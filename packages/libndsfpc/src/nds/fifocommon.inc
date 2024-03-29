
{$ifdef NDS_INTERFACE}
 
type
  FifoChannels = integer;
const
  FIFO_PM      : FifoChannels = 0;
  FIFO_SOUND   : FifoChannels = 1;
  FIFO_SYSTEM  : FifoChannels = 2;
  FIFO_MAXMOD  : FifoChannels = 3;
  FIFO_DSWIFI  : FifoChannels = 4;
  FIFO_SDMMC   : FifoChannels = 5;
  FIFO_FIRMWARE: FifoChannels = 6;
  FIFO_RSVD_01 : FifoChannels = 7;
  FIFO_USER_01 : FifoChannels = 8;
  FIFO_USER_02 : FifoChannels = 9;
  FIFO_USER_03 : FifoChannels = 10;	    
  FIFO_USER_04 : FifoChannels = 11;	    
  FIFO_USER_05 : FifoChannels = 12;	    
  FIFO_USER_06 : FifoChannels = 13;	    
  FIFO_USER_07 : FifoChannels = 14;	    
  FIFO_USER_08 : FifoChannels = 15;
  
  
type
  FifoSoundCommand = integer;
const
  SOUND_SET_PAN         : FifoSoundCommand = ( 0 shl 20);
  SOUND_SET_VOLUME      : FifoSoundCommand = ( 1 shl 20);
  SOUND_SET_FREQ        : FifoSoundCommand = ( 2 shl 20);
  SOUND_SET_WAVEDUTY    : FifoSoundCommand = ( 3 shl 20);
  SOUND_MASTER_ENABLE   : FifoSoundCommand = ( 4 shl 20);
  SOUND_MASTER_DISABLE  : FifoSoundCommand = ( 5 shl 20);
  SOUND_PAUSE           : FifoSoundCommand = ( 6 shl 20);
  SOUND_RESUME          : FifoSoundCommand = ( 7 shl 20);
  SOUND_KILL            : FifoSoundCommand = ( 8 shl 20);
  SET_MASTER_VOL        : FifoSoundCommand = ( 9 shl 20);
  MIC_STOP              : FifoSoundCommand = (10 shl 20);

type
  FifoSystemCommands = integer;
const
  SYS_REQ_TOUCH      : FifoSystemCommands = 0;
  SYS_REQ_KEYS       : FifoSystemCommands = 1;
  SYS_REQ_TIME       : FifoSystemCommands = 2;
  SYS_SET_TIME       : FifoSystemCommands = 3;
  SDMMC_INSERT       : FifoSystemCommands = 4;
  SDMMC_REMOVE       : FifoSystemCommands = 5;  
  
type
 FifoSdmmcCommands = integer;
const
  SDMMC_HAVE_SD        : FifoSystemCommands = 0;
  SDMMC_SD_START       : FifoSystemCommands = 1;
  SDMMC_SD_IS_INSERTED : FifoSystemCommands = 2;
  SDMMC_SD_STOP        : FifoSystemCommands = 3;
  SDMMC_NAND_START     : FifoSystemCommands = 4;
  SDMMC_NAND_STOP      : FifoSystemCommands = 5;
  SDMMC_NAND_SIZE      : FifoSystemCommands = 6;
type
  FifoFirmwareCommands = integer;
const
	FW_READ  = 0;
	FW_WRITE = 1;

type
  FifoPMCommands = integer;
const
  PM_REQ_ON             : FifoPMCommands = (1 shl 16);
  PM_REQ_OFF            : FifoPMCommands = (2 shl 16);
  PM_REQ_LED            : FifoPMCommands = (3 shl 16);
  PM_REQ_SLEEP          : FifoPMCommands = (4 shl 16);
  PM_REQ_SLEEP_DISABLE  : FifoPMCommands = (5 shl 16);
  PM_REQ_SLEEP_ENABLE   : FifoPMCommands = (6 shl 16);
  PM_REQ_BATTERY        : FifoPMCommands = (7 shl 16);
  PM_REQ_SLOT1_DISABLE  : FifoPMCommands = (8 shl 16);
  PM_REQ_SLOT1_ENABLE   : FifoPMCommands = (9 shl 16);
	
type
  FifoWifiCommands = integer;
const
  WIFI_ENABLE   : FifoWifiCommands = 0;
  WIFI_DISABLE  : FifoWifiCommands = 1;
  WIFI_SYNC     : FifoWifiCommands = 2;
  WIFI_STARTUP  : FifoWifiCommands = 3;

type
  PM_LedBlinkMode = integer;
const
  PM_LED_ON   : PM_LedBlinkMode = 0;
  PM_LED_SLEEP: PM_LedBlinkMode = 1;
  PM_LED_BLINK: PM_LedBlinkMode = 3;

//var
//  fifo_buffer: array [0..FIFO_BUFFER_ENTRIES*2-1] of cuint32; cvar; external;


{$ifdef FIFO_RIGOROUS_ERROR_CHECKING}
	function fifoError(value: PAnsiChar; array of const): integer; cdecl; external;// expected to be defined externally.
{$endif}

type  // FUNCTION(...):POINTER or PROCEDURE?!?
  FifoAddressHandlerFunc = function(address, userdata: pointer): pointer;
  FifoValue32HandlerFunc = function(value32: cuint32; userdata: pointer): pointer;
  FifoDatamsgHandlerFunc = function(num_bytes: integer; userdata: pointer): pointer;

function fifoInit(): cbool; cdecl; external;
function fifoSendAddress(channel: integer; address: pointer): cbool; cdecl; external;
function fifoSendValue32(channel: integer; value32: cuint32): cbool; cdecl; external;

function fifoSendDatamsg(channel, num_bytes: integer; data_array: pcuint8): cbool; cdecl; external;

function fifoSetAddressHandler(channel: integer; newhandler: FifoAddressHandlerFunc; userdata: pointer): cbool; cdecl; external;
function fifoSetValue32Handler(channel: integer; newhandler: FifoValue32HandlerFunc; userdata: pointer): cbool; cdecl; external;
function fifoSetDatamsgHandler(channel: integer; newhandler: FifoDatamsgHandlerFunc; userdata: pointer): cbool; cdecl; external;

function fifoCheckAddress(channel: integer): cbool; cdecl; external;
function fifoCheckValue32(channel: integer): cbool; cdecl; external;
function fifoCheckDatamsg(channel: integer): cbool; cdecl; external;

function fifoCheckDatamsgLength(channel: integer): cint; cdecl; external;

function fifoGetAddress(channel: integer): pointer; cdecl; external;

function fifoGetValue32(channel: integer): cuint32; cdecl; external;

function fifoGetDatamsg(channel, buffersize: cint; destbuffer: pcuint8): cint; cdecl; external;

procedure fifoWaitValue32(channel: cint); inline; 

{$endif NDS_INTERFACE}



{$ifdef NDS_IMPLEMENTATION}

procedure fifoWaitValue32(channel: cint); inline; 
begin

	while (not fifoCheckValue32(channel)) do
	begin
		swiIntrWait(1, IRQ_FIFO_NOT_EMPTY);
	end;

end;


{$endif NDS_IMPLEMENTATION}
