{
    $Id$
    This file is part of the Free Component Library

    XHTML helper classes
    Copyright (c) 2000 by
      Areca Systems GmbH / Sebastian Guenther, sg@freepascal.org

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}


unit XHTML;

{$MODE objfpc}
{$H+}

interface

uses DOM;

type

  TXHTMLTitleElement = class(TDOMElement);

  TXHTMLHeadElement = class(TDOMElement)
  private
    function GetTitleElement: TXHTMLTitleElement;
  public
    function RequestTitleElement: TXHTMLTitleElement;
    property TitleElement: TXHTMLTitleElement read GetTitleElement;
  end;

  TXHTMLBodyElement = class(TDOMElement);


  TXHTMLType = (xhtmlStrict, xhtmlTransitional);

  TXHTMLDocument = class(TXMLDocument)
  private
    function GetHeadElement: TXHTMLHeadElement;
    function GetBodyElement: TXHTMLBodyElement;
  public
    procedure CreateRoot(XHTMLType: TXHTMLType);
    function RequestHeadElement: TXHTMLHeadElement;
    function RequestBodyElement(const Lang: DOMString): TXHTMLBodyElement;
    property HeadElement: TXHTMLHeadElement read GetHeadElement;
    property BodyElement: TXHTMLBodyElement read GetBodyElement;
  end;



implementation


function TXHTMLHeadElement.RequestTitleElement: TXHTMLTitleElement;
begin
  Result := TitleElement;
  if not Assigned(Result) then
  begin
    Result := TXHTMLTitleElement(OwnerDocument.CreateElement('title'));
    AppendChild(Result);
  end;
end;

function TXHTMLHeadElement.GetTitleElement: TXHTMLTitleElement;
begin
  Result := TXHTMLTitleElement(FindNode('title'));
end;


procedure TXHTMLDocument.CreateRoot(XHTMLType: TXHTMLType);
var
  s: DOMString;
  HtmlEl: TDOMElement;
begin
  case XHTMLType of
    xhtmlStrict:
      s := 'html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd"';
    xhtmlTransitional:
      s := 'html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd"';
  end;
  AppendChild(CreateProcessingInstruction('DOCTYPE', s));
  HtmlEl := CreateElement('html');
  AppendChild(HtmlEl);
  HtmlEl['xmlns'] := 'http://www.w3.org/1999/xhtml';
end;

function TXHTMLDocument.RequestHeadElement: TXHTMLHeadElement;
begin
  Result := HeadElement;
  if not Assigned(Result) then
  begin
    Result := TXHTMLHeadElement(CreateElement('head'));
    DocumentElement.AppendChild(Result);
  end;
end;

function TXHTMLDocument.RequestBodyElement(const Lang: DOMString):
  TXHTMLBodyElement;
begin
  Result := BodyElement;
  if not Assigned(Result) then
  begin
    Result := TXHTMLBodyElement(CreateElement('body'));
    DocumentElement.AppendChild(Result);
    Result['xmlns'] := 'http://www.w3.org/1999/xhtml';
    Result['xml:lang'] := Lang;
    Result['lang'] := Lang;
  end;
end;

function TXHTMLDocument.GetHeadElement: TXHTMLHeadElement;
begin
  Result := TXHTMLHeadElement(DocumentElement.FindNode('head'));
end;

function TXHTMLDocument.GetBodyElement: TXHTMLBodyElement;
begin
  Result := TXHTMLBodyElement(DocumentElement.FindNode('body'));
end;


end.


{
  $Log$
  Revision 1.1  2000-10-03 20:33:22  sg
  * Added new Units "htmwrite" and "xhtml"

}
