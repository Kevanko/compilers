; ModuleID = 'sum.mod'
source_filename = "sum.mod"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i64 @_t7example3Sum(i64 %a, i64 %b) {
entry:
  %0 = add nsw i64 %a, %b
  ret i64 %0
}
