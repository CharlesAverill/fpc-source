{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Peter Vreman

    GPM (>v1.17) mouse Interface for linux

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY;without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit gpm;
interface
uses
  Unix;

{$linklib gpm}
{$linklib c}

const
  _PATH_VARRUN = '/var/run/';
  _PATH_DEV    = '/dev/';
  GPM_NODE_DIR = _PATH_VARRUN;
  GPM_NODE_DIR_MODE = 0775;
  GPM_NODE_PID  = '/var/run/gpm.pid';
  GPM_NODE_DEV  = '/dev/gpmctl';
  GPM_NODE_CTL  = GPM_NODE_DEV;
  GPM_NODE_FIFO = '/dev/gpmdata';

  GPM_B_LEFT   = 4;
  GPM_B_MIDDLE = 2;
  GPM_B_RIGHT  = 1;

type
  TGpmEtype = longint;
  TGpmMargin = longint;

const
  GPM_MOVE = 1;
  GPM_DRAG = 2;
  GPM_DOWN = 4;
  GPM_UP = 8;
  GPM_SINGLE = 16;
  GPM_DOUBLE = 32;
  GPM_TRIPLE = 64;
  GPM_MFLAG = 128;
  GPM_HARD = 256;
  GPM_ENTER = 512;
  GPM_LEAVE = 1024;

  GPM_TOP = 1;
  GPM_BOT = 2;
  GPM_LFT = 4;
  GPM_RGT = 8;

type
{$PACKRECORDS c}
     PGpmEvent = ^TGpmEvent;
     TGpmEvent = record
          buttons : byte;
          modifiers : byte;
          vc : word;
          dx : word;
          dy : word;
          x,y : word;
          wdx,wdy : word;
          EventType : TGpmEType;
          clicks : longint;
          margin : TGpmMargin;
       end;

     TGpmHandler=function(var event:TGpmEvent;clientdata:pointer):longint;cdecl;

  const
     GPM_MAGIC = $47706D4C;

  type
     PGpmConnect = ^TGpmConnect;
     TGpmConnect = record
          eventMask : word;
          defaultMask : word;
          minMod : word;
          maxMod : word;
          pid : longint;
          vc : longint;
       end;

     PGpmRoi = ^TGpmRoi;
     TGpmRoi = record
          xMin : integer;
          xMax : integer;
          yMin : integer;
          yMax : integer;
          minMod : word;
          maxMod : word;
          eventMask : word;
          owned : word;
          handler : TGpmHandler;
          clientdata : pointer;
          prev : PGpmRoi;
          next : PGpmRoi;
       end;

var
  gpm_flag           : longint;cvar;external;
  gpm_fd             : longint;cvar;external;
  gpm_hflag          : longint;cvar;external;
  gpm_morekeys       : Longbool;cvar;external;
  gpm_zerobased      : Longbool;cvar;external;
  gpm_visiblepointer : Longbool;cvar;external;
  gpm_mx             : longint;cvar;external;
  gpm_my             : longint;cvar;external;
  gpm_timeout        : TTimeVal;cvar;external;
  _gpm_buf           : array[0..0] of char;cvar;external;
  _gpm_arg           : ^word;cvar;external;
  gpm_handler        : TGpmHandler;cvar;external;
  gpm_data           : pointer;cvar;external;
  gpm_roi_handler    : TGpmHandler;cvar;external;
  gpm_roi_data       : pointer;cvar;external;
  gpm_roi            : PGpmRoi;cvar;external;
  gpm_current_roi    : PGpmRoi;cvar;external;
  gpm_consolefd      : longint;cvar;external;
  Gpm_HandleRoi      : TGpmHandler;cvar;external;

function Gpm_StrictSingle(EventType : longint) : boolean;
function Gpm_AnySingle(EventType : longint) : boolean;
function Gpm_StrictDouble(EventType : longint) : boolean;
function Gpm_AnyDouble(EventType : longint) : boolean;
function Gpm_StrictTriple(EventType : longint) : boolean;
function Gpm_AnyTriple(EventType : longint) : boolean;

function Gpm_Open(var _para1:TGpmConnect; _para2:longint):longint;cdecl;external;
function Gpm_Close:longint;cdecl;external;
function Gpm_GetEvent(var _para1:TGpmEvent):longint;cdecl;external;
{function Gpm_Getc(_para1:pFILE):longint;cdecl;external;
function Gpm_Getchar : longint;}
function Gpm_Repeat(millisec:longint):longint;cdecl;external;
function Gpm_FitValuesM(var x,y:longint; margin:longint):longint;cdecl;external;
function Gpm_FitValues(var x,y:longint):longint;cdecl;external;

{
function GPM_DRAWPOINTER(ePtr : longint) : longint;
}

function Gpm_PushRoi(x1:longint; y1:longint; X2:longint; Y2:longint; mask:longint; fun:TGpmHandler; xtradata:pointer):PGpmRoi;cdecl;external;
function Gpm_PopRoi(which:PGpmRoi):PGpmRoi;cdecl;external;
function Gpm_RaiseRoi(which:PGpmRoi; before:PGpmRoi):PGpmRoi;cdecl;external;
function Gpm_LowerRoi(which:PGpmRoi; after:PGpmRoi):PGpmRoi;cdecl;external;

{function Gpm_Wgetch:longint;cdecl;external;
function Gpm_Getch:longint;}

function Gpm_GetLibVersion(var where:longint):pchar;cdecl;external;
function Gpm_GetServerVersion(var where:longint):pchar;cdecl;external;
function Gpm_GetSnapshot(var ePtr:TGpmEvent):longint;cdecl;external;


implementation

function Gpm_StrictSingle(EventType : longint) : boolean;
begin
  Gpm_StrictSingle:=(EventType and GPM_SINGLE<>0) and not(EventType and GPM_MFLAG<>0);
end;

function Gpm_AnySingle(EventType : longint) : boolean;
begin
  Gpm_AnySingle:=(EventType and GPM_SINGLE<>0);
end;

function Gpm_StrictDouble(EventType : longint) : boolean;
begin
  Gpm_StrictDouble:=(EventType and GPM_DOUBLE<>0) and not(EventType and GPM_MFLAG<>0);
end;

function Gpm_AnyDouble(EventType : longint) : boolean;
begin
  Gpm_AnyDouble:=(EventType and GPM_DOUBLE<>0);
end;

function Gpm_StrictTriple(EventType : longint) : boolean;
begin
  Gpm_StrictTriple:=(EventType and GPM_TRIPLE<>0) and not(EventType and GPM_MFLAG<>0);
end;

function Gpm_AnyTriple(EventType : longint) : boolean;
begin
  Gpm_AnyTriple:=(EventType and GPM_TRIPLE<>0);
end;

procedure Gpm_CheckVersion;
var
  l : longint;
begin
  Gpm_GetLibVersion(l);
  if l<11700 then
   begin
     writeln('You need at least gpm 1.17');
     halt(1);
   end;
end;

end.
{
  $Log$
  Revision 1.4  2001-01-21 20:21:40  marco
   * Rename fest II. Rtl OK

  Revision 1.3  2000/11/22 22:44:08  peter
    * fixed gpmevent

  Revision 1.2  2000/09/18 13:14:50  marco
   * Global Linux +bsd to (rtl/freebsd rtl/unix rtl/linux structure)

  Revision 1.2  2000/07/13 11:33:48  michael
  + removed logs
 
}
