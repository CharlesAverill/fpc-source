{$ifdef fpc}
{$mode delphi}
{$endif fpc}

{$ifdef FPC_COMP_IS_INT64}
type 
  comp = double;
{$endif FPC_COMP_IS_INT64}
procedure test(a: smallint); overload;
  begin
    writeln('smallint called instead of ansistring');
    writeln('XXX')
  end;

procedure test(a: ansistring); overload;
  begin
    writeln('ansistring called instead of smallint');
    halt(1)
  end;

var
  v: variant;
  x: smallint;
  y: ansistring;

begin
  try
    v := x;
    test(v);
  except
    on E : TObject do
      halt(1);
  end;

  try
    v := y;
    test(v);
  except
    on E : TObject do
      writeln('VVV');
  end;
end.
