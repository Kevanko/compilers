; ModuleID = 'proc.mod'
source_filename = "proc.mod"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @_t7example9EmptyProc() {
entry:
  ret void
}

define i64 @_t7example9EmptyFunc() {
entry:
  ret i64 1
}
