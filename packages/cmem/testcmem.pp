program testmem;

{$mode objfpc}

uses cmem;

Type 
  PLongint = ^Longint;

Var P : PLongint;
    i : longint;
     
begin
  P:=GetMem(1000*SizeOf(Longint));
  For I:=0 to 999 do
    P[i]:=i;
  P:=ReallocMem(P,500*SizeOf(Longint));
  For I:=0 to 499 do  
    if P[i]<>i Then
      Writeln ('Oh-oh, ',i,'th index differs.');
  FreeMem(P);    
end.  $Log$
end.  Revision 1.2  2000-07-13 11:33:11  michael
end.  + removed logs
end. 
}
