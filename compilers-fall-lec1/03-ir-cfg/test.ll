; ModuleID = './test.cpp'
source_filename = "./test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local noundef i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 1, ptr %2, align 4
  store i32 2, ptr %3, align 4
  store i32 10, ptr %4, align 4
  %5 = load i32, ptr %2, align 4
  %6 = icmp sgt i32 %5, 3
  br i1 %6, label %15, label %7

7:                                                ; preds = %0
  %8 = load i32, ptr %3, align 4
  %9 = icmp slt i32 %8, 2
  br i1 %9, label %10, label %17

10:                                               ; preds = %7
  %11 = load i32, ptr %4, align 4
  %12 = load i32, ptr %2, align 4
  %13 = add nsw i32 %11, %12
  %14 = icmp eq i32 %13, 4
  br i1 %14, label %15, label %17

15:                                               ; preds = %10, %0
  %16 = load i32, ptr %3, align 4
  store i32 %16, ptr %4, align 4
  br label %19

17:                                               ; preds = %10, %7
  %18 = load i32, ptr %2, align 4
  store i32 %18, ptr %4, align 4
  br label %19

19:                                               ; preds = %17, %15
  %20 = load i32, ptr %4, align 4
  ret i32 %20
}

attributes #0 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 22.0.0git (https://github.com/llvm/llvm-project.git 28c2c1e06e2dc73df03cfc2d797fa70365d481f2)"}
