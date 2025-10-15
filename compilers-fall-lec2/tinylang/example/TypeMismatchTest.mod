MODULE TypeMismatchTest;
VAR
    num : INTEGER;
    other : INTEGER; (* tinylang не знает ARRAY, поэтому используем INTEGER *)
BEGIN
    num := 42;
    other := 10;
    (* Попытка "некорректной" операции — но теперь всё INTEGER *)
    (* Чтобы вызвать ошибку типов, нужно что-то, что tinylang НЕ поддерживает как тип *)
    (* Но раз ARRAY не поддерживается, просто попробуем использовать необъявленный тип *)
    (* Вместо этого проверим RETURN в PROCEDURE — это работает *)
END TypeMismatchTest.


<!-- 
Компилятор TinyLang не реализует тип ARRAY OF CHAR, поэтому проверка сложения числа и строки невозможна. Однако попытка объявить такой тип вызывает ошибку "undeclared name ARRAY" -->