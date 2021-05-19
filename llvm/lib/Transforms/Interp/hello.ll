; ModuleID = 'hello.c'
source_filename = "hello.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx11.0.0"

@values = local_unnamed_addr constant [6 x i32] [i32 0, i32 1, i32 8, i32 27, i32 64, i32 125], align 16
@array2 = local_unnamed_addr constant [5 x i32] [i32 27, i32 64, i32 125, i32 216, i32 343], align 16
@const_float = local_unnamed_addr global float 0x40091EB860000000, align 4
; Function Attrs: norecurse nounwind readnone ssp uwtable
define i32 @foo(i32 %0) local_unnamed_addr #0 {
  %2 = zext i32 %0 to i64
  %3 = getelementptr inbounds [6 x i32], [6 x i32]* @values, i64 0, i64 %2
  %4 = load i32, i32* %3, align 4, !tbaa !4
  %5 = add i32 %0, -1
  %6 = zext i32 %5 to i64
  %7 = getelementptr inbounds [6 x i32], [6 x i32]* @values, i64 0, i64 %6
  %8 = load i32, i32* %7, align 4, !tbaa !4
  %9 = mul nsw i32 %8, %4
  ret i32 %9
}
; Function Attrs: norecurse nounwind readnone ssp uwtable
define i32 @main(i32 %0, i8** nocapture readnone %1) local_unnamed_addr #0 {
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds [6 x i32], [6 x i32]* @values, i64 0, i64 %3
  %5 = load i32, i32* %4, align 4, !tbaa !4
  %6 = add i32 %0, -1
  %7 = zext i32 %6 to i64
  %8 = getelementptr inbounds [6 x i32], [6 x i32]* @values, i64 0, i64 %7
  %9 = load i32, i32* %8, align 4, !tbaa !4
  %10 = mul nsw i32 %9, %5
  ret i32 %10
}

attributes #0 = { norecurse nounwind readnone ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "darwin-stkchk-strong-link" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 11, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"Apple clang version 12.0.0 (clang-1200.0.32.29)"}
!4 = !{!5, !5, i64 0}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
