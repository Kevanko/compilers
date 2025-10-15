MODULE BooleanLiterals;
VAR b : BOOLEAN;
BEGIN
    b := TRUE;
    b := FALSE;
    IF b THEN
        b := TRUE;
    END;
END BooleanLiterals.