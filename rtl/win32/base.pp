{
    $Id$
    This file is part of the Free Pascal run time library.
    This unit contains base definition for the Win32 API
    Copyright (c) 1993,97 by Florian Klaempfl,
    member of the Free Pascal development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$ifndef windows_include_files}
{$define read_interface}
{$define read_implementation}
{$endif not windows_include_files}


{$ifndef windows_include_files}

unit base;
interface

{$endif not windows_include_files}

{$ifdef read_interface}

  { C default packing is dword }

{$PACKRECORDS 4}
  {
     Base.h

     Base definitions

     Copyright (C) 1996, 1997 Free Software Foundation, Inc.

     Author: Scott Christley <scottc@net-community.com>

     This file is part of the Windows32 API Library.

     This library is free software; you can redistribute it and/or
     modify it under the terms of the GNU Library General Public
     License as published by the Free Software Foundation; either
     version 2 of the License, or (at your option) any later version.

     This library is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
     Library General Public License for more details.

     If you are interested in a warranty or support for this source code,
     contact Scott Christley <scottc@net-community.com> for more information.

     You should have received a copy of the GNU Library General Public
     License along with this library; see the file COPYING.LIB.
     If not, write to the Free Software Foundation,
     59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
   }

{$ifndef VER0_99_10}
  const
     NULL = nil;
{$endif}

  type

     ATOM = word;

     WINBOOL = longbool;
     BOOL = WINBOOL;

     CALTYPE = cardinal;
     CALID = cardinal;

     CCHAR = char;

     COLORREF = cardinal;

     SHORT = integer;
     INT   = longint;
     LONG  = longint;
     DWORD = cardinal;

     LONGLONG  = double;
     PLONGLONG = ^LONGLONG;

     DWORDLONG  = double;  { was unsigned long  }
     PDWORDLONG = ^DWORDLONG;

     FLOAT = real;

     HANDLE = longint;    { or should it be cardinal ?? PM }

     HACCEL = HANDLE;
     HBITMAP = HANDLE;
     HBRUSH = HANDLE;
     HCOLORSPACE = HANDLE;
     HCONV = HANDLE;
     HCONVLIST = HANDLE;
     HCURSOR = HANDLE;
     HDBC = HANDLE;
     HDC = HANDLE;
     HDDEDATA = HANDLE;
     HDESK = HANDLE;
     HDROP = HANDLE;
     HDWP = HANDLE;
     HENHMETAFILE = HANDLE;
     HENV = HANDLE;
     HFILE = HANDLE;
     HFONT = HANDLE;
     HGDIOBJ = HANDLE;
     HGLOBAL = HANDLE;
     HGLRC = HANDLE;
     HHOOK = HANDLE;
     HICON = HANDLE;
     HIMAGELIST = HANDLE;
     HINST = HANDLE;   { Not HINSTANCE, else it has problems with the var HInstance }
     HKEY = HANDLE;
     HKL = HANDLE;
     HLOCAL = HANDLE;
     HMENU = HANDLE;
     HMETAFILE = HANDLE;
     HMODULE = HANDLE;
     HPALETTE = HANDLE;
     HPEN = HANDLE;
     HRASCONN = HANDLE;
     HRESULT = HANDLE;
     HRGN = HANDLE;
     HRSRC = HANDLE;
     HSTMT = HANDLE;
     HSZ = HANDLE;
     HWINSTA = HANDLE;
     HWND = HANDLE;

     LANGID = word;
     LCID   = DWORD;
     LCTYPE = DWORD;
     LPARAM = longint;

     LP     = ^word;
     LPBOOL = ^WINBOOL;
     LPBYTE = ^BYTE;
     LPCCH  = PCHAR;
     LPCH   = PCHAR;

     LPCOLORREF = ^COLORREF;

     LPCSTR  = Pchar;
{$ifdef UNICODE}
     LPCTSTR = ^word;
{$else}
     LPCTSTR = Pchar;
{$endif}

     LPCWCH  = ^word;
     LPCWSTR = ^word;

     LPDWORD = ^DWORD;

     LPHANDLE = ^HANDLE;

     LPINT  = ^longint;
     LPLONG = ^longint;

     LPSTR = Pchar;
{$ifdef UNICODE}
     LPTCH  = ^word;
     LPTSTR = ^word;
{$else}
     LPTCH  = Pchar;
     LPTSTR = Pchar;
{$endif}

     LRESULT = longint;

     LPVOID  = pointer;
     LPCVOID = pointer;

     LPWCH  = ^word;
     LPWORD = ^word;
     LPWSTR = ^word;
     NWPSTR = ^word;

     PWINBOOL = ^WINBOOL;
     PBOOLEAN = ^BYTE;

     PBYTE = ^BYTE;

     PCCH = PCHAR;
     PCH  = PCHAR;

     PCSTR = Pchar;

     PCWCH  = ^word;
     PCWSTR = ^word;

     PDWORD = ^DWORD;

     PFLOAT = ^real;

     PHANDLE = ^HANDLE;
     PHKEY = ^HKEY;

     PINT = ^longint;
     PLONG = ^longint;
     PSHORT = ^integer;

     PSTR = Pchar;

     PSZ = Pchar;
{$ifdef UNICODE}
     PTBYTE = ^word;
     PTCH = ^word;
     PTCHAR = ^word;
     PTSTR = ^word;
{$else}
     PTBYTE = ^byte;
     PTCH   = Pchar;
     PTCHAR = Pchar;
     PTSTR  = Pchar;
{$endif}

     PUCHAR = ^byte;
     PWCH   = ^word;
     PWCHAR = ^word;

     PWORD   = ^word;
     PUINT   = ^cardinal;
     PULONG  = ^cardinal;
     PUSHORT = ^word;

     PVOID = pointer;

     RETCODE = integer;

     SC_HANDLE = HANDLE;
     SC_LOCK = LPVOID;
     LPSC_HANDLE = ^SC_HANDLE;

     SERVICE_STATUS_HANDLE = DWORD;

