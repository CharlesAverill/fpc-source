
{$ifdef go32v2}
   uses dpmiexcp;

{$endif go32v2}

const
      nextoptpass : longint = 0;
  procedure init;

    const
       endofparas : boolean = false;

    procedure getparastring;

      procedure nextopt;

        begin
           endofparas:=true;
           getparastring;
           inc(nextoptpass);
           init;
        end;

      begin
       if not endofparas then
         nextopt;
      end;
      
    begin
         getparastring;
    end;      
     
begin
   init;
   if nextoptpass<>1 then Halt(1);
end.

