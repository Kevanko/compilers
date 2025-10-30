MODULE TestModule;

VAR X : INTEGER;
VAR F : BOOLEAN;

PROCEDURE Toggle(VAR B : BOOLEAN);
BEGIN
    IF B THEN
        B := FALSE
    ELSE
        B := TRUE
    END
END Toggle;

PROCEDURE CountDown(VAR N : INTEGER);
VAR I : INTEGER;
BEGIN
    I := 0;
    WHILE I < N DO
        N := N - 1;
        I := I + 1
    END
END CountDown;

END TestModule.
