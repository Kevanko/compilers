@.str = private constant [18 x i8] c"gcd(12, 15) = %d\0A\00"

declare i32 @printf(i8*, ...)

define i32 @gcd(i32 %a, i32 %b) {
entry:
  %a_ptr = alloca i32
  %b_ptr = alloca i32
  store i32 %a, i32* %a_ptr
  store i32 %b, i32* %b_ptr
  br label %loop

loop:
  %a1 = load i32, i32* %a_ptr
  %b1 = load i32, i32* %b_ptr
  %cond = icmp ne i32 %b1, 0
  br i1 %cond, label %loop_body, label %exit

loop_body:
  %t = srem i32 %a1, %b1
  store i32 %b1, i32* %a_ptr
  store i32 %t, i32* %b_ptr
  br label %loop

exit:
  %result = load i32, i32* %a_ptr
  ret i32 %result
}

define i32 @main() {
entry:
  %res = call i32 @gcd(i32 12, i32 15)
  %fmt = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i32 0, i32 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %res)
  ret i32 0
}