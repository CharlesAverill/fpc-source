Program Wrong_Output;
{}
Var r:Extended; s:String;
d : double;
{}
Begin
  Writeln('Size of Extended type (r)=',SizeOf(r),' bytes');
  r:=0.000058184639;
  d:=0.000058184639;
  Writeln('r=',r);
  Writeln('r=',r:16:13);
  Writeln('r=',r:15:12);
  Writeln('r=',r:14:11);
  Writeln('r=',r:13:10);
  Writeln('r=',r:12:9);
  Writeln('r=',r:11:8);
  Writeln('r=',r:10:7);
  Writeln('r=',r:9:6);
  Writeln('r=',r:8:5);
  Writeln('r=',r:7:4);
  Str(r:7:4,s);
  Writeln('r=',s,' (as string)')
End.
