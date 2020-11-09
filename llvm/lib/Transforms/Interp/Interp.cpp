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
    std::vector<const GlobalVariable*> globalArrays;
    std::map<llvm::StringRef, Function*> varToInterpolator;

    void extractConstNumericArrays(const Module::GlobalListType& globals)
    {
        for (auto& global : globals) {
            errs() << global << " of type " << *global.getType() << ' ';
            PointerType* PTy = cast<PointerType>(global.getType());
            if (PTy->getElementType()->isArrayTy() && PTy->getElementType()->getArrayElementType()->isIntegerTy()) {
                errs() << " is an array." << '\n';
                globalArrays.push_back(&global);
            } else {
                errs() << " is NOT array." << '\n';
            }
        }
    }

    // template <typename T>
    std::pair<std::vector<double>, alglib::polynomialfitreport>
    getInterpolationOf(std::vector<double> arrayValues)
    {
        using namespace alglib;

        // Initialize domain of function
        std::vector<double> xVec(arrayValues.size());
        std::iota(std::begin(xVec), std::end(xVec), 0);

        // Interpolate over all values provided with
        ae_int_t numPoints = arrayValues.size();
        real_1d_array x;
        x.setcontent(numPoints, xVec.data());
        real_1d_array y;
        y.setcontent(numPoints, arrayValues.data());
        ae_int_t polynomialDegree = 5;
        ae_int_t info;
        barycentricinterpolant p;
        polynomialfitreport rep;
        std::vector<double> polynomialCoefficientVec;
        try {
            // Try to fit polynomial
            polynomialfit(x, y, numPoints, polynomialDegree, info, p, rep);

            // Convert to barycentric to more usable, polynomial form
            double offset = 0.0;
            double scale = 1.0;
            real_1d_array polynomialCoefficients;
            polynomialbar2pow(p, offset, scale, polynomialCoefficients);
            for (int i = 0; i < polynomialDegree + 1; i++)
                polynomialCoefficientVec.push_back(polynomialCoefficients[i]);
        } catch (alglib::ap_error e) {
            errs() << "Polynomial fit failed: " << e.msg << '\n';
        }
        return { polynomialCoefficientVec, rep };
    }

    void insertFunctionFromCoefficients(
        Module& M,
        std::vector<double> polynomialCoefficients,
        llvm::StringRef globalName)
    {
        // Make the function type:  int(int)
        auto& ctx = M.getContext();
        IRBuilder<> builder(ctx);
        const auto llvmint32_t = Type::getInt32Ty(ctx);
        FunctionType* FT = FunctionType::get(llvmint32_t, { llvmint32_t }, false);
        const llvm::Twine interpolatorName = globalName + "_interpolator";
        Function* F = Function::Create(FT, Function::ExternalLinkage, interpolatorName, M);
        varToInterpolator[globalName] = F;
        // Set names for all arguments.
        for (auto& Arg : F->args())
            Arg.setName("index");

        // Create a new basic block to start insertion into.
        BasicBlock* BB = BasicBlock::Create(ctx, "entry", F);
        builder.SetInsertPoint(BB);

        // Generate code to compute value at index.
        // Given a vector of polynomialCoefficients = {c0, c1, c2, c3, c4, c5} and a
        // vector of values xs = {1, x, x^2, x^3, x^4, x^5}, take dot product into
        // ds = {d0, d1, d2, d3, d4, d5}, and perform sum (d0...d5).
        std::vector<llvm::Value*> xs = { ConstantInt::get(llvmint32_t, 1) };
        Argument* x = F->getArg(0); // Only argument of function is the index
        for (size_t i = 1; i < 6; i++)
            xs.push_back(builder.CreateMul(xs.back(), x, "x" + std::to_string(i)));
        std::vector<llvm::Value*> ds;
        for (size_t i = 0; i < 6; i++) {
            auto c_i = ConstantInt::get(llvmint32_t, (int)(polynomialCoefficients[i] + 0.5));
            auto x_i = xs[i];
            ds.push_back(builder.CreateMul(c_i, x_i, "d" + std::to_string(i)));
        }
        std::vector<llvm::Value*> sums = { ds[0] };
        for (size_t i = 1; i < 6; i++)
            sums.push_back(
                builder.CreateAdd(sums.back(), ds[i], "sum" + std::to_string(i)));
        builder.CreateRet(sums.back());
    }

    template <typename T>
    void printVec(std::vector<T> vec)
    {
        errs() << "[ ";
        for (auto e : vec)
            errs() << e << " ";
        errs() << "]\n";
    }

    void insertInterpolationFunctions(Module& M)
    {
        for (auto array : globalArrays) {
            auto arraySize = array->getType()->getElementType()->getArrayNumElements();
            std::vector<double> arrayValues;
            for (size_t i = 0; i < arraySize; i++) {
                auto intVal = dyn_cast<ConstantInt>(array->getInitializer()->getAggregateElement(i))
                                  ->getZExtValue();
                arrayValues.push_back(intVal);
            }
            printVec(arrayValues);
            auto [polynomialCoefficients, fitreport] = getInterpolationOf(arrayValues);
            printVec(polynomialCoefficients);
            insertFunctionFromCoefficients(
                M, polynomialCoefficients, array->getName());
        }
    }

public:
    static char ID;
    Interp()
        : ModulePass(ID)
    {
    }

    bool runOnModule(Module& M) override
    {
        // Extract all global constant numeric arrays
        extractConstNumericArrays(M.getGlobalList());

        // Perform polynomial interpolation and create a function
        // for each global constant array
        insertInterpolationFunctions(M);

        // Replace references to the array with accesses into the function

        return false;
    }
}; // end of struct Interp
} // end of anonymous namespace

char Interp::ID = 0;
static RegisterPass<Interp> X("Interp",
    "Polynomial Interpolation Pass",
    false /* Only looks at CFG */,
    false /* Analysis Pass */);

static RegisterStandardPasses Y(PassManagerBuilder::EP_EarlyAsPossible,
    [](const PassManagerBuilder& Builder,
        legacy::PassManagerBase& PM) {
        PM.add(new Interp());
    });
