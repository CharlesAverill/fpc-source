program test;

  type
      obj1 = object
        st : string;
      constructor init;
      procedure writeit;
      end;

      obj2 = object(obj1)
      procedure writeit;virtual;
      end;

      obj3 = object(obj2)
        l : longint;
      end;
      
      constructor obj1.init;
        begin
        end;

      procedure obj1.writeit;
        begin
        end;
        
      procedure obj2.writeit;
        begin
        end;
        

begin
end.
