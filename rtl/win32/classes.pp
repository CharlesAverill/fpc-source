{
    $Id$
    This file is part of the Free Component Library (FCL)
    Copyright (c) 1998 by Michael Van Canneyt and Florian Klaempfl

    Classes unit for win32

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$mode objfpc}

{ Require threading }
{$ifndef ver1_0}
  {$threading on}
{$endif ver1_0}

{ determine the type of the resource/form file }
{$define Win16Res}

unit Classes;

interface

uses
  rtlconst,
  sysutils,
  typinfo,
  windows;

{$i classesh.inc}

implementation

{ OS - independent class implementations are in /inc directory. }
{$i classes.inc}

initialization
  CommonInit;

finalization
  CommonCleanup;

end.
{
  $Log$
  Revision 1.3  2004-01-10 19:35:18  michael
  + Moved all resource strings to rtlconst/sysconst

  Revision 1.2  2003/10/07 16:20:21  florian
    * win32 now uses aliases from the windows unit for types like trect

  Revision 1.1  2003/10/06 21:01:07  peter
    * moved classes unit to rtl

  Revision 1.1  2003/10/06 20:33:58  peter
    * classes moved to rtl for 1.1
    * classes .inc and classes.pp files moved to fcl/classes for
      backwards 1.0.x compatiblity to have it in the fcl

  Revision 1.4  2002/10/14 19:46:13  peter
    * threading switch

  Revision 1.3  2002/09/07 15:15:29  peter
    * old logs removed and tabs fixed

}
