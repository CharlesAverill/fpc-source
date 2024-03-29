{ %CPU=wasm32 }
{$mode objfpc}
{$H+}
uses typinfo, sysutils;

{
  Test for invoke helper generated by compiler in combination with CallInvokeHelper from Typinfo unit.
  Test using COM interface
}

Type

  {$M+}
  I1 = interface ['{76DC0D03-376C-45AA-9E0C-B3546B0C7208}']
    procedure T1(var a);
    procedure T2(out a);
    procedure T3(constref a);
  end;
  
  TT1 = Class(TInterfacedObject,I1)
  Protected
    procedure T1(var a);
    procedure T2(out a);
    procedure T3(constref a);
  end;

  { TTestInvokeHelper }

  TTestInvokeHelper = class
  Public
    FTest : string;
    I : IInterface;
    TI : PTypeInfo;
    function GetInterfaceAsPtr: Pointer;
    Procedure Fail(const S : String);
    Procedure AssertEquals(Msg : string; aExpect,aActual : Integer);
    Procedure AssertEquals(Msg : string; aExpect,aActual : Ansistring);
    Procedure AssertTrue(Msg : string; aValue : Boolean);
    Procedure AssertNotNull(Msg : string; aValue : Pointer);
    procedure StartTest(const aName : string);
    Constructor Create;
  Published
    Procedure DoTest1;
    Procedure DoTest2;
    Procedure DoTest3;
  end;
  
var
  sa : Integer;  
  ss : ansistring;
  ssa : array of ansistring;
  
Procedure TT1.T1(var a);

begin
  Writeln('in T1');
  sa:=PInteger(@a)^;
  PInteger(@a)^:=321;
end;

procedure TT1.T2(out a);

begin
  Writeln('in T2');
  PInteger(@a)^:=321;
end;

  
Procedure TT1.T3(constref a);

begin
  Writeln('in T3');
  sa:=PInteger(@a)^;
end;  

procedure TTestInvokeHelper.AssertEquals(Msg: string; aExpect, aActual: Integer);
begin
  AssertTrue(Msg+': '+IntToStr(aExpect)+'<>'+IntToStr(aActual),aExpect=aActual);
end;

procedure TTestInvokeHelper.AssertEquals(Msg: string; aExpect,
  aActual: Ansistring);
begin
  AssertTrue(Msg+': "'+aExpect+'" <> "'+aActual+'"',aExpect=aActual);
end;

procedure TTestInvokeHelper.AssertTrue(Msg: string; aValue: Boolean);
begin
  if not aValue then
    Fail(' failed: '+Msg);
end;

procedure TTestInvokeHelper.AssertNotNull(Msg: string; aValue: Pointer);
begin
  AssertTrue(Msg+': not null',Assigned(aValue));
end;

procedure TTestInvokeHelper.StartTest(const aName: string);
begin
  FTest:=aName;
  I:=Nil;
end;

constructor TTestInvokeHelper.Create;
begin
  TI:=TypeInfo(I1);
end;


function TTestInvokeHelper.GetInterfaceAsPtr: Pointer;

var
  IU : IInterface;

begin
  I:=Nil; // Free previous
  I:=TT1.Create;
  if Not Supports(I,I1,IU) then
    Fail('No I1');
  Result:=Pointer(IU);
end;

procedure TTestInvokeHelper.Fail(const S : String);

begin
  Writeln(FTest,' '+S);
  Halt(1);
end;
  

procedure TTestInvokeHelper.DoTest1;

var
  a : Integer;
  args : Array of pointer;
  
begin
  StartTest('DoTest1');
  A:=123;
  Setlength(Args,2);
  Args[0]:=Nil;
  Args[1]:=@A;
  CallInvokeHelper(TI,GetInterfaceAsPtr,'T1',PPointer(Args));
  AssertEquals('Value passed',123,sa);
  AssertEquals('Retured value',321,A);
end;

procedure TTestInvokeHelper.DoTest2;

var
  a : Integer;
  args : Array of pointer;
  
begin
  StartTest('DoTest2');
  A:=123;
  Setlength(Args,2);
  Args[0]:=Nil;
  Args[1]:=@A;
  CallInvokeHelper(TI,GetInterfaceAsPtr,'T2',PPointer(Args));
  AssertEquals('Returned value',321,A);
 
end;

procedure TTestInvokeHelper.DoTest3;

var
  a,ra : Integer;
  args : Array of pointer;

begin
  StartTest('DoTest3');
  A:=123;
  Setlength(Args,2);
  Args[0]:=@RA;
  Args[1]:=@A;
  CallInvokeHelper(TI,GetInterfaceAsPtr,'T3',PPointer(Args));
  AssertEquals('Value passed',A,sa);
end;

begin
  With TTestInvokeHelper.Create do
    try
      DoTest1;
      DoTest2;
      DoTest3;
      Writeln('All OK');
    finally
      Free;
    end;   
end.
