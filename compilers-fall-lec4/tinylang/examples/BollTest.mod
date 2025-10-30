MODULE BoolTest;
VAR
  x: BOOLEAN;
BEGIN
  x := TRUE;
  IF x THEN
    x := FALSE;
  END;
END BoolTest.
