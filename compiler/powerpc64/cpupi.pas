{
    Copyright (c) 2002 by Florian Klaempfl

    This unit contains the CPU specific part of tprocinfo

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 ****************************************************************************
}

{ This unit contains the CPU specific part of tprocinfo. }
unit cpupi;

{$I fpcdefs.inc}

interface

uses
  cutils,
  procinfo, cpuinfo, psub;

type
  tppcprocinfo = class(tcgprocinfo)
    { offset where the frame pointer from the outer procedure is stored. }
    parent_framepointer_offset: longint;
    constructor create(aparent: tprocinfo); override;
    procedure set_first_temp_offset; override;
    function calc_stackframe_size: longint; override;
    function calc_stackframe_size(numgpr, numfpr : longint): longint;

    needs_frame_pointer : boolean;
  end;

implementation

uses
  globtype, globals, systems,
  cpubase, cgbase,
  aasmtai,
  tgobj,
  symconst, symsym, paramgr, symutil,
  verbose;

constructor tppcprocinfo.create(aparent: tprocinfo);

begin
  inherited create(aparent);
  maxpushedparasize := 0;
  needs_frame_pointer := false;
end;

procedure tppcprocinfo.set_first_temp_offset;
var
  ofs: aword;
  locals: longint;
begin
  if not (po_assembler in procdef.procoptions) then begin
    { align the stack properly }
    ofs := align(maxpushedparasize + LinkageAreaSizeELF, 8);

    { the ABI specification says that it is required to always allocate space for 8 * 8 bytes
      for registers R3-R10 and stack header if there's a stack frame, but GCC doesn't do that,
      so we don't that too. Uncomment the next three lines if this is required }
//    if (ofs < 112) then begin
//      ofs := 112;
//    end;
    tg.setfirsttemp(ofs);
  end else begin
    locals := 0;
    current_procinfo.procdef.localst.foreach_static(@count_locals, @locals);
    if locals <> 0 then
      { at 0(r1), the previous value of r1 will be stored }
      tg.setfirsttemp(8);
  end;
end;

function tppcprocinfo.calc_stackframe_size: longint;
begin
  result := calc_stackframe_size(18, 18);
end;

function tppcprocinfo.calc_stackframe_size(numgpr, numfpr : longint) : longint;
begin
  { more or less copied from cgcpu.pas/g_stackframe_entry }
  if not (po_assembler in procdef.procoptions) then begin
    // no VMX support
    result := align(numgpr * tcgsize2size[OS_INT] +
        numfpr * tcgsize2size[OS_FLOAT], ELF_STACK_ALIGN);

    if (pi_do_call in flags) or (tg.lasttemp <> tg.firsttemp) or
      (result > RED_ZONE_SIZE) then begin
      result := align(result + tg.lasttemp, ELF_STACK_ALIGN);
    end;
  end else
    result := align(tg.lasttemp, ELF_STACK_ALIGN);
end;

begin
  cprocinfo := tppcprocinfo;
end.

