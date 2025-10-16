@.str = private constant [18 x i8] c"gcd(12, 15) = %d\0A\00"

declare i32 @printf(i8*, ...)

define i32 @gcd(i32 %a, i32 %b) {
entry:
  br label %loop

loop:
  %a1 = phi i32 [ %a, %entry ], [ %b1, %loop_body ]
  %b1 = phi i32 [ %b, %entry ], [ %t, %loop_body ]
  %cond = icmp ne i32 %b1, 0
  br i1 %cond, label %loop_body, label %exit

loop_body:
  %t = srem i32 %a1, %b1
  br label %loop

exit:
  ret i32 %a1
}

define i32 @main() {
entry:
  %res = call i32 @gcd(i32 12, i32 15)
  %fmt = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i32 0, i32 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %res)
  ret i32 0
}