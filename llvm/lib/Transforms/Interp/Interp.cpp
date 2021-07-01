#include <llvm/CodeGen/Passes.h>
#include <llvm/Transforms/InstCombine/InstCombine.h>
#include <numeric>
#include <vector>

#include "interpolation.h"
#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/IR/Argument.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"

using namespace llvm;

namespace {
struct Interp : public ModulePass {
private:
  std::vector<const GlobalVariable *> GlobalArrays;
  std::map<llvm::StringRef, Function *> VarToInterpolator;

  void extractConstNumericArrays(const Module::GlobalListType &globals) {
    for (auto &Global : globals) {
      errs() << Global << " of type " << *Global.getType() << ' ';
      PointerType *PTy = cast<PointerType>(Global.getType());
      if (PTy->getElementType()->isArrayTy() &&
          PTy->getElementType()->getArrayElementType()->isIntegerTy() &&
          !Global.getInitializer()->isZeroValue() && /* Not initialized */
          !Global.hasGlobalUnnamedAddr() /* Probably a string literal */) {
        errs() << " is a numeric array literal." << '\n';
        GlobalArrays.push_back(&Global);
      } else {
        errs() << " is NOT a numeric array literal." << '\n';
      }
    }
  }

  // template <typename T>
  std::pair<std::vector<double>, alglib::polynomialfitreport>
  getInterpolationOf(std::vector<double> ArrayValues) {
    using namespace alglib;

    // Initialize domain of function
    std::vector<double> XVec(ArrayValues.size());
    std::iota(std::begin(XVec), std::end(XVec), 0);

    // Interpolate over all values provided with
    ae_int_t NumPoints = ArrayValues.size();
    real_1d_array X;
    X.setcontent(NumPoints, XVec.data());
    real_1d_array Y;
    Y.setcontent(NumPoints, ArrayValues.data());
    ae_int_t PolynomialDegree = 5;
    ae_int_t Info;
    barycentricinterpolant P;
    polynomialfitreport Rep;
    std::vector<double> PolynomialCoefficientVec;
    try {
      // Try to fit polynomial
      polynomialfit(X, Y, NumPoints, PolynomialDegree, Info, P, Rep);

      // Convert to barycentric to more usable, polynomial form
      double Offset = 0.0;
      double Scale = 1.0;
      real_1d_array PolynomialCoefficients;
      polynomialbar2pow(P, Offset, Scale, PolynomialCoefficients);
      for (int i = 0; i < PolynomialDegree + 1; i++)
        PolynomialCoefficientVec.push_back(PolynomialCoefficients[i]);
    } catch (alglib::ap_error &e) {
      errs() << "Polynomial fit failed: " << e.msg << '\n';
    }
    return {PolynomialCoefficientVec, Rep};
  }

  void
  insertFunctionFromCoefficients(Module &M,
                                 std::vector<double> PolynomialCoefficients,
                                 llvm::StringRef GlobalName) {
    // Make the function type:  int(int)
    auto &Ctx = M.getContext();
    IRBuilder<> builder(Ctx);
    const auto LLVMint64T = Type::getInt64Ty(Ctx);
    const auto LLVMint32T = Type::getInt32Ty(Ctx);
    FunctionType *FT = FunctionType::get(LLVMint32T, {LLVMint64T}, false);
    const llvm::Twine InterpolatorName = GlobalName + "_interpolator";
    Function *F =
        Function::Create(FT, Function::ExternalLinkage, InterpolatorName, M);
    VarToInterpolator[GlobalName] = F;
    // Set names for all arguments.
    for (auto &Arg : F->args())
      Arg.setName("index");

    // Create a new basic block to start insertion into.
    BasicBlock *BB = BasicBlock::Create(Ctx, "entry", F);
    builder.SetInsertPoint(BB);

    // Generate code to compute value at index.
    // Given a vector of polynomialCoefficients = {c0, c1, c2, c3, c4, c5} and a
    // vector of values xs = {1, x, x^2, x^3, x^4, x^5}, take dot product into
    // ds = {d0, d1, d2, d3, d4, d5}, and perform sum (d0...d5).
    std::vector<llvm::Value *> xs = {ConstantInt::get(LLVMint32T, 1)};
    Argument *x = F->getArg(0); // Only argument of function is the index
    auto *x32 = builder.CreateTrunc(x, LLVMint32T);
    for (size_t I = 1; I < 6; I++)
      xs.push_back(builder.CreateMul(xs.back(), x32, "x" + std::to_string(I)));
    std::vector<llvm::Value *> Ds;
    for (size_t I = 0; I < 6; I++) {
      auto c_i =
          ConstantInt::get(LLVMint32T, (int)(PolynomialCoefficients[I] + 0.5));
      auto x_i = xs[I];
      Ds.push_back(builder.CreateMul(c_i, x_i, "d" + std::to_string(I)));
    }
    std::vector<llvm::Value *> Sums = {Ds[0]};
    for (size_t i = 1; i < 6; i++)
      Sums.push_back(
          builder.CreateAdd(Sums.back(), Ds[i], "sum" + std::to_string(i)));
    builder.CreateRet(Sums.back());
  }

