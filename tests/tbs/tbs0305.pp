{$mode objfpc}
uses
{$ifdef go32v2}
dpmiexcp,
{$endif}
sysutils;
var i,j,k:real;
const except_called : boolean = false;
begin
  i:=100;
  j:=0;
  try
    k:=i/j;
    writeln(k:5:3);
  except
    k:=0;
    writeln('Illegal Input');
    except_called:=true;
  end;
  if not except_called then
    begin
      Writeln('Error in except handling');
      Halt(1);
    end;
end.
