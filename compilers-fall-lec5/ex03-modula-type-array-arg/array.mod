MODULE ExampleMod;

TYPE MyArray = ARRAY [10] OF INTEGER;

PROCEDURE Main(p: MyArray);
BEGIN
  p[0] := 2;
END Main;

END ExampleMod.
