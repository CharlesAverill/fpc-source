{
    This file is part of the Free Pascal Run time library.
    Copyright (c) 2022 by Michael Van Canneyt (michael@freepascal.org)

    This file contains the tests for the CSS parser

    See the File COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit tcCSSResolver;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Contnrs, fpcunit, testregistry, fpCSSParser, fpCSSTree,
  fpCSSResolver;

type
  TDemoNodeAttribute = (
    naLeft,
    naTop,
    naWidth,
    naHeight,
    naBorder,
    naDisplay,
    naColor
    );
  TDemoNodeAttributes = set of TDemoNodeAttribute;

const
  DemoAttributeNames: array[TDemoNodeAttribute] of string = (
    // case sensitive!
    'left',
    'top',
    'width',
    'height',
    'border',
    'display',
    'color'
    );

  DemoAttrIDBase = 100;

type
  TDemoPseudoClass = (
    pcActive,
    pcHover
    );
  TDemoPseudoClasses = set of TDemoPseudoClass;

type

  { TDemoNode }

  TDemoNode = class(TComponent,TCSSNode)
  private
    class var FAttributeInitialValues: array[TDemoNodeAttribute] of string;
  private
    FAttributeValues: array[TDemoNodeAttribute] of string;
    FNodes: TFPObjectList; // list of TDemoNode
    FCSSClasses: TStrings;
    FParent: TDemoNode;
    FStyleElements: TCSSElement;
    FStyle: string;
    function GetAttribute(AIndex: TDemoNodeAttribute): string;
    function GetNodeCount: integer;
    function GetNodes(Index: integer): TDemoNode;
    procedure SetAttribute(AIndex: TDemoNodeAttribute; const AValue: string);
    procedure SetParent(const AValue: TDemoNode);
    procedure SetStyleElements(const AValue: TCSSElement);
    procedure SetStyle(const AValue: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    function GetCSSID: TCSSString; virtual;
    class function CSSTypeName: TCSSString; virtual;
    function GetCSSTypeName: TCSSString;
    class function CSSTypeID: TCSSNumericalID; virtual;
    function GetCSSTypeID: TCSSNumericalID;
    class function GetAttributeInitialValue(Attr: TDemoNodeAttribute): string; virtual;
    function HasCSSClass(const aClassName: TCSSString): boolean; virtual;
    procedure SetCSSValue(AttrID: TCSSNumericalID; Value: TCSSElement); virtual;
    function GetCSSParent: TCSSNode; virtual;
    function GetCSSIndex: integer; virtual;
    function GetCSSNextSibling: TCSSNode; virtual;
    function GetCSSPreviousSibling: TCSSNode; virtual;
    function GetCSSChildCount: integer; virtual;
    function GetCSSChild(const anIndex: integer): TCSSNode; virtual;
    function HasCSSAttribute(const AttrID: TCSSNumericalID): boolean; virtual;
    function GetCSSAttribute(const AttrID: TCSSNumericalID): TCSSString; virtual;
    function HasCSSPseudoAttribute(const AttrID: TCSSNumericalID): boolean; virtual;
    function GetCSSPseudoAttribute(const AttrID: TCSSNumericalID): TCSSString; virtual;
    property Parent: TDemoNode read FParent write SetParent;
    property NodeCount: integer read GetNodeCount;
    property Nodes[Index: integer]: TDemoNode read GetNodes; default;
    property CSSClasses: TStrings read FCSSClasses;
    property StyleElements: TCSSElement read FStyleElements write SetStyleElements;
    property Style: string read FStyle write SetStyle;
    // CSS attributes
    property Left: string index naLeft read GetAttribute write SetAttribute;
    property Top: string index naTop read GetAttribute write SetAttribute;
    property Width: string index naWidth read GetAttribute write SetAttribute;
    property Height: string index naHeight read GetAttribute write SetAttribute;
    property Border: string index naBorder read GetAttribute write SetAttribute;
    property Display: string index naDisplay read GetAttribute write SetAttribute;
    property Color: string index naColor read GetAttribute write SetAttribute;
    property Attribute[Attr: TDemoNodeAttribute]: string read GetAttribute write SetAttribute;
  end;
  TDemoNodeClass = class of TDemoNode;

  { TDemoDiv }

  TDemoDiv = class(TDemoNode)
  public
    class function CSSTypeName: TCSSString; override;
    class function CSSTypeID: TCSSNumericalID; override;
  end;

  { TDemoSpan }

  TDemoSpan = class(TDemoNode)
  public
    class function CSSTypeName: TCSSString; override;
    class function CSSTypeID: TCSSNumericalID; override;
  end;

  { TDemoButton }

  TDemoButton = class(TDemoNode)
  private
    FCaption: string;
    procedure SetCaption(const AValue: string);
  public
    class var CSSCaptionID: TCSSNumericalID;
    class function CSSTypeName: TCSSString; override;
    class function CSSTypeID: TCSSNumericalID; override;
    function HasCSSAttribute(const AttrID: TCSSNumericalID): boolean; override;
    function GetCSSAttribute(const AttrID: TCSSNumericalID): TCSSString;
      override;
    procedure SetCSSValue(AttrID: TCSSNumericalID; Value: TCSSElement); override;
    property Caption: string read FCaption write SetCaption;
  end;

  { TDemoDocument }

  TDemoDocument = class(TComponent)
  private
    FNumericalIDs: array[TCSSNumericalIDKind] of TCSSNumericalIDs;
    FCSSResolver: TCSSResolver;
    FStyle: string;
    FStyleElements: TCSSElement;
    function GetNumericalIDs(Kind: TCSSNumericalIDKind): TCSSNumericalIDs;
    procedure SetNumericalIDs(Kind: TCSSNumericalIDKind;
      const AValue: TCSSNumericalIDs);
    procedure SetStyle(const AValue: string);
    procedure SetStyleElements(const AValue: TCSSElement);
  public
    Root: TDemoNode;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyStyle; virtual;
    procedure ApplyStyleToNode(Node: TDemoNode); virtual;

    property NumericalIDs[Kind: TCSSNumericalIDKind]: TCSSNumericalIDs read GetNumericalIDs write SetNumericalIDs;

    property StyleElements: TCSSElement read FStyleElements write SetStyleElements;
    property Style: string read FStyle write SetStyle;

    property CSSResolver: TCSSResolver read FCSSResolver;
  end;

  { TCustomTestCSSResolver }

  TCustomTestCSSResolver = class(TTestCase)
  Private
    FDoc: TDemoDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    property Doc: TDemoDocument read FDoc;
  end;

  { TTestCSSResolver }

  TTestCSSResolver = class(TCustomTestCSSResolver)
  published
    procedure Test_Selector_Universal;
    procedure Test_Selector_Type;
    procedure Test_Selector_Id;
    procedure Test_Selector_Class;
    procedure Test_Selector_ClassClass; // ToDo and combinator
    procedure Test_Selector_ClassSpaceClass; // ToDo descendant combinator
    procedure Test_Selector_TypeCommaType; // or combinator
    procedure Test_Selector_ClassGTClass; // child combinator
    procedure Test_Selector_TypePlusType; // adjacent sibling combinator
    procedure Test_Selector_TypeTildeType; // general sibling combinator
    procedure Test_Selector_HasAttribute;
    procedure Test_Selector_AttributeEquals;
    procedure Test_Selector_AttributeBeginsWith;
    procedure Test_Selector_AttributeEndsWith;
    procedure Test_Selector_AttributeBeginsWithHyphen;
    procedure Test_Selector_AttributeContainsWord;
    procedure Test_Selector_AttributeContainsSubstring;
    // ToDo: all
    procedure Test_Selector_Root;
    procedure Test_Selector_Empty;
    procedure Test_Selector_FirstChild;
    procedure Test_Selector_LastChild;
    // ToDo: :first-of-type
    // ToDo: :last-of-type
    // ToDo: :not(selector)
    // ToDo: nth-child(n)
    // ToDo: nth-last-child(n)
    // ToDo: nth-of-type(n)
    // ToDo: nth-last-of-type(n)
    // ToDo: :only-of-type
    // ToDo: :only-child
    // ToDo: :defined
    // ToDo: div:has(>img)
    // ToDo: div:has(+img)
    // ToDo: :is()
    // ToDo: :where()
    // ToDo: :lang()
    // ToDo: inline style
    // ToDo: specifity
  end;

function LinesToStr(const Args: array of const): string;

implementation

function LinesToStr(const Args: array of const): string;
var
  s: String;
  i: Integer;
begin
  s:='';
  for i:=Low(Args) to High(Args) do
    case Args[i].VType of
      vtChar:         s += Args[i].VChar+LineEnding;
      vtString:       s += Args[i].VString^+LineEnding;
      vtPChar:        s += Args[i].VPChar+LineEnding;
      vtWideChar:     s += AnsiString(Args[i].VWideChar)+LineEnding;
      vtPWideChar:    s += AnsiString(Args[i].VPWideChar)+LineEnding;
      vtAnsiString:   s += AnsiString(Args[i].VAnsiString)+LineEnding;
      vtWidestring:   s += AnsiString(WideString(Args[i].VWideString))+LineEnding;
      vtUnicodeString:s += AnsiString(UnicodeString(Args[i].VUnicodeString))+LineEnding;
    end;
  Result:=s;
end;

{ TCustomTestCSSResolver }

procedure TCustomTestCSSResolver.SetUp;
begin
  inherited SetUp;
  FDoc:=TDemoDocument.Create(nil);
end;

procedure TCustomTestCSSResolver.TearDown;
begin
  FreeAndNil(FDoc);
  inherited TearDown;
end;

{ TTestCSSResolver }

procedure TTestCSSResolver.Test_Selector_Universal;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Style:='* { left: 10px; }';
  Doc.ApplyStyle;
  AssertEquals('Root.left','10px',Doc.Root.Left);
end;

procedure TTestCSSResolver.Test_Selector_Type;
var
  Button: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Button:=TDemoButton.Create(Doc);
  Button.Parent:=Doc.Root;
  Doc.Style:='button { left: 11px; }';
  Doc.ApplyStyle;
  AssertEquals('Root.left','',Doc.Root.Left);
  AssertEquals('Button.left','11px',Button.Left);
end;

procedure TTestCSSResolver.Test_Selector_Id;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Button1:=TDemoButton.Create(Doc);
  Button1.Name:='Button1';
  Button1.Parent:=Doc.Root;
  Doc.Style:='#Button1 { left: 12px; }';
  Doc.ApplyStyle;
  AssertEquals('Root.left','',Doc.Root.Left);
  AssertEquals('Button1.left','12px',Button1.Left);
end;

procedure TTestCSSResolver.Test_Selector_Class;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Button1:=TDemoButton.Create(Doc);
  Button1.CSSClasses.Add('west');
  Button1.Parent:=Doc.Root;
  Doc.Style:='.west { left: 13px; }';
  Doc.ApplyStyle;
  AssertEquals('Root.left','',Doc.Root.Left);
  AssertEquals('Button1.left','13px',Button1.Left);
end;

procedure TTestCSSResolver.Test_Selector_ClassClass;
var
  Button1, Button2: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);

  Button1:=TDemoButton.Create(Doc);
  Button1.CSSClasses.Add('west');
  Button1.Parent:=Doc.Root;

  Button2:=TDemoButton.Create(Doc);
  Button2.CSSClasses.Add('west south');
  Button2.Parent:=Doc.Root;

  Doc.Style:='.west.south { left: 10px; }';
  Doc.ApplyStyle;
  AssertEquals('Root.left','',Doc.Root.Left);
  AssertEquals('Button1.left','',Button1.Left);
  AssertEquals('Button2.left','10px',Button2.Left);
end;

procedure TTestCSSResolver.Test_Selector_ClassSpaceClass;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Root.CSSClasses.Add('bird');

  Button1:=TDemoButton.Create(Doc);
  Button1.CSSClasses.Add('west');
  Button1.Parent:=Doc.Root;

  Doc.Style:='.bird .west { left: 10px; }';
  Doc.ApplyStyle;
  AssertEquals('Root.left','',Doc.Root.Left);
  AssertEquals('Button1.left','10px',Button1.Left);
end;

procedure TTestCSSResolver.Test_Selector_TypeCommaType;
var
  Button1: TDemoButton;
  Div1: TDemoDiv;
begin
  Doc.Root:=TDemoNode.Create(nil);

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;

  Div1:=TDemoDiv.Create(Doc);
  Div1.Parent:=Doc.Root;

  Doc.Style:='div, button { left: 10px; }';
  Doc.ApplyStyle;
  AssertEquals('Root.left','',Doc.Root.Left);
  AssertEquals('Button1.left','10px',Button1.Left);
  AssertEquals('Div1.left','10px',Div1.Left);
end;

procedure TTestCSSResolver.Test_Selector_ClassGTClass;
var
  Div1, Div2: TDemoDiv;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Root.CSSClasses.Add('lvl1');

  Div1:=TDemoDiv.Create(Doc);
  Div1.CSSClasses.Add('lvl2');
  Div1.Parent:=Doc.Root;

  Div2:=TDemoDiv.Create(Doc);
  Div2.CSSClasses.Add('lvl3');
  Div2.Parent:=Div1;

  Doc.Style:=LinesToStr([
  '.lvl1>.lvl2 { left: 10px; }',
  '.lvl1>.lvl3 { top: 11px; }',
  '.lvl2>.lvl3 { width: 12px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.left','',Doc.Root.Left);
  AssertEquals('Root.top','',Doc.Root.Top);
  AssertEquals('Root.width','',Doc.Root.Width);
  AssertEquals('Div1.left','10px',Div1.Left);
  AssertEquals('Div1.top','',Div1.Top);
  AssertEquals('Div1.width','',Div1.Width);
  AssertEquals('Div2.left','',Div2.Left);
  AssertEquals('Div2.top','',Div2.Top);
  AssertEquals('Div2.width','12px',Div2.Width);
end;

procedure TTestCSSResolver.Test_Selector_TypePlusType;
var
  Button1, Button2, Button3: TDemoButton;
  Div1: TDemoDiv;
begin
  Doc.Root:=TDemoNode.Create(nil);

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;

  Div1:=TDemoDiv.Create(Doc);
  Div1.Parent:=Doc.Root;

  Button2:=TDemoButton.Create(Doc);
  Button2.Parent:=Doc.Root;

  Button3:=TDemoButton.Create(Doc);
  Button3.Parent:=Doc.Root;

  Doc.Style:='div+button { left: 10px; }';
  Doc.ApplyStyle;
  AssertEquals('Root.left','',Doc.Root.Left);
  AssertEquals('Button1.left','',Button1.Left);
  AssertEquals('Div1.left','',Div1.Left);
  AssertEquals('Button2.left','10px',Button2.Left);
  AssertEquals('Button3.left','',Button3.Left);
end;

procedure TTestCSSResolver.Test_Selector_TypeTildeType;
var
  Button1, Button2, Button3: TDemoButton;
  Div1: TDemoDiv;
begin
  Doc.Root:=TDemoNode.Create(nil);

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;

  Div1:=TDemoDiv.Create(Doc);
  Div1.Parent:=Doc.Root;

  Button2:=TDemoButton.Create(Doc);
  Button2.Parent:=Doc.Root;

  Button3:=TDemoButton.Create(Doc);
  Button3.Parent:=Doc.Root;

  Doc.Style:='div~button { left: 10px; }';
  Doc.ApplyStyle;
  AssertEquals('Root.left','',Doc.Root.Left);
  AssertEquals('Button1.left','',Button1.Left);
  AssertEquals('Div1.left','',Div1.Left);
  AssertEquals('Button2.left','10px',Button2.Left);
  AssertEquals('Button3.left','10px',Button3.Left);
end;

procedure TTestCSSResolver.Test_Selector_HasAttribute;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;
  Button1.Left:='2px';

  Doc.Style:=LinesToStr([
  '[left] { top: 3px; }',
  '[caption] { width: 4px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Top','3px',Doc.Root.Top);
  AssertEquals('Root.Width','',Doc.Root.Width);
  AssertEquals('Button1.Top','3px',Button1.Top);
  AssertEquals('Button1.Width','4px',Button1.Width);
end;

procedure TTestCSSResolver.Test_Selector_AttributeEquals;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Root.Left:='2px';

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;
  Button1.Left:='3px';

  Doc.Style:=LinesToStr([
  '[left=2px] { top: 4px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Top','4px',Doc.Root.Top);
  AssertEquals('Button1.Top','',Button1.Top);
end;

procedure TTestCSSResolver.Test_Selector_AttributeBeginsWith;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Root.Left:='Foo';

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;
  Button1.Left:='Foo Bar';

  Doc.Style:=LinesToStr([
  '[left^=Fo] { top: 4px; }',
  '[left^="Foo B"] { width: 5px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Top','4px',Doc.Root.Top);
  AssertEquals('Root.Width','',Doc.Root.Width);
  AssertEquals('Button1.Top','4px',Button1.Top);
  AssertEquals('Button1.Width','5px',Button1.Width);
end;

procedure TTestCSSResolver.Test_Selector_AttributeEndsWith;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Root.Left:='Foo';

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;
  Button1.Left:='Foo Bar';

  Doc.Style:=LinesToStr([
  '[left$=o] { top: 4px; }',
  '[left$="o Bar"] { width: 5px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Top','4px',Doc.Root.Top);
  AssertEquals('Root.Width','',Doc.Root.Width);
  AssertEquals('Button1.Top','',Button1.Top);
  AssertEquals('Button1.Width','5px',Button1.Width);
end;

procedure TTestCSSResolver.Test_Selector_AttributeBeginsWithHyphen;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Root.Left:='Foo';

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;
  Button1.Left:='Foo-Bar';

  Doc.Style:=LinesToStr([
  '[left|=Foo] { top: 4px; }',
  '[left|="Fo"] { width: 5px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Top','4px',Doc.Root.Top);
  AssertEquals('Root.Width','',Doc.Root.Width);
  AssertEquals('Button1.Top','4px',Button1.Top);
  AssertEquals('Button1.Width','',Button1.Width);
end;

procedure TTestCSSResolver.Test_Selector_AttributeContainsWord;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Root.Left:='One Two Three';

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;
  Button1.Left:='Four Five';

  Doc.Style:=LinesToStr([
  '[left~=One] { top: 4px; }',
  '[left~=Two] { width: 5px; }',
  '[left~=Three] { height: 6px; }',
  '[left~="Four Five"] { color: #123; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Top','4px',Doc.Root.Top);
  AssertEquals('Root.Width','5px',Doc.Root.Width);
  AssertEquals('Root.Height','6px',Doc.Root.Height);
  AssertEquals('Root.Color','',Doc.Root.Color);
  AssertEquals('Button1.Top','',Button1.Top);
  AssertEquals('Button1.Width','',Button1.Width);
  AssertEquals('Button1.Height','',Button1.Height);
  AssertEquals('Button1.Color','#123',Button1.Color);
end;

procedure TTestCSSResolver.Test_Selector_AttributeContainsSubstring;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Root.Left:='Foo';

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;
  Button1.Left:='Foo Bar';

  Doc.Style:=LinesToStr([
  '[left*=oo] { top: 4px; }',
  '[left*="o B"] { width: 5px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Top','4px',Doc.Root.Top);
  AssertEquals('Root.Width','',Doc.Root.Width);
  AssertEquals('Button1.Top','4px',Button1.Top);
  AssertEquals('Button1.Width','5px',Button1.Width);
end;

procedure TTestCSSResolver.Test_Selector_Root;
var
  Button1: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);
  Doc.Root.Left:='Foo';

  Button1:=TDemoButton.Create(Doc);
  Button1.Parent:=Doc.Root;

  Doc.Style:=LinesToStr([
  ':root { top: 4px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Top','4px',Doc.Root.Top);
  AssertEquals('Button1.Top','',Button1.Top);
end;

procedure TTestCSSResolver.Test_Selector_Empty;
var
  Div1, Div11, Div2: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);

  Div1:=TDemoButton.Create(Doc);
  Div1.Parent:=Doc.Root;

  Div11:=TDemoButton.Create(Doc);
  Div11.Parent:=Div1;

  Div2:=TDemoButton.Create(Doc);
  Div2.Parent:=Doc.Root;

  Doc.Style:=LinesToStr([
  ':empty { left: 1px; }',
  'div:empty { top: 2px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Left','',Doc.Root.Left);
  AssertEquals('Root.Top','',Doc.Root.Top);
  AssertEquals('Div1.Left','x',Div1.Left);
  AssertEquals('Div1.Top','',Div1.Top);
  AssertEquals('Div11.Left','1px',Div1.Left);
  AssertEquals('Div11.Top','2px',Div1.Top);
  AssertEquals('Div2.Left','1px',Div1.Left);
  AssertEquals('Div2.Top','',Div1.Top);
end;

procedure TTestCSSResolver.Test_Selector_FirstChild;
var
  Div1, Div11, Div12, Div2: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);

  Div1:=TDemoButton.Create(Doc);
  Div1.Parent:=Doc.Root;

  Div11:=TDemoButton.Create(Doc);
  Div11.Parent:=Div1;

  Div12:=TDemoButton.Create(Doc);
  Div12.Parent:=Div1;

  Div2:=TDemoButton.Create(Doc);
  Div2.Parent:=Doc.Root;

  Doc.Style:=LinesToStr([
  ':first-child { left: 1px; }',
  'div:first-child { top: 2px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Left','1px',Doc.Root.Left);
  AssertEquals('Root.Top','',Doc.Root.Top);
  AssertEquals('Div1.Left','1px',Div1.Left);
  AssertEquals('Div1.Top','',Div1.Top);
  AssertEquals('Div11.Left','1px',Div1.Left);
  AssertEquals('Div11.Top','2px',Div1.Top);
  AssertEquals('Div12.Left','',Div1.Left);
  AssertEquals('Div12.Top','',Div1.Top);
  AssertEquals('Div2.Left','',Div1.Left);
  AssertEquals('Div2.Top','',Div1.Top);
end;

procedure TTestCSSResolver.Test_Selector_LastChild;
var
  Div1, Div11, Div12, Div2: TDemoButton;
begin
  Doc.Root:=TDemoNode.Create(nil);

  Div1:=TDemoButton.Create(Doc);
  Div1.Parent:=Doc.Root;

  Div11:=TDemoButton.Create(Doc);
  Div11.Parent:=Div1;

  Div12:=TDemoButton.Create(Doc);
  Div12.Parent:=Div1;

  Div2:=TDemoButton.Create(Doc);
  Div2.Parent:=Doc.Root;

  Doc.Style:=LinesToStr([
  ':last-child { left: 6px; }',
  'div:last-child { top: 7px; }',
  '']);
  Doc.ApplyStyle;
  AssertEquals('Root.Left','6px',Doc.Root.Left);
  AssertEquals('Root.Top','',Doc.Root.Top);
  AssertEquals('Div1.Left','',Div1.Left);
  AssertEquals('Div1.Top','',Div1.Top);
  AssertEquals('Div11.Left','',Div1.Left);
  AssertEquals('Div11.Top','',Div1.Top);
  AssertEquals('Div12.Left','6px',Div1.Left);
  AssertEquals('Div12.Top','7px',Div1.Top);
  AssertEquals('Div2.Left','6px',Div1.Left);
  AssertEquals('Div2.Top','',Div1.Top);
end;

{ TDemoDiv }

class function TDemoDiv.CSSTypeName: TCSSString;
begin
  Result:='div';
end;

class function TDemoDiv.CSSTypeID: TCSSNumericalID;
begin
  Result:=101;
end;

{ TDemoSpan }

class function TDemoSpan.CSSTypeName: TCSSString;
begin
  Result:='span';
end;

class function TDemoSpan.CSSTypeID: TCSSNumericalID;
begin
  Result:=102;
end;

{ TDemoButton }

procedure TDemoButton.SetCaption(const AValue: string);
begin
  if FCaption=AValue then Exit;
  FCaption:=AValue;
end;

class function TDemoButton.CSSTypeName: TCSSString;
begin
  Result:='button';
end;

class function TDemoButton.CSSTypeID: TCSSNumericalID;
begin
  Result:=103;
end;

function TDemoButton.HasCSSAttribute(const AttrID: TCSSNumericalID): boolean;
begin
  Result:=(AttrID=CSSCaptionID) or inherited HasCSSAttribute(AttrID);
end;

function TDemoButton.GetCSSAttribute(const AttrID: TCSSNumericalID): TCSSString;
begin
  if AttrID=CSSCaptionID then
    Result:=Caption
  else
    Result:=inherited GetCSSAttribute(AttrID);
end;

procedure TDemoButton.SetCSSValue(AttrID: TCSSNumericalID; Value: TCSSElement);
begin
  if AttrID=CSSCaptionID then
    SetCaption(Value.AsString)
  else
    inherited SetCSSValue(AttrID, Value);
end;

{ TDemoDocument }

procedure TDemoDocument.SetStyle(const AValue: string);
var
  ss: TStringStream;
  aParser: TCSSParser;
begin
  if FStyle=AValue then Exit;
  FStyle:=AValue;
  FreeAndNil(FStyleElements);
  aParser:=nil;
  ss:=TStringStream.Create(Style);
  try
    aParser:=TCSSParser.Create(ss);
    FStyleElements:=aParser.Parse;
  finally
    aParser.Free;
  end;
end;

function TDemoDocument.GetNumericalIDs(Kind: TCSSNumericalIDKind
  ): TCSSNumericalIDs;
begin
  Result:=FNumericalIDs[Kind];
end;

procedure TDemoDocument.SetNumericalIDs(Kind: TCSSNumericalIDKind;
  const AValue: TCSSNumericalIDs);
begin
  FNumericalIDs[Kind]:=AValue;
end;

procedure TDemoDocument.SetStyleElements(const AValue: TCSSElement);
begin
  if FStyleElements=AValue then Exit;
  FStyleElements.Free;
  FStyleElements:=AValue;
end;

constructor TDemoDocument.Create(AOwner: TComponent);
var
  Attr: TDemoNodeAttribute;
  TypeIDs, AttributeIDs: TCSSNumericalIDs;
  NumKind: TCSSNumericalIDKind;
  AttrID: TCSSNumericalID;
begin
  inherited Create(AOwner);

  for NumKind in TCSSNumericalIDKind do
    FNumericalIDs[NumKind]:=TCSSNumericalIDs.Create(NumKind);
  TypeIDs:=FNumericalIDs[nikType];
  TypeIDs['*']:=CSSTypeID_Universal;
  if TypeIDs['*']<>CSSTypeID_Universal then
    raise Exception.Create('20220909004740');

  TypeIDs[TDemoNode.CSSTypeName]:=TDemoNode.CSSTypeID;
  TypeIDs[TDemoDiv.CSSTypeName]:=TDemoDiv.CSSTypeID;
  TypeIDs[TDemoButton.CSSTypeName]:=TDemoButton.CSSTypeID;

  AttributeIDs:=FNumericalIDs[nikAttribute];
  AttributeIDs['all']:=CSSAttributeID_All;
  AttrID:=DemoAttrIDBase;
  for Attr in TDemoNodeAttribute do
  begin
    AttributeIDs[DemoAttributeNames[Attr]]:=AttrID;
    inc(AttrID);
  end;
  TDemoButton.CSSCaptionID:=AttrID;
  AttributeIDs['caption']:=AttrID;
  inc(AttrID);

  FCSSResolver:=TCSSResolver.Create;
  for NumKind in TCSSNumericalIDKind do
    CSSResolver.NumericalIDs[NumKind]:=FNumericalIDs[NumKind];

  Root:=TDemoNode.Create(Self);
  Root.Name:='Root';
end;

destructor TDemoDocument.Destroy;
var
  NumKind: TCSSNumericalIDKind;
begin
  FreeAndNil(FCSSResolver);
  FreeAndNil(Root);
  FreeAndNil(FStyleElements);
  for NumKind in TCSSNumericalIDKind do
    FreeAndNil(FNumericalIDs[NumKind]);
  inherited Destroy;
end;

procedure TDemoDocument.ApplyStyle;

  procedure Traverse(Node: TDemoNode);
  var
    i: Integer;
  begin
    ApplyStyleToNode(Node);
    for i:=0 to Node.NodeCount-1 do
      Traverse(Node[i]);
  end;

begin
  CSSResolver.Style:=StyleElements;
  Traverse(Root);
end;

procedure TDemoDocument.ApplyStyleToNode(Node: TDemoNode);
begin
  CSSResolver.Compute(Node,Node.StyleElements);
end;

{ TDemoNode }

function TDemoNode.GetAttribute(AIndex: TDemoNodeAttribute): string;
begin
  Result:=FAttributeValues[AIndex];
end;

function TDemoNode.GetNodeCount: integer;
begin
  Result:=FNodes.Count;
end;

function TDemoNode.GetNodes(Index: integer): TDemoNode;
begin
  Result:=TDemoNode(FNodes[Index]);
end;

procedure TDemoNode.SetAttribute(AIndex: TDemoNodeAttribute;
  const AValue: string);
begin
  if FAttributeValues[AIndex]=AValue then exit;
  FAttributeValues[AIndex]:=AValue;
end;

procedure TDemoNode.SetParent(const AValue: TDemoNode);
begin
  if FParent=AValue then Exit;
  if AValue=Self then
    raise Exception.Create('cycle');

  if FParent<>nil then
  begin
    FParent.FNodes.Remove(Self);
  end;
  FParent:=AValue;
  if FParent<>nil then
  begin
    FParent.FNodes.Add(Self);
    FreeNotification(FParent);
  end;
end;

procedure TDemoNode.SetStyleElements(const AValue: TCSSElement);
begin
  if FStyleElements=AValue then Exit;
  FreeAndNil(FStyleElements);
  FStyleElements:=AValue;
end;

procedure TDemoNode.SetStyle(const AValue: string);
var
  ss: TStringStream;
  aParser: TCSSParser;
begin
  if FStyle=AValue then Exit;
  FStyle:=AValue;
  FreeAndNil(FStyleElements);
  aParser:=nil;
  ss:=TStringStream.Create(Style);
  try
    aParser:=TCSSParser.Create(ss);
    FStyleElements:=aParser.Parse;
  finally
    aParser.Free;
  end;
end;

procedure TDemoNode.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if AComponent=Self then exit;
  if Operation=opRemove then
  begin
    if FNodes<>nil then
      FNodes.Remove(AComponent);
  end;
end;

constructor TDemoNode.Create(AOwner: TComponent);
var
  a: TDemoNodeAttribute;
begin
  inherited Create(AOwner);
  FNodes:=TFPObjectList.Create(false);
  FCSSClasses:=TStringList.Create;
  for a in TDemoNodeAttribute do
    FAttributeValues[a]:=FAttributeInitialValues[a];
end;

destructor TDemoNode.Destroy;
begin
  Clear;
  FreeAndNil(FNodes);
  FreeAndNil(FCSSClasses);
  inherited Destroy;
end;

procedure TDemoNode.Clear;
var
  i: Integer;
begin
  FCSSClasses.Clear;
  for i:=NodeCount-1 downto 0 do
    Nodes[i].Parent:=nil;
  FNodes.Clear;
end;

function TDemoNode.GetCSSID: TCSSString;
begin
  Result:=Name;
end;

class function TDemoNode.CSSTypeName: TCSSString;
begin
  Result:='node';
end;

class function TDemoNode.GetAttributeInitialValue(Attr: TDemoNodeAttribute
  ): string;
begin
  case Attr of
    naLeft: Result:='0px';
    naTop: Result:='0px';
    naWidth: Result:='';
    naHeight: Result:='';
    naBorder: Result:='1px';
    naDisplay: Result:='inline';
    naColor: Result:='#000';
  end;
end;

function TDemoNode.HasCSSClass(const aClassName: TCSSString): boolean;
var
  i: Integer;
begin
  for i:=0 to CSSClasses.Count-1 do
    if aClassName=CSSClasses[i] then
      exit(true);
  Result:=false;
end;

procedure TDemoNode.SetCSSValue(AttrID: TCSSNumericalID; Value: TCSSElement);
var
  Attr: TDemoNodeAttribute;
  s: TCSSString;
begin
  if (AttrID<DemoAttrIDBase) or (AttrID>ord(High(TDemoNodeAttribute))+DemoAttrIDBase) then
    raise Exception.Create('TDemoNode.SetCSSValue invalid AttrID '+IntToStr(AttrID));
  Attr:=TDemoNodeAttribute(AttrID-DemoAttrIDBase);
  s:=Value.AsString;
  {$IFDEF VerboseCSSResolver}
  writeln('TDemoNode.SetCSSValue ',DemoAttributeNames[Attr],':="',s,'"');
  {$ENDIF}
  Attribute[Attr]:=s;
end;

function TDemoNode.GetCSSParent: TCSSNode;
begin
  Result:=Parent;
end;

function TDemoNode.GetCSSIndex: integer;
begin
  if Parent=nil then
    Result:=-1
  else
    Result:=Parent.FNodes.IndexOf(Self);
end;

function TDemoNode.GetCSSNextSibling: TCSSNode;
var
  i: Integer;
begin
  i:=GetCSSIndex;
  if i>=NodeCount then
    Result:=nil
  else
    Result:=Parent.Nodes[i+1];
end;

function TDemoNode.GetCSSPreviousSibling: TCSSNode;
var
  i: Integer;
begin
  i:=GetCSSIndex;
  if i<1 then
    Result:=nil
  else
    Result:=Parent.Nodes[i-1];
end;

function TDemoNode.GetCSSChildCount: integer;
begin
  Result:=NodeCount;
end;

function TDemoNode.GetCSSChild(const anIndex: integer): TCSSNode;
begin
  Result:=Nodes[anIndex];
end;

function TDemoNode.HasCSSAttribute(const AttrID: TCSSNumericalID): boolean;
begin
  Result:=(AttrID>=DemoAttrIDBase) and (AttrID<=DemoAttrIDBase+ord(High(TDemoNodeAttribute)));
end;

function TDemoNode.GetCSSAttribute(const AttrID: TCSSNumericalID): TCSSString;
var
  Attr: TDemoNodeAttribute;
begin
  if (AttrID<DemoAttrIDBase) or (AttrID>DemoAttrIDBase+ord(High(TDemoNodeAttribute))) then
    exit('');
  Attr:=TDemoNodeAttribute(AttrID-DemoAttrIDBase);
  Result:=Attribute[Attr];
end;

function TDemoNode.HasCSSPseudoAttribute(const AttrID: TCSSNumericalID
  ): boolean;
begin
  Result:=false;
end;

function TDemoNode.GetCSSPseudoAttribute(const AttrID: TCSSNumericalID
  ): TCSSString;
begin
  Result:='';
end;

function TDemoNode.GetCSSTypeName: TCSSString;
begin
  Result:=CSSTypeName;
end;

class function TDemoNode.CSSTypeID: TCSSNumericalID;
begin
  Result:=100;
end;

function TDemoNode.GetCSSTypeID: TCSSNumericalID;
begin
  Result:=CSSTypeID;
end;

initialization
  RegisterTests([TTestCSSResolver]);
end.

