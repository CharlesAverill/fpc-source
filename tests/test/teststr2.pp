uses
   dotest;

procedure chararray2stringtest;

  var
     a : array[1..2,1..10,1..5] of char;
     i,j,k,l : integer;

  begin
     for i:=1 to 10 do
       a[i,i]:='Hello';
     i:=1;
     j:=2;
     k:=3;
     l:=4;
     { test register allocation }
     if (a[i,i]<>'Hello') or
       (a[i,i]<>'Hello') or
       (a[i,i]<>'Hello') or
       (a[i,i]<>'Hello') then
       do_error(1000);
   end;

begin
   writeln('Misc. shortstring tests');
   chararray2stringtest;
   writeln('Misc. shortstring tests successfully passed');
   halt(0);
end.