{$ifdef UNICODE}
     TBYTE = word;
     TCHAR = word;
     BCHAR = word;
{$else}
     TBYTE = byte;
     TCHAR = char;
     BCHAR = BYTE;
{$endif}

     UCHAR = byte;
     WCHAR = word;

     UINT   = cardinal;
     WORD   = word;
     ULONG  = cardinal;
     USHORT = word;

     WPARAM = cardinal;

{
  Enumerations
}

     ACL_INFORMATION_CLASS = (AclRevisionInformation := 1,AclSizeInformation
       );

     _ACL_INFORMATION_CLASS = ACL_INFORMATION_CLASS;

     MEDIA_TYPE = (Unknown,F5_1Pt2_512,F3_1Pt44_512,F3_2Pt88_512,
       F3_20Pt8_512,F3_720_512,F5_360_512,F5_320_512,
       F5_320_1024,F5_180_512,F5_160_512,RemovableMedia,
       FixedMedia);

     _MEDIA_TYPE = MEDIA_TYPE;

  const
     RASCS_DONE = $2000;
     RASCS_PAUSED = $1000;

  type

     RASCONNSTATE = (RASCS_OpenPort := 0,RASCS_PortOpened,
       RASCS_ConnectDevice,RASCS_DeviceConnected,
       RASCS_AllDevicesConnected,RASCS_Authenticate,
       RASCS_AuthNotify,RASCS_AuthRetry,RASCS_AuthCallback,
       RASCS_AuthChangePassword,RASCS_AuthProject,
       RASCS_AuthLinkSpeed,RASCS_AuthAck,RASCS_ReAuthenticate,
       RASCS_Authenticated,RASCS_PrepareForCallback,
       RASCS_WaitForModemReset,RASCS_WaitForCallback,
       RASCS_Projected,RASCS_StartAuthentication,
       RASCS_CallbackComplete,RASCS_LogonNetwork,
       RASCS_Interactive := RASCS_PAUSED,RASCS_RetryAuthentication,
       RASCS_CallbackSetByCaller,RASCS_PasswordExpired,
       RASCS_Connected := RASCS_DONE,RASCS_Disconnected
       );

     _RASCONNSTATE = RASCONNSTATE;

     RASPROJECTION = (RASP_Amb := $10000,RASP_PppNbf := $803F,RASP_PppIpx := $802B,
       RASP_PppIp := $8021);

     _RASPROJECTION = RASPROJECTION;

     SECURITY_IMPERSONATION_LEVEL = (SecurityAnonymous,SecurityIdentification,
       SecurityImpersonation,SecurityDelegation
       );

     _SECURITY_IMPERSONATION_LEVEL = SECURITY_IMPERSONATION_LEVEL;

     SID_NAME_USE = (SidTypeUser := 1,SidTypeGroup,SidTypeDomain,
       SidTypeAlias,SidTypeWellKnownGroup,SidTypeDeletedAccount,
       SidTypeInvalid,SidTypeUnknown);

     PSID_NAME_USE = ^SID_NAME_USE;

     _SID_NAME_USE = SID_NAME_USE;

     TOKEN_INFORMATION_CLASS = (TokenUser := 1,TokenGroups,TokenPrivileges,
       TokenOwner,TokenPrimaryGroup,TokenDefaultDacl,
       TokenSource,TokenType,TokenImpersonationLevel,
       TokenStatistics);

     _TOKEN_INFORMATION_CLASS = TOKEN_INFORMATION_CLASS;

     TOKEN_TYPE = (TokenPrimary := 1,TokenImpersonation
       );

     tagTOKEN_TYPE = TOKEN_TYPE;

 {
   Macros
 }

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function GetBValue(rgb : longint) : BYTE;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function GetGValue(rgb : longint) : BYTE;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function GetRValue(rgb : longint) : BYTE;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function RGB(r,g,b : longint) : DWORD;

  {  Not convertable by H2PAS
  #define HANDLE_WM_NOTIFY(hwnd, wParam, lParam, fn) \
      (fn)((hwnd), (int)(wParam), (NMHDR FAR )(lParam))
   }

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function HIBYTE(w : longint) : BYTE;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function HIWORD(l : longint) : WORD;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function LOBYTE(w : longint) : BYTE;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function LOWORD(l : longint) : WORD;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKELONG(a,b : longint) : LONG;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEWORD(a,b : longint) : WORD;

  { original Cygnus headers also had the following defined:  }
  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function SEXT_HIWORD(l : longint) : longint;
    { return type might be wrong }

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function ZEXT_HIWORD(l : longint) : longint;
    { return type might be wrong }

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function SEXT_LOWORD(l : longint) : longint;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function INDEXTOOVERLAYMASK(i : longint) : longint;
    { return type might be wrong }

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function INDEXTOSTATEIMAGEMASK(i : longint) : longint;
    { return type might be wrong }

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEINTATOM(i : longint) : LPTSTR;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEINTRESOURCE(i : longint) : LPTSTR;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function MAKELANGID(p,s : longint) : longint;
    { return type might be wrong }

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function PRIMARYLANGID(lgid : longint) : WORD;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function SUBLANGID(lgid : longint) : longint;
    { return type might be wrong }

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function LANGIDFROMLCID(lcid : longint) : WORD;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function SORTIDFROMLCID(lcid : longint) : WORD;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKELCID(lgid,srtid : longint) : DWORD;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKELPARAM(l,h : longint) : LPARAM;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKELRESULT(l,h : longint) : LRESULT;

  {  Not convertable by H2PAS
  #define MAKEPOINTS(l)   ( ((POINTS FAR  ) & (l)))
   }
  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEROP4(fore,back : longint) : DWORD;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEWPARAM(l,h : longint) : WPARAM;

