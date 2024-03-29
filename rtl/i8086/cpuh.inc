{

    This file is part of the Free Pascal run time library.
    Copyright (c) 2016 by the Free Pascal development team.

    CPU specific system unit header file

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

 const
  {$I cpuinnr.inc}
   { will be detected at startup }
  { 0=8086/8088/80186/80188/NEC V20/NEC V30, 1=80286, 2=80386 or newer }
  Test8086 : byte = 0; public name '__Test8086';
  { will be detected at startup }
  { 0=NO FPU, 1=8087, 2=80287, 3=80387 or newer }
  Test8087 : byte = 0;
  { will be detected at startup }
  has_sse_support : boolean = false;
  has_mmx_support : boolean = false;

function fpc_x86_inportb(port : word) : byte;[internproc:fpc_in_x86_inportb];
function fpc_x86_inportw(port : word) : word;[internproc:fpc_in_x86_inportw];
//function fpc_x86_inportl(port : word) : longint;[internproc:fpc_in_x86_inportl];
procedure fpc_x86_outportb(port : word;data : byte);[internproc:fpc_in_x86_outportb];
procedure fpc_x86_outportw(port : word;data : word);[internproc:fpc_in_x86_outportw];
//procedure fpc_x86_outportl(port : word;data : longint);[internproc:fpc_in_x86_outportl];
procedure fpc_x86_cli;[internproc:fpc_in_x86_cli];
procedure fpc_x86_sti;[internproc:fpc_in_x86_sti];
function fpc_x86_get_cs:word;[internproc:fpc_in_x86_get_cs];
function fpc_x86_get_ss:word;[internproc:fpc_in_x86_get_ss];
function fpc_x86_get_ds:word;[internproc:fpc_in_x86_get_ds];
function fpc_x86_get_es:word;[internproc:fpc_in_x86_get_es];
function fpc_x86_get_fs:word;[internproc:fpc_in_x86_get_fs];
function fpc_x86_get_gs:word;[internproc:fpc_in_x86_get_gs];

type
  TNativeFPUControlWord = word;
