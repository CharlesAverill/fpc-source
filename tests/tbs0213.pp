uses
  tbs0213a;

PROCEDURE Testsomething(VAR A:LONGINT);

FUNCTION Internaltest(L:LONGINT):LONGINT;

BEGIN
 InternalTest:=L+10;
END;

BEGIN
 A:=Internaltest(20)+5;
END;

PROCEDURE Testsomething(VAR A:WORD);

FUNCTION Internaltest(L:LONGINT):WORD;

BEGIN
 InternalTest:=L+15;
END;

BEGIN
 A:=Internaltest(20)+5;
END;

VAR O  : LONGINT;
    O2 : WORD;

BEGIN
 TestSomething(O);
 TestSomething(O2);
END.