{$ifndef max}
  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function max(a,b : longint) : longint;
    { return type might be wrong }

{$endif}
{$ifndef min}
  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function min(a,b : longint) : longint;
    { return type might be wrong }

{$endif}
  { was #define dname(params) def_expr }
  { argument types are unknown }
  function PALETTEINDEX(i : longint) : COLORREF;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function PALETTERGB(r,g,b : longint) : longint;
    { return type might be wrong }

  (*  Not convertable by H2PAS
  #define POINTSTOPOINT(pt, pts) {(pt).x = (SHORT) LOWORD(pts); \
        (pt).y = (SHORT) HIWORD(pts);}
  #define POINTTOPOINTS(pt) \
      (MAKELONG((short) ((pt).x), (short) ((pt).y)))
   *)
  { already declared before
  #define INDEXTOOVERLAYMASK(i) ((i) << 8)
  #define INDEXTOSTATEIMAGEMASK(i) ((i) << 12)
   }
  {  Not convertable by H2PAS
  #ifdef UNICODE
  #define TEXT(quote) L##quote
  #else
  #define TEXT(quote) quote
  #endif
   }

 {
    Definitions for callback procedures
 }

 type

     BFFCALLBACK = function (_para1:HWND; _para2:UINT; _para3:LPARAM; _para4:LPARAM):longint;

     LPCCHOOKPROC = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):UINT;

     LPCFHOOKPROC = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):UINT;

     PTHREAD_START_ROUTINE = function (_para1:LPVOID):DWORD;

     LPTHREAD_START_ROUTINE = PTHREAD_START_ROUTINE;

     EDITSTREAMCALLBACK = function (_para1:DWORD; _para2:LPBYTE; _para3:LONG; _para4:LONG):DWORD;

     LPFRHOOKPROC = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):UINT;

     LPOFNHOOKPROC = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):UINT;

     LPPRINTHOOKPROC = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):UINT;

     LPSETUPHOOKPROC = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):UINT;

     DLGPROC = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):LRESULT;

     PFNPROPSHEETCALLBACK = function (_para1:HWND; _para2:UINT; _para3:LPARAM):longint;

     LPSERVICE_MAIN_FUNCTION = procedure (_para1:DWORD; _para2:LPTSTR);

     PFNTVCOMPARE = function (_para1:LPARAM; _para2:LPARAM; _para3:LPARAM):longint;

     WNDPROC = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):LRESULT;

     FARPROC = pointer;

     PROC = FARPROC;

     ENUMRESTYPEPROC = function (_para1:HANDLE; _para2:LPTSTR; _para3:LONG):WINBOOL;

     ENUMRESNAMEPROC = function (_para1:HANDLE; _para2:LPCTSTR; _para3:LPTSTR; _para4:LONG):WINBOOL;

     ENUMRESLANGPROC = function (_para1:HANDLE; _para2:LPCTSTR; _para3:LPCTSTR; _para4:WORD; _para5:LONG):WINBOOL;

     DESKTOPENUMPROC = FARPROC;

     ENUMWINDOWSPROC = function (_para1:HWND; _para2:LPARAM):WINBOOL;

     ENUMWINDOWSTATIONPROC = function (_para1:LPTSTR; _para2:LPARAM):WINBOOL;

     SENDASYNCPROC = procedure (_para1:HWND; _para2:UINT; _para3:DWORD; _para4:LRESULT);

     TIMERPROC = procedure (_para1:HWND; _para2:UINT; _para3:UINT; _para4:DWORD);

     GRAYSTRINGPROC = FARPROC;

     DRAWSTATEPROC = function (_para1:HDC; _para2:LPARAM; _para3:WPARAM; _para4:longint; _para5:longint):WINBOOL;

     PROPENUMPROCEX = function (_para1:HWND; _para2:LPCTSTR; _para3:HANDLE; _para4:DWORD):WINBOOL;

     PROPENUMPROC = function (_para1:HWND; _para2:LPCTSTR; _para3:HANDLE):WINBOOL;

     HOOKPROC = function (_para1:longint; _para2:WPARAM; _para3:LPARAM):LRESULT;

     ENUMOBJECTSPROC = procedure (_para1:LPVOID; _para2:LPARAM);

     LINEDDAPROC = procedure (_para1:longint; _para2:longint; _para3:LPARAM);

     TABORTPROC = function (_para1:HDC; _para2:longint):WINBOOL;

     LPPAGEPAINTHOOK = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):UINT;

     LPPAGESETUPHOOK = function (_para1:HWND; _para2:UINT; _para3:WPARAM; _para4:LPARAM):UINT;

     ICMENUMPROC = function (_para1:LPTSTR; _para2:LPARAM):longint;

     EDITWORDBREAKPROCEX = function (_para1:pchar; _para2:LONG; _para3:BYTE; _para4:INT):LONG;CDECL;

     PFNLVCOMPARE = function (_para1:LPARAM; _para2:LPARAM; _para3:LPARAM):longint;

     LOCALE_ENUMPROC = function (_para1:LPTSTR):WINBOOL;

     CODEPAGE_ENUMPROC = function (_para1:LPTSTR):WINBOOL;

     DATEFMT_ENUMPROC = function (_para1:LPTSTR):WINBOOL;

     TIMEFMT_ENUMPROC = function (_para1:LPTSTR):WINBOOL;

     CALINFO_ENUMPROC = function (_para1:LPTSTR):WINBOOL;

     PHANDLER_ROUTINE = function (_para1:DWORD):WINBOOL;

     LPHANDLER_FUNCTION = function (_para1:DWORD):WINBOOL;

     PFNGETPROFILEPATH = function (_para1:LPCTSTR; _para2:LPSTR; _para3:UINT):UINT;

     PFNRECONCILEPROFILE = function (_para1:LPCTSTR; _para2:LPCTSTR; _para3:DWORD):UINT;

     PFNPROCESSPOLICIES = function (_para1:HWND; _para2:LPCTSTR; _para3:LPCTSTR; _para4:LPCTSTR; _para5:DWORD):WINBOOL;
  (*  Not convertable by H2PAS
  #define SECURITY_NULL_SID_AUTHORITY     {0,0,0,0,0,0}
  #define SECURITY_WORLD_SID_AUTHORITY    {0,0,0,0,0,1}
  #define SECURITY_LOCAL_SID_AUTHORITY    {0,0,0,0,0,2}
  #define SECURITY_CREATOR_SID_AUTHORITY  {0,0,0,0,0,3}
  #define SECURITY_NON_UNIQUE_AUTHORITY   {0,0,0,0,0,4}
  #define SECURITY_NT_AUTHORITY           {0,0,0,0,0,5}
   *)
  { TEXT("String") replaced by "String" below for H2PAS  }

  const
     SE_CREATE_TOKEN_NAME = 'SeCreateTokenPrivilege';
     SE_ASSIGNPRIMARYTOKEN_NAME = 'SeAssignPrimaryTokenPrivilege';
     SE_LOCK_MEMORY_NAME = 'SeLockMemoryPrivilege';
     SE_INCREASE_QUOTA_NAME = 'SeIncreaseQuotaPrivilege';
     SE_UNSOLICITED_INPUT_NAME = 'SeUnsolicitedInputPrivilege';
     SE_MACHINE_ACCOUNT_NAME = 'SeMachineAccountPrivilege';
     SE_TCB_NAME = 'SeTcbPrivilege';
     SE_SECURITY_NAME = 'SeSecurityPrivilege';
     SE_TAKE_OWNERSHIP_NAME = 'SeTakeOwnershipPrivilege';
     SE_LOAD_DRIVER_NAME = 'SeLoadDriverPrivilege';
     SE_SYSTEM_PROFILE_NAME = 'SeSystemProfilePrivilege';
     SE_SYSTEMTIME_NAME = 'SeSystemtimePrivilege';
     SE_PROF_SINGLE_PROCESS_NAME = 'SeProfileSingleProcessPrivilege';
     SE_INC_BASE_PRIORITY_NAME = 'SeIncreaseBasePriorityPrivilege';
     SE_CREATE_PAGEFILE_NAME = 'SeCreatePagefilePrivilege';
     SE_CREATE_PERMANENT_NAME = 'SeCreatePermanentPrivilege';
     SE_BACKUP_NAME = 'SeBackupPrivilege';
     SE_RESTORE_NAME = 'SeRestorePrivilege';
     SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
     SE_DEBUG_NAME = 'SeDebugPrivilege';
     SE_AUDIT_NAME = 'SeAuditPrivilege';
     SE_SYSTEM_ENVIRONMENT_NAME = 'SeSystemEnvironmentPrivilege';
     SE_CHANGE_NOTIFY_NAME = 'SeChangeNotifyPrivilege';
     SE_REMOTE_SHUTDOWN_NAME = 'SeRemoteShutdownPrivilege';
  {  Not convertable by H2PAS
  #define SERVICES_ACTIVE_DATABASEW      L"ServicesActive"
  #define SERVICES_FAILED_DATABASEW      L"ServicesFailed"
   }
     SERVICES_ACTIVE_DATABASEA = 'ServicesActive';
     SERVICES_FAILED_DATABASEA = 'ServicesFailed';
  {  Not convertable by H2PAS
  #define SC_GROUP_IDENTIFIERW           L'+'
   }
     SC_GROUP_IDENTIFIERA = '+';
{$ifdef UNICODE}
     SERVICES_ACTIVE_DATABASE = SERVICES_ACTIVE_DATABASEW;
     SERVICES_FAILED_DATABASE = SERVICES_FAILED_DATABASEW;
     SC_GROUP_IDENTIFIER = SC_GROUP_IDENTIFIERW;
{$else}
     SERVICES_ACTIVE_DATABASE = SERVICES_ACTIVE_DATABASEA;
     SERVICES_FAILED_DATABASE = SERVICES_FAILED_DATABASEA;
     SC_GROUP_IDENTIFIER = SC_GROUP_IDENTIFIERA;
{$endif}