  template <typename T> void printVec(std::vector<T> vec) {
    errs() << "[ ";
    for (auto e : vec)
      errs() << e << " ";
    errs() << "]\n";
  }

  void insertInterpolationFunctions(Module &M) {
    for (const auto *array : GlobalArrays) {
      auto arraySize =
          array->getType()->getElementType()->getArrayNumElements();
      std::vector<double> arrayValues;
      for (size_t i = 0; i < arraySize; i++) {
        auto intVal = dyn_cast<ConstantInt>(
                          array->getInitializer()->getAggregateElement(i))
                          ->getZExtValue();
        arrayValues.push_back(intVal);
      }
      printVec(arrayValues);
      auto [polynomialCoefficients, fitreport] =
          getInterpolationOf(arrayValues);
      printVec(polynomialCoefficients);
      insertFunctionFromCoefficients(M, polynomialCoefficients,
                                     array->getName());
    }
  }

  void replaceArrayAccesses(Module &M) {
    std::vector<Instruction *> InsToDelete;
    for (auto &f : M.getFunctionList()) {
      for (auto &bb : f.getBasicBlockList()) {
        for (auto &ins : bb) {
          if (ins.getOpcode() == Instruction::GetElementPtr
              && ins.getNumOperands() == 3) {
            auto *array = dyn_cast<GlobalVariable>(ins.getOperand(0));
            if (VarToInterpolator.find(array->getName()) == VarToInterpolator.end()) {
              // We haven't interpolated this array. Carry on.
              continue;
            }
            auto *gepIndex1 = dyn_cast<ConstantInt>(ins.getOperand(1));
            auto *gepIndex2 = ins.getOperand(2);
            auto &Ctx = M.getContext();
            const auto LLVMint64T = Type::getInt64Ty(Ctx);
            const auto LLVMint32T = Type::getInt32Ty(Ctx);
            FunctionType *FT =
                FunctionType::get(LLVMint32T, {LLVMint64T}, false);
            auto *interpolatedValue = CallInst::Create(
                FT, VarToInterpolator[array->getName()], {gepIndex2}, "", &ins);
            // Replace all Load uses of this GEP with our newly created
            // function call result.
            bool ShouldEraseGep = true;
            for (User *U : ins.users()) {
              errs() << "use ";
              if (auto *load = dyn_cast<LoadInst>(U)) {
                for (auto &loadUse : load->uses()) {
                  loadUse.getUser()->setOperand(loadUse.getOperandNo(),
                                                interpolatedValue);
                }
                load->eraseFromParent();
              } else {
                ShouldEraseGep = false;
              }
              errs() << '\n';
            }
            for (unsigned i = 0; i < ins.getNumOperands(); ++i) {
              errs() << i << "= ";
              ins.getOperand(i)->print(errs());
              errs() << '\n';
            }
            errs() << '\t';
            ins.print(errs());
            errs() << '\n';
            if (ShouldEraseGep) {
              InsToDelete.push_back(&ins);
            }
          }
        }
      }
    }
    for (auto* ins : InsToDelete) {
      ins->eraseFromParent();
    }
  }

public:
  static char ID;
  Interp() : ModulePass(ID) {}

  bool runOnModule(Module &M) override {
    // Extract all global constant numeric arrays
    extractConstNumericArrays(M.getGlobalList());

    // Perform polynomial interpolation and create a function
    // for each global constant array
    insertInterpolationFunctions(M);

    // Replace references to the array with accesses into the function
    replaceArrayAccesses(M);

    return true;
  }

  void getAnalysisUsage(AnalysisUsage &Info) const override {
    ModulePass::getAnalysisUsage(Info);
  }
}; // end of struct Interp
} // end of anonymous namespace

char Interp::ID = 0;
static RegisterPass<Interp> X("Interp", "Polynomial Interpolation Pass",
                              false /* Only looks at CFG */,
                              false /* Analysis Pass */);

static RegisterStandardPasses Y(PassManagerBuilder::EP_EarlyAsPossible,
                                [](const PassManagerBuilder &Builder,
                                   legacy::PassManagerBase &PM) {
                                  PM.add(new Interp());
                                });
