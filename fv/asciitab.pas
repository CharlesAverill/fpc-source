{ $Id$  }
{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}
{                                                          }
{   System independent GRAPHICAL clone of ASCIITAB.PAS     }
{                                                          }
{   Interface Copyright (c) 1992 Borland International     }
{                                                          }
{   Copyright (c) 2002 by Pierre Muller                    }
{   pierre@freepascal.org                                  }
{****************[ THIS CODE IS FREEWARE ]*****************}
{                                                          }
{     This sourcecode is released for the purpose to       }
{   promote the pascal language on all platforms. You may  }
{   redistribute it and/or modify with the following       }
{   DISCLAIMER.                                            }
{                                                          }
{     This SOURCE CODE is distributed "AS IS" WITHOUT      }
{   WARRANTIES AS TO PERFORMANCE OF MERCHANTABILITY OR     }
{   ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED.     }
{                                                          }
{*****************[ SUPPORTED PLATFORMS ]******************}
{     16 and 32 Bit compilers                              }
{        DPMI     - FPC 0.9912+ (GO32V2)    (32 Bit)       }
{        WIN95/NT - FPC 0.9912+             (32 Bit)       }
{                                                          }

UNIT AsciiTab;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                  INTERFACE
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I Platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$X+} { Extended syntax is ok }
{$R-} { Disable range checking }
{$S-} { Disable Stack Checking }
{$I-} { Disable IO Checking }
{$Q-} { Disable Overflow Checking }
{$V-} { Turn off strict VAR strings }
{====================================================================}

USES FVConsts, Objects, Drivers, Views, App;      { Standard GFV units }

{***************************************************************************}
{                        PUBLIC OBJECT DEFINITIONS                          }
{***************************************************************************}


{---------------------------------------------------------------------------}
{                  TTABLE OBJECT - 32x32 matrix of all chars                }
{---------------------------------------------------------------------------}

type
  PTable = ^TTable;
  TTable = object(TView)
    procedure DrawBackground; virtual;
    procedure HandleEvent(var Event:TEvent); virtual;
  private
    procedure DrawCurPos(enable : boolean);
  end;

{---------------------------------------------------------------------------}
{                  TREPORT OBJECT - View with details of current char       }
{---------------------------------------------------------------------------}
  PReport = ^TReport;
  TReport = object(TView)
    ASCIIChar: LongInt;
    constructor Load(var S: TStream);
    procedure Draw; virtual;
    procedure HandleEvent(var Event:TEvent); virtual;
    procedure Store(var S: TStream);
  end;

{---------------------------------------------------------------------------}
{                  TASCIIChart OBJECT - the complete AsciiChar window       }
{---------------------------------------------------------------------------}

  PASCIIChart = ^TASCIIChart;
  TASCIIChart = object(TWindow)
    Report: PReport;
    Table: PTable;
    constructor Init;
    constructor Load(var S: TStream);
    procedure   Store(var S: TStream);
    procedure HandleEvent(var Event:TEvent); virtual;
  end;

{---------------------------------------------------------------------------}
{ AsciiTableCommandBase                                                     }
{---------------------------------------------------------------------------}

const
  AsciiTableCommandBase: Word = 910;

{---------------------------------------------------------------------------}
{ Registrations records                                                     }
{---------------------------------------------------------------------------}

  RTable: TStreamRec = (
     ObjType: 10030;
     VmtLink: Ofs(TypeOf(TTable)^);
     Load:    @TTable.Load;
     Store:   @TTable.Store
  );
  RReport: TStreamRec = (
     ObjType: 10031;
     VmtLink: Ofs(TypeOf(TReport)^);
     Load:    @TReport.Load;
     Store:   @TReport.Store
  );
  RASCIIChart: TStreamRec = (
     ObjType: 10032;
     VmtLink: Ofs(TypeOf(TASCIIChart)^);
     Load:    @TASCIIChart.Load;
     Store:   @TASCIIChart.Store
  );

{---------------------------------------------------------------------------}
{ Registration procedure                                                    }
{---------------------------------------------------------------------------}
procedure RegisterASCIITab;



