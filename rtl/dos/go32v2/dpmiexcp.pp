{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1997-98 by Pierre Muller

    DPMI Exception routines for Go32V2

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
Unit DPMIExcp;

{ If linking to C code we must avoid loading of the dpmiexcp.o
  in libc.a from the equivalent C code
  => all global functions from dpmiexcp.c must be aliased PM

  Problem this is only valid for DJGPP v2.01 }

interface

uses
  go32;

{ No stack checking ! }
{$S-}


{ Error Messages }
function do_faulting_finish_message : integer;

{ SetJmp/LongJmp }
type
  dpmi_jmp_buf = packed record
      eax,ebx,ecx,edx,esi,edi,ebp,esp,eip,flags : longint;
      cs,ds,es,fs,gs,ss : word;
  end;
  pdpmi_jmp_buf = ^dpmi_jmp_buf;
function dpmi_setjmp(var rec : dpmi_jmp_buf) : longint;
procedure dpmi_longjmp(var rec : dpmi_jmp_buf;return_value : longint);

{ Signals }
const
  SIGABRT   = 288;
  SIGFPE    = 289;
  SIGILL    = 290;
  SIGSEGV   = 291;
  SIGTERM   = 292;
  SIGALRM   = 293;
  SIGHUP    = 294;
  SIGINT    = 295;
  SIGKILL   = 296;
  SIGPIPE   = 297;
  SIGQUIT   = 298;
  SIGUSR1   = 299;
  SIGUSR2   = 300;
  SIGNOFP   = 301;
  SIGTRAP   = 302;
  SIGTIMR   = 303;    { Internal for setitimer (SIGALRM, SIGPROF) }
  SIGPROF   = 304;
  SIGMAX    = 320;

  SIG_BLOCK   = 1;
  SIG_SETMASK = 2;
  SIG_UNBLOCK = 3;

function SIG_DFL( x: longint) : longint;
function SIG_ERR( x: longint) : longint;
function SIG_IGN( x: longint) : longint;

type
  SignalHandler  = function (v : longint) : longint;
  PSignalHandler = SignalHandler; { to be compatible with linux.pp }

function signal(sig : longint;func : SignalHandler) : SignalHandler;
function _raise(sig : longint) : longint;

{ Exceptions }
type
  texception_state = record
    __eax, __ebx, __ecx, __edx, __esi : longint;
    __edi, __ebp, __esp, __eip, __eflags : longint;
    __cs, __ds, __es, __fs, __gs, __ss : word;
    __sigmask : longint;        {  for POSIX signals only  }
    __signum : longint;         {  for expansion  }
    __exception_ptr : longint;  {  pointer to previous exception  }
    __fpu_state : array [0..108-1] of byte; {  for future use  }
  end;
  pexception_state = ^texception_state;

procedure djgpp_exception_toggle;
procedure djgpp_exception_setup;
function  djgpp_exception_state : pexception_state;
function  djgpp_set_ctrl_c(enable : boolean) : boolean;

{ Other }
function dpmi_set_coprocessor_emulation(flag : longint) : longint;


implementation

{$ASMMODE DIRECT}

{$L exceptn.o}

var
  v2prt0_ds_alias : pointer;external name '___v2prt0_ds_alias';
  djgpp_ds_alias  : pointer;external name '___djgpp_ds_alias';
  endtext        : longint;external name '_etext';
  starttext       : longint;external name 'start';
  djgpp_old_kbd : tseginfo;external name '___djgpp_old_kbd';
  djgpp_hw_lock_start : longint;external name '___djgpp_hw_lock_start';
  djgpp_hw_lock_end : longint;external name '___djgpp_hw_lock_end';
  djgpp_hwint_flags : longint;external name '___djgpp_hwint_flags';
  djgpp_dos_sel : word;external name '___djgpp_dos_sel';
  djgpp_exception_table : array[0..0] of pointer;external name '___djgpp_exception_table';

procedure djgpp_i24;external name ' ___djgpp_i24';
procedure djgpp_iret;external name ' ___djgpp_iret';
procedure djgpp_npx_hdlr;external name '___djgpp_npx_hdlr';
procedure djgpp_kbd_hdlr;external name '___djgpp_kbd_hdlr';
procedure djgpp_kbd_hdlr_pc98;external name '___djgpp_kbd_hdlr_pc98';
procedure djgpp_cbrk_hdlr;external name '___djgpp_cbrk_hdlr';


var
  exceptions_on : boolean;
const
  cbrk_vect : byte = $1b;
  exception_level : longint = 0;


{****************************************************************************
                                  Helpers
****************************************************************************}

procedure err(const x : string);
begin
   write(stderr, x);
end;

procedure errln(const x : string);
begin
   writeln(stderr, x);
end;


procedure itox(v,len : longint);
var
  st : string;
begin
  st:=hexstr(v,len);
  err(st);
end;


{****************************************************************************
                              SetJmp/LongJmp
****************************************************************************}

function dpmi_setjmp(var rec : dpmi_jmp_buf) : longint;
begin
  asm
        pushl   %edi
        movl    rec,%edi
        movl    %eax,(%edi)
        movl    %ebx,4(%edi)
        movl    %ecx,8(%edi)
        movl    %edx,12(%edi)
        movl    %esi,16(%edi)
        { load edi }
        movl    -4(%ebp),%eax
        { ... and store it }
        movl    %eax,20(%edi)
        { ebp ... }
        movl    (%ebp),%eax
        movl    %eax,24(%edi)
        { esp ... }
        movl    %esp,%eax
        addl    $12,%eax
        movl    %eax,28(%edi)
        { the return address }
        movl    4(%ebp),%eax
        movl    %eax,32(%edi)
        { flags ... }
        pushfl
        popl    36(%edi)
        { !!!!! the segment registers, not yet needed }
        { you need them if the exception comes from
        an interrupt or a seg_move }
        movw    %cs,40(%edi)
        movw    %ds,42(%edi)
        movw    %es,44(%edi)
        movw    %fs,46(%edi)
        movw    %gs,48(%edi)
        movw    %ss,50(%edi)
        movl    ___djgpp_exception_state_ptr, %eax
        movl    %eax, 60(%edi)
        { restore EDI }
        pop     %edi
        { we come from the initial call }
        xorl    %eax,%eax
        leave
        ret $4
  end;
end;


procedure dpmi_longjmp(var  rec : dpmi_jmp_buf;return_value : longint);
begin
  if (@rec=pdpmi_jmp_buf(djgpp_exception_state)) and (exception_level>0) then
   dec(exception_level);
  asm
        { restore compiler shit }
        popl    %ebp
        { copy from longjmp.S }
        movl    4(%esp),%edi    { get dpmi_jmp_buf }
        movl    8(%esp),%eax    { store retval in j->eax }
        movl    %eax,0(%edi)

        movw    46(%edi),%fs
        movw    48(%edi),%gs
        movl    4(%edi),%ebx
        movl    8(%edi),%ecx
        movl    12(%edi),%edx
        movl    24(%edi),%ebp
        { Now for some uglyness.  The dpmi_jmp_buf structure may be ABOVE the
           point on the new SS:ESP we are moving to.  We don't allow overlap,
           but do force that it always be valid.  We will use ES:ESI for
           our new stack before swapping to it.  }
        movw    50(%edi),%es
        movl    28(%edi),%esi
        subl    $28,%esi        { We need 7 working longwords on stack }
        movl    60(%edi),%eax
        es
        movl    %eax,(%esi)     { Exception pointer }
        movzwl  42(%edi),%eax
        es
        movl    %eax,4(%esi)    { DS }
        movl    20(%edi),%eax
        es
        movl    %eax,8(%esi)    { EDI }
        movl    16(%edi),%eax
        es
        movl    %eax,12(%esi)   { ESI }
        movl    32(%edi),%eax
        es
        movl    %eax,16(%esi)   { EIP - start of IRET frame }
        movl    40(%edi),%eax
        es
        movl    %eax,20(%esi)   { CS }
        movl    36(%edi),%eax
        es
        movl    %eax,24(%esi)   { EFLAGS }
        movl    0(%edi),%eax
        movw    44(%edi),%es
        movw    50(%edi),%ss
        movl    %esi,%esp
        popl    ___djgpp_exception_state_ptr
        popl    %ds
        popl    %edi
        popl    %esi
        iret                    { actually jump to new cs:eip loading flags }
  end;
end;


{****************************************************************************
                                 Signals
****************************************************************************}

var
  signal_list : Array[0..SIGMAX] of SignalHandler;

function SIG_ERR(x:longint):longint;
begin
  SIG_ERR:=-1;
end;


function SIG_IGN(x:longint):longint;
begin
  SIG_IGN:=-1;
end;


function SIG_DFL(x:longint):longint;
begin
  SIG_DFL:=0;
end;


function signal(sig : longint;func : SignalHandler) : SignalHandler;
var
  temp : SignalHandler;
begin
  if ((sig <= 0) or (sig > SIGMAX) or (sig = SIGKILL)) then
   begin
     signal:=@SIG_ERR;
     runerror(201);
   end;
  temp := signal_list[sig - 1];
  signal_list[sig - 1] := func;
  signal:=temp;
end;


{ C counter part }
function c_signal(sig : longint;func : SignalHandler) : SignalHandler;cdecl;[public,alias : '_signal'];
var
  temp : SignalHandler;
begin
  temp:=signal(sig,func);
  c_signal:=temp;
end;


const
  signames : array [0..14] of string[4] = (
    'ABRT','FPE ','ILL ','SEGV','TERM','ALRM','HUP ',
    'INT ','KILL','PIPE','QUIT','USR1','USR2','NOFP','TRAP');

function _raise(sig : longint) : longint;
var
  temp : SignalHandler;
label
  traceback_exit;
begin
  if(sig <= 0) or (sig > SIGMAX) then
   exit(-1);
  temp:=signal_list[sig - 1];
  if (temp = SignalHandler(@SIG_IGN)) then
   exit(0);
  if (temp = SignalHandler(@SIG_DFL)) then
   begin
traceback_exit:
     if ((sig >= SIGABRT) and (sig <= SIGTRAP)) then
      begin
        err('Exiting due to signal SIG');
        err(signames[sig-sigabrt]);
      end
     else
      begin
        err('Exiting due to signal $');
        itox(sig, 4);
      end;
     errln('');
     do_faulting_finish_message();   { Exits, does not return }
     exit(-1);
   end;
  { this is incompatible with dxegen-dxeload stuff PM }
  if ((cardinal(temp) < cardinal(@starttext)) or
      (cardinal(temp) > cardinal(@endtext))) then
   begin
     errln('Bad signal handler, ');
     goto traceback_exit;
   end;
  temp(sig);
  exit(0);
end;


function c_raise(sig : longint) : longint;cdecl;[public,alias : '_raise'];
begin
  c_raise:=_raise(sig);
end;


{****************************************************************************
                                 Exceptions
****************************************************************************}

function except_to_sig(excep : longint) : longint;
begin
  case excep of
    5,8,9,11,12,13,14 : exit(SIGSEGV);
    0,4,16            : exit(SIGFPE);
    1,3               : exit(SIGTRAP);
    7                 : exit(SIGNOFP);
  else
    begin
      case excep of
        $75 : exit(SIGFPE);
        $78 : exit(SIGTIMR);
        $1b,
        $79 : exit(SIGINT);
      else
        exit(SIGILL);
      end;
    end;
  end;
end;


procedure show_call_frame;
begin
  errln('Call frame traceback EIPs:');
  errln('  0x'+hexstr(djgpp_exception_state^.__eip, 8));
  dump_stack(djgpp_exception_state^.__ebp);
end;


const
  EXCEPTIONCOUNT = 18;
  exception_names : array[0..EXCEPTIONCOUNT-1] of pchar = (
   'Division by Zero',
   'Debug',
   'NMI',
   'Breakpoint',
   'Overflow',
   'Bounds Check',
   'Invalid Opcode',
   'Coprocessor not available',
   'Double Fault',
   'Coprocessor overrun',
   'Invalid TSS',
   'Segment Not Present',
   'Stack Fault',
   'General Protection Fault',
   'Page fault',
   ' ',
   'Coprocessor Error',
   'Alignment Check');

  has_error : array [0..EXCEPTIONCOUNT-1] of byte =
   (0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,0,0,1);

  cbrk_hooked    : boolean = false;
  old_video_mode : byte = 3;


procedure dump_selector(const name : string; sel : word);
var
  base,limit : longint;
begin
  err(name);
  err(': sel=');
  itox(sel, 4);
  if (sel<>0) then
   begin
     base:=get_segment_base_address(sel);
     err('  base='); itox(base, 8);
     limit:=get_segment_limit(sel);
     err('  limit='); itox(limit, 8);
   end;
  errln('');
end;


function farpeekb(sel : word;offset : longint) : byte;
var
  b : byte;
begin
  seg_move(sel,offset,get_ds,longint(@b),1);
  farpeekb:=b;
end;



function do_faulting_finish_message : integer;
var
  en : pchar;
  signum,i : longint;
  old_vid : byte;
begin
  do_faulting_finish_message:=0;
  signum:=djgpp_exception_state^.__signum;
  { check video mode for original here and reset (not if PC98) */ }
  if ((go32_info_block.linear_address_of_primary_screen <> $a0000) and
     (farpeekb(dosmemselector, $449) <> old_video_mode)) then
    begin
       old_vid:=old_video_mode;
       asm
          pusha
          movzbl old_vid,%eax
          int $0x10
          popa
          nop
       end;
    end;

  if (signum >= EXCEPTIONCOUNT) then
    begin
       case signum of
         $75 : en:='Floating Point exception';
         $1b : en:='Control-Break Pressed';
         $79 : en:='Control-C Pressed';
       else
         en:=nil;
       end;
    end
  else
    en:=exception_names[signum];

  if (en = nil) then
    begin
       err('Exception ');
       itox(signum, 2);
       err(' at eip=');
       itox(djgpp_exception_state^.__eip, 8);
    end
  else
    begin
       write(stderr, 'FPC ',en);
       err(' at eip=');
       itox(djgpp_exception_state^.__eip, 8);
    end;
  { Control-C should stop the program also !}
  {if (signum = $79) then
    begin
       errln('');
       exit(-1);
    end;}
  if ((signum < EXCEPTIONCOUNT) and (has_error[signum]=1)) then
   begin
     errorcode := djgpp_exception_state^.__sigmask and $ffff;
     if(errorcode<>0) then
      begin
        err(', error=');
        itox(errorcode, 4);
      end;
   end;
  errln('');
  err('eax=');
  itox(djgpp_exception_state^.__eax, 8);
  err(' ebx='); itox(djgpp_exception_state^.__ebx, 8);
  err(' ecx='); itox(djgpp_exception_state^.__ecx, 8);
  err(' edx='); itox(djgpp_exception_state^.__edx, 8);
  err(' esi='); itox(djgpp_exception_state^.__esi, 8);
  err(' edi='); itox(djgpp_exception_state^.__edi, 8);
  errln('');
  err('ebp='); itox(djgpp_exception_state^.__ebp, 8);
  err(' esp='); itox(djgpp_exception_state^.__esp, 8);
  err(' program=');
  errln(paramstr(0));
  dump_selector('cs', djgpp_exception_state^.__cs);
  dump_selector('ds', djgpp_exception_state^.__ds);
  dump_selector('es', djgpp_exception_state^.__es);
  dump_selector('fs', djgpp_exception_state^.__fs);
  dump_selector('gs', djgpp_exception_state^.__gs);
  dump_selector('ss', djgpp_exception_state^.__ss);
  errln('');
  if (djgpp_exception_state^.__cs = get_cs) then
    show_call_frame;
  { must not return !! }
  if exceptions_on then
    djgpp_exception_toggle;
  asm
     pushw $1
     call  ___exit
  end;
end;


function djgpp_exception_state:pexception_state;assembler;
asm
        movl    ___djgpp_exception_state_ptr,%eax
end;


procedure djgpp_exception_processor;[public,alias : '___djgpp_exception_processor'];
var
  sig : longint;
begin
  inc(exception_level);
  sig:=djgpp_exception_state^.__signum;
  if (exception_level=1) or (sig=$78) then
    begin
       sig := except_to_sig(sig);
       _raise(sig);
       if (djgpp_exception_state^.__signum >= EXCEPTIONCOUNT) then
         {  Not exception so continue OK }
         dpmi_longjmp(pdpmi_jmp_buf(djgpp_exception_state)^, djgpp_exception_state^.__eax);
       { User handler did not exit or longjmp, we must exit }
       err('FPC cannot continue from exception, exiting due to signal ');
       itox(sig, 4);
       errln('');
    end
  else
    begin
       if exception_level>2 then
         begin
            errln('FPC triple exception, exiting !!! ');
            if (exceptions_on) then
              djgpp_exception_toggle;
            asm
               pushw $1
               call  ___exit
            end;
         end;
       err('FPC double exception, exiting due to signal ');
       itox(sig, 4);
       errln('');
    end;
  do_faulting_finish_message;
end;


type
  trealseginfo = tseginfo;
  pseginfo = ^tseginfo;
var
  except_ori : array [0..EXCEPTIONCOUNT-1] of tseginfo;
  kbd_ori    : tseginfo;
  npx_ori    : tseginfo;
  cbrk_ori,
  cbrk_rmcb  : trealseginfo;
  cbrk_regs  : registers;



procedure djgpp_exception_toggle;[alias : '___djgpp_exception_toggle'];
var
  _except : tseginfo;
  i : longint;
  local_ex : boolean;
begin
{$ifdef SYSTEMDEBUG}
  if exceptions_on then
   errln('Disabling FPC exceptions')
  else
   errln('Enabling FPC exceptions');
{$endif SYSTEMDEBUG}
  { toggle here to avoid infinite recursion }
  { if a subfunction calls runerror !!      }
  exceptions_on:=not exceptions_on;
  local_ex:=exceptions_on;
  asm
        movzbl  local_ex,%eax
        movl    %eax,_v2prt0_exceptions_on
  end;
  for i:=0 to EXCEPTIONCOUNT-1 do
   begin
     if get_pm_exception_handler(i,_except) then
      begin
        if (i <> 2) {or (_crt0_startup_flags & _CRT0_FLAG_NMI_SIGNAL))} then
         begin
           if not set_pm_exception_handler(i,except_ori[i]) then
            errln('error setting exception n�'+hexstr(i,2));
         end;
        except_ori[i]:=_except;
      end
     else
      begin
        if get_exception_handler(i,_except) then
         begin
           if (i <> 2) {or (_crt0_startup_flags & _CRT0_FLAG_NMI_SIGNAL))} then
            begin
              if not set_exception_handler(i,except_ori[i]) then
               errln('error setting exception n�'+hexstr(i,2));
            end;
           except_ori[i]:=_except;
         end;
      end;
   end;
  get_pm_interrupt($75,_except);
  set_pm_interrupt($75,npx_ori);
  npx_ori:=_except;
  get_pm_interrupt(9,_except);
  set_pm_interrupt(9,kbd_ori);
  kbd_ori:=_except;
  if (cbrk_hooked) then
   begin
     set_rm_interrupt(cbrk_vect,cbrk_ori);
     free_rm_callback(cbrk_rmcb);
     cbrk_hooked := false;
{$ifdef SYSTEMDEBUG}
     errln('back to ori rm cbrk  '+hexstr(cbrk_ori.segment,4)+':'+hexstr(longint(cbrk_ori.offset),4));
{$endif SYSTEMDEBUG}
   end
  else
   begin
     get_rm_interrupt(cbrk_vect, cbrk_ori);
{$ifdef SYSTEMDEBUG}
     errln('ori rm cbrk  '+hexstr(cbrk_ori.segment,4)+':'+hexstr(longint(cbrk_ori.offset),4));
{$endif SYSTEMDEBUG}
     get_rm_callback(@djgpp_cbrk_hdlr, cbrk_regs, cbrk_rmcb);
     set_rm_interrupt(cbrk_vect, cbrk_rmcb);
{$ifdef SYSTEMDEBUG}
     errln('now rm cbrk  '+hexstr(cbrk_rmcb.segment,4)+':'+hexstr(longint(cbrk_rmcb.offset),4));
{$endif SYSTEMDEBUG}
     cbrk_hooked := true;
   end;
