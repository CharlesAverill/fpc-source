{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2017 by Olivier Coursière

    FPC Pascal system unit for UEFI target.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System;
 
interface

{ $define USE_NOTHREADMANAGER}
{$define DISABLE_NO_THREAD_MANAGER}

{ $define FPC_HEAPTRC_EXTRA}
 
{ include system-independent routine headers }
{$I systemh.inc}

const
 LineEnding = #13#10;
 LFNSupport = true;
 DirectorySeparator = '\';
 DriveSeparator = ':';
 ExtensionSeparator = '.';
 PathSeparator = ';';
 AllowDirectorySeparators : set of char = ['\'];
 AllowDriveSeparators : set of char = [];

var
{ C compatible arguments }
  argc: LongWord;
  argvw: PPWideChar;
  argv: PPChar;
 
const
{ Default filehandles }
  UnusedHandle    : THandle = -1;
  StdInputHandle  : THandle = 0;
  StdOutputHandle : THandle = 1;
  StdErrorHandle  : THandle = 2;

{ FileNameCaseSensitive and FileNameCasePreserving are defined separately below!!! }
 maxExitCode = High(ErrorCode);
 MaxPathLen = High(Word);
 AllFilesMask = '*';

const
  // UEFI is not case sensitive because of defaut FAT32 file system
  FileNameCaseSensitive : boolean = false;
  FileNameCasePreserving: boolean = true;
  // todo: check whether this is really the case on UEFI...
  CtrlZMarksEOF: boolean = true; (* #26 is considered as end of file *)

  sLineBreak = LineEnding;
  DefaultTextLineBreakStyle : TTextLineBreakStyle = tlbsCRLF;

{ Basic EFI definitions }


    const
      EFI_SYSTEM_TABLE_SIGNATURE = $5453595320494249;
      EFI_RUNTIME_SERVICES_SIGNATURE = $56524553544e5552;
      EFI_BOOT_SERVICES_SIGNATURE = $56524553544f4f42;

type
  { }
  { A GUID }
  { }
// Still does not understand why it does not correspond yet...
(*    EFI_GUID = packed record
        Data1 : UINT32;
        Data2 : UINT16;
        Data3 : UINT16;
        Data4 : array[0..7] of UINT8;
      end;
*)
// Until then, we use this definition under Freepascal.
// Don't forget to reverse data in integer definition (to take endianess into account)
    EFI_GUID = packed record
        Data : array[0..15] of UINT8;
      end;


{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}

const
// Many attends at understanding the binary representation of a GUID.

// Image handle
//#define LOADED_IMAGE_PROTOCOL      \
//    { 0x5B1B31A1, 0x9562, 0x11d2, {0x8E, 0x3F, 0x00, 0xA0, 0xC9, 0x69, 0x72, 0x3B} }

// UEFI.inc : EFI_LOADED_IMAGE_PROTOCOL_UUID equ 0A1h,31h,1bh,5bh,62h,95h,0d2h,11h,8Eh,3Fh,0h,0A0h,0C9h,69h,72h,3Bh

//      LOADED_IMAGE_PROTOCOL : EFI_GUID = (Data1:$5B1BB31A1; Data2:$9562; 
//      	Data3:$11D2; Data4: ($8E, $3F, $00, $A0, $C9, $69, $72, $3B));

//      LOADED_IMAGE_PROTOCOL : EFI_GUID = (Data1:$A1311B5B; Data2:$6295; 
//      	Data3:$D211; Data4: ($8E, $3F, $00, $A0, $C9, $69, $72, $3B));

// Good definition !
      LOADED_IMAGE_PROTOCOL : EFI_GUID = (Data: ( $A1, $31, $1B, $5B, $62, $95, 
      	$D2, $11, $8E, $3F, $00, $A0, $C9, $69, $72, $3B));

//#define EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL_GUID \
//  {0x387477c2,0x69c7,0x11d2,0x8e,0x39,0x00,0xa0,0xc9,0x69,0x72,0x3b}
//	EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL_GUID : EFI_GUID = (Data1:$387477c2; 
//		Data2: $69C7; Data3: $11D2; Data4: ($8E, $39, $00, $A0, $C9, $69, $72, $3B));

	// reversed
//	EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL_GUID : EFI_GUID = (Data1:$c2777438; 
//		Data2: $C769; Data3: $D211; Data4: ($8E, $39, $00, $A0, $C9, $69, $72, $3B));

//	EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL_GUID : EFI_GUID = 
//		(Data: ($c2, $77, $74, $38, $C7, $69, $D2, $11, $8E, $39, $00, $A0, $C9, $69, $72, $3B));

// Good definition !
	EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL_GUID : EFI_GUID = 
		(Data: ( $38, $74, $77, $c2, $69, $C7, $11, $D2, $8E, $39, $00, $A0, $C9, $69, $72, $3B));

	const
	  EFI_SUCCESS = 0;
	  EFI_LOAD_ERROR = 1;
	  EFI_INVALID_PARAMETER = 2;
	  EFI_UNSUPPORTED = 3;
	  EFI_OUT_OF_RESOURCES = 9;
	  EFI_NOT_FOUND = 14;
	  
type
  EFI_HANDLE = NativeUInt;
  EFI_EVENT = pointer;
  EFI_STATUS = NativeUInt;

    type
      EFI_INPUT_KEY = record
          ScanCode : UINT16;
          UnicodeChar : WideChar;
        end;

Type
    PCHAR16  = ^WideChar;
    PEFI_INPUT_KEY  = ^EFI_INPUT_KEY;
    // According to http://vzimmer.blogspot.fr/2015/08/efi-byte-code.html,
    // their size should follow the pointer size.
    // UINTN mean Unsigned natural integer
    // INTN mean Signed natural integer
    // TODO : 64 bits
    UINTN = Cardinal;
    PUINTN  = ^UINTN;
    
    EFI_MEMORY_TYPE = (EfiReservedMemoryType,EfiLoaderCode,EfiLoaderData,
      EfiBootServicesCode,EfiBootServicesData,
      EfiRuntimeServicesCode,EfiRuntimeServicesData,
      EfiConventionalMemory,EfiUnusableMemory,
      EfiACPIReclaimMemory,EfiACPIMemoryNVS,
      EfiMemoryMappedIO,EfiMemoryMappedIOPortSpace,
      EfiPalCode,EfiMaxMemoryType);

type
    P_SIMPLE_TEXT_OUTPUT_INTERFACE = ^_SIMPLE_TEXT_OUTPUT_INTERFACE;
    P_SIMPLE_INPUT_INTERFACE  = ^_SIMPLE_INPUT_INTERFACE;


      EFI_TEXT_RESET = function (This:P_SIMPLE_TEXT_OUTPUT_INTERFACE; ExtendedVerification:BOOLEAN):EFI_STATUS;cdecl;
    {EFIAPI }    {IN }    {IN }
      EFI_TEXT_OUTPUT_STRING = function (This:P_SIMPLE_TEXT_OUTPUT_INTERFACE; _String:PCHAR16):EFI_STATUS;cdecl;
    {EFIAPI }    {IN }    {IN }
      EFI_TEXT_TEST_STRING = function (This:P_SIMPLE_TEXT_OUTPUT_INTERFACE; _String:PCHAR16):EFI_STATUS;cdecl;
    {EFIAPI }    {IN }    {IN }    {OUT }    {OUT }
      EFI_TEXT_QUERY_MODE = function (This:P_SIMPLE_TEXT_OUTPUT_INTERFACE; ModeNumber:UINTN; Columns:PUINTN; Rows:PUINTN):EFI_STATUS;cdecl;
    {EFIAPI }    {IN }    {IN }
      EFI_TEXT_SET_MODE = function (This:P_SIMPLE_TEXT_OUTPUT_INTERFACE; ModeNumber:UINTN):EFI_STATUS;cdecl;
    {EFIAPI }    {IN }    {IN }
      EFI_TEXT_SET_ATTRIBUTE = function (This:P_SIMPLE_TEXT_OUTPUT_INTERFACE; Attribute:UINTN):EFI_STATUS;cdecl;

      EFI_TEXT_CLEAR_SCREEN = function (This:P_SIMPLE_TEXT_OUTPUT_INTERFACE):EFI_STATUS;cdecl;
    {EFIAPI }    {IN }    {IN }    {IN }
      EFI_TEXT_SET_CURSOR_POSITION = function (This:P_SIMPLE_TEXT_OUTPUT_INTERFACE; Column:UINTN; Row:UINTN):EFI_STATUS;cdecl;
    {EFIAPI }    {IN }    {IN }
      EFI_TEXT_ENABLE_CURSOR = function (This:P_SIMPLE_TEXT_OUTPUT_INTERFACE; Enable:BOOLEAN):EFI_STATUS;cdecl;
    { current settings }

      SIMPLE_TEXT_OUTPUT_MODE = record
          MaxMode : INT32;
          Mode : INT32;
          Attribute : INT32;
          CursorColumn : INT32;
          CursorRow : INT32;
          CursorVisible : BOOLEAN;
        end;
    { Current mode }

      _SIMPLE_TEXT_OUTPUT_INTERFACE = record
          Reset : EFI_TEXT_RESET;
          OutputString : EFI_TEXT_OUTPUT_STRING;
          TestString : EFI_TEXT_TEST_STRING;
          QueryMode : EFI_TEXT_QUERY_MODE;
          SetMode : EFI_TEXT_SET_MODE;
          SetAttribute : EFI_TEXT_SET_ATTRIBUTE;
          ClearScreen : EFI_TEXT_CLEAR_SCREEN;
          SetCursorPosition : EFI_TEXT_SET_CURSOR_POSITION;
          EnableCursor : EFI_TEXT_ENABLE_CURSOR;
          Mode : ^SIMPLE_TEXT_OUTPUT_MODE;
        end;
      SIMPLE_TEXT_OUTPUT_INTERFACE = _SIMPLE_TEXT_OUTPUT_INTERFACE;
//    P_SIMPLE_TEXT_OUTPUT_INTERFACE  = ^_SIMPLE_TEXT_OUTPUT_INTERFACE;

      EFI_INPUT_RESET = function (This:P_SIMPLE_INPUT_INTERFACE; ExtendedVerification:BOOLEAN):EFI_STATUS;cdecl;
    {EFIAPI }    {IN }    {OUT }
      EFI_INPUT_READ_KEY = function (This:P_SIMPLE_INPUT_INTERFACE; Key:PEFI_INPUT_KEY):EFI_STATUS;cdecl;

      _SIMPLE_INPUT_INTERFACE = record
          Reset : EFI_INPUT_RESET;
          ReadKeyStroke : EFI_INPUT_READ_KEY;
          WaitForKey : EFI_EVENT;
        end;
      SIMPLE_INPUT_INTERFACE = _SIMPLE_INPUT_INTERFACE;

//    P_SIMPLE_INPUT_INTERFACE  = ^_SIMPLE_INPUT_INTERFACE;

    type
      _EFI_TABLE_HEARDER = record
          Signature : UINT64;
          Revision : UINT32;
          HeaderSize : UINT32;
          CRC32 : UINT32;
          Reserved : UINT32;
        end;
      EFI_TABLE_HEADER = _EFI_TABLE_HEARDER;

	type
      EFI_GET_TIME = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_SET_TIME = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_GET_WAKEUP_TIME = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_SET_WAKEUP_TIME = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_SET_VIRTUAL_ADDRESS_MAP = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_CONVERT_POINTER = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_GET_VARIABLE = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_GET_NEXT_VARIABLE_NAME = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_SET_VARIABLE = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_GET_NEXT_HIGH_MONO_COUNT = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_RESET_SYSTEM = function ((* TODO *)):EFI_STATUS;cdecl;

    type
      EFI_RUNTIME_SERVICES = record
          Hdr : EFI_TABLE_HEADER;
          GetTime : EFI_GET_TIME;
          SetTime : EFI_SET_TIME;
          GetWakeupTime : EFI_GET_WAKEUP_TIME;
          SetWakeupTime : EFI_SET_WAKEUP_TIME;
          SetVirtualAddressMap : EFI_SET_VIRTUAL_ADDRESS_MAP;
          ConvertPointer : EFI_CONVERT_POINTER;
          GetVariable : EFI_GET_VARIABLE;
          GetNextVariableName : EFI_GET_NEXT_VARIABLE_NAME;
          SetVariable : EFI_SET_VARIABLE;
          GetNextHighMonotonicCount : EFI_GET_NEXT_HIGH_MONO_COUNT;
          ResetSystem : EFI_RESET_SYSTEM;
        end;

    EFI_ALLOCATE_TYPE = (AllocateAnyPages,AllocateMaxAddress,AllocateAddress,
      MaxAllocateType);
  {Preseve the attr on any range supplied. }
  {ConventialMemory must have WB,SR,SW when supplied. }
  {When allocating from ConventialMemory always make it WB,SR,SW }
  {When returning to ConventialMemory always make it WB,SR,SW }
  {When getting the memory map, or on RT for runtime types }

	type
	  EFI_PHYSICAL_ADDRESS = UINT64;
	
	type
      EFI_RAISE_TPL = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_RESTORE_TPL = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_ALLOCATE_PAGES = function (aType : EFI_ALLOCATE_TYPE; 
      	MemoryType : EFI_MEMORY_TYPE; NoPages : UINTN; 
      	var Memory : EFI_PHYSICAL_ADDRESS(* TODO *)):EFI_STATUS;cdecl;
      EFI_FREE_PAGES = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_GET_MEMORY_MAP = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_ALLOCATE_POOL = function (PoolType : EFI_MEMORY_TYPE; Size : UINT32; 
      	var Buffer : Pointer):EFI_STATUS;cdecl;
      EFI_FREE_POOL = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_CREATE_EVENT = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_SET_TIMER = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_WAIT_FOR_EVENT = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_SIGNAL_EVENT = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_CLOSE_EVENT = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_CHECK_EVENT = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_INSTALL_PROTOCOL_INTERFACE = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_REINSTALL_PROTOCOL_INTERFACE = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_UNINSTALL_PROTOCOL_INTERFACE = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_HANDLE_PROTOCOL = function (Handle : EFI_HANDLE; var Protocol : EFI_GUID; var _Interface : pointer):EFI_STATUS;cdecl;
      EFI_REGISTER_PROTOCOL_NOTIFY = function ((* TODOhand *)):EFI_STATUS;cdecl;
      EFI_LOCATE_HANDLE = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_LOCATE_DEVICE_PATH = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_INSTALL_CONFIGURATION_TABLE = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_IMAGE_LOAD = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_IMAGE_START = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_EXIT = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_IMAGE_UNLOAD = function (ImageHandle : EFI_HANDLE):EFI_STATUS;cdecl;
      EFI_EXIT_BOOT_SERVICES = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_GET_NEXT_MONOTONIC_COUNT = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_STALL = function (Microseconds : UINT32):EFI_STATUS;cdecl;
      EFI_SET_WATCHDOG_TIMER = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_CONNECT_CONTROLLER = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_DISCONNECT_CONTROLLER = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_OPEN_PROTOCOL = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_CLOSE_PROTOCOL = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_OPEN_PROTOCOL_INFORMATION = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_PROTOCOLS_PER_HANDLE = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_LOCATE_HANDLE_BUFFER = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_LOCATE_PROTOCOL = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_INSTALL_MULTIPLE_PROTOCOL_INTERFACES = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_UNINSTALL_MULTIPLE_PROTOCOL_INTERFACES = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_CALCULATE_CRC32 = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_COPY_MEM = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_SET_MEM = function ((* TODO *)):EFI_STATUS;cdecl;
      EFI_CREATE_EVENT_EX = function ((* TODO *)):EFI_STATUS;cdecl;

    type
      _EFI_BOOT_SERVICES = record
          Hdr : EFI_TABLE_HEADER;
          RaiseTPL : EFI_RAISE_TPL;
          RestoreTPL : EFI_RESTORE_TPL;
          AllocatePages : EFI_ALLOCATE_PAGES;
          FreePages : EFI_FREE_PAGES;
          GetMemoryMap : EFI_GET_MEMORY_MAP;
          AllocatePool : EFI_ALLOCATE_POOL;
          FreePool : EFI_FREE_POOL;
          CreateEvent : EFI_CREATE_EVENT;
          SetTimer : EFI_SET_TIMER;
          WaitForEvent : EFI_WAIT_FOR_EVENT;
          SignalEvent : EFI_SIGNAL_EVENT;
          CloseEvent : EFI_CLOSE_EVENT;
          CheckEvent : EFI_CHECK_EVENT;
          InstallProtocolInterface : EFI_INSTALL_PROTOCOL_INTERFACE;
          ReinstallProtocolInterface : EFI_REINSTALL_PROTOCOL_INTERFACE;
          UninstallProtocolInterface : EFI_UNINSTALL_PROTOCOL_INTERFACE;
          HandleProtocol : EFI_HANDLE_PROTOCOL;
          PCHandleProtocol : EFI_HANDLE_PROTOCOL; // Reserved acording to http://wiki.phoenix.com/wiki/index.php/EFI_BOOT_SERVICES
          RegisterProtocolNotify : EFI_REGISTER_PROTOCOL_NOTIFY;
          LocateHandle : EFI_LOCATE_HANDLE;
          LocateDevicePath : EFI_LOCATE_DEVICE_PATH;
          InstallConfigurationTable : EFI_INSTALL_CONFIGURATION_TABLE;
          LoadImage : EFI_IMAGE_LOAD;
          StartImage : EFI_IMAGE_START;
          Exit : EFI_EXIT;
          UnloadImage : EFI_IMAGE_UNLOAD;
          ExitBootServices : EFI_EXIT_BOOT_SERVICES;
          GetNextMonotonicCount : EFI_GET_NEXT_MONOTONIC_COUNT;
          Stall : EFI_STALL;
          SetWatchdogTimer : EFI_SET_WATCHDOG_TIMER;
          ConnectController : EFI_CONNECT_CONTROLLER;
          DisconnectController : EFI_DISCONNECT_CONTROLLER;
          OpenProtocol : EFI_OPEN_PROTOCOL;
          CloseProtocol : EFI_CLOSE_PROTOCOL;
          OpenProtocolInformation : EFI_OPEN_PROTOCOL_INFORMATION;
          ProtocolsPerHandle : EFI_PROTOCOLS_PER_HANDLE;
          LocateHandleBuffer : EFI_LOCATE_HANDLE_BUFFER;
          LocateProtocol : EFI_LOCATE_PROTOCOL;
          InstallMultipleProtocolInterfaces : EFI_INSTALL_MULTIPLE_PROTOCOL_INTERFACES;
          UninstallMultipleProtocolInterfaces : EFI_UNINSTALL_MULTIPLE_PROTOCOL_INTERFACES;
          CalculateCrc32 : EFI_CALCULATE_CRC32;
          CopyMem : EFI_COPY_MEM;
          SetMem : EFI_SET_MEM;
          CreateEventEx : EFI_CREATE_EVENT_EX;
        end;
      EFI_BOOT_SERVICES = _EFI_BOOT_SERVICES;
               
type
      _EFI_SYSTEM_TABLE = record
          Hdr : EFI_TABLE_HEADER;
          FirmwareVendor : ^WideChar;
          FirmwareRevision : UINT32;
          ConsoleInHandle : EFI_HANDLE;
          ConIn : ^SIMPLE_INPUT_INTERFACE;
          ConsoleOutHandle : EFI_HANDLE;
          ConOut : ^SIMPLE_TEXT_OUTPUT_INTERFACE;
          StandardErrorHandle : EFI_HANDLE;
          StdErr : ^SIMPLE_TEXT_OUTPUT_INTERFACE;
          RuntimeServices : ^EFI_RUNTIME_SERVICES;
          BootServices : ^EFI_BOOT_SERVICES;
{          NumberOfTableEntries : UINTN;
          ConfigurationTable : ^EFI_CONFIGURATION_TABLE;}
        end;
      EFI_SYSTEM_TABLE = _EFI_SYSTEM_TABLE;
      PEFI_SYSTEM_TABLE = ^EFI_SYSTEM_TABLE;


    const
      EFI_IMAGE_INFORMATION_REVISION = $1000;      

    { Source location of image }
    { Images load options }
    { Location of where image was loaded }
    { If the driver image supports a dynamic unload request }

  {++
  
  Copyright (c) 1998  Intel Corporation
  
  Module Name:
  
      devpath.h
  
  Abstract:
  
      Defines for parsing the EFI Device Path structures
  
  
  
  Revision History
  
  -- }
  { }
  { Device Path structures - Section C }
  { }

  type
    _EFI_DEVICE_PATH = record
        _Type : UINT8;
        SubType : UINT8;
        Length : array[0..1] of UINT8;
      end;
    EFI_DEVICE_PATH = _EFI_DEVICE_PATH;

    type
      EFI_LOADED_IMAGE = record
          Revision : UINT32;
          ParentHandle : EFI_HANDLE;
          SystemTable : ^_EFI_SYSTEM_TABLE;
          DeviceHandle : EFI_HANDLE;
          FilePath : ^EFI_DEVICE_PATH;
          Reserved : pointer;
          LoadOptionsSize : UINT32;
          LoadOptions : pointer;
          ImageBase : pointer;
          ImageSize : UINT64;
          ImageCodeType : EFI_MEMORY_TYPE;
          ImageDataType : EFI_MEMORY_TYPE;
          Unload : EFI_IMAGE_UNLOAD;
        end;
        PEFI_LOADED_IMAGE = ^EFI_LOADED_IMAGE;

{$IFDEF FPC}
{$PACKRECORDS DEFAULT}
{$ENDIF}

procedure Check(systemTable : EFI_SYSTEM_TABLE; status : EFI_STATUS);
procedure Check(status : EFI_STATUS);

var
  sysTable : EFI_SYSTEM_TABLE;
  //PSysTable : PEFI_SYSTEM_TABLE = nil;
  StdOutput : ^SIMPLE_TEXT_OUTPUT_INTERFACE;

type
  THeapPointer = ^pointer;
var
  heapstartpointer : THeapPointer;
  heapstart : pointer;//external;//external name 'HEAP';
  myheapsize : longint; //external;//external name 'HEAPSIZE';
  myheaprealsize : longint;
  heap_handle : longint;

procedure Init(systemTable : EFI_SYSTEM_TABLE);

procedure PascalMain;stdcall;external name 'PASCALMAIN';

procedure Debugger(s : WideString);
procedure Debugger();

//*******************************************************
// Attributes
//*******************************************************
const
  EFI_BLACK = $00;
  EFI_BLUE = $01;
  EFI_GREEN = $02;
  EFI_CYAN = $03;
  EFI_RED = $04;
  EFI_MAGENTA = $05;
  EFI_BROWN = $06;
  EFI_LIGHTGRAY = $07;
  EFI_BRIGHT = $08;
  EFI_DARKGRAY = $08; // (EFI_BLACK | EFI_BRIGHT)
  EFI_LIGHTBLUE = $09;
  EFI_LIGHTGREEN = $0A;
  EFI_LIGHTCYAN = $0B;
  EFI_LIGHTRED = $0C;
  EFI_LIGHTMAGENTA = $0D;
  EFI_YELLOW = $0E;
  EFI_WHITE = $0F;
  EFI_BACKGROUND_BLACK = $00;
  EFI_BACKGROUND_BLUE = $10;
  EFI_BACKGROUND_GREEN = $20;
  EFI_BACKGROUND_CYAN = $30;
  EFI_BACKGROUND_RED = $40;
  EFI_BACKGROUND_MAGENTA = $50;
  EFI_BACKGROUND_BROWN = $60;
  EFI_BACKGROUND_LIGHTGRAY = $70;
//
// Macro to accept color values in their raw form to create
// a value that represents both a foreground and background
// color in a single byte.
// For Foreground, and EFI_* value is valid from EFI_BLACK(0x00)
// to EFI_WHITE (0x0F).
// For Background, only EFI_BLACK, EFI_BLUE, EFI_GREEN,
// EFI_CYAN, EFI_RED, EFI_MAGENTA, EFI_BROWN, and EFI_LIGHTGRAY
// are acceptable.
//
// Do not use EFI_BACKGROUND_xxx values with this macro.
//#define EFI_TEXT_ATTR(Foreground,Background) \
//((Foreground) | ((Background) << 4))
function EFI_TEXT_ATTR(Foreground, Background : integer) : integer;

implementation

{ include system independent routines }
{$I system.inc}

function EFI_TEXT_ATTR(Foreground, Background : integer) : integer;
begin
  Result := Foreground or (Background shl 4);
end;

function paramcount : longint;
begin
  Result := 0;
end;

function paramstr(l : longint) : string;
begin
  Result := '';
end;

procedure randomize;
begin
end;

procedure Check(status : EFI_STATUS);
begin
  Check(sysTable, status);
end;

procedure Check(systemTable : EFI_SYSTEM_TABLE; status : EFI_STATUS);
var
  msg : WideString;
begin
  msg := 'Default error';
  
  case status of
  	EFI_SUCCESS:
  	  begin
  	  	// Success
  	  	msg := 'Success';
  	  end;
  	EFI_INVALID_PARAMETER:
  	  begin
  	    // Invalid
  	    msg := 'Invalid';
  	  end;
  	EFI_OUT_OF_RESOURCES:
  	  begin
  	    // Out of resources
  	    msg := 'Out of resources';
  	  end;
  	1, 3..8, 10 :
  	  begin
  	    msg := 'Error 1';
  	  end;
  	11..20 :
  	  begin
  	    msg := 'Error 11';
  	  end;
  	21..30 :
  	  begin
  	    msg := 'Error 21';
  	  end;
  	31..40 :
  	  begin
  	    msg := 'Error 31';
  	  end;
  	41..50 :
  	  begin
  	    msg := 'Error 41';
  	  end;
  	51..60 :
  	  begin
  	    msg := 'Error 51';
  	  end;
  	61..70 :
  	  begin
  	    msg := 'Error 61';
  	  end;
  	71..80 :
  	  begin
  	    msg := 'Error 71';
  	  end;
  	81..90 :
  	  begin
  	    msg := 'Error 81';
  	  end;
  	91..100 :
  	  begin
  	    msg := 'Error 91';
  	  end;
  	101..MaxInt :
  	  begin
  	    msg := 'Error 101';
  	  end;
  	else
  	  begin
  	    if (status > MaxInt) and (status <= High(Cardinal)) then
  	    begin
  	      msg := 'Very high error number : suspicious...';
  	    end
  	    else
  	    begin
  	  	  // Error
  	      msg := 'Error not handled in Check';
  	    end;
  	  end;
  end;

  Debugger('');
  Debugger(msg);
  Debugger('End of Check');
end;

procedure Init(systemTable : EFI_SYSTEM_TABLE);
begin
  DefaultSystemCodePage := CP_UTF16;
  DefaultRTLFileSystemCodePage := CP_UTF16;
  DefaultFileSystemCodePage := CP_UTF16;
  SetMultiByteConversionCodePage(CP_UTF16);

  SysTable := systemTable;
  
  { Setup heap }
  myheapsize:=4096*1000;// $ 20000;
  myheaprealsize:=4096*1000;// $ 20000;
  heapstart:=nil;
  heapstartpointer := nil;
  heapstartpointer := SysOSAlloc(4096*1000);
  if heapstartpointer <> nil then
  begin
    SysTable.ConOut^.OutputString(SysTable.ConOut, 'heapStartPointer initialization' + #13#10);
    FillChar(heapstartpointer^, 4096*1000, #0);
  end
  else
  begin
    SysTable.ConOut^.OutputString(SysTable.ConOut, 'heapStartPointer not initialized' + #13#10);
  end;

  WriteLn('Init');

  SysInitExceptions;
  initunicodestringmanager;
{ Setup IO }
  SysInitStdIO;
{ Reset IO Error }
  InOutRes:=0;

  SysTable.ConOut^.OutputString(SysTable.ConOut, #13#10);
end;

procedure Debugger();
begin
  {$ifdef UEFI}
  SysTable.ConOut^.OutputString(SysTable.ConOut, PChar16('Debugger call : ' + #13#10));
  {$endif}
end;

procedure Debugger(s : WideString);
begin
  {$ifdef UEFI}
  SysTable.ConOut^.OutputString(SysTable.ConOut, PChar16('Debugger call : ' + s + #13#10));
  {$endif}
end;

procedure TestQueryMode;
var
  x, y : integer;
begin
  SysTable.ConOut^.QueryMode(SysTable.ConOut, 0, @x, @y);
  WriteLn(HexStr(x, 8) + ', ' + HexStr(y, 8));
  SysTable.ConOut^.QueryMode(SysTable.ConOut, 1, @x, @y);
  WriteLn(HexStr(x, 8) + ', ' + HexStr(y, 8));
  SysTable.ConOut^.QueryMode(SysTable.ConOut, 2, @x, @y);
  WriteLn(HexStr(x, 8) + ', ' + HexStr(y, 8));
  SysTable.ConOut^.QueryMode(SysTable.ConOut, 3, @x, @y);
  WriteLn(HexStr(x, 8) + ', ' + HexStr(y, 8));
  SysTable.ConOut^.QueryMode(SysTable.ConOut, 4, @x, @y);
  WriteLn(HexStr(x, 8) + ', ' + HexStr(y, 8));
  SysTable.ConOut^.QueryMode(SysTable.ConOut, 5, @x, @y);
  WriteLn(HexStr(x, 8) + ', ' + HexStr(y, 8));
  SysTable.ConOut^.SetMode(SysTable.ConOut, 2);

  WriteLn(HexStr(SysTable.ConOut^.Mode^.MaxMode, 8));

  SysTable.ConOut^.SetCursorPosition(SysTable.ConOut, 10, 10);
  SysTable.ConOut^.EnableCursor(SysTable.ConOut, False);
end;

var
  s : WideString;
  s1 : string;

function EFI_MAIN( imageHandle: EFI_HANDLE; systemTable : PEFI_SYSTEM_TABLE): EFI_STATUS; cdecl; [public, alias: 'EFI_MAIN'];
var
  CurrentImage : EFI_LOADED_IMAGE;
  pCurrentImage : PEFI_LOADED_IMAGE;
  HandleProtocolResult : EFI_STATUS = 0;
  myImageHandle : Cardinal;
begin
 //try
  SysTable := systemTable^;

  SysTable.ConOut^.OutputString(SysTable.ConOut, 'EFI_MAIN start' + #13#10);

  StackLength := CheckInitialStkLen ($1000000); 
  StackBottom := StackTop - StackLength; 
  
  { Setup heap }
  myheapsize:=4096*100;// $ 20000;
  myheaprealsize:=4096*100;// $ 20000;
  heapstart:=nil;
  heapstartpointer := nil;
  heapstartpointer := SysOSAlloc(4096*100);
  FillChar(heapstartpointer^, myheaprealsize, #0);

  SysTable.ConOut^.OutputString(SysTable.ConOut, 'just before InitHeap' + #13#10);

  InitHeap;

  SysTable.ConOut^.OutputString(SysTable.ConOut, 'just after InitHeap' + #13#10);

  DefaultSystemCodePage := CP_UTF16;
  DefaultRTLFileSystemCodePage := CP_UTF16;
  DefaultFileSystemCodePage := CP_UTF16;
  SetMultiByteConversionCodePage(CP_UTF16);

  Debugger('start');
  
  if heapstartpointer <> nil then
  begin
    SysTable.ConOut^.OutputString(SysTable.ConOut, 'heapStartPointer initialization' + #13#10);
    FillChar(heapstartpointer^, 4096*100, #0);
  end
  else
  begin
    SysTable.ConOut^.OutputString(SysTable.ConOut, 'heapStartPointer not initialized' + #13#10);
  end;
  SysInitExceptions;
  initunicodestringmanager;
{ Setup IO }
  SysInitStdIO;
{ Reset IO Error }
  InOutRes:=0;
  Debugger('before InitSystemThreads');
  InitSystemThreads;

  SysTable.ConOut^.OutputString(SysTable.ConOut, #13#10);

  myImageHandle := imageHandle;
  Debugger('After afectation');
  s1 := HexStr(myImageHandle, 8) + #13#10 + #0#0;
  Debugger('After HexStr 1');
  
  Debugger(s1);
    
  pCurrentImage := @CurrentImage;
  HandleProtocolResult :=
    SysTable.BootServices^.HandleProtocol(imageHandle, LOADED_IMAGE_PROTOCOL,
    //SysTable.BootServices^.HandleProtocol(imageHandle, EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL_GUID,
  	pCurrentImage);
  if pCurrentImage = nil then
  begin
    Debugger('pCurrentImage == nil');
  end
  else
  begin
    Debugger('pCurrentImage <> nil');
  end;
  if pCurrentImage^.Revision = EFI_IMAGE_INFORMATION_REVISION then
  begin
    Debugger('Revision OK');
    // Print loaded address
    Debugger('Loaded address : ');
    Debugger(HexStr(PEFI_LOADED_IMAGE(pCurrentImage^.ImageBase)));
    Debugger('Size : ');
    Debugger(HexStr(PEFI_LOADED_IMAGE(pCurrentImage^.ImageSize)));
  end
  else
    Debugger('Bas revision number');
  begin
    
  end;
  Check(HandleProtocolResult);
  s := HexStr(HandleProtocolResult, 8);	
  Debugger('After HexStr 2');
  Debugger(s);
  if HandleProtocolResult = EFI_SUCCESS then
  begin
    Debugger('Success in HandleProtocol');
  end
  else
  begin
    Debugger('Error in HandleProtocol');
  end;

  SysTable.ConOut^.Reset(SysTable.ConOut, False);

  PascalMain;
  WriteLn('End of EFI_MAIN...');

//  SysTable.ConOut^.Reset(SysTable.ConOut, True);
  SysTable.ConOut^.SetAttribute(SysTable.ConOut, EFI_TEXT_ATTR(EFI_GREEN, EFI_BLACK) );
  if SysTable.ConOut^.TestString(SysTable.ConOut, 'Text to test...') = EFI_SUCCESS then
  begin
    WriteLn('TestString OK');
  end;

  TestQueryMode;

//except
//   Result := EFI_INVALID_PARAMETER;
//   WriteLn('Exception in EFI_MAIN');
 //end;
 Result := EFI_SUCCESS;
 SysTable.ConOut^.OutputString(SysTable.ConOut, 'EFI_MAIN real end' + #13#10);
end;
{*****************************************************************************
                         System Dependent Exit code
*****************************************************************************}

Procedure system_exit;
begin
  WriteLn('system_exit');
end;

procedure SysInitStdIO;
begin
  { Setup stdin, stdout and stderr, for GUI apps redirect stderr,stdout to be
    displayed in and messagebox }
  OpenStdIO(Input,fmInput,StdInputHandle);
  OpenStdIO(Output,fmOutput,StdOutputHandle);
  OpenStdIO(StdOut,fmOutput,StdOutputHandle);
  OpenStdIO(StdErr,fmOutput,StdErrorHandle);
end;

function GetProcessID: SizeUInt;
begin
  Result := 0;
end;

function CheckInitialStkLen(stklen : SizeUInt) : SizeUInt;
begin
  result := stklen;
end;

begin

end.