type

     CALLB = procedure ;CDECL;

     PFNCALLBACK = CALLB;

     SECURITY_CONTEXT_TRACKING_MODE = WINBOOL;
  { End of stuff from ddeml.h in old Cygnus headers  }
  { -----------------------------------------------  }

     WNDENUMPROC = FARPROC;

     ENHMFENUMPROC = FARPROC;

     CCSTYLE = DWORD;

     PCCSTYLE = ^CCSTYLE;

     LPCCSTYLE = ^CCSTYLE;

     CCSTYLEFLAGA = DWORD;

     PCCSTYLEFLAGA = ^CCSTYLEFLAGA;

     LPCCSTYLEFLAGA = ^CCSTYLEFLAGA;

{$endif read_interface}


{$ifndef windows_include_files}
  implementation
{$endif not windows_include_files}

{$ifdef read_implementation}

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function GetBValue(rgb : longint) : BYTE;
    begin
       GetBValue:=BYTE(rgb shr 16);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function GetGValue(rgb : longint) : BYTE;
    begin
       GetGValue:=BYTE((WORD(rgb)) shr 8);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function GetRValue(rgb : longint) : BYTE;
    begin
       GetRValue:=BYTE(rgb);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function RGB(r,g,b : longint) : DWORD;
    begin
       RGB:=DWORD(((BYTE(r)) or ((WORD(g)) shl 8)) or ((DWORD(BYTE(b))) shl 16));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function HIBYTE(w : longint) : BYTE;
    begin
       HIBYTE:=BYTE(((WORD(w)) shr 8) and $FF);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function HIWORD(l : longint) : WORD;
    begin
       HIWORD:=WORD(((DWORD(l)) shr 16) and $FFFF);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function LOBYTE(w : longint) : BYTE;
    begin
       LOBYTE:=BYTE(w);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function LOWORD(l : longint) : WORD;
    begin
       LOWORD:=WORD(l);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKELONG(a,b : longint) : LONG;
    begin
       MAKELONG:=LONG((WORD(a)) or ((DWORD(WORD(b))) shl 16));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEWORD(a,b : longint) : WORD;
    begin
       MAKEWORD:=WORD((BYTE(a)) or ((WORD(BYTE(b))) shl 8));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function SEXT_HIWORD(l : longint) : longint;
    { return type might be wrong }
    begin
       SEXT_HIWORD:=(longint(l)) shr 16;
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function ZEXT_HIWORD(l : longint) : longint;
    { return type might be wrong }
    begin
       ZEXT_HIWORD:=(cardinal(l)) shr 16;
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function SEXT_LOWORD(l : longint) : longint;
    begin
       SEXT_LOWORD:=longint(integer(l));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function INDEXTOOVERLAYMASK(i : longint) : longint;
    { return type might be wrong }
    begin
       INDEXTOOVERLAYMASK:=i shl 8;
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function INDEXTOSTATEIMAGEMASK(i : longint) : longint;
    { return type might be wrong }
    begin
       INDEXTOSTATEIMAGEMASK:=i shl 12;
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEINTATOM(i : longint) : LPTSTR;
    begin
       MAKEINTATOM:=LPTSTR(DWORD(WORD(i)));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEINTRESOURCE(i : longint) : LPTSTR;
    begin
       MAKEINTRESOURCE:=LPTSTR(DWORD(WORD(i)));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function MAKELANGID(p,s : longint) : longint;
    { return type might be wrong }
    begin
       MAKELANGID:=((WORD(s)) shl 10) or (WORD(p));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function PRIMARYLANGID(lgid : longint) : WORD;
    begin
       { PRIMARYLANGID:=WORD(lgid(@($3ff)));
         h2pas error here corrected by hand PM }
       PRIMARYLANGID:=WORD(lgid) and ($3ff);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function SUBLANGID(lgid : longint) : longint;
    { return type might be wrong }
    begin
       SUBLANGID:=(WORD(lgid)) shr 10;
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function LANGIDFROMLCID(lcid : longint) : WORD;
    begin
       LANGIDFROMLCID:=WORD(lcid);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function SORTIDFROMLCID(lcid : longint) : WORD;
    begin
       SORTIDFROMLCID:=WORD(((DWORD(lcid)) and $000FFFFF) shr 16);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKELCID(lgid,srtid : longint) : DWORD;
    begin
       MAKELCID:=DWORD(((DWORD(WORD(srtid))) shl 16) or (DWORD(WORD(lgid))));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKELPARAM(l,h : longint) : LPARAM;
    begin
       MAKELPARAM:=LPARAM(MAKELONG(l,h));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKELRESULT(l,h : longint) : LRESULT;
    begin
       MAKELRESULT:=LRESULT(MAKELONG(l,h));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEROP4(fore,back : longint) : DWORD;
    begin
       MAKEROP4:=DWORD(((back shl 8) and $FF000000) or fore);
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function MAKEWPARAM(l,h : longint) : WPARAM;
    begin
       MAKEWPARAM:=WPARAM(MAKELONG(l,h));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function max(a,b : longint) : longint;
    { return type might be wrong }
    var
       if_local1 : longint;
    (* result types are not known *)
    begin
       if a > b then
         if_local1:=a
       else
         if_local1:=b;
       max:=if_local1;
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function min(a,b : longint) : longint;
    { return type might be wrong }
    var
       if_local1 : longint;
    (* result types are not known *)
    begin
       if a < b then
         if_local1:=a
       else
         if_local1:=b;
       min:=if_local1;
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  function PALETTEINDEX(i : longint) : COLORREF;
    begin
       PALETTEINDEX:=COLORREF($01000000 or (DWORD(WORD(i))));
    end;

  { was #define dname(params) def_expr }
  { argument types are unknown }
  { return type might be wrong }
  function PALETTERGB(r,g,b : longint) : longint;
    { return type might be wrong }
    begin
       PALETTERGB:=$02000000 or (RGB(r,g,b));
    end;

{$endif read_implementation}


{$ifndef windows_include_files}
end.
{$endif not windows_include_files}

{
  $Log$
  Revision 1.11  1999-03-30 17:00:22  peter
    * fixes for 0.99.10

  Revision 1.10  1999/01/09 07:29:47  florian
    * some updates to compile API units for win32

  Revision 1.9  1998/12/28 23:35:14  peter
    * small fixes for better compatibility

  Revision 1.8  1998/10/27 11:17:11  peter
    * type HINSTANCE -> HINST

  Revision 1.7  1998/09/08 14:30:03  pierre
    * WINBOOL changed from longint to longbool

  Revision 1.6  1998/09/04 17:17:32  pierre
    + all unknown function ifdef with
      conditionnal unknown_functions
      testwin works now, but windowcreate still fails !!

  Revision 1.5  1998/08/31 11:53:53  pierre
    * compilable windows.pp file
      still to do :
       - findout problems
       - findout the correct DLL for each call !!

  Revision 1.4  1998/06/10 10:39:11  peter
    * working w32 rtl

}