end;


function dpmi_set_coprocessor_emulation(flag : longint) : longint;
var
  res : longint;
begin
  asm
        movl    flag,%ebx
        movl    $0xe01,%eax
        int     $0x31
        jc      .L_coproc_error
        xorl    %eax,%eax
.L_coproc_error:
        movl    %eax,res
  end;
  dpmi_set_coprocessor_emulation:=res;
end;


procedure dpmiexcp_exit{(status : longint)};[public,alias : 'excep_exit'];
{ We need to restore hardware interrupt handlers even if somebody calls
  `_exit' directly, or else we crash the machine in nested programs.
  We only toggle the handlers if the original keyboard handler is intact
  (otherwise, they might have already toggled them). }
begin
  if (exceptions_on) then
    djgpp_exception_toggle;
  asm
        xorl    %eax,%eax
        movl    %eax,_exception_exit
        movl    %eax,_swap_in
        movl    %eax,_swap_out
  end;
  { restore the FPU state }
  dpmi_set_coprocessor_emulation(1);
end;

{ _exit in dpmiexcp.c
  is already present in v2prt0.as  PM}

{ used by dos.pp for swap vectors }
procedure dpmi_swap_in;[public,alias : 'swap_in'];
begin
  if not (exceptions_on) then
   djgpp_exception_toggle;
end;


procedure dpmi_swap_out;[public,alias : 'swap_out'];
begin
  if (exceptions_on) then
   djgpp_exception_toggle;
end;



procedure djgpp_exception_setup;[alias : '___djgpp_exception_setup'];
var
  temp_kbd,
  temp_npx    : pointer;
  _except,
  old_kbd     : tseginfo;
  locksize    : longint;
  i           : longint;
begin
  asm
        movl    _exception_exit,%eax
        xorl    %eax,%eax
        jne     .L_already
        leal    excep_exit,%eax
        movl    %eax,_exception_exit
        leal    swap_in,%eax
        movl    %eax,_swap_in
        leal    swap_out,%eax
        movl    %eax,_swap_out
  end;
{ reset signals }
  for i := 0 to  SIGMAX-1 do
   signal_list[i] := SignalHandler(@SIG_DFL);
{ app_DS only used when converting HW interrupts to exceptions }
  asm
        movw    %ds,___djgpp_app_DS
        movw    %ds,___djgpp_our_DS
  end;
  djgpp_dos_sel:=dosmemselector;
{ lock addresses which may see HW interrupts }
  lock_code(@djgpp_hw_lock_start,@djgpp_hw_lock_end-@djgpp_hw_lock_start);
  _except.segment:=get_cs;
  _except.offset:=@djgpp_exception_table;
  for i:=0 to ExceptionCount-1 do
   begin
     except_ori[i] := _except;    { New value to set }
     inc(_except.offset,4);       { This is the size of push n, jmp }
   end;
  kbd_ori.segment:=_except.segment;
  npx_ori.segment:=_except.segment;
  npx_ori.offset:=@djgpp_npx_hdlr;
  if (go32_info_block.linear_address_of_primary_screen <> $a0000) then
   kbd_ori.offset:=@djgpp_kbd_hdlr
  else
   begin
     kbd_ori.offset:=@djgpp_kbd_hdlr_pc98;
     cbrk_vect := $06;
     _except.offset:=@djgpp_iret;
     set_pm_interrupt($23,_except);
   end;
  _except.offset:=@djgpp_i24;
  set_pm_interrupt($24, _except);
  get_pm_interrupt(9,djgpp_old_kbd);
  djgpp_exception_toggle;    { Set new values & save old values }
{ get original video mode and save }
  old_video_mode := farpeekb(dosmemselector, $449);
  asm
        .L_already:
  end;
end;


function djgpp_set_ctrl_c(enable : boolean) : boolean;
begin
  djgpp_set_ctrl_c:=(djgpp_hwint_flags and 1)=0;
  if enable then
   djgpp_hwint_flags:=djgpp_hwint_flags and (not 1)
  else
   djgpp_hwint_flags:=djgpp_hwint_flags or 1;
end;


function c_djgpp_set_ctrl_c(enable : longint) : boolean;cdecl;[public,alias : '___djgpp_set_ctrl_c'];
begin
  c_djgpp_set_ctrl_c:=djgpp_set_ctrl_c(boolean(enable));
end;



procedure InitDPMIExcp;
begin
  djgpp_ds_alias:=v2prt0_ds_alias;
  djgpp_exception_setup;
end;


begin
  InitDPMIExcp;
end.
{
  $Log$
  Revision 1.11  1998-11-17 09:42:50  pierre
   * position check of signal handler was wrong

  Revision 1.10  1998/10/13 21:42:42  peter
    * cleanup and use of external var
    * fixed ctrl-break crashes

  Revision 1.9  1998/08/20 08:08:36  pierre
    * dpmiexcp did not compile with older versions
      due to the proc to procvar bug
    * makefile separator problem fixed

  Revision 1.8  1998/08/19 10:56:33  pierre
    + added some special code for C interface
      to avoid loading of crt1.o or dpmiexcp.o from the libc.a

  Revision 1.7  1998/08/15 17:01:13  peter
    * smartlinking the units works now
    * setjmp/longjmp -> dmpi_setjmp/dpmi_longjmp to solve systemunit
      conflict

  Revision 1.6  1998/08/04 13:31:32  pierre
    * changed all FPK into FPC

  Revision 1.5  1998/07/08 12:02:19  carl
    * make it compiler under fpc v0995

  Revision 1.4  1998/06/26 08:19:08  pierre
    + all debug in ifdef SYSTEMDEBUG
    + added local arrays :
      opennames names of opened files
      fileopen boolean array to know if still open
      usefull with gdb if you get problems about too
      many open files !!

  Revision 1.3  1998/05/31 14:18:23  peter
    * force att or direct assembling
    * cleanup of some files

  Revision 1.2  1998/04/21 14:46:33  pierre
    + debug info better output
      no normal code changed
}
