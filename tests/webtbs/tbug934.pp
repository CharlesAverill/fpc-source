{ $OPT=-Or }
{$mode objfpc}
 Type
      t = class(TObject)
       f1,f2:dword;
       constructor Init(p1, p2:dword);
      end;

 constructor t.Init(p1, p2:dword);
 begin
  f1:=p1; f2:=p2;
 end;
 var ti:t;
begin
 ti:=t.Init(1,2);
 writeln(ti.f1, ', ', ti.f2) // prints garbage instead of t2
end.