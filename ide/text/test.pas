program                TestProgram;

uses Test2;

const A =  1234;
      B =  $1234;
      C =  #1#2#3#4;
      ConstBool1 = true;
      ConstBool2 = boolean(5);
      ConstChar = 'A';
      ConstSet = ['A'..'Z'];
      ConstSet2 = [15..254];
      ConstFloat = 3.1415;

type
      PObj = ^TObj;
      TObj = object
        constructor Init;
        function    Func: boolean;
        procedure   Proc; virtual;
        destructor  Done; virtual;
      private
        Z: integer;
      end;

      TObj2 = object(TObj)
        procedure Proc; virtual;
      end;

      TObj3  = object(TObj)
      end;

      TObj32 = object(TObj3)
      end;

      TObj4 = object(TObj)
      end;

      TClass = class
        constructor Create;
      end;

      TClass2 = class(TClass)
      end;

      EnumTyp = (enum1,enum2,enum3);
      ArrayTyp = array[1..10] of EnumTyp;
      ProcTyp = function(A: word; var B: longint; const C: EnumTyp): real;
      SetTyp = set of EnumTyp;

const
      ConstOrd = enum1;

var Hello : word;
    X: PRecord;
    Bool: boolean;
    T : TRecord;
    Str20 : string[20];
    Str255: string;
    ArrayW: array[2..45] of word;
    ArrayVar: ArrayTyp;
    EnumVar: (enumElem1,enumElem2,enumElem3);
    EnumVar2: EnumTyp;
    FileVar: file;
    FileVarR: file of TRecord;
    FileVarW: file of word;
    ProcVar: procedure;
    ProcVarD: function(X: real): boolean;
    ProcVarI: ProcTyp;
    SetVarD: set of char;
    SetVarI: SetTyp;
    Float1: real;
    Float2: double;
    Float3: comp;
    Float4: extended;
    Pointer1: pointer;
    Pointer2: PObj;
    ClassVar1: TClass;
    ClassVar2: TClass2;
    Obj1: TObj;
    Obj2: TObj2;

constructor TObj.Init;
begin
  Z:=1;
end;

function TObj.Func: boolean;
begin
  Func:=true;
end;

procedure TObj.Proc;
begin
  if Func=false then Halt;
end;

destructor TObj.Done;
begin
end;

procedure TObj2.Proc;
begin
  Z:=4;
end;

constructor TClass.Create;
begin
end;

function Func1(x,z : word; var y : boolean; const r: TRecord): shortint;

  procedure test_local(c,f : longint);
   var
      int_loc : longint;
   begin
      Writeln('dummy for browser');
   end;

begin
  if Hello=0 then X:=0 else X:=1;
  test_local(0,2);
  Func1:=X;
end;

var i : longint;

BEGIN
  X:=nil;
  writeln('Hello world!');
  Writeln('ParamCount = ',ParamCount);
  For i:=0 to paramcount do
   writeln('Paramstr(',i,') = ',Paramstr(i));
  writeln(IsOdd(3));
  writeln(Func1(5,5,Bool,T));
  Halt;
END.
