{
    $Id$
    This file is part of the Free Pascal Integrated Development Environment
    Copyright (c) 1999-2000 by Berczi Gabor

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit WHTMLHlp;

interface

uses Objects,WHTML,WAnsi,WHelp;

const
     extHTML              = '.htm';
     extHTMLIndex         = '.htx';

     ListIndent = 2;
     DefIndent  = 4;

     MaxTopicLinks = 4000; { maximum number of links on a single HTML page }

type
    THTMLSection = (hsNone,hsHeading1,hsHeading2,hsHeading3,hsHeading4,hsHeading5,hsHeading6);

    PTopicLinkCollection = ^TTopicLinkCollection;
    TTopicLinkCollection = object(TStringCollection)
      procedure   Insert(Item: Pointer); virtual;
      function    At(Index: sw_Integer): PString;
      function    AddItem(Item: string): integer;
    end;

    TParagraphAlign = (paLeft,paCenter,paRight);

    PHTMLTopicRenderer = ^THTMLTopicRenderer;
    THTMLTopicRenderer = object(THTMLParser)
      function  BuildTopic(P: PTopic; AURL: string; HTMLFile: PTextFile; ATopicLinks: PTopicLinkCollection): boolean;
    public
      function  DocAddTextChar(C: char): boolean; virtual;
      procedure DocSoftBreak; virtual;
      procedure DocTYPE; virtual;
      procedure DocHTML(Entered: boolean); virtual;
      procedure DocHEAD(Entered: boolean); virtual;
      procedure DocMETA; virtual;
      procedure DocTITLE(Entered: boolean); virtual;
      procedure DocBODY(Entered: boolean); virtual;
      procedure DocAnchor(Entered: boolean); virtual;
      procedure DocHeading(Level: integer; Entered: boolean); virtual;
      procedure DocParagraph(Entered: boolean); virtual;
      procedure DocBreak; virtual;
      procedure DocImage; virtual;
      procedure DocBold(Entered: boolean); virtual;
      procedure DocCite(Entered: boolean); virtual;
      procedure DocCode(Entered: boolean); virtual;
      procedure DocEmphasized(Entered: boolean); virtual;
      procedure DocItalic(Entered: boolean); virtual;
      procedure DocKbd(Entered: boolean); virtual;
      procedure DocPreformatted(Entered: boolean); virtual;
      procedure DocSample(Entered: boolean); virtual;
      procedure DocStrong(Entered: boolean); virtual;
      procedure DocTeleType(Entered: boolean); virtual;
      procedure DocVariable(Entered: boolean); virtual;
      procedure DocList(Entered: boolean); virtual;
      procedure DocOrderedList(Entered: boolean); virtual;
      procedure DocListItem; virtual;
      procedure DocDefList(Entered: boolean); virtual;
      procedure DocDefTerm; virtual;
      procedure DocDefExp; virtual;
      procedure DocTable(Entered: boolean); virtual;
      procedure DocTableRow(Entered: boolean); virtual;
      procedure DocTableItem(Entered: boolean); virtual;
      procedure DocHorizontalRuler; virtual;
    public
      function  GetSectionColor(Section: THTMLSection; var Color: byte): boolean; virtual;
    private
      URL: string;
      Topic: PTopic;
      TopicLinks: PTopicLinkCollection;
      TextPtr: sw_word;
      InTitle: boolean;
      InBody: boolean;
      InAnchor: boolean;
      InParagraph: boolean;
      InPreformatted: boolean;
      TopicTitle: string;
      Indent: integer;
      AnyCharsInLine: boolean;
      CurHeadLevel: integer;
      PAlign: TParagraphAlign;
      LinkIndexes: array[0..MaxTopicLinks] of sw_integer;
      LinkPtr: sw_integer;
      LastTextChar: char;
{      Anchor: TAnchor;}
      procedure AddText(S: string);
      procedure AddChar(C: char);
    end;

    PCustomHTMLHelpFile = ^TCustomHTMLHelpFile;
    TCustomHTMLHelpFile = object(THelpFile)
      constructor Init(AID: word);
      destructor  Done; virtual;
    public
      function    SearchTopic(HelpCtx: THelpCtx): PTopic; virtual;
      function    ReadTopic(T: PTopic): boolean; virtual;
    private
      Renderer: PHTMLTopicRenderer;
      DefaultFileName: string;
      CurFileName: string;
      TopicLinks: PTopicLinkCollection;
    end;

    PHTMLHelpFile = ^THTMLHelpFile;
    THTMLHelpFile = object(TCustomHTMLHelpFile)
      constructor Init(AFileName: string; AID: word; ATOCEntry: string);
    public
      function    LoadIndex: boolean; virtual;
    private
      TOCEntry: string;
    end;

    PHTMLIndexHelpFile = ^THTMLIndexHelpFile;
    THTMLIndexHelpFile = object(TCustomHTMLHelpFile)
      constructor Init(AFileName: string; AID: word);
      function    LoadIndex: boolean; virtual;
    private
      IndexFileName: string;
    end;

    PHTMLAnsiView    = ^THTMLAnsiView;
    PHTMLAnsiConsole = ^THTMLAnsiConsole;

    THTMLAnsiConsole = Object(TAnsiViewConsole)
      MaxX,MaxY : integer;
      procedure   GotoXY(X,Y: integer); virtual;
    end;

    THTMLAnsiView = Object(TAnsiView)
    private
      HTMLOwner : PHTMLTopicRenderer;
      HTMLConsole : PHTMLAnsiConsole;
    public
      constructor Init(AOwner: PHTMLTopicRenderer);
      procedure   CopyToHTML;
    end;

    THTMLGetSectionColorProc = function(Section: THTMLSection; var Color: byte): boolean;

function DefHTMLGetSectionColor(Section: THTMLSection; var Color: byte): boolean;

const HTMLGetSectionColor : THTMLGetSectionColorProc = {$ifdef fpc}@{$endif}DefHTMLGetSectionColor;

procedure RegisterHelpType;

implementation

uses Views,WConsts,WUtils,WViews,WHTMLScn;


{    THTMLAnsiConsole methods      }

procedure THTMLAnsiConsole.GotoXY(X,Y : integer);
begin
  if X>MaxX then MaxX:=X;
  if Y>MaxY then MaxY:=Y;
  inherited GotoXY(X,Y);
end;

{    THTMLAnsiView methods      }

constructor THTMLAnsiView.Init(AOwner : PHTMLTopicRenderer);
var
  R : TRect;
begin
  if not assigned(AOwner) then
    fail;
  R.Assign(0,0,80,25);
  inherited init(R,nil,nil);
  HTMLOwner:=AOwner;
  HTMLConsole:=New(PHTMLAnsiConsole,Init(@Self));
  Dispose(Console,Done);
  Console:=HTMLConsole;
  HTMLConsole^.Size.X:=80;
  HTMLConsole^.Size.Y:=25;
  HTMLConsole^.ClrScr;
  HTMLConsole^.MaxX:=-1;
  HTMLConsole^.MaxY:=-1;
  HTMLConsole^.BoundChecks:=0;
end;

procedure THTMLAnsiView.CopyToHTML;
var
  Attr,NewAttr : byte;
  X,Y,Pos : longint;
begin
   Attr:=(Buffer^[1] shr 8);
   HTMLOwner^.AddChar(hscLineBreak);
   HTMLOwner^.AddText(hscTextAttr+chr(Attr));
   for Y:=0 to HTMLConsole^.MaxY-1 do
     begin
       for X:=1 to HTMLConsole^.MaxX-1 do
         begin
           Pos:=(Delta.Y*MaxViewWidth)+X+Y*MaxViewWidth;
           NewAttr:=(Buffer^[Pos] shr 8);
           if NewAttr <> Attr then
             begin
               Attr:=NewAttr;
               HTMLOwner^.AddText(hscTextAttr+chr(Attr));
             end;
           HTMLOwner^.AddChar(chr(Buffer^[Pos] and $ff));
         end;
       HTMLOwner^.AddChar(hscLineBreak);
     end;
end;

function DefHTMLGetSectionColor(Section: THTMLSection; var Color: byte): boolean;
begin
  Color:=0;
  DefHTMLGetSectionColor:=false;
end;

function EncodeHTMLCtx(FileID: integer; LinkNo: word): longint;
var Ctx: longint;
begin
  Ctx:=(longint(FileID) shl 16)+LinkNo;
  EncodeHTMLCtx:=Ctx;
end;

procedure DecodeHTMLCtx(Ctx: longint; var FileID: word; var LinkNo: word);
begin
  if (Ctx shr 16)=0 then
    begin
      FileID:=$ffff; LinkNo:=0;
    end
  else
    begin
      FileID:=Ctx shr 16; LinkNo:=Ctx and $ffff;
    end;
end;

function CharStr(C: char; Count: byte): string;
var S: string;
begin
  S[0]:=chr(Count);
  if Count>0 then FillChar(S[1],Count,C);
  CharStr:=S;
end;

procedure TTopicLinkCollection.Insert(Item: Pointer);
begin
  AtInsert(Count,Item);
end;

function TTopicLinkCollection.At(Index: sw_Integer): PString;
begin
  At:=inherited At(Index);
end;

function TTopicLinkCollection.AddItem(Item: string): integer;
var Idx: sw_integer;
begin
  if Item='' then Idx:=-1 else
  if Search(@Item,Idx)=false then
    begin
      AtInsert(Count,NewStr(Item));
      Idx:=Count-1;
    end;
  AddItem:=Idx;
end;

function THTMLTopicRenderer.DocAddTextChar(C: char): boolean;
var Added: boolean;
begin
  Added:=false;
  if InTitle then
    begin
      TopicTitle:=TopicTitle+C;
      Added:=true;
    end
  else
  if InBody then
    begin
      if (InPreFormatted) or (C<>#32) or (LastTextChar<>C) then
      if (C<>#32) or (AnyCharsInLine=true) or (InPreFormatted=true) then
        begin
          AddChar(C);
          LastTextChar:=C;
          Added:=true;
        end;
    end;
  DocAddTextChar:=Added;
end;

procedure THTMLTopicRenderer.DocSoftBreak;
begin
  if InPreformatted then DocBreak else
  if AnyCharsInLine then
    begin
      AddChar(' ');
      LastTextChar:=' ';
    end;
end;

procedure THTMLTopicRenderer.DocTYPE;
begin
end;

procedure THTMLTopicRenderer.DocHTML(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocHEAD(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocMETA;
begin
end;

procedure THTMLTopicRenderer.DocTITLE(Entered: boolean);
begin
  if Entered then
    begin
      TopicTitle:='';
    end
  else
    begin
      { render topic title here }
      if TopicTitle<>'' then
        begin
          AddText('  '+TopicTitle+' �'); DocBreak;
          AddText(' '+CharStr('�',length(TopicTitle)+3)); DocBreak;
        end;
    end;
  InTitle:=Entered;
end;

procedure THTMLTopicRenderer.DocBODY(Entered: boolean);
begin
  InBody:=Entered;
end;

procedure THTMLTopicRenderer.DocAnchor(Entered: boolean);
var HRef,Name: string;
begin
  if Entered and InAnchor then DocAnchor(false);
  if Entered then
    begin
      if DocGetTagParam('HREF',HRef)=false then HRef:='';
      if DocGetTagParam('NAME',Name)=false then Name:='';
      if Name<>'' then
        begin
          Topic^.NamedMarks^.InsertStr(Name);
          AddChar(hscNamedMark);
        end;
      if (HRef<>'') then
          begin
            InAnchor:=true;
            AddChar(hscLink);
            if LinkPtr<MaxTopicLinks then
            begin
              HRef:=CompleteURL(URL,HRef);
              LinkIndexes[LinkPtr]:=TopicLinks^.AddItem(HRef);
              Inc(LinkPtr);
            end;
          end;
    end
  else
    begin
      if InAnchor=true then AddChar(hscLink);
      InAnchor:=false;
    end;
end;

procedure DecodeAlign(Align: string; var PAlign: TParagraphAlign);
begin
  Align:=UpcaseStr(Align);
  if Align='LEFT' then PAlign:=paLeft else
  if Align='CENTER' then PAlign:=paCenter else
  if Align='RIGHT' then PAlign:=paRight;
end;

procedure THTMLTopicRenderer.DocHeading(Level: integer; Entered: boolean);
var Align: string;
    C: byte;
    SC: THTMLSection;
begin
  if Entered then
    begin
      DocBreak;
      CurHeadLevel:=Level;
      PAlign:=paLeft;
      if DocGetTagParam('ALIGN',Align) then
        DecodeAlign(Align,PAlign);
      SC:=hsNone;
      case Level of
        1: SC:=hsHeading1;
        2: SC:=hsHeading2;
        3: SC:=hsHeading3;
        4: SC:=hsHeading4;
        5: SC:=hsHeading5;
        6: SC:=hsHeading6;
      end;
      if GetSectionColor(SC,C) then
        AddText(hscTextAttr+chr(C));
    end
  else
    begin
      AddChar(hscNormText);
      CurHeadLevel:=0;
      DocBreak;
    end;
end;

procedure THTMLTopicRenderer.DocParagraph(Entered: boolean);
var Align: string;
begin
  if Entered and InParagraph then DocParagraph(false);
  if Entered then
    begin
      if AnyCharsInLine then DocBreak;
      if DocGetTagParam('ALIGN',Align) then
        DecodeAlign(Align,PAlign);
    end
  else
    begin
{      if AnyCharsInLine then }DocBreak;
      PAlign:=paLeft;
    end;
  InParagraph:=Entered;
end;

procedure THTMLTopicRenderer.DocBreak;
begin
  if (CurHeadLevel=1) or (PAlign=paCenter) then
    AddChar(hscCenter);
  if (PAlign=paRight) then
    AddChar(hscRight);
  AddChar(hscLineBreak);
  if Indent>0 then
  AddText(CharStr(#255,Indent)+hscLineStart);
  AnyCharsInLine:=false;
end;

procedure THTMLTopicRenderer.DocImage;
var Src,Alt,SrcLine: string;
    f : text;
    attr : byte;
    PA : PHTMLAnsiView;

begin
  if DocGetTagParam('SRC',src) then
    begin
      if src<>'' then
        begin
          src:=CompleteURL(URL,src);
          { this should be a image file ending by .gif or .jpg...
            Try to see if a file with same name and extension .git
            exists PM }
          src:=DirAndNameOf(src)+'.ans';
          if ExistsFile(src) then
            begin
              PA:=New(PHTMLAnsiView,init(@self));
              PA^.LoadFile(src);
              if AnyCharsInLine then DocBreak;
              InPreformatted:=true;
              {AddText('Image from '+src+hscLineBreak); }
              AddChar(hscInImage);
              PA^.CopyToHTML;
              InPreformatted:=false;
              AddChar(hscInImage);
              AddChar(hscNormText);
              if AnyCharsInLine then DocBreak;
              Dispose(PA,Done);
              Exit;
            end;
          { also look for a raw text file without colors }
          src:=DirAndNameOf(src)+'.txt';
          if ExistsFile(src) then
            begin
              Assign(f,src);
              Reset(f);
              DocPreformatted(true);
              while not eof(f) do
                begin
                  Readln(f,SrcLine);
                  AddText(SrcLine+hscLineBreak);
                end;
              Close(f);
              DocPreformatted(false);
              Exit;
            end;
        end;
    end;
  if DocGetTagParam('ALT',Alt)=false then
    begin
      DocGetTagParam('SRC',Alt);
      if Alt<>'' then
        Alt:='Can''t display '+Alt
      else
        Alt:='IMG';
    end;
  if Alt<>'' then
    begin
      AddText('['+Alt+']');
    end;
end;

procedure THTMLTopicRenderer.DocBold(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocCite(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocCode(Entered: boolean);
begin
  if AnyCharsInLine then DocBreak;
  AddText(hscCode);
  DocBreak;
end;

procedure THTMLTopicRenderer.DocEmphasized(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocItalic(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocKbd(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocPreformatted(Entered: boolean);
begin
  if AnyCharsInLine then DocBreak;
  AddText(hscCode);
  DocBreak;
  InPreformatted:=Entered;
end;

procedure THTMLTopicRenderer.DocSample(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocStrong(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocTeleType(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocVariable(Entered: boolean);
begin
end;

procedure THTMLTopicRenderer.DocList(Entered: boolean);
begin
  if Entered then
    begin
      Inc(Indent,ListIndent);
      DocBreak;
    end
  else
    begin
      Dec(Indent,ListIndent);
      if AnyCharsInLine then DocBreak;
    end;
end;

procedure THTMLTopicRenderer.DocOrderedList(Entered: boolean);
begin
  DocList(Entered);
end;

procedure THTMLTopicRenderer.DocListItem;
begin
  if AnyCharsInLine then
    DocBreak;
  AddText('�'+hscLineStart);
end;

procedure THTMLTopicRenderer.DocDefList(Entered: boolean);
begin
  if Entered then
    begin
{      if LastChar<>hscLineBreak then DocBreak;}
    end
  else
    begin
      if AnyCharsInLine then DocBreak;
    end;
end;

procedure THTMLTopicRenderer.DocDefTerm;
begin
  DocBreak;
end;

procedure THTMLTopicRenderer.DocDefExp;
begin
  Inc(Indent,DefIndent);
  DocBreak;
  Dec(Indent,DefIndent);
end;

procedure THTMLTopicRenderer.DocTable(Entered: boolean);
begin
  if AnyCharsInLine then
    DocBreak;
  if Entered then
    DocBreak;
end;

procedure THTMLTopicRenderer.DocTableRow(Entered: boolean);
begin
  if AnyCharsInLine then
    DocBreak;
end;

procedure THTMLTopicRenderer.DocTableItem(Entered: boolean);
begin
  if Entered then
    AddText(' - ');
end;

procedure THTMLTopicRenderer.DocHorizontalRuler;
var OAlign: TParagraphAlign;
begin
  OAlign:=PAlign;
  if AnyCharsInLine then DocBreak;
  PAlign:=paCenter;
  DocAddText(' '+CharStr('�',60)+' ');
  DocBreak;
  PAlign:=OAlign;
end;

procedure THTMLTopicRenderer.AddChar(C: char);
begin
  if (Topic=nil) or (TextPtr=MaxBytes) then Exit;
  Topic^.Text^[TextPtr]:=ord(C);
  Inc(TextPtr);
  if (C>#15) and ((C<>' ') or (InPreFormatted=true)) then
    AnyCharsInLine:=true;
end;

procedure THTMLTopicRenderer.AddText(S: string);
var I: sw_integer;
begin
  for I:=1 to length(S) do
    AddChar(S[I]);
end;

function THTMLTopicRenderer.GetSectionColor(Section: THTMLSection; var Color: byte): boolean;
begin
  GetSectionColor:=HTMLGetSectionColor(Section,Color);
end;

function THTMLTopicRenderer.BuildTopic(P: PTopic; AURL: string; HTMLFile: PTextFile;
           ATopicLinks: PTopicLinkCollection): boolean;
var OK: boolean;
    TP: pointer;
    I: sw_integer;
begin
  URL:=AURL;
  Topic:=P; TopicLinks:=ATopicLinks;
  OK:=Assigned(Topic) and Assigned(HTMLFile) and Assigned(TopicLinks);
  if OK then
    begin
      if (Topic^.TextSize<>0) and Assigned(Topic^.Text) then
        begin
          FreeMem(Topic^.Text,Topic^.TextSize);
          Topic^.TextSize:=0; Topic^.Text:=nil;
        end;
      Topic^.TextSize:=MaxHelpTopicSize;
      GetMem(Topic^.Text,Topic^.TextSize);

      TopicTitle:='';
      InTitle:=false; InBody:={false}true; InAnchor:=false;
      InParagraph:=false; InPreformatted:=false;
      Indent:=0; CurHeadLevel:=0;
      PAlign:=paLeft;
      TextPtr:=0; LinkPtr:=0;
      AnyCharsInLine:=false;
      LastTextChar:=#0;
      OK:=Process(HTMLFile);

      if OK then
        begin
          { --- topic links --- }
          if (Topic^.Links<>nil) and (Topic^.LinkSize>0) then
            begin
              FreeMem(Topic^.Links,Topic^.LinkSize);
              Topic^.Links:=nil; Topic^.LinkCount:=0;
            end;
          Topic^.LinkCount:=LinkPtr{TopicLinks^.Count}; { <- eeeeeek! }
          GetMem(Topic^.Links,Topic^.LinkSize);
          if Topic^.LinkCount>0 then { FP causes numeric RTE 215 without this }
          for I:=0 to Min(Topic^.LinkCount-1,High(LinkIndexes)-1) do
            begin
              Topic^.Links^[I].FileID:=Topic^.FileID;
              Topic^.Links^[I].Context:=EncodeHTMLCtx(Topic^.FileID,LinkIndexes[I]+1);
            end;
          { --- topic text --- }
          GetMem(TP,TextPtr);
          Move(Topic^.Text^,TP^,TextPtr);
          FreeMem(Topic^.Text,Topic^.TextSize);
          Topic^.Text:=TP; Topic^.TextSize:=TextPtr;
        end
      else
        begin
          DisposeTopic(Topic);
          Topic:=nil;
        end;
    end;
  BuildTopic:=OK;
end;

constructor TCustomHTMLHelpFile.Init(AID: word);
begin
  inherited Init(AID);
  New(Renderer, Init);
  New(TopicLinks, Init(50,500));
end;

function TCustomHTMLHelpFile.SearchTopic(HelpCtx: THelpCtx): PTopic;
function MatchCtx(P: PTopic): boolean; {$ifndef FPC}far;{$endif}
begin
  MatchCtx:=P^.HelpCtx=HelpCtx;
end;
var FileID,LinkNo: word;
    P: PTopic;
    FName: string;
begin
  DecodeHTMLCtx(HelpCtx,FileID,LinkNo);
  if (HelpCtx<>0) and (FileID<>ID) then P:=nil else
  if (FileID=ID) and (LinkNo>TopicLinks^.Count) then P:=nil else
    begin
      P:=Topics^.FirstThat(@MatchCtx);
      if P=nil then
        begin
          if LinkNo=0 then
            FName:=DefaultFileName
          else
            FName:=TopicLinks^.At(LinkNo-1)^;
          P:=NewTopic(ID,HelpCtx,0,FName,nil,0);
          Topics^.Insert(P);
        end;
    end;
  SearchTopic:=P;
end;

function TCustomHTMLHelpFile.ReadTopic(T: PTopic): boolean;
var OK: boolean;
    HTMLFile: PMemoryTextFile;
    Name: string;
    Link,Bookmark: string;
    P: sw_integer;
begin
  Bookmark:='';
  OK:=T<>nil;
  if OK then
    begin
      if T^.HelpCtx=0 then Name:=DefaultFileName else
        begin
          Link:=TopicLinks^.At((T^.HelpCtx and $ffff)-1)^;
          Link:=FormatPath(Link);
          P:=Pos('#',Link);
          if P>0 then
          begin
            Bookmark:=copy(Link,P+1,length(Link));
            Link:=copy(Link,1,P-1);
          end;
{          if CurFileName='' then Name:=Link else
          Name:=CompletePath(CurFileName,Link);}
          Name:=Link;
        end;
      HTMLFile:=New(PDOSTextFile, Init(Name));
      if HTMLFile=nil then
        begin
          New(HTMLFile, Init);
          HTMLFile^.AddLine('<HEAD><TITLE>'+msg_pagenotavailable+'</TITLE></HEAD>');
          HTMLFile^.AddLine(
            '<BODY>'+
            FormatStrStr(msg_cantaccessurl,Name)+'<br><br>'+
            '</BODY>');
        end;
      OK:=Renderer^.BuildTopic(T,Name,HTMLFile,TopicLinks);
      if OK then CurFileName:=Name;
      if HTMLFile<>nil then Dispose(HTMLFile, Done);
      if BookMark='' then
        T^.StartNamedMark:=0
      else
        T^.StartNamedMark:=T^.GetNamedMarkIndex(BookMark)+1;
    end;
  ReadTopic:=OK;
end;

destructor TCustomHTMLHelpFile.Done;
begin
  inherited Done;
  if Renderer<>nil then Dispose(Renderer, Done);
  if TopicLinks<>nil then Dispose(TopicLinks, Done);
end;

constructor THTMLHelpFile.Init(AFileName: string; AID: word; ATOCEntry: string);
begin
  if inherited Init(AID)=false then Fail;
  DefaultFileName:=AFileName; TOCEntry:=ATOCEntry;
  if DefaultFileName='' then
  begin
    Done;
    Fail;
  end;
end;

function THTMLHelpFile.LoadIndex: boolean;
begin
  IndexEntries^.Insert(NewIndexEntry(TOCEntry,ID,0));
  LoadIndex:=true;
end;

constructor THTMLIndexHelpFile.Init(AFileName: string; AID: word);
begin
  inherited Init(AID);
  IndexFileName:=AFileName;
end;

function THTMLIndexHelpFile.LoadIndex: boolean;
function FormatAlias(Alias: string): string;
begin
  if Assigned(HelpFacility) then
    if length(Alias)>HelpFacility^.IndexTabSize-4 then
      Alias:=Trim(copy(Alias,1,HelpFacility^.IndexTabSize-4-2))+'..';
  FormatAlias:=Alias;
end;
(*procedure AddDoc(P: PHTMLLinkScanDocument); {$ifndef FPC}far;{$endif}
var I: sw_integer;
    TLI: THelpCtx;
begin
  for I:=1 to P^.GetAliasCount do
  begin
    TLI:=TopicLinks^.AddItem(P^.GetName);
    TLI:=EncodeHTMLCtx(ID,TLI+1);
    IndexEntries^.Insert(NewIndexEntry(FormatAlias(P^.GetAlias(I-1)),ID,TLI));
  end;
end;*)
var S: PBufStream;
    LS: PHTMLLinkScanner;
    OK: boolean;
    TLI: THelpCtx;
    I,J: sw_integer;
begin
  New(S, Init(IndexFileName,stOpenRead,4096));
  OK:=Assigned(S);
  if OK then
  begin
    New(LS, LoadDocuments(S^));
    OK:=Assigned(LS);
    if OK then
    begin
      LS^.SetBaseDir(DirOf(IndexFileName));
      for I:=0 to LS^.GetDocumentCount-1 do
       for J:=0 to LS^.GetDocumentAliasCount(I)-1 do
        begin
          TLI:=TopicLinks^.AddItem(LS^.GetDocumentURL(I));
          TLI:=EncodeHTMLCtx(ID,TLI+1);
          IndexEntries^.Insert(NewIndexEntry(FormatAlias(LS^.GetDocumentAlias(I,J)),ID,TLI));
        end;
      Dispose(LS, Done);
    end;
    Dispose(S, Done);
  end;
  LoadIndex:=OK;
end;

function CreateProcHTML(const FileName,Param: string): PHelpFile; {$ifndef FPC}far;{$endif}
var H: PHelpFile;
begin
  H:=nil;
  if CompareText(copy(ExtOf(FileName),1,length(extHTML)),extHTML)=0 then
    H:=New(PHTMLHelpFile, Init(FileName,0,Param));
  CreateProcHTML:=H;
end;

function CreateProcHTMLIndex(const FileName,Param: string): PHelpFile; {$ifndef FPC}far;{$endif}
var H: PHelpFile;
begin
  H:=nil;
  if CompareText(ExtOf(FileName),extHTMLIndex)=0 then
    H:=New(PHTMLIndexHelpFile, Init(FileName,0));
  CreateProcHTMLIndex:=H;
end;

procedure RegisterHelpType;
begin
  RegisterHelpFileType({$ifdef FPC}@{$endif}CreateProcHTML);
  RegisterHelpFileType({$ifdef FPC}@{$endif}CreateProcHTMLIndex);
end;


END.
{
  $Log$
  Revision 1.1  2001-08-04 11:30:25  peter
    * ide works now with both compiler versions

  Revision 1.1.2.6  2001/06/07 16:41:14  jonas
    *  updated for stricter checking of @ for procvars

  Revision 1.1.2.5  2001/03/06 22:41:21  pierre
   * avoid clipping for ansi file loading

  Revision 1.1.2.4  2000/11/27 12:06:52  pierre
   New bunch of Gabor fixes

  Revision 1.1.2.3  2000/11/16 23:13:06  pierre
   + support for ANSI substitutes to HTML images in HTML viewer

  Revision 1.1.2.2  2000/10/18 21:53:27  pierre
   * several Gabor fixes

  Revision 1.1.2.1  2000/09/18 13:20:56  pierre
   New bunch of Gabor changes

  Revision 1.1  2000/07/13 09:48:37  michael
  + Initial import

  Revision 1.15  2000/06/22 09:07:15  pierre
   * Gabor changes: see fixes.txt

  Revision 1.14  2000/06/16 08:50:45  pierre
   + new bunch of Gabor's changes

}
