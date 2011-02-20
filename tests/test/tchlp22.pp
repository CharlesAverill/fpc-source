{ %FAIL }

{ overloading needs to be enabled explicitly }
program tchlp22;

{$ifdef fpc}
  {$mode objfpc}
{$endif}

type
  TFoo = class
    procedure Test(const aTest: String);
  end;

  TFooHelper = class helper for TFoo
    procedure Test;
  end;

procedure TFoo.Test(const aTest: String);
begin

end;

procedure TFooHelper.Test;
begin

end;

var
  f: TFoo;
begin
  f := TFoo.Create;
  f.Test('Foo');
end.

