var
  b,bb : boolean;
begin
  b:=(true > false);
  if b then
   writeln('ok 1')
  else
   halt(1);
  b:=true;
  b:=(b > false);
  if b then
   writeln('ok 2')
  else
   halt(1);
  b:=false;
  bb:=true;
  if b<bb then
   writeln('ok 3')
  else
   halt(1);
end.
