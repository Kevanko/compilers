; ModuleID = 'bool_test.mod'
source_filename = "bool_test.mod"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@_t10TestModule1X = private global i64
@_t10TestModule1F = private global i1

define void @_t10TestModule6Toggle(ptr dereferenceable(1) %B) {
entry:
  %0 = load i1, ptr %B, align 1
  br i1 %0, label %if.body, label %else.body

if.body:                                          ; preds = %entry
  store i1 false, ptr %B, align 1
  br label %after.if

else.body:                                        ; preds = %entry
  store i1 true, ptr %B, align 1
  br label %after.if

after.if:                                         ; preds = %else.body, %if.body
  ret void
}

define void @_t10TestModule9CountDown(ptr dereferenceable(8) %N) {
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %0 = phi i64 [ %5, %while.body ], [ 0, %entry ]
  %1 = load i64, ptr %N, align 8
  %2 = icmp slt i64 %0, %1
  br i1 %2, label %while.body, label %after.while

while.body:                                       ; preds = %while.cond
  %3 = load i64, ptr %N, align 8
  %4 = sub nsw i64 %3, 1
  store i64 %4, ptr %N, align 8
  %5 = add nsw i64 %0, 1
  br label %while.cond

after.while:                                      ; preds = %while.cond
  ret void
}
