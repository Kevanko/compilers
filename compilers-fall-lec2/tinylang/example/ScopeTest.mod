MODULE ScopeTest;
VAR x : INTEGER;

PROCEDURE Inner();
VAR x : INTEGER;
BEGIN
    x := 20; (* локальная *)
END Inner;

BEGIN
    x := 10; (* глобальная *)
    Inner();
    x := x + 1; (* должно работать с глобальной *)
END ScopeTest.