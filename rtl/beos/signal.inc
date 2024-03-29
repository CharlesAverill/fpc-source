{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Jonas Maebe,
    member of the Free Pascal development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}


Const   { For sending a signal }

  SA_NOCLDSTOP = 1;
  
  // does not exist under BeOS i think !
  SA_ONSTACK   = $001; { take signal on signal stack }
  SA_RESTART   = $002; { restart system call on signal return }
  SA_RESETHAND = $004; { reset to SIG_DFL when taking signal }
  SA_NODEFER   = $010; { don't mask the signal we're delivering }
  SA_NOCLDWAIT = $020; { don't keep zombies around }
  SA_SIGINFO   = $040; { signal handler with SA_SIGINFO args }
  SA_USERTRAMP = $100; { SUNOS compat: Do not bounce off kernel's sigtramp }

  SIG_BLOCK   = 1;
  SIG_UNBLOCK = 2;
  SIG_SETMASK = 3;

{BeOS Checked}
{
   The numbering of signals for BeOS attempts to maintain 
   some consistency with UN*X conventions so that things 
   like "kill -9" do what you expect.
}   

  SIG_DFL = 0 ;
  SIG_IGN = 1 ;
  SIG_ERR = -1 ;

  SIGHUP     = 1;
  SIGINT     = 2;
  SIGQUIT    = 3;
  SIGILL     = 4;
  SIGCHLD    = 5;
  SIGABRT    = 6;
  SIGPIPE    = 7;
  SIGFPE     = 8;
  SIGKILL    = 9;
  SIGSTOP    = 10;
  SIGSEGV    = 11;
  SIGCONT    = 12;
  SIGTSTP    = 13;
  SIGALRM    = 14;
  SIGTERM    = 15;
  SIGTTIN    = 16;
  SIGTTOU    = 17;
  SIGUSR1    = 18;
  SIGUSR2    = 19;
  SIGWINCH   = 20;
  SIGKILLTHR = 21;
  SIGTRAP    = 22;
  SIGBUS     = SIGSEGV;
  
{
   Signal numbers 23-32 are currently free but may be used in future
   releases.  Use them at your own peril (if you do use them, at least
   be smart and use them backwards from signal 32).
}

{$packrecords C}
const
  SI_PAD_SIZE   = ((128/sizeof(longint)) - 3);

{
 * The sequence of the fields/registers in struct sigcontext should match
 * those in mcontext_t.
 }

type 
  packed_fp_stack = packed record
    st0 : array[0..9] of byte;
    st1 : array[0..9] of byte;
    st2 : array[0..9] of byte;
    st3 : array[0..9] of byte;
    st4 : array[0..9] of byte;
    st5 : array[0..9] of byte;
    st6 : array[0..9] of byte;    
    st7 : array[0..9] of byte;    
  end;
  
  packed_mmx_regs = packed record
    mm0 : array[0..9] of byte;
    mm1 : array[0..9] of byte;
    mm2 : array[0..9] of byte;
    mm3 : array[0..9] of byte;
    mm4 : array[0..9] of byte;
    mm5 : array[0..9] of byte;
    mm6 : array[0..9] of byte;    
    mm7 : array[0..9] of byte;    
  end;
  
  old_extended_regs = packed record
    fp_control 	: word;
    _reserved1 	: word;
    fp_status 	: word;
    _reserved2 	: word;
    fp_tag 		: word;
    _reserved3 	: word;
    fp_eip 		: cardinal;
    fp_cs 		: word;
    fp_opcode	: word;
    fp_datap	: word;
    fp_ds		: word;
    _reserved4	: word;
    fp_mmx : record
      case fp_mmx : byte of
        0 : (fp	: packed_fp_stack);
        1 : (mmx	: packed_mmx_regs);
    end;
  end;
  
  fp_stack = record
    st0 : array[0..9] of byte;
    _reserved_42_47 : array[0..5] of byte;
    st1 : array[0..9] of byte;
    _reserved_58_63 : array[0..5] of byte;
    st2 : array[0..9] of byte;
    _reserved_74_79 : array[0..5] of byte;
    st3 : array[0..9] of byte;
    _reserved_90_95 : array[0..5] of byte;
    st4 : array[0..9] of byte;
    _reserved_106_111 : array[0..5] of byte;
    st5 : array[0..9] of byte;
    _reserved_122_127 : array[0..5] of byte;
    st6 : array[0..9] of byte;    
    _reserved_138_143 : array[0..5] of byte;
    st7 : array[0..9] of byte;        
    _reserved_154_159 : array[0..5] of byte;
  end;
  
  mmx_regs = record
    mm0 : array[0..9] of byte;
    _reserved_42_47 : array[0..5] of byte;
    mm1 : array[0..9] of byte;
    _reserved_58_63 : array[0..5] of byte;
    mm2 : array[0..9] of byte;
    _reserved_74_79 : array[0..5] of byte;
    mm3 : array[0..9] of byte;
    _reserved_90_95 : array[0..5] of byte;
    mm4 : array[0..9] of byte;
    _reserved_106_111 : array[0..5] of byte;
    mm5 : array[0..9] of byte;
    _reserved_122_127 : array[0..5] of byte;
    mm6 : array[0..9] of byte;    
    _reserved_138_143 : array[0..5] of byte;
    mm7 : array[0..9] of byte;    
    _reserved_154_159 : array[0..5] of byte;
  end;
  
  xmmx_regs = record
    xmm0 : array [0..15] of byte;
    xmm1 : array [0..15] of byte;
    xmm2 : array [0..15] of byte;
    xmm3 : array [0..15] of byte;
    xmm4 : array [0..15] of byte;
    xmm5 : array [0..15] of byte;
    xmm6 : array [0..15] of byte;
    xmm7 : array [0..15] of byte;
  end;
  
  new_extended_regs = record
    fp_control 	: word;
    fp_status 	: word;
    fp_tag		: word;
    fp_opcode	: word;
    fp_eip		: Cardinal;
    fp_cs		: word;
    res_14_15	: word;
    fp_datap	: Cardinal;
    fp_ds		: word;
    _reserved_22_23 : word;
    mxcsr		: Cardinal;
    _reserved_28_31 : Cardinal;
    fp_mmx : record
      case byte of
        0 : (fp : fp_stack);
        1 : (mmx : mmx_regs);
    end;
    xmmx : xmmx_regs;
    _reserved_288_511 : array[0..223] of byte;
  end;
  
  extended_regs = record
    state : record
      case byte of
  	    0 : (old_format : old_extended_regs);
  	    1 : (new_format : new_extended_regs);  	  
  	end;
  	format	: Cardinal;
  end;
  
  vregs = record
    eip 	: Cardinal;
    eflags 	: cardinal;
    eax		: Cardinal;
    ecx		: Cardinal;
    edx		: Cardinal;
    esp		: Cardinal;
    ebp		: Cardinal;
    _reserved_1 : Cardinal;
    xregs	: extended_regs;
    _reserved_2 : array[0..2] of Cardinal;
  end;
  
  Pvregs = ^vregs;

  sigset_t = array[0..3] of Longint;

    PSigContextRec = ^SigContextRec;
    SigContextRec = record
       sc_mask      : sigset_t;          { signal mask to restore }
       sc_onstack   : longint;              { sigstack state to restore }

       sc_gs        : longint;              { machine state (struct trapframe): }
       sc_fs        : longint;
       sc_es        : longint;
       sc_ds        : longint;
       sc_edi       : longint;
       sc_esi       : longint;
       sc_ebp       : longint;
       sc_isp       : longint;
       sc_ebx       : longint;
       sc_edx       : longint;
       sc_ecx       : longint;
       sc_eax       : longint;
       sc_trapno    : longint;
       sc_err       : longint;
       sc_eip       : longint;
       sc_cs        : longint;
       sc_efl       : longint;
       sc_esp       : longint;
       sc_ss        : longint;
        {
         * XXX FPU state is 27 * 4 bytes h/w, 1 * 4 bytes s/w (probably not
         * needed here), or that + 16 * 4 bytes for emulators (probably all
         * needed here).  The "spare" bytes are mostly not spare.
         }
       en_cw        : cardinal;     { control word (16bits used) }
       en_sw        : cardinal;     { status word (16bits) }
       en_tw        : cardinal;     { tag word (16bits) }
       en_fip       : cardinal;     { floating point instruction pointer }
       en_fcs       : word;         { floating code segment selector }
       en_opcode    : word;         { opcode last executed (11 bits ) }
       en_foo       : cardinal;     { floating operand offset }
       en_fos       : cardinal;     { floating operand segment selector }
       fpr_acc      : array[0..79] of AnsiChar;
       fpr_ex_sw    : cardinal;
       fpr_pad      : array[0..63] of AnsiChar;
       end;
       
  SignalHandler   = Procedure(Sig : Longint);cdecl;
  PSignalHandler  = ^SignalHandler;
  SignalRestorer  = Procedure;cdecl;
  PSignalRestorer = ^SignalRestorer;
  {$WARNING TODO : check with signal.h}
  sigActionHandler = procedure(Sig: Longint; SigContext: PSigContextRec; uContext : Pvregs);cdecl;

  Sigset=sigset_t;
  TSigset=sigset_t;
  PSigSet = ^SigSet;
  psigset_t=psigset;

  SigActionRec = packed record
//    Handler  : record
    sa_handler : sigActionHandler;
//      case byte of
//        0: (Sh: SignalHandler);
//        1: (Sa: TSigAction);
//      end;
    sa_Mask     : SigSet;
    sa_Flags    : Longint;
    sa_userdaa  : pointer
  end;

  PSigActionRec = ^SigActionRec;

{
  Change action of process upon receipt of a signal.
  Signum specifies the signal (all except SigKill and SigStop).
  If Act is non-nil, it is used to specify the new action.
  If OldAct is non-nil the previous action is saved there.
}



