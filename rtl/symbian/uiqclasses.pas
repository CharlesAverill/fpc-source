{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2007 by contributors of the Free Pascal Compiler

    Symbian OS unit that adds common types, constants and functions
    for the Symbian API

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$IFNDEF FPC_DOTTEDUNITS}
unit uiqclasses;
{$ENDIF FPC_DOTTEDUNITS}

{$mode objfpc}{$H+}

interface

{$IFDEF FPC_DOTTEDUNITS}
uses System.CTypes;
{$ELSE FPC_DOTTEDUNITS}
uses ctypes;
{$ENDIF FPC_DOTTEDUNITS}

{$include e32def.inc}
{$include e32err.inc}
{.$include e32const.inc}
{.$include e32cmn.inc}
{.$include e32std.inc}

{ e32std.h header file }

{ User class }

function User_InfoPrint(aString: PAnsiChar): TInt; cdecl; external;

implementation

end.

