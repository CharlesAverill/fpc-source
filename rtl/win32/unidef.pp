{
    $Id$
    This file is part of the Free Pascal run time library.
    This unit contains the record definition for the Win32 API
    Copyright (c) 1993,97 by Florian KLaempfl,
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

unit unidef;

{  Automatically converted by H2PAS.EXE from unicfun.h
   Utility made by Florian Klaempfl 25th-28th september 96
   Improvements made by Mark A. Malakanov 22nd-25th may 97 
   Further improvements by Michael Van Canneyt, April 1998 
   define handling and error recovery by Pierre Muller, June 1998 }


  interface

   uses
      base,defines,struct;

{$endif not windows_include_files}

{$ifdef read_interface}

  { C default packing is dword }

{$PACKRECORDS 4}
  { 
     UnicodeFunctions.h
  
     Declarations for all the Windows32 API Unicode Functions
  
     Copyright (C) 1996 Free Software Foundation, Inc.
  
     Author:  Scott Christley <scottc@net-community.com>
     Date: 1996
     
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
{$ifndef _GNU_H_WINDOWS32_UNICODEFUNCFIONSDEFAULT}
{$define _GNU_H_WINDOWS32_UNICODEFUNCFIONSDEFAULT}
{ C++ extern C conditionnal removed }
  { __cplusplus  }

  function GetBinaryType(lpApplicationName:LPCWSTR; lpBinaryType:LPDWORD):WINBOOL;

  function GetShortPathName(lpszLongPath:LPCWSTR; lpszShortPath:LPWSTR; cchBuffer:DWORD):DWORD;

  function GetEnvironmentStrings : LPWSTR;

  function FreeEnvironmentStrings(_para1:LPWSTR):WINBOOL;

  function FormatMessage(dwFlags:DWORD; lpSource:LPCVOID; dwMessageId:DWORD; dwLanguageId:DWORD; lpBuffer:LPWSTR; 
             nSize:DWORD; var Arguments:va_list):DWORD;

  function CreateMailslot(lpName:LPCWSTR; nMaxMessageSize:DWORD; lReadTimeout:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):HANDLE;

  function lstrcmp(lpString1:LPCWSTR; lpString2:LPCWSTR):longint;

  function lstrcmpi(lpString1:LPCWSTR; lpString2:LPCWSTR):longint;

  function lstrcpyn(lpString1:LPWSTR; lpString2:LPCWSTR; iMaxLength:longint):LPWSTR;

  function lstrcpy(lpString1:LPWSTR; lpString2:LPCWSTR):LPWSTR;

  function lstrcat(lpString1:LPWSTR; lpString2:LPCWSTR):LPWSTR;

  function lstrlen(lpString:LPCWSTR):longint;

  function CreateMutex(lpMutexAttributes:LPSECURITY_ATTRIBUTES; bInitialOwner:WINBOOL; lpName:LPCWSTR):HANDLE;

  function OpenMutex(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE;

  function CreateEvent(lpEventAttributes:LPSECURITY_ATTRIBUTES; bManualReset:WINBOOL; bInitialState:WINBOOL; lpName:LPCWSTR):HANDLE;

  function OpenEvent(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE;

  function CreateSemaphore(lpSemaphoreAttributes:LPSECURITY_ATTRIBUTES; lInitialCount:LONG; lMaximumCount:LONG; lpName:LPCWSTR):HANDLE;

  function OpenSemaphore(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE;

  function CreateFileMapping(hFile:HANDLE; lpFileMappingAttributes:LPSECURITY_ATTRIBUTES; flProtect:DWORD; dwMaximumSizeHigh:DWORD; dwMaximumSizeLow:DWORD; 
             lpName:LPCWSTR):HANDLE;

  function OpenFileMapping(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE;

  function GetLogicalDriveStrings(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD;

  function LoadLibrary(lpLibFileName:LPCWSTR):HINSTANCE;

  function LoadLibraryEx(lpLibFileName:LPCWSTR; hFile:HANDLE; dwFlags:DWORD):HINSTANCE;

  function GetModuleFileName(hModule:HINSTANCE; lpFilename:LPWSTR; nSize:DWORD):DWORD;

  function GetModuleHandle(lpModuleName:LPCWSTR):HMODULE;

  procedure FatalAppExit(uAction:UINT; lpMessageText:LPCWSTR);

  function GetCommandLine : LPWSTR;

  function GetEnvironmentVariable(lpName:LPCWSTR; lpBuffer:LPWSTR; nSize:DWORD):DWORD;

  function SetEnvironmentVariable(lpName:LPCWSTR; lpValue:LPCWSTR):WINBOOL;

  function ExpandEnvironmentStrings(lpSrc:LPCWSTR; lpDst:LPWSTR; nSize:DWORD):DWORD;

  procedure OutputDebugString(lpOutputString:LPCWSTR);

  function FindResource(hModule:HINSTANCE; lpName:LPCWSTR; lpType:LPCWSTR):HRSRC;

  function FindResourceEx(hModule:HINSTANCE; lpType:LPCWSTR; lpName:LPCWSTR; wLanguage:WORD):HRSRC;

  function EnumResourceTypes(hModule:HINSTANCE; lpEnumFunc:ENUMRESTYPEPROC; lParam:LONG):WINBOOL;

  function EnumResourceNames(hModule:HINSTANCE; lpType:LPCWSTR; lpEnumFunc:ENUMRESNAMEPROC; lParam:LONG):WINBOOL;

  function EnumResourceLanguages(hModule:HINSTANCE; lpType:LPCWSTR; lpName:LPCWSTR; lpEnumFunc:ENUMRESLANGPROC; lParam:LONG):WINBOOL;

  function BeginUpdateResource(pFileName:LPCWSTR; bDeleteExistingResources:WINBOOL):HANDLE;

  function UpdateResource(hUpdate:HANDLE; lpType:LPCWSTR; lpName:LPCWSTR; wLanguage:WORD; lpData:LPVOID; 
             cbData:DWORD):WINBOOL;

  function EndUpdateResource(hUpdate:HANDLE; fDiscard:WINBOOL):WINBOOL;

  function GlobalAddAtom(lpString:LPCWSTR):ATOM;

  function GlobalFindAtom(lpString:LPCWSTR):ATOM;

  function GlobalGetAtomName(nAtom:ATOM; lpBuffer:LPWSTR; nSize:longint):UINT;

  function AddAtom(lpString:LPCWSTR):ATOM;

  function FindAtom(lpString:LPCWSTR):ATOM;

  function GetAtomName(nAtom:ATOM; lpBuffer:LPWSTR; nSize:longint):UINT;

  function GetProfileInt(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; nDefault:INT):UINT;

  function GetProfileString(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpDefault:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD):DWORD;

  function WriteProfileString(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpString:LPCWSTR):WINBOOL;

  function GetProfileSection(lpAppName:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD):DWORD;

  function WriteProfileSection(lpAppName:LPCWSTR; lpString:LPCWSTR):WINBOOL;

  function GetPrivateProfileInt(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; nDefault:INT; lpFileName:LPCWSTR):UINT;

  function GetPrivateProfileString(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpDefault:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD; 
             lpFileName:LPCWSTR):DWORD;

  function WritePrivateProfileString(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpString:LPCWSTR; lpFileName:LPCWSTR):WINBOOL;

  function GetPrivateProfileSection(lpAppName:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD; lpFileName:LPCWSTR):DWORD;

  function WritePrivateProfileSection(lpAppName:LPCWSTR; lpString:LPCWSTR; lpFileName:LPCWSTR):WINBOOL;

  function GetDriveType(lpRootPathName:LPCWSTR):UINT;

  function GetSystemDirectory(lpBuffer:LPWSTR; uSize:UINT):UINT;

  function GetTempPath(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD;

  function GetTempFileName(lpPathName:LPCWSTR; lpPrefixString:LPCWSTR; uUnique:UINT; lpTempFileName:LPWSTR):UINT;

  function GetWindowsDirectory(lpBuffer:LPWSTR; uSize:UINT):UINT;

  function SetCurrentDirectory(lpPathName:LPCWSTR):WINBOOL;

  function GetCurrentDirectory(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD;

  function GetDiskFreeSpace(lpRootPathName:LPCWSTR; lpSectorsPerCluster:LPDWORD; lpBytesPerSector:LPDWORD; lpNumberOfFreeClusters:LPDWORD; lpTotalNumberOfClusters:LPDWORD):WINBOOL;

  function CreateDirectory(lpPathName:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):WINBOOL;

  function CreateDirectoryEx(lpTemplateDirectory:LPCWSTR; lpNewDirectory:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):WINBOOL;

  function RemoveDirectory(lpPathName:LPCWSTR):WINBOOL;

  function GetFullPathName(lpFileName:LPCWSTR; nBufferLength:DWORD; lpBuffer:LPWSTR; var lpFilePart:LPWSTR):DWORD;

  function DefineDosDevice(dwFlags:DWORD; lpDeviceName:LPCWSTR; lpTargetPath:LPCWSTR):WINBOOL;

  function QueryDosDevice(lpDeviceName:LPCWSTR; lpTargetPath:LPWSTR; ucchMax:DWORD):DWORD;

  function CreateFile(lpFileName:LPCWSTR; dwDesiredAccess:DWORD; dwShareMode:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES; dwCreationDisposition:DWORD; 
             dwFlagsAndAttributes:DWORD; hTemplateFile:HANDLE):HANDLE;

  function SetFileAttributes(lpFileName:LPCWSTR; dwFileAttributes:DWORD):WINBOOL;

  function GetFileAttributes(lpFileName:LPCWSTR):DWORD;

  function GetCompressedFileSize(lpFileName:LPCWSTR; lpFileSizeHigh:LPDWORD):DWORD;

  function DeleteFile(lpFileName:LPCWSTR):WINBOOL;

  function SearchPath(lpPath:LPCWSTR; lpFileName:LPCWSTR; lpExtension:LPCWSTR; nBufferLength:DWORD; lpBuffer:LPWSTR; 
             var lpFilePart:LPWSTR):DWORD;

  function CopyFile(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR; bFailIfExists:WINBOOL):WINBOOL;

  function MoveFile(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR):WINBOOL;

  function MoveFileEx(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR; dwFlags:DWORD):WINBOOL;

  function CreateNamedPipe(lpName:LPCWSTR; dwOpenMode:DWORD; dwPipeMode:DWORD; nMaxInstances:DWORD; nOutBufferSize:DWORD; 
             nInBufferSize:DWORD; nDefaultTimeOut:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):HANDLE;

  function GetNamedPipeHandleState(hNamedPipe:HANDLE; lpState:LPDWORD; lpCurInstances:LPDWORD; lpMaxCollectionCount:LPDWORD; lpCollectDataTimeout:LPDWORD; 
             lpUserName:LPWSTR; nMaxUserNameSize:DWORD):WINBOOL;

  function CallNamedPipe(lpNamedPipeName:LPCWSTR; lpInBuffer:LPVOID; nInBufferSize:DWORD; lpOutBuffer:LPVOID; nOutBufferSize:DWORD; 
             lpBytesRead:LPDWORD; nTimeOut:DWORD):WINBOOL;

  function WaitNamedPipe(lpNamedPipeName:LPCWSTR; nTimeOut:DWORD):WINBOOL;

  function SetVolumeLabel(lpRootPathName:LPCWSTR; lpVolumeName:LPCWSTR):WINBOOL;

  function GetVolumeInformation(lpRootPathName:LPCWSTR; lpVolumeNameBuffer:LPWSTR; nVolumeNameSize:DWORD; lpVolumeSerialNumber:LPDWORD; lpMaximumComponentLength:LPDWORD; 
             lpFileSystemFlags:LPDWORD; lpFileSystemNameBuffer:LPWSTR; nFileSystemNameSize:DWORD):WINBOOL;

  function ClearEventLog(hEventLog:HANDLE; lpBackupFileName:LPCWSTR):WINBOOL;

  function BackupEventLog(hEventLog:HANDLE; lpBackupFileName:LPCWSTR):WINBOOL;

  function OpenEventLog(lpUNCServerName:LPCWSTR; lpSourceName:LPCWSTR):HANDLE;

  function RegisterEventSource(lpUNCServerName:LPCWSTR; lpSourceName:LPCWSTR):HANDLE;

  function OpenBackupEventLog(lpUNCServerName:LPCWSTR; lpFileName:LPCWSTR):HANDLE;

  function ReadEventLog(hEventLog:HANDLE; dwReadFlags:DWORD; dwRecordOffset:DWORD; lpBuffer:LPVOID; nNumberOfBytesToRead:DWORD; 
             var pnBytesRead:DWORD; var pnMinNumberOfBytesNeeded:DWORD):WINBOOL;

  function ReportEvent(hEventLog:HANDLE; wType:WORD; wCategory:WORD; dwEventID:DWORD; lpUserSid:PSID; 
             wNumStrings:WORD; dwDataSize:DWORD; var lpStrings:LPCWSTR; lpRawData:LPVOID):WINBOOL;

  function AccessCheckAndAuditAlarm(SubsystemName:LPCWSTR; HandleId:LPVOID; ObjectTypeName:LPWSTR; ObjectName:LPWSTR; SecurityDescriptor:PSECURITY_DESCRIPTOR; 
             DesiredAccess:DWORD; GenericMapping:PGENERIC_MAPPING; ObjectCreation:WINBOOL; GrantedAccess:LPDWORD; AccessStatus:LPBOOL; 
             pfGenerateOnClose:LPBOOL):WINBOOL;

  function ObjectOpenAuditAlarm(SubsystemName:LPCWSTR; HandleId:LPVOID; ObjectTypeName:LPWSTR; ObjectName:LPWSTR; pSecurityDescriptor:PSECURITY_DESCRIPTOR; 
             ClientToken:HANDLE; DesiredAccess:DWORD; GrantedAccess:DWORD; Privileges:PPRIVILEGE_SET; ObjectCreation:WINBOOL; 
             AccessGranted:WINBOOL; GenerateOnClose:LPBOOL):WINBOOL;

  function ObjectPrivilegeAuditAlarm(SubsystemName:LPCWSTR; HandleId:LPVOID; ClientToken:HANDLE; DesiredAccess:DWORD; Privileges:PPRIVILEGE_SET; 
             AccessGranted:WINBOOL):WINBOOL;

  function ObjectCloseAuditAlarm(SubsystemName:LPCWSTR; HandleId:LPVOID; GenerateOnClose:WINBOOL):WINBOOL;

  function PrivilegedServiceAuditAlarm(SubsystemName:LPCWSTR; ServiceName:LPCWSTR; ClientToken:HANDLE; Privileges:PPRIVILEGE_SET; AccessGranted:WINBOOL):WINBOOL;

  function SetFileSecurity(lpFileName:LPCWSTR; SecurityInformation:SECURITY_INFORMATION; pSecurityDescriptor:PSECURITY_DESCRIPTOR):WINBOOL;

  function GetFileSecurity(lpFileName:LPCWSTR; RequestedInformation:SECURITY_INFORMATION; pSecurityDescriptor:PSECURITY_DESCRIPTOR; nLength:DWORD; lpnLengthNeeded:LPDWORD):WINBOOL;

  function FindFirstChangeNotification(lpPathName:LPCWSTR; bWatchSubtree:WINBOOL; dwNotifyFilter:DWORD):HANDLE;

  function IsBadStringPtr(lpsz:LPCWSTR; ucchMax:UINT):WINBOOL;

  function LookupAccountSid(lpSystemName:LPCWSTR; Sid:PSID; Name:LPWSTR; cbName:LPDWORD; ReferencedDomainName:LPWSTR; 
             cbReferencedDomainName:LPDWORD; peUse:PSID_NAME_USE):WINBOOL;

  function LookupAccountName(lpSystemName:LPCWSTR; lpAccountName:LPCWSTR; Sid:PSID; cbSid:LPDWORD; ReferencedDomainName:LPWSTR; 
             cbReferencedDomainName:LPDWORD; peUse:PSID_NAME_USE):WINBOOL;

  function LookupPrivilegeValue(lpSystemName:LPCWSTR; lpName:LPCWSTR; lpLuid:PLUID):WINBOOL;

  function LookupPrivilegeName(lpSystemName:LPCWSTR; lpLuid:PLUID; lpName:LPWSTR; cbName:LPDWORD):WINBOOL;

  function LookupPrivilegeDisplayName(lpSystemName:LPCWSTR; lpName:LPCWSTR; lpDisplayName:LPWSTR; cbDisplayName:LPDWORD; lpLanguageId:LPDWORD):WINBOOL;

  function BuildCommDCB(lpDef:LPCWSTR; lpDCB:LPDCB):WINBOOL;

  function BuildCommDCBAndTimeouts(lpDef:LPCWSTR; lpDCB:LPDCB; lpCommTimeouts:LPCOMMTIMEOUTS):WINBOOL;

  function CommConfigDialog(lpszName:LPCWSTR; hWnd:HWND; lpCC:LPCOMMCONFIG):WINBOOL;

  function GetDefaultCommConfig(lpszName:LPCWSTR; lpCC:LPCOMMCONFIG; lpdwSize:LPDWORD):WINBOOL;

  function SetDefaultCommConfig(lpszName:LPCWSTR; lpCC:LPCOMMCONFIG; dwSize:DWORD):WINBOOL;

  function GetComputerName(lpBuffer:LPWSTR; nSize:LPDWORD):WINBOOL;

  function SetComputerName(lpComputerName:LPCWSTR):WINBOOL;

  function GetUserName(lpBuffer:LPWSTR; nSize:LPDWORD):WINBOOL;

  function wvsprintf(_para1:LPWSTR; _para2:LPCWSTR; arglist:va_list):longint;

  { variable number of args not yet implemented in FPC
  function wsprintf(_para1:LPWSTR; _para2:LPCWSTR; ...):longint;}

  function LoadKeyboardLayout(pwszKLID:LPCWSTR; Flags:UINT):HKL;

  function GetKeyboardLayoutName(pwszKLID:LPWSTR):WINBOOL;

  function CreateDesktop(lpszDesktop:LPWSTR; lpszDevice:LPWSTR; pDevmode:LPDEVMODE; dwFlags:DWORD; dwDesiredAccess:DWORD; 
             lpsa:LPSECURITY_ATTRIBUTES):HDESK;

  function OpenDesktop(lpszDesktop:LPWSTR; dwFlags:DWORD; fInherit:WINBOOL; dwDesiredAccess:DWORD):HDESK;

  function EnumDesktops(hwinsta:HWINSTA; lpEnumFunc:DESKTOPENUMPROC; lParam:LPARAM):WINBOOL;

  function CreateWindowStation(lpwinsta:LPWSTR; dwReserved:DWORD; dwDesiredAccess:DWORD; lpsa:LPSECURITY_ATTRIBUTES):HWINSTA;

  function OpenWindowStation(lpszWinSta:LPWSTR; fInherit:WINBOOL; dwDesiredAccess:DWORD):HWINSTA;

  function EnumWindowStations(lpEnumFunc:ENUMWINDOWSTATIONPROC; lParam:LPARAM):WINBOOL;

  function GetUserObjectInformation(hObj:HANDLE; nIndex:longint; pvInfo:PVOID; nLength:DWORD; lpnLengthNeeded:LPDWORD):WINBOOL;

  function SetUserObjectInformation(hObj:HANDLE; nIndex:longint; pvInfo:PVOID; nLength:DWORD):WINBOOL;

  function RegisterWindowMessage(lpString:LPCWSTR):UINT;

  function GetMessage(lpMsg:LPMSG; hWnd:HWND; wMsgFilterMin:UINT; wMsgFilterMax:UINT):WINBOOL;

(* Const before type ignored *)
  function DispatchMessage(var lpMsg:MSG):LONG;

  function PeekMessage(lpMsg:LPMSG; hWnd:HWND; wMsgFilterMin:UINT; wMsgFilterMax:UINT; wRemoveMsg:UINT):WINBOOL;

  function SendMessage(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function SendMessageTimeout(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM; fuFlags:UINT; 
             uTimeout:UINT; lpdwResult:LPDWORD):LRESULT;

  function SendNotifyMessage(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL;

  function SendMessageCallback(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM; lpResultCallBack:SENDASYNCPROC; 
             dwData:DWORD):WINBOOL;

  function PostMessage(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL;

  function PostThreadMessage(idThread:DWORD; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL;

  function DefWindowProc(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function CallWindowProc(lpPrevWndFunc:WNDPROC; hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

(* Const before type ignored *)
  function RegisterClass(var lpWndClass:WNDCLASS):ATOM;

  function UnregisterClass(lpClassName:LPCWSTR; hInstance:HINSTANCE):WINBOOL;

  function GetClassInfo(hInstance:HINSTANCE; lpClassName:LPCWSTR; lpWndClass:LPWNDCLASS):WINBOOL;

(* Const before type ignored *)
  function RegisterClassEx(var _para1:WNDCLASSEX):ATOM;

  function GetClassInfoEx(_para1:HINSTANCE; _para2:LPCWSTR; _para3:LPWNDCLASSEX):WINBOOL;

  function CreateWindowEx(dwExStyle:DWORD; lpClassName:LPCWSTR; lpWindowName:LPCWSTR; dwStyle:DWORD; X:longint; 
             Y:longint; nWidth:longint; nHeight:longint; hWndParent:HWND; hMenu:HMENU; 
             hInstance:HINSTANCE; lpParam:LPVOID):HWND;

  function CreateDialogParam(hInstance:HINSTANCE; lpTemplateName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):HWND;

  function CreateDialogIndirectParam(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):HWND;

  function DialogBoxParam(hInstance:HINSTANCE; lpTemplateName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):longint;

  function DialogBoxIndirectParam(hInstance:HINSTANCE; hDialogTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):longint;

  function SetDlgItemText(hDlg:HWND; nIDDlgItem:longint; lpString:LPCWSTR):WINBOOL;

  function GetDlgItemText(hDlg:HWND; nIDDlgItem:longint; lpString:LPWSTR; nMaxCount:longint):UINT;

  function SendDlgItemMessage(hDlg:HWND; nIDDlgItem:longint; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LONG;

  function DefDlgProc(hDlg:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function CallMsgFilter(lpMsg:LPMSG; nCode:longint):WINBOOL;

  function RegisterClipboardFormat(lpszFormat:LPCWSTR):UINT;

  function GetClipboardFormatName(format:UINT; lpszFormatName:LPWSTR; cchMaxCount:longint):longint;

  function CharToOem(lpszSrc:LPCWSTR; lpszDst:LPSTR):WINBOOL;

  function OemToChar(lpszSrc:LPCSTR; lpszDst:LPWSTR):WINBOOL;

  function CharToOemBuff(lpszSrc:LPCWSTR; lpszDst:LPSTR; cchDstLength:DWORD):WINBOOL;

  function OemToCharBuff(lpszSrc:LPCSTR; lpszDst:LPWSTR; cchDstLength:DWORD):WINBOOL;

  function CharUpper(lpsz:LPWSTR):LPWSTR;

  function CharUpperBuff(lpsz:LPWSTR; cchLength:DWORD):DWORD;

  function CharLower(lpsz:LPWSTR):LPWSTR;

  function CharLowerBuff(lpsz:LPWSTR; cchLength:DWORD):DWORD;

  function CharNext(lpsz:LPCWSTR):LPWSTR;

  function CharPrev(lpszStart:LPCWSTR; lpszCurrent:LPCWSTR):LPWSTR;

  function IsCharAlpha(ch:WCHAR):WINBOOL;

  function IsCharAlphaNumeric(ch:WCHAR):WINBOOL;

  function IsCharUpper(ch:WCHAR):WINBOOL;

  function IsCharLower(ch:WCHAR):WINBOOL;

  function GetKeyNameText(lParam:LONG; lpString:LPWSTR; nSize:longint):longint;

  function VkKeyScan(ch:WCHAR):SHORT;

  function VkKeyScanEx(ch:WCHAR; dwhkl:HKL):SHORT;

  function MapVirtualKey(uCode:UINT; uMapType:UINT):UINT;

  function MapVirtualKeyEx(uCode:UINT; uMapType:UINT; dwhkl:HKL):UINT;

  function LoadAccelerators(hInstance:HINSTANCE; lpTableName:LPCWSTR):HACCEL;

  function CreateAcceleratorTable(_para1:LPACCEL; _para2:longint):HACCEL;

  function CopyAcceleratorTable(hAccelSrc:HACCEL; lpAccelDst:LPACCEL; cAccelEntries:longint):longint;

  function TranslateAccelerator(hWnd:HWND; hAccTable:HACCEL; lpMsg:LPMSG):longint;

  function LoadMenu(hInstance:HINSTANCE; lpMenuName:LPCWSTR):HMENU;

(* Const before type ignored *)
  function LoadMenuIndirect(var lpMenuTemplate:MENUTEMPLATE):HMENU;

  function ChangeMenu(hMenu:HMENU; cmd:UINT; lpszNewItem:LPCWSTR; cmdInsert:UINT; flags:UINT):WINBOOL;

  function GetMenuString(hMenu:HMENU; uIDItem:UINT; lpString:LPWSTR; nMaxCount:longint; uFlag:UINT):longint;

  function InsertMenu(hMenu:HMENU; uPosition:UINT; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL;

  function AppendMenu(hMenu:HMENU; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL;

  function ModifyMenu(hMnu:HMENU; uPosition:UINT; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL;

  function InsertMenuItem(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPCMENUITEMINFO):WINBOOL;

  function GetMenuItemInfo(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPMENUITEMINFO):WINBOOL;

  function SetMenuItemInfo(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPCMENUITEMINFO):WINBOOL;

  function DrawText(hDC:HDC; lpString:LPCWSTR; nCount:longint; lpRect:LPRECT; uFormat:UINT):longint;

  function DrawTextEx(_para1:HDC; _para2:LPWSTR; _para3:longint; _para4:LPRECT; _para5:UINT; 
             _para6:LPDRAWTEXTPARAMS):longint;

  function GrayString(hDC:HDC; hBrush:HBRUSH; lpOutputFunc:GRAYSTRINGPROC; lpData:LPARAM; nCount:longint; 
             X:longint; Y:longint; nWidth:longint; nHeight:longint):WINBOOL;

  function DrawState(_para1:HDC; _para2:HBRUSH; _para3:DRAWSTATEPROC; _para4:LPARAM; _para5:WPARAM; 
             _para6:longint; _para7:longint; _para8:longint; _para9:longint; _para10:UINT):WINBOOL;

  function TabbedTextOut(hDC:HDC; X:longint; Y:longint; lpString:LPCWSTR; nCount:longint; 
             nTabPositions:longint; lpnTabStopPositions:LPINT; nTabOrigin:longint):LONG;

  function GetTabbedTextExtent(hDC:HDC; lpString:LPCWSTR; nCount:longint; nTabPositions:longint; lpnTabStopPositions:LPINT):DWORD;

  function SetProp(hWnd:HWND; lpString:LPCWSTR; hData:HANDLE):WINBOOL;

  function GetProp(hWnd:HWND; lpString:LPCWSTR):HANDLE;

  function RemoveProp(hWnd:HWND; lpString:LPCWSTR):HANDLE;

  function EnumPropsEx(hWnd:HWND; lpEnumFunc:PROPENUMPROCEX; lParam:LPARAM):longint;

  function EnumProps(hWnd:HWND; lpEnumFunc:PROPENUMPROC):longint;

  function SetWindowText(hWnd:HWND; lpString:LPCWSTR):WINBOOL;

  function GetWindowText(hWnd:HWND; lpString:LPWSTR; nMaxCount:longint):longint;

  function GetWindowTextLength(hWnd:HWND):longint;

  function MessageBox(hWnd:HWND; lpText:LPCWSTR; lpCaption:LPCWSTR; uType:UINT):longint;

  function MessageBoxEx(hWnd:HWND; lpText:LPCWSTR; lpCaption:LPCWSTR; uType:UINT; wLanguageId:WORD):longint;

  function MessageBoxIndirect(_para1:LPMSGBOXPARAMS):longint;

  function GetWindowLong(hWnd:HWND; nIndex:longint):LONG;

  function SetWindowLong(hWnd:HWND; nIndex:longint; dwNewLong:LONG):LONG;

  function GetClassLong(hWnd:HWND; nIndex:longint):DWORD;

  function SetClassLong(hWnd:HWND; nIndex:longint; dwNewLong:LONG):DWORD;

  function FindWindow(lpClassName:LPCWSTR; lpWindowName:LPCWSTR):HWND;

  function FindWindowEx(_para1:HWND; _para2:HWND; _para3:LPCWSTR; _para4:LPCWSTR):HWND;

  function GetClassName(hWnd:HWND; lpClassName:LPWSTR; nMaxCount:longint):longint;

  function SetWindowsHookEx(idHook:longint; lpfn:HOOKPROC; hmod:HINSTANCE; dwThreadId:DWORD):HHOOK;

  function LoadBitmap(hInstance:HINSTANCE; lpBitmapName:LPCWSTR):HBITMAP;

  function LoadCursor(hInstance:HINSTANCE; lpCursorName:LPCWSTR):HCURSOR;

  function LoadCursorFromFile(lpFileName:LPCWSTR):HCURSOR;

  function LoadIcon(hInstance:HINSTANCE; lpIconName:LPCWSTR):HICON;

  function LoadImage(_para1:HINSTANCE; _para2:LPCWSTR; _para3:UINT; _para4:longint; _para5:longint; 
             _para6:UINT):HANDLE;

  function LoadString(hInstance:HINSTANCE; uID:UINT; lpBuffer:LPWSTR; nBufferMax:longint):longint;

  function IsDialogMessage(hDlg:HWND; lpMsg:LPMSG):WINBOOL;

  function DlgDirList(hDlg:HWND; lpPathSpec:LPWSTR; nIDListBox:longint; nIDStaticPath:longint; uFileType:UINT):longint;

  function DlgDirSelectEx(hDlg:HWND; lpString:LPWSTR; nCount:longint; nIDListBox:longint):WINBOOL;

  function DlgDirListComboBox(hDlg:HWND; lpPathSpec:LPWSTR; nIDComboBox:longint; nIDStaticPath:longint; uFiletype:UINT):longint;

  function DlgDirSelectComboBoxEx(hDlg:HWND; lpString:LPWSTR; nCount:longint; nIDComboBox:longint):WINBOOL;

  function DefFrameProc(hWnd:HWND; hWndMDIClient:HWND; uMsg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function DefMDIChildProc(hWnd:HWND; uMsg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function CreateMDIWindow(lpClassName:LPWSTR; lpWindowName:LPWSTR; dwStyle:DWORD; X:longint; Y:longint; 
             nWidth:longint; nHeight:longint; hWndParent:HWND; hInstance:HINSTANCE; lParam:LPARAM):HWND;

  function WinHelp(hWndMain:HWND; lpszHelp:LPCWSTR; uCommand:UINT; dwData:DWORD):WINBOOL;

  function ChangeDisplaySettings(lpDevMode:LPDEVMODE; dwFlags:DWORD):LONG;

  function EnumDisplaySettings(lpszDeviceName:LPCWSTR; iModeNum:DWORD; lpDevMode:LPDEVMODE):WINBOOL;

  function SystemParametersInfo(uiAction:UINT; uiParam:UINT; pvParam:PVOID; fWinIni:UINT):WINBOOL;

  function AddFontResource(_para1:LPCWSTR):longint;

  function CopyMetaFile(_para1:HMETAFILE; _para2:LPCWSTR):HMETAFILE;

(* Const before type ignored *)
  function CreateFontIndirect(var _para1:LOGFONT):HFONT;

  function CreateFont(_para1:longint; _para2:longint; _para3:longint; _para4:longint; _para5:longint; 
             _para6:DWORD; _para7:DWORD; _para8:DWORD; _para9:DWORD; _para10:DWORD; 
             _para11:DWORD; _para12:DWORD; _para13:DWORD; _para14:LPCWSTR):HFONT;

(* Const before type ignored *)
  function CreateIC(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR; var _para4:DEVMODE):HDC;

  function CreateMetaFile(_para1:LPCWSTR):HDC;

  function CreateScalableFontResource(_para1:DWORD; _para2:LPCWSTR; _para3:LPCWSTR; _para4:LPCWSTR):WINBOOL;

(* Const before type ignored *)
  function DeviceCapabilities(_para1:LPCWSTR; _para2:LPCWSTR; _para3:WORD; _para4:LPWSTR; var _para5:DEVMODE):longint;

  function EnumFontFamiliesEx(_para1:HDC; _para2:LPLOGFONT; _para3:FONTENUMEXPROC; _para4:LPARAM; _para5:DWORD):longint;

  function EnumFontFamilies(_para1:HDC; _para2:LPCWSTR; _para3:FONTENUMPROC; _para4:LPARAM):longint;

  function EnumFonts(_para1:HDC; _para2:LPCWSTR; _para3:ENUMFONTSPROC; _para4:LPARAM):longint;

  function GetCharWidth(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPINT):WINBOOL;

  function GetCharWidth32(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPINT):WINBOOL;

  function GetCharWidthFloat(_para1:HDC; _para2:UINT; _para3:UINT; _para4:PFLOAT):WINBOOL;

  function GetCharABCWidths(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPABC):WINBOOL;

  function GetCharABCWidthsFloat(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPABCFLOAT):WINBOOL;

(* Const before type ignored *)
  function GetGlyphOutline(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPGLYPHMETRICS; _para5:DWORD; 
             _para6:LPVOID; var _para7:MAT2):DWORD;

  function GetMetaFile(_para1:LPCWSTR):HMETAFILE;

  function GetOutlineTextMetrics(_para1:HDC; _para2:UINT; _para3:LPOUTLINETEXTMETRIC):UINT;

  function GetTextExtentPoint(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:LPSIZE):WINBOOL;

  function GetTextExtentPoint32(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:LPSIZE):WINBOOL;

  function GetTextExtentExPoint(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:longint; _para5:LPINT; 
             _para6:LPINT; _para7:LPSIZE):WINBOOL;

  function GetCharacterPlacement(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:longint; _para5:LPGCP_RESULTS; 
             _para6:DWORD):DWORD;

(* Const before type ignored *)
  function ResetDC(_para1:HDC; var _para2:DEVMODE):HDC;

  function RemoveFontResource(_para1:LPCWSTR):WINBOOL;

  function CopyEnhMetaFile(_para1:HENHMETAFILE; _para2:LPCWSTR):HENHMETAFILE;

(* Const before type ignored *)
  function CreateEnhMetaFile(_para1:HDC; _para2:LPCWSTR; var _para3:RECT; _para4:LPCWSTR):HDC;

  function GetEnhMetaFile(_para1:LPCWSTR):HENHMETAFILE;

  function GetEnhMetaFileDescription(_para1:HENHMETAFILE; _para2:UINT; _para3:LPWSTR):UINT;

  function GetTextMetrics(_para1:HDC; _para2:LPTEXTMETRIC):WINBOOL;

(* Const before type ignored *)
  function StartDoc(_para1:HDC; var _para2:DOCINFO):longint;

  function GetObject(_para1:HGDIOBJ; _para2:longint; _para3:LPVOID):longint;

  function TextOut(_para1:HDC; _para2:longint; _para3:longint; _para4:LPCWSTR; _para5:longint):WINBOOL;

(* Const before type ignored *)
(* Const before type ignored *)
  function ExtTextOut(_para1:HDC; _para2:longint; _para3:longint; _para4:UINT; var _para5:RECT; 
             _para6:LPCWSTR; _para7:UINT; var _para8:INT):WINBOOL;

(* Const before type ignored *)
  function PolyTextOut(_para1:HDC; var _para2:POLYTEXT; _para3:longint):WINBOOL;

  function GetTextFace(_para1:HDC; _para2:longint; _para3:LPWSTR):longint;

  function GetKerningPairs(_para1:HDC; _para2:DWORD; _para3:LPKERNINGPAIR):DWORD;

  function GetLogColorSpace(_para1:HCOLORSPACE; _para2:LPLOGCOLORSPACE; _para3:DWORD):WINBOOL;

  function CreateColorSpace(_para1:LPLOGCOLORSPACE):HCOLORSPACE;

  function GetICMProfile(_para1:HDC; _para2:DWORD; _para3:LPWSTR):WINBOOL;

  function SetICMProfile(_para1:HDC; _para2:LPWSTR):WINBOOL;

  function UpdateICMRegKey(_para1:DWORD; _para2:DWORD; _para3:LPWSTR; _para4:UINT):WINBOOL;

  function EnumICMProfiles(_para1:HDC; _para2:ICMENUMPROC; _para3:LPARAM):longint;

  function CreatePropertySheetPage(lppsp:LPCPROPSHEETPAGE):HPROPSHEETPAGE;

  function PropertySheet(lppsph:LPCPROPSHEETHEADER):longint;

  function ImageList_LoadImage(hi:HINSTANCE; lpbmp:LPCWSTR; cx:longint; cGrow:longint; crMask:COLORREF; 
             uType:UINT; uFlags:UINT):HIMAGELIST;

  function CreateStatusWindow(style:LONG; lpszText:LPCWSTR; hwndParent:HWND; wID:UINT):HWND;

  procedure DrawStatusText(hDC:HDC; lprc:LPRECT; pszText:LPCWSTR; uFlags:UINT);

  function GetOpenFileName(_para1:LPOPENFILENAME):WINBOOL;

  function GetSaveFileName(_para1:LPOPENFILENAME):WINBOOL;

  function GetFileTitle(_para1:LPCWSTR; _para2:LPWSTR; _para3:WORD):integer;

  function ChooseColor(_para1:LPCHOOSECOLOR):WINBOOL;

  function ReplaceText(_para1:LPFINDREPLACE):HWND;

  function ChooseFont(_para1:LPCHOOSEFONT):WINBOOL;

  function FindText(_para1:LPFINDREPLACE):HWND;

  function PrintDlg(_para1:LPPRINTDLG):WINBOOL;

  function PageSetupDlg(_para1:LPPAGESETUPDLG):WINBOOL;

  function CreateProcess(lpApplicationName:LPCWSTR; lpCommandLine:LPWSTR; lpProcessAttributes:LPSECURITY_ATTRIBUTES; lpThreadAttributes:LPSECURITY_ATTRIBUTES; bInheritHandles:WINBOOL; 
             dwCreationFlags:DWORD; lpEnvironment:LPVOID; lpCurrentDirectory:LPCWSTR; lpStartupInfo:LPSTARTUPINFO; lpProcessInformation:LPPROCESS_INFORMATION):WINBOOL;

  procedure GetStartupInfo(lpStartupInfo:LPSTARTUPINFO);

  function FindFirstFile(lpFileName:LPCWSTR; lpFindFileData:LPWIN32_FIND_DATA):HANDLE;

  function FindNextFile(hFindFile:HANDLE; lpFindFileData:LPWIN32_FIND_DATA):WINBOOL;

  function GetVersionEx(lpVersionInformation:LPOSVERSIONINFO):WINBOOL;

  { was #define dname(params) def_expr }
  function CreateWindow(lpClassName:LPCWSTR; lpWindowName:LPCWSTR; dwStyle:DWORD; X:longint;
             Y:longint; nWidth:longint; nHeight:longint; hWndParent:HWND; hMenu:HMENU; 
             hInstance:HINSTANCE; lpParam:LPVOID):HWND;

  { was #define dname(params) def_expr }
  function CreateDialog(hInstance:HINSTANCE; lpName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC):HWND;

  { was #define dname(params) def_expr }
  function CreateDialogIndirect(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC):HWND;

  { was #define dname(params) def_expr }
  function DialogBox(hInstance:HINSTANCE; lpTemplate:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC):longint;

  { was #define dname(params) def_expr }
  function DialogBoxIndirect(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC):longint;

(* Const before type ignored *)
  function CreateDC(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR; var _para4:DEVMODE):HDC;

  function CreateFontA(_para1:longint; _para2:longint; _para3:longint; _para4:longint; _para5:longint; 
             _para6:DWORD; _para7:DWORD; _para8:DWORD; _para9:DWORD; _para10:DWORD; 
             _para11:DWORD; _para12:DWORD; _para13:DWORD; _para14:LPCSTR):HFONT;

  function VerInstallFile(uFlags:DWORD; szSrcFileName:LPWSTR; szDestFileName:LPWSTR; szSrcDir:LPWSTR; szDestDir:LPWSTR; 
             szCurDir:LPWSTR; szTmpFile:LPWSTR; lpuTmpFileLen:PUINT):DWORD;

  function GetFileVersionInfoSize(lptstrFilename:LPWSTR; lpdwHandle:LPDWORD):DWORD;

  function GetFileVersionInfo(lptstrFilename:LPWSTR; dwHandle:DWORD; dwLen:DWORD; lpData:LPVOID):WINBOOL;

  function VerLanguageName(wLang:DWORD; szLang:LPWSTR; nSize:DWORD):DWORD;

(* Const before type ignored *)
  function VerQueryValue(pBlock:LPVOID; lpSubBlock:LPWSTR; var lplpBuffer:LPVOID; puLen:PUINT):WINBOOL;

  function VerFindFile(uFlags:DWORD; szFileName:LPWSTR; szWinDir:LPWSTR; szAppDir:LPWSTR; szCurDir:LPWSTR; 
             lpuCurDirLen:PUINT; szDestDir:LPWSTR; lpuDestDirLen:PUINT):DWORD;

(* Const before type ignored *)
  function RegSetValueEx(hKey:HKEY; lpValueName:LPCWSTR; Reserved:DWORD; dwType:DWORD; var lpData:BYTE; 
             cbData:DWORD):LONG;

  function RegUnLoadKey(hKey:HKEY; lpSubKey:LPCWSTR):LONG;

  function InitiateSystemShutdown(lpMachineName:LPWSTR; lpMessage:LPWSTR; dwTimeout:DWORD; bForceAppsClosed:WINBOOL; bRebootAfterShutdown:WINBOOL):WINBOOL;

  function AbortSystemShutdown(lpMachineName:LPWSTR):WINBOOL;

  function RegRestoreKey(hKey:HKEY; lpFile:LPCWSTR; dwFlags:DWORD):LONG;

  function RegSaveKey(hKey:HKEY; lpFile:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):LONG;

  function RegSetValue(hKey:HKEY; lpSubKey:LPCWSTR; dwType:DWORD; lpData:LPCWSTR; cbData:DWORD):LONG;

  function RegQueryValue(hKey:HKEY; lpSubKey:LPCWSTR; lpValue:LPWSTR; lpcbValue:PLONG):LONG;

  function RegQueryMultipleValues(hKey:HKEY; val_list:PVALENT; num_vals:DWORD; lpValueBuf:LPWSTR; ldwTotsize:LPDWORD):LONG;

  function RegQueryValueEx(hKey:HKEY; lpValueName:LPCWSTR; lpReserved:LPDWORD; lpType:LPDWORD; lpData:LPBYTE; 
             lpcbData:LPDWORD):LONG;

  function RegReplaceKey(hKey:HKEY; lpSubKey:LPCWSTR; lpNewFile:LPCWSTR; lpOldFile:LPCWSTR):LONG;

  function RegConnectRegistry(lpMachineName:LPWSTR; hKey:HKEY; phkResult:PHKEY):LONG;

  function RegCreateKey(hKey:HKEY; lpSubKey:LPCWSTR; phkResult:PHKEY):LONG;

  function RegCreateKeyEx(hKey:HKEY; lpSubKey:LPCWSTR; Reserved:DWORD; lpClass:LPWSTR; dwOptions:DWORD; 
             samDesired:REGSAM; lpSecurityAttributes:LPSECURITY_ATTRIBUTES; phkResult:PHKEY; lpdwDisposition:LPDWORD):LONG;

  function RegDeleteKey(hKey:HKEY; lpSubKey:LPCWSTR):LONG;

  function RegDeleteValue(hKey:HKEY; lpValueName:LPCWSTR):LONG;

  function RegEnumKey(hKey:HKEY; dwIndex:DWORD; lpName:LPWSTR; cbName:DWORD):LONG;

  function RegEnumKeyEx(hKey:HKEY; dwIndex:DWORD; lpName:LPWSTR; lpcbName:LPDWORD; lpReserved:LPDWORD; 
             lpClass:LPWSTR; lpcbClass:LPDWORD; lpftLastWriteTime:PFILETIME):LONG;

  function RegEnumValue(hKey:HKEY; dwIndex:DWORD; lpValueName:LPWSTR; lpcbValueName:LPDWORD; lpReserved:LPDWORD; 
             lpType:LPDWORD; lpData:LPBYTE; lpcbData:LPDWORD):LONG;

  function RegLoadKey(hKey:HKEY; lpSubKey:LPCWSTR; lpFile:LPCWSTR):LONG;

  function RegOpenKey(hKey:HKEY; lpSubKey:LPCWSTR; phkResult:PHKEY):LONG;

  function RegOpenKeyEx(hKey:HKEY; lpSubKey:LPCWSTR; ulOptions:DWORD; samDesired:REGSAM; phkResult:PHKEY):LONG;

  function RegQueryInfoKey(hKey:HKEY; lpClass:LPWSTR; lpcbClass:LPDWORD; lpReserved:LPDWORD; lpcSubKeys:LPDWORD; 
             lpcbMaxSubKeyLen:LPDWORD; lpcbMaxClassLen:LPDWORD; lpcValues:LPDWORD; lpcbMaxValueNameLen:LPDWORD; lpcbMaxValueLen:LPDWORD; 
             lpcbSecurityDescriptor:LPDWORD; lpftLastWriteTime:PFILETIME):LONG;

  function CompareString(Locale:LCID; dwCmpFlags:DWORD; lpString1:LPCWSTR; cchCount1:longint; lpString2:LPCWSTR; 
             cchCount2:longint):longint;

  function LCMapString(Locale:LCID; dwMapFlags:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpDestStr:LPWSTR; 
             cchDest:longint):longint;

  function GetLocaleInfo(Locale:LCID; LCType:LCTYPE; lpLCData:LPWSTR; cchData:longint):longint;

  function SetLocaleInfo(Locale:LCID; LCType:LCTYPE; lpLCData:LPCWSTR):WINBOOL;

(* Const before type ignored *)
  function GetTimeFormat(Locale:LCID; dwFlags:DWORD; var lpTime:SYSTEMTIME; lpFormat:LPCWSTR; lpTimeStr:LPWSTR; 
             cchTime:longint):longint;

(* Const before type ignored *)
  function GetDateFormat(Locale:LCID; dwFlags:DWORD; var lpDate:SYSTEMTIME; lpFormat:LPCWSTR; lpDateStr:LPWSTR; 
             cchDate:longint):longint;

(* Const before type ignored *)
  function GetNumberFormat(Locale:LCID; dwFlags:DWORD; lpValue:LPCWSTR; var lpFormat:NUMBERFMT; lpNumberStr:LPWSTR; 
             cchNumber:longint):longint;

(* Const before type ignored *)
  function GetCurrencyFormat(Locale:LCID; dwFlags:DWORD; lpValue:LPCWSTR; var lpFormat:CURRENCYFMT; lpCurrencyStr:LPWSTR; 
             cchCurrency:longint):longint;

  function EnumCalendarInfo(lpCalInfoEnumProc:CALINFO_ENUMPROC; Locale:LCID; Calendar:CALID; CalType:CALTYPE):WINBOOL;

  function EnumTimeFormats(lpTimeFmtEnumProc:TIMEFMT_ENUMPROC; Locale:LCID; dwFlags:DWORD):WINBOOL;

  function EnumDateFormats(lpDateFmtEnumProc:DATEFMT_ENUMPROC; Locale:LCID; dwFlags:DWORD):WINBOOL;

  function GetStringTypeEx(Locale:LCID; dwInfoType:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpCharType:LPWORD):WINBOOL;

  function GetStringType(dwInfoType:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpCharType:LPWORD):WINBOOL;

  function FoldString(dwMapFlags:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpDestStr:LPWSTR; cchDest:longint):longint;

  function EnumSystemLocales(lpLocaleEnumProc:LOCALE_ENUMPROC; dwFlags:DWORD):WINBOOL;

  function EnumSystemCodePages(lpCodePageEnumProc:CODEPAGE_ENUMPROC; dwFlags:DWORD):WINBOOL;

  function PeekConsoleInput(hConsoleInput:HANDLE; lpBuffer:PINPUT_RECORD; nLength:DWORD; lpNumberOfEventsRead:LPDWORD):WINBOOL;

  function ReadConsoleInput(hConsoleInput:HANDLE; lpBuffer:PINPUT_RECORD; nLength:DWORD; lpNumberOfEventsRead:LPDWORD):WINBOOL;

(* Const before type ignored *)
  function WriteConsoleInput(hConsoleInput:HANDLE; var lpBuffer:INPUT_RECORD; nLength:DWORD; lpNumberOfEventsWritten:LPDWORD):WINBOOL;

  function ReadConsoleOutput(hConsoleOutput:HANDLE; lpBuffer:PCHAR_INFO; dwBufferSize:COORD; dwBufferCoord:COORD; lpReadRegion:PSMALL_RECT):WINBOOL;

(* Const before type ignored *)
  function WriteConsoleOutput(hConsoleOutput:HANDLE; var lpBuffer:CHAR_INFO; dwBufferSize:COORD; dwBufferCoord:COORD; lpWriteRegion:PSMALL_RECT):WINBOOL;

  function ReadConsoleOutputCharacter(hConsoleOutput:HANDLE; lpCharacter:LPWSTR; nLength:DWORD; dwReadCoord:COORD; lpNumberOfCharsRead:LPDWORD):WINBOOL;

  function WriteConsoleOutputCharacter(hConsoleOutput:HANDLE; lpCharacter:LPCWSTR; nLength:DWORD; dwWriteCoord:COORD; lpNumberOfCharsWritten:LPDWORD):WINBOOL;

  function FillConsoleOutputCharacter(hConsoleOutput:HANDLE; cCharacter:WCHAR; nLength:DWORD; dwWriteCoord:COORD; lpNumberOfCharsWritten:LPDWORD):WINBOOL;

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function ScrollConsoleScreenBuffer(hConsoleOutput:HANDLE; var lpScrollRectangle:SMALL_RECT; var lpClipRectangle:SMALL_RECT; dwDestinationOrigin:COORD; var lpFill:CHAR_INFO):WINBOOL;

  function GetConsoleTitle(lpConsoleTitle:LPWSTR; nSize:DWORD):DWORD;

  function SetConsoleTitle(lpConsoleTitle:LPCWSTR):WINBOOL;

  function ReadConsole(hConsoleInput:HANDLE; lpBuffer:LPVOID; nNumberOfCharsToRead:DWORD; lpNumberOfCharsRead:LPDWORD; lpReserved:LPVOID):WINBOOL;

(* Const before type ignored *)
  function WriteConsole(hConsoleOutput:HANDLE;lpBuffer:pointer; nNumberOfCharsToWrite:DWORD; lpNumberOfCharsWritten:LPDWORD; lpReserved:LPVOID):WINBOOL;

  function WNetAddConnection(lpRemoteName:LPCWSTR; lpPassword:LPCWSTR; lpLocalName:LPCWSTR):DWORD;

  function WNetAddConnection2(lpNetResource:LPNETRESOURCE; lpPassword:LPCWSTR; lpUserName:LPCWSTR; dwFlags:DWORD):DWORD;

  function WNetAddConnection3(hwndOwner:HWND; lpNetResource:LPNETRESOURCE; lpPassword:LPCWSTR; lpUserName:LPCWSTR; dwFlags:DWORD):DWORD;

  function WNetCancelConnection(lpName:LPCWSTR; fForce:WINBOOL):DWORD;

  function WNetCancelConnection2(lpName:LPCWSTR; dwFlags:DWORD; fForce:WINBOOL):DWORD;

  function WNetGetConnection(lpLocalName:LPCWSTR; lpRemoteName:LPWSTR; lpnLength:LPDWORD):DWORD;

  function WNetUseConnection(hwndOwner:HWND; lpNetResource:LPNETRESOURCE; lpUserID:LPCWSTR; lpPassword:LPCWSTR; dwFlags:DWORD; 
             lpAccessName:LPWSTR; lpBufferSize:LPDWORD; lpResult:LPDWORD):DWORD;

  function WNetSetConnection(lpName:LPCWSTR; dwProperties:DWORD; pvValues:LPVOID):DWORD;

  function WNetConnectionDialog1(lpConnDlgStruct:LPCONNECTDLGSTRUCT):DWORD;

  function WNetDisconnectDialog1(lpConnDlgStruct:LPDISCDLGSTRUCT):DWORD;

  function WNetOpenEnum(dwScope:DWORD; dwType:DWORD; dwUsage:DWORD; lpNetResource:LPNETRESOURCE; lphEnum:LPHANDLE):DWORD;

  function WNetEnumResource(hEnum:HANDLE; lpcCount:LPDWORD; lpBuffer:LPVOID; lpBufferSize:LPDWORD):DWORD;

  function WNetGetUniversalName(lpLocalPath:LPCWSTR; dwInfoLevel:DWORD; lpBuffer:LPVOID; lpBufferSize:LPDWORD):DWORD;

  function WNetGetUser(lpName:LPCWSTR; lpUserName:LPWSTR; lpnLength:LPDWORD):DWORD;

  function WNetGetProviderName(dwNetType:DWORD; lpProviderName:LPWSTR; lpBufferSize:LPDWORD):DWORD;

  function WNetGetNetworkInformation(lpProvider:LPCWSTR; lpNetInfoStruct:LPNETINFOSTRUCT):DWORD;

  function WNetGetLastError(lpError:LPDWORD; lpErrorBuf:LPWSTR; nErrorBufSize:DWORD; lpNameBuf:LPWSTR; nNameBufSize:DWORD):DWORD;

  function MultinetGetConnectionPerformance(lpNetResource:LPNETRESOURCE; lpNetConnectInfoStruct:LPNETCONNECTINFOSTRUCT):DWORD;

  function ChangeServiceConfig(hService:SC_HANDLE; dwServiceType:DWORD; dwStartType:DWORD; dwErrorControl:DWORD; lpBinaryPathName:LPCWSTR; 
             lpLoadOrderGroup:LPCWSTR; lpdwTagId:LPDWORD; lpDependencies:LPCWSTR; lpServiceStartName:LPCWSTR; lpPassword:LPCWSTR; 
             lpDisplayName:LPCWSTR):WINBOOL;

  function CreateService(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; lpDisplayName:LPCWSTR; dwDesiredAccess:DWORD; dwServiceType:DWORD; 
             dwStartType:DWORD; dwErrorControl:DWORD; lpBinaryPathName:LPCWSTR; lpLoadOrderGroup:LPCWSTR; lpdwTagId:LPDWORD; 
             lpDependencies:LPCWSTR; lpServiceStartName:LPCWSTR; lpPassword:LPCWSTR):SC_HANDLE;

  function EnumDependentServices(hService:SC_HANDLE; dwServiceState:DWORD; lpServices:LPENUM_SERVICE_STATUS; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD; 
             lpServicesReturned:LPDWORD):WINBOOL;

  function EnumServicesStatus(hSCManager:SC_HANDLE; dwServiceType:DWORD; dwServiceState:DWORD; lpServices:LPENUM_SERVICE_STATUS; cbBufSize:DWORD; 
             pcbBytesNeeded:LPDWORD; lpServicesReturned:LPDWORD; lpResumeHandle:LPDWORD):WINBOOL;

  function GetServiceKeyName(hSCManager:SC_HANDLE; lpDisplayName:LPCWSTR; lpServiceName:LPWSTR; lpcchBuffer:LPDWORD):WINBOOL;

  function GetServiceDisplayName(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; lpDisplayName:LPWSTR; lpcchBuffer:LPDWORD):WINBOOL;

  function OpenSCManager(lpMachineName:LPCWSTR; lpDatabaseName:LPCWSTR; dwDesiredAccess:DWORD):SC_HANDLE;

  function OpenService(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; dwDesiredAccess:DWORD):SC_HANDLE;

  function QueryServiceConfig(hService:SC_HANDLE; lpServiceConfig:LPQUERY_SERVICE_CONFIG; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD):WINBOOL;

  function QueryServiceLockStatus(hSCManager:SC_HANDLE; lpLockStatus:LPQUERY_SERVICE_LOCK_STATUS; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD):WINBOOL;

  function RegisterServiceCtrlHandler(lpServiceName:LPCWSTR; lpHandlerProc:LPHANDLER_FUNCTION):SERVICE_STATUS_HANDLE;

  function StartServiceCtrlDispatcher(lpServiceStartTable:LPSERVICE_TABLE_ENTRY):WINBOOL;

  function StartService(hService:SC_HANDLE; dwNumServiceArgs:DWORD; var lpServiceArgVectors:LPCWSTR):WINBOOL;

  { Extensions to OpenGL  }
  function wglUseFontBitmaps(_para1:HDC; _para2:DWORD; _para3:DWORD; _para4:DWORD):WINBOOL;

  function wglUseFontOutlines(_para1:HDC; _para2:DWORD; _para3:DWORD; _para4:DWORD; _para5:FLOAT; 
             _para6:FLOAT; _para7:longint; _para8:LPGLYPHMETRICSFLOAT):WINBOOL;

  { -------------------------------------  }
  { From shellapi.h in old Cygnus headers  }
  function DragQueryFile(_para1:HDROP; _para2:cardinal; _para3:LPCWSTR; _para4:cardinal):cardinal;

  function ExtractAssociatedIcon(_para1:HINSTANCE; _para2:LPCWSTR; var _para3:WORD):HICON;

(* Const before type ignored *)
  function ExtractIcon(_para1:HINSTANCE; _para2:LPCWSTR; _para3:cardinal):HICON;

(* Const before type ignored *)
(* Const before type ignored *)
  function FindExecutable(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR):HINSTANCE;

(* Const before type ignored *)
(* Const before type ignored *)
  function ShellAbout(_para1:HWND; _para2:LPCWSTR; _para3:LPCWSTR; _para4:HICON):longint;

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function ShellExecute(_para1:HWND; _para2:LPCWSTR; _para3:LPCWSTR; _para4:LPCWSTR; _para5:LPCWSTR; 
             _para6:longint):HINSTANCE;

  { end of stuff from shellapi.h in old Cygnus headers  }
  { --------------------------------------------------  }
  { From ddeml.h in old Cygnus headers  }
  function DdeCreateStringHandle(_para1:DWORD; _para2:LPCWSTR; _para3:longint):HSZ;

  function DdeInitialize(var _para1:DWORD; _para2:CALLB; _para3:DWORD; _para4:DWORD):UINT;

  function DdeQueryString(_para1:DWORD; _para2:HSZ; _para3:LPCWSTR; _para4:DWORD; _para5:longint):DWORD;

  { end of stuff from ddeml.h in old Cygnus headers  }
  { -----------------------------------------------  }
  function LogonUser(_para1:LPWSTR; _para2:LPWSTR; _para3:LPWSTR; _para4:DWORD; _para5:DWORD; 
             var _para6:HANDLE):WINBOOL;

  function CreateProcessAsUser(_para1:HANDLE; _para2:LPCWSTR; _para3:LPWSTR; var _para4:SECURITY_ATTRIBUTES; var _para5:SECURITY_ATTRIBUTES; 
             _para6:WINBOOL; _para7:DWORD; _para8:LPVOID; _para9:LPCWSTR; var _para10:STARTUPINFO; 
             var _para11:PROCESS_INFORMATION):WINBOOL;

{ C++ end of extern C conditionnal removed }
  { __cplusplus  }
{$endif}
  { _GNU_H_WINDOWS32_UNICODEFUNCFIONSDEFAULT  }

{$endif read_interface}

{$ifndef windows_include_files}
  implementation

    const External_library='kernel32'; {Setup as you need!}

{$endif not windows_include_files}

{$ifdef read_implementation}

  function GetBinaryType(lpApplicationName:LPCWSTR; lpBinaryType:LPDWORD):WINBOOL; external 'kernel32.dll' name 'GetBinaryTypeW';

  function GetShortPathName(lpszLongPath:LPCWSTR; lpszShortPath:LPWSTR; cchBuffer:DWORD):DWORD; external 'kernel32.dll' name 'GetShortPathNameW';

  function GetEnvironmentStrings : LPWSTR; external 'kernel32.dll' name 'GetEnvironmentStringsW';

  function FreeEnvironmentStrings(_para1:LPWSTR):WINBOOL; external 'kernel32.dll' name 'FreeEnvironmentStringsW';

  function FormatMessage(dwFlags:DWORD; lpSource:LPCVOID; dwMessageId:DWORD; dwLanguageId:DWORD; lpBuffer:LPWSTR; 
             nSize:DWORD; var Arguments:va_list):DWORD; external 'kernel32.dll' name 'FormatMessageW';

  function CreateMailslot(lpName:LPCWSTR; nMaxMessageSize:DWORD; lReadTimeout:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):HANDLE; external 'kernel32.dll' name 'CreateMailslotW';

  function lstrcmp(lpString1:LPCWSTR; lpString2:LPCWSTR):longint; external 'kernel32.dll' name 'lstrcmpW';

  function lstrcmpi(lpString1:LPCWSTR; lpString2:LPCWSTR):longint; external 'kernel32.dll' name 'lstrcmpiW';

  function lstrcpyn(lpString1:LPWSTR; lpString2:LPCWSTR; iMaxLength:longint):LPWSTR; external 'kernel32.dll' name 'lstrcpynW';

  function lstrcpy(lpString1:LPWSTR; lpString2:LPCWSTR):LPWSTR; external 'kernel32.dll' name 'lstrcpyW';

  function lstrcat(lpString1:LPWSTR; lpString2:LPCWSTR):LPWSTR; external 'kernel32.dll' name 'lstrcatW';

  function lstrlen(lpString:LPCWSTR):longint; external 'kernel32.dll' name 'lstrlenW';

  function CreateMutex(lpMutexAttributes:LPSECURITY_ATTRIBUTES; bInitialOwner:WINBOOL; lpName:LPCWSTR):HANDLE; external 'kernel32.dll' name 'CreateMutexW';

  function OpenMutex(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE; external 'kernel32.dll' name 'OpenMutexW';

  function CreateEvent(lpEventAttributes:LPSECURITY_ATTRIBUTES; bManualReset:WINBOOL; bInitialState:WINBOOL; lpName:LPCWSTR):HANDLE; external 'kernel32.dll' name 'CreateEventW';

  function OpenEvent(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE; external 'kernel32.dll' name 'OpenEventW';

  function CreateSemaphore(lpSemaphoreAttributes:LPSECURITY_ATTRIBUTES; lInitialCount:LONG; lMaximumCount:LONG; lpName:LPCWSTR):HANDLE; external 'kernel32.dll' name 'CreateSemaphoreW';

  function OpenSemaphore(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE; external 'kernel32.dll' name 'OpenSemaphoreW';

  function CreateFileMapping(hFile:HANDLE; lpFileMappingAttributes:LPSECURITY_ATTRIBUTES; flProtect:DWORD; dwMaximumSizeHigh:DWORD; dwMaximumSizeLow:DWORD; 
             lpName:LPCWSTR):HANDLE; external 'kernel32.dll' name 'CreateFileMappingW';

  function OpenFileMapping(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE; external 'kernel32.dll' name 'OpenFileMappingW';

  function GetLogicalDriveStrings(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD; external 'kernel32.dll' name 'GetLogicalDriveStringsW';

  function LoadLibrary(lpLibFileName:LPCWSTR):HINSTANCE; external 'kernel32.dll' name 'LoadLibraryW';

  function LoadLibraryEx(lpLibFileName:LPCWSTR; hFile:HANDLE; dwFlags:DWORD):HINSTANCE; external 'kernel32.dll' name 'LoadLibraryExW';

  function GetModuleFileName(hModule:HINSTANCE; lpFilename:LPWSTR; nSize:DWORD):DWORD; external 'kernel32.dll' name 'GetModuleFileNameW';

  function GetModuleHandle(lpModuleName:LPCWSTR):HMODULE; external 'kernel32.dll' name 'GetModuleHandleW';

  procedure FatalAppExit(uAction:UINT; lpMessageText:LPCWSTR); external 'kernel32.dll' name 'FatalAppExitW';

  function GetCommandLine : LPWSTR; external 'kernel32.dll' name 'GetCommandLineW';

  function GetEnvironmentVariable(lpName:LPCWSTR; lpBuffer:LPWSTR; nSize:DWORD):DWORD; external 'kernel32.dll' name 'GetEnvironmentVariableW';

  function SetEnvironmentVariable(lpName:LPCWSTR; lpValue:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'SetEnvironmentVariableW';

  function ExpandEnvironmentStrings(lpSrc:LPCWSTR; lpDst:LPWSTR; nSize:DWORD):DWORD; external 'kernel32.dll' name 'ExpandEnvironmentStringsW';

  procedure OutputDebugString(lpOutputString:LPCWSTR); external 'kernel32.dll' name 'OutputDebugStringW';

  function FindResource(hModule:HINSTANCE; lpName:LPCWSTR; lpType:LPCWSTR):HRSRC; external 'kernel32.dll' name 'FindResourceW';

  function FindResourceEx(hModule:HINSTANCE; lpType:LPCWSTR; lpName:LPCWSTR; wLanguage:WORD):HRSRC; external 'kernel32.dll' name 'FindResourceExW';

  function EnumResourceTypes(hModule:HINSTANCE; lpEnumFunc:ENUMRESTYPEPROC; lParam:LONG):WINBOOL; external 'kernel32.dll' name 'EnumResourceTypesW';

  function EnumResourceNames(hModule:HINSTANCE; lpType:LPCWSTR; lpEnumFunc:ENUMRESNAMEPROC; lParam:LONG):WINBOOL; external 'kernel32.dll' name 'EnumResourceNamesW';

  function EnumResourceLanguages(hModule:HINSTANCE; lpType:LPCWSTR; lpName:LPCWSTR; lpEnumFunc:ENUMRESLANGPROC; lParam:LONG):WINBOOL; external 'kernel32.dll' name 'EnumResourceLanguagesW';

  function BeginUpdateResource(pFileName:LPCWSTR; bDeleteExistingResources:WINBOOL):HANDLE; external 'kernel32.dll' name 'BeginUpdateResourceW';

  function UpdateResource(hUpdate:HANDLE; lpType:LPCWSTR; lpName:LPCWSTR; wLanguage:WORD; lpData:LPVOID; 
             cbData:DWORD):WINBOOL; external 'kernel32.dll' name 'UpdateResourceW';

  function EndUpdateResource(hUpdate:HANDLE; fDiscard:WINBOOL):WINBOOL; external 'kernel32.dll' name 'EndUpdateResourceW';

  function GlobalAddAtom(lpString:LPCWSTR):ATOM; external 'kernel32.dll' name 'GlobalAddAtomW';

  function GlobalFindAtom(lpString:LPCWSTR):ATOM; external 'kernel32.dll' name 'GlobalFindAtomW';

  function GlobalGetAtomName(nAtom:ATOM; lpBuffer:LPWSTR; nSize:longint):UINT; external 'kernel32.dll' name 'GlobalGetAtomNameW';

  function AddAtom(lpString:LPCWSTR):ATOM; external 'kernel32.dll' name 'AddAtomW';

  function FindAtom(lpString:LPCWSTR):ATOM; external 'kernel32.dll' name 'FindAtomW';

  function GetAtomName(nAtom:ATOM; lpBuffer:LPWSTR; nSize:longint):UINT; external 'kernel32.dll' name 'GetAtomNameW';

  function GetProfileInt(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; nDefault:INT):UINT; external 'kernel32.dll' name 'GetProfileIntW';

  function GetProfileString(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpDefault:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD):DWORD; external 'kernel32.dll' name 'GetProfileStringW';

  function WriteProfileString(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpString:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'WriteProfileStringW';

  function GetProfileSection(lpAppName:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD):DWORD; external 'kernel32.dll' name 'GetProfileSectionW';

  function WriteProfileSection(lpAppName:LPCWSTR; lpString:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'WriteProfileSectionW';

  function GetPrivateProfileInt(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; nDefault:INT; lpFileName:LPCWSTR):UINT; external 'kernel32.dll' name 'GetPrivateProfileIntW';

  function GetPrivateProfileString(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpDefault:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD; 
             lpFileName:LPCWSTR):DWORD; external 'kernel32.dll' name 'GetPrivateProfileStringW';

  function WritePrivateProfileString(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpString:LPCWSTR; lpFileName:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'WritePrivateProfileStringW';

  function GetPrivateProfileSection(lpAppName:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD; lpFileName:LPCWSTR):DWORD; external 'kernel32.dll' name 'GetPrivateProfileSectionW';

  function WritePrivateProfileSection(lpAppName:LPCWSTR; lpString:LPCWSTR; lpFileName:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'WritePrivateProfileSectionW';

  function GetDriveType(lpRootPathName:LPCWSTR):UINT; external 'kernel32.dll' name 'GetDriveTypeW';

  function GetSystemDirectory(lpBuffer:LPWSTR; uSize:UINT):UINT; external 'kernel32.dll' name 'GetSystemDirectoryW';

  function GetTempPath(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD; external 'kernel32.dll' name 'GetTempPathW';

  function GetTempFileName(lpPathName:LPCWSTR; lpPrefixString:LPCWSTR; uUnique:UINT; lpTempFileName:LPWSTR):UINT; external 'kernel32.dll' name 'GetTempFileNameW';

  function GetWindowsDirectory(lpBuffer:LPWSTR; uSize:UINT):UINT; external 'kernel32.dll' name 'GetWindowsDirectoryW';

  function SetCurrentDirectory(lpPathName:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'SetCurrentDirectoryW';

  function GetCurrentDirectory(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD; external 'kernel32.dll' name 'GetCurrentDirectoryW';

  function GetDiskFreeSpace(lpRootPathName:LPCWSTR; lpSectorsPerCluster:LPDWORD; lpBytesPerSector:LPDWORD; lpNumberOfFreeClusters:LPDWORD; lpTotalNumberOfClusters:LPDWORD):WINBOOL; external 'kernel32.dll' name 'GetDiskFreeSpaceW';

  function CreateDirectory(lpPathName:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):WINBOOL; external 'kernel32.dll' name 'CreateDirectoryW';

  function CreateDirectoryEx(lpTemplateDirectory:LPCWSTR; lpNewDirectory:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):WINBOOL; external 'kernel32.dll' name 'CreateDirectoryExW';

  function RemoveDirectory(lpPathName:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'RemoveDirectoryW';

  function GetFullPathName(lpFileName:LPCWSTR; nBufferLength:DWORD; lpBuffer:LPWSTR; var lpFilePart:LPWSTR):DWORD; external 'kernel32.dll' name 'GetFullPathNameW';

  function DefineDosDevice(dwFlags:DWORD; lpDeviceName:LPCWSTR; lpTargetPath:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'DefineDosDeviceW';

  function QueryDosDevice(lpDeviceName:LPCWSTR; lpTargetPath:LPWSTR; ucchMax:DWORD):DWORD; external 'kernel32.dll' name 'QueryDosDeviceW';

  function CreateFile(lpFileName:LPCWSTR; dwDesiredAccess:DWORD; dwShareMode:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES; dwCreationDisposition:DWORD; 
             dwFlagsAndAttributes:DWORD; hTemplateFile:HANDLE):HANDLE; external 'kernel32.dll' name 'CreateFileW';

  function SetFileAttributes(lpFileName:LPCWSTR; dwFileAttributes:DWORD):WINBOOL; external 'kernel32.dll' name 'SetFileAttributesW';

  function GetFileAttributes(lpFileName:LPCWSTR):DWORD; external 'kernel32.dll' name 'GetFileAttributesW';

  function GetCompressedFileSize(lpFileName:LPCWSTR; lpFileSizeHigh:LPDWORD):DWORD; external 'kernel32.dll' name 'GetCompressedFileSizeW';

  function DeleteFile(lpFileName:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'DeleteFileW';

  function SearchPath(lpPath:LPCWSTR; lpFileName:LPCWSTR; lpExtension:LPCWSTR; nBufferLength:DWORD; lpBuffer:LPWSTR; 
             var lpFilePart:LPWSTR):DWORD; external 'kernel32.dll' name 'SearchPathW';

  function CopyFile(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR; bFailIfExists:WINBOOL):WINBOOL; external 'kernel32.dll' name 'CopyFileW';

  function MoveFile(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'MoveFileW';

  function MoveFileEx(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR; dwFlags:DWORD):WINBOOL; external 'kernel32.dll' name 'MoveFileExW';

  function CreateNamedPipe(lpName:LPCWSTR; dwOpenMode:DWORD; dwPipeMode:DWORD; nMaxInstances:DWORD; nOutBufferSize:DWORD; 
             nInBufferSize:DWORD; nDefaultTimeOut:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):HANDLE; external 'kernel32.dll' name 'CreateNamedPipeW';

  function GetNamedPipeHandleState(hNamedPipe:HANDLE; lpState:LPDWORD; lpCurInstances:LPDWORD; lpMaxCollectionCount:LPDWORD; lpCollectDataTimeout:LPDWORD; 
             lpUserName:LPWSTR; nMaxUserNameSize:DWORD):WINBOOL; external 'kernel32.dll' name 'GetNamedPipeHandleStateW';

  function CallNamedPipe(lpNamedPipeName:LPCWSTR; lpInBuffer:LPVOID; nInBufferSize:DWORD; lpOutBuffer:LPVOID; nOutBufferSize:DWORD; 
             lpBytesRead:LPDWORD; nTimeOut:DWORD):WINBOOL; external 'kernel32.dll' name 'CallNamedPipeW';

  function WaitNamedPipe(lpNamedPipeName:LPCWSTR; nTimeOut:DWORD):WINBOOL; external 'kernel32.dll' name 'WaitNamedPipeW';

  function SetVolumeLabel(lpRootPathName:LPCWSTR; lpVolumeName:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'SetVolumeLabelW';

  function GetVolumeInformation(lpRootPathName:LPCWSTR; lpVolumeNameBuffer:LPWSTR; nVolumeNameSize:DWORD; lpVolumeSerialNumber:LPDWORD; lpMaximumComponentLength:LPDWORD; 
             lpFileSystemFlags:LPDWORD; lpFileSystemNameBuffer:LPWSTR; nFileSystemNameSize:DWORD):WINBOOL; external 'kernel32.dll' name 'GetVolumeInformationW';

  function ClearEventLog(hEventLog:HANDLE; lpBackupFileName:LPCWSTR):WINBOOL; external 'advapi32.dll' name 'ClearEventLogW';

  function BackupEventLog(hEventLog:HANDLE; lpBackupFileName:LPCWSTR):WINBOOL; external 'advapi32.dll' name 'BackupEventLogW';

  function OpenEventLog(lpUNCServerName:LPCWSTR; lpSourceName:LPCWSTR):HANDLE; external 'advapi32.dll' name 'OpenEventLogW';

  function RegisterEventSource(lpUNCServerName:LPCWSTR; lpSourceName:LPCWSTR):HANDLE; external 'advapi32.dll' name 'RegisterEventSourceW';

  function OpenBackupEventLog(lpUNCServerName:LPCWSTR; lpFileName:LPCWSTR):HANDLE; external 'advapi32.dll' name 'OpenBackupEventLogW';

  function ReadEventLog(hEventLog:HANDLE; dwReadFlags:DWORD; dwRecordOffset:DWORD; lpBuffer:LPVOID; nNumberOfBytesToRead:DWORD; 
             var pnBytesRead:DWORD; var pnMinNumberOfBytesNeeded:DWORD):WINBOOL; external 'advapi32.dll' name 'ReadEventLogW';

  function ReportEvent(hEventLog:HANDLE; wType:WORD; wCategory:WORD; dwEventID:DWORD; lpUserSid:PSID; 
             wNumStrings:WORD; dwDataSize:DWORD; var lpStrings:LPCWSTR; lpRawData:LPVOID):WINBOOL; external 'advapi32.dll' name 'ReportEventW';

  function AccessCheckAndAuditAlarm(SubsystemName:LPCWSTR; HandleId:LPVOID; ObjectTypeName:LPWSTR; ObjectName:LPWSTR; SecurityDescriptor:PSECURITY_DESCRIPTOR; 
             DesiredAccess:DWORD; GenericMapping:PGENERIC_MAPPING; ObjectCreation:WINBOOL; GrantedAccess:LPDWORD; AccessStatus:LPBOOL; 
             pfGenerateOnClose:LPBOOL):WINBOOL; external 'advapi32.dll' name 'AccessCheckAndAuditAlarmW';

  function ObjectOpenAuditAlarm(SubsystemName:LPCWSTR; HandleId:LPVOID; ObjectTypeName:LPWSTR; ObjectName:LPWSTR; pSecurityDescriptor:PSECURITY_DESCRIPTOR; 
             ClientToken:HANDLE; DesiredAccess:DWORD; GrantedAccess:DWORD; Privileges:PPRIVILEGE_SET; ObjectCreation:WINBOOL; 
             AccessGranted:WINBOOL; GenerateOnClose:LPBOOL):WINBOOL; external 'advapi32.dll' name 'ObjectOpenAuditAlarmW';

  function ObjectPrivilegeAuditAlarm(SubsystemName:LPCWSTR; HandleId:LPVOID; ClientToken:HANDLE; DesiredAccess:DWORD; Privileges:PPRIVILEGE_SET; 
             AccessGranted:WINBOOL):WINBOOL; external 'advapi32.dll' name 'ObjectPrivilegeAuditAlarmW';

  function ObjectCloseAuditAlarm(SubsystemName:LPCWSTR; HandleId:LPVOID; GenerateOnClose:WINBOOL):WINBOOL; external 'advapi32.dll' name 'ObjectCloseAuditAlarmW';

  function PrivilegedServiceAuditAlarm(SubsystemName:LPCWSTR; ServiceName:LPCWSTR; ClientToken:HANDLE; Privileges:PPRIVILEGE_SET; AccessGranted:WINBOOL):WINBOOL; external 'advapi32.dll' name 'PrivilegedServiceAuditAlarmW';

  function SetFileSecurity(lpFileName:LPCWSTR; SecurityInformation:SECURITY_INFORMATION; pSecurityDescriptor:PSECURITY_DESCRIPTOR):WINBOOL; external 'advapi32.dll' name 'SetFileSecurityW';

  function GetFileSecurity(lpFileName:LPCWSTR; RequestedInformation:SECURITY_INFORMATION; pSecurityDescriptor:PSECURITY_DESCRIPTOR; nLength:DWORD; lpnLengthNeeded:LPDWORD):WINBOOL; external 'advapi32.dll' name 'GetFileSecurityW';

  function FindFirstChangeNotification(lpPathName:LPCWSTR; bWatchSubtree:WINBOOL; dwNotifyFilter:DWORD):HANDLE; external 'kernel32.dll' name 'FindFirstChangeNotificationW';

  function IsBadStringPtr(lpsz:LPCWSTR; ucchMax:UINT):WINBOOL; external 'kernel32.dll' name 'IsBadStringPtrW';

  function LookupAccountSid(lpSystemName:LPCWSTR; Sid:PSID; Name:LPWSTR; cbName:LPDWORD; ReferencedDomainName:LPWSTR; 
             cbReferencedDomainName:LPDWORD; peUse:PSID_NAME_USE):WINBOOL; external 'advapi32.dll' name 'LookupAccountSidW';

  function LookupAccountName(lpSystemName:LPCWSTR; lpAccountName:LPCWSTR; Sid:PSID; cbSid:LPDWORD; ReferencedDomainName:LPWSTR; 
             cbReferencedDomainName:LPDWORD; peUse:PSID_NAME_USE):WINBOOL; external 'advapi32.dll' name 'LookupAccountNameW';

  function LookupPrivilegeValue(lpSystemName:LPCWSTR; lpName:LPCWSTR; lpLuid:PLUID):WINBOOL; external 'advapi32.dll' name 'LookupPrivilegeValueW';

  function LookupPrivilegeName(lpSystemName:LPCWSTR; lpLuid:PLUID; lpName:LPWSTR; cbName:LPDWORD):WINBOOL; external 'advapi32.dll' name 'LookupPrivilegeNameW';

  function LookupPrivilegeDisplayName(lpSystemName:LPCWSTR; lpName:LPCWSTR; lpDisplayName:LPWSTR; cbDisplayName:LPDWORD; lpLanguageId:LPDWORD):WINBOOL; external 'advapi32.dll' name 'LookupPrivilegeDisplayNameW';

  function BuildCommDCB(lpDef:LPCWSTR; lpDCB:LPDCB):WINBOOL; external 'kernel32.dll' name 'BuildCommDCBW';

  function BuildCommDCBAndTimeouts(lpDef:LPCWSTR; lpDCB:LPDCB; lpCommTimeouts:LPCOMMTIMEOUTS):WINBOOL; external 'kernel32.dll' name 'BuildCommDCBAndTimeoutsW';

  function CommConfigDialog(lpszName:LPCWSTR; hWnd:HWND; lpCC:LPCOMMCONFIG):WINBOOL; external 'kernel32.dll' name 'CommConfigDialogW';

  function GetDefaultCommConfig(lpszName:LPCWSTR; lpCC:LPCOMMCONFIG; lpdwSize:LPDWORD):WINBOOL; external 'kernel32.dll' name 'GetDefaultCommConfigW';

  function SetDefaultCommConfig(lpszName:LPCWSTR; lpCC:LPCOMMCONFIG; dwSize:DWORD):WINBOOL; external 'kernel32.dll' name 'SetDefaultCommConfigW';

  function GetComputerName(lpBuffer:LPWSTR; nSize:LPDWORD):WINBOOL; external 'kernel32.dll' name 'GetComputerNameW';

  function SetComputerName(lpComputerName:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'SetComputerNameW';

  function GetUserName(lpBuffer:LPWSTR; nSize:LPDWORD):WINBOOL; external 'advapi32.dll' name 'GetUserNameW';

  function wvsprintf(_para1:LPWSTR; _para2:LPCWSTR; arglist:va_list):longint; external 'user32.dll' name 'wvsprintfW';

  {function wsprintf(_para1:LPWSTR; _para2:LPCWSTR; ...):longint;CDECL; external 'user32.dll' name 'wsprintfW';}

  function LoadKeyboardLayout(pwszKLID:LPCWSTR; Flags:UINT):HKL; external 'user32.dll' name 'LoadKeyboardLayoutW';

  function GetKeyboardLayoutName(pwszKLID:LPWSTR):WINBOOL; external 'user32.dll' name 'GetKeyboardLayoutNameW';

  function CreateDesktop(lpszDesktop:LPWSTR; lpszDevice:LPWSTR; pDevmode:LPDEVMODE; dwFlags:DWORD; dwDesiredAccess:DWORD; 
             lpsa:LPSECURITY_ATTRIBUTES):HDESK; external 'user32.dll' name 'CreateDesktopW';

  function OpenDesktop(lpszDesktop:LPWSTR; dwFlags:DWORD; fInherit:WINBOOL; dwDesiredAccess:DWORD):HDESK; external 'user32.dll' name 'OpenDesktopW';

  function EnumDesktops(hwinsta:HWINSTA; lpEnumFunc:DESKTOPENUMPROC; lParam:LPARAM):WINBOOL; external 'user32.dll' name 'EnumDesktopsW';

  function CreateWindowStation(lpwinsta:LPWSTR; dwReserved:DWORD; dwDesiredAccess:DWORD; lpsa:LPSECURITY_ATTRIBUTES):HWINSTA; external 'user32.dll' name 'CreateWindowStationW';

  function OpenWindowStation(lpszWinSta:LPWSTR; fInherit:WINBOOL; dwDesiredAccess:DWORD):HWINSTA; external 'user32.dll' name 'OpenWindowStationW';

  function EnumWindowStations(lpEnumFunc:ENUMWINDOWSTATIONPROC; lParam:LPARAM):WINBOOL; external 'user32.dll' name 'EnumWindowStationsW';

  function GetUserObjectInformation(hObj:HANDLE; nIndex:longint; pvInfo:PVOID; nLength:DWORD; lpnLengthNeeded:LPDWORD):WINBOOL; external 'user32.dll' name 'GetUserObjectInformationW';

  function SetUserObjectInformation(hObj:HANDLE; nIndex:longint; pvInfo:PVOID; nLength:DWORD):WINBOOL; external 'user32.dll' name 'SetUserObjectInformationW';

  function RegisterWindowMessage(lpString:LPCWSTR):UINT; external 'user32.dll' name 'RegisterWindowMessageW';

  function GetMessage(lpMsg:LPMSG; hWnd:HWND; wMsgFilterMin:UINT; wMsgFilterMax:UINT):WINBOOL; external 'user32.dll' name 'GetMessageW';

  function DispatchMessage(var lpMsg:MSG):LONG; external 'user32.dll' name 'DispatchMessageW';

  function PeekMessage(lpMsg:LPMSG; hWnd:HWND; wMsgFilterMin:UINT; wMsgFilterMax:UINT; wRemoveMsg:UINT):WINBOOL; external 'user32.dll' name 'PeekMessageW';

  function SendMessage(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external 'user32.dll' name 'SendMessageW';

  function SendMessageTimeout(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM; fuFlags:UINT; 
             uTimeout:UINT; lpdwResult:LPDWORD):LRESULT; external 'user32.dll' name 'SendMessageTimeoutW';

  function SendNotifyMessage(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL; external 'user32.dll' name 'SendNotifyMessageW';

  function SendMessageCallback(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM; lpResultCallBack:SENDASYNCPROC; 
             dwData:DWORD):WINBOOL; external 'user32.dll' name 'SendMessageCallbackW';

  function PostMessage(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL; external 'user32.dll' name 'PostMessageW';

  function PostThreadMessage(idThread:DWORD; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL; external 'user32.dll' name 'PostThreadMessageW';

  function DefWindowProc(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external 'user32.dll' name 'DefWindowProcW';

  function CallWindowProc(lpPrevWndFunc:WNDPROC; hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external 'user32.dll' name 'CallWindowProcW';

  function RegisterClass(var lpWndClass:WNDCLASS):ATOM; external 'user32.dll' name 'RegisterClassW';

  function UnregisterClass(lpClassName:LPCWSTR; hInstance:HINSTANCE):WINBOOL; external 'user32.dll' name 'UnregisterClassW';

  function GetClassInfo(hInstance:HINSTANCE; lpClassName:LPCWSTR; lpWndClass:LPWNDCLASS):WINBOOL; external 'user32.dll' name 'GetClassInfoW';

  function RegisterClassEx(var _para1:WNDCLASSEX):ATOM; external 'user32.dll' name 'RegisterClassExW';

  function GetClassInfoEx(_para1:HINSTANCE; _para2:LPCWSTR; _para3:LPWNDCLASSEX):WINBOOL; external 'user32.dll' name 'GetClassInfoExW';

  function CreateWindowEx(dwExStyle:DWORD; lpClassName:LPCWSTR; lpWindowName:LPCWSTR; dwStyle:DWORD; X:longint; 
             Y:longint; nWidth:longint; nHeight:longint; hWndParent:HWND; hMenu:HMENU; 
             hInstance:HINSTANCE; lpParam:LPVOID):HWND; external 'user32.dll' name 'CreateWindowExW';

  function CreateDialogParam(hInstance:HINSTANCE; lpTemplateName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):HWND; external 'user32.dll' name 'CreateDialogParamW';

  function CreateDialogIndirectParam(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):HWND; external 'user32.dll' name 'CreateDialogIndirectParamW';

  function DialogBoxParam(hInstance:HINSTANCE; lpTemplateName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):longint; external 'user32.dll' name 'DialogBoxParamW';

  function DialogBoxIndirectParam(hInstance:HINSTANCE; hDialogTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):longint; external 'user32.dll' name 'DialogBoxIndirectParamW';

  function SetDlgItemText(hDlg:HWND; nIDDlgItem:longint; lpString:LPCWSTR):WINBOOL; external 'user32.dll' name 'SetDlgItemTextW';

  function GetDlgItemText(hDlg:HWND; nIDDlgItem:longint; lpString:LPWSTR; nMaxCount:longint):UINT; external 'user32.dll' name 'GetDlgItemTextW';

  function SendDlgItemMessage(hDlg:HWND; nIDDlgItem:longint; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LONG; external 'user32.dll' name 'SendDlgItemMessageW';

  function DefDlgProc(hDlg:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external 'user32.dll' name 'DefDlgProcW';

  function CallMsgFilter(lpMsg:LPMSG; nCode:longint):WINBOOL; external 'user32.dll' name 'CallMsgFilterW';

  function RegisterClipboardFormat(lpszFormat:LPCWSTR):UINT; external 'user32.dll' name 'RegisterClipboardFormatW';

  function GetClipboardFormatName(format:UINT; lpszFormatName:LPWSTR; cchMaxCount:longint):longint; external 'user32.dll' name 'GetClipboardFormatNameW';

  function CharToOem(lpszSrc:LPCWSTR; lpszDst:LPSTR):WINBOOL; external 'user32.dll' name 'CharToOemW';

  function OemToChar(lpszSrc:LPCSTR; lpszDst:LPWSTR):WINBOOL; external 'user32.dll' name 'OemToCharW';

  function CharToOemBuff(lpszSrc:LPCWSTR; lpszDst:LPSTR; cchDstLength:DWORD):WINBOOL; external 'user32.dll' name 'CharToOemBuffW';

  function OemToCharBuff(lpszSrc:LPCSTR; lpszDst:LPWSTR; cchDstLength:DWORD):WINBOOL; external 'user32.dll' name 'OemToCharBuffW';

  function CharUpper(lpsz:LPWSTR):LPWSTR; external 'user32.dll' name 'CharUpperW';

  function CharUpperBuff(lpsz:LPWSTR; cchLength:DWORD):DWORD; external 'user32.dll' name 'CharUpperBuffW';

  function CharLower(lpsz:LPWSTR):LPWSTR; external 'user32.dll' name 'CharLowerW';

  function CharLowerBuff(lpsz:LPWSTR; cchLength:DWORD):DWORD; external 'user32.dll' name 'CharLowerBuffW';

  function CharNext(lpsz:LPCWSTR):LPWSTR; external 'user32.dll' name 'CharNextW';

  function CharPrev(lpszStart:LPCWSTR; lpszCurrent:LPCWSTR):LPWSTR; external 'user32.dll' name 'CharPrevW';

  function IsCharAlpha(ch:WCHAR):WINBOOL; external 'user32.dll' name 'IsCharAlphaW';

  function IsCharAlphaNumeric(ch:WCHAR):WINBOOL; external 'user32.dll' name 'IsCharAlphaNumericW';

  function IsCharUpper(ch:WCHAR):WINBOOL; external 'user32.dll' name 'IsCharUpperW';

  function IsCharLower(ch:WCHAR):WINBOOL; external 'user32.dll' name 'IsCharLowerW';

  function GetKeyNameText(lParam:LONG; lpString:LPWSTR; nSize:longint):longint; external 'user32.dll' name 'GetKeyNameTextW';

  function VkKeyScan(ch:WCHAR):SHORT; external 'user32.dll' name 'VkKeyScanW';

  function VkKeyScanEx(ch:WCHAR; dwhkl:HKL):SHORT; external 'user32.dll' name 'VkKeyScanExW';

  function MapVirtualKey(uCode:UINT; uMapType:UINT):UINT; external 'user32.dll' name 'MapVirtualKeyW';

  function MapVirtualKeyEx(uCode:UINT; uMapType:UINT; dwhkl:HKL):UINT; external 'user32.dll' name 'MapVirtualKeyExW';

  function LoadAccelerators(hInstance:HINSTANCE; lpTableName:LPCWSTR):HACCEL; external 'user32.dll' name 'LoadAcceleratorsW';

  function CreateAcceleratorTable(_para1:LPACCEL; _para2:longint):HACCEL; external 'user32.dll' name 'CreateAcceleratorTableW';

  function CopyAcceleratorTable(hAccelSrc:HACCEL; lpAccelDst:LPACCEL; cAccelEntries:longint):longint; external 'user32.dll' name 'CopyAcceleratorTableW';

  function TranslateAccelerator(hWnd:HWND; hAccTable:HACCEL; lpMsg:LPMSG):longint; external 'user32.dll' name 'TranslateAcceleratorW';

  function LoadMenu(hInstance:HINSTANCE; lpMenuName:LPCWSTR):HMENU; external 'user32.dll' name 'LoadMenuW';

  function LoadMenuIndirect(var lpMenuTemplate:MENUTEMPLATE):HMENU; external 'user32.dll' name 'LoadMenuIndirectW';

  function ChangeMenu(hMenu:HMENU; cmd:UINT; lpszNewItem:LPCWSTR; cmdInsert:UINT; flags:UINT):WINBOOL; external 'user32.dll' name 'ChangeMenuW';

  function GetMenuString(hMenu:HMENU; uIDItem:UINT; lpString:LPWSTR; nMaxCount:longint; uFlag:UINT):longint; external 'user32.dll' name 'GetMenuStringW';

  function InsertMenu(hMenu:HMENU; uPosition:UINT; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL; external 'user32.dll' name 'InsertMenuW';

  function AppendMenu(hMenu:HMENU; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL; external 'user32.dll' name 'AppendMenuW';

  function ModifyMenu(hMnu:HMENU; uPosition:UINT; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL; external 'user32.dll' name 'ModifyMenuW';

  function InsertMenuItem(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPCMENUITEMINFO):WINBOOL; external 'user32.dll' name 'InsertMenuItemW';

  function GetMenuItemInfo(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPMENUITEMINFO):WINBOOL; external 'user32.dll' name 'GetMenuItemInfoW';

  function SetMenuItemInfo(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPCMENUITEMINFO):WINBOOL; external 'user32.dll' name 'SetMenuItemInfoW';

  function DrawText(hDC:HDC; lpString:LPCWSTR; nCount:longint; lpRect:LPRECT; uFormat:UINT):longint; external 'user32.dll' name 'DrawTextW';

  function DrawTextEx(_para1:HDC; _para2:LPWSTR; _para3:longint; _para4:LPRECT; _para5:UINT; 
             _para6:LPDRAWTEXTPARAMS):longint; external 'user32.dll' name 'DrawTextExW';

  function GrayString(hDC:HDC; hBrush:HBRUSH; lpOutputFunc:GRAYSTRINGPROC; lpData:LPARAM; nCount:longint; 
             X:longint; Y:longint; nWidth:longint; nHeight:longint):WINBOOL; external 'user32.dll' name 'GrayStringW';

  function DrawState(_para1:HDC; _para2:HBRUSH; _para3:DRAWSTATEPROC; _para4:LPARAM; _para5:WPARAM; 
             _para6:longint; _para7:longint; _para8:longint; _para9:longint; _para10:UINT):WINBOOL; external 'user32.dll' name 'DrawStateW';

  function TabbedTextOut(hDC:HDC; X:longint; Y:longint; lpString:LPCWSTR; nCount:longint; 
             nTabPositions:longint; lpnTabStopPositions:LPINT; nTabOrigin:longint):LONG; external 'user32.dll' name 'TabbedTextOutW';

  function GetTabbedTextExtent(hDC:HDC; lpString:LPCWSTR; nCount:longint; nTabPositions:longint; lpnTabStopPositions:LPINT):DWORD; external 'user32.dll' name 'GetTabbedTextExtentW';

  function SetProp(hWnd:HWND; lpString:LPCWSTR; hData:HANDLE):WINBOOL; external 'user32.dll' name 'SetPropW';

  function GetProp(hWnd:HWND; lpString:LPCWSTR):HANDLE; external 'user32.dll' name 'GetPropW';

  function RemoveProp(hWnd:HWND; lpString:LPCWSTR):HANDLE; external 'user32.dll' name 'RemovePropW';

  function EnumPropsEx(hWnd:HWND; lpEnumFunc:PROPENUMPROCEX; lParam:LPARAM):longint; external 'user32.dll' name 'EnumPropsExW';

  function EnumProps(hWnd:HWND; lpEnumFunc:PROPENUMPROC):longint; external 'user32.dll' name 'EnumPropsW';

  function SetWindowText(hWnd:HWND; lpString:LPCWSTR):WINBOOL; external 'user32.dll' name 'SetWindowTextW';

  function GetWindowText(hWnd:HWND; lpString:LPWSTR; nMaxCount:longint):longint; external 'user32.dll' name 'GetWindowTextW';

  function GetWindowTextLength(hWnd:HWND):longint; external 'user32.dll' name 'GetWindowTextLengthW';

  function MessageBox(hWnd:HWND; lpText:LPCWSTR; lpCaption:LPCWSTR; uType:UINT):longint; external 'user32.dll' name 'MessageBoxW';

  function MessageBoxEx(hWnd:HWND; lpText:LPCWSTR; lpCaption:LPCWSTR; uType:UINT; wLanguageId:WORD):longint; external 'user32.dll' name 'MessageBoxExW';

  function MessageBoxIndirect(_para1:LPMSGBOXPARAMS):longint; external 'user32.dll' name 'MessageBoxIndirectW';

  function GetWindowLong(hWnd:HWND; nIndex:longint):LONG; external 'user32.dll' name 'GetWindowLongW';

  function SetWindowLong(hWnd:HWND; nIndex:longint; dwNewLong:LONG):LONG; external 'user32.dll' name 'SetWindowLongW';

  function GetClassLong(hWnd:HWND; nIndex:longint):DWORD; external 'user32.dll' name 'GetClassLongW';

  function SetClassLong(hWnd:HWND; nIndex:longint; dwNewLong:LONG):DWORD; external 'user32.dll' name 'SetClassLongW';

  function FindWindow(lpClassName:LPCWSTR; lpWindowName:LPCWSTR):HWND; external 'user32.dll' name 'FindWindowW';

  function FindWindowEx(_para1:HWND; _para2:HWND; _para3:LPCWSTR; _para4:LPCWSTR):HWND; external 'user32.dll' name 'FindWindowExW';

  function GetClassName(hWnd:HWND; lpClassName:LPWSTR; nMaxCount:longint):longint; external 'user32.dll' name 'GetClassNameW';

  function SetWindowsHookEx(idHook:longint; lpfn:HOOKPROC; hmod:HINSTANCE; dwThreadId:DWORD):HHOOK; external 'user32.dll' name 'SetWindowsHookExW';

  function LoadBitmap(hInstance:HINSTANCE; lpBitmapName:LPCWSTR):HBITMAP; external 'user32.dll' name 'LoadBitmapW';

  function LoadCursor(hInstance:HINSTANCE; lpCursorName:LPCWSTR):HCURSOR; external 'user32.dll' name 'LoadCursorW';

  function LoadCursorFromFile(lpFileName:LPCWSTR):HCURSOR; external 'user32.dll' name 'LoadCursorFromFileW';

  function LoadIcon(hInstance:HINSTANCE; lpIconName:LPCWSTR):HICON; external 'user32.dll' name 'LoadIconW';

  function LoadImage(_para1:HINSTANCE; _para2:LPCWSTR; _para3:UINT; _para4:longint; _para5:longint; 
             _para6:UINT):HANDLE; external 'user32.dll' name 'LoadImageW';

  function LoadString(hInstance:HINSTANCE; uID:UINT; lpBuffer:LPWSTR; nBufferMax:longint):longint; external 'user32.dll' name 'LoadStringW';

  function IsDialogMessage(hDlg:HWND; lpMsg:LPMSG):WINBOOL; external 'user32.dll' name 'IsDialogMessageW';

  function DlgDirList(hDlg:HWND; lpPathSpec:LPWSTR; nIDListBox:longint; nIDStaticPath:longint; uFileType:UINT):longint; external 'user32.dll' name 'DlgDirListW';

  function DlgDirSelectEx(hDlg:HWND; lpString:LPWSTR; nCount:longint; nIDListBox:longint):WINBOOL; external 'user32.dll' name 'DlgDirSelectExW';

  function DlgDirListComboBox(hDlg:HWND; lpPathSpec:LPWSTR; nIDComboBox:longint; nIDStaticPath:longint; uFiletype:UINT):longint; external 'user32.dll' name 'DlgDirListComboBoxW';

  function DlgDirSelectComboBoxEx(hDlg:HWND; lpString:LPWSTR; nCount:longint; nIDComboBox:longint):WINBOOL; external 'user32.dll' name 'DlgDirSelectComboBoxExW';

  function DefFrameProc(hWnd:HWND; hWndMDIClient:HWND; uMsg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external 'user32.dll' name 'DefFrameProcW';

  function DefMDIChildProc(hWnd:HWND; uMsg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external 'user32.dll' name 'DefMDIChildProcW';

  function CreateMDIWindow(lpClassName:LPWSTR; lpWindowName:LPWSTR; dwStyle:DWORD; X:longint; Y:longint; 
             nWidth:longint; nHeight:longint; hWndParent:HWND; hInstance:HINSTANCE; lParam:LPARAM):HWND; external 'user32.dll' name 'CreateMDIWindowW';

  function WinHelp(hWndMain:HWND; lpszHelp:LPCWSTR; uCommand:UINT; dwData:DWORD):WINBOOL; external 'user32.dll' name 'WinHelpW';

  function ChangeDisplaySettings(lpDevMode:LPDEVMODE; dwFlags:DWORD):LONG; external 'user32.dll' name 'ChangeDisplaySettingsW';

  function EnumDisplaySettings(lpszDeviceName:LPCWSTR; iModeNum:DWORD; lpDevMode:LPDEVMODE):WINBOOL; external 'user32.dll' name 'EnumDisplaySettingsW';

  function SystemParametersInfo(uiAction:UINT; uiParam:UINT; pvParam:PVOID; fWinIni:UINT):WINBOOL; external 'user32.dll' name 'SystemParametersInfoW';

  function AddFontResource(_para1:LPCWSTR):longint; external 'gdi32.dll' name 'AddFontResourceW';

  function CopyMetaFile(_para1:HMETAFILE; _para2:LPCWSTR):HMETAFILE; external 'gdi32.dll' name 'CopyMetaFileW';

  function CreateFontIndirect(var _para1:LOGFONT):HFONT; external 'gdi32.dll' name 'CreateFontIndirectW';

  function CreateFont(_para1:longint; _para2:longint; _para3:longint; _para4:longint; _para5:longint; 
             _para6:DWORD; _para7:DWORD; _para8:DWORD; _para9:DWORD; _para10:DWORD; 
             _para11:DWORD; _para12:DWORD; _para13:DWORD; _para14:LPCWSTR):HFONT; external 'gdi32.dll' name 'CreateFontW';

  function CreateIC(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR; var _para4:DEVMODE):HDC; external 'gdi32.dll' name 'CreateICW';

  function CreateMetaFile(_para1:LPCWSTR):HDC; external 'gdi32.dll' name 'CreateMetaFileW';

  function CreateScalableFontResource(_para1:DWORD; _para2:LPCWSTR; _para3:LPCWSTR; _para4:LPCWSTR):WINBOOL; external 'gdi32.dll' name 'CreateScalableFontResourceW';

  function DeviceCapabilities(_para1:LPCWSTR; _para2:LPCWSTR; _para3:WORD; _para4:LPWSTR; var _para5:DEVMODE):longint; external 'winspool.drv' name 'DeviceCapabilitiesW';

  function EnumFontFamiliesEx(_para1:HDC; _para2:LPLOGFONT; _para3:FONTENUMEXPROC; _para4:LPARAM; _para5:DWORD):longint; external 'gdi32.dll' name 'EnumFontFamiliesExW';

  function EnumFontFamilies(_para1:HDC; _para2:LPCWSTR; _para3:FONTENUMPROC; _para4:LPARAM):longint; external 'gdi32.dll' name 'EnumFontFamiliesW';

  function EnumFonts(_para1:HDC; _para2:LPCWSTR; _para3:ENUMFONTSPROC; _para4:LPARAM):longint; external 'gdi32.dll' name 'EnumFontsW';

  function GetCharWidth(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPINT):WINBOOL; external 'gdi32.dll' name 'GetCharWidthW';

  function GetCharWidth32(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPINT):WINBOOL; external 'gdi32.dll' name 'GetCharWidth32W';

  function GetCharWidthFloat(_para1:HDC; _para2:UINT; _para3:UINT; _para4:PFLOAT):WINBOOL; external 'gdi32.dll' name 'GetCharWidthFloatW';

  function GetCharABCWidths(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPABC):WINBOOL; external 'gdi32.dll' name 'GetCharABCWidthsW';

  function GetCharABCWidthsFloat(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPABCFLOAT):WINBOOL; external 'gdi32.dll' name 'GetCharABCWidthsFloatW';

  function GetGlyphOutline(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPGLYPHMETRICS; _para5:DWORD; 
             _para6:LPVOID; var _para7:MAT2):DWORD; external 'gdi32.dll' name 'GetGlyphOutlineW';

  function GetMetaFile(_para1:LPCWSTR):HMETAFILE; external 'gdi32.dll' name 'GetMetaFileW';

  function GetOutlineTextMetrics(_para1:HDC; _para2:UINT; _para3:LPOUTLINETEXTMETRIC):UINT; external 'gdi32.dll' name 'GetOutlineTextMetricsW';

  function GetTextExtentPoint(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:LPSIZE):WINBOOL; external 'gdi32.dll' name 'GetTextExtentPointW';

  function GetTextExtentPoint32(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:LPSIZE):WINBOOL; external 'gdi32.dll' name 'GetTextExtentPoint32W';

  function GetTextExtentExPoint(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:longint; _para5:LPINT; 
             _para6:LPINT; _para7:LPSIZE):WINBOOL; external 'gdi32.dll' name 'GetTextExtentExPointW';

  function GetCharacterPlacement(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:longint; _para5:LPGCP_RESULTS; 
             _para6:DWORD):DWORD; external 'gdi32.dll' name 'GetCharacterPlacementW';

  function ResetDC(_para1:HDC; var _para2:DEVMODE):HDC; external 'gdi32.dll' name 'ResetDCW';

  function RemoveFontResource(_para1:LPCWSTR):WINBOOL; external 'gdi32.dll' name 'RemoveFontResourceW';

  function CopyEnhMetaFile(_para1:HENHMETAFILE; _para2:LPCWSTR):HENHMETAFILE; external 'gdi32.dll' name 'CopyEnhMetaFileW';

  function CreateEnhMetaFile(_para1:HDC; _para2:LPCWSTR; var _para3:RECT; _para4:LPCWSTR):HDC; external 'gdi32.dll' name 'CreateEnhMetaFileW';

  function GetEnhMetaFile(_para1:LPCWSTR):HENHMETAFILE; external 'gdi32.dll' name 'GetEnhMetaFileW';

  function GetEnhMetaFileDescription(_para1:HENHMETAFILE; _para2:UINT; _para3:LPWSTR):UINT; external 'gdi32.dll' name 'GetEnhMetaFileDescriptionW';

  function GetTextMetrics(_para1:HDC; _para2:LPTEXTMETRIC):WINBOOL; external 'gdi32.dll' name 'GetTextMetricsW';

  function StartDoc(_para1:HDC; var _para2:DOCINFO):longint; external 'gdi32.dll' name 'StartDocW';

  function GetObject(_para1:HGDIOBJ; _para2:longint; _para3:LPVOID):longint; external 'gdi32.dll' name 'GetObjectW';

  function TextOut(_para1:HDC; _para2:longint; _para3:longint; _para4:LPCWSTR; _para5:longint):WINBOOL; external 'gdi32.dll' name 'TextOutW';

  function ExtTextOut(_para1:HDC; _para2:longint; _para3:longint; _para4:UINT; var _para5:RECT; 
             _para6:LPCWSTR; _para7:UINT; var _para8:INT):WINBOOL; external 'gdi32.dll' name 'ExtTextOutW';

  function PolyTextOut(_para1:HDC; var _para2:POLYTEXT; _para3:longint):WINBOOL; external 'gdi32.dll' name 'PolyTextOutW';

  function GetTextFace(_para1:HDC; _para2:longint; _para3:LPWSTR):longint; external 'gdi32.dll' name 'GetTextFaceW';

  function GetKerningPairs(_para1:HDC; _para2:DWORD; _para3:LPKERNINGPAIR):DWORD; external 'gdi32.dll' name 'GetKerningPairsW';

  function GetLogColorSpace(_para1:HCOLORSPACE; _para2:LPLOGCOLORSPACE; _para3:DWORD):WINBOOL; external 'gdi32.dll' name 'GetLogColorSpaceW';

  function CreateColorSpace(_para1:LPLOGCOLORSPACE):HCOLORSPACE; external 'gdi32.dll' name 'CreateColorSpaceW';

  function GetICMProfile(_para1:HDC; _para2:DWORD; _para3:LPWSTR):WINBOOL; external 'gdi32.dll' name 'GetICMProfileW';

  function SetICMProfile(_para1:HDC; _para2:LPWSTR):WINBOOL; external 'gdi32.dll' name 'SetICMProfileW';

  function UpdateICMRegKey(_para1:DWORD; _para2:DWORD; _para3:LPWSTR; _para4:UINT):WINBOOL; external 'gdi32.dll' name 'UpdateICMRegKeyW';

  function EnumICMProfiles(_para1:HDC; _para2:ICMENUMPROC; _para3:LPARAM):longint; external 'gdi32.dll' name 'EnumICMProfilesW';

  function CreatePropertySheetPage(lppsp:LPCPROPSHEETPAGE):HPROPSHEETPAGE; external 'comctl32.dll' name 'CreatePropertySheetPageW';

  function PropertySheet(lppsph:LPCPROPSHEETHEADER):longint; external 'comctl32.dll' name 'PropertySheetW';

  function ImageList_LoadImage(hi:HINSTANCE; lpbmp:LPCWSTR; cx:longint; cGrow:longint; crMask:COLORREF; 
             uType:UINT; uFlags:UINT):HIMAGELIST; external 'comctl32.dll' name 'ImageList_LoadImageW';

  function CreateStatusWindow(style:LONG; lpszText:LPCWSTR; hwndParent:HWND; wID:UINT):HWND; external 'comctl32.dll' name 'CreateStatusWindowW';

  procedure DrawStatusText(hDC:HDC; lprc:LPRECT; pszText:LPCWSTR; uFlags:UINT); external 'comctl32.dll' name 'DrawStatusTextW';

  function GetOpenFileName(_para1:LPOPENFILENAME):WINBOOL; external 'comdlg32.dll' name 'GetOpenFileNameW';

  function GetSaveFileName(_para1:LPOPENFILENAME):WINBOOL; external 'comdlg32.dll' name 'GetSaveFileNameW';

  function GetFileTitle(_para1:LPCWSTR; _para2:LPWSTR; _para3:WORD):integer; external 'comdlg32.dll' name 'GetFileTitleW';

  function ChooseColor(_para1:LPCHOOSECOLOR):WINBOOL; external 'comdlg32.dll' name 'ChooseColorW';

  function ReplaceText(_para1:LPFINDREPLACE):HWND; external 'comdlg32.dll' name 'ReplaceTextW';

  function ChooseFont(_para1:LPCHOOSEFONT):WINBOOL; external 'comdlg32.dll' name 'ChooseFontW';

  function FindText(_para1:LPFINDREPLACE):HWND; external 'comdlg32.dll' name 'FindTextW';

  function PrintDlg(_para1:LPPRINTDLG):WINBOOL; external 'comdlg32.dll' name 'PrintDlgW';

  function PageSetupDlg(_para1:LPPAGESETUPDLG):WINBOOL; external 'comdlg32.dll' name 'PageSetupDlgW';

  function CreateProcess(lpApplicationName:LPCWSTR; lpCommandLine:LPWSTR; lpProcessAttributes:LPSECURITY_ATTRIBUTES; lpThreadAttributes:LPSECURITY_ATTRIBUTES; bInheritHandles:WINBOOL; 
             dwCreationFlags:DWORD; lpEnvironment:LPVOID; lpCurrentDirectory:LPCWSTR; lpStartupInfo:LPSTARTUPINFO; lpProcessInformation:LPPROCESS_INFORMATION):WINBOOL; external 'kernel32.dll' name 'CreateProcessW';

  procedure GetStartupInfo(lpStartupInfo:LPSTARTUPINFO); external 'kernel32.dll' name 'GetStartupInfoW';

  function FindFirstFile(lpFileName:LPCWSTR; lpFindFileData:LPWIN32_FIND_DATA):HANDLE; external 'kernel32.dll' name 'FindFirstFileW';

  function FindNextFile(hFindFile:HANDLE; lpFindFileData:LPWIN32_FIND_DATA):WINBOOL; external 'kernel32.dll' name 'FindNextFileW';

  function GetVersionEx(lpVersionInformation:LPOSVERSIONINFO):WINBOOL; external 'kernel32.dll' name 'GetVersionExW';

  { was #define dname(params) def_expr }
  function CreateWindow(lpClassName:LPCWSTR; lpWindowName:LPCWSTR; dwStyle:DWORD; X:longint;
             Y:longint; nWidth:longint; nHeight:longint; hWndParent:HWND; hMenu:HMENU; 
             hInstance:HINSTANCE; lpParam:LPVOID):HWND;
    begin
       CreateWindow:=CreateWindowExW(0,lpClassName,lpWindowName,dwStyle,x,y,nWidth,nHeight,hWndParent,hMenu,hInstance,lpParam);
    end;

  { was #define dname(params) def_expr }
  function CreateDialog(hInstance:HINSTANCE; lpName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC):HWND;
    begin
       CreateDialog:=CreateDialogParamW(hInstance,lpName,hWndParent,lpDialogFunc,0);
    end;

  { was #define dname(params) def_expr }
  function CreateDialogIndirect(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC):HWND;
    begin
       CreateDialogIndirect:=CreateDialogIndirectParamW(hInstance,lpTemplate,hWndParent,lpDialogFunc,0);
    end;

  { was #define dname(params) def_expr }
  function DialogBox(hInstance:HINSTANCE; lpTemplate:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC):longint;
    begin
       DialogBox:=DialogBoxParamW(hInstance,lpTemplate,hWndParent,lpDialogFunc,0);
    end;

  { was #define dname(params) def_expr }
  function DialogBoxIndirect(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC):longint;
    begin
       DialogBoxIndirect:=DialogBoxIndirectParamW(hInstance,lpTemplate,hWndParent,lpDialogFunc,0);
    end;

  function CreateDC(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR; var _para4:DEVMODE):HDC; external 'gdi32.dll' name 'CreateDCW';

  function CreateFontA(_para1:longint; _para2:longint; _para3:longint; _para4:longint; _para5:longint; 
             _para6:DWORD; _para7:DWORD; _para8:DWORD; _para9:DWORD; _para10:DWORD; 
             _para11:DWORD; _para12:DWORD; _para13:DWORD; _para14:LPCSTR):HFONT; external 'gdi32.dll' name 'CreateFontA';

  function VerInstallFile(uFlags:DWORD; szSrcFileName:LPWSTR; szDestFileName:LPWSTR; szSrcDir:LPWSTR; szDestDir:LPWSTR; 
             szCurDir:LPWSTR; szTmpFile:LPWSTR; lpuTmpFileLen:PUINT):DWORD; external 'version.dll' name 'VerInstallFileW';

  function GetFileVersionInfoSize(lptstrFilename:LPWSTR; lpdwHandle:LPDWORD):DWORD; external 'version.dll' name 'GetFileVersionInfoSizeW';

  function GetFileVersionInfo(lptstrFilename:LPWSTR; dwHandle:DWORD; dwLen:DWORD; lpData:LPVOID):WINBOOL; external 'version.dll' name 'GetFileVersionInfoW';

  function VerLanguageName(wLang:DWORD; szLang:LPWSTR; nSize:DWORD):DWORD; external 'kernel32.dll' name 'VerLanguageNameW';

  function VerQueryValue(pBlock:LPVOID; lpSubBlock:LPWSTR; var lplpBuffer:LPVOID; puLen:PUINT):WINBOOL; external 'version.dll' name 'VerQueryValueW';

  function VerFindFile(uFlags:DWORD; szFileName:LPWSTR; szWinDir:LPWSTR; szAppDir:LPWSTR; szCurDir:LPWSTR; 
             lpuCurDirLen:PUINT; szDestDir:LPWSTR; lpuDestDirLen:PUINT):DWORD; external 'version.dll' name 'VerFindFileW';

  function RegSetValueEx(hKey:HKEY; lpValueName:LPCWSTR; Reserved:DWORD; dwType:DWORD; var lpData:BYTE; 
             cbData:DWORD):LONG; external 'advapi32.dll' name 'RegSetValueExW';

  function RegUnLoadKey(hKey:HKEY; lpSubKey:LPCWSTR):LONG; external 'advapi32.dll' name 'RegUnLoadKeyW';

  function InitiateSystemShutdown(lpMachineName:LPWSTR; lpMessage:LPWSTR; dwTimeout:DWORD; bForceAppsClosed:WINBOOL; bRebootAfterShutdown:WINBOOL):WINBOOL; external 'advapi32.dll' name 'InitiateSystemShutdownW';

  function AbortSystemShutdown(lpMachineName:LPWSTR):WINBOOL; external 'advapi32.dll' name 'AbortSystemShutdownW';

  function RegRestoreKey(hKey:HKEY; lpFile:LPCWSTR; dwFlags:DWORD):LONG; external 'advapi32.dll' name 'RegRestoreKeyW';

  function RegSaveKey(hKey:HKEY; lpFile:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):LONG; external 'advapi32.dll' name 'RegSaveKeyW';

  function RegSetValue(hKey:HKEY; lpSubKey:LPCWSTR; dwType:DWORD; lpData:LPCWSTR; cbData:DWORD):LONG; external 'advapi32.dll' name 'RegSetValueW';

  function RegQueryValue(hKey:HKEY; lpSubKey:LPCWSTR; lpValue:LPWSTR; lpcbValue:PLONG):LONG; external 'advapi32.dll' name 'RegQueryValueW';

  function RegQueryMultipleValues(hKey:HKEY; val_list:PVALENT; num_vals:DWORD; lpValueBuf:LPWSTR; ldwTotsize:LPDWORD):LONG; external 'advapi32.dll' name 'RegQueryMultipleValuesW';

  function RegQueryValueEx(hKey:HKEY; lpValueName:LPCWSTR; lpReserved:LPDWORD; lpType:LPDWORD; lpData:LPBYTE; 
             lpcbData:LPDWORD):LONG; external 'advapi32.dll' name 'RegQueryValueExW';

  function RegReplaceKey(hKey:HKEY; lpSubKey:LPCWSTR; lpNewFile:LPCWSTR; lpOldFile:LPCWSTR):LONG; external 'advapi32.dll' name 'RegReplaceKeyW';

  function RegConnectRegistry(lpMachineName:LPWSTR; hKey:HKEY; phkResult:PHKEY):LONG; external 'advapi32.dll' name 'RegConnectRegistryW';

  function RegCreateKey(hKey:HKEY; lpSubKey:LPCWSTR; phkResult:PHKEY):LONG; external 'advapi32.dll' name 'RegCreateKeyW';

  function RegCreateKeyEx(hKey:HKEY; lpSubKey:LPCWSTR; Reserved:DWORD; lpClass:LPWSTR; dwOptions:DWORD; 
             samDesired:REGSAM; lpSecurityAttributes:LPSECURITY_ATTRIBUTES; phkResult:PHKEY; lpdwDisposition:LPDWORD):LONG; external 'advapi32.dll' name 'RegCreateKeyExW';

  function RegDeleteKey(hKey:HKEY; lpSubKey:LPCWSTR):LONG; external 'advapi32.dll' name 'RegDeleteKeyW';

  function RegDeleteValue(hKey:HKEY; lpValueName:LPCWSTR):LONG; external 'advapi32.dll' name 'RegDeleteValueW';

  function RegEnumKey(hKey:HKEY; dwIndex:DWORD; lpName:LPWSTR; cbName:DWORD):LONG; external 'advapi32.dll' name 'RegEnumKeyW';

  function RegEnumKeyEx(hKey:HKEY; dwIndex:DWORD; lpName:LPWSTR; lpcbName:LPDWORD; lpReserved:LPDWORD; 
             lpClass:LPWSTR; lpcbClass:LPDWORD; lpftLastWriteTime:PFILETIME):LONG; external 'advapi32.dll' name 'RegEnumKeyExW';

  function RegEnumValue(hKey:HKEY; dwIndex:DWORD; lpValueName:LPWSTR; lpcbValueName:LPDWORD; lpReserved:LPDWORD; 
             lpType:LPDWORD; lpData:LPBYTE; lpcbData:LPDWORD):LONG; external 'advapi32.dll' name 'RegEnumValueW';

  function RegLoadKey(hKey:HKEY; lpSubKey:LPCWSTR; lpFile:LPCWSTR):LONG; external 'advapi32.dll' name 'RegLoadKeyW';

  function RegOpenKey(hKey:HKEY; lpSubKey:LPCWSTR; phkResult:PHKEY):LONG; external 'advapi32.dll' name 'RegOpenKeyW';

  function RegOpenKeyEx(hKey:HKEY; lpSubKey:LPCWSTR; ulOptions:DWORD; samDesired:REGSAM; phkResult:PHKEY):LONG; external 'advapi32.dll' name 'RegOpenKeyExW';

  function RegQueryInfoKey(hKey:HKEY; lpClass:LPWSTR; lpcbClass:LPDWORD; lpReserved:LPDWORD; lpcSubKeys:LPDWORD; 
             lpcbMaxSubKeyLen:LPDWORD; lpcbMaxClassLen:LPDWORD; lpcValues:LPDWORD; lpcbMaxValueNameLen:LPDWORD; lpcbMaxValueLen:LPDWORD; 
             lpcbSecurityDescriptor:LPDWORD; lpftLastWriteTime:PFILETIME):LONG; external 'advapi32.dll' name 'RegQueryInfoKeyW';

  function CompareString(Locale:LCID; dwCmpFlags:DWORD; lpString1:LPCWSTR; cchCount1:longint; lpString2:LPCWSTR; 
             cchCount2:longint):longint; external 'kernel32.dll' name 'CompareStringW';

  function LCMapString(Locale:LCID; dwMapFlags:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpDestStr:LPWSTR; 
             cchDest:longint):longint; external 'kernel32.dll' name 'LCMapStringW';

  function GetLocaleInfo(Locale:LCID; LCType:LCTYPE; lpLCData:LPWSTR; cchData:longint):longint; external 'kernel32.dll' name 'GetLocaleInfoW';

  function SetLocaleInfo(Locale:LCID; LCType:LCTYPE; lpLCData:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'SetLocaleInfoW';

  function GetTimeFormat(Locale:LCID; dwFlags:DWORD; var lpTime:SYSTEMTIME; lpFormat:LPCWSTR; lpTimeStr:LPWSTR; 
             cchTime:longint):longint; external 'kernel32.dll' name 'GetTimeFormatW';

  function GetDateFormat(Locale:LCID; dwFlags:DWORD; var lpDate:SYSTEMTIME; lpFormat:LPCWSTR; lpDateStr:LPWSTR; 
             cchDate:longint):longint; external 'kernel32.dll' name 'GetDateFormatW';

  function GetNumberFormat(Locale:LCID; dwFlags:DWORD; lpValue:LPCWSTR; var lpFormat:NUMBERFMT; lpNumberStr:LPWSTR; 
             cchNumber:longint):longint; external 'kernel32.dll' name 'GetNumberFormatW';

  function GetCurrencyFormat(Locale:LCID; dwFlags:DWORD; lpValue:LPCWSTR; var lpFormat:CURRENCYFMT; lpCurrencyStr:LPWSTR; 
             cchCurrency:longint):longint; external 'kernel32.dll' name 'GetCurrencyFormatW';

  function EnumCalendarInfo(lpCalInfoEnumProc:CALINFO_ENUMPROC; Locale:LCID; Calendar:CALID; CalType:CALTYPE):WINBOOL; external 'kernel32.dll' name 'EnumCalendarInfoW';

  function EnumTimeFormats(lpTimeFmtEnumProc:TIMEFMT_ENUMPROC; Locale:LCID; dwFlags:DWORD):WINBOOL; external 'kernel32.dll' name 'EnumTimeFormatsW';

  function EnumDateFormats(lpDateFmtEnumProc:DATEFMT_ENUMPROC; Locale:LCID; dwFlags:DWORD):WINBOOL; external 'kernel32.dll' name 'EnumDateFormatsW';

  function GetStringTypeEx(Locale:LCID; dwInfoType:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpCharType:LPWORD):WINBOOL; external 'kernel32.dll' name 'GetStringTypeExW';

  function GetStringType(dwInfoType:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpCharType:LPWORD):WINBOOL; external 'kernel32.dll' name 'GetStringTypeW';

  function FoldString(dwMapFlags:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpDestStr:LPWSTR; cchDest:longint):longint; external 'kernel32.dll' name 'FoldStringW';

  function EnumSystemLocales(lpLocaleEnumProc:LOCALE_ENUMPROC; dwFlags:DWORD):WINBOOL; external 'kernel32.dll' name 'EnumSystemLocalesW';

  function EnumSystemCodePages(lpCodePageEnumProc:CODEPAGE_ENUMPROC; dwFlags:DWORD):WINBOOL; external 'kernel32.dll' name 'EnumSystemCodePagesW';

  function PeekConsoleInput(hConsoleInput:HANDLE; lpBuffer:PINPUT_RECORD; nLength:DWORD; lpNumberOfEventsRead:LPDWORD):WINBOOL; external 'kernel32.dll' name 'PeekConsoleInputW';

  function ReadConsoleInput(hConsoleInput:HANDLE; lpBuffer:PINPUT_RECORD; nLength:DWORD; lpNumberOfEventsRead:LPDWORD):WINBOOL; external 'kernel32.dll' name 'ReadConsoleInputW';

  function WriteConsoleInput(hConsoleInput:HANDLE; var lpBuffer:INPUT_RECORD; nLength:DWORD; lpNumberOfEventsWritten:LPDWORD):WINBOOL; external 'kernel32.dll' name 'WriteConsoleInputW';

  function ReadConsoleOutput(hConsoleOutput:HANDLE; lpBuffer:PCHAR_INFO; dwBufferSize:COORD; dwBufferCoord:COORD; lpReadRegion:PSMALL_RECT):WINBOOL; external 'kernel32.dll' name 'ReadConsoleOutputW';

  function WriteConsoleOutput(hConsoleOutput:HANDLE; var lpBuffer:CHAR_INFO; dwBufferSize:COORD; dwBufferCoord:COORD; lpWriteRegion:PSMALL_RECT):WINBOOL; external 'kernel32.dll' name 'WriteConsoleOutputW';

  function ReadConsoleOutputCharacter(hConsoleOutput:HANDLE; lpCharacter:LPWSTR; nLength:DWORD; dwReadCoord:COORD; lpNumberOfCharsRead:LPDWORD):WINBOOL; external 'kernel32.dll' name 'ReadConsoleOutputCharacterW';

  function WriteConsoleOutputCharacter(hConsoleOutput:HANDLE; lpCharacter:LPCWSTR; nLength:DWORD; dwWriteCoord:COORD; lpNumberOfCharsWritten:LPDWORD):WINBOOL; external 'kernel32.dll' name 'WriteConsoleOutputCharacterW';

  function FillConsoleOutputCharacter(hConsoleOutput:HANDLE; cCharacter:WCHAR; nLength:DWORD; dwWriteCoord:COORD; lpNumberOfCharsWritten:LPDWORD):WINBOOL; external 'kernel32.dll' name 'FillConsoleOutputCharacterW';

  function ScrollConsoleScreenBuffer(hConsoleOutput:HANDLE; var lpScrollRectangle:SMALL_RECT; var lpClipRectangle:SMALL_RECT; dwDestinationOrigin:COORD; var lpFill:CHAR_INFO):WINBOOL; external 'kernel32.dll' name 'ScrollConsoleScreenBufferW';

  function GetConsoleTitle(lpConsoleTitle:LPWSTR; nSize:DWORD):DWORD; external 'kernel32.dll' name 'GetConsoleTitleW';

  function SetConsoleTitle(lpConsoleTitle:LPCWSTR):WINBOOL; external 'kernel32.dll' name 'SetConsoleTitleW';

  function ReadConsole(hConsoleInput:HANDLE; lpBuffer:LPVOID; nNumberOfCharsToRead:DWORD; lpNumberOfCharsRead:LPDWORD; lpReserved:LPVOID):WINBOOL; external 'kernel32.dll' name 'ReadConsoleW';

  function WriteConsole(hConsoleOutput:HANDLE;lpBuffer:pointer; nNumberOfCharsToWrite:DWORD; lpNumberOfCharsWritten:LPDWORD; lpReserved:LPVOID):WINBOOL; external 'kernel32.dll' name 'WriteConsoleW';

  function WNetAddConnection(lpRemoteName:LPCWSTR; lpPassword:LPCWSTR; lpLocalName:LPCWSTR):DWORD; external 'mpr.dll' name 'WNetAddConnectionW';

  function WNetAddConnection2(lpNetResource:LPNETRESOURCE; lpPassword:LPCWSTR; lpUserName:LPCWSTR; dwFlags:DWORD):DWORD; external 'mpr.dll' name 'WNetAddConnection2W';

  function WNetAddConnection3(hwndOwner:HWND; lpNetResource:LPNETRESOURCE; lpPassword:LPCWSTR; lpUserName:LPCWSTR; dwFlags:DWORD):DWORD; external 'mpr.dll' name 'WNetAddConnection3W';

  function WNetCancelConnection(lpName:LPCWSTR; fForce:WINBOOL):DWORD; external 'mpr.dll' name 'WNetCancelConnectionW';

  function WNetCancelConnection2(lpName:LPCWSTR; dwFlags:DWORD; fForce:WINBOOL):DWORD; external 'mpr.dll' name 'WNetCancelConnection2W';

  function WNetGetConnection(lpLocalName:LPCWSTR; lpRemoteName:LPWSTR; lpnLength:LPDWORD):DWORD; external 'mpr.dll' name 'WNetGetConnectionW';

  function WNetUseConnection(hwndOwner:HWND; lpNetResource:LPNETRESOURCE; lpUserID:LPCWSTR; lpPassword:LPCWSTR; dwFlags:DWORD; 
             lpAccessName:LPWSTR; lpBufferSize:LPDWORD; lpResult:LPDWORD):DWORD; external 'mpr.dll' name 'WNetUseConnectionW';

  function WNetSetConnection(lpName:LPCWSTR; dwProperties:DWORD; pvValues:LPVOID):DWORD; external 'mpr.dll' name 'WNetSetConnectionW';

  function WNetConnectionDialog1(lpConnDlgStruct:LPCONNECTDLGSTRUCT):DWORD; external 'mpr.dll' name 'WNetConnectionDialog1W';

  function WNetDisconnectDialog1(lpConnDlgStruct:LPDISCDLGSTRUCT):DWORD; external 'mpr.dll' name 'WNetDisconnectDialog1W';

  function WNetOpenEnum(dwScope:DWORD; dwType:DWORD; dwUsage:DWORD; lpNetResource:LPNETRESOURCE; lphEnum:LPHANDLE):DWORD; external 'mpr.dll' name 'WNetOpenEnumW';

  function WNetEnumResource(hEnum:HANDLE; lpcCount:LPDWORD; lpBuffer:LPVOID; lpBufferSize:LPDWORD):DWORD; external 'mpr.dll' name 'WNetEnumResourceW';

  function WNetGetUniversalName(lpLocalPath:LPCWSTR; dwInfoLevel:DWORD; lpBuffer:LPVOID; lpBufferSize:LPDWORD):DWORD; external 'mpr.dll' name 'WNetGetUniversalNameW';

  function WNetGetUser(lpName:LPCWSTR; lpUserName:LPWSTR; lpnLength:LPDWORD):DWORD; external 'mpr.dll' name 'WNetGetUserW';

  function WNetGetProviderName(dwNetType:DWORD; lpProviderName:LPWSTR; lpBufferSize:LPDWORD):DWORD; external 'mpr.dll' name 'WNetGetProviderNameW';

  function WNetGetNetworkInformation(lpProvider:LPCWSTR; lpNetInfoStruct:LPNETINFOSTRUCT):DWORD; external 'mpr.dll' name 'WNetGetNetworkInformationW';

  function WNetGetLastError(lpError:LPDWORD; lpErrorBuf:LPWSTR; nErrorBufSize:DWORD; lpNameBuf:LPWSTR; nNameBufSize:DWORD):DWORD; external 'mpr.dll' name 'WNetGetLastErrorW';

  function MultinetGetConnectionPerformance(lpNetResource:LPNETRESOURCE; lpNetConnectInfoStruct:LPNETCONNECTINFOSTRUCT):DWORD; external 'mpr.dll' name 'MultinetGetConnectionPerformanceW';

  function ChangeServiceConfig(hService:SC_HANDLE; dwServiceType:DWORD; dwStartType:DWORD; dwErrorControl:DWORD; lpBinaryPathName:LPCWSTR; 
             lpLoadOrderGroup:LPCWSTR; lpdwTagId:LPDWORD; lpDependencies:LPCWSTR; lpServiceStartName:LPCWSTR; lpPassword:LPCWSTR; 
             lpDisplayName:LPCWSTR):WINBOOL; external 'advapi32.dll' name 'ChangeServiceConfigW';

  function CreateService(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; lpDisplayName:LPCWSTR; dwDesiredAccess:DWORD; dwServiceType:DWORD; 
             dwStartType:DWORD; dwErrorControl:DWORD; lpBinaryPathName:LPCWSTR; lpLoadOrderGroup:LPCWSTR; lpdwTagId:LPDWORD; 
             lpDependencies:LPCWSTR; lpServiceStartName:LPCWSTR; lpPassword:LPCWSTR):SC_HANDLE; external 'advapi32.dll' name 'CreateServiceW';

  function EnumDependentServices(hService:SC_HANDLE; dwServiceState:DWORD; lpServices:LPENUM_SERVICE_STATUS; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD; 
             lpServicesReturned:LPDWORD):WINBOOL; external 'advapi32.dll' name 'EnumDependentServicesW';

  function EnumServicesStatus(hSCManager:SC_HANDLE; dwServiceType:DWORD; dwServiceState:DWORD; lpServices:LPENUM_SERVICE_STATUS; cbBufSize:DWORD; 
             pcbBytesNeeded:LPDWORD; lpServicesReturned:LPDWORD; lpResumeHandle:LPDWORD):WINBOOL; external 'advapi32.dll' name 'EnumServicesStatusW';

  function GetServiceKeyName(hSCManager:SC_HANDLE; lpDisplayName:LPCWSTR; lpServiceName:LPWSTR; lpcchBuffer:LPDWORD):WINBOOL; external 'advapi32.dll' name 'GetServiceKeyNameW';

  function GetServiceDisplayName(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; lpDisplayName:LPWSTR; lpcchBuffer:LPDWORD):WINBOOL; external 'advapi32.dll' name 'GetServiceDisplayNameW';

  function OpenSCManager(lpMachineName:LPCWSTR; lpDatabaseName:LPCWSTR; dwDesiredAccess:DWORD):SC_HANDLE; external 'advapi32.dll' name 'OpenSCManagerW';

  function OpenService(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; dwDesiredAccess:DWORD):SC_HANDLE; external 'advapi32.dll' name 'OpenServiceW';

  function QueryServiceConfig(hService:SC_HANDLE; lpServiceConfig:LPQUERY_SERVICE_CONFIG; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD):WINBOOL; external 'advapi32.dll' name 'QueryServiceConfigW';

  function QueryServiceLockStatus(hSCManager:SC_HANDLE; lpLockStatus:LPQUERY_SERVICE_LOCK_STATUS; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD):WINBOOL; external 'advapi32.dll' name 'QueryServiceLockStatusW';

  function RegisterServiceCtrlHandler(lpServiceName:LPCWSTR; lpHandlerProc:LPHANDLER_FUNCTION):SERVICE_STATUS_HANDLE; external 'advapi32.dll' name 'RegisterServiceCtrlHandlerW';

  function StartServiceCtrlDispatcher(lpServiceStartTable:LPSERVICE_TABLE_ENTRY):WINBOOL; external 'advapi32.dll' name 'StartServiceCtrlDispatcherW';

  function StartService(hService:SC_HANDLE; dwNumServiceArgs:DWORD; var lpServiceArgVectors:LPCWSTR):WINBOOL; external 'advapi32.dll' name 'StartServiceW';

  function wglUseFontBitmaps(_para1:HDC; _para2:DWORD; _para3:DWORD; _para4:DWORD):WINBOOL; external 'opengl32.dll' name 'wglUseFontBitmapsW';

  function wglUseFontOutlines(_para1:HDC; _para2:DWORD; _para3:DWORD; _para4:DWORD; _para5:FLOAT; 
             _para6:FLOAT; _para7:longint; _para8:LPGLYPHMETRICSFLOAT):WINBOOL; external 'opengl32.dll' name 'wglUseFontOutlinesW';

  function DragQueryFile(_para1:HDROP; _para2:cardinal; _para3:LPCWSTR; _para4:cardinal):cardinal; external 'shell32.dll' name 'DragQueryFileW';

  function ExtractAssociatedIcon(_para1:HINSTANCE; _para2:LPCWSTR; var _para3:WORD):HICON; external 'shell32.dll' name 'ExtractAssociatedIconW';

  function ExtractIcon(_para1:HINSTANCE; _para2:LPCWSTR; _para3:cardinal):HICON; external 'shell32.dll' name 'ExtractIconW';

  function FindExecutable(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR):HINSTANCE; external 'shell32.dll' name 'FindExecutableW';

  function ShellAbout(_para1:HWND; _para2:LPCWSTR; _para3:LPCWSTR; _para4:HICON):longint; external 'shell32.dll' name 'ShellAboutW';

  function ShellExecute(_para1:HWND; _para2:LPCWSTR; _para3:LPCWSTR; _para4:LPCWSTR; _para5:LPCWSTR; 
             _para6:longint):HINSTANCE; external 'shell32.dll' name 'ShellExecuteW';

  function DdeCreateStringHandle(_para1:DWORD; _para2:LPCWSTR; _para3:longint):HSZ; external 'user32.dll' name 'DdeCreateStringHandleW';

  function DdeInitialize(var _para1:DWORD; _para2:CALLB; _para3:DWORD; _para4:DWORD):UINT; external 'user32.dll' name 'DdeInitializeW';

  function DdeQueryString(_para1:DWORD; _para2:HSZ; _para3:LPCWSTR; _para4:DWORD; _para5:longint):DWORD; external 'user32.dll' name 'DdeQueryStringW';

  function LogonUser(_para1:LPWSTR; _para2:LPWSTR; _para3:LPWSTR; _para4:DWORD; _para5:DWORD; 
             var _para6:HANDLE):WINBOOL; external 'advapi32.dll' name 'LogonUserW';

  function CreateProcessAsUser(_para1:HANDLE; _para2:LPCWSTR; _para3:LPWSTR; var _para4:SECURITY_ATTRIBUTES; var _para5:SECURITY_ATTRIBUTES; 
             _para6:WINBOOL; _para7:DWORD; _para8:LPVOID; _para9:LPCWSTR; var _para10:STARTUPINFO; 
             var _para11:PROCESS_INFORMATION):WINBOOL; external 'advapi32.dll' name 'CreateProcessAsUserW';


{$endif read_implementation}

{$ifndef windows_include_files}
end.
{$endif not windows_include_files}
{
  $Log$
  Revision 1.3  1998-09-03 18:17:36  pierre
    * small improvements in number of found functions
      all remaining are in func.pp

  Revision 1.2  1998/09/03 17:14:57  pierre
    * most functions found in main DLL's
      still some missing
      use 'make dllnames' to get missing names

  Revision 1.1  1998/08/31 11:54:02  pierre
    * compilable windows.pp file
      still to do :
       - findout problems
       - findout the correct DLL for each call !!

}
