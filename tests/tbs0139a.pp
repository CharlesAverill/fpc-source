 unit tbs0139a;

{$mode objfpc}

 interface

 type
    SomeClass=class(TObject)
    protected
    procedure doSomething; virtual;
    end ;

 implementation


 procedure SomeClass.doSomething;
 begin
   Writeln ('Hello from SomeClass.DoSomething');
 end ;

end.