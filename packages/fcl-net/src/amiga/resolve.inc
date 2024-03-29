{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2022 by Michael van Canney and other members of the
    Free Pascal development team

    Amiga parts of the resolver

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

uses
  Sysutils;
const
  { Net type }
  socklib = 'c';
  AF_INET = 2;

  { Error constants. Returned by LastError method of THost, TNet}

  NETDB_INTERNAL= -1;       { see errno }
  NETDB_SUCCESS = 0;        { no problem }
  HOST_NOT_FOUND= 1;        { Authoritative Answer Host not found }
  TRY_AGAIN     = 2;        { Non-Authoritive Host not found, or SERVERFAIL }
  NO_RECOVERY   = 3;        { Non recoverable errors, FORMERR, REFUSED, NOTIMP }
  NO_DATA       = 4;        { Valid name, no data record of requested type }
  NO_ADDRESS    = NO_DATA;  { no address, look for MX record }


Type

  { THostEnt Object }
  THostEnt = record
    H_Name     : PAnsiChar;   { Official name }
    H_Aliases  : PPAnsiChar;  { Null-terminated list of aliases}
    H_Addrtype : longint;   { Host address type }
    H_length  : longint;   { Length of address }
    H_Addr : PPAnsiChar;    { null-terminated list of adresses }
  end;
  PHostEntry = ^THostEnt;

  { TNetEnt object }
  TNetEnt = record
    N_Name     : PAnsiChar;   { Official name }
    N_Aliases  : PPAnsiChar;  { Nill-terminated alias list }
    N_AddrType : longint; { Net address type }
    N_net      : Cardinal; { Network number }
  end;
  PNetEntry = ^TNetEnt;

  TServEnt = record
    s_name    : PAnsiChar;    { Service name }
    s_aliases : PPAnsiChar;   { Null-terminated alias list }
    s_port    : longint;  { Port number }
    s_proto   : PAnsiChar;    { Protocol to use }
  end;
  PServEntry = ^TServEnt;

{ remember, classic style calls are also used on MorphOS, so don't test for AMIGA68K }
{$ifndef AMIGAOS4}
function fpgethostbyname(Name: PAnsiChar location 'a0'): PHostEntry; syscall SocketBase 210;
function getnetbyname(Name: PAnsiChar location 'a0'): PNetEntry; syscall SocketBase 222;
function getnetbyaddr(Net: Longint location 'd0'; NetType: Longint location 'd1'): PNetEntry; syscall SocketBase 228;
function getservbyname(Name: PAnsiChar location 'a0'; Protocol: PAnsiChar location 'a1'): PServEntry; syscall SocketBase 234;
function getservbyport(Port: LongInt location 'd0'; Protocol: PAnsiChar location 'a0'): PServEntry; syscall SocketBase 240;

procedure setnetent(Stayopen: Longint location 'd0');  syscall SocketBase 516;
procedure endnetent; syscall SocketBase 522;
function getnetent: PNetEntry; syscall SocketBase 528;
procedure setservent(StayOpen: longint location 'd0'); syscall SocketBase 552;
procedure endservent; syscall SocketBase 558;
function getservent: PServEntry; syscall SocketBase 564;

{$else AMIGAOS4}

function fpgethostbyname(const Name: PAnsiChar): PHostEntry; syscall ISocket 196;
function getnetbyname(Name: PAnsiChar): PNetEntry; syscall ISocket 204;
function getnetbyaddr(Net: Longint; NetType: Longint): PNetEntry; syscall ISocket 208;
function getservbyname(Name: PAnsiChar; Protocol: PAnsiChar): PServEntry; syscall ISocket 212;
function getservbyport(Port: LongInt; Protocol: PAnsiChar): PServEntry; syscall ISocket 216;

procedure setnetent(Stayopen: Longint);  syscall ISocket 456;
procedure endnetent; syscall ISocket 460;
function getnetent: PNetEntry; syscall ISocket 464;
procedure setservent(StayOpen: longint); syscall ISocket 480;
procedure endservent; syscall ISocket 484;
function getservent: PServEntry; syscall ISocket 488;
{$endif AMIGAOS4}

function gethostbyname(Name: PAnsiChar): PHostEntry;
begin
  if Assigned(SocketBase) then
    gethostbyname := fpgethostbyname(Name)
  else
    gethostbyname := nil;
end;

function gethostbyaddr(Addr: PAnsiChar; Len: Longint; HType: Longint): PHostentry;
var
  addr1,
  addr2: in_addr;
  IP: PPLongInt;
begin
  gethostbyaddr := nil;
  if not Assigned(SocketBase) then
    Exit;
  //
  Addr1 :=  in_addr(PHostAddr(Addr)^);
  Addr2.s_addr := htonl(Addr1.s_addr);
  gethostbyaddr := Pointer(bsd_GetHostByAddr(Pointer(@Addr2.s_addr), Len, HType));
  if Assigned(gethostbyaddr) then
  begin
    ip := Pointer(gethostbyaddr^.H_Addr);
    if Assigned(ip) then
    begin
      repeat
        ip^^ := ntohl(ip^^);
        Inc(IP);
      until ip^ = nil;
    end;
  end;
end;

function  GetDNSError: integer;
begin
  GetDNSError := 0;
  if assigned(SocketBase) then
    GetDNSError:=bsd_Errno;
end;

Function InitResolve : Boolean;
begin
  Result:=Assigned(SocketBase);
end;

Function FinalResolve : Boolean;
begin
  Result:=True;
end;
