MODULE WhileIntCondition;
VAR
    i : INTEGER;
BEGIN
    i := 5;
    WHILE i DO (* Ожидаем ошибку: условие должно быть BOOLEAN *)
        i := i - 1;
    END;
END WhileIntCondition.