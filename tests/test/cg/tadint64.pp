{ Program to test Code generator secondadd()                 }
{ with int64 values                                        }
{ FUNCTIONAL PRE-REQUISITES:                                 }
{   - assignments function correctly.                        }
{   - if statements function correctly.                      }
{   - subroutine calls function correctly.                   }



procedure int64TestAdd;
var
 i: int64;
 j: int64;
 result : boolean;
begin
 Write('int64 + int64 test...');
 result := true;
 i:=0;
 j:=0;
 i := i + -10000;
 if i <> -10000 then
  result := false;
 j := 32767;
 i := i + j;
 if i <> 22767 then
  result := false;
 i := i + j + 50000;
 if i <> 105534 then
  result := false;
 i:=0;
 j:=10000;
 i:= i + j + j + i + j;
 if i <> 30000 then
  result := false;
 if not result then
  WriteLn('Failure.')
 else
  WriteLn('Success.');
end;


procedure int64TestSub;
var
 i, j, k : int64;
 result : boolean;
begin
 Write('int64 - int64 test...');
 result := true;
 i:=100000;
 j:=54;
 k:=56;
 i:= i - 100;
 if i <> 99900 then
  result := false;
 i := i - j - k - 100;
 if i <> 99690 then
  result := false;
 i:=100;
 j:=1000;
 k:=100;
 i:= j - i - k;
 if i <> 800 then
  result := false;
 if not result then
  WriteLn('Failure.')
 else
  WriteLn('Success.');
end;


procedure int64TestMul;
var
 i : int64;
 j : int64;
 k: int64;
 result: boolean;
begin
 Write('int64 * int64 test...');
 result := true;
 i:=0;
 j:=0;
 i:=i * 32;
 if i <> 0 then
   result := false;
 i:=10;
 i:=i * -16;
 if i <> -160 then
    result := false;
 j:=10000;
 i:=-10000;
 i:=i * j;
 if i <> -100000000 then
    result := false;
 i:=1;
 j:=10;
 k:=16;
 i := i * j * k;
 if i <> 160 then
    result := false;
 i := 1;
 j := 10;
 k := 16;
 i := i * 10 * j * i * j * 16 * k;
 if i <> 256000 then
    result := false;
 if not result then
  WriteLn('Failure.')
 else
  WriteLn('Success.');
end;

procedure int64TestXor;
var
 i, j : int64;
 result : boolean;
begin
 Write('int64 XOR int64 test...');
 result := true;
 i := 0;
 j := 0;
 i := i xor $1000001;
 if i <> $1000001 then
   result := false;
 i:=0;
 j:=$10000001;
 i:=i xor j;
 if i <> $10000001 then
   result := false;

 i := 0;
 j := $55555555;
 i := i xor j xor $AAAAAAAA;
 if i <> $FFFFFFFF then
   result := false;
 if not result then
  WriteLn('Failure.')
 else
  WriteLn('Success.');
end;


procedure int64TestOr;
var
 i,j : int64;
 result : boolean;
Begin
 Write('int64 OR int64 test...');
 result := true;
 i := 0;
 j := 0;
 i := i or $1000001;
 if i <> $1000001 then
   result := false;
 i:=0;
 j:=$10000001;
 i:=i or j;
 if i <> $10000001 then
   result := false;

 i := 0;
 j := $55555555;
 i := i or j or $AAAAAAAA;
 if i <> $FFFFFFFF then
   result := false;
 if not result then
  WriteLn('Failure.')
 else
  WriteLn('Success.');
end;



procedure int64TestAnd;
var
 i,j : int64;
 result : boolean;
Begin
 Write('int64 AND int64 test...');
 result := true;
 i := $1000001;
 j := 0;
 i := i and $1000001;
 if i <> $1000001 then
   result := false;
 i:=0;
 j:=$10000001;
 i:=i and j;
 if i <> 0 then
   result := false;

 i := $FFFFFFFF;
 j := $55555555;
 i := i and j;
 if i <> $55555555 then
   result := false;
 i := $FFFFFFFF;
 i := i and $AAAAAAAA;
 if i <> $AAAAAAAA then
   result := false;

 i := 0;
 j := $55555555;
 i := i and j and $AAAAAAAA;
 if i <> 0 then
   result := false;
 if not result then
  WriteLn('Failure.')
 else
  WriteLn('Success.');
end;

procedure int64TestEqual;
var
 i,j : int64;
 result : boolean;
Begin
 Write('int64 = int64 test...');
 result := true;
 i := $1000001;
 j := 0;
 if i = 0 then
   result := false;
 if i = j then
  result := false;
 if j = i then
  result := false;
 if not result then
  WriteLn('Failure.')
 else
  WriteLn('Success.');
end;


procedure int64TestNotEqual;
var
 i,j : int64;
 result : boolean;
Begin
 Write('int64 <> int64 test...');
 result := true;
 i := $1000001;
 j := $1000001;
 if i <> $1000001 then
   result := false;
 if i <> j then
  result := false;
 if j <> i then
  result := false;
 if not result then
  WriteLn('Failure.')
 else
  WriteLn('Success.');
end;

procedure int64TestLE;
var
 i, j: int64;
 result : boolean;
begin
 Write('int64 <= int64 test...');
 result := true;
 i := -1;
 j := -2;
 if i <= j then
   result := false;
 i := -2;
 j := $FFFF;
 if i >= j then
   result := false;
 i := $FFFFFFFF;
 if i <= $FFFFFFFE then
    result := false;
 j := $FFFFFFFF;
 if i <= j then
  begin
    if result then
      WriteLn('Success.')
    else
      WriteLn('Failure.');
  end
 else
  WriteLn('Failure.');
end;


procedure int64TestGE;
var
 i, j: int64;
 result : boolean;
begin
 Write('int64 >= int64 test...');
 result := true;
 i := $FFFFFFFE;
 j := $FFFFFFFF;
 if i >= j then
   result := false;
 i := $FFFFFFFE;
 j := $FFFFFFFF;
 if i > j then
   result := false;
 i := $FFFFFFFE;
 if i > $FFFFFFFE then
    result := false;
 i := $FFFFFFFF;
 j := $FFFFFFFF;
 if i >= j then
  begin
    if result then
      WriteLn('Success.')
    else
      WriteLn('Failure.');
  end
 else
  WriteLn('Failure.');
end;



Begin
  { These should be tested first, since if they do not }
  { work, they will false all other results.           }
  Int64TestEqual;
  Int64TestNotEqual;
  Int64TestAdd;
  Int64TestMul;
  Int64TestOr;
  Int64TestAnd;
  Int64TestXor;
  Int64TestLe;
  Int64TestGe;
  Int64TestSub;
end.


{
 $Log
}