{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2005 by Free Pascal development team

    Low level memory functions

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{*****************************************************************************
      OS Memory allocation / deallocation
 ****************************************************************************}


function SysOSAlloc(size: ptruint): pointer;
begin
  SysOSAlloc:=h68kdos_malloc(size);

  { uppermost bit set means, the allocation has failed, so return nil }
  if (PtrUInt(SysOSAlloc) and $80000000) > 0 then
    SysOSAlloc:=nil;
end;

{$define HAS_SYSOSFREE}

procedure SysOSFree(p: pointer; size: ptruint);
begin
  h68kdos_mfree(p);
end;