{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                             IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{***************************************************************************}
{                              OBJECT METHODS                               }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TTable OBJECT METHODS                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

procedure TTable.DrawBackground;
var
  NormColor : byte;
  B : TDrawBuffer;
  x,y : sw_integer;
begin
  NormColor:=GetColor(1);
  For y:=0 to size.Y-1 do
    For x:=0 to size.X-1 do
      begin
        B[x]:=(NormColor shl 8) or ((y*Size.X+x) and $ff);
        WriteLine(0,Y,Size.X,1,B);
      end;
  DrawCurPos(true);
end;

procedure TTable.DrawCurPos(enable : boolean);
var
  Color : byte;
  B : word;
begin
  Color:=GetColor(1);
  { add blinking if enable }
  If Enable then
    Color:=((Color and $F) shl 4) or (Color shr 4);
  B:=(Color shl 8) or ((Cursor.Y*Size.X+Cursor.X) and $ff);
  WriteLine(Cursor.X,Cursor.Y,1,1,B);
end;

procedure TTable.HandleEvent(var Event:TEvent);
var
  xpos,ypos : sw_integer;
  Handled : boolean;

  procedure SetTo(xpos, ypos : sw_integer);
  var
    newchar : ptrint;
  begin
    newchar:=(ypos*size.X+xpos) and $ff;
    DrawCurPos(false);
    SetCursor(xpos,ypos);
    Message(Owner,evCommand,AsciiTableCommandBase,
      pointer(newchar));
    DrawCurPos(true);
    ClearEvent(Event);
  end;
begin
  case Event.What of
    evMouseDown :
      begin
        If MouseInView(Event.Where) then
          begin
            xpos:=Event.Where.X-Origin.X;
            ypos:=Event.Where.Y-Origin.Y;
            SetTo(xpos, ypos);
            exit;
          end;
      end;
    evKeyDown :
      begin
        Handled:=true;
        case Event.Keycode of
          kbUp   : if Cursor.Y>0 then
                   SetTo(Cursor.X,Cursor.Y-1);
          kbDown : if Cursor.Y<Size.Y-1 then
                   SetTo(Cursor.X,Cursor.Y+1);
          kbLeft : if Cursor.X>0 then
                   SetTo(Cursor.X-1,Cursor.Y);
          kbRight: if Cursor.X<Size.X-1 then
                   SetTo(Cursor.X+1,Cursor.Y);
          kbHome : SetTo(0,0);
          kbEnd  : SetTo(Size.X-1,Size.Y-1);
        else
          Handled:=false;
        end;
        if Handled then
          exit;
      end;
  end;
  inherited HandleEvent(Event);
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TReport OBJECT METHODS                             }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

constructor TReport.Load(var S: TStream);
begin
  Inherited Load(S);
  S.Read(AsciiChar,Sizeof(AsciiChar));
end;

procedure TReport.Draw;
  var
    stHex,stDec : string[3];
    s : string;
begin
  Str(AsciiChar,StDec);
  while length(stDec)<3 do
    stDec:=' '+stDec;
  stHex:=hexstr(AsciiChar,2);
  s:='Char "'+chr(AsciiChar)+'" Decimal: '+
     StDec+' Hex: $'+StHex;
  WriteStr(0,0,S,1);
end;

procedure TReport.HandleEvent(var Event:TEvent);
begin
  if (Event.what=evCommand) and
     (Event.Command =  AsciiTableCommandBase) then
    begin
      AsciiChar:=Event.InfoLong;
      Draw;
      ClearEvent(Event);
    end
  else inherited HandleEvent(Event);
end;

procedure TReport.Store(var S: TStream);
begin
  Inherited Store(S);
  S.Write(AsciiChar,Sizeof(AsciiChar));
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TAsciiChart OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

constructor TASCIIChart.Init;
var
  R : Trect;
begin
  R.Assign(0,0,34,12);
  Inherited Init(R,'Ascii table',wnNoNumber);
  Flags:=Flags and not (wfGrow or wfZoom);
  Palette:=wpGrayWindow;
  R.Assign(1,10,33,11);
  New(Report,Init(R));
  Report^.Options:=Report^.Options or ofFramed;
  Insert(Report);
  R.Assign(1,1,33,9);
  New(Table,Init(R));
  Table^.Options:=Table^.Options or (ofSelectable+ofTopSelect);
  Insert(Table);
  Table^.Select;
end;

constructor TASCIIChart.Load(var S: TStream);
begin
  Inherited Load(S);
  GetSubViewPtr(S,Table);
  GetSubViewPtr(S,Report);
end;

procedure TASCIIChart.Store(var S: TStream);
begin
  Inherited Store(S);
  PutSubViewPtr(S,Table);
  PutSubViewPtr(S,Report);
end;

procedure TASCIIChart.HandleEvent(var Event:TEvent);
begin
  if (Event.what=evCommand) and
     (Event.Command =  AsciiTableCommandBase) then
    begin
      Report^.HandleEvent(Event);
    end
  else inherited HandleEvent(Event);
end;
{---------------------------------------------------------------------------}
{ Registration procedure                                                    }
{---------------------------------------------------------------------------}
procedure RegisterASCIITab;
begin
  RegisterType(RTable);
  RegisterType(RReport);
  RegisterType(RAsciiChart);
end;


END.
{
 $Log$
 Revision 1.6  2004-12-19 13:05:56  florian
   * fixed x86_64 compilation

 Revision 1.5  2004/11/06 17:08:48  peter
   * drawing of tview merged from old fv code

}
