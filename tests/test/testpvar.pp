{
  $Id$
  This program tries to test any aspect of procedure variables and related
  stuff in FPC mode
}

{$ifdef go32v2}
uses
   dpmiexcp;
{$endif go32v2}

Type
  TMyRecord = Record
    MyProc1,MyProc2 : Procedure(l : longint);
    MyVar : longint;
  end;

procedure do_error(i : longint);

  begin
     writeln('Error near: ',i);
     halt(1);
  end;

var
   globalvar : longint;

type
   tpoo_rec = record
      procpointer : pointer;
      s : pointer;
   end;

procedure callmethodparam(s : pointer;addr : pointer;param : longint);

  var
     p : procedure(param : longint) of object;

  begin
     tpoo_rec(p).procpointer:=addr;
     tpoo_rec(p).s:=s;
     p(param);
  end;

type
   to1 = object
      constructor init;
      procedure test1;
      procedure test2(l : longint);
      procedure test3(l : longint);virtual;abstract;
   end;

   to2 = object(to1)
     procedure test3(l : longint);virtual;
   end;

 constructor to1.init;

   begin
   end;

 procedure to1.test1;
   var
      p:pointer;
   begin
      // useless only a semantic test
      p:=@to1.test1;
      // this do we use to do some testing
      p:=@to1.test2;
      globalvar:=0;
      callmethodparam(@self,p,1234);
      if globalvar<>1234 then
        do_error(1000);
   end;

 procedure to1.test2(l : longint);

   begin
      globalvar:=l;
   end;

 procedure to2.test3(l : longint);

   begin
      globalvar:=l;
   end;

 procedure testproc(l : longint);

   begin
      globalvar:=l;
   end;

const
   constmethodaddr : pointer = @to1.test2;
   MyRecord : TMyRecord = (
     MyProc1 : TestProc;
     MyProc2 : @TestProc;
   );

var
   o1 : to1;
   o2 : to2;
   p : procedure(l : longint) of object;

begin
   { Simple procedure variables }
   writeln('Procedure variables');
   globalvar:=0;
   MyRecord.MyProc1(1234);
   if globalvar<>1234 then
     do_error(2000);
   globalvar:=0;
   MyRecord.MyProc2(4321);
   if globalvar<>4321 then
     do_error(2001);
   writeln('Ok');
   {                                       }
   {  Procedures of objects                }
   {                                       }
   o1.init;
   o2.init;
   writeln('Procedures of objects');
   p:=@o1.test2;
   globalvar:=0;
   p(12);
   if globalvar<>12 then
     do_error(1002);
   writeln('Ok');
   p:=@o2.test3;
   globalvar:=0;
   p(12);
   if globalvar<>12 then
     do_error(1004);
   writeln('Ok');
   {                                       }
   {  Pointers and addresses of procedures }
   {                                       }
   writeln('Getting an address of a method as pointer');
   o1.test1;
   globalvar:=0;
   callmethodparam(@o1,constmethodaddr,34);
   if globalvar<>34 then
     do_error(1001);   
   writeln('Ok');
end.
{
  $Log$
  Revision 1.2  2000-04-02 09:06:55  florian
  *** empty log message ***

  Revision 1.1  1999/12/02 17:37:45  peter
    * moved *.pp into subdirs
    * fpcmaked

  Revision 1.2  1999/11/29 22:55:25  florian
    * small update

  Revision 1.1  1999/09/11 19:45:33  florian
    * first version, please keep it up-to-date

}
