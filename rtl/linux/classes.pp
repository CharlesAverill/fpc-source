{
    $Id$
    This file is part of the Free Component Library (FCL)
    Copyright (c) 1999-2000 by Michael Van Canneyt and Florian Klaempfl

    Classes unit for linux

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
  sysutils,
  typinfo;

{$i classesh.inc}

implementation

uses
  BaseUnix,unix
  ;

{ OS - independent class implementations are in /inc directory. }
{$i classes.inc}


initialization
  CommonInit;

finalization
  CommonCleanup;

  if ThreadsInited then
     DoneThreads;

end.
{
  $Log$
  Revision 1.2  2003-11-10 16:54:28  marco
   * new oldlinux unit. 1_0 defines killed in some former FCL parts.

  Revision 1.1  2003/10/06 21:01:06  peter
    * moved classes unit to rtl

  Revision 1.7  2003/09/20 15:10:30  marco
   * small fixes. fcl now compiles

  Revision 1.6  2002/10/14 19:45:54  peter
    * threading switch

  Revision 1.5  2002/09/07 15:15:27  peter
    * old logs removed and tabs fixed

}
