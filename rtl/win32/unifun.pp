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

unit unifun;

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
{$ifndef _GNU_H_WINDOWS32_UNICODEFUNCTIONS}
{$define _GNU_H_WINDOWS32_UNICODEFUNCTIONS}
{ C++ extern C conditionnal removed }
  { __cplusplus  }

  function GetBinaryTypeW(lpApplicationName:LPCWSTR; lpBinaryType:LPDWORD):WINBOOL;

  function GetShortPathNameW(lpszLongPath:LPCWSTR; lpszShortPath:LPWSTR; cchBuffer:DWORD):DWORD;

  function GetEnvironmentStringsW:LPWSTR;

  function FreeEnvironmentStringsW(_para1:LPWSTR):WINBOOL;

  function FormatMessageW(dwFlags:DWORD; lpSource:LPCVOID; dwMessageId:DWORD; dwLanguageId:DWORD; lpBuffer:LPWSTR; 
             nSize:DWORD; var Arguments:va_list):DWORD;

  function CreateMailslotW(lpName:LPCWSTR; nMaxMessageSize:DWORD; lReadTimeout:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):HANDLE;

  function lstrcmpW(lpString1:LPCWSTR; lpString2:LPCWSTR):longint;

  function lstrcmpiW(lpString1:LPCWSTR; lpString2:LPCWSTR):longint;

  function lstrcpynW(lpString1:LPWSTR; lpString2:LPCWSTR; iMaxLength:longint):LPWSTR;

  function lstrcpyW(lpString1:LPWSTR; lpString2:LPCWSTR):LPWSTR;

  function lstrcatW(lpString1:LPWSTR; lpString2:LPCWSTR):LPWSTR;

  function lstrlenW(lpString:LPCWSTR):longint;

  function CreateMutexW(lpMutexAttributes:LPSECURITY_ATTRIBUTES; bInitialOwner:WINBOOL; lpName:LPCWSTR):HANDLE;

  function OpenMutexW(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE;

  function CreateEventW(lpEventAttributes:LPSECURITY_ATTRIBUTES; bManualReset:WINBOOL; bInitialState:WINBOOL; lpName:LPCWSTR):HANDLE;

  function OpenEventW(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE;

  function CreateSemaphoreW(lpSemaphoreAttributes:LPSECURITY_ATTRIBUTES; lInitialCount:LONG; lMaximumCount:LONG; lpName:LPCWSTR):HANDLE;

  function OpenSemaphoreW(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE;

  function CreateFileMappingW(hFile:HANDLE; lpFileMappingAttributes:LPSECURITY_ATTRIBUTES; flProtect:DWORD; dwMaximumSizeHigh:DWORD; dwMaximumSizeLow:DWORD; 
             lpName:LPCWSTR):HANDLE;

  function OpenFileMappingW(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE;

  function GetLogicalDriveStringsW(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD;

  function LoadLibraryW(lpLibFileName:LPCWSTR):HINSTANCE;

  function LoadLibraryExW(lpLibFileName:LPCWSTR; hFile:HANDLE; dwFlags:DWORD):HINSTANCE;

  function GetModuleFileNameW(hModule:HINSTANCE; lpFilename:LPWSTR; nSize:DWORD):DWORD;

  function GetModuleHandleW(lpModuleName:LPCWSTR):HMODULE;

  procedure FatalAppExitW(uAction:UINT; lpMessageText:LPCWSTR);

  function GetCommandLineW:LPWSTR;

  function GetEnvironmentVariableW(lpName:LPCWSTR; lpBuffer:LPWSTR; nSize:DWORD):DWORD;

  function SetEnvironmentVariableW(lpName:LPCWSTR; lpValue:LPCWSTR):WINBOOL;

  function ExpandEnvironmentStringsW(lpSrc:LPCWSTR; lpDst:LPWSTR; nSize:DWORD):DWORD;

  procedure OutputDebugStringW(lpOutputString:LPCWSTR);

  function FindResourceW(hModule:HINSTANCE; lpName:LPCWSTR; lpType:LPCWSTR):HRSRC;

  function FindResourceExW(hModule:HINSTANCE; lpType:LPCWSTR; lpName:LPCWSTR; wLanguage:WORD):HRSRC;

  function EnumResourceTypesW(hModule:HINSTANCE; lpEnumFunc:ENUMRESTYPEPROC; lParam:LONG):WINBOOL;

  function EnumResourceNamesW(hModule:HINSTANCE; lpType:LPCWSTR; lpEnumFunc:ENUMRESNAMEPROC; lParam:LONG):WINBOOL;

  function EnumResourceLanguagesW(hModule:HINSTANCE; lpType:LPCWSTR; lpName:LPCWSTR; lpEnumFunc:ENUMRESLANGPROC; lParam:LONG):WINBOOL;

  function BeginUpdateResourceW(pFileName:LPCWSTR; bDeleteExistingResources:WINBOOL):HANDLE;

  function UpdateResourceW(hUpdate:HANDLE; lpType:LPCWSTR; lpName:LPCWSTR; wLanguage:WORD; lpData:LPVOID; 
             cbData:DWORD):WINBOOL;

  function EndUpdateResourceW(hUpdate:HANDLE; fDiscard:WINBOOL):WINBOOL;

  function GlobalAddAtomW(lpString:LPCWSTR):ATOM;

  function GlobalFindAtomW(lpString:LPCWSTR):ATOM;

  function GlobalGetAtomNameW(nAtom:ATOM; lpBuffer:LPWSTR; nSize:longint):UINT;

  function AddAtomW(lpString:LPCWSTR):ATOM;

  function FindAtomW(lpString:LPCWSTR):ATOM;

  function GetAtomNameW(nAtom:ATOM; lpBuffer:LPWSTR; nSize:longint):UINT;

  function GetProfileIntW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; nDefault:INT):UINT;

  function GetProfileStringW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpDefault:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD):DWORD;

  function WriteProfileStringW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpString:LPCWSTR):WINBOOL;

  function GetProfileSectionW(lpAppName:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD):DWORD;

  function WriteProfileSectionW(lpAppName:LPCWSTR; lpString:LPCWSTR):WINBOOL;

  function GetPrivateProfileIntW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; nDefault:INT; lpFileName:LPCWSTR):UINT;

  function GetPrivateProfileStringW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpDefault:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD; 
             lpFileName:LPCWSTR):DWORD;

  function WritePrivateProfileStringW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpString:LPCWSTR; lpFileName:LPCWSTR):WINBOOL;

  function GetPrivateProfileSectionW(lpAppName:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD; lpFileName:LPCWSTR):DWORD;

  function WritePrivateProfileSectionW(lpAppName:LPCWSTR; lpString:LPCWSTR; lpFileName:LPCWSTR):WINBOOL;

  function GetDriveTypeW(lpRootPathName:LPCWSTR):UINT;

  function GetSystemDirectoryW(lpBuffer:LPWSTR; uSize:UINT):UINT;

  function GetTempPathW(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD;

  function GetTempFileNameW(lpPathName:LPCWSTR; lpPrefixString:LPCWSTR; uUnique:UINT; lpTempFileName:LPWSTR):UINT;

  function GetWindowsDirectoryW(lpBuffer:LPWSTR; uSize:UINT):UINT;

  function SetCurrentDirectoryW(lpPathName:LPCWSTR):WINBOOL;

  function GetCurrentDirectoryW(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD;

  function GetDiskFreeSpaceW(lpRootPathName:LPCWSTR; lpSectorsPerCluster:LPDWORD; lpBytesPerSector:LPDWORD; lpNumberOfFreeClusters:LPDWORD; lpTotalNumberOfClusters:LPDWORD):WINBOOL;

  function CreateDirectoryW(lpPathName:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):WINBOOL;

  function CreateDirectoryExW(lpTemplateDirectory:LPCWSTR; lpNewDirectory:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):WINBOOL;

  function RemoveDirectoryW(lpPathName:LPCWSTR):WINBOOL;

  function GetFullPathNameW(lpFileName:LPCWSTR; nBufferLength:DWORD; lpBuffer:LPWSTR; var lpFilePart:LPWSTR):DWORD;

  function DefineDosDeviceW(dwFlags:DWORD; lpDeviceName:LPCWSTR; lpTargetPath:LPCWSTR):WINBOOL;

  function QueryDosDeviceW(lpDeviceName:LPCWSTR; lpTargetPath:LPWSTR; ucchMax:DWORD):DWORD;

  function CreateFileW(lpFileName:LPCWSTR; dwDesiredAccess:DWORD; dwShareMode:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES; dwCreationDisposition:DWORD; 
             dwFlagsAndAttributes:DWORD; hTemplateFile:HANDLE):HANDLE;

  function SetFileAttributesW(lpFileName:LPCWSTR; dwFileAttributes:DWORD):WINBOOL;

  function GetFileAttributesW(lpFileName:LPCWSTR):DWORD;

  function GetCompressedFileSizeW(lpFileName:LPCWSTR; lpFileSizeHigh:LPDWORD):DWORD;

  function DeleteFileW(lpFileName:LPCWSTR):WINBOOL;

  function SearchPathW(lpPath:LPCWSTR; lpFileName:LPCWSTR; lpExtension:LPCWSTR; nBufferLength:DWORD; lpBuffer:LPWSTR; 
             var lpFilePart:LPWSTR):DWORD;

  function CopyFileW(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR; bFailIfExists:WINBOOL):WINBOOL;

  function MoveFileW(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR):WINBOOL;

  function MoveFileExW(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR; dwFlags:DWORD):WINBOOL;

  function CreateNamedPipeW(lpName:LPCWSTR; dwOpenMode:DWORD; dwPipeMode:DWORD; nMaxInstances:DWORD; nOutBufferSize:DWORD; 
             nInBufferSize:DWORD; nDefaultTimeOut:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):HANDLE;

  function GetNamedPipeHandleStateW(hNamedPipe:HANDLE; lpState:LPDWORD; lpCurInstances:LPDWORD; lpMaxCollectionCount:LPDWORD; lpCollectDataTimeout:LPDWORD; 
             lpUserName:LPWSTR; nMaxUserNameSize:DWORD):WINBOOL;

  function CallNamedPipeW(lpNamedPipeName:LPCWSTR; lpInBuffer:LPVOID; nInBufferSize:DWORD; lpOutBuffer:LPVOID; nOutBufferSize:DWORD; 
             lpBytesRead:LPDWORD; nTimeOut:DWORD):WINBOOL;

  function WaitNamedPipeW(lpNamedPipeName:LPCWSTR; nTimeOut:DWORD):WINBOOL;

  function SetVolumeLabelW(lpRootPathName:LPCWSTR; lpVolumeName:LPCWSTR):WINBOOL;

  function GetVolumeInformationW(lpRootPathName:LPCWSTR; lpVolumeNameBuffer:LPWSTR; nVolumeNameSize:DWORD; lpVolumeSerialNumber:LPDWORD; lpMaximumComponentLength:LPDWORD; 
             lpFileSystemFlags:LPDWORD; lpFileSystemNameBuffer:LPWSTR; nFileSystemNameSize:DWORD):WINBOOL;

  function ClearEventLogW(hEventLog:HANDLE; lpBackupFileName:LPCWSTR):WINBOOL;

  function BackupEventLogW(hEventLog:HANDLE; lpBackupFileName:LPCWSTR):WINBOOL;

  function OpenEventLogW(lpUNCServerName:LPCWSTR; lpSourceName:LPCWSTR):HANDLE;

  function RegisterEventSourceW(lpUNCServerName:LPCWSTR; lpSourceName:LPCWSTR):HANDLE;

  function OpenBackupEventLogW(lpUNCServerName:LPCWSTR; lpFileName:LPCWSTR):HANDLE;

  function ReadEventLogW(hEventLog:HANDLE; dwReadFlags:DWORD; dwRecordOffset:DWORD; lpBuffer:LPVOID; nNumberOfBytesToRead:DWORD; 
             var pnBytesRead:DWORD; var pnMinNumberOfBytesNeeded:DWORD):WINBOOL;

  function ReportEventW(hEventLog:HANDLE; wType:WORD; wCategory:WORD; dwEventID:DWORD; lpUserSid:PSID; 
             wNumStrings:WORD; dwDataSize:DWORD; var lpStrings:LPCWSTR; lpRawData:LPVOID):WINBOOL;

  function AccessCheckAndAuditAlarmW(SubsystemName:LPCWSTR; HandleId:LPVOID; ObjectTypeName:LPWSTR; ObjectName:LPWSTR; SecurityDescriptor:PSECURITY_DESCRIPTOR; 
             DesiredAccess:DWORD; GenericMapping:PGENERIC_MAPPING; ObjectCreation:WINBOOL; GrantedAccess:LPDWORD; AccessStatus:LPBOOL; 
             pfGenerateOnClose:LPBOOL):WINBOOL;

  function ObjectOpenAuditAlarmW(SubsystemName:LPCWSTR; HandleId:LPVOID; ObjectTypeName:LPWSTR; ObjectName:LPWSTR; pSecurityDescriptor:PSECURITY_DESCRIPTOR; 
             ClientToken:HANDLE; DesiredAccess:DWORD; GrantedAccess:DWORD; Privileges:PPRIVILEGE_SET; ObjectCreation:WINBOOL; 
             AccessGranted:WINBOOL; GenerateOnClose:LPBOOL):WINBOOL;

  function ObjectPrivilegeAuditAlarmW(SubsystemName:LPCWSTR; HandleId:LPVOID; ClientToken:HANDLE; DesiredAccess:DWORD; Privileges:PPRIVILEGE_SET; 
             AccessGranted:WINBOOL):WINBOOL;

  function ObjectCloseAuditAlarmW(SubsystemName:LPCWSTR; HandleId:LPVOID; GenerateOnClose:WINBOOL):WINBOOL;

  function PrivilegedServiceAuditAlarmW(SubsystemName:LPCWSTR; ServiceName:LPCWSTR; ClientToken:HANDLE; Privileges:PPRIVILEGE_SET; AccessGranted:WINBOOL):WINBOOL;

  function SetFileSecurityW(lpFileName:LPCWSTR; SecurityInformation:SECURITY_INFORMATION; pSecurityDescriptor:PSECURITY_DESCRIPTOR):WINBOOL;

  function GetFileSecurityW(lpFileName:LPCWSTR; RequestedInformation:SECURITY_INFORMATION; pSecurityDescriptor:PSECURITY_DESCRIPTOR; nLength:DWORD; lpnLengthNeeded:LPDWORD):WINBOOL;

  function FindFirstChangeNotificationW(lpPathName:LPCWSTR; bWatchSubtree:WINBOOL; dwNotifyFilter:DWORD):HANDLE;

  function IsBadStringPtrW(lpsz:LPCWSTR; ucchMax:UINT):WINBOOL;

  function LookupAccountSidW(lpSystemName:LPCWSTR; Sid:PSID; Name:LPWSTR; cbName:LPDWORD; ReferencedDomainName:LPWSTR; 
             cbReferencedDomainName:LPDWORD; peUse:PSID_NAME_USE):WINBOOL;

  function LookupAccountNameW(lpSystemName:LPCWSTR; lpAccountName:LPCWSTR; Sid:PSID; cbSid:LPDWORD; ReferencedDomainName:LPWSTR; 
             cbReferencedDomainName:LPDWORD; peUse:PSID_NAME_USE):WINBOOL;

  function LookupPrivilegeValueW(lpSystemName:LPCWSTR; lpName:LPCWSTR; lpLuid:PLUID):WINBOOL;

  function LookupPrivilegeNameW(lpSystemName:LPCWSTR; lpLuid:PLUID; lpName:LPWSTR; cbName:LPDWORD):WINBOOL;

  function LookupPrivilegeDisplayNameW(lpSystemName:LPCWSTR; lpName:LPCWSTR; lpDisplayName:LPWSTR; cbDisplayName:LPDWORD; lpLanguageId:LPDWORD):WINBOOL;

  function BuildCommDCBW(lpDef:LPCWSTR; lpDCB:LPDCB):WINBOOL;

  function BuildCommDCBAndTimeoutsW(lpDef:LPCWSTR; lpDCB:LPDCB; lpCommTimeouts:LPCOMMTIMEOUTS):WINBOOL;

  function CommConfigDialogW(lpszName:LPCWSTR; hWnd:HWND; lpCC:LPCOMMCONFIG):WINBOOL;

  function GetDefaultCommConfigW(lpszName:LPCWSTR; lpCC:LPCOMMCONFIG; lpdwSize:LPDWORD):WINBOOL;

  function SetDefaultCommConfigW(lpszName:LPCWSTR; lpCC:LPCOMMCONFIG; dwSize:DWORD):WINBOOL;

  function GetComputerNameW(lpBuffer:LPWSTR; nSize:LPDWORD):WINBOOL;

  function SetComputerNameW(lpComputerName:LPCWSTR):WINBOOL;

  function GetUserNameW(lpBuffer:LPWSTR; nSize:LPDWORD):WINBOOL;

  function wvsprintfW(_para1:LPWSTR; _para2:LPCWSTR; arglist:va_list):longint;

  { variable number of args not yet implemented in FPC
  function wsprintfW(_para1:LPWSTR; _para2:LPCWSTR; ...):longint;}

  function LoadKeyboardLayoutW(pwszKLID:LPCWSTR; Flags:UINT):HKL;

  function GetKeyboardLayoutNameW(pwszKLID:LPWSTR):WINBOOL;

  function CreateDesktopW(lpszDesktop:LPWSTR; lpszDevice:LPWSTR; pDevmode:LPDEVMODE; dwFlags:DWORD; dwDesiredAccess:DWORD; 
             lpsa:LPSECURITY_ATTRIBUTES):HDESK;

  function OpenDesktopW(lpszDesktop:LPWSTR; dwFlags:DWORD; fInherit:WINBOOL; dwDesiredAccess:DWORD):HDESK;

  function EnumDesktopsW(hwinsta:HWINSTA; lpEnumFunc:DESKTOPENUMPROC; lParam:LPARAM):WINBOOL;

  function CreateWindowStationW(lpwinsta:LPWSTR; dwReserved:DWORD; dwDesiredAccess:DWORD; lpsa:LPSECURITY_ATTRIBUTES):HWINSTA;

  function OpenWindowStationW(lpszWinSta:LPWSTR; fInherit:WINBOOL; dwDesiredAccess:DWORD):HWINSTA;

  function EnumWindowStationsW(lpEnumFunc:ENUMWINDOWSTATIONPROC; lParam:LPARAM):WINBOOL;

  function GetUserObjectInformationW(hObj:HANDLE; nIndex:longint; pvInfo:PVOID; nLength:DWORD; lpnLengthNeeded:LPDWORD):WINBOOL;

  function SetUserObjectInformationW(hObj:HANDLE; nIndex:longint; pvInfo:PVOID; nLength:DWORD):WINBOOL;

  function RegisterWindowMessageW(lpString:LPCWSTR):UINT;

  function GetMessageW(lpMsg:LPMSG; hWnd:HWND; wMsgFilterMin:UINT; wMsgFilterMax:UINT):WINBOOL;

(* Const before type ignored *)
  function DispatchMessageW(var lpMsg:MSG):LONG;

  function PeekMessageW(lpMsg:LPMSG; hWnd:HWND; wMsgFilterMin:UINT; wMsgFilterMax:UINT; wRemoveMsg:UINT):WINBOOL;

  function SendMessageW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function SendMessageTimeoutW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM; fuFlags:UINT; 
             uTimeout:UINT; lpdwResult:LPDWORD):LRESULT;

  function SendNotifyMessageW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL;

  function SendMessageCallbackW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM; lpResultCallBack:SENDASYNCPROC; 
             dwData:DWORD):WINBOOL;

  function PostMessageW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL;

  function PostThreadMessageW(idThread:DWORD; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL;

  function DefWindowProcW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function CallWindowProcW(lpPrevWndFunc:WNDPROC; hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

(* Const before type ignored *)
  function RegisterClassW(var lpWndClass:WNDCLASS):ATOM;

  function UnregisterClassW(lpClassName:LPCWSTR; hInstance:HINSTANCE):WINBOOL;

  function GetClassInfoW(hInstance:HINSTANCE; lpClassName:LPCWSTR; lpWndClass:LPWNDCLASS):WINBOOL;

(* Const before type ignored *)
  function RegisterClassExW(var _para1:WNDCLASSEX):ATOM;

  function GetClassInfoExW(_para1:HINSTANCE; _para2:LPCWSTR; _para3:LPWNDCLASSEX):WINBOOL;

  function CreateWindowExW(dwExStyle:DWORD; lpClassName:LPCWSTR; lpWindowName:LPCWSTR; dwStyle:DWORD; X:longint; 
             Y:longint; nWidth:longint; nHeight:longint; hWndParent:HWND; hMenu:HMENU; 
             hInstance:HINSTANCE; lpParam:LPVOID):HWND;

  function CreateDialogParamW(hInstance:HINSTANCE; lpTemplateName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):HWND;

  function CreateDialogIndirectParamW(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):HWND;

  function DialogBoxParamW(hInstance:HINSTANCE; lpTemplateName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):longint;

  function DialogBoxIndirectParamW(hInstance:HINSTANCE; hDialogTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):longint;

  function SetDlgItemTextW(hDlg:HWND; nIDDlgItem:longint; lpString:LPCWSTR):WINBOOL;

  function GetDlgItemTextW(hDlg:HWND; nIDDlgItem:longint; lpString:LPWSTR; nMaxCount:longint):UINT;

  function SendDlgItemMessageW(hDlg:HWND; nIDDlgItem:longint; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LONG;

  function DefDlgProcW(hDlg:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function CallMsgFilterW(lpMsg:LPMSG; nCode:longint):WINBOOL;

  function RegisterClipboardFormatW(lpszFormat:LPCWSTR):UINT;

  function GetClipboardFormatNameW(format:UINT; lpszFormatName:LPWSTR; cchMaxCount:longint):longint;

  function CharToOemW(lpszSrc:LPCWSTR; lpszDst:LPSTR):WINBOOL;

  function OemToCharW(lpszSrc:LPCSTR; lpszDst:LPWSTR):WINBOOL;

  function CharToOemBuffW(lpszSrc:LPCWSTR; lpszDst:LPSTR; cchDstLength:DWORD):WINBOOL;

  function OemToCharBuffW(lpszSrc:LPCSTR; lpszDst:LPWSTR; cchDstLength:DWORD):WINBOOL;

  function CharUpperW(lpsz:LPWSTR):LPWSTR;

  function CharUpperBuffW(lpsz:LPWSTR; cchLength:DWORD):DWORD;

  function CharLowerW(lpsz:LPWSTR):LPWSTR;

  function CharLowerBuffW(lpsz:LPWSTR; cchLength:DWORD):DWORD;

  function CharNextW(lpsz:LPCWSTR):LPWSTR;

  function CharPrevW(lpszStart:LPCWSTR; lpszCurrent:LPCWSTR):LPWSTR;

  function IsCharAlphaW(ch:WCHAR):WINBOOL;

  function IsCharAlphaNumericW(ch:WCHAR):WINBOOL;

  function IsCharUpperW(ch:WCHAR):WINBOOL;

  function IsCharLowerW(ch:WCHAR):WINBOOL;

  function GetKeyNameTextW(lParam:LONG; lpString:LPWSTR; nSize:longint):longint;

  function VkKeyScanW(ch:WCHAR):SHORT;

  function VkKeyScanExW(ch:WCHAR; dwhkl:HKL):SHORT;

  function MapVirtualKeyW(uCode:UINT; uMapType:UINT):UINT;

  function MapVirtualKeyExW(uCode:UINT; uMapType:UINT; dwhkl:HKL):UINT;

  function LoadAcceleratorsW(hInstance:HINSTANCE; lpTableName:LPCWSTR):HACCEL;

  function CreateAcceleratorTableW(_para1:LPACCEL; _para2:longint):HACCEL;

  function CopyAcceleratorTableW(hAccelSrc:HACCEL; lpAccelDst:LPACCEL; cAccelEntries:longint):longint;

  function TranslateAcceleratorW(hWnd:HWND; hAccTable:HACCEL; lpMsg:LPMSG):longint;

  function LoadMenuW(hInstance:HINSTANCE; lpMenuName:LPCWSTR):HMENU;

(* Const before type ignored *)
  function LoadMenuIndirectW(var lpMenuTemplate:MENUTEMPLATE):HMENU;

  function ChangeMenuW(hMenu:HMENU; cmd:UINT; lpszNewItem:LPCWSTR; cmdInsert:UINT; flags:UINT):WINBOOL;

  function GetMenuStringW(hMenu:HMENU; uIDItem:UINT; lpString:LPWSTR; nMaxCount:longint; uFlag:UINT):longint;

  function InsertMenuW(hMenu:HMENU; uPosition:UINT; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL;

  function AppendMenuW(hMenu:HMENU; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL;

  function ModifyMenuW(hMnu:HMENU; uPosition:UINT; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL;

  function InsertMenuItemW(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPCMENUITEMINFO):WINBOOL;

  function GetMenuItemInfoW(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPMENUITEMINFO):WINBOOL;

  function SetMenuItemInfoW(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPCMENUITEMINFO):WINBOOL;

  function DrawTextW(hDC:HDC; lpString:LPCWSTR; nCount:longint; lpRect:LPRECT; uFormat:UINT):longint;

  function DrawTextExW(_para1:HDC; _para2:LPWSTR; _para3:longint; _para4:LPRECT; _para5:UINT; 
             _para6:LPDRAWTEXTPARAMS):longint;

  function GrayStringW(hDC:HDC; hBrush:HBRUSH; lpOutputFunc:GRAYSTRINGPROC; lpData:LPARAM; nCount:longint; 
             X:longint; Y:longint; nWidth:longint; nHeight:longint):WINBOOL;

  function DrawStateW(_para1:HDC; _para2:HBRUSH; _para3:DRAWSTATEPROC; _para4:LPARAM; _para5:WPARAM; 
             _para6:longint; _para7:longint; _para8:longint; _para9:longint; _para10:UINT):WINBOOL;

  function TabbedTextOutW(hDC:HDC; X:longint; Y:longint; lpString:LPCWSTR; nCount:longint; 
             nTabPositions:longint; lpnTabStopPositions:LPINT; nTabOrigin:longint):LONG;

  function GetTabbedTextExtentW(hDC:HDC; lpString:LPCWSTR; nCount:longint; nTabPositions:longint; lpnTabStopPositions:LPINT):DWORD;

  function SetPropW(hWnd:HWND; lpString:LPCWSTR; hData:HANDLE):WINBOOL;

  function GetPropW(hWnd:HWND; lpString:LPCWSTR):HANDLE;

  function RemovePropW(hWnd:HWND; lpString:LPCWSTR):HANDLE;

  function EnumPropsExW(hWnd:HWND; lpEnumFunc:PROPENUMPROCEX; lParam:LPARAM):longint;

  function EnumPropsW(hWnd:HWND; lpEnumFunc:PROPENUMPROC):longint;

  function SetWindowTextW(hWnd:HWND; lpString:LPCWSTR):WINBOOL;

  function GetWindowTextW(hWnd:HWND; lpString:LPWSTR; nMaxCount:longint):longint;

  function GetWindowTextLengthW(hWnd:HWND):longint;

  function MessageBoxW(hWnd:HWND; lpText:LPCWSTR; lpCaption:LPCWSTR; uType:UINT):longint;

  function MessageBoxExW(hWnd:HWND; lpText:LPCWSTR; lpCaption:LPCWSTR; uType:UINT; wLanguageId:WORD):longint;

  function MessageBoxIndirectW(_para1:LPMSGBOXPARAMS):longint;

  function GetWindowLongW(hWnd:HWND; nIndex:longint):LONG;

  function SetWindowLongW(hWnd:HWND; nIndex:longint; dwNewLong:LONG):LONG;

  function GetClassLongW(hWnd:HWND; nIndex:longint):DWORD;

  function SetClassLongW(hWnd:HWND; nIndex:longint; dwNewLong:LONG):DWORD;

  function FindWindowW(lpClassName:LPCWSTR; lpWindowName:LPCWSTR):HWND;

  function FindWindowExW(_para1:HWND; _para2:HWND; _para3:LPCWSTR; _para4:LPCWSTR):HWND;

  function GetClassNameW(hWnd:HWND; lpClassName:LPWSTR; nMaxCount:longint):longint;

  function SetWindowsHookExW(idHook:longint; lpfn:HOOKPROC; hmod:HINSTANCE; dwThreadId:DWORD):HHOOK;

  function LoadBitmapW(hInstance:HINSTANCE; lpBitmapName:LPCWSTR):HBITMAP;

  function LoadCursorW(hInstance:HINSTANCE; lpCursorName:LPCWSTR):HCURSOR;

  function LoadCursorFromFileW(lpFileName:LPCWSTR):HCURSOR;

  function LoadIconW(hInstance:HINSTANCE; lpIconName:LPCWSTR):HICON;

  function LoadImageW(_para1:HINSTANCE; _para2:LPCWSTR; _para3:UINT; _para4:longint; _para5:longint; 
             _para6:UINT):HANDLE;

  function LoadStringW(hInstance:HINSTANCE; uID:UINT; lpBuffer:LPWSTR; nBufferMax:longint):longint;

  function IsDialogMessageW(hDlg:HWND; lpMsg:LPMSG):WINBOOL;

  function DlgDirListW(hDlg:HWND; lpPathSpec:LPWSTR; nIDListBox:longint; nIDStaticPath:longint; uFileType:UINT):longint;

  function DlgDirSelectExW(hDlg:HWND; lpString:LPWSTR; nCount:longint; nIDListBox:longint):WINBOOL;

  function DlgDirListComboBoxW(hDlg:HWND; lpPathSpec:LPWSTR; nIDComboBox:longint; nIDStaticPath:longint; uFiletype:UINT):longint;

  function DlgDirSelectComboBoxExW(hDlg:HWND; lpString:LPWSTR; nCount:longint; nIDComboBox:longint):WINBOOL;

  function DefFrameProcW(hWnd:HWND; hWndMDIClient:HWND; uMsg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function DefMDIChildProcW(hWnd:HWND; uMsg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;

  function CreateMDIWindowW(lpClassName:LPWSTR; lpWindowName:LPWSTR; dwStyle:DWORD; X:longint; Y:longint; 
             nWidth:longint; nHeight:longint; hWndParent:HWND; hInstance:HINSTANCE; lParam:LPARAM):HWND;

  function WinHelpW(hWndMain:HWND; lpszHelp:LPCWSTR; uCommand:UINT; dwData:DWORD):WINBOOL;

  function ChangeDisplaySettingsW(lpDevMode:LPDEVMODE; dwFlags:DWORD):LONG;

  function EnumDisplaySettingsW(lpszDeviceName:LPCWSTR; iModeNum:DWORD; lpDevMode:LPDEVMODE):WINBOOL;

  function SystemParametersInfoW(uiAction:UINT; uiParam:UINT; pvParam:PVOID; fWinIni:UINT):WINBOOL;

  function AddFontResourceW(_para1:LPCWSTR):longint;

  function CopyMetaFileW(_para1:HMETAFILE; _para2:LPCWSTR):HMETAFILE;

(* Const before type ignored *)
  function CreateFontIndirectW(var _para1:LOGFONT):HFONT;

  function CreateFontW(_para1:longint; _para2:longint; _para3:longint; _para4:longint; _para5:longint; 
             _para6:DWORD; _para7:DWORD; _para8:DWORD; _para9:DWORD; _para10:DWORD; 
             _para11:DWORD; _para12:DWORD; _para13:DWORD; _para14:LPCWSTR):HFONT;

(* Const before type ignored *)
  function CreateICW(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR; var _para4:DEVMODE):HDC;

  function CreateMetaFileW(_para1:LPCWSTR):HDC;

  function CreateScalableFontResourceW(_para1:DWORD; _para2:LPCWSTR; _para3:LPCWSTR; _para4:LPCWSTR):WINBOOL;

(* Const before type ignored *)
  function DeviceCapabilitiesW(_para1:LPCWSTR; _para2:LPCWSTR; _para3:WORD; _para4:LPWSTR; var _para5:DEVMODE):longint;

  function EnumFontFamiliesExW(_para1:HDC; _para2:LPLOGFONT; _para3:FONTENUMEXPROC; _para4:LPARAM; _para5:DWORD):longint;

  function EnumFontFamiliesW(_para1:HDC; _para2:LPCWSTR; _para3:FONTENUMPROC; _para4:LPARAM):longint;

  function EnumFontsW(_para1:HDC; _para2:LPCWSTR; _para3:ENUMFONTSPROC; _para4:LPARAM):longint;

  function GetCharWidthW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPINT):WINBOOL;

  function GetCharWidth32W(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPINT):WINBOOL;

  function GetCharWidthFloatW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:PFLOAT):WINBOOL;

  function GetCharABCWidthsW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPABC):WINBOOL;

  function GetCharABCWidthsFloatW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPABCFLOAT):WINBOOL;

(* Const before type ignored *)
  function GetGlyphOutlineW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPGLYPHMETRICS; _para5:DWORD; 
             _para6:LPVOID; var _para7:MAT2):DWORD;

  function GetMetaFileW(_para1:LPCWSTR):HMETAFILE;

  function GetOutlineTextMetricsW(_para1:HDC; _para2:UINT; _para3:LPOUTLINETEXTMETRIC):UINT;

  function GetTextExtentPointW(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:LPSIZE):WINBOOL;

  function GetTextExtentPoint32W(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:LPSIZE):WINBOOL;

  function GetTextExtentExPointW(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:longint; _para5:LPINT; 
             _para6:LPINT; _para7:LPSIZE):WINBOOL;

  function GetCharacterPlacementW(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:longint; _para5:LPGCP_RESULTS; 
             _para6:DWORD):DWORD;

(* Const before type ignored *)
  function ResetDCW(_para1:HDC; var _para2:DEVMODE):HDC;

  function RemoveFontResourceW(_para1:LPCWSTR):WINBOOL;

  function CopyEnhMetaFileW(_para1:HENHMETAFILE; _para2:LPCWSTR):HENHMETAFILE;

(* Const before type ignored *)
  function CreateEnhMetaFileW(_para1:HDC; _para2:LPCWSTR; var _para3:RECT; _para4:LPCWSTR):HDC;

  function GetEnhMetaFileW(_para1:LPCWSTR):HENHMETAFILE;

  function GetEnhMetaFileDescriptionW(_para1:HENHMETAFILE; _para2:UINT; _para3:LPWSTR):UINT;

  function GetTextMetricsW(_para1:HDC; _para2:LPTEXTMETRIC):WINBOOL;

(* Const before type ignored *)
  function StartDocW(_para1:HDC; var _para2:DOCINFO):longint;

  function GetObjectW(_para1:HGDIOBJ; _para2:longint; _para3:LPVOID):longint;

  function TextOutW(_para1:HDC; _para2:longint; _para3:longint; _para4:LPCWSTR; _para5:longint):WINBOOL;

(* Const before type ignored *)
(* Const before type ignored *)
  function ExtTextOutW(_para1:HDC; _para2:longint; _para3:longint; _para4:UINT; var _para5:RECT; 
             _para6:LPCWSTR; _para7:UINT; var _para8:INT):WINBOOL;

(* Const before type ignored *)
  function PolyTextOutW(_para1:HDC; var _para2:POLYTEXT; _para3:longint):WINBOOL;

  function GetTextFaceW(_para1:HDC; _para2:longint; _para3:LPWSTR):longint;

  function GetKerningPairsW(_para1:HDC; _para2:DWORD; _para3:LPKERNINGPAIR):DWORD;

  function GetLogColorSpaceW(_para1:HCOLORSPACE; _para2:LPLOGCOLORSPACE; _para3:DWORD):WINBOOL;

  function CreateColorSpaceW(_para1:LPLOGCOLORSPACE):HCOLORSPACE;

  function GetICMProfileW(_para1:HDC; _para2:DWORD; _para3:LPWSTR):WINBOOL;

  function SetICMProfileW(_para1:HDC; _para2:LPWSTR):WINBOOL;

  function UpdateICMRegKeyW(_para1:DWORD; _para2:DWORD; _para3:LPWSTR; _para4:UINT):WINBOOL;

  function EnumICMProfilesW(_para1:HDC; _para2:ICMENUMPROC; _para3:LPARAM):longint;

  function CreatePropertySheetPageW(lppsp:LPCPROPSHEETPAGE):HPROPSHEETPAGE;

  function PropertySheetW(lppsph:LPCPROPSHEETHEADER):longint;

  function ImageList_LoadImageW(hi:HINSTANCE; lpbmp:LPCWSTR; cx:longint; cGrow:longint; crMask:COLORREF; 
             uType:UINT; uFlags:UINT):HIMAGELIST;

  function CreateStatusWindowW(style:LONG; lpszText:LPCWSTR; hwndParent:HWND; wID:UINT):HWND;

  procedure DrawStatusTextW(hDC:HDC; lprc:LPRECT; pszText:LPCWSTR; uFlags:UINT);

  function GetOpenFileNameW(_para1:LPOPENFILENAME):WINBOOL;

  function GetSaveFileNameW(_para1:LPOPENFILENAME):WINBOOL;

  function GetFileTitleW(_para1:LPCWSTR; _para2:LPWSTR; _para3:WORD):integer;

  function ChooseColorW(_para1:LPCHOOSECOLOR):WINBOOL;

  function ReplaceTextW(_para1:LPFINDREPLACE):HWND;

  function ChooseFontW(_para1:LPCHOOSEFONT):WINBOOL;

  function FindTextW(_para1:LPFINDREPLACE):HWND;

  function PrintDlgW(_para1:LPPRINTDLG):WINBOOL;

  function PageSetupDlgW(_para1:LPPAGESETUPDLG):WINBOOL;

  function CreateProcessW(lpApplicationName:LPCWSTR; lpCommandLine:LPWSTR; lpProcessAttributes:LPSECURITY_ATTRIBUTES; lpThreadAttributes:LPSECURITY_ATTRIBUTES; bInheritHandles:WINBOOL; 
             dwCreationFlags:DWORD; lpEnvironment:LPVOID; lpCurrentDirectory:LPCWSTR; lpStartupInfo:LPSTARTUPINFO; lpProcessInformation:LPPROCESS_INFORMATION):WINBOOL;

  procedure GetStartupInfoW(lpStartupInfo:LPSTARTUPINFO);

  function FindFirstFileW(lpFileName:LPCWSTR; lpFindFileData:LPWIN32_FIND_DATA):HANDLE;

  function FindNextFileW(hFindFile:HANDLE; lpFindFileData:LPWIN32_FIND_DATA):WINBOOL;

  function GetVersionExW(lpVersionInformation:LPOSVERSIONINFO):WINBOOL;

  { was #define dname(params) def_expr }
  function CreateWindowW(lpClassName:LPCWSTR; lpWindowName:LPCWSTR; dwStyle:DWORD; X:longint;
             Y:longint; nWidth:longint; nHeight:longint; hWndParent:HWND; hMenu:HMENU; 
             hInstance:HINSTANCE; lpParam:LPVOID):HWND;

  { was #define dname(params) def_expr }
  function CreateDialogW(hInstance:HINSTANCE; lpName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC):HWND;

  { was #define dname(params) def_expr }
  function CreateDialogIndirectW(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC):HWND;

  { was #define dname(params) def_expr }
  function DialogBoxW(hInstance:HINSTANCE; lpTemplate:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC):longint;

  { was #define dname(params) def_expr }
  function DialogBoxIndirectW(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC):longint;

(* Const before type ignored *)
  function CreateDCW(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR; var _para4:DEVMODE):HDC;

  function CreateFontA(_para1:longint; _para2:longint; _para3:longint; _para4:longint; _para5:longint; 
             _para6:DWORD; _para7:DWORD; _para8:DWORD; _para9:DWORD; _para10:DWORD; 
             _para11:DWORD; _para12:DWORD; _para13:DWORD; _para14:LPCSTR):HFONT;

  function VerInstallFileW(uFlags:DWORD; szSrcFileName:LPWSTR; szDestFileName:LPWSTR; szSrcDir:LPWSTR; szDestDir:LPWSTR; 
             szCurDir:LPWSTR; szTmpFile:LPWSTR; lpuTmpFileLen:PUINT):DWORD;

  function GetFileVersionInfoSizeW(lptstrFilename:LPWSTR; lpdwHandle:LPDWORD):DWORD;

  function GetFileVersionInfoW(lptstrFilename:LPWSTR; dwHandle:DWORD; dwLen:DWORD; lpData:LPVOID):WINBOOL;

  function VerLanguageNameW(wLang:DWORD; szLang:LPWSTR; nSize:DWORD):DWORD;

(* Const before type ignored *)
  function VerQueryValueW(pBlock:LPVOID; lpSubBlock:LPWSTR; var lplpBuffer:LPVOID; puLen:PUINT):WINBOOL;

  function VerFindFileW(uFlags:DWORD; szFileName:LPWSTR; szWinDir:LPWSTR; szAppDir:LPWSTR; szCurDir:LPWSTR; 
             lpuCurDirLen:PUINT; szDestDir:LPWSTR; lpuDestDirLen:PUINT):DWORD;

(* Const before type ignored *)
  function RegSetValueExW(hKey:HKEY; lpValueName:LPCWSTR; Reserved:DWORD; dwType:DWORD; var lpData:BYTE; 
             cbData:DWORD):LONG;

  function RegUnLoadKeyW(hKey:HKEY; lpSubKey:LPCWSTR):LONG;

  function InitiateSystemShutdownW(lpMachineName:LPWSTR; lpMessage:LPWSTR; dwTimeout:DWORD; bForceAppsClosed:WINBOOL; bRebootAfterShutdown:WINBOOL):WINBOOL;

  function AbortSystemShutdownW(lpMachineName:LPWSTR):WINBOOL;

  function RegRestoreKeyW(hKey:HKEY; lpFile:LPCWSTR; dwFlags:DWORD):LONG;

  function RegSaveKeyW(hKey:HKEY; lpFile:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):LONG;

  function RegSetValueW(hKey:HKEY; lpSubKey:LPCWSTR; dwType:DWORD; lpData:LPCWSTR; cbData:DWORD):LONG;

  function RegQueryValueW(hKey:HKEY; lpSubKey:LPCWSTR; lpValue:LPWSTR; lpcbValue:PLONG):LONG;

  function RegQueryMultipleValuesW(hKey:HKEY; val_list:PVALENT; num_vals:DWORD; lpValueBuf:LPWSTR; ldwTotsize:LPDWORD):LONG;

  function RegQueryValueExW(hKey:HKEY; lpValueName:LPCWSTR; lpReserved:LPDWORD; lpType:LPDWORD; lpData:LPBYTE; 
             lpcbData:LPDWORD):LONG;

  function RegReplaceKeyW(hKey:HKEY; lpSubKey:LPCWSTR; lpNewFile:LPCWSTR; lpOldFile:LPCWSTR):LONG;

  function RegConnectRegistryW(lpMachineName:LPWSTR; hKey:HKEY; phkResult:PHKEY):LONG;

  function RegCreateKeyW(hKey:HKEY; lpSubKey:LPCWSTR; phkResult:PHKEY):LONG;

  function RegCreateKeyExW(hKey:HKEY; lpSubKey:LPCWSTR; Reserved:DWORD; lpClass:LPWSTR; dwOptions:DWORD; 
             samDesired:REGSAM; lpSecurityAttributes:LPSECURITY_ATTRIBUTES; phkResult:PHKEY; lpdwDisposition:LPDWORD):LONG;

  function RegDeleteKeyW(hKey:HKEY; lpSubKey:LPCWSTR):LONG;

  function RegDeleteValueW(hKey:HKEY; lpValueName:LPCWSTR):LONG;

  function RegEnumKeyW(hKey:HKEY; dwIndex:DWORD; lpName:LPWSTR; cbName:DWORD):LONG;

  function RegEnumKeyExW(hKey:HKEY; dwIndex:DWORD; lpName:LPWSTR; lpcbName:LPDWORD; lpReserved:LPDWORD; 
             lpClass:LPWSTR; lpcbClass:LPDWORD; lpftLastWriteTime:PFILETIME):LONG;

  function RegEnumValueW(hKey:HKEY; dwIndex:DWORD; lpValueName:LPWSTR; lpcbValueName:LPDWORD; lpReserved:LPDWORD; 
             lpType:LPDWORD; lpData:LPBYTE; lpcbData:LPDWORD):LONG;

  function RegLoadKeyW(hKey:HKEY; lpSubKey:LPCWSTR; lpFile:LPCWSTR):LONG;

  function RegOpenKeyW(hKey:HKEY; lpSubKey:LPCWSTR; phkResult:PHKEY):LONG;

  function RegOpenKeyExW(hKey:HKEY; lpSubKey:LPCWSTR; ulOptions:DWORD; samDesired:REGSAM; phkResult:PHKEY):LONG;

  function RegQueryInfoKeyW(hKey:HKEY; lpClass:LPWSTR; lpcbClass:LPDWORD; lpReserved:LPDWORD; lpcSubKeys:LPDWORD; 
             lpcbMaxSubKeyLen:LPDWORD; lpcbMaxClassLen:LPDWORD; lpcValues:LPDWORD; lpcbMaxValueNameLen:LPDWORD; lpcbMaxValueLen:LPDWORD; 
             lpcbSecurityDescriptor:LPDWORD; lpftLastWriteTime:PFILETIME):LONG;

  function CompareStringW(Locale:LCID; dwCmpFlags:DWORD; lpString1:LPCWSTR; cchCount1:longint; lpString2:LPCWSTR; 
             cchCount2:longint):longint;

  function LCMapStringW(Locale:LCID; dwMapFlags:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpDestStr:LPWSTR; 
             cchDest:longint):longint;

  function GetLocaleInfoW(Locale:LCID; LCType:LCTYPE; lpLCData:LPWSTR; cchData:longint):longint;

  function SetLocaleInfoW(Locale:LCID; LCType:LCTYPE; lpLCData:LPCWSTR):WINBOOL;

(* Const before type ignored *)
  function GetTimeFormatW(Locale:LCID; dwFlags:DWORD; var lpTime:SYSTEMTIME; lpFormat:LPCWSTR; lpTimeStr:LPWSTR; 
             cchTime:longint):longint;

(* Const before type ignored *)
  function GetDateFormatW(Locale:LCID; dwFlags:DWORD; var lpDate:SYSTEMTIME; lpFormat:LPCWSTR; lpDateStr:LPWSTR; 
             cchDate:longint):longint;

(* Const before type ignored *)
  function GetNumberFormatW(Locale:LCID; dwFlags:DWORD; lpValue:LPCWSTR; var lpFormat:NUMBERFMT; lpNumberStr:LPWSTR; 
             cchNumber:longint):longint;

(* Const before type ignored *)
  function GetCurrencyFormatW(Locale:LCID; dwFlags:DWORD; lpValue:LPCWSTR; var lpFormat:CURRENCYFMT; lpCurrencyStr:LPWSTR; 
             cchCurrency:longint):longint;

  function EnumCalendarInfoW(lpCalInfoEnumProc:CALINFO_ENUMPROC; Locale:LCID; Calendar:CALID; CalType:CALTYPE):WINBOOL;

  function EnumTimeFormatsW(lpTimeFmtEnumProc:TIMEFMT_ENUMPROC; Locale:LCID; dwFlags:DWORD):WINBOOL;

  function EnumDateFormatsW(lpDateFmtEnumProc:DATEFMT_ENUMPROC; Locale:LCID; dwFlags:DWORD):WINBOOL;

  function GetStringTypeExW(Locale:LCID; dwInfoType:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpCharType:LPWORD):WINBOOL;

  function GetStringTypeW(dwInfoType:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpCharType:LPWORD):WINBOOL;

  function FoldStringW(dwMapFlags:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpDestStr:LPWSTR; cchDest:longint):longint;

  function EnumSystemLocalesW(lpLocaleEnumProc:LOCALE_ENUMPROC; dwFlags:DWORD):WINBOOL;

  function EnumSystemCodePagesW(lpCodePageEnumProc:CODEPAGE_ENUMPROC; dwFlags:DWORD):WINBOOL;

  function PeekConsoleInputW(hConsoleInput:HANDLE; lpBuffer:PINPUT_RECORD; nLength:DWORD; lpNumberOfEventsRead:LPDWORD):WINBOOL;

  function ReadConsoleInputW(hConsoleInput:HANDLE; lpBuffer:PINPUT_RECORD; nLength:DWORD; lpNumberOfEventsRead:LPDWORD):WINBOOL;

(* Const before type ignored *)
  function WriteConsoleInputW(hConsoleInput:HANDLE; var lpBuffer:INPUT_RECORD; nLength:DWORD; lpNumberOfEventsWritten:LPDWORD):WINBOOL;

  function ReadConsoleOutputW(hConsoleOutput:HANDLE; lpBuffer:PCHAR_INFO; dwBufferSize:COORD; dwBufferCoord:COORD; lpReadRegion:PSMALL_RECT):WINBOOL;

(* Const before type ignored *)
  function WriteConsoleOutputW(hConsoleOutput:HANDLE; var lpBuffer:CHAR_INFO; dwBufferSize:COORD; dwBufferCoord:COORD; lpWriteRegion:PSMALL_RECT):WINBOOL;

  function ReadConsoleOutputCharacterW(hConsoleOutput:HANDLE; lpCharacter:LPWSTR; nLength:DWORD; dwReadCoord:COORD; lpNumberOfCharsRead:LPDWORD):WINBOOL;

  function WriteConsoleOutputCharacterW(hConsoleOutput:HANDLE; lpCharacter:LPCWSTR; nLength:DWORD; dwWriteCoord:COORD; lpNumberOfCharsWritten:LPDWORD):WINBOOL;

  function FillConsoleOutputCharacterW(hConsoleOutput:HANDLE; cCharacter:WCHAR; nLength:DWORD; dwWriteCoord:COORD; lpNumberOfCharsWritten:LPDWORD):WINBOOL;

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function ScrollConsoleScreenBufferW(hConsoleOutput:HANDLE; var lpScrollRectangle:SMALL_RECT; var lpClipRectangle:SMALL_RECT; dwDestinationOrigin:COORD; var lpFill:CHAR_INFO):WINBOOL;

  function GetConsoleTitleW(lpConsoleTitle:LPWSTR; nSize:DWORD):DWORD;

  function SetConsoleTitleW(lpConsoleTitle:LPCWSTR):WINBOOL;

  function ReadConsoleW(hConsoleInput:HANDLE; lpBuffer:LPVOID; nNumberOfCharsToRead:DWORD; lpNumberOfCharsRead:LPDWORD; lpReserved:LPVOID):WINBOOL;

(* Const before type ignored *)
  function WriteConsoleW(hConsoleOutput:HANDLE;lpBuffer:pointer; nNumberOfCharsToWrite:DWORD; lpNumberOfCharsWritten:LPDWORD; lpReserved:LPVOID):WINBOOL;

  function WNetAddConnectionW(lpRemoteName:LPCWSTR; lpPassword:LPCWSTR; lpLocalName:LPCWSTR):DWORD;

  function WNetAddConnection2W(lpNetResource:LPNETRESOURCE; lpPassword:LPCWSTR; lpUserName:LPCWSTR; dwFlags:DWORD):DWORD;

  function WNetAddConnection3W(hwndOwner:HWND; lpNetResource:LPNETRESOURCE; lpPassword:LPCWSTR; lpUserName:LPCWSTR; dwFlags:DWORD):DWORD;

  function WNetCancelConnectionW(lpName:LPCWSTR; fForce:WINBOOL):DWORD;

  function WNetCancelConnection2W(lpName:LPCWSTR; dwFlags:DWORD; fForce:WINBOOL):DWORD;

  function WNetGetConnectionW(lpLocalName:LPCWSTR; lpRemoteName:LPWSTR; lpnLength:LPDWORD):DWORD;

  function WNetUseConnectionW(hwndOwner:HWND; lpNetResource:LPNETRESOURCE; lpUserID:LPCWSTR; lpPassword:LPCWSTR; dwFlags:DWORD; 
             lpAccessName:LPWSTR; lpBufferSize:LPDWORD; lpResult:LPDWORD):DWORD;

  function WNetSetConnectionW(lpName:LPCWSTR; dwProperties:DWORD; pvValues:LPVOID):DWORD;

  function WNetConnectionDialog1W(lpConnDlgStruct:LPCONNECTDLGSTRUCT):DWORD;

  function WNetDisconnectDialog1W(lpConnDlgStruct:LPDISCDLGSTRUCT):DWORD;

  function WNetOpenEnumW(dwScope:DWORD; dwType:DWORD; dwUsage:DWORD; lpNetResource:LPNETRESOURCE; lphEnum:LPHANDLE):DWORD;

  function WNetEnumResourceW(hEnum:HANDLE; lpcCount:LPDWORD; lpBuffer:LPVOID; lpBufferSize:LPDWORD):DWORD;

  function WNetGetUniversalNameW(lpLocalPath:LPCWSTR; dwInfoLevel:DWORD; lpBuffer:LPVOID; lpBufferSize:LPDWORD):DWORD;

  function WNetGetUserW(lpName:LPCWSTR; lpUserName:LPWSTR; lpnLength:LPDWORD):DWORD;

  function WNetGetProviderNameW(dwNetType:DWORD; lpProviderName:LPWSTR; lpBufferSize:LPDWORD):DWORD;

  function WNetGetNetworkInformationW(lpProvider:LPCWSTR; lpNetInfoStruct:LPNETINFOSTRUCT):DWORD;

  function WNetGetLastErrorW(lpError:LPDWORD; lpErrorBuf:LPWSTR; nErrorBufSize:DWORD; lpNameBuf:LPWSTR; nNameBufSize:DWORD):DWORD;

  function MultinetGetConnectionPerformanceW(lpNetResource:LPNETRESOURCE; lpNetConnectInfoStruct:LPNETCONNECTINFOSTRUCT):DWORD;

  function ChangeServiceConfigW(hService:SC_HANDLE; dwServiceType:DWORD; dwStartType:DWORD; dwErrorControl:DWORD; lpBinaryPathName:LPCWSTR; 
             lpLoadOrderGroup:LPCWSTR; lpdwTagId:LPDWORD; lpDependencies:LPCWSTR; lpServiceStartName:LPCWSTR; lpPassword:LPCWSTR; 
             lpDisplayName:LPCWSTR):WINBOOL;

  function CreateServiceW(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; lpDisplayName:LPCWSTR; dwDesiredAccess:DWORD; dwServiceType:DWORD; 
             dwStartType:DWORD; dwErrorControl:DWORD; lpBinaryPathName:LPCWSTR; lpLoadOrderGroup:LPCWSTR; lpdwTagId:LPDWORD; 
             lpDependencies:LPCWSTR; lpServiceStartName:LPCWSTR; lpPassword:LPCWSTR):SC_HANDLE;

  function EnumDependentServicesW(hService:SC_HANDLE; dwServiceState:DWORD; lpServices:LPENUM_SERVICE_STATUS; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD; 
             lpServicesReturned:LPDWORD):WINBOOL;

  function EnumServicesStatusW(hSCManager:SC_HANDLE; dwServiceType:DWORD; dwServiceState:DWORD; lpServices:LPENUM_SERVICE_STATUS; cbBufSize:DWORD; 
             pcbBytesNeeded:LPDWORD; lpServicesReturned:LPDWORD; lpResumeHandle:LPDWORD):WINBOOL;

  function GetServiceKeyNameW(hSCManager:SC_HANDLE; lpDisplayName:LPCWSTR; lpServiceName:LPWSTR; lpcchBuffer:LPDWORD):WINBOOL;

  function GetServiceDisplayNameW(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; lpDisplayName:LPWSTR; lpcchBuffer:LPDWORD):WINBOOL;

  function OpenSCManagerW(lpMachineName:LPCWSTR; lpDatabaseName:LPCWSTR; dwDesiredAccess:DWORD):SC_HANDLE;

  function OpenServiceW(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; dwDesiredAccess:DWORD):SC_HANDLE;

  function QueryServiceConfigW(hService:SC_HANDLE; lpServiceConfig:LPQUERY_SERVICE_CONFIG; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD):WINBOOL;

  function QueryServiceLockStatusW(hSCManager:SC_HANDLE; lpLockStatus:LPQUERY_SERVICE_LOCK_STATUS; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD):WINBOOL;

  function RegisterServiceCtrlHandlerW(lpServiceName:LPCWSTR; lpHandlerProc:LPHANDLER_FUNCTION):SERVICE_STATUS_HANDLE;

  function StartServiceCtrlDispatcherW(lpServiceStartTable:LPSERVICE_TABLE_ENTRY):WINBOOL;

  function StartServiceW(hService:SC_HANDLE; dwNumServiceArgs:DWORD; var lpServiceArgVectors:LPCWSTR):WINBOOL;

  { Extensions to OpenGL  }
  function wglUseFontBitmapsW(_para1:HDC; _para2:DWORD; _para3:DWORD; _para4:DWORD):WINBOOL;

  function wglUseFontOutlinesW(_para1:HDC; _para2:DWORD; _para3:DWORD; _para4:DWORD; _para5:FLOAT; 
             _para6:FLOAT; _para7:longint; _para8:LPGLYPHMETRICSFLOAT):WINBOOL;

  { -------------------------------------  }
  { From shellapi.h in old Cygnus headers  }
  function DragQueryFileW(_para1:HDROP; _para2:cardinal; _para3:LPCWSTR; _para4:cardinal):cardinal;

  function ExtractAssociatedIconW(_para1:HINSTANCE; _para2:LPCWSTR; var _para3:WORD):HICON;

(* Const before type ignored *)
  function ExtractIconW(_para1:HINSTANCE; _para2:LPCWSTR; _para3:cardinal):HICON;

(* Const before type ignored *)
(* Const before type ignored *)
  function FindExecutableW(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR):HINSTANCE;

(* Const before type ignored *)
(* Const before type ignored *)
  function ShellAboutW(_para1:HWND; _para2:LPCWSTR; _para3:LPCWSTR; _para4:HICON):longint;

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function ShellExecuteW(_para1:HWND; _para2:LPCWSTR; _para3:LPCWSTR; _para4:LPCWSTR; _para5:LPCWSTR; 
             _para6:longint):HINSTANCE;

  { end of stuff from shellapi.h in old Cygnus headers  }
  { --------------------------------------------------  }
  { From ddeml.h in old Cygnus headers  }
  function DdeCreateStringHandleW(_para1:DWORD; _para2:LPCWSTR; _para3:longint):HSZ;

  function DdeInitializeW(var _para1:DWORD; _para2:CALLB; _para3:DWORD; _para4:DWORD):UINT;

  function DdeQueryStringW(_para1:DWORD; _para2:HSZ; _para3:LPCWSTR; _para4:DWORD; _para5:longint):DWORD;

  { end of stuff from ddeml.h in old Cygnus headers  }
  { -----------------------------------------------  }
  function LogonUserW(_para1:LPWSTR; _para2:LPWSTR; _para3:LPWSTR; _para4:DWORD; _para5:DWORD; 
             var _para6:HANDLE):WINBOOL;

  function CreateProcessAsUserW(_para1:HANDLE; _para2:LPCWSTR; _para3:LPWSTR; var _para4:SECURITY_ATTRIBUTES; var _para5:SECURITY_ATTRIBUTES; 
             _para6:WINBOOL; _para7:DWORD; _para8:LPVOID; _para9:LPCWSTR; var _para10:STARTUPINFO; 
             var _para11:PROCESS_INFORMATION):WINBOOL;

{ C++ end of extern C conditionnal removed }
  { __cplusplus  }
{$endif}
  { _GNU_H_WINDOWS32_UNICODEFUNCTIONS  }

{$endif read_interface}

{$ifndef windows_include_files}
  implementation

    const External_library='kernel32'; {Setup as you need!}

{$endif not windows_include_files}

{$ifdef read_implementation}

  function GetBinaryTypeW(lpApplicationName:LPCWSTR; lpBinaryType:LPDWORD):WINBOOL; external External_library name 'GetBinaryTypeW';

  function GetShortPathNameW(lpszLongPath:LPCWSTR; lpszShortPath:LPWSTR; cchBuffer:DWORD):DWORD; external External_library name 'GetShortPathNameW';

  function GetEnvironmentStringsW:LPWSTR; external External_library name 'GetEnvironmentStringsW';

  function FreeEnvironmentStringsW(_para1:LPWSTR):WINBOOL; external External_library name 'FreeEnvironmentStringsW';

  function FormatMessageW(dwFlags:DWORD; lpSource:LPCVOID; dwMessageId:DWORD; dwLanguageId:DWORD; lpBuffer:LPWSTR; 
             nSize:DWORD; var Arguments:va_list):DWORD; external External_library name 'FormatMessageW';

  function CreateMailslotW(lpName:LPCWSTR; nMaxMessageSize:DWORD; lReadTimeout:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):HANDLE; external External_library name 'CreateMailslotW';

  function lstrcmpW(lpString1:LPCWSTR; lpString2:LPCWSTR):longint; external External_library name 'lstrcmpW';

  function lstrcmpiW(lpString1:LPCWSTR; lpString2:LPCWSTR):longint; external External_library name 'lstrcmpiW';

  function lstrcpynW(lpString1:LPWSTR; lpString2:LPCWSTR; iMaxLength:longint):LPWSTR; external External_library name 'lstrcpynW';

  function lstrcpyW(lpString1:LPWSTR; lpString2:LPCWSTR):LPWSTR; external External_library name 'lstrcpyW';

  function lstrcatW(lpString1:LPWSTR; lpString2:LPCWSTR):LPWSTR; external External_library name 'lstrcatW';

  function lstrlenW(lpString:LPCWSTR):longint; external External_library name 'lstrlenW';

  function CreateMutexW(lpMutexAttributes:LPSECURITY_ATTRIBUTES; bInitialOwner:WINBOOL; lpName:LPCWSTR):HANDLE; external External_library name 'CreateMutexW';

  function OpenMutexW(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE; external External_library name 'OpenMutexW';

  function CreateEventW(lpEventAttributes:LPSECURITY_ATTRIBUTES; bManualReset:WINBOOL; bInitialState:WINBOOL; lpName:LPCWSTR):HANDLE; external External_library name 'CreateEventW';

  function OpenEventW(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE; external External_library name 'OpenEventW';

  function CreateSemaphoreW(lpSemaphoreAttributes:LPSECURITY_ATTRIBUTES; lInitialCount:LONG; lMaximumCount:LONG; lpName:LPCWSTR):HANDLE; external External_library name 'CreateSemaphoreW';

  function OpenSemaphoreW(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE; external External_library name 'OpenSemaphoreW';

  function CreateFileMappingW(hFile:HANDLE; lpFileMappingAttributes:LPSECURITY_ATTRIBUTES; flProtect:DWORD; dwMaximumSizeHigh:DWORD; dwMaximumSizeLow:DWORD; 
             lpName:LPCWSTR):HANDLE; external External_library name 'CreateFileMappingW';

  function OpenFileMappingW(dwDesiredAccess:DWORD; bInheritHandle:WINBOOL; lpName:LPCWSTR):HANDLE; external External_library name 'OpenFileMappingW';

  function GetLogicalDriveStringsW(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD; external External_library name 'GetLogicalDriveStringsW';

  function LoadLibraryW(lpLibFileName:LPCWSTR):HINSTANCE; external External_library name 'LoadLibraryW';

  function LoadLibraryExW(lpLibFileName:LPCWSTR; hFile:HANDLE; dwFlags:DWORD):HINSTANCE; external External_library name 'LoadLibraryExW';

  function GetModuleFileNameW(hModule:HINSTANCE; lpFilename:LPWSTR; nSize:DWORD):DWORD; external External_library name 'GetModuleFileNameW';

  function GetModuleHandleW(lpModuleName:LPCWSTR):HMODULE; external External_library name 'GetModuleHandleW';

  procedure FatalAppExitW(uAction:UINT; lpMessageText:LPCWSTR); external External_library name 'FatalAppExitW';

  function GetCommandLineW:LPWSTR; external External_library name 'GetCommandLineW';

  function GetEnvironmentVariableW(lpName:LPCWSTR; lpBuffer:LPWSTR; nSize:DWORD):DWORD; external External_library name 'GetEnvironmentVariableW';

  function SetEnvironmentVariableW(lpName:LPCWSTR; lpValue:LPCWSTR):WINBOOL; external External_library name 'SetEnvironmentVariableW';

  function ExpandEnvironmentStringsW(lpSrc:LPCWSTR; lpDst:LPWSTR; nSize:DWORD):DWORD; external External_library name 'ExpandEnvironmentStringsW';

  procedure OutputDebugStringW(lpOutputString:LPCWSTR); external External_library name 'OutputDebugStringW';

  function FindResourceW(hModule:HINSTANCE; lpName:LPCWSTR; lpType:LPCWSTR):HRSRC; external External_library name 'FindResourceW';

  function FindResourceExW(hModule:HINSTANCE; lpType:LPCWSTR; lpName:LPCWSTR; wLanguage:WORD):HRSRC; external External_library name 'FindResourceExW';

  function EnumResourceTypesW(hModule:HINSTANCE; lpEnumFunc:ENUMRESTYPEPROC; lParam:LONG):WINBOOL; external External_library name 'EnumResourceTypesW';

  function EnumResourceNamesW(hModule:HINSTANCE; lpType:LPCWSTR; lpEnumFunc:ENUMRESNAMEPROC; lParam:LONG):WINBOOL; external External_library name 'EnumResourceNamesW';

  function EnumResourceLanguagesW(hModule:HINSTANCE; lpType:LPCWSTR; lpName:LPCWSTR; lpEnumFunc:ENUMRESLANGPROC; lParam:LONG):WINBOOL; external External_library name 'EnumResourceLanguagesW';

  function BeginUpdateResourceW(pFileName:LPCWSTR; bDeleteExistingResources:WINBOOL):HANDLE; external External_library name 'BeginUpdateResourceW';

  function UpdateResourceW(hUpdate:HANDLE; lpType:LPCWSTR; lpName:LPCWSTR; wLanguage:WORD; lpData:LPVOID; 
             cbData:DWORD):WINBOOL; external External_library name 'UpdateResourceW';

  function EndUpdateResourceW(hUpdate:HANDLE; fDiscard:WINBOOL):WINBOOL; external External_library name 'EndUpdateResourceW';

  function GlobalAddAtomW(lpString:LPCWSTR):ATOM; external External_library name 'GlobalAddAtomW';

  function GlobalFindAtomW(lpString:LPCWSTR):ATOM; external External_library name 'GlobalFindAtomW';

  function GlobalGetAtomNameW(nAtom:ATOM; lpBuffer:LPWSTR; nSize:longint):UINT; external External_library name 'GlobalGetAtomNameW';

  function AddAtomW(lpString:LPCWSTR):ATOM; external External_library name 'AddAtomW';

  function FindAtomW(lpString:LPCWSTR):ATOM; external External_library name 'FindAtomW';

  function GetAtomNameW(nAtom:ATOM; lpBuffer:LPWSTR; nSize:longint):UINT; external External_library name 'GetAtomNameW';

  function GetProfileIntW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; nDefault:INT):UINT; external External_library name 'GetProfileIntW';

  function GetProfileStringW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpDefault:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD):DWORD; external External_library name 'GetProfileStringW';

  function WriteProfileStringW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpString:LPCWSTR):WINBOOL; external External_library name 'WriteProfileStringW';

  function GetProfileSectionW(lpAppName:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD):DWORD; external External_library name 'GetProfileSectionW';

  function WriteProfileSectionW(lpAppName:LPCWSTR; lpString:LPCWSTR):WINBOOL; external External_library name 'WriteProfileSectionW';

  function GetPrivateProfileIntW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; nDefault:INT; lpFileName:LPCWSTR):UINT; external External_library name 'GetPrivateProfileIntW';

  function GetPrivateProfileStringW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpDefault:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD; 
             lpFileName:LPCWSTR):DWORD; external External_library name 'GetPrivateProfileStringW';

  function WritePrivateProfileStringW(lpAppName:LPCWSTR; lpKeyName:LPCWSTR; lpString:LPCWSTR; lpFileName:LPCWSTR):WINBOOL; external External_library name 'WritePrivateProfileStringW';

  function GetPrivateProfileSectionW(lpAppName:LPCWSTR; lpReturnedString:LPWSTR; nSize:DWORD; lpFileName:LPCWSTR):DWORD; external External_library name 'GetPrivateProfileSectionW';

  function WritePrivateProfileSectionW(lpAppName:LPCWSTR; lpString:LPCWSTR; lpFileName:LPCWSTR):WINBOOL; external External_library name 'WritePrivateProfileSectionW';

  function GetDriveTypeW(lpRootPathName:LPCWSTR):UINT; external External_library name 'GetDriveTypeW';

  function GetSystemDirectoryW(lpBuffer:LPWSTR; uSize:UINT):UINT; external External_library name 'GetSystemDirectoryW';

  function GetTempPathW(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD; external External_library name 'GetTempPathW';

  function GetTempFileNameW(lpPathName:LPCWSTR; lpPrefixString:LPCWSTR; uUnique:UINT; lpTempFileName:LPWSTR):UINT; external External_library name 'GetTempFileNameW';

  function GetWindowsDirectoryW(lpBuffer:LPWSTR; uSize:UINT):UINT; external External_library name 'GetWindowsDirectoryW';

  function SetCurrentDirectoryW(lpPathName:LPCWSTR):WINBOOL; external External_library name 'SetCurrentDirectoryW';

  function GetCurrentDirectoryW(nBufferLength:DWORD; lpBuffer:LPWSTR):DWORD; external External_library name 'GetCurrentDirectoryW';

  function GetDiskFreeSpaceW(lpRootPathName:LPCWSTR; lpSectorsPerCluster:LPDWORD; lpBytesPerSector:LPDWORD; lpNumberOfFreeClusters:LPDWORD; lpTotalNumberOfClusters:LPDWORD):WINBOOL; external External_library name 'GetDiskFreeSpaceW';

  function CreateDirectoryW(lpPathName:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):WINBOOL; external External_library name 'CreateDirectoryW';

  function CreateDirectoryExW(lpTemplateDirectory:LPCWSTR; lpNewDirectory:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):WINBOOL; external External_library name 'CreateDirectoryExW';

  function RemoveDirectoryW(lpPathName:LPCWSTR):WINBOOL; external External_library name 'RemoveDirectoryW';

  function GetFullPathNameW(lpFileName:LPCWSTR; nBufferLength:DWORD; lpBuffer:LPWSTR; var lpFilePart:LPWSTR):DWORD; external External_library name 'GetFullPathNameW';

  function DefineDosDeviceW(dwFlags:DWORD; lpDeviceName:LPCWSTR; lpTargetPath:LPCWSTR):WINBOOL; external External_library name 'DefineDosDeviceW';

  function QueryDosDeviceW(lpDeviceName:LPCWSTR; lpTargetPath:LPWSTR; ucchMax:DWORD):DWORD; external External_library name 'QueryDosDeviceW';

  function CreateFileW(lpFileName:LPCWSTR; dwDesiredAccess:DWORD; dwShareMode:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES; dwCreationDisposition:DWORD; 
             dwFlagsAndAttributes:DWORD; hTemplateFile:HANDLE):HANDLE; external External_library name 'CreateFileW';

  function SetFileAttributesW(lpFileName:LPCWSTR; dwFileAttributes:DWORD):WINBOOL; external External_library name 'SetFileAttributesW';

  function GetFileAttributesW(lpFileName:LPCWSTR):DWORD; external External_library name 'GetFileAttributesW';

  function GetCompressedFileSizeW(lpFileName:LPCWSTR; lpFileSizeHigh:LPDWORD):DWORD; external External_library name 'GetCompressedFileSizeW';

  function DeleteFileW(lpFileName:LPCWSTR):WINBOOL; external External_library name 'DeleteFileW';

  function SearchPathW(lpPath:LPCWSTR; lpFileName:LPCWSTR; lpExtension:LPCWSTR; nBufferLength:DWORD; lpBuffer:LPWSTR; 
             var lpFilePart:LPWSTR):DWORD; external External_library name 'SearchPathW';

  function CopyFileW(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR; bFailIfExists:WINBOOL):WINBOOL; external External_library name 'CopyFileW';

  function MoveFileW(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR):WINBOOL; external External_library name 'MoveFileW';

  function MoveFileExW(lpExistingFileName:LPCWSTR; lpNewFileName:LPCWSTR; dwFlags:DWORD):WINBOOL; external External_library name 'MoveFileExW';

  function CreateNamedPipeW(lpName:LPCWSTR; dwOpenMode:DWORD; dwPipeMode:DWORD; nMaxInstances:DWORD; nOutBufferSize:DWORD; 
             nInBufferSize:DWORD; nDefaultTimeOut:DWORD; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):HANDLE; external External_library name 'CreateNamedPipeW';

  function GetNamedPipeHandleStateW(hNamedPipe:HANDLE; lpState:LPDWORD; lpCurInstances:LPDWORD; lpMaxCollectionCount:LPDWORD; lpCollectDataTimeout:LPDWORD; 
             lpUserName:LPWSTR; nMaxUserNameSize:DWORD):WINBOOL; external External_library name 'GetNamedPipeHandleStateW';

  function CallNamedPipeW(lpNamedPipeName:LPCWSTR; lpInBuffer:LPVOID; nInBufferSize:DWORD; lpOutBuffer:LPVOID; nOutBufferSize:DWORD; 
             lpBytesRead:LPDWORD; nTimeOut:DWORD):WINBOOL; external External_library name 'CallNamedPipeW';

  function WaitNamedPipeW(lpNamedPipeName:LPCWSTR; nTimeOut:DWORD):WINBOOL; external External_library name 'WaitNamedPipeW';

  function SetVolumeLabelW(lpRootPathName:LPCWSTR; lpVolumeName:LPCWSTR):WINBOOL; external External_library name 'SetVolumeLabelW';

  function GetVolumeInformationW(lpRootPathName:LPCWSTR; lpVolumeNameBuffer:LPWSTR; nVolumeNameSize:DWORD; lpVolumeSerialNumber:LPDWORD; lpMaximumComponentLength:LPDWORD; 
             lpFileSystemFlags:LPDWORD; lpFileSystemNameBuffer:LPWSTR; nFileSystemNameSize:DWORD):WINBOOL; external External_library name 'GetVolumeInformationW';

  function ClearEventLogW(hEventLog:HANDLE; lpBackupFileName:LPCWSTR):WINBOOL; external External_library name 'ClearEventLogW';

  function BackupEventLogW(hEventLog:HANDLE; lpBackupFileName:LPCWSTR):WINBOOL; external External_library name 'BackupEventLogW';

  function OpenEventLogW(lpUNCServerName:LPCWSTR; lpSourceName:LPCWSTR):HANDLE; external External_library name 'OpenEventLogW';

  function RegisterEventSourceW(lpUNCServerName:LPCWSTR; lpSourceName:LPCWSTR):HANDLE; external External_library name 'RegisterEventSourceW';

  function OpenBackupEventLogW(lpUNCServerName:LPCWSTR; lpFileName:LPCWSTR):HANDLE; external External_library name 'OpenBackupEventLogW';

  function ReadEventLogW(hEventLog:HANDLE; dwReadFlags:DWORD; dwRecordOffset:DWORD; lpBuffer:LPVOID; nNumberOfBytesToRead:DWORD; 
             var pnBytesRead:DWORD; var pnMinNumberOfBytesNeeded:DWORD):WINBOOL; external External_library name 'ReadEventLogW';

  function ReportEventW(hEventLog:HANDLE; wType:WORD; wCategory:WORD; dwEventID:DWORD; lpUserSid:PSID; 
             wNumStrings:WORD; dwDataSize:DWORD; var lpStrings:LPCWSTR; lpRawData:LPVOID):WINBOOL; external External_library name 'ReportEventW';

  function AccessCheckAndAuditAlarmW(SubsystemName:LPCWSTR; HandleId:LPVOID; ObjectTypeName:LPWSTR; ObjectName:LPWSTR; SecurityDescriptor:PSECURITY_DESCRIPTOR; 
             DesiredAccess:DWORD; GenericMapping:PGENERIC_MAPPING; ObjectCreation:WINBOOL; GrantedAccess:LPDWORD; AccessStatus:LPBOOL; 
             pfGenerateOnClose:LPBOOL):WINBOOL; external External_library name 'AccessCheckAndAuditAlarmW';

  function ObjectOpenAuditAlarmW(SubsystemName:LPCWSTR; HandleId:LPVOID; ObjectTypeName:LPWSTR; ObjectName:LPWSTR; pSecurityDescriptor:PSECURITY_DESCRIPTOR; 
             ClientToken:HANDLE; DesiredAccess:DWORD; GrantedAccess:DWORD; Privileges:PPRIVILEGE_SET; ObjectCreation:WINBOOL; 
             AccessGranted:WINBOOL; GenerateOnClose:LPBOOL):WINBOOL; external External_library name 'ObjectOpenAuditAlarmW';

  function ObjectPrivilegeAuditAlarmW(SubsystemName:LPCWSTR; HandleId:LPVOID; ClientToken:HANDLE; DesiredAccess:DWORD; Privileges:PPRIVILEGE_SET; 
             AccessGranted:WINBOOL):WINBOOL; external External_library name 'ObjectPrivilegeAuditAlarmW';

  function ObjectCloseAuditAlarmW(SubsystemName:LPCWSTR; HandleId:LPVOID; GenerateOnClose:WINBOOL):WINBOOL; external External_library name 'ObjectCloseAuditAlarmW';

  function PrivilegedServiceAuditAlarmW(SubsystemName:LPCWSTR; ServiceName:LPCWSTR; ClientToken:HANDLE; Privileges:PPRIVILEGE_SET; AccessGranted:WINBOOL):WINBOOL; external External_library name 'PrivilegedServiceAuditAlarmW';

  function SetFileSecurityW(lpFileName:LPCWSTR; SecurityInformation:SECURITY_INFORMATION; pSecurityDescriptor:PSECURITY_DESCRIPTOR):WINBOOL; external External_library name 'SetFileSecurityW';

  function GetFileSecurityW(lpFileName:LPCWSTR; RequestedInformation:SECURITY_INFORMATION; pSecurityDescriptor:PSECURITY_DESCRIPTOR; nLength:DWORD; lpnLengthNeeded:LPDWORD):WINBOOL; external External_library name 'GetFileSecurityW';

  function FindFirstChangeNotificationW(lpPathName:LPCWSTR; bWatchSubtree:WINBOOL; dwNotifyFilter:DWORD):HANDLE; external External_library name 'FindFirstChangeNotificationW';

  function IsBadStringPtrW(lpsz:LPCWSTR; ucchMax:UINT):WINBOOL; external External_library name 'IsBadStringPtrW';

  function LookupAccountSidW(lpSystemName:LPCWSTR; Sid:PSID; Name:LPWSTR; cbName:LPDWORD; ReferencedDomainName:LPWSTR; 
             cbReferencedDomainName:LPDWORD; peUse:PSID_NAME_USE):WINBOOL; external External_library name 'LookupAccountSidW';

  function LookupAccountNameW(lpSystemName:LPCWSTR; lpAccountName:LPCWSTR; Sid:PSID; cbSid:LPDWORD; ReferencedDomainName:LPWSTR; 
             cbReferencedDomainName:LPDWORD; peUse:PSID_NAME_USE):WINBOOL; external External_library name 'LookupAccountNameW';

  function LookupPrivilegeValueW(lpSystemName:LPCWSTR; lpName:LPCWSTR; lpLuid:PLUID):WINBOOL; external External_library name 'LookupPrivilegeValueW';

  function LookupPrivilegeNameW(lpSystemName:LPCWSTR; lpLuid:PLUID; lpName:LPWSTR; cbName:LPDWORD):WINBOOL; external External_library name 'LookupPrivilegeNameW';

  function LookupPrivilegeDisplayNameW(lpSystemName:LPCWSTR; lpName:LPCWSTR; lpDisplayName:LPWSTR; cbDisplayName:LPDWORD; lpLanguageId:LPDWORD):WINBOOL; external External_library name 'LookupPrivilegeDisplayNameW';

  function BuildCommDCBW(lpDef:LPCWSTR; lpDCB:LPDCB):WINBOOL; external External_library name 'BuildCommDCBW';

  function BuildCommDCBAndTimeoutsW(lpDef:LPCWSTR; lpDCB:LPDCB; lpCommTimeouts:LPCOMMTIMEOUTS):WINBOOL; external External_library name 'BuildCommDCBAndTimeoutsW';

  function CommConfigDialogW(lpszName:LPCWSTR; hWnd:HWND; lpCC:LPCOMMCONFIG):WINBOOL; external External_library name 'CommConfigDialogW';

  function GetDefaultCommConfigW(lpszName:LPCWSTR; lpCC:LPCOMMCONFIG; lpdwSize:LPDWORD):WINBOOL; external External_library name 'GetDefaultCommConfigW';

  function SetDefaultCommConfigW(lpszName:LPCWSTR; lpCC:LPCOMMCONFIG; dwSize:DWORD):WINBOOL; external External_library name 'SetDefaultCommConfigW';

  function GetComputerNameW(lpBuffer:LPWSTR; nSize:LPDWORD):WINBOOL; external External_library name 'GetComputerNameW';

  function SetComputerNameW(lpComputerName:LPCWSTR):WINBOOL; external External_library name 'SetComputerNameW';

  function GetUserNameW(lpBuffer:LPWSTR; nSize:LPDWORD):WINBOOL; external External_library name 'GetUserNameW';

  function wvsprintfW(_para1:LPWSTR; _para2:LPCWSTR; arglist:va_list):longint; external External_library name 'wvsprintfW';

  {function wsprintfW(_para1:LPWSTR; _para2:LPCWSTR; ...):longint;CDECL; external External_library name 'wsprintfW';}

  function LoadKeyboardLayoutW(pwszKLID:LPCWSTR; Flags:UINT):HKL; external External_library name 'LoadKeyboardLayoutW';

  function GetKeyboardLayoutNameW(pwszKLID:LPWSTR):WINBOOL; external External_library name 'GetKeyboardLayoutNameW';

  function CreateDesktopW(lpszDesktop:LPWSTR; lpszDevice:LPWSTR; pDevmode:LPDEVMODE; dwFlags:DWORD; dwDesiredAccess:DWORD; 
             lpsa:LPSECURITY_ATTRIBUTES):HDESK; external External_library name 'CreateDesktopW';

  function OpenDesktopW(lpszDesktop:LPWSTR; dwFlags:DWORD; fInherit:WINBOOL; dwDesiredAccess:DWORD):HDESK; external External_library name 'OpenDesktopW';

  function EnumDesktopsW(hwinsta:HWINSTA; lpEnumFunc:DESKTOPENUMPROC; lParam:LPARAM):WINBOOL; external External_library name 'EnumDesktopsW';

  function CreateWindowStationW(lpwinsta:LPWSTR; dwReserved:DWORD; dwDesiredAccess:DWORD; lpsa:LPSECURITY_ATTRIBUTES):HWINSTA; external External_library name 'CreateWindowStationW';

  function OpenWindowStationW(lpszWinSta:LPWSTR; fInherit:WINBOOL; dwDesiredAccess:DWORD):HWINSTA; external External_library name 'OpenWindowStationW';

  function EnumWindowStationsW(lpEnumFunc:ENUMWINDOWSTATIONPROC; lParam:LPARAM):WINBOOL; external External_library name 'EnumWindowStationsW';

  function GetUserObjectInformationW(hObj:HANDLE; nIndex:longint; pvInfo:PVOID; nLength:DWORD; lpnLengthNeeded:LPDWORD):WINBOOL; external External_library name 'GetUserObjectInformationW';

  function SetUserObjectInformationW(hObj:HANDLE; nIndex:longint; pvInfo:PVOID; nLength:DWORD):WINBOOL; external External_library name 'SetUserObjectInformationW';

  function RegisterWindowMessageW(lpString:LPCWSTR):UINT; external External_library name 'RegisterWindowMessageW';

  function GetMessageW(lpMsg:LPMSG; hWnd:HWND; wMsgFilterMin:UINT; wMsgFilterMax:UINT):WINBOOL; external External_library name 'GetMessageW';

  function DispatchMessageW(var lpMsg:MSG):LONG; external External_library name 'DispatchMessageW';

  function PeekMessageW(lpMsg:LPMSG; hWnd:HWND; wMsgFilterMin:UINT; wMsgFilterMax:UINT; wRemoveMsg:UINT):WINBOOL; external External_library name 'PeekMessageW';

  function SendMessageW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external External_library name 'SendMessageW';

  function SendMessageTimeoutW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM; fuFlags:UINT; 
             uTimeout:UINT; lpdwResult:LPDWORD):LRESULT; external External_library name 'SendMessageTimeoutW';

  function SendNotifyMessageW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL; external External_library name 'SendNotifyMessageW';

  function SendMessageCallbackW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM; lpResultCallBack:SENDASYNCPROC; 
             dwData:DWORD):WINBOOL; external External_library name 'SendMessageCallbackW';

  function PostMessageW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL; external External_library name 'PostMessageW';

  function PostThreadMessageW(idThread:DWORD; Msg:UINT; wParam:WPARAM; lParam:LPARAM):WINBOOL; external External_library name 'PostThreadMessageW';

  function DefWindowProcW(hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external External_library name 'DefWindowProcW';

  function CallWindowProcW(lpPrevWndFunc:WNDPROC; hWnd:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external External_library name 'CallWindowProcW';

  function RegisterClassW(var lpWndClass:WNDCLASS):ATOM; external External_library name 'RegisterClassW';

  function UnregisterClassW(lpClassName:LPCWSTR; hInstance:HINSTANCE):WINBOOL; external External_library name 'UnregisterClassW';

  function GetClassInfoW(hInstance:HINSTANCE; lpClassName:LPCWSTR; lpWndClass:LPWNDCLASS):WINBOOL; external External_library name 'GetClassInfoW';

  function RegisterClassExW(var _para1:WNDCLASSEX):ATOM; external External_library name 'RegisterClassExW';

  function GetClassInfoExW(_para1:HINSTANCE; _para2:LPCWSTR; _para3:LPWNDCLASSEX):WINBOOL; external External_library name 'GetClassInfoExW';

  function CreateWindowExW(dwExStyle:DWORD; lpClassName:LPCWSTR; lpWindowName:LPCWSTR; dwStyle:DWORD; X:longint; 
             Y:longint; nWidth:longint; nHeight:longint; hWndParent:HWND; hMenu:HMENU; 
             hInstance:HINSTANCE; lpParam:LPVOID):HWND; external External_library name 'CreateWindowExW';

  function CreateDialogParamW(hInstance:HINSTANCE; lpTemplateName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):HWND; external External_library name 'CreateDialogParamW';

  function CreateDialogIndirectParamW(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):HWND; external External_library name 'CreateDialogIndirectParamW';

  function DialogBoxParamW(hInstance:HINSTANCE; lpTemplateName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):longint; external External_library name 'DialogBoxParamW';

  function DialogBoxIndirectParamW(hInstance:HINSTANCE; hDialogTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC; dwInitParam:LPARAM):longint; external External_library name 'DialogBoxIndirectParamW';

  function SetDlgItemTextW(hDlg:HWND; nIDDlgItem:longint; lpString:LPCWSTR):WINBOOL; external External_library name 'SetDlgItemTextW';

  function GetDlgItemTextW(hDlg:HWND; nIDDlgItem:longint; lpString:LPWSTR; nMaxCount:longint):UINT; external External_library name 'GetDlgItemTextW';

  function SendDlgItemMessageW(hDlg:HWND; nIDDlgItem:longint; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LONG; external External_library name 'SendDlgItemMessageW';

  function DefDlgProcW(hDlg:HWND; Msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external External_library name 'DefDlgProcW';

  function CallMsgFilterW(lpMsg:LPMSG; nCode:longint):WINBOOL; external External_library name 'CallMsgFilterW';

  function RegisterClipboardFormatW(lpszFormat:LPCWSTR):UINT; external External_library name 'RegisterClipboardFormatW';

  function GetClipboardFormatNameW(format:UINT; lpszFormatName:LPWSTR; cchMaxCount:longint):longint; external External_library name 'GetClipboardFormatNameW';

  function CharToOemW(lpszSrc:LPCWSTR; lpszDst:LPSTR):WINBOOL; external External_library name 'CharToOemW';

  function OemToCharW(lpszSrc:LPCSTR; lpszDst:LPWSTR):WINBOOL; external External_library name 'OemToCharW';

  function CharToOemBuffW(lpszSrc:LPCWSTR; lpszDst:LPSTR; cchDstLength:DWORD):WINBOOL; external External_library name 'CharToOemBuffW';

  function OemToCharBuffW(lpszSrc:LPCSTR; lpszDst:LPWSTR; cchDstLength:DWORD):WINBOOL; external External_library name 'OemToCharBuffW';

  function CharUpperW(lpsz:LPWSTR):LPWSTR; external External_library name 'CharUpperW';

  function CharUpperBuffW(lpsz:LPWSTR; cchLength:DWORD):DWORD; external External_library name 'CharUpperBuffW';

  function CharLowerW(lpsz:LPWSTR):LPWSTR; external External_library name 'CharLowerW';

  function CharLowerBuffW(lpsz:LPWSTR; cchLength:DWORD):DWORD; external External_library name 'CharLowerBuffW';

  function CharNextW(lpsz:LPCWSTR):LPWSTR; external External_library name 'CharNextW';

  function CharPrevW(lpszStart:LPCWSTR; lpszCurrent:LPCWSTR):LPWSTR; external External_library name 'CharPrevW';

  function IsCharAlphaW(ch:WCHAR):WINBOOL; external External_library name 'IsCharAlphaW';

  function IsCharAlphaNumericW(ch:WCHAR):WINBOOL; external External_library name 'IsCharAlphaNumericW';

  function IsCharUpperW(ch:WCHAR):WINBOOL; external External_library name 'IsCharUpperW';

  function IsCharLowerW(ch:WCHAR):WINBOOL; external External_library name 'IsCharLowerW';

  function GetKeyNameTextW(lParam:LONG; lpString:LPWSTR; nSize:longint):longint; external External_library name 'GetKeyNameTextW';

  function VkKeyScanW(ch:WCHAR):SHORT; external External_library name 'VkKeyScanW';

  function VkKeyScanExW(ch:WCHAR; dwhkl:HKL):SHORT; external External_library name 'VkKeyScanExW';

  function MapVirtualKeyW(uCode:UINT; uMapType:UINT):UINT; external External_library name 'MapVirtualKeyW';

  function MapVirtualKeyExW(uCode:UINT; uMapType:UINT; dwhkl:HKL):UINT; external External_library name 'MapVirtualKeyExW';

  function LoadAcceleratorsW(hInstance:HINSTANCE; lpTableName:LPCWSTR):HACCEL; external External_library name 'LoadAcceleratorsW';

  function CreateAcceleratorTableW(_para1:LPACCEL; _para2:longint):HACCEL; external External_library name 'CreateAcceleratorTableW';

  function CopyAcceleratorTableW(hAccelSrc:HACCEL; lpAccelDst:LPACCEL; cAccelEntries:longint):longint; external External_library name 'CopyAcceleratorTableW';

  function TranslateAcceleratorW(hWnd:HWND; hAccTable:HACCEL; lpMsg:LPMSG):longint; external External_library name 'TranslateAcceleratorW';

  function LoadMenuW(hInstance:HINSTANCE; lpMenuName:LPCWSTR):HMENU; external External_library name 'LoadMenuW';

  function LoadMenuIndirectW(var lpMenuTemplate:MENUTEMPLATE):HMENU; external External_library name 'LoadMenuIndirectW';

  function ChangeMenuW(hMenu:HMENU; cmd:UINT; lpszNewItem:LPCWSTR; cmdInsert:UINT; flags:UINT):WINBOOL; external External_library name 'ChangeMenuW';

  function GetMenuStringW(hMenu:HMENU; uIDItem:UINT; lpString:LPWSTR; nMaxCount:longint; uFlag:UINT):longint; external External_library name 'GetMenuStringW';

  function InsertMenuW(hMenu:HMENU; uPosition:UINT; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL; external External_library name 'InsertMenuW';

  function AppendMenuW(hMenu:HMENU; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL; external External_library name 'AppendMenuW';

  function ModifyMenuW(hMnu:HMENU; uPosition:UINT; uFlags:UINT; uIDNewItem:UINT; lpNewItem:LPCWSTR):WINBOOL; external External_library name 'ModifyMenuW';

  function InsertMenuItemW(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPCMENUITEMINFO):WINBOOL; external External_library name 'InsertMenuItemW';

  function GetMenuItemInfoW(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPMENUITEMINFO):WINBOOL; external External_library name 'GetMenuItemInfoW';

  function SetMenuItemInfoW(_para1:HMENU; _para2:UINT; _para3:WINBOOL; _para4:LPCMENUITEMINFO):WINBOOL; external External_library name 'SetMenuItemInfoW';

  function DrawTextW(hDC:HDC; lpString:LPCWSTR; nCount:longint; lpRect:LPRECT; uFormat:UINT):longint; external External_library name 'DrawTextW';

  function DrawTextExW(_para1:HDC; _para2:LPWSTR; _para3:longint; _para4:LPRECT; _para5:UINT; 
             _para6:LPDRAWTEXTPARAMS):longint; external External_library name 'DrawTextExW';

  function GrayStringW(hDC:HDC; hBrush:HBRUSH; lpOutputFunc:GRAYSTRINGPROC; lpData:LPARAM; nCount:longint; 
             X:longint; Y:longint; nWidth:longint; nHeight:longint):WINBOOL; external External_library name 'GrayStringW';

  function DrawStateW(_para1:HDC; _para2:HBRUSH; _para3:DRAWSTATEPROC; _para4:LPARAM; _para5:WPARAM; 
             _para6:longint; _para7:longint; _para8:longint; _para9:longint; _para10:UINT):WINBOOL; external External_library name 'DrawStateW';

  function TabbedTextOutW(hDC:HDC; X:longint; Y:longint; lpString:LPCWSTR; nCount:longint; 
             nTabPositions:longint; lpnTabStopPositions:LPINT; nTabOrigin:longint):LONG; external External_library name 'TabbedTextOutW';

  function GetTabbedTextExtentW(hDC:HDC; lpString:LPCWSTR; nCount:longint; nTabPositions:longint; lpnTabStopPositions:LPINT):DWORD; external External_library name 'GetTabbedTextExtentW';

  function SetPropW(hWnd:HWND; lpString:LPCWSTR; hData:HANDLE):WINBOOL; external External_library name 'SetPropW';

  function GetPropW(hWnd:HWND; lpString:LPCWSTR):HANDLE; external External_library name 'GetPropW';

  function RemovePropW(hWnd:HWND; lpString:LPCWSTR):HANDLE; external External_library name 'RemovePropW';

  function EnumPropsExW(hWnd:HWND; lpEnumFunc:PROPENUMPROCEX; lParam:LPARAM):longint; external External_library name 'EnumPropsExW';

  function EnumPropsW(hWnd:HWND; lpEnumFunc:PROPENUMPROC):longint; external External_library name 'EnumPropsW';

  function SetWindowTextW(hWnd:HWND; lpString:LPCWSTR):WINBOOL; external External_library name 'SetWindowTextW';

  function GetWindowTextW(hWnd:HWND; lpString:LPWSTR; nMaxCount:longint):longint; external External_library name 'GetWindowTextW';

  function GetWindowTextLengthW(hWnd:HWND):longint; external External_library name 'GetWindowTextLengthW';

  function MessageBoxW(hWnd:HWND; lpText:LPCWSTR; lpCaption:LPCWSTR; uType:UINT):longint; external External_library name 'MessageBoxW';

  function MessageBoxExW(hWnd:HWND; lpText:LPCWSTR; lpCaption:LPCWSTR; uType:UINT; wLanguageId:WORD):longint; external External_library name 'MessageBoxExW';

  function MessageBoxIndirectW(_para1:LPMSGBOXPARAMS):longint; external External_library name 'MessageBoxIndirectW';

  function GetWindowLongW(hWnd:HWND; nIndex:longint):LONG; external External_library name 'GetWindowLongW';

  function SetWindowLongW(hWnd:HWND; nIndex:longint; dwNewLong:LONG):LONG; external External_library name 'SetWindowLongW';

  function GetClassLongW(hWnd:HWND; nIndex:longint):DWORD; external External_library name 'GetClassLongW';

  function SetClassLongW(hWnd:HWND; nIndex:longint; dwNewLong:LONG):DWORD; external External_library name 'SetClassLongW';

  function FindWindowW(lpClassName:LPCWSTR; lpWindowName:LPCWSTR):HWND; external External_library name 'FindWindowW';

  function FindWindowExW(_para1:HWND; _para2:HWND; _para3:LPCWSTR; _para4:LPCWSTR):HWND; external External_library name 'FindWindowExW';

  function GetClassNameW(hWnd:HWND; lpClassName:LPWSTR; nMaxCount:longint):longint; external External_library name 'GetClassNameW';

  function SetWindowsHookExW(idHook:longint; lpfn:HOOKPROC; hmod:HINSTANCE; dwThreadId:DWORD):HHOOK; external External_library name 'SetWindowsHookExW';

  function LoadBitmapW(hInstance:HINSTANCE; lpBitmapName:LPCWSTR):HBITMAP; external External_library name 'LoadBitmapW';

  function LoadCursorW(hInstance:HINSTANCE; lpCursorName:LPCWSTR):HCURSOR; external External_library name 'LoadCursorW';

  function LoadCursorFromFileW(lpFileName:LPCWSTR):HCURSOR; external External_library name 'LoadCursorFromFileW';

  function LoadIconW(hInstance:HINSTANCE; lpIconName:LPCWSTR):HICON; external External_library name 'LoadIconW';

  function LoadImageW(_para1:HINSTANCE; _para2:LPCWSTR; _para3:UINT; _para4:longint; _para5:longint; 
             _para6:UINT):HANDLE; external External_library name 'LoadImageW';

  function LoadStringW(hInstance:HINSTANCE; uID:UINT; lpBuffer:LPWSTR; nBufferMax:longint):longint; external External_library name 'LoadStringW';

  function IsDialogMessageW(hDlg:HWND; lpMsg:LPMSG):WINBOOL; external External_library name 'IsDialogMessageW';

  function DlgDirListW(hDlg:HWND; lpPathSpec:LPWSTR; nIDListBox:longint; nIDStaticPath:longint; uFileType:UINT):longint; external External_library name 'DlgDirListW';

  function DlgDirSelectExW(hDlg:HWND; lpString:LPWSTR; nCount:longint; nIDListBox:longint):WINBOOL; external External_library name 'DlgDirSelectExW';

  function DlgDirListComboBoxW(hDlg:HWND; lpPathSpec:LPWSTR; nIDComboBox:longint; nIDStaticPath:longint; uFiletype:UINT):longint; external External_library name 'DlgDirListComboBoxW';

  function DlgDirSelectComboBoxExW(hDlg:HWND; lpString:LPWSTR; nCount:longint; nIDComboBox:longint):WINBOOL; external External_library name 'DlgDirSelectComboBoxExW';

  function DefFrameProcW(hWnd:HWND; hWndMDIClient:HWND; uMsg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external External_library name 'DefFrameProcW';

  function DefMDIChildProcW(hWnd:HWND; uMsg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; external External_library name 'DefMDIChildProcW';

  function CreateMDIWindowW(lpClassName:LPWSTR; lpWindowName:LPWSTR; dwStyle:DWORD; X:longint; Y:longint; 
             nWidth:longint; nHeight:longint; hWndParent:HWND; hInstance:HINSTANCE; lParam:LPARAM):HWND; external External_library name 'CreateMDIWindowW';

  function WinHelpW(hWndMain:HWND; lpszHelp:LPCWSTR; uCommand:UINT; dwData:DWORD):WINBOOL; external External_library name 'WinHelpW';

  function ChangeDisplaySettingsW(lpDevMode:LPDEVMODE; dwFlags:DWORD):LONG; external External_library name 'ChangeDisplaySettingsW';

  function EnumDisplaySettingsW(lpszDeviceName:LPCWSTR; iModeNum:DWORD; lpDevMode:LPDEVMODE):WINBOOL; external External_library name 'EnumDisplaySettingsW';

  function SystemParametersInfoW(uiAction:UINT; uiParam:UINT; pvParam:PVOID; fWinIni:UINT):WINBOOL; external External_library name 'SystemParametersInfoW';

  function AddFontResourceW(_para1:LPCWSTR):longint; external External_library name 'AddFontResourceW';

  function CopyMetaFileW(_para1:HMETAFILE; _para2:LPCWSTR):HMETAFILE; external External_library name 'CopyMetaFileW';

  function CreateFontIndirectW(var _para1:LOGFONT):HFONT; external External_library name 'CreateFontIndirectW';

  function CreateFontW(_para1:longint; _para2:longint; _para3:longint; _para4:longint; _para5:longint; 
             _para6:DWORD; _para7:DWORD; _para8:DWORD; _para9:DWORD; _para10:DWORD; 
             _para11:DWORD; _para12:DWORD; _para13:DWORD; _para14:LPCWSTR):HFONT; external External_library name 'CreateFontW';

  function CreateICW(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR; var _para4:DEVMODE):HDC; external External_library name 'CreateICW';

  function CreateMetaFileW(_para1:LPCWSTR):HDC; external External_library name 'CreateMetaFileW';

  function CreateScalableFontResourceW(_para1:DWORD; _para2:LPCWSTR; _para3:LPCWSTR; _para4:LPCWSTR):WINBOOL; external External_library name 'CreateScalableFontResourceW';

  function DeviceCapabilitiesW(_para1:LPCWSTR; _para2:LPCWSTR; _para3:WORD; _para4:LPWSTR; var _para5:DEVMODE):longint; external External_library name 'DeviceCapabilitiesW';

  function EnumFontFamiliesExW(_para1:HDC; _para2:LPLOGFONT; _para3:FONTENUMEXPROC; _para4:LPARAM; _para5:DWORD):longint; external External_library name 'EnumFontFamiliesExW';

  function EnumFontFamiliesW(_para1:HDC; _para2:LPCWSTR; _para3:FONTENUMPROC; _para4:LPARAM):longint; external External_library name 'EnumFontFamiliesW';

  function EnumFontsW(_para1:HDC; _para2:LPCWSTR; _para3:ENUMFONTSPROC; _para4:LPARAM):longint; external External_library name 'EnumFontsW';

  function GetCharWidthW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPINT):WINBOOL; external External_library name 'GetCharWidthW';

  function GetCharWidth32W(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPINT):WINBOOL; external External_library name 'GetCharWidth32W';

  function GetCharWidthFloatW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:PFLOAT):WINBOOL; external External_library name 'GetCharWidthFloatW';

  function GetCharABCWidthsW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPABC):WINBOOL; external External_library name 'GetCharABCWidthsW';

  function GetCharABCWidthsFloatW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPABCFLOAT):WINBOOL; external External_library name 'GetCharABCWidthsFloatW';

  function GetGlyphOutlineW(_para1:HDC; _para2:UINT; _para3:UINT; _para4:LPGLYPHMETRICS; _para5:DWORD; 
             _para6:LPVOID; var _para7:MAT2):DWORD; external External_library name 'GetGlyphOutlineW';

  function GetMetaFileW(_para1:LPCWSTR):HMETAFILE; external External_library name 'GetMetaFileW';

  function GetOutlineTextMetricsW(_para1:HDC; _para2:UINT; _para3:LPOUTLINETEXTMETRIC):UINT; external External_library name 'GetOutlineTextMetricsW';

  function GetTextExtentPointW(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:LPSIZE):WINBOOL; external External_library name 'GetTextExtentPointW';

  function GetTextExtentPoint32W(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:LPSIZE):WINBOOL; external External_library name 'GetTextExtentPoint32W';

  function GetTextExtentExPointW(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:longint; _para5:LPINT; 
             _para6:LPINT; _para7:LPSIZE):WINBOOL; external External_library name 'GetTextExtentExPointW';

  function GetCharacterPlacementW(_para1:HDC; _para2:LPCWSTR; _para3:longint; _para4:longint; _para5:LPGCP_RESULTS; 
             _para6:DWORD):DWORD; external External_library name 'GetCharacterPlacementW';

  function ResetDCW(_para1:HDC; var _para2:DEVMODE):HDC; external External_library name 'ResetDCW';

  function RemoveFontResourceW(_para1:LPCWSTR):WINBOOL; external External_library name 'RemoveFontResourceW';

  function CopyEnhMetaFileW(_para1:HENHMETAFILE; _para2:LPCWSTR):HENHMETAFILE; external External_library name 'CopyEnhMetaFileW';

  function CreateEnhMetaFileW(_para1:HDC; _para2:LPCWSTR; var _para3:RECT; _para4:LPCWSTR):HDC; external External_library name 'CreateEnhMetaFileW';

  function GetEnhMetaFileW(_para1:LPCWSTR):HENHMETAFILE; external External_library name 'GetEnhMetaFileW';

  function GetEnhMetaFileDescriptionW(_para1:HENHMETAFILE; _para2:UINT; _para3:LPWSTR):UINT; external External_library name 'GetEnhMetaFileDescriptionW';

  function GetTextMetricsW(_para1:HDC; _para2:LPTEXTMETRIC):WINBOOL; external External_library name 'GetTextMetricsW';

  function StartDocW(_para1:HDC; var _para2:DOCINFO):longint; external External_library name 'StartDocW';

  function GetObjectW(_para1:HGDIOBJ; _para2:longint; _para3:LPVOID):longint; external External_library name 'GetObjectW';

  function TextOutW(_para1:HDC; _para2:longint; _para3:longint; _para4:LPCWSTR; _para5:longint):WINBOOL; external External_library name 'TextOutW';

  function ExtTextOutW(_para1:HDC; _para2:longint; _para3:longint; _para4:UINT; var _para5:RECT; 
             _para6:LPCWSTR; _para7:UINT; var _para8:INT):WINBOOL; external External_library name 'ExtTextOutW';

  function PolyTextOutW(_para1:HDC; var _para2:POLYTEXT; _para3:longint):WINBOOL; external External_library name 'PolyTextOutW';

  function GetTextFaceW(_para1:HDC; _para2:longint; _para3:LPWSTR):longint; external External_library name 'GetTextFaceW';

  function GetKerningPairsW(_para1:HDC; _para2:DWORD; _para3:LPKERNINGPAIR):DWORD; external External_library name 'GetKerningPairsW';

  function GetLogColorSpaceW(_para1:HCOLORSPACE; _para2:LPLOGCOLORSPACE; _para3:DWORD):WINBOOL; external External_library name 'GetLogColorSpaceW';

  function CreateColorSpaceW(_para1:LPLOGCOLORSPACE):HCOLORSPACE; external External_library name 'CreateColorSpaceW';

  function GetICMProfileW(_para1:HDC; _para2:DWORD; _para3:LPWSTR):WINBOOL; external External_library name 'GetICMProfileW';

  function SetICMProfileW(_para1:HDC; _para2:LPWSTR):WINBOOL; external External_library name 'SetICMProfileW';

  function UpdateICMRegKeyW(_para1:DWORD; _para2:DWORD; _para3:LPWSTR; _para4:UINT):WINBOOL; external External_library name 'UpdateICMRegKeyW';

  function EnumICMProfilesW(_para1:HDC; _para2:ICMENUMPROC; _para3:LPARAM):longint; external External_library name 'EnumICMProfilesW';

  function CreatePropertySheetPageW(lppsp:LPCPROPSHEETPAGE):HPROPSHEETPAGE; external External_library name 'CreatePropertySheetPageW';

  function PropertySheetW(lppsph:LPCPROPSHEETHEADER):longint; external External_library name 'PropertySheetW';

  function ImageList_LoadImageW(hi:HINSTANCE; lpbmp:LPCWSTR; cx:longint; cGrow:longint; crMask:COLORREF; 
             uType:UINT; uFlags:UINT):HIMAGELIST; external External_library name 'ImageList_LoadImageW';

  function CreateStatusWindowW(style:LONG; lpszText:LPCWSTR; hwndParent:HWND; wID:UINT):HWND; external External_library name 'CreateStatusWindowW';

  procedure DrawStatusTextW(hDC:HDC; lprc:LPRECT; pszText:LPCWSTR; uFlags:UINT); external External_library name 'DrawStatusTextW';

  function GetOpenFileNameW(_para1:LPOPENFILENAME):WINBOOL; external External_library name 'GetOpenFileNameW';

  function GetSaveFileNameW(_para1:LPOPENFILENAME):WINBOOL; external External_library name 'GetSaveFileNameW';

  function GetFileTitleW(_para1:LPCWSTR; _para2:LPWSTR; _para3:WORD):integer; external External_library name 'GetFileTitleW';

  function ChooseColorW(_para1:LPCHOOSECOLOR):WINBOOL; external External_library name 'ChooseColorW';

  function ReplaceTextW(_para1:LPFINDREPLACE):HWND; external External_library name 'ReplaceTextW';

  function ChooseFontW(_para1:LPCHOOSEFONT):WINBOOL; external External_library name 'ChooseFontW';

  function FindTextW(_para1:LPFINDREPLACE):HWND; external External_library name 'FindTextW';

  function PrintDlgW(_para1:LPPRINTDLG):WINBOOL; external External_library name 'PrintDlgW';

  function PageSetupDlgW(_para1:LPPAGESETUPDLG):WINBOOL; external External_library name 'PageSetupDlgW';

  function CreateProcessW(lpApplicationName:LPCWSTR; lpCommandLine:LPWSTR; lpProcessAttributes:LPSECURITY_ATTRIBUTES; lpThreadAttributes:LPSECURITY_ATTRIBUTES; bInheritHandles:WINBOOL; 
             dwCreationFlags:DWORD; lpEnvironment:LPVOID; lpCurrentDirectory:LPCWSTR; lpStartupInfo:LPSTARTUPINFO; lpProcessInformation:LPPROCESS_INFORMATION):WINBOOL; external External_library name 'CreateProcessW';

  procedure GetStartupInfoW(lpStartupInfo:LPSTARTUPINFO); external External_library name 'GetStartupInfoW';

  function FindFirstFileW(lpFileName:LPCWSTR; lpFindFileData:LPWIN32_FIND_DATA):HANDLE; external External_library name 'FindFirstFileW';

  function FindNextFileW(hFindFile:HANDLE; lpFindFileData:LPWIN32_FIND_DATA):WINBOOL; external External_library name 'FindNextFileW';

  function GetVersionExW(lpVersionInformation:LPOSVERSIONINFO):WINBOOL; external External_library name 'GetVersionExW';

  { was #define dname(params) def_expr }
  function CreateWindowW(lpClassName:LPCWSTR; lpWindowName:LPCWSTR; dwStyle:DWORD; X:longint;
             Y:longint; nWidth:longint; nHeight:longint; hWndParent:HWND; hMenu:HMENU; 
             hInstance:HINSTANCE; lpParam:LPVOID):HWND;
    begin
       CreateWindowW:=CreateWindowExW(0,lpClassName,lpWindowName,dwStyle,x,y,nWidth,nHeight,hWndParent,hMenu,hInstance,lpParam);
    end;

  { was #define dname(params) def_expr }
  function CreateDialogW(hInstance:HINSTANCE; lpName:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC):HWND;
    begin
       CreateDialogW:=CreateDialogParamW(hInstance,lpName,hWndParent,lpDialogFunc,0);
    end;

  { was #define dname(params) def_expr }
  function CreateDialogIndirectW(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC):HWND;
    begin
       CreateDialogIndirectW:=CreateDialogIndirectParamW(hInstance,lpTemplate,hWndParent,lpDialogFunc,0);
    end;

  { was #define dname(params) def_expr }
  function DialogBoxW(hInstance:HINSTANCE; lpTemplate:LPCWSTR; hWndParent:HWND; lpDialogFunc:DLGPROC):longint;
    begin
       DialogBoxW:=DialogBoxParamW(hInstance,lpTemplate,hWndParent,lpDialogFunc,0);
    end;

  { was #define dname(params) def_expr }
  function DialogBoxIndirectW(hInstance:HINSTANCE; lpTemplate:LPCDLGTEMPLATE; hWndParent:HWND; lpDialogFunc:DLGPROC):longint;
    begin
       DialogBoxIndirectW:=DialogBoxIndirectParamW(hInstance,lpTemplate,hWndParent,lpDialogFunc,0);
    end;

  function CreateDCW(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR; var _para4:DEVMODE):HDC; external External_library name 'CreateDCW';

  function CreateFontA(_para1:longint; _para2:longint; _para3:longint; _para4:longint; _para5:longint; 
             _para6:DWORD; _para7:DWORD; _para8:DWORD; _para9:DWORD; _para10:DWORD; 
             _para11:DWORD; _para12:DWORD; _para13:DWORD; _para14:LPCSTR):HFONT; external External_library name 'CreateFontA';

  function VerInstallFileW(uFlags:DWORD; szSrcFileName:LPWSTR; szDestFileName:LPWSTR; szSrcDir:LPWSTR; szDestDir:LPWSTR; 
             szCurDir:LPWSTR; szTmpFile:LPWSTR; lpuTmpFileLen:PUINT):DWORD; external External_library name 'VerInstallFileW';

  function GetFileVersionInfoSizeW(lptstrFilename:LPWSTR; lpdwHandle:LPDWORD):DWORD; external External_library name 'GetFileVersionInfoSizeW';

  function GetFileVersionInfoW(lptstrFilename:LPWSTR; dwHandle:DWORD; dwLen:DWORD; lpData:LPVOID):WINBOOL; external External_library name 'GetFileVersionInfoW';

  function VerLanguageNameW(wLang:DWORD; szLang:LPWSTR; nSize:DWORD):DWORD; external External_library name 'VerLanguageNameW';

  function VerQueryValueW(pBlock:LPVOID; lpSubBlock:LPWSTR; var lplpBuffer:LPVOID; puLen:PUINT):WINBOOL; external External_library name 'VerQueryValueW';

  function VerFindFileW(uFlags:DWORD; szFileName:LPWSTR; szWinDir:LPWSTR; szAppDir:LPWSTR; szCurDir:LPWSTR; 
             lpuCurDirLen:PUINT; szDestDir:LPWSTR; lpuDestDirLen:PUINT):DWORD; external External_library name 'VerFindFileW';

  function RegSetValueExW(hKey:HKEY; lpValueName:LPCWSTR; Reserved:DWORD; dwType:DWORD; var lpData:BYTE; 
             cbData:DWORD):LONG; external External_library name 'RegSetValueExW';

  function RegUnLoadKeyW(hKey:HKEY; lpSubKey:LPCWSTR):LONG; external External_library name 'RegUnLoadKeyW';

  function InitiateSystemShutdownW(lpMachineName:LPWSTR; lpMessage:LPWSTR; dwTimeout:DWORD; bForceAppsClosed:WINBOOL; bRebootAfterShutdown:WINBOOL):WINBOOL; external External_library name 'InitiateSystemShutdownW';

  function AbortSystemShutdownW(lpMachineName:LPWSTR):WINBOOL; external External_library name 'AbortSystemShutdownW';

  function RegRestoreKeyW(hKey:HKEY; lpFile:LPCWSTR; dwFlags:DWORD):LONG; external External_library name 'RegRestoreKeyW';

  function RegSaveKeyW(hKey:HKEY; lpFile:LPCWSTR; lpSecurityAttributes:LPSECURITY_ATTRIBUTES):LONG; external External_library name 'RegSaveKeyW';

  function RegSetValueW(hKey:HKEY; lpSubKey:LPCWSTR; dwType:DWORD; lpData:LPCWSTR; cbData:DWORD):LONG; external External_library name 'RegSetValueW';

  function RegQueryValueW(hKey:HKEY; lpSubKey:LPCWSTR; lpValue:LPWSTR; lpcbValue:PLONG):LONG; external External_library name 'RegQueryValueW';

  function RegQueryMultipleValuesW(hKey:HKEY; val_list:PVALENT; num_vals:DWORD; lpValueBuf:LPWSTR; ldwTotsize:LPDWORD):LONG; external External_library name 'RegQueryMultipleValuesW';

  function RegQueryValueExW(hKey:HKEY; lpValueName:LPCWSTR; lpReserved:LPDWORD; lpType:LPDWORD; lpData:LPBYTE; 
             lpcbData:LPDWORD):LONG; external External_library name 'RegQueryValueExW';

  function RegReplaceKeyW(hKey:HKEY; lpSubKey:LPCWSTR; lpNewFile:LPCWSTR; lpOldFile:LPCWSTR):LONG; external External_library name 'RegReplaceKeyW';

  function RegConnectRegistryW(lpMachineName:LPWSTR; hKey:HKEY; phkResult:PHKEY):LONG; external External_library name 'RegConnectRegistryW';

  function RegCreateKeyW(hKey:HKEY; lpSubKey:LPCWSTR; phkResult:PHKEY):LONG; external External_library name 'RegCreateKeyW';

  function RegCreateKeyExW(hKey:HKEY; lpSubKey:LPCWSTR; Reserved:DWORD; lpClass:LPWSTR; dwOptions:DWORD; 
             samDesired:REGSAM; lpSecurityAttributes:LPSECURITY_ATTRIBUTES; phkResult:PHKEY; lpdwDisposition:LPDWORD):LONG; external External_library name 'RegCreateKeyExW';

  function RegDeleteKeyW(hKey:HKEY; lpSubKey:LPCWSTR):LONG; external External_library name 'RegDeleteKeyW';

  function RegDeleteValueW(hKey:HKEY; lpValueName:LPCWSTR):LONG; external External_library name 'RegDeleteValueW';

  function RegEnumKeyW(hKey:HKEY; dwIndex:DWORD; lpName:LPWSTR; cbName:DWORD):LONG; external External_library name 'RegEnumKeyW';

  function RegEnumKeyExW(hKey:HKEY; dwIndex:DWORD; lpName:LPWSTR; lpcbName:LPDWORD; lpReserved:LPDWORD; 
             lpClass:LPWSTR; lpcbClass:LPDWORD; lpftLastWriteTime:PFILETIME):LONG; external External_library name 'RegEnumKeyExW';

  function RegEnumValueW(hKey:HKEY; dwIndex:DWORD; lpValueName:LPWSTR; lpcbValueName:LPDWORD; lpReserved:LPDWORD; 
             lpType:LPDWORD; lpData:LPBYTE; lpcbData:LPDWORD):LONG; external External_library name 'RegEnumValueW';

  function RegLoadKeyW(hKey:HKEY; lpSubKey:LPCWSTR; lpFile:LPCWSTR):LONG; external External_library name 'RegLoadKeyW';

  function RegOpenKeyW(hKey:HKEY; lpSubKey:LPCWSTR; phkResult:PHKEY):LONG; external External_library name 'RegOpenKeyW';

  function RegOpenKeyExW(hKey:HKEY; lpSubKey:LPCWSTR; ulOptions:DWORD; samDesired:REGSAM; phkResult:PHKEY):LONG; external External_library name 'RegOpenKeyExW';

  function RegQueryInfoKeyW(hKey:HKEY; lpClass:LPWSTR; lpcbClass:LPDWORD; lpReserved:LPDWORD; lpcSubKeys:LPDWORD; 
             lpcbMaxSubKeyLen:LPDWORD; lpcbMaxClassLen:LPDWORD; lpcValues:LPDWORD; lpcbMaxValueNameLen:LPDWORD; lpcbMaxValueLen:LPDWORD; 
             lpcbSecurityDescriptor:LPDWORD; lpftLastWriteTime:PFILETIME):LONG; external External_library name 'RegQueryInfoKeyW';

  function CompareStringW(Locale:LCID; dwCmpFlags:DWORD; lpString1:LPCWSTR; cchCount1:longint; lpString2:LPCWSTR; 
             cchCount2:longint):longint; external External_library name 'CompareStringW';

  function LCMapStringW(Locale:LCID; dwMapFlags:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpDestStr:LPWSTR; 
             cchDest:longint):longint; external External_library name 'LCMapStringW';

  function GetLocaleInfoW(Locale:LCID; LCType:LCTYPE; lpLCData:LPWSTR; cchData:longint):longint; external External_library name 'GetLocaleInfoW';

  function SetLocaleInfoW(Locale:LCID; LCType:LCTYPE; lpLCData:LPCWSTR):WINBOOL; external External_library name 'SetLocaleInfoW';

  function GetTimeFormatW(Locale:LCID; dwFlags:DWORD; var lpTime:SYSTEMTIME; lpFormat:LPCWSTR; lpTimeStr:LPWSTR; 
             cchTime:longint):longint; external External_library name 'GetTimeFormatW';

  function GetDateFormatW(Locale:LCID; dwFlags:DWORD; var lpDate:SYSTEMTIME; lpFormat:LPCWSTR; lpDateStr:LPWSTR; 
             cchDate:longint):longint; external External_library name 'GetDateFormatW';

  function GetNumberFormatW(Locale:LCID; dwFlags:DWORD; lpValue:LPCWSTR; var lpFormat:NUMBERFMT; lpNumberStr:LPWSTR; 
             cchNumber:longint):longint; external External_library name 'GetNumberFormatW';

  function GetCurrencyFormatW(Locale:LCID; dwFlags:DWORD; lpValue:LPCWSTR; var lpFormat:CURRENCYFMT; lpCurrencyStr:LPWSTR; 
             cchCurrency:longint):longint; external External_library name 'GetCurrencyFormatW';

  function EnumCalendarInfoW(lpCalInfoEnumProc:CALINFO_ENUMPROC; Locale:LCID; Calendar:CALID; CalType:CALTYPE):WINBOOL; external External_library name 'EnumCalendarInfoW';

  function EnumTimeFormatsW(lpTimeFmtEnumProc:TIMEFMT_ENUMPROC; Locale:LCID; dwFlags:DWORD):WINBOOL; external External_library name 'EnumTimeFormatsW';

  function EnumDateFormatsW(lpDateFmtEnumProc:DATEFMT_ENUMPROC; Locale:LCID; dwFlags:DWORD):WINBOOL; external External_library name 'EnumDateFormatsW';

  function GetStringTypeExW(Locale:LCID; dwInfoType:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpCharType:LPWORD):WINBOOL; external External_library name 'GetStringTypeExW';

  function GetStringTypeW(dwInfoType:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpCharType:LPWORD):WINBOOL; external External_library name 'GetStringTypeW';

  function FoldStringW(dwMapFlags:DWORD; lpSrcStr:LPCWSTR; cchSrc:longint; lpDestStr:LPWSTR; cchDest:longint):longint; external External_library name 'FoldStringW';

  function EnumSystemLocalesW(lpLocaleEnumProc:LOCALE_ENUMPROC; dwFlags:DWORD):WINBOOL; external External_library name 'EnumSystemLocalesW';

  function EnumSystemCodePagesW(lpCodePageEnumProc:CODEPAGE_ENUMPROC; dwFlags:DWORD):WINBOOL; external External_library name 'EnumSystemCodePagesW';

  function PeekConsoleInputW(hConsoleInput:HANDLE; lpBuffer:PINPUT_RECORD; nLength:DWORD; lpNumberOfEventsRead:LPDWORD):WINBOOL; external External_library name 'PeekConsoleInputW';

  function ReadConsoleInputW(hConsoleInput:HANDLE; lpBuffer:PINPUT_RECORD; nLength:DWORD; lpNumberOfEventsRead:LPDWORD):WINBOOL; external External_library name 'ReadConsoleInputW';

  function WriteConsoleInputW(hConsoleInput:HANDLE; var lpBuffer:INPUT_RECORD; nLength:DWORD; lpNumberOfEventsWritten:LPDWORD):WINBOOL; external External_library name 'WriteConsoleInputW';

  function ReadConsoleOutputW(hConsoleOutput:HANDLE; lpBuffer:PCHAR_INFO; dwBufferSize:COORD; dwBufferCoord:COORD; lpReadRegion:PSMALL_RECT):WINBOOL; external External_library name 'ReadConsoleOutputW';

  function WriteConsoleOutputW(hConsoleOutput:HANDLE; var lpBuffer:CHAR_INFO; dwBufferSize:COORD; dwBufferCoord:COORD; lpWriteRegion:PSMALL_RECT):WINBOOL; external External_library name 'WriteConsoleOutputW';

  function ReadConsoleOutputCharacterW(hConsoleOutput:HANDLE; lpCharacter:LPWSTR; nLength:DWORD; dwReadCoord:COORD; lpNumberOfCharsRead:LPDWORD):WINBOOL; external External_library name 'ReadConsoleOutputCharacterW';

  function WriteConsoleOutputCharacterW(hConsoleOutput:HANDLE; lpCharacter:LPCWSTR; nLength:DWORD; dwWriteCoord:COORD; lpNumberOfCharsWritten:LPDWORD):WINBOOL; external External_library name 'WriteConsoleOutputCharacterW';

  function FillConsoleOutputCharacterW(hConsoleOutput:HANDLE; cCharacter:WCHAR; nLength:DWORD; dwWriteCoord:COORD; lpNumberOfCharsWritten:LPDWORD):WINBOOL; external External_library name 'FillConsoleOutputCharacterW';

  function ScrollConsoleScreenBufferW(hConsoleOutput:HANDLE; var lpScrollRectangle:SMALL_RECT; var lpClipRectangle:SMALL_RECT; dwDestinationOrigin:COORD; var lpFill:CHAR_INFO):WINBOOL; external External_library name 'ScrollConsoleScreenBufferW';

  function GetConsoleTitleW(lpConsoleTitle:LPWSTR; nSize:DWORD):DWORD; external External_library name 'GetConsoleTitleW';

  function SetConsoleTitleW(lpConsoleTitle:LPCWSTR):WINBOOL; external External_library name 'SetConsoleTitleW';

  function ReadConsoleW(hConsoleInput:HANDLE; lpBuffer:LPVOID; nNumberOfCharsToRead:DWORD; lpNumberOfCharsRead:LPDWORD; lpReserved:LPVOID):WINBOOL; external External_library name 'ReadConsoleW';

  function WriteConsoleW(hConsoleOutput:HANDLE;lpBuffer:pointer; nNumberOfCharsToWrite:DWORD; lpNumberOfCharsWritten:LPDWORD; lpReserved:LPVOID):WINBOOL; external External_library name 'WriteConsoleW';

  function WNetAddConnectionW(lpRemoteName:LPCWSTR; lpPassword:LPCWSTR; lpLocalName:LPCWSTR):DWORD; external External_library name 'WNetAddConnectionW';

  function WNetAddConnection2W(lpNetResource:LPNETRESOURCE; lpPassword:LPCWSTR; lpUserName:LPCWSTR; dwFlags:DWORD):DWORD; external External_library name 'WNetAddConnection2W';

  function WNetAddConnection3W(hwndOwner:HWND; lpNetResource:LPNETRESOURCE; lpPassword:LPCWSTR; lpUserName:LPCWSTR; dwFlags:DWORD):DWORD; external External_library name 'WNetAddConnection3W';

  function WNetCancelConnectionW(lpName:LPCWSTR; fForce:WINBOOL):DWORD; external External_library name 'WNetCancelConnectionW';

  function WNetCancelConnection2W(lpName:LPCWSTR; dwFlags:DWORD; fForce:WINBOOL):DWORD; external External_library name 'WNetCancelConnection2W';

  function WNetGetConnectionW(lpLocalName:LPCWSTR; lpRemoteName:LPWSTR; lpnLength:LPDWORD):DWORD; external External_library name 'WNetGetConnectionW';

  function WNetUseConnectionW(hwndOwner:HWND; lpNetResource:LPNETRESOURCE; lpUserID:LPCWSTR; lpPassword:LPCWSTR; dwFlags:DWORD; 
             lpAccessName:LPWSTR; lpBufferSize:LPDWORD; lpResult:LPDWORD):DWORD; external External_library name 'WNetUseConnectionW';

  function WNetSetConnectionW(lpName:LPCWSTR; dwProperties:DWORD; pvValues:LPVOID):DWORD; external External_library name 'WNetSetConnectionW';

  function WNetConnectionDialog1W(lpConnDlgStruct:LPCONNECTDLGSTRUCT):DWORD; external External_library name 'WNetConnectionDialog1W';

  function WNetDisconnectDialog1W(lpConnDlgStruct:LPDISCDLGSTRUCT):DWORD; external External_library name 'WNetDisconnectDialog1W';

  function WNetOpenEnumW(dwScope:DWORD; dwType:DWORD; dwUsage:DWORD; lpNetResource:LPNETRESOURCE; lphEnum:LPHANDLE):DWORD; external External_library name 'WNetOpenEnumW';

  function WNetEnumResourceW(hEnum:HANDLE; lpcCount:LPDWORD; lpBuffer:LPVOID; lpBufferSize:LPDWORD):DWORD; external External_library name 'WNetEnumResourceW';

  function WNetGetUniversalNameW(lpLocalPath:LPCWSTR; dwInfoLevel:DWORD; lpBuffer:LPVOID; lpBufferSize:LPDWORD):DWORD; external External_library name 'WNetGetUniversalNameW';

  function WNetGetUserW(lpName:LPCWSTR; lpUserName:LPWSTR; lpnLength:LPDWORD):DWORD; external External_library name 'WNetGetUserW';

  function WNetGetProviderNameW(dwNetType:DWORD; lpProviderName:LPWSTR; lpBufferSize:LPDWORD):DWORD; external External_library name 'WNetGetProviderNameW';

  function WNetGetNetworkInformationW(lpProvider:LPCWSTR; lpNetInfoStruct:LPNETINFOSTRUCT):DWORD; external External_library name 'WNetGetNetworkInformationW';

  function WNetGetLastErrorW(lpError:LPDWORD; lpErrorBuf:LPWSTR; nErrorBufSize:DWORD; lpNameBuf:LPWSTR; nNameBufSize:DWORD):DWORD; external External_library name 'WNetGetLastErrorW';

  function MultinetGetConnectionPerformanceW(lpNetResource:LPNETRESOURCE; lpNetConnectInfoStruct:LPNETCONNECTINFOSTRUCT):DWORD; external External_library name 'MultinetGetConnectionPerformanceW';

  function ChangeServiceConfigW(hService:SC_HANDLE; dwServiceType:DWORD; dwStartType:DWORD; dwErrorControl:DWORD; lpBinaryPathName:LPCWSTR; 
             lpLoadOrderGroup:LPCWSTR; lpdwTagId:LPDWORD; lpDependencies:LPCWSTR; lpServiceStartName:LPCWSTR; lpPassword:LPCWSTR; 
             lpDisplayName:LPCWSTR):WINBOOL; external External_library name 'ChangeServiceConfigW';

  function CreateServiceW(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; lpDisplayName:LPCWSTR; dwDesiredAccess:DWORD; dwServiceType:DWORD; 
             dwStartType:DWORD; dwErrorControl:DWORD; lpBinaryPathName:LPCWSTR; lpLoadOrderGroup:LPCWSTR; lpdwTagId:LPDWORD; 
             lpDependencies:LPCWSTR; lpServiceStartName:LPCWSTR; lpPassword:LPCWSTR):SC_HANDLE; external External_library name 'CreateServiceW';

  function EnumDependentServicesW(hService:SC_HANDLE; dwServiceState:DWORD; lpServices:LPENUM_SERVICE_STATUS; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD; 
             lpServicesReturned:LPDWORD):WINBOOL; external External_library name 'EnumDependentServicesW';

  function EnumServicesStatusW(hSCManager:SC_HANDLE; dwServiceType:DWORD; dwServiceState:DWORD; lpServices:LPENUM_SERVICE_STATUS; cbBufSize:DWORD; 
             pcbBytesNeeded:LPDWORD; lpServicesReturned:LPDWORD; lpResumeHandle:LPDWORD):WINBOOL; external External_library name 'EnumServicesStatusW';

  function GetServiceKeyNameW(hSCManager:SC_HANDLE; lpDisplayName:LPCWSTR; lpServiceName:LPWSTR; lpcchBuffer:LPDWORD):WINBOOL; external External_library name 'GetServiceKeyNameW';

  function GetServiceDisplayNameW(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; lpDisplayName:LPWSTR; lpcchBuffer:LPDWORD):WINBOOL; external External_library name 'GetServiceDisplayNameW';

  function OpenSCManagerW(lpMachineName:LPCWSTR; lpDatabaseName:LPCWSTR; dwDesiredAccess:DWORD):SC_HANDLE; external External_library name 'OpenSCManagerW';

  function OpenServiceW(hSCManager:SC_HANDLE; lpServiceName:LPCWSTR; dwDesiredAccess:DWORD):SC_HANDLE; external External_library name 'OpenServiceW';

  function QueryServiceConfigW(hService:SC_HANDLE; lpServiceConfig:LPQUERY_SERVICE_CONFIG; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD):WINBOOL; external External_library name 'QueryServiceConfigW';

  function QueryServiceLockStatusW(hSCManager:SC_HANDLE; lpLockStatus:LPQUERY_SERVICE_LOCK_STATUS; cbBufSize:DWORD; pcbBytesNeeded:LPDWORD):WINBOOL; external External_library name 'QueryServiceLockStatusW';

  function RegisterServiceCtrlHandlerW(lpServiceName:LPCWSTR; lpHandlerProc:LPHANDLER_FUNCTION):SERVICE_STATUS_HANDLE; external External_library name 'RegisterServiceCtrlHandlerW';

  function StartServiceCtrlDispatcherW(lpServiceStartTable:LPSERVICE_TABLE_ENTRY):WINBOOL; external External_library name 'StartServiceCtrlDispatcherW';

  function StartServiceW(hService:SC_HANDLE; dwNumServiceArgs:DWORD; var lpServiceArgVectors:LPCWSTR):WINBOOL; external External_library name 'StartServiceW';

  function wglUseFontBitmapsW(_para1:HDC; _para2:DWORD; _para3:DWORD; _para4:DWORD):WINBOOL; external External_library name 'wglUseFontBitmapsW';

  function wglUseFontOutlinesW(_para1:HDC; _para2:DWORD; _para3:DWORD; _para4:DWORD; _para5:FLOAT; 
             _para6:FLOAT; _para7:longint; _para8:LPGLYPHMETRICSFLOAT):WINBOOL; external External_library name 'wglUseFontOutlinesW';

  function DragQueryFileW(_para1:HDROP; _para2:cardinal; _para3:LPCWSTR; _para4:cardinal):cardinal; external External_library name 'DragQueryFileW';

  function ExtractAssociatedIconW(_para1:HINSTANCE; _para2:LPCWSTR; var _para3:WORD):HICON; external External_library name 'ExtractAssociatedIconW';

  function ExtractIconW(_para1:HINSTANCE; _para2:LPCWSTR; _para3:cardinal):HICON; external External_library name 'ExtractIconW';

  function FindExecutableW(_para1:LPCWSTR; _para2:LPCWSTR; _para3:LPCWSTR):HINSTANCE; external External_library name 'FindExecutableW';

  function ShellAboutW(_para1:HWND; _para2:LPCWSTR; _para3:LPCWSTR; _para4:HICON):longint; external External_library name 'ShellAboutW';

  function ShellExecuteW(_para1:HWND; _para2:LPCWSTR; _para3:LPCWSTR; _para4:LPCWSTR; _para5:LPCWSTR; 
             _para6:longint):HINSTANCE; external External_library name 'ShellExecuteW';

  function DdeCreateStringHandleW(_para1:DWORD; _para2:LPCWSTR; _para3:longint):HSZ; external External_library name 'DdeCreateStringHandleW';

  function DdeInitializeW(var _para1:DWORD; _para2:CALLB; _para3:DWORD; _para4:DWORD):UINT; external External_library name 'DdeInitializeW';

  function DdeQueryStringW(_para1:DWORD; _para2:HSZ; _para3:LPCWSTR; _para4:DWORD; _para5:longint):DWORD; external External_library name 'DdeQueryStringW';

  function LogonUserW(_para1:LPWSTR; _para2:LPWSTR; _para3:LPWSTR; _para4:DWORD; _para5:DWORD; 
             var _para6:HANDLE):WINBOOL; external External_library name 'LogonUserW';

  function CreateProcessAsUserW(_para1:HANDLE; _para2:LPCWSTR; _para3:LPWSTR; var _para4:SECURITY_ATTRIBUTES; var _para5:SECURITY_ATTRIBUTES; 
             _para6:WINBOOL; _para7:DWORD; _para8:LPVOID; _para9:LPCWSTR; var _para10:STARTUPINFO; 
             var _para11:PROCESS_INFORMATION):WINBOOL; external External_library name 'CreateProcessAsUserW';


{$endif read_implementation}

{$ifndef windows_include_files}
end.
{$endif not windows_include_files}
{
  $Log$
  Revision 1.1  1998-08-31 11:54:02  pierre
    * compilable windows.pp file
      still to do :
       - findout problems
       - findout the correct DLL for each call !!

}
