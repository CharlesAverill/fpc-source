unit tbf0203a;

interface
   procedure a;
   procedure c;

   const is_called : boolean = false;

implementation

   procedure c;
     begin
        a;
     end;

   procedure b;[public, alias : '_assembler_a'];
     begin
        Writeln('b called'); 
        Is_called:=true;
     end;

   procedure a;external name '_assembler_a';

end.

