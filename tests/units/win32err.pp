{
  $Id$
    This file is part of the Free Pascal test suite.
    Copyright (c) 1999-2002 by the Free Pascal development team.

    Used to avoid getting pop up windows
    under Windows Operation Systems for critical errors

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

unit win32err;

interface

implementation

{$ifdef win32}
uses
  windows;
{$endif win32}

begin
{$ifdef win32}
  SetErrorMode(
    SEM_FAILCRITICALERRORS or
    SEM_NOGPFAULTERRORBOX or
    SEM_NOOPENFILEERRORBOX);
{$endif win32}
end.

{
  $Log$
  Revision 1.1  2004-04-27 23:07:16  olle
    * moved to utils in accordance with the major makefile rework

  Revision 1.1  2003/04/29 21:12:17  pierre
   * win32 specific unit added

}
