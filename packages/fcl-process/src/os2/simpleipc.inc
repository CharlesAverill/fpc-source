{
    This file is part of the Free Component library.
    Copyright (c) 2007 by Tomas Hajny, member of
    the Free Pascal development team

    OS/2 implementation of one-way IPC between 2 processes

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$IFDEF FPC_DOTTEDUNITS}
uses OS2Api.doscalls, OS2Api.os2def;
{$ELSE FPC_DOTTEDUNITS}
uses DosCalls, OS2Def;
{$ENDIF FPC_DOTTEDUNITS}

ResourceString
  SErrFailedToCreatePipe = 'Failed to create named pipe: %s';
  SErrFailedToDisconnectPipe = 'Failed to disconnect named pipe: %s';

const
(* Constant used as key identifying a pipe connected to event semaphore. *)
(* 'FP' *)
  PipeKey = $4650;
  PipeBufSize = 256;

{ ---------------------------------------------------------------------
    TPipeClientComm
  ---------------------------------------------------------------------}

Type
  TPipeClientComm = Class(TIPCClientComm)
  Private
    FFileName: AnsiString;
    FStream: TFileStream;
  Public
    Constructor Create(AOWner : TSimpleIPCClient); override;
    Procedure Connect; override;
    Procedure Disconnect; override;
    Procedure SendMessage(MsgType : TMessageType; AStream : TStream); override;
    Function  ServerRunning : Boolean; override;
    Property FileName : String Read FFileName;
    Property Stream : TFileStream Read FStream;
  end;


constructor TPipeClientComm.Create (AOWner: TSimpleIPCClient);
begin
  inherited Create (AOWner);
  FFileName:= '\PIPE\' + Owner.ServerID;
  If (Owner.ServerInstance <> '') then
    FFileName := FFileName + '.' + Owner.ServerInstance;
end;


procedure TPipeClientComm.Connect;
begin
  try
    FStream := TFileStream.Create (FFileName, fmOpenWrite);
  finally
    Owner.DoError (SErrServerNotActive, [Owner.ServerID]);
  end;
end;


procedure TPipeClientComm.Disconnect;
begin
  FreeAndNil (FStream);
end;


procedure TPipeClientComm.SendMessage (MsgType: TMessageType; AStream: TStream);
var
  Hdr: TMsgHeader;
begin
  Hdr.Version := MsgVersion;
  Hdr.MsgType := MsgType;
  Hdr.MsgLen := AStream.Size;
  FStream.WriteBuffer (Hdr, SizeOf (Hdr));
  FStream.CopyFrom (AStream, 0);
end;


function TPipeClientComm.ServerRunning: boolean;
begin
{$WARNING Fake TPipeClientComm.ServerRunning - no safe solution known}
  Result := true;
end;


{ ---------------------------------------------------------------------
    TPipeServerComm
  ---------------------------------------------------------------------}

type
  TPipeServerComm = class (TIPCServerComm)
  private
    FFileName: ansistring;
    FStream: THandleStream;
    EventSem: THandle;
    SemName: ansistring;
  public
    constructor Create (AOWner: TSimpleIPCServer); override;
    procedure StartServer; override;
    procedure StopServer; override;
    function  PeekMessage (TimeOut: integer): boolean; override;
    procedure ReadMessage; override;
    function GetInstanceID: string; override;
    property FileName: Ansistring read FFileName;
    property Stream: THandleStream read FStream;
  end;


constructor TPipeServerComm.Create (AOWner: TSimpleIPCServer);
begin
  inherited Create (AOWner);
  FFileName := '\PIPE\' + Owner.ServerID;
  SemName := '\SEM32\PIPE\' + Owner.ServerID;
  If not Owner.Global then
    FFileName := FFileName + '.' + IntToStr (GetProcessID);
end;


procedure TPipeServerComm.StartServer;
var
  H: THandle;
begin
  if not (Assigned (FStream)) then
    if (DosCreateNPipe (PAnsiChar (FFileName), H, np_Access_Inbound,
        np_ReadMode_Message or np_WriteMode_Message or 1, PipeBufSize,
                                               PipeBufSize, 0) <> 0) or
           (DosCreateEventSem (PAnsiChar (SemName), EventSem, 0, 0) <> 0) or
                          (DosSetNPipeSem (H, EventSem, PipeKey) <> 0) or
                                            (DosConnectNPipe (H) <> 0) then
                           Owner.DoError (SErrFailedToCreatePipe, [FFileName]);
  FStream := THandleStream.Create (H);
end;


procedure TPipeServerComm.StopServer;
begin
  if (DosDisconnectNPipe (FStream.Handle) <> 0) or
                 (DosCloseEventSem (EventSem) <> 0) then
                       Owner.DoError (SErrFailedToDisconnectPipe, [FFileName]);
  FreeAndNil (FStream);
end;


function TPipeServerComm.PeekMessage (TimeOut: integer): boolean;
var
  PipeSemState: TPipeSemState;
begin
  Result := (DosQueryNPipeSemState (EventSem, PipeSemState,
             SizeOf (PipeSemState)) = 0) and (PipeSemState.Status = 1) and
                (PipeSemState.Avail <> 0) and (PipeSemState.Key = PipeKey);
  if not (Result) then
    Result := (DosWaitEventSem (EventSem, TimeOut) = 0) and
               (DosQueryNPipeSemState (EventSem, PipeSemState,
                SizeOf (PipeSemState)) = 0) and (PipeSemState.Status = 1) and
                    (PipeSemState.Avail <> 0) and (PipeSemState.Key = PipeKey);
end;


procedure TPipeServerComm.ReadMessage;

var
  Hdr: TMsgHeader;
  
begin
  FStream.ReadBuffer(Hdr,SizeOf(Hdr));
  PushMessage(Hdr,FStream);
end;

function TPipeServerComm.GetInstanceID: string;
begin
  Result := IntToStr (GetProcessID);
end;

{ ---------------------------------------------------------------------
    Set TSimpleIPCClient / TSimpleIPCServer defaults.
  ---------------------------------------------------------------------}

function TSimpleIPCServer.CommClass: TIPCServerCommClass;
begin
  if (DefaultIPCServerClass <> nil) then
    Result := DefaultIPCServerClass
  else
    Result := TPipeServerComm;
end;

function TSimpleIPCClient.CommClass: TIPCClientCommClass;
begin
  if (DefaultIPCClientClass <> nil) then
    Result := DefaultIPCClientClass
  else
    Result := TPipeClientComm;
end;
