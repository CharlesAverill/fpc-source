unit DDG_Rec;

interface

uses sysutils;

type

  // arbitary-length array of char used for name field
  TNameStr = array[0..31] of char;

  // this record info represents the "table" structure:
  PDDGData = ^TDDGData;
  TDDGData = record
    Name: TNameStr;
    Height: Extended;
    LongField : Longint;
    ShoeSize: SmallInt;
    WordField : Word;
    DatetimeField : TDateTime;
    TimeField : TDateTime;
    DateField : TDateTime;
    Even : Boolean;
  end;

  // Pascal file of record which holds "table" data:
  TDDGDataFile = file of TDDGData;


implementation

end.
  $Log$
  Revision 1.2  2000-07-13 11:32:56  michael
  + removed logs
 
}
