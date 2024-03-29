{
  objcrtlutils.pas

  Copyright (C) 2009 Dmitry Boyarintsev
 
  This unit is implementation for dynamic Objective-C Run-time Library based on run-time version 2.0
  headers included with XCode 3.1.2
  The original copyright note of is kept on each include file
}

{$IFNDEF FPC_DOTTEDUNITS}
unit objcrtlutils;
{$ENDIF FPC_DOTTEDUNITS}

{$mode objfpc}{$H+}

interface

{$IFDEF FPC_DOTTEDUNITS}
uses
  Api.ObjC.Rtl;
{$ELSE FPC_DOTTEDUNITS}
uses
  objcrtl;
{$ENDIF FPC_DOTTEDUNITS}

function alloc(classname: PAnsiChar): id; inline;
function allocex(classname: PAnsiChar; extraBytes: Integer): id; inline;
function objcclass(classname: PAnsiChar): _class; inline;
function selector(cmdname: PAnsiChar): SEL; inline;
procedure release(objc: id); inline;
function AllocAndInit(classname: PAnsiChar): id; inline;
function AllocAndInitEx(classname: PAnsiChar; extraBytes: Integer): id; inline;
function super(obj: id): objc_super;

implementation

var
  SEL_alloc   : SEL = nil;
  SEL_init    : SEL = nil;
  SEL_release : SEL = nil;

function super(obj: id): objc_super;
begin
  Result.reciever := obj;
  Result.class_ := class_getSuperclass(object_getClass(obj));
end;

function allocex(classname: PAnsiChar; extraBytes: Integer): id; inline;
begin
  Result := class_createInstance( objcclass(classname), extraBytes);
end;

function alloc(classname: PAnsiChar): id; inline;
begin
  Result := allocex(classname, 0);
  // Result := objc_msgSend( objc_getClass(classname), selector('alloc'), []);
end;

function objcclass(classname: PAnsiChar): _class; inline;
begin
  Result := _class(objc_getClass(classname));
end;

function selector(cmdname: PAnsiChar): SEL; inline;
begin
  Result := sel_registerName(cmdname);
end;

procedure release(objc: id); inline;
begin
  if SEL_release=nil then SEL_release := selector('release');
  objc_msgSend(objc, SEL_release, []);
end;

function AllocAndInit(classname: PAnsiChar): id; inline;
begin
  if SEL_init=nil then SEL_init := selector('init');
  Result:= objc_msgSend( alloc( classname ), SEL_init, []);
end;

function AllocAndInitEx(classname: PAnsiChar; extraBytes: Integer): id; inline;
begin
  if SEL_init=nil then SEL_init := selector('init');
  Result := objc_msgSend( allocEx( classname, extraBytes ), SEL_init, []);
end;


end.

