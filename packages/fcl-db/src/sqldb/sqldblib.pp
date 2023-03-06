{$IFNDEF FPC_DOTTEDUNITS}
unit SQLDBLib;
{$ENDIF FPC_DOTTEDUNITS}
{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2022 by Michael van Canney and other members of the
    Free Pascal development team

    SQLDB Library Loader

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$mode objfpc}{$H+}

interface

{$IFDEF FPC_DOTTEDUNITS}
uses
  System.Classes, System.SysUtils, Data.Db, Data.Sqldb;
{$ELSE FPC_DOTTEDUNITS}
uses
  Classes, SysUtils, db, sqldb;
{$ENDIF FPC_DOTTEDUNITS}

Type

  { TSQLDBLibraryLoader }

  TSQLDBLibraryLoader = Class(TComponent)
  private
    FCType: String;
    FEnabled: Boolean;
    FLibraryName: String;
    procedure CheckDisabled;
    procedure SetCType(const AValue: String);
    procedure SetEnabled(AValue: Boolean);
    procedure SetLibraryName(const AValue: String);
  Protected
    Function GetConnectionDef : TConnectionDef;
    Procedure Loaded; override;
    Procedure SetDefaultLibraryName; virtual;
  Public
    Procedure LoadLibrary;
    Procedure UnloadLibrary;
  Published
    Property Enabled : Boolean Read FEnabled Write SetEnabled;
    Property ConnectionType : String Read FCType Write SetCType;
    Property LibraryName : String Read FLibraryName Write SetLibraryName;
  end;

implementation

Resourcestring
   SErrConnnected = 'This operation is not allowed while the datatabase is loaded';
   SErrInvalidConnectionType = 'Invalid connection type : "%s"';

{ TSQLDBLibraryLoader }

procedure TSQLDBLibraryLoader.CheckDisabled;
begin
  If not (csLoading in ComponentState) and Enabled then
    DatabaseError(SErrConnnected,Self);
end;

procedure TSQLDBLibraryLoader.SetCType(const AValue: String);
begin
  if FCType=AValue then Exit;
  CheckDisabled;
  FCType:=AValue;
  if (FCType<>'') then
    SetDefaultLibraryName;
end;

procedure TSQLDBLibraryLoader.SetEnabled(aValue: Boolean);
begin
  if FEnabled=AValue then Exit;
  if (csLoading in ComponentState) then
    FEnabled:=AValue
  else
    If AValue then
      LoadLibrary
    else
      UnloadLibrary;
end;

procedure TSQLDBLibraryLoader.SetLibraryName(const AValue: String);
begin
  if FLibraryName=AValue then Exit;
  CheckDisabled;
  FLibraryName:=AValue;
end;

function TSQLDBLibraryLoader.GetConnectionDef: TConnectionDef;
begin
  Result:={$IFDEF FPC_DOTTEDUNITS}Data.{$ENDIF}SqlDb.GetConnectionDef(ConnectionType);
  if (Result=Nil) then
    DatabaseErrorFmt(SErrInvalidConnectionType,[FCType],Self)
end;

procedure TSQLDBLibraryLoader.Loaded;
begin
  inherited;
  If FEnabled and (FCType<>'') and (FLibraryName<>'') then
    LoadLibrary;
end;

procedure TSQLDBLibraryLoader.SetDefaultLibraryName;
Var
  D : TConnectionDef;
begin
  D:=GetConnectionDef;
  LibraryName:=D.DefaultLibraryName;
end;

procedure TSQLDBLibraryLoader.LoadLibrary;

Var
  D : TConnectionDef;
  l : TLibraryLoadFunction;

begin
  D:=GetConnectionDef;
  L:=D.LoadFunction();
  if (L<>Nil) then
    L(LibraryName);
  FEnabled:=True;
end;

procedure TSQLDBLibraryLoader.UnloadLibrary;

Var
  D : TConnectionDef;
  l : TLibraryUnLoadFunction;

begin
  D:=GetConnectionDef;
  L:=D.UnLoadFunction;
  if L<>Nil then
    L;
  FEnabled:=False;
end;

end.

