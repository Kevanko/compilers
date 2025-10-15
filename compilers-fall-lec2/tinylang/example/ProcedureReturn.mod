MODULE ProcedureReturn;
PROCEDURE MyProc();
BEGIN
    RETURN 10; (* Ошибка: RETURN с выражением в PROCEDURE *)
END MyProc;
BEGIN
    MyProc();
END ProcedureReturn.