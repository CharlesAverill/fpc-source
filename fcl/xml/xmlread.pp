{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999 Sebastian Guenther

    XML reading routines.
    
    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$MODE objfpc}
{$H+}

unit xmlread;

interface

uses classes, DOM;

function ReadXMLFile(const AFileName: String): TXMLDocument;
function ReadXMLFile(var f: File): TXMLDocument;
function ReadXMLFile(var f: TStream): TXMLDocument;

function ReadDTDFile(const AFileName: String): TXMLDocument;
function ReadDTDFile(var f: File): TXMLDocument;
function ReadDTDFile(var f: TStream): TXMLDocument;


// =======================================================

implementation

uses sysutils;

const

  Letter = ['A'..'Z', 'a'..'z'];
  Digit = ['0'..'9'];
  PubidChars: set of Char = [' ', #13, #10, 'a'..'z', 'A'..'Z', '0'..'9',
    '-', '''', '(', ')', '+', ',', '.', '/', ':', '=', '?', ';', '!', '*',
    '#', '@', '$', '_', '%'];

  NmToken: set of Char = Letter + Digit + ['.', '-', '_', ':'];

type

  TSetOfChar = set of Char;

  TXMLReader = class
  protected
    doc: TXMLDocument;
    buf, BufStart: PChar;

    procedure RaiseExc(descr: String);
    function  SkipWhitespace: Boolean;
    procedure ExpectWhitespace;
    procedure ExpectString(s: String);
    function  CheckFor(s: PChar): Boolean;
    function  GetString(ValidChars: TSetOfChar): String;

    function  GetName(var s: String): Boolean;
    function  ExpectName: String;					// [5]
    procedure ExpectAttValue(attr: TDOMAttr);				// [10]
    function  ExpectPubidLiteral: String;				// [12]
    function  ParseComment(AOwner: TDOMNode): Boolean;			// [15]
    function  ParsePI: Boolean;						// [16]
    procedure ExpectProlog;			    			// [22]
    function  ParseEq: Boolean;						// [25]
    procedure ExpectEq;
    procedure ParseMisc(AOwner: TDOMNode);				// [27]
    function  ParseMarkupDecl: Boolean;					// [29]
    function  ParseElement(AOwner: TDOMNode): Boolean;			// [39]
    procedure ExpectElement(AOwner: TDOMNode);
    function  ParseReference(AOwner: TDOMNode): Boolean;		// [67]
    procedure ExpectReference(AOwner: TDOMNode);
    function  ParsePEReference: Boolean;				// [69]
    function  ParseExternalID: Boolean;					// [75]
    procedure ExpectExternalID;
    function  ParseEncodingDecl: String;    				// [80]
  public
    function ProcessXML(ABuf: PChar): TXMLDocument;    			// [1]
    function ProcessDTD(ABuf: PChar): TXMLDocument;			// ([29])
  end;



procedure TXMLReader.RaiseExc(descr: String);
var
  apos: PChar;
  x, y: Integer;
begin
  // find out the line in which the error occured
  apos := BufStart;
  x := 1;
  y := 1;
  while apos < buf do begin
    if apos[0] = #10 then begin
      Inc(y);
      x := 1;
    end else
      Inc(x);
    Inc(apos);
  end;

  raise Exception.Create('In XML reader (line ' + IntToStr(y) + ' pos ' +
    IntToStr(x) + '): ' + descr);
end;

function TXMLReader.SkipWhitespace: Boolean;
begin
  Result := False;
  while buf[0] in [#9, #10, #13, ' '] do begin
    Inc(buf);
    Result := True;
  end;
end;

procedure TXMLReader.ExpectWhitespace;
begin
  if not SkipWhitespace then
    RaiseExc('Expected whitespace');
end;

procedure TXMLReader.ExpectString(s: String);
var
  i: Integer;
  s2: PChar;
  s3: String;
begin
  for i := 1 to Length(s) do
    if buf[i - 1] <> s[i] then begin
      GetMem(s2, Length(s) + 1);
      StrLCopy(s2, buf, Length(s));
      s3 := StrPas(s2);
      FreeMem(s2, Length(s) + 1);
      RaiseExc('Expected "' + s + '", found "' + s3 + '"');
    end;
  Inc(buf, Length(s));
end;

function TXMLReader.CheckFor(s: PChar): Boolean;
begin
  if buf[0] = #0 then begin
    Result := False;
    exit;
  end;
  if StrLComp(buf, s, StrLen(s)) = 0 then begin
    Inc(buf, StrLen(s));
    Result := True;
  end else
    Result := False;
end;

function TXMLReader.GetString(ValidChars: TSetOfChar): String;
begin
  Result := '';
  while buf[0] in ValidChars do begin
    Result := Result + buf[0];
    Inc(buf);
  end;
end;

function TXMLReader.ProcessXML(ABuf: PChar): TXMLDocument;    // [1]
var
  LastNodeBeforeDoc: TDOMNode;
begin
  buf := ABuf;
  BufStart := ABuf;

  doc := TXMLDocument.Create;
  ExpectProlog;
  LastNodeBeforeDoc := doc.LastChild;
  ExpectElement(doc);
  ParseMisc(doc);

  {
  if buf[0] <> #0 then begin
    WriteLn('=== Unparsed: ===');
    //WriteLn(buf);
    WriteLn(StrLen(buf), ' chars');
  end;
  }

  Result := doc;
end;


function TXMLReader.GetName(var s: String): Boolean;    // [5]
begin
  s := '';
  if not (buf[0] in (Letter + ['_', ':'])) then begin
    Result := False;
    exit;
  end;

  s := buf[0];
  Inc(buf);
  s := s + GetString(Letter + ['0'..'9', '.', '-', '_', ':']);
  Result := True;
end;

function TXMLReader.ExpectName: String;    // [5]
begin
  if not (buf[0] in (Letter + ['_', ':'])) then
    RaiseExc('Expected letter, "_" or ":" for name, found "' + buf[0] + '"');

  Result := buf[0];
  Inc(buf);
  Result := Result + GetString(Letter + ['0'..'9', '.', '-', '_', ':']);
end;

procedure TXMLReader.ExpectAttValue(attr: TDOMAttr);    // [10]
var
  strdel: array[0..1] of Char;
  s: String;
begin
  if (buf[0] <> '''') and (buf[0] <> '"') then
    RaiseExc('Expected quotation marks');
  strdel[0] := buf[0];
  strdel[1] := #0;
  Inc(buf);
  s := '';
  while not CheckFor(strdel) do
    if not ParseReference(attr) then begin
      s := s + buf[0];
      Inc(buf);
    end else begin
      if s <> '' then begin
        attr.AppendChild(doc.CreateTextNode(s));
        s := '';
      end;
    end;

  if s <> '' then
    attr.AppendChild(doc.CreateTextNode(s));

end;

function TXMLReader.ExpectPubidLiteral: String;
begin
  Result := '';
  if CheckFor('''') then begin
    GetString(PubidChars - ['''']);
    ExpectString('''');
  end else if CheckFor('"') then begin
    GetString(PubidChars - ['"']);
    ExpectString('"');
  end else
    RaiseExc('Expected quotation marks');
end;

function TXMLReader.ParseComment(AOwner: TDOMNode): Boolean;    // [15]
var
  comment: String;
begin
  if CheckFor('<!--') then begin
    comment := '';
    while (buf[0] <> #0) and (buf[1] <> #0) and
      ((buf[0] <> '-') or (buf[1] <> '-')) do begin
      comment := comment + buf[0];
      Inc(buf);
    end;
    AOwner.AppendChild(doc.CreateComment(comment));
    ExpectString('-->');
    Result := True;
  end else
    Result := False;
end;

function TXMLReader.ParsePI: Boolean;    // [16]
var
  checkbuf: array[0..3] of char;
begin
  if CheckFor('<?') then begin
    StrLCopy(checkbuf, buf, 3);
    if UpCase(StrPas(checkbuf)) = 'XML' then
      RaiseExc('"<?xml" processing instruction not allowed here');
    ExpectName;
    if SkipWhitespace then
      while (buf[0] <> #0) and (buf[1] <> #0) and not
        ((buf[0] = '?') and (buf[1] = '>')) do Inc(buf);
    ExpectString('?>');
    Result := True;
  end else
    Result := False;
end;

procedure TXMLReader.ExpectProlog;    // [22]

  procedure ParseVersionNum;
  begin
    doc.XMLVersion :=
      GetString(['a'..'z', 'A'..'Z', '0'..'9', '_', '.', ':', '-']);
  end;

begin
  if CheckFor('<?xml') then begin
    // '<?xml' VersionInfo EncodingDecl? SDDecl? S? '?>'

    // VersionInfo: S 'version' Eq (' VersionNum ' | " VersionNum ")
    SkipWhitespace;
    ExpectString('version');
    ParseEq;
    if buf[0] = '''' then begin
      Inc(buf);
      ParseVersionNum;
      ExpectString('''');
    end else if buf[0] = '"' then begin
      Inc(buf);
      ParseVersionNum;
      ExpectString('"');
    end else
      RaiseExc('Expected single or double quotation mark');

    // EncodingDecl?
    ParseEncodingDecl;

    // SDDecl?
    SkipWhitespace;
    if CheckFor('standalone') then begin
      ExpectEq;
      if buf[0] = '''' then begin
        Inc(buf);
	if not (CheckFor('yes''') or CheckFor('no''')) then
	  RaiseExc('Expected ''yes'' or ''no''');
      end else if buf[0] = '''' then begin
        Inc(buf);
	if not (CheckFor('yes"') or CheckFor('no"')) then
	  RaiseExc('Expected "yes" or "no"');
      end;
      SkipWhitespace;
    end;

    ExpectString('?>');
  end;

  // Check for "Misc*"
  ParseMisc(doc);

  // Check for "(doctypedecl Misc*)?"    [28]
  if CheckFor('<!DOCTYPE') then begin
    SkipWhitespace;
    ExpectName;
    SkipWhitespace;
    ParseExternalID;
    SkipWhitespace;
    if CheckFor('[') then begin
      repeat
        SkipWhitespace;
      until not (ParseMarkupDecl or ParsePEReference);
      ExpectString(']');
      SkipWhitespace;
    end;
    ExpectString('>');
    ParseMisc(doc);
  end;

end;

function TXMLReader.ParseEq: Boolean;    // [25]
var
  savedbuf: PChar;
begin
  savedbuf := buf;
  SkipWhitespace;
  if buf[0] = '=' then begin
    Inc(buf);
    SkipWhitespace;
    Result := True;
  end else begin
    buf := savedbuf;
    Result := False;
  end;
end;

procedure TXMLReader.ExpectEq;
begin
  if not ParseEq then
    RaiseExc('Expected "="');
end;


// Parse "Misc*": 
//   Misc ::= Comment | PI | S

procedure TXMLReader.ParseMisc(AOwner: TDOMNode);    // [27]
begin
  repeat
    SkipWhitespace;
  until not (ParseComment(AOwner) or ParsePI);
end;

function TXMLReader.ParseMarkupDecl: Boolean;    // [29]

  function ParseElementDecl: Boolean;    // [45]

    procedure ExpectChoiceOrSeq;    // [49], [50]

      procedure ExpectCP;    // [48]
      begin
        if CheckFor('(') then
	  ExpectChoiceOrSeq
	else
	  ExpectName;
	if CheckFor('?') then
	else if CheckFor('*') then
	else if CheckFor('+') then;
      end;

    var
      delimiter: Char;
    begin
      SkipWhitespace;
      ExpectCP;
      SkipWhitespace;
      delimiter := #0;
      while not CheckFor(')') do begin
        if delimiter = #0 then begin
	  if (buf[0] = '|') or (buf[0] = ',') then
	    delimiter := buf[0]
	  else
	    RaiseExc('Expected "|" or ","');
	  Inc(buf);
	end else
	  ExpectString(delimiter);
	SkipWhitespace;
	ExpectCP;
      end;
    end;

  begin
    if CheckFor('<!ELEMENT') then begin
      ExpectWhitespace;
      ExpectName;
      ExpectWhitespace;

      // Get contentspec [46]

      if CheckFor('EMPTY') then
      else if CheckFor('ANY') then
      else if CheckFor('(') then begin
	SkipWhitespace;
	if CheckFor('#PCDATA') then begin
          // Parse Mixed section [51]
  	  SkipWhitespace;
	  if not CheckFor(')') then
	    repeat
	      ExpectString('|');
	      SkipWhitespace;
	      ExpectName;
	    until CheckFor(')*');
	end else begin
	  // Parse Children section [47]

	  ExpectChoiceOrSeq;

	  if CheckFor('?') then
	  else if CheckFor('*') then
	  else if CheckFor('+') then;
	end;
      end else
        RaiseExc('Invalid content specification');

      SkipWhitespace;
      ExpectString('>');
      Result := True;
    end else
      Result := False;
  end;

  function ParseAttlistDecl: Boolean;    // [52]
  var
    attr: TDOMAttr;
  begin
    if CheckFor('<!ATTLIST') then begin
      ExpectWhitespace;
      ExpectName;
      SkipWhitespace;
      while not CheckFor('>') do begin
        ExpectName;
	ExpectWhitespace;

        // Get AttType [54], [55], [56]
	if CheckFor('CDATA') then
	else if CheckFor('ID') then
	else if CheckFor('IDREF') then
	else if CheckFor('IDREFS') then
	else if CheckFor('ENTITTY') then
	else if CheckFor('ENTITIES') then
	else if CheckFor('NMTOKEN') then
	else if CheckFor('NMTOKENS') then
	else if CheckFor('NOTATION') then begin   // [57], [58]
	  ExpectWhitespace;
	  ExpectString('(');
	  SkipWhitespace;
	  ExpectName;
	  SkipWhitespace;
	  while not CheckFor(')') do begin
	    ExpectString('|');
	    SkipWhitespace;
	    ExpectName;
	    SkipWhitespace;
	  end;
	end else if CheckFor('(') then begin    // [59]
	  SkipWhitespace;
	  GetString(Nmtoken);
	  SkipWhitespace;
	  while not CheckFor(')') do begin
	    ExpectString('|');
	    SkipWhitespace;
	    GetString(Nmtoken);
	    SkipWhitespace;
          end;
	end else
	  RaiseExc('Invalid tokenized type');

	ExpectWhitespace;

	// Get DefaultDecl [60]
	if CheckFor('#REQUIRED') then
	else if CheckFor('#IMPLIED') then
	else begin
	  if CheckFor('#FIXED') then
	    SkipWhitespace;
	  attr := doc.CreateAttribute('');
	  ExpectAttValue(attr);
	end;

        SkipWhitespace;
      end;
      Result := True;
    end else
      Result := False;
  end;

  function ParseEntityDecl: Boolean;    // [70]
  var
    NewEntity: TDOMEntity;

    function ParseEntityValue: Boolean;    // [9]
    var
      strdel: array[0..1] of Char;
    begin
      if (buf[0] <> '''') and (buf[0] <> '"') then begin
        Result := False;
        exit;
      end;
      strdel[0] := buf[0];
      strdel[1] := #0;
      Inc(buf);
      while not CheckFor(strdel) do
        if ParsePEReference then
	else if ParseReference(NewEntity) then
	else begin
	  Inc(buf);		// Normal haracter
	end;
      Result := True;
    end;

  begin
    if CheckFor('<!ENTITY') then begin
      ExpectWhitespace;
      if CheckFor('%') then begin    // [72]
        ExpectWhitespace;
	NewEntity := doc.CreateEntity(ExpectName);
	ExpectWhitespace;
	// Get PEDef [74]
	if ParseEntityValue then
	else if ParseExternalID then
	else
	  RaiseExc('Expected entity value or external ID');
      end else begin    // [71]
        NewEntity := doc.CreateEntity(ExpectName);
	ExpectWhitespace;
	// Get EntityDef [73]
	if ParseEntityValue then
	else begin
	  ExpectExternalID;
	  // Get NDataDecl [76]
	  ExpectWhitespace;
	  ExpectString('NDATA');
	  ExpectWhitespace;
	  ExpectName;
	end;
      end;
      SkipWhitespace;
      ExpectString('>');
      Result := True;
    end else
      Result := False;
  end;

  function ParseNotationDecl: Boolean;    // [82]
  begin
    if CheckFor('<!NOTATION') then begin
      ExpectWhitespace;
      ExpectName;
      ExpectWhitespace;
      if ParseExternalID then
      else if CheckFor('PUBLIC') then begin    // [83]
        ExpectWhitespace;
	ExpectPubidLiteral;
      end else
        RaiseExc('Expected external or public ID');
      SkipWhitespace;
      ExpectString('>');
      Result := True;
    end else
      Result := False;
  end;

begin
  Result := False;
  while ParseElementDecl or ParseAttlistDecl or ParseEntityDecl or
    ParseNotationDecl or ParsePI or ParseComment(doc) or SkipWhitespace do
    Result := True;
end;

function TXMLReader.ProcessDTD(ABuf: PChar): TXMLDocument;
begin
  buf := ABuf;
  BufStart := ABuf;

  doc := TXMLDocument.Create;
  ParseMarkupDecl;

  {
  if buf[0] <> #0 then begin
    WriteLn('=== Unparsed: ===');
    //WriteLn(buf);
    WriteLn(StrLen(buf), ' chars');
  end;
  }

  Result := doc;
end;

function TXMLReader.ParseElement(AOwner: TDOMNode): Boolean;    // [39] [40] [44]
var
  NewElem: TDOMElement;

  function ParseCharData: Boolean;    // [14]
  var
    s: String;
    i: Integer;
  begin
    s := '';
    while not (buf[0] in [#0, '<', '&']) do begin
      s := s + buf[0];
      Inc(buf);
    end;
    if s <> '' then begin
      // Strip whitespace from end of s
      i := Length(s);
      while (i > 0) and (s[i] in [#10, #13, ' ']) do Dec(i);
      NewElem.AppendChild(doc.CreateTextNode(Copy(s, 1, i)));
      Result := True;
    end else
      Result := False;
  end;

  function ParseCDSect: Boolean;    // [18]
  var
    cdata: String;
  begin
    if CheckFor('<![CDATA[') then begin
      cdata := '';
      while not CheckFor(']]>') do begin
        cdata := cdata + buf[0];
        Inc(buf);
      end;
      NewElem.AppendChild(doc.CreateCDATASection(cdata));
      Result := True;
    end else
      Result := False;
  end;

var
  IsEmpty: Boolean;
  name: String;
  oldpos: PChar;

  attr: TDOMAttr;
begin
  oldpos := buf;
  if CheckFor('<') then begin
    if not GetName(name) then begin
      buf := oldpos;
      Result := False;
      exit;
    end;

    NewElem := doc.CreateElement(name);
    AOwner.AppendChild(NewElem);

    SkipWhitespace;
    IsEmpty := False;
    while True do begin
      if CheckFor('/>') then begin
        IsEmpty := True;
        break;
      end;
      if CheckFor('>') then break;

      // Get Attribute [41]
      attr := doc.CreateAttribute(ExpectName);
      NewElem.Attributes.SetNamedItem(attr);
      ExpectEq;
      ExpectAttValue(attr);

      SkipWhitespace;
    end;

    if not IsEmpty then begin
      // Get content
      while SkipWhitespace or ParseCharData or ParseCDSect or ParsePI or
        ParseComment(NewElem) or ParseElement(NewElem) or
	ParseReference(NewElem) do;

      // Get ETag [42]
      ExpectString('</');
      ExpectName;
      SkipWhitespace;
      ExpectString('>');
    end;

    Result := True;
  end else
    Result := False;
end;

procedure TXMLReader.ExpectElement(AOwner: TDOMNode);
begin
  if not ParseElement(AOwner) then
    RaiseExc('Expected element');
end;

function TXMLReader.ParsePEReference: Boolean;    // [69]
begin
  if CheckFor('%') then begin
    ExpectName;
    ExpectString(';');
    Result := True;
  end else
    Result := False;
end;

function TXMLReader.ParseReference(AOwner: TDOMNode): Boolean;    // [67] [68]
begin
  if not CheckFor('&') then begin
    Result := False;
    exit;
  end;
  if CheckFor('#') then begin    // Test for CharRef [66]
    if CheckFor('x') then begin
      // *** there must be at leat one digit
      while buf[0] in ['0'..'9', 'a'..'f', 'A'..'F'] do Inc(buf);
    end else
      // *** there must be at leat one digit
      while buf[0] in ['0'..'9'] do Inc(buf);
  end else
    AOwner.AppendChild(doc.CreateEntityReference(ExpectName));
  ExpectString(';');
  Result := True;
end;

procedure TXMLReader.ExpectReference(AOwner: TDOMNode);
begin
  if not ParseReference(AOwner) then
    RaiseExc('Expected reference ("&Name;" or "%Name;")');
end;


function TXMLReader.ParseExternalID: Boolean;    // [75]

  function GetSystemLiteral: String;
  begin
    if buf[0] = '''' then begin
      Inc(buf);
      Result := '';
      while (buf[0] <> '''') and (buf[0] <> #0) do begin
        Result := Result + buf[0];
	Inc(buf);
      end;
      ExpectString('''');
    end else if buf[0] = '"' then begin
      Inc(buf);
      Result := '';
      while (buf[0] <> '"') and (buf[0] <> #0) do begin
        Result := Result + buf[0];
	Inc(buf);
      end;
      ExpectString('"');
    end;
  end;

begin
  if CheckFor('SYSTEM') then begin
    ExpectWhitespace;
    GetSystemLiteral;
    Result := True;
  end else if CheckFor('PUBLIC') then begin
    ExpectWhitespace;
    ExpectPubidLiteral;
    ExpectWhitespace;
    GetSystemLiteral;
    Result := True;
  end else
    Result := False;
end;

procedure TXMLReader.ExpectExternalID;
begin
  if not ParseExternalID then
    RaiseExc('Expected external ID');
end;

function TXMLReader.ParseEncodingDecl: String;    // [80]

  function ParseEncName: String;
  begin
    if not (buf[0] in ['A'..'Z', 'a'..'z']) then
      RaiseExc('Expected character (A-Z, a-z)');
    Result := buf[0];
    Inc(buf);
    Result := Result + GetString(['A'..'Z', 'a'..'z', '0'..'9', '.', '_', '-']);
  end;

begin
  Result := '';
  SkipWhitespace;
  if CheckFor('encoding') then begin
    ExpectEq;
    if buf[0] = '''' then begin
      Inc(buf);
      Result := ParseEncName;
      ExpectString('''');
    end else if buf[0] = '"' then begin
      Inc(buf);
      Result := ParseEncName;
      ExpectString('"');
    end;
  end;
end;


function ReadXMLFile(var f: File): TXMLDocument;
var
  reader: TXMLReader;
  buf: PChar;
  BufSize: LongInt;
begin
  BufSize := FileSize(f) + 1;
  if BufSize <= 1 then begin
    Result := nil;
    exit;
  end;

  GetMem(buf, BufSize);
  BlockRead(f, buf^, BufSize - 1);
  buf[BufSize - 1] := #0;
  reader := TXMLReader.Create;
  Result := reader.ProcessXML(buf);
  FreeMem(buf, BufSize);
  reader.Free;
end;

function ReadXMLFile(var f: TStream): TXMLDocument;
var
  reader: TXMLReader;
  buf: PChar;
begin
  if f.Size = 0 then begin
    Result := nil;
    exit;
  end;

  GetMem(buf, f.Size + 1);
  f.Read(buf^, f.Size);
  buf[f.Size] := #0;
  reader := TXMLReader.Create;
  Result := reader.ProcessXML(buf);
  FreeMem(buf, f.Size + 1);
  reader.Free;
end;

function ReadXMLFile(const AFileName: String): TXMLDocument;
var
  stream: TFileStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead);
  Result := ReadXMLFile(stream);
  stream.Free;
end;


function ReadDTDFile(var f: File): TXMLDocument;
var
  reader: TXMLReader;
  buf: PChar;
  BufSize: LongInt;
begin
  BufSize := FileSize(f) + 1;
  if BufSize <= 1 then begin
    Result := nil;
  end;

  GetMem(buf, BufSize + 1);
  BlockRead(f, buf^, BufSize - 1);
  buf[BufSize - 1] := #0;
  reader := TXMLReader.Create;
  Result := reader.ProcessDTD(buf);
  FreeMem(buf, BufSize);
  reader.Free;
end;

function ReadDTDFile(var f: TStream): TXMLDocument;
var
  reader: TXMLReader;
  buf: PChar;
begin
  if f.Size = 0 then begin
    Result := nil;
    exit;
  end;

  GetMem(buf, f.Size + 1);
  f.Read(buf^, f.Size);
  buf[f.Size] := #0;
  reader := TXMLReader.Create;
  Result := reader.ProcessDTD(buf);
  FreeMem(buf, f.Size + 1);
  reader.Free;
end;

function ReadDTDFile(const AFileName: String): TXMLDocument;
var
  stream: TFileStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead);
  Result := ReadDTDFile(stream);
  stream.Free;
end;


end.


{
  $Log$
  Revision 1.4  1999-07-11 20:20:12  michael
  + Fixes from Sebastian Guenther

  Revision 1.3  1999/07/09 21:05:51  michael
  + fixes from Guenther Sebastian

  Revision 1.2  1999/07/09 10:42:50  michael
  * Removed debug statements

  Revision 1.1  1999/07/09 08:35:09  michael
  + Initial implementation by Sebastian Guenther

}
