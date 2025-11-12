MODULE RecEx;

TYPE Cursor = RECORD
  visible: BOOLEAN;
  x, y: INTEGER;
END;

VAR c: Cursor;

PROCEDURE SetCenter();
BEGIN
  c.visible := TRUE;
  c.x := 100;
  c.y := 100;
END SetCenter;

END RecEx.
