{ %FAIL }

{ OpenString with high should not be allowed }
program tb0144;

procedure TestOpen(var s: OpenString); cdecl;
var
 b: byte;
begin
 b:=high(s); 
end;



Begin
end.

{
   $Log$
   Revision 1.1  2002-11-26 19:24:30  carl
     * some small fixes
     + added several new tests

}