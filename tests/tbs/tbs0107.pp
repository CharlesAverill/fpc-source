{ PAGE FAULT PROBLEM ... TEST UNDER DOS ONLY! Not windows... }
{ -Cr -g flags                                               }

Program Test1;

{$ifdef go32v2}
uses
   dpmiexcp;
{$endif}

type
 myObject = object
   constructor init;
   procedure v;virtual;
 end;

 constructor myobject.init;
 Begin
 end;

 procedure myobject.v;
 Begin
  WriteLn('Hello....');
 end;

var
 my: myobject;
Begin
 my.init;
 my.v;
end.
