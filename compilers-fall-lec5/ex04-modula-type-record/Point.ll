; ModuleID = './Point.mod'
source_filename = "./Point.mod"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%Cursor = type { i1, i64, i64 }

@_t5RecEx1c = private global %Cursor

define void @_t5RecEx9SetCenter() {
entry:
  store i1 true, ptr @_t5RecEx1c, align 1
  store i64 100, ptr getelementptr inbounds (%Cursor, ptr @_t5RecEx1c, i32 0, i32 1), align 8
  store i64 100, ptr getelementptr inbounds (%Cursor, ptr @_t5RecEx1c, i32 0, i32 2), align 8
  ret void
}
