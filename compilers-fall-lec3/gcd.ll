@.str = private constant [18 x i8] c"gcd(12, 15) = %d\0A\00"

declare i32 @printf(i8*, ...)

define i32 @gcd(i32 %a_init, i32 %b_init) {
entry:
  br label %loop

; loop: while (b != 0) { t = a % b; a = b; b = t; }
loop:
  ; phi — берёт начальные значения из entry, а в последующих итерациях — из блока body
  %a = phi i32 [ %a_init, %entry ], [ %a_next, %body ]
  %b = phi i32 [ %b_init, %entry ], [ %b_next, %body ]

  ; условие выхода: b == 0 ?
  %is_zero = icmp eq i32 %b, 0
  br i1 %is_zero, label %end, label %body

body:
  ; остаток: t = a % b
  %t = srem i32 %a, %b

  ; в SSA нельзя "присвоить" напрямую, поэтому создаём новые SSA-значения
  ; (инструкция add i32 %b, 0 — просто копирует значение в новое имя)
  %a_next = add i32 %b, 0
  %b_next = add i32 %t, 0

  br label %loop

end:
  ret i32 %a
}

define i32 @main() {
entry:
  %res = call i32 @gcd(i32 12, i32 15)
  %fmt = getelementptr inbounds [18 x i8], ptr @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %res)
  ret i32 0
}
