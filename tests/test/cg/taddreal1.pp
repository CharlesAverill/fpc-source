{****************************************************************}
{  CODE GENERATOR TEST PROGRAM                                   }
{****************************************************************}
{ NODE TESTED : secondadd() FPU real type code with Emulator     }
{****************************************************************}
{ PRE-REQUISITES: secondload()                                   }
{                 secondassign()                                 }
{                 secondtypeconv()                               }
{****************************************************************}
{ DEFINES:                                                       }
{            FPC     = Target is FreePascal compiler             }
{****************************************************************}
{ REMARKS:                                                       }
{                                                                }
{                                                                }
{                                                                }
{****************************************************************}

{ Result is either LOC_FPU or LOC_REFERENCE                     }
{ LEFT NODE (operand) (left operator)                           }
{  LOC_REFERENCE / LOC_MEM                                      }
{  LOC_FPU                                                      }
{ RIGHT NODE (operand)                                          }
{  LOC_FPU                                                      }
{  LOC_REFERENCE / LOC_MEM                                      }

{ Only m68k needs FPU emulation }
{$ifdef m68k}
  {$define NEEDFPUEMU}
{$endif m68k}

{$ifdef NEEDFPUEMU}
{$E+}
{$endif NEEDFPUEMU}

procedure fail;
begin
  WriteLn('Failed!');
  halt(1);
end;


 Procedure RealTestSub;
 var
  i : Real;
  j : Real;
  result : boolean;
 Begin
  Write('Real - Real test...');
  result := true;
  i:=99.9;
  j:=10.0;
  i:=i-j;
  if trunc(i) <> trunc(89.9) then
    result := false;
  WriteLn('Result (89.9) :',i);
  i:=j-i;
  if trunc(i) <> trunc(-79.9) then
    result := false;
  WriteLn('Result (-79.9) :',i);
  j:=j-10.0;
  if j <> 0.0 then
    result := false;
  WriteLn('Result (0.0) :',j);
  if not result then
    Fail
  else
    WriteLn('Success.');
 end;

 procedure RealTestAdd;
 var
  i : real;
  j : real;
  result : boolean;
 Begin
   WriteLn('Real + Real test...');
   result := true;
   i:= 9;
   i:=i+1.5;
   if trunc(i) <> trunc(10.5) then
     result := false;
   WriteLn('Result (10.5) :',i);
   i := 0.0;
   j := 100.0;
   i := i + j + j + 12.5;
   if trunc(i) <> trunc(212.5) then
     result := false;
   WriteLn('Result (212.5) :',i);
   if not result then
    Fail
   else
    WriteLn('Success.');
 end;


 procedure realtestmul;
 var
  i : real;
  j : real;
  result : boolean;
 begin
  WriteLn('Real * Real test...');
  result := true;
  i:= 0;
  j:= 0;
  i := i * j * i;
  if trunc(i) <> trunc(0.0) then
    result := false;
  WriteLn('Result (0.0) :',i);
  i := 10.0;
  j := -12.0;
  i := i * j * 10.0;
  if trunc(i) <> trunc(-1200.0) then
    result := false;
  WriteLn('Result (-1200.0) :',i);
  if not result then
    Fail
  else
    WriteLn('Success.');
 end;



 Procedure RealTestDiv;
 var
  i : Real;
  j : Real;
  result : boolean;
 Begin
  result := true;
  WriteLn('Real / Real test...');
  i:=-99.9;
  j:=10.0;
  i:=i / j;
  if trunc(i) <> trunc(-9.9) then
    result := false;
  WriteLn('Result (-9.9) :',i);
  i:=j / i;
  if trunc(i) <> trunc(-1.01) then
    result := false;
  WriteLN('Result (-1.01) :',i);
  j:=i / 10.0;
  if trunc(j) <> trunc(-0.1001) then
    result := false;
  WriteLn('Result (-0.1001) :',j);
  if not result then
    Fail
  else
    WriteLn('Success.');
 end;



