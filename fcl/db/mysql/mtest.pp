{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by the Free Pascal development team

    <What does this file>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program mtest;

uses db,sysutils,mysqldb;

Procedure Log(Const Msg : String);
begin
  Writeln(Msg);
end;

Procedure DumpFieldDef(F : TfieldDef);

begin
  With F do
    begin
    Writeln ('Name              : ',Name);
    Writeln ('FieldNo           : ',FieldNo);
    Writeln ('Size              : ',Size);
    Writeln ('FieldClass        : ',FieldClass.ClassName);
    Writeln ('Required          : ',required);
    Writeln ('Precision         : ',Precision);
    Writeln ('DataType          : ',FieldTypeNames[DataType]);
    Writeln ('InternalCalcField : ',Internalcalcfield);
    end;
end;

Procedure DumpField(F : Tfield);

begin
  With F do
    begin
    Writeln ('FieldName : ',FieldName);
    Writeln ('FieldNo   : ',FieldNo);
    Writeln ('Index     : ',Index);
    Writeln ('DataSize  : ',DataSize);
    Writeln ('Size      : ',Size);
    Writeln ('DataType  : ',FieldTypeNames[DataType]);
    Writeln ('Class     : ',ClassName);
    Writeln ('Required  : ',required);
    Writeln ('ReadOnly  : ',ReadOnly);
    Writeln ('Visible   : ',Visible);
    end;
end;

Procedure DumpFieldData (F : TField);

begin
  With F Do
    begin
    Writeln ('Field     : ',FieldName);
    Writeln ('Data type : ',FieldTypeNames[DataType]);
    Writeln ('As String : ',Asstring);
    Case Datatype of
      ftSmallint, ftInteger, ftWord : Writeln ('As longint : ',AsLongint);
      ftBoolean : Writeln ('As Boolean : ',AsBoolean);
      ftFloat : Writeln ('As Float : ',AsFloat);
      ftDate, ftTime, ftDateTime : Writeln ('As DateTime : ',DateTimeToStr(AsDateTime));
    end;
    end;
end;

Var
  Data : TMysqldataset;
  I,Count : longint;
  Bookie : TBookMarkStr;

Procedure ScrollForward;

begin
  Writeln ('Browsing Forward:');
  Writeln ('------------------');
  With Data do
    While NOT EOF do
      begin
      For I:=0 to FieldCount-1 do
        DumpFieldData(Fields[I]);
      Next;
      end;
end;

Procedure ScrollBackWard;

begin
  Writeln ('Browsing Backward:');
  Writeln ('-------------------');
  With Data do
    While NOT BOF do
      begin
      For I:=0 to FieldCount-1 do
        DumpFieldData(Fields[I]);
      Prior;
      end;
end;

begin
  if paramcount<>4 then
    begin
    Writeln ('Usage : mtest db user pwd sql');
    Halt(1);
    end;
  Log ('Creating Dataset');
  Data:=TMysqlDataset.Create(Nil);
  With Data do
    begin
    Log('Setting database');
    Database:=Paramstr(1);
    Log('Setting user');
    User:=Paramstr(2);
    Log('Setting password');
    PassWord := Paramstr(3);
    Log('Setting SQL');
    SQL.text := Paramstr(4);
    Log('Opening Dataset');
    Open;
    Log('Dumping fielddefs : ');
    Writeln ('Fielddefs count : ',FieldDefs.Count);
    For I:=0 to FieldDefs.Count-1 do
      DumpFieldDef(FieldDefs.Items[i]);
    Writeln ('Fields count : ',FieldCount);
    For I:=0 to FieldCount-1 do
      DumpField(Fields[i]);
    ScrollForward;
    ScrollBackWard;
    Writeln ('Going to last :');
    writeln ('---------------');
    Last;
    ScrollBackWard;
    ScrollForward;
    Writeln ('Going to first:');
    First;
    Count:=0;
    Writeln ('Browsing Forward:');
    Writeln ('------------------');
    With Data do
      While NOT EOF do
        begin
        Inc(Count);
        If Count=recordCount div 2 then
          begin
          Writeln ('Setting bookmark on record');
          Bookie:=Bookmark;
          Writeln ('Got data : "',Bookie,'"');
          end;
        For I:=0 to FieldCount-1 do
          DumpFieldData(Fields[I]);
        Next;
        end;
    Writeln ('Jumping to bookmark',Bookie);
    BookMark:=Bookie;
    Writeln ('Dumping Record : ');
      For I:=0 to FieldCount-1 do
        DumpFieldData(Fields[I]);
    Next;
    Writeln ('Dumping Next Record : ');
    For I:=0 to FieldCount-1 do
      DumpFieldData(Fields[I]);
    Prior;
    Prior;
    Writeln ('Dumping Previous Record : ');
    For I:=0 to FieldCount-1 do
      DumpFieldData(Fields[I]);
    Log('Closing Dataset');
    Close;
    Log('End.');
    Free;
    end;
end.

{
   $Log$
   Revision 1.1  2001-01-24 22:19:04  peter
     * mysql units moved to mysql/ dir

   Revision 1.1  2000/09/01 22:02:10  peter
     * build also db

   Revision 1.1  2000/07/13 06:31:27  michael
   + Initial import

   Revision 1.5  2000/01/07 01:24:32  peter
     * updated copyright to 2000

   Revision 1.4  2000/01/06 01:20:32  peter
     * moved out of packages/ back to topdir

   Revision 1.1  2000/01/03 19:33:06  peter
     * moved to packages dir

   Revision 1.2  1999/10/24 17:07:54  michael
   + Added copyright header

}