{ Procedure RealTestComplex;
 var
  i : real;
 Begin
   Write('RESULT SHOULD BE 2.09 :');
   i := 4.4;
   WriteLn(Sqrt(i));
   Write('RESULT SHOULD BE PI :');
   WriteLn(Pi);
   Write('RESULT SHOULD BE 4.0 :');
   WriteLn(Round(3.6));
 end;}


 procedure realtestequal;
 var
  i : real;
  j : real;
  result : boolean;
 begin
  result := true;
  Write('Real = Real test...');
  i := 1000.0;
  j := 1000.0;
  if not (i=j) then
    result := false;
  if not (i=1000.0) then
    result := false;
  if not (trunc(i) = trunc(j)) then
    result := false;
  if not (trunc(i) = trunc(1000.0)) then
    result := false;
  if not result then
    Fail
  else
    WriteLn('Success.');
 end;

 procedure realtestnotequal;
 var
  i : real;
  j : real;
  result : boolean;
 begin
  result := true;
  Write('Real <> Real test...');
  i := 1000.0;
  j := 1000.0;
  if (i <> j) then
    result := false;
  if (i <> 1000.0) then
  if (trunc(i) <> trunc(j)) then
    result := false;
  if (trunc(i) <> trunc(1000.0)) then
    result := false;
  if not result then
    Fail
  else
    WriteLn('Success.');
 end;


 procedure realtestle;
 var
  i : real;
  j : real;
  result : boolean;
 begin
  result := true;
  Write('Real <= Real test...');
  i := 1000.0;
  j := 1000.0;
  if not (i <= j) then
    result := false;
  if not (i <= 1000.0) then
    result := false;
  if not (trunc(i) <= trunc(j)) then
    result := false;
  if not (trunc(i) <= trunc(1000.0)) then
    result := false;
  i := 10000.0;
  j := 999.0;
  if trunc(i) < trunc(j) then
    result := false;
  if trunc(i) < trunc(999.0) then
    result := false;
  if not result then
    Fail
  else
    WriteLn('Success.');
 end;

 procedure realtestge;
 var
  i : real;
  j : real;
  result : boolean;
 begin
  result := true;
  Write('Real >= Real test...');
  i := 1000.0;
  j := 1000.0;
  if not (i >= j) then
    result := false;
  if not (i >= 1000.0) then
    result := false;
  if not (trunc(i) >= trunc(j)) then
    result := false;
  if not (trunc(i) >= trunc(1000.0)) then
    result := false;
  i := 999.0;
  j := 1000.0;
  if i > j then
    result := false;
  if i > 999.0 then
    result := false;
  if trunc(i) > trunc(j) then
    result := false;
  if trunc(i) > trunc(999.0) then
    result := false;
  if not result then
    Fail
  else
    WriteLn('Success.');
 end;


Begin
 RealTestEqual;
 RealTestNotEqual;
 RealTestLE;
 RealTestGE;
 RealTestSub;
 RealTestAdd;
 RealTestDiv;
 RealTestMul;
{ RealTestComplex;}
end.


{
  $Log$
  Revision 1.5  2004-03-13 11:07:50  florian
    * improved test, previously it mainly tested integer comparisations

  Revision 1.4  2003/04/26 16:44:10  florian
    * released the code for all cpus, at least with i386, it works fine

  Revision 1.3  2002/12/06 15:49:36  peter
    * FPU emu is only needed for m68k

  Revision 1.2  2002/09/07 15:40:49  peter
    * old logs removed and tabs fixed

  Revision 1.1  2002/08/25 19:26:23  peter
    * splitted in $E+ file and without emulator

  Revision 1.5  2002/04/13 21:02:38  carl
  * fixed typos

  Revision 1.4  2002/03/05 21:55:11  carl
  * Adapted for automated testing

}
