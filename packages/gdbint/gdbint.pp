{
    $Id$
    Copyright (c) 1998 by Peter Vreman

    Lowlevel GDB interface which communicates directly with libgdb

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit GdbInt;
interface

{ this is not needed (PM) $output_format as}

{.$define Debug}
{.$define DebugCommand}
{$define NotImplemented}

{$ifdef go32v2}
 {$undef NotImplemented}
 { ifdef GDB_V418 changed to ifndef GDB_V416}
{$ifdef USE_GDB_OBJS}
  {$include gdbobjs.inc}
{$else USE_GDB_OBJS}
  {$LINKLIB gdb}
{$endif ndef USE_GDB_OBJS}
  {$LINKLIB dbg}
  {$LINKLIB c}
{$endif go32v2}

{$ifdef linux}
 {$undef NotImplemented}
 {$LINKLIB ncurses}
 {$LINKLIB gdb}
 {$LINKLIB c}
 {$LINKLIB gcc}
{$endif linux}

{$ifdef win32}
 {$undef NotImplemented}
 {$LINKLIB cygwin}
 {$LINKLIB gdb}
 {$ifdef USE_TERMCAP}
   {$LINKLIB termcap}
 {$else not USE_TERMCAP}
   {$LINKLIB ncurses}
 {$endif not USE_TERMCAP}
 {$LINKLIB gcc}
 {$LINKLIB c}
 {$LINKLIB cygwin}
 { all those are maybe not necessary
   but at least user32 is required
   because of clipboard handling PM }
 {$LINKLIB kernel32}
 {$LINKLIB user32}
 {$LINKLIB shell32}
{$endif win32}

{$ifdef go32v2}
 {$define supportexceptions}
{$endif go32v2}
{$ifdef linux}
 {$define supportexceptions}
{$endif linux}

{$ifdef NotImplemented}
{$fatal This OS is not yet supported !!!}
{$endif NotImplemented}

type
  psyminfo=^tsyminfo;
  tsyminfo=record
    address  : longint;
    fname    : pchar;
    line     : longint;
    funcname : pchar;
    offset   : longint;
  end;

  tframeentry = object
    file_name : pchar;
    function_name : pchar;
    args : pchar;
    line_number : longint;
    address : longint;
    level : longint;
    constructor init;
    destructor done;
    procedure reset;
    procedure clear;
  end;
  pframeentry=^tframeentry;
  ppframeentry=^pframeentry;

{$ifndef GDB_V416}
{ needed for handles }
{not anymore I textrec.inc}

{ GDB_FILE type }
type
  streamtype = (afile,astring);
  C_FILE     = longint; { at least under DJGPP }
  P_C_FILE   = ^C_FILE;

  PGDB_FILE = ^TGDB_FILE;
  TGDB_FILE = record
              ts_streamtype : streamtype;
              ts_filestream : P_C_FILE;
              ts_strbuf : pchar;
              ts_buflen : longint;
              end;
{$ifdef win32}
  { from sys/reent.h
    real structure is bigger but only std.. are wanted here PM }
  REENT = record
    err : longint;
    stdin,stdout,stderr : P_C_FILE;
  end;
  PREENT = ^REENT;

var _impure_ptr : PREENT;cvar;external;

{$endif win32}
{$endif not GDB_V416}
type
  tgdbbuffer=object
    buf   : pchar;
    size,
    idx   : longint;
{$ifndef GDB_V416}
    link  : pgdb_file;
{$endif not GDB_V416}
    constructor Init;
    destructor  Done;
    procedure Reset;
    procedure Resize(nsize : longint);
    procedure Append(p:pchar);
  end;

  pgdbinterface=^tgdbinterface;
  tgdbinterface=object
    gdberrorbuf,
    gdboutputbuf  : tgdbbuffer;
    got_error,
    reset_command,
    call_reset,
    Debuggee_started : boolean;
    { frames and frame info while recording a frame }
    frames        : ppframeentry;
    frame_size,
    frame_count   : longint;
    record_frames,
    frame_begin_seen : boolean;
    frame_level,
    command_level,
    stop_breakpoint_number,
    current_address,
    current_line_number,
    signal_start,
    signal_end,
    error_start,
    error_end,
    function_start,
    function_end,
    args_start,
    args_end,
    file_start,
    file_end,
    line_start,
    line_end : longint;
    { breakpoint }
    last_breakpoint_number,
    last_breakpoint_address,
    last_breakpoint_line : longint;
    last_breakpoint_file : pchar;
    invalid_breakpoint_line : boolean;
    { init }
    constructor init;
    destructor  done;
    { Lowlevel }
    function  error:boolean;
    function  error_num:longint;
    procedure gdb_command(const s:string);
    procedure gdb__init;
    procedure gdb_done;
    procedure resize_frames;
    function  add_frameentry:pframeentry;
    function  get_frameentry(level : longint):pframeentry;
    procedure clear_frames;
    { Highlevel }
    user_screen_shown,
    switch_to_user     : boolean;
    procedure GetAddrSyminfo(addr:longint;var si:tsyminfo);
    procedure SelectSourceline(fn:pchar;line:longint);
    procedure StartSession;
    procedure BreakSession;
    procedure EndSession(code:longint);
    procedure DebuggerScreen;
    procedure UserScreen;
    { Hooks }
    procedure DoSelectSourceline(const fn:string;line:longint);virtual;
    procedure DoStartSession;virtual;
    procedure DoBreakSession;virtual;
    procedure DoEndSession(code:longint);virtual;
    procedure DoDebuggerScreen;virtual;
    procedure DoUserScreen;virtual;
    function  AllowQuit : boolean;virtual;
  end;


function  GDBVersion : string;

var
  curr_gdb : pgdbinterface;

const
  use_gdb_file : boolean = false;
var
  gdb_file : text;

{$ifdef go32v2}
  { needed to be sure %fs contains the DOS memory selector
    used in Mem[] code PM }
  procedure reload_fs;
{$endif go32v2}

implementation

uses
{$ifdef win32}
  initc,
{$endif win32}
{$ifdef linux}
  linux,
{$endif}
{$ifdef go32v2}
  go32,
  dpmiexcp,
  initc,
{$endif}
  strings;

{*****************************************************************************
                          Types used by libgdb.a
*****************************************************************************}

{$ifdef go32v2}
type
  jmp_buf = dpmi_jmp_buf;
  pjmp_buf = pdpmi_jmp_buf;

  function setjmp(var rec : jmp_buf) : longint;cdecl;external;

  procedure longjmp(var rec : jmp_buf;return_value : longint);cdecl;external;

  procedure reload_fs;assembler;
  asm
     movw  dosmemselector,%ax
     movw  %ax,%fs
  end['EAX'];

{$endif}
{$ifdef win32}
  function setjmp(var rec : jmp_buf) : longint;cdecl;external;

  procedure longjmp(var rec : jmp_buf;return_value : longint);cdecl;external;

{$ifndef supportexceptions}
type
  { I don't think FPC would accept that
    the funcvar return type is the funcvar type itself ! PM }
  SignalHandler   = Procedure(Sig : LongInt);cdecl;
  function signal(sig : longint;new_signal : SignalHandler) : SignalHandler;cdecl;external;

{define supportexceptions not yet working }
{$endif now exceptions are supported for win32}
{$endif win32}

  type
     CORE_ADDR = longint;
     pCORE_ADDR = ^CORE_ADDR;
     pblock = ^block;

     tlanguage = (language_unknown,language_auto,language_c,
       language_cplus,language_java,language_chill,
       language_fortran,language_m2,language_asm,
       language_scm,language_pascal,language_objc);

     bptype = (bp_breakpoint,bp_hardware_breakpoint,
       bp_until,bp_finish,bp_watchpoint,bp_hardware_watchpoint,
       bp_read_watchpoint,bp_access_watchpoint,
       bp_longjmp,bp_longjmp_resume,bp_step_resume,
       bp_through_sigtramp,bp_watchpoint_scope,
       bp_call_dummy,bp_shlib_event);

     tenable = (disabled,enabled,shlib_disabled);

     bpdisp = (del,del_at_next_stop,disable,donttouch);

{$PACKRECORDS 4}
     pbreakpoint = ^breakpoint;
     breakpoint = record
          next : pbreakpoint;
          typ : bptype;
          enable : tenable;
          disposition : bpdisp;
          number : longint;
          address : CORE_ADDR;
          line_number : longint;
          source_file : pchar;
          silent : byte;
          ignore_count : longint;
          shadow_contents : array[0..15] of char;
          inserted : char;
          duplicate : char;
          commands : pointer; {^command_line}
          frame : CORE_ADDR;
          cond : pointer; {^expression}
          addr_string : ^char;
          language : tlanguage;
          input_radix : longint;
          cond_string : ^char;
          exp_string : ^char;
          exp : pointer; {^expression}
          exp_valid_block : pblock; {^block;}
          val : pointer; {value_ptr;}
          val_chain : pointer; {value_ptr;}
          related_breakpoint : pbreakpoint;
          watchpoint_frame : CORE_ADDR;
          thread : longint;
          hit_count : longint;
          section : pointer; {^asection}
       end;

     tfreecode=(free_nothing,free_contents,free_linetable);

     psymtab = ^symtab;
     symtab = record
          next : psymtab;
          blockvector : pointer; {^blockvector;}
          linetable : pointer; {^linetable;}
          block_line_section : longint;
          primary : longint;
          filename : pchar;
          dirname : pchar;
          free_code : tfreecode;
          free_ptr : pchar;
          nlines : longint;
          line_charpos : ^longint;
          language : tlanguage;
          Debugformat : pchar;
          version : pchar;
          fullname : pchar;
          objfile : pointer; {^objfile;}
       end;

     psymtab_and_line = ^symtab_and_line;
     symtab_and_line = record
          symtab : psymtab;
{$ifndef GDB_V416}
          { v4.16 does not have the section field !! }
          section : pointer; {^asection;}
{$endif GDB_V416}
          line : longint;
          pc : CORE_ADDR;
          _end : CORE_ADDR;
       end;

     symtabs_and_lines = record
          sals : ^symtab_and_line;
          nelts : longint;
       end;

    psymbol = ^symbol;
    pminimal_symbol = ^minimal_symbol;

    general_symbol_info = record
  (* Name of the symbol.  This is a required field.  Storage for the name is
     allocated on the psymbol_obstack or symbol_obstack for the associated
     objfile. *)

      _name : pchar;

  (* Value of the symbol.  Which member of this union to use, and what
     it means, depends on what kind of symbol this is and its
     SYMBOL_CLASS.  See comments there for more details.  All of these
     are in host byte order (though what they point to might be in
     target byte order, e.g. LOC_CONST_BYTES).  *)
     value : record
       case integer of
      (* The fact that this is a long not a LONGEST mainly limits the
	 range of a LOC_CONST.  Since LOC_CONST_BYTES exists, I'm not
	 sure that is a big deal.  *)
       0 : (ivalue : longint;);

       1 : (block  : pblock;);

       2 : (bytes  : pchar;);

       3 : (address : CORE_ADDR;);

      (* for opaque typedef struct chain *)

       4 : (chain : psymbol;);
      end;

  (* Since one and only one language can apply, wrap the language specific
     information inside a union. *)

   (* union
    {
      struct cplus_specific      /* For C++ */
				/*  and Java */
	{
	  char *demangled_name;
	} cplus_specific;
      struct chill_specific      /* For Chill */
	{
	  char *demangled_name;
	} chill_specific;
    } language_specific; *)
     demangled_name : pchar;

  (* Record the source code language that applies to this symbol.
     This is used to select one of the fields from the language specific
     union above. *)

    language : tlanguage;

  (* Which section is this symbol in?  This is an index into
     section_offsets for this objfile.  Negative means that the symbol
     does not get relocated relative to a section.
     Disclaimer: currently this is just used for xcoff, so don't
     expect all symbol-reading code to set it correctly (the ELF code
     also tries to set it correctly).  *)

    section : word;

  (* The bfd section associated with this symbol. *)

    bfd_section : pointer {^asection};
  end; { of general_symbol_info record declaration }

  tminimal_symbol_type =
    (
      mst_unknown := 0,	        (* Unknown type, the default *)
      mst_text,		        (* Generally executable instructions *)
      mst_data,		        (* Generally initialized data *)
      mst_bss,		        (* Generally uninitialized data *)
      mst_abs,		        (* Generally absolute (nonrelocatable) *)
      (* GDB uses mst_solib_trampoline for the start address of a shared
	 library trampoline entry.  Breakpoints for shared library functions
	 are put there if the shared library is not yet loaded.
	 After the shared library is loaded, lookup_minimal_symbol will
	 prefer the minimal symbol from the shared library (usually
	 a mst_text symbol) over the mst_solib_trampoline symbol, and the
	 breakpoints will be moved to their true address in the shared
	 library via breakpoint_re_set.  *)
      mst_solib_trampoline,     (* Shared library trampoline code *)
      (* For the mst_file* types, the names are only guaranteed to be unique
	 within a given .o file.  *)
      mst_file_text,            (* Static version of mst_text *)
      mst_file_data,	        (* Static version of mst_data *)
      mst_file_bss	        (* Static version of mst_bss *)
    );

  namespace_enum = (
  (* UNDEF_NAMESPACE is used when a namespace has not been discovered or
     none of the following apply.  This usually indicates an error either
     in the symbol information or in gdb's handling of symbols. *)
  UNDEF_NAMESPACE,

  (* VAR_NAMESPACE is the usual namespace.  In C, this contains variables,
     function names, typedef names and enum type values. *)
  VAR_NAMESPACE,

  (* STRUCT_NAMESPACE is used in C to hold struct, union and enum type names.
     Thus, if `struct foo' is used in a C program, it produces a symbol named
     `foo' in the STRUCT_NAMESPACE. *)
  STRUCT_NAMESPACE,

  (* LABEL_NAMESPACE may be used for names of labels (for gotos);
     currently it is not used and labels are not recorded at all.  *)
  LABEL_NAMESPACE,

  (* Searching namespaces. These overlap with VAR_NAMESPACE, providing
     some granularity with the search_symbols function. *)
  (* Everything in VAR_NAMESPACE minus FUNCTIONS_-, TYPES_-, and
     METHODS_NAMESPACE *)
  VARIABLES_NAMESPACE,

  (* All functions -- for some reason not methods, though. *)
  FUNCTIONS_NAMESPACE,

  (* All defined types *)
  TYPES_NAMESPACE,

  (* All class methods -- why is this separated out? *)
  METHODS_NAMESPACE

  );
  address_class = (
  (* Not used; catches errors *)
  LOC_UNDEF,

  (* Value is constant int SYMBOL_VALUE, host byteorder *)
  LOC_CONST,

  (* Value is at fixed address SYMBOL_VALUE_ADDRESS *)
  LOC_STATIC,

  (* Value is in register.  SYMBOL_VALUE is the register number.  *)
  LOC_REGISTER,

  (* It's an argument; the value is at SYMBOL_VALUE offset in arglist.  *)
  LOC_ARG,

  (* Value address is at SYMBOL_VALUE offset in arglist.  *)
  LOC_REF_ARG,

  (* Value is in register number SYMBOL_VALUE.  Just like LOC_REGISTER
     except this is an argument.  Probably the cleaner way to handle
     this would be to separate address_class (which would include
     separate ARG and LOCAL to deal with FRAME_ARGS_ADDRESS versus
     FRAME_LOCALS_ADDRESS), and an is_argument flag.

     For some symbol formats (stabs, for some compilers at least),
     the compiler generates two symbols, an argument and a register.
     In some cases we combine them to a single LOC_REGPARM in symbol
     reading, but currently not for all cases (e.g. it's passed on the
     stack and then loaded into a register).  *)
  LOC_REGPARM,

  (* Value is in specified register.  Just like LOC_REGPARM except the
     register holds the address of the argument instead of the argument
     itself. This is currently used for the passing of structs and unions
     on sparc and hppa.  It is also used for call by reference where the
     address is in a register, at least by mipsread.c.  *)
  LOC_REGPARM_ADDR,

  (* Value is a local variable at SYMBOL_VALUE offset in stack frame.  *)
  LOC_LOCAL,

  (* Value not used; definition in SYMBOL_TYPE.  Symbols in the namespace
     STRUCT_NAMESPACE all have this class.  *)
  LOC_TYPEDEF,

  (* Value is address SYMBOL_VALUE_ADDRESS in the code *)
  LOC_LABEL,

  (* In a symbol table, value is SYMBOL_BLOCK_VALUE of a `struct block'.
     In a partial symbol table, SYMBOL_VALUE_ADDRESS is the start address
     of the block.  Function names have this class. *)
  LOC_BLOCK,

  (* Value is a constant byte-sequence pointed to by SYMBOL_VALUE_BYTES, in
     target byte order.  *)
  LOC_CONST_BYTES,

  (* Value is arg at SYMBOL_VALUE offset in stack frame. Differs from
     LOC_LOCAL in that symbol is an argument; differs from LOC_ARG in
     that we find it in the frame (FRAME_LOCALS_ADDRESS), not in the
     arglist (FRAME_ARGS_ADDRESS).  Added for i960, which passes args
     in regs then copies to frame.  *)
  LOC_LOCAL_ARG,

  (* Value is at SYMBOL_VALUE offset from the current value of
     register number SYMBOL_BASEREG.  This exists mainly for the same
     things that LOC_LOCAL and LOC_ARG do; but we need to do this
     instead because on 88k DWARF gives us the offset from the
     frame/stack pointer, rather than the offset from the "canonical
     frame address" used by COFF, stabs, etc., and we don't know how
     to convert between these until we start examining prologues.

     Note that LOC_BASEREG is much less general than a DWARF expression.
     We don't need the generality (at least not yet), and storing a general
     DWARF expression would presumably take up more space than the existing
     scheme.  *)
  LOC_BASEREG,

  (* Same as LOC_BASEREG but it is an argument.  *)
  LOC_BASEREG_ARG,

  (* Value is at fixed address, but the address of the variable has
     to be determined from the minimal symbol table whenever the
     variable is referenced.
     This happens if debugging information for a global symbol is
     emitted and the corresponding minimal symbol is defined
     in another object file or runtime common storage.
     The linker might even remove the minimal symbol if the global
     symbol is never referenced, in which case the symbol remains
     unresolved.  *)
  LOC_UNRESOLVED,

  (* Value is at a thread-specific location calculated by a
     target-specific method. *)
  LOC_THREAD_LOCAL_STATIC,

  (* The variable does not actually exist in the program.
     The value is ignored.  *)
  LOC_OPTIMIZED_OUT,

  (* The variable is static, but actually lives at * (address).
   * I.e. do an extra indirection to get to it.
   * This is used on HP-UX to get at globals that are allocated
   * in shared libraries, where references from images other
   * than the one where the global was allocated are done
   * with a level of indirection.
   *)
  LOC_INDIRECT
  );

   minimal_symbol = record
  (* The general symbol info required for all types of symbols.
     The SYMBOL_VALUE_ADDRESS contains the address that this symbol
     corresponds to.  *)
    ginfo : general_symbol_info;

  (* The info field is available for caching machine-specific information
     so it doesn't have to rederive the info constantly (over a serial line).
     It is initialized to zero and stays that way until target-dependent code
     sets it.  Storage for any data pointed to by this field should be allo-
     cated on the symbol_obstack for the associated objfile.
     The type would be "void *" except for reasons of compatibility with older
     compilers.  This field is optional.

     Currently, the AMD 29000 tdep.c uses it to remember things it has decoded
     from the instructions in the function header, and the MIPS-16 code uses
     it to identify 16-bit procedures.  *)

    info : pchar;

{$ifdef SOFUN_ADDRESS_MAYBE_MISSING}
  (* Which source file is this symbol in?  Only relevant for mst_file_*.  *)
    filename : pchar;
{$endif}

  (* Classification types for this symbol.  These should be taken as "advisory
     only", since if gdb can't easily figure out a classification it simply
     selects mst_unknown.  It may also have to guess when it can't figure out
     which is a better match between two types (mst_data versus mst_bss) for
     example.  Since the minimal symbol info is sometimes derived from the
     BFD library's view of a file, we need to live with what information bfd
     supplies. *)

    minimal_symbol_type : tminimal_symbol_type;
  end{ of minimal_symbol};

  block = record
  (* Addresses in the executable code that are in this block.  *)
  startaddr,
  endaddr : CORE_ADDR ;

  (* The symbol that names this block, if the block is the body of a
     function; otherwise, zero.  *)
  _function : psymbol;

  (* The `struct block' for the containing block, or 0 if none.
     The superblock of a top-level local block (i.e. a function in the
     case of C) is the STATIC_BLOCK.  The superblock of the
     STATIC_BLOCK is the GLOBAL_BLOCK.  *)

  superblock : pblock;

  (* Version of GCC used to compile the function corresponding
     to this block, or 0 if not compiled with GCC.  When possible,
     GCC should be compatible with the native compiler, or if that
     is not feasible, the differences should be fixed during symbol
     reading.  As of 16 Apr 93, this flag is never used to distinguish
     between gcc2 and the native compiler.

     If there is no function corresponding to this block, this meaning
     of this flag is undefined.  *)

  gcc_compile_flag : byte;

  (* Number of local symbols.  *)
  nsyms : longint;

  (* The symbols.  If some of them are arguments, then they must be
     in the order in which we would like to print them.  *)
  sym : array [0..0] of psymbol;
  end { of block definition };

  symbol = record
  (* The general symbol info required for all types of symbols. *)
    ginfo : general_symbol_info;

  (* Data type of value *)
    _type : pointer{ptype};

  (* Name space code.  *)
  namespace : namespace_enum;

  (* Address class *)

  aclass : address_class;

  (* Line number of definition.  FIXME:  Should we really make the assumption
     that nobody will try to debug files longer than 64K lines?  What about
     machine generated programs? *)

  line : word;

  (* Some symbols require an additional value to be recorded on a per-
     symbol basis.  Stash those values here. *)

  (*union
    {
      /* Used by LOC_BASEREG and LOC_BASEREG_ARG.  */
      short basereg;
    } *)
  aux_value_base_reg : word;

  (* Link to a list of aliases for this symbol.
     Only a "primary/main symbol may have aliases.  *)
  aliases : pointer{palias_list};

  (* List of ranges where this symbol is active.  This is only
     used by alias symbols at the current time.  *)
  ranges : pointer{prange_list};
  end;

     target_signal = (TARGET_SIGNAL_FIRST := 0,
       TARGET_SIGNAL_HUP := 1,TARGET_SIGNAL_INT := 2,
       TARGET_SIGNAL_QUIT := 3,TARGET_SIGNAL_ILL := 4,
       TARGET_SIGNAL_TRAP := 5,TARGET_SIGNAL_ABRT := 6,
       TARGET_SIGNAL_EMT := 7,TARGET_SIGNAL_FPE := 8,
       TARGET_SIGNAL_KILL := 9,TARGET_SIGNAL_BUS := 10,
       TARGET_SIGNAL_SEGV := 11,TARGET_SIGNAL_SYS := 12,
       TARGET_SIGNAL_PIPE := 13,TARGET_SIGNAL_ALRM := 14,
       TARGET_SIGNAL_TERM := 15,TARGET_SIGNAL_URG := 16,
       TARGET_SIGNAL_STOP := 17,TARGET_SIGNAL_TSTP := 18,
       TARGET_SIGNAL_CONT := 19,TARGET_SIGNAL_CHLD := 20,
       TARGET_SIGNAL_TTIN := 21,TARGET_SIGNAL_TTOU := 22,
       TARGET_SIGNAL_IO := 23,TARGET_SIGNAL_XCPU := 24,
       TARGET_SIGNAL_XFSZ := 25,TARGET_SIGNAL_VTALRM := 26,
       TARGET_SIGNAL_PROF := 27,TARGET_SIGNAL_WINCH := 28,
       TARGET_SIGNAL_LOST := 29,TARGET_SIGNAL_USR1 := 30,
       TARGET_SIGNAL_USR2 := 31,TARGET_SIGNAL_PWR := 32,
       TARGET_SIGNAL_POLL := 33,TARGET_SIGNAL_WIND := 34,
       TARGET_SIGNAL_PHONE := 35,TARGET_SIGNAL_WAITING := 36,
       TARGET_SIGNAL_LWP := 37,TARGET_SIGNAL_DANGER := 38,
       TARGET_SIGNAL_GRANT := 39,TARGET_SIGNAL_RETRACT := 40,
       TARGET_SIGNAL_MSG := 41,TARGET_SIGNAL_SOUND := 42,
       TARGET_SIGNAL_SAK := 43,TARGET_SIGNAL_PRIO := 44,
       TARGET_SIGNAL_REALTIME_33 := 45,TARGET_SIGNAL_REALTIME_34 := 46,
       TARGET_SIGNAL_REALTIME_35 := 47,TARGET_SIGNAL_REALTIME_36 := 48,
       TARGET_SIGNAL_REALTIME_37 := 49,TARGET_SIGNAL_REALTIME_38 := 50,
       TARGET_SIGNAL_REALTIME_39 := 51,TARGET_SIGNAL_REALTIME_40 := 52,
       TARGET_SIGNAL_REALTIME_41 := 53,TARGET_SIGNAL_REALTIME_42 := 54,
       TARGET_SIGNAL_REALTIME_43 := 55,TARGET_SIGNAL_REALTIME_44 := 56,
       TARGET_SIGNAL_REALTIME_45 := 57,TARGET_SIGNAL_REALTIME_46 := 58,
       TARGET_SIGNAL_REALTIME_47 := 59,TARGET_SIGNAL_REALTIME_48 := 60,
       TARGET_SIGNAL_REALTIME_49 := 61,TARGET_SIGNAL_REALTIME_50 := 62,
       TARGET_SIGNAL_REALTIME_51 := 63,TARGET_SIGNAL_REALTIME_52 := 64,
       TARGET_SIGNAL_REALTIME_53 := 65,TARGET_SIGNAL_REALTIME_54 := 66,
       TARGET_SIGNAL_REALTIME_55 := 67,TARGET_SIGNAL_REALTIME_56 := 68,
       TARGET_SIGNAL_REALTIME_57 := 69,TARGET_SIGNAL_REALTIME_58 := 70,
       TARGET_SIGNAL_REALTIME_59 := 71,TARGET_SIGNAL_REALTIME_60 := 72,
       TARGET_SIGNAL_REALTIME_61 := 73,TARGET_SIGNAL_REALTIME_62 := 74,
       TARGET_SIGNAL_REALTIME_63 := 75,TARGET_SIGNAL_UNKNOWN,
       TARGET_SIGNAL_DEFAULT,TARGET_SIGNAL_LAST
       );

     strata = (dummy_stratum,file_stratum,core_stratum,download_stratum,process_stratum);

     ptarget_ops = ^target_ops;
     target_ops = record
          to_shortname : pchar;
          to_longname : pchar;
          to_doc : pchar;
          to_open : procedure (_para1:pchar; _para2:longint);
          to_close : procedure (_para1:longint);
          to_attach : procedure (_para1:pchar; _para2:longint);
          to_detach : procedure (_para1:pchar; _para2:longint);
          to_resume : procedure (_para1:longint; _para2:longint; _para3:target_signal);
          to_wait : pointer; {function (_para1:longint; _para2:ptarget_waitstatus):longint;}
          to_fetch_registers : procedure (_para1:longint);
          to_store_registers : procedure (_para1:longint);
          to_prepare_to_store : procedure ;
          to_xfer_memory : function (memaddr:CORE_ADDR; myaddr:pchar; len:longint; write:longint; target:ptarget_ops):longint;
          to_files_info : procedure (_para1:ptarget_ops);
          to_insert_breakpoint : function (_para1:CORE_ADDR; _para2:pchar):longint;
          to_remove_breakpoint : function (_para1:CORE_ADDR; _para2:pchar):longint;
          to_terminal_init : procedure ;
          to_terminal_inferior : procedure ;
          to_terminal_ours_for_output : procedure ;
          to_terminal_ours : procedure ;
          to_terminal_info : procedure (_para1:pchar; _para2:longint);
          to_kill : procedure ;
          to_load : procedure (_para1:pchar; _para2:longint);
          to_lookup_symbol : function (_para1:pchar; _para2:pCORE_ADDR):longint;
          to_create_inferior : procedure (_para1:pchar; _para2:pchar; _para3:ppchar);
          to_mourn_inferior : procedure ;
          to_can_run : function :longint;
          to_notice_signals : procedure (pid:longint);
          to_thread_alive : function (pid:longint):longint;
          to_stop : procedure ;
          to_stratum : strata;
          DONT_USE : pointer;
          to_has_all_memory : longint;
          to_has_memory : longint;
          to_has_stack : longint;
          to_has_registers : longint;
          to_has_execution : longint;
          to_sections : pointer; {^section_table}
          to_sections_end : pointer; {^section_table}
          to_magic : longint;
       end;

{$PACKRECORDS NORMAL}

{*****************************************************************************
                   Define external calls to libgdb.a
*****************************************************************************}

var
{ external variables }
  error_return : jmp_buf;cvar;external;
  quit_return  : jmp_buf;cvar;external;
  inferior_pid : longint;cvar;external;
  create_breakpoint_hook : pointer;cvar;external;
  current_target : target_ops;cvar;external;
  stop_pc      : CORE_ADDR;cvar;external;

{ we need also to declare some vars }
  watchdog      : longint;cvar;public;
  gdb_error     : longint;cvar;public;
  display_time  : longbool;cvar;public;
  display_space : longbool;cvar;public;

{$ifndef GDB_V416}
{ the following are also needed from version 4.18 }

{ Whether this is the command line version or not }
  tui_version : longint;cvar;public;

{ Whether xdb commands will be handled }
  xdb_commands : longint;cvar;public;

{ Whether dbx commands will be handled }
  dbx_commands : longint;cvar;public;

var
  gdb_stdout : PGDB_FILE;cvar;public;
  gdb_stderr : PGDB_FILE;cvar;public;

{ used for gdb_stdout and gdb_stderr }
function xmalloc(size : longint) : pointer;cdecl;external;

{$endif not GDB_V416}

function  find_pc_line(i:CORE_ADDR;l:longint):symtab_and_line;cdecl;external;
function  find_pc_function(i:CORE_ADDR):psymbol;cdecl;external;
function  lookup_minimal_symbol_by_pc(i : CORE_ADDR):pminimal_symbol;cdecl;external;
procedure gdb_init;cdecl;external;
procedure execute_command(p:pchar;i:longint);cdecl;external;
procedure target_kill;cdecl;external;
procedure target_close(i:longint);cdecl;external;


{*****************************************************************************
                                 Helpers
*****************************************************************************}

procedure Debug(const s:string);
begin
  if use_gdb_file then
    Writeln(gdb_file,s)
  else
    Writeln(s);
end;


{*****************************************************************************
                               TFrameEntry
*****************************************************************************}

constructor tframeentry.init;
begin
  Reset;
end;

destructor tframeentry.done;
begin
  Clear;
end;

procedure tframeentry.reset;
begin
  file_name:=nil;
  function_name:=nil;
  args:=nil;
  line_number:=0;
  address:=0;
end;

procedure tframeentry.clear;
begin
  if assigned(file_name) then
   strdispose(file_name);
  if assigned(function_name) then
   strdispose(function_name);
  if assigned(args) then
   strdispose(args);
  reset;
end;


{*****************************************************************************
                                 tgdbbuffer
*****************************************************************************}

const
  blocksize=2048;

constructor tgdbbuffer.init;
begin
  Buf:=nil;
{$ifndef GDB_V416}
  link:=nil;
{$endif not GDB_V416}
  Size:=0;
  Resize(blocksize);
  Reset;
end;


destructor tgdbbuffer.done;
begin
  if assigned(buf) then
    freemem(buf,size);
{$ifndef GDB_V416}
  if assigned(link) then
    begin
      link^.ts_streamtype:=afile;
      link^.ts_strbuf:=nil;
      link^.ts_buflen:=0;
    end;
{$endif not GDB_V416}
end;



procedure tgdbbuffer.reset;
begin
  idx:=0;
  Buf[0]:=#0;
end;


procedure tgdbbuffer.append(p:pchar);
var
  len : longint;
begin
  if not assigned(p) then
   exit;
  len:=Strlen(p);
  if len+idx>size then
   Resize(len+idx);
  Move(p^,buf[idx],len);
  inc(idx,len);
  buf[idx]:=#0;
end;


procedure tgdbbuffer.resize(nsize : longint);
var
  np    : pchar;
begin
  nsize:=((nsize+blocksize-1) div blocksize)*blocksize;
  getmem(np,nsize);
  if assigned(buf) then
    begin
       move(buf^,np^,size);
       freemem(buf,size);
    end;
  buf:=np;
  size:=nsize;
{$ifndef GDB_V416}
  if assigned(link) then
    begin
      link^.ts_strbuf:=buf;
      link^.ts_buflen:=size;
    end;
{$endif not GDB_V416}
end;


{*****************************************************************************
                         Hook calls from libgdb.a
*****************************************************************************}

{$ifdef go32v2}
procedure gdbpas_prev_exception_handler;cdecl;public;
begin
end;
{$endif go32v2}

procedure init_proc;cdecl;public;
begin
end;


procedure annotate_signalled;cdecl;public;
begin
{$ifdef Debug}
  Debug('|signalled|');
{$endif}
end;


procedure annotate_signal_name;cdecl;public;
begin
{$ifdef Debug}
  Debug('|signal_name|');
  with curr_gdb^ do
   signal_start:=gdboutputbuf.idx;
{$endif}
end;


procedure annotate_signal_name_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|signal_name_end|');
{$endif}
end;


procedure annotate_signal_string;cdecl;public;
begin
{$ifdef Debug}
  Debug('|signal_string|');
{$endif}
end;


procedure annotate_signal_string_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|signal_string_end|');
{$endif}
  with curr_gdb^ do
   begin
     signal_end:=gdboutputbuf.idx;
{
  signal = (char *)alloca(signal_end-signal_start+1);
  strncpy(signal,gdb_output_buffer+signal_start,signal_end-signal_start);
  signal[signal_end-signal_start] = 0;
  if (user_screen_shown)
    __DebuggerScreen();
    _UserWarning(WARN_SIGNALED,signal);
    __UserScreen();
  else
    _UserWarning(WARN_SIGNALED,signal); }
     call_reset:=true;
   end;
end;


procedure annotate_signal;cdecl;public;
begin
{$ifdef Debug}
  Debug('|signal|');
{$endif}
end;


procedure annotate_exited(exitstatus:longint);cdecl;public;
begin
{$ifdef Debug}
  Debug('|exited|');
{$endif}
{#ifdef __DJGPP__
 /* this is very important. The exit code of a djgpp program
   disables interrupts and after this there is no other interrupt
   called, which enables interrupts with the iret. */
  __dpmi_get_and_enable_virtual_interrupt_state();
#endif }
{$ifdef go32v2}
   {$asmmode att}
     asm
        movw $0x901,%ax
        int  $0x31
     end;
   {$asmmode default}
   reload_fs;
{$endif def go32v2}

  curr_gdb^.DebuggerScreen;
{  DeleteBreakPoints; }
  curr_gdb^.EndSession(exitstatus);
end;


procedure annotate_error;cdecl;public;
begin
{$ifdef Debug}
  Debug('|error|');
{$endif}
end;


procedure annotate_error_begin;cdecl;public;
begin
{$ifdef Debug}
  Debug('|error begin|');
{$endif}
  with curr_gdb^ do
   begin
     error_start:=gdboutputbuf.idx+strlen(gdboutputbuf.buf);
     got_error:=true;
   end;
{$ifdef Debug}
  Debug('|end of error begin|');
{$endif}
end;


procedure annotate_starting;cdecl;public;
begin
{$ifdef Debug}
  Debug('|starting|');
{$endif}
{$ifdef go32v2}
     reload_fs;
{$endif go32v2}
  curr_gdb^.UserScreen;
end;


procedure annotate_stopped;cdecl;public;
var
  sym : symtab_and_line;
  fname : pchar;
begin
{$ifdef Debug}
  Debug('|stopped|');
{$endif}
  with curr_gdb^ do
   begin
{$ifdef go32v2}
     reload_fs;
{$endif go32v2}
     DebuggerScreen;
     Debuggee_started:=inferior_pid<>0;
     if not Debuggee_started then exit;
     if reset_command then exit;
      sym:=find_pc_line(stop_pc,0);
     if assigned(sym.symtab) then
      fname:=sym.symtab^.filename
     else
      fname:=nil;
     SelectSourceLine(fname,sym.line);
   end;
end;


procedure proc_remove_foreign(pid:longint);cdecl;public;
begin
end;


procedure breakpoints_changed;cdecl;public;
begin
{$ifdef Debug}
  Debug('|breakpoints_changed|');
{$endif}
end;


procedure annotate_breakpoint(num:longint);cdecl;public;
begin
{$ifdef Debug}
  Debug('|breakpoint(%d)|');
{$endif}
  With Curr_gdb^ do
    stop_breakpoint_number:=num;
end;


procedure annotate_watchpoint(num:longint);cdecl;public;
begin
{$ifdef Debug}
  Debug('|watchpoint(%d)|');
{$endif}
  With Curr_gdb^ do
    stop_breakpoint_number:=num;
end;

procedure annotate_catchpoint(num:longint);cdecl;public;
begin
{$ifdef Debug}
  Debug('|catchpoint(%d)|');
{$endif}
  With Curr_gdb^ do
    stop_breakpoint_number:=num;
end;


procedure annotate_breakpoints_headers;cdecl;public;
begin
{$ifdef Debug}
  Debug('|breakpoints_headers|');
{$endif}
end;


procedure annotate_breakpoints_table;cdecl;public;
begin
{$ifdef Debug}
  Debug('|breakpoints_table|');
{$endif}
end;


procedure annotate_record;cdecl;public;
begin
{$ifdef Debug}
  Debug('|record|');
{$endif}
end;


procedure annotate_breakpoints_table_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|breakpoints_table_end|');
{$endif}
end;


procedure annotate_frames_invalid;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frames_invalid|');
{$endif}
end;


procedure annotate_frame_begin(level:longint;pc:CORE_ADDR);cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_begin(%d,%ld)|');
{$endif}
  with curr_gdb^ do
   begin
     frame_begin_seen:=true;
     frame_level:=level;
     current_address:=pc;
     current_line_number:=-1;
     function_start:=-1;
     function_end:=-1;
     args_start:=-1;
     args_end:=-1;
     file_start:=-1;
     file_end:=-1;
     line_start:=-1;
     line_end:=-1;
   end;
end;


procedure annotate_frame_address;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_address|');
{$endif}
end;


procedure annotate_frame_address_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_address_end|');
{$endif}
end;

procedure annotate_frame_function_name;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_function_name|');
{$endif}
  with curr_gdb^ do
   function_start:=gdboutputbuf.idx;
end;


procedure annotate_frame_args;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_args|');
{$endif}
  with curr_gdb^ do
   begin
     function_end:=gdboutputbuf.idx;
     args_start:=gdboutputbuf.idx;
   end;
end;

procedure annotate_frame_source_begin;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_source_begin|');
{$endif}
  with curr_gdb^ do
   args_end:=gdboutputbuf.idx;
end;


procedure annotate_frame_source_file;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_source_file|');
{$endif}
  with curr_gdb^ do
   file_start:=gdboutputbuf.idx;
end;

procedure annotate_frame_source_file_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_source_file_end|');
{$endif}
  with curr_gdb^ do
   file_end:=gdboutputbuf.idx;
end;


procedure annotate_frame_source_line;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_source_line|');
{$endif}
  with curr_gdb^ do
   line_start:=gdboutputbuf.idx;
end;


procedure annotate_frame_source_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_source_end|');
{$endif}
  with curr_gdb^ do
   line_end:=gdboutputbuf.idx;
end;


procedure annotate_frame_where;cdecl;public;
begin
{$ifdef Debug}
  Debug('|frame_where|');
{$endif}
end;


procedure annotate_frame_end;cdecl;public;
var
  fe : pframeentry;
  c  : char;
  err : integer;
begin
{$ifdef Debug}
  Debug('|frame_end|');
{$endif}
  with curr_gdb^ do
   begin
     if (not record_frames) and (not frame_begin_seen) then
      exit;
     { This can happen, when the function has no Debugging information }
     if (args_start >= 0) and (args_end < 0) then
      args_end:=gdboutputbuf.idx;
     frame_begin_seen:=false;
     fe:=get_frameentry(frame_level);
     fe^.address:=current_address;
     fe^.level:=frame_level;
     if (function_start>=0) then
      begin
        c:=gdboutputbuf.buf[function_end];
        gdboutputbuf.buf[function_end]:=#0;
        fe^.function_name:=strnew(gdboutputbuf.buf+function_start);
        gdboutputbuf.buf[function_end]:=c;
      end;
     if (file_start>=0)  then
      begin
        c:=gdboutputbuf.buf[file_end];
        gdboutputbuf.buf[file_end]:=#0;
        fe^.file_name:=strnew(gdboutputbuf.buf+file_start);
        gdboutputbuf.buf[file_end]:=c;
      end;
     if (args_start>=0) then
      begin
        if (gdboutputbuf.buf[args_end-1]=#10) then
         dec(args_end);
        c:=gdboutputbuf.buf[args_end];
        gdboutputbuf.buf[args_end]:=#0;
        fe^.args:=strnew(gdboutputbuf.buf+args_start);
        gdboutputbuf.buf[args_end]:=c;
      end;
     if (line_start>=0) then
      begin
        c:=gdboutputbuf.buf[line_end];
        gdboutputbuf.buf[line_end]:=#0;
{     sscanf(gdb_output_buffer+line_start,'%d',&fe^.line_number); }
        val(strpas(pchar(@gdboutputbuf.buf[line_start])),fe^.line_number,err);
        gdboutputbuf.buf[line_end]:=c;
      end;
   end;
end;


procedure annotate_quit;cdecl;public;
begin
{$ifdef Debug}
  Debug('|quit|');
{$endif}
end;


procedure annotate_arg_begin;cdecl;public;
begin
{$ifdef Debug}
  Debug('|arg_begin|');
{$endif}
end;


procedure annotate_arg_name_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|arg_name_end|');
{$endif}
end;


procedure annotate_arg_value(typ:pointer);cdecl;public;
begin
{$ifdef Debug}
  Debug('|arg_value|');
{$endif}
end;


procedure annotate_arg_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|arg_end|');
{$endif}
end;

procedure annotate_source(filename:pchar;line,character,mid:longint;pc:CORE_ADDR);cdecl;public;
begin
{$ifdef Debug}
  Debug('|source|');
{$endif}
end;


procedure annotate_function_call;cdecl;public;
begin
{$ifdef Debug}
  Debug('|function_call|');
{$endif}
end;


procedure annotate_signal_handler_caller;cdecl;public;
begin
{$ifdef Debug}
  Debug('|signal_handler_caller|');
{$endif}
end;


procedure annotate_array_section_begin(index:longint;elttype:pointer);cdecl;public;
begin
{$ifdef Debug}
  Debug('|array_section_begin()|');
{$endif}
end;


procedure annotate_elt_rep(repcount:longint);cdecl;public;
begin
{$ifdef Debug}
  Debug('|elt_rep()|');
{$endif}
end;

procedure annotate_elt_rep_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|elt_rep_end|');
{$endif}
end;


procedure annotate_elt;cdecl;public;
begin
{$ifdef Debug}
  Debug('|elt|');
{$endif}
end;


procedure annotate_array_section_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|array_section_end|');
{$endif}
end;

procedure annotate_display_begin;cdecl;public;
begin
{$ifdef Debug}
  Debug('|display_begin|');
{$endif}
end;


procedure annotate_display_number_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|display_number_end|');
{$endif}
end;


procedure annotate_display_format;cdecl;public;
begin
{$ifdef Debug}
  Debug('|display_format|');
{$endif}
end;

procedure annotate_display_expression;cdecl;public;
begin
{$ifdef Debug}
  Debug('|display_expression|');
{$endif}
end;


procedure annotate_display_expression_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|display_expression_end|');
{$endif}
end;


procedure annotate_display_value;cdecl;public;
begin
{$ifdef Debug}
  Debug('|display_value|');
{$endif}
end;


procedure annotate_display_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('|display_end|');
{$endif}
end;


procedure annotate_field (num:longint);cdecl;public;
begin
{$ifdef Debug}
  Debug('a_field(%d)');
{$endif}
end;


procedure annotate_field_begin(typ:pointer);cdecl;public;
begin
{$ifdef Debug}
  Debug('a_field_begin\n');
{$endif}
end;


procedure annotate_field_name_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('a_field_name_end\n');
{$endif}
end;


procedure annotate_field_value;cdecl;public;
begin
{$ifdef Debug}
  Debug('a_field_value\n');
{$endif}
end;


procedure annotate_field_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('a_field_end\n');
{$endif}
end;


procedure annotate_value_history_begin (histindex:longint;typ:pointer);cdecl;public;
begin
{$ifdef Debug}
  Debug('a_value_history_begin(%d)\n');
{$endif}
end;


procedure annotate_value_begin (typ:pointer);cdecl;public;
begin
{$ifdef Debug}
  Debug('a_value_begin\n');
{$endif}
end;


procedure annotate_value_history_value;cdecl;public;
begin
{$ifdef Debug}
  Debug('a_value_history_value\n');
{$endif}
end;


procedure annotate_value_history_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('a_value_history_end\n');
{$endif}
end;


procedure annotate_value_end;cdecl;public;
begin
{$ifdef Debug}
  Debug('a_value_end\n');
{$endif}
end;


procedure _initialize_annotate;cdecl;public;
begin
end;


procedure fputs_unfiltered(linebuffer:pchar;stream:pointer);cdecl;public;
begin
  with curr_gdb^ do
{$ifndef gdb_v416}
  if stream = gdb_stderr then
     gdberrorbuf.append(linebuffer)
  else
{$endif not gdb_v416}
     gdboutputbuf.append(linebuffer);
end;


procedure CreateBreakPointHook(var b:breakpoint);cdecl;
var
  sym : symtab_and_line;
begin
  sym:=find_pc_line(b.address,0);
  with curr_gdb^ do
   begin
     last_breakpoint_number:=b.number;
     { function breakpoints have zero as file and as line !!
       but they are valid !! }
     invalid_breakpoint_line:=(b.line_number<>sym.line) and (b.line_number<>0);
     last_breakpoint_address:=b.address;
     last_breakpoint_line:=sym.line;
     if assigned(sym.symtab) then
      last_breakpoint_file:=sym.symtab^.filename
     else
      last_breakpoint_file:=nil;
   end;
end;


{*****************************************************************************
                                 tgdbinterface
*****************************************************************************}

constructor tgdbinterface.init;
begin
  gdboutputbuf.init;
  gdberrorbuf.init;
{$ifndef GDB_V416}
(* GDB_FILE *
  gdb_file_init_astring (n)
    int n;
  should we use xmalloc ?
  gdb could resize the buffer => crash,
  but normally it should not if unfiltered !! PM *)
  gdb_stdout^.ts_streamtype := astring;
  gdb_stdout^.ts_strbuf := gdboutputbuf.buf;
  gdb_stdout^.ts_buflen := gdboutputbuf.size;
  gdboutputbuf.link:=gdb_stdout;

  gdb_stderr^.ts_streamtype := astring;
  gdb_stderr^.ts_strbuf := gdberrorbuf.buf;
  gdb_stderr^.ts_buflen := gdberrorbuf.size;
  gdberrorbuf.link:=gdb_stderr;
{$endif not GDB_V416}

  gdb__init;
  curr_gdb:=@self;
  command_level:=0;
{ set output mode for GDB }
{ only these values disable filtering
  DONT CHANGE THEM !!! PM }
  gdb_command('set width 0xffffffff');
  gdb_command('set height 0xffffffff');
{ other standard commands used for fpc debugging }
  gdb_command('set print demangle off');
  gdb_command('set gnutarget auto');
  gdb_command('set language auto');
  gdb_command('set print vtbl on');
  gdb_command('set print object on');
  gdb_command('set print null-stop');
end;


destructor tgdbinterface.done;
begin
  clear_frames;
  gdb_done;
  gdboutputbuf.done;
  gdberrorbuf.done;
end;


procedure tgdbinterface.gdb__init;
begin
  gdboutputbuf.reset;
  gdberrorbuf.reset;
  create_breakpoint_hook:=@CreateBreakPointHook;
end;



procedure tgdbinterface.gdb_done;
begin
  if debuggee_started then
    begin
      current_target.to_kill;
      current_target.to_close(1);
    end;
  create_breakpoint_hook:=nil;
end;


function tgdbinterface.error:boolean;
begin
  error:=got_error;
end;

function tgdbinterface.error_num:longint;
begin
  error_num:=gdb_error;
end;

var
   top_level_val : longint;

procedure tgdbinterface.gdb_command(const s:string);
var
  command          : array[0..256] of char;
  s2 : string;
  old_quit_return,
  old_error_return : jmp_buf;
begin
  inc(command_level);
  move(s[1],command,length(s));
  command[length(s)]:=#0;
  old_quit_return:=quit_return;
  old_error_return:=error_return;
  gdb_error:=0;
  got_error:=false;
  stop_breakpoint_number:=0;
  { Trap quit commands }
  s2:=s;
  while (length(s2)>0) and ((s2[1]=' ') or (s2[1]=#9)) do
    s2:=copy(s2,2,255);
  if (length(s2)>0) and
     (s2[1]='q') and
     ((length(s2)=1) or
      (s2[2]=' ') or
      ((s2[2]='u') and
      ((length(s2)=2) or
       (s2[3]=' ') or
       ((s2[3]='i') and
        ((length(s2)=3) or
         (s2[4]=' ') or
         ((s2[4]='t') and
          ((length(s2)=4) or
           (s2[5]=' ')
     ))))))) then
    begin
      if not AllowQuit then
        exit;
    end;
{$ifdef DebugCommand}
  Debug('start of handle_gdb_command ('+s+')');
{$endif}
  top_level_val:=setjmp(error_return);
  if top_level_val=0 then
   begin
     quit_return:=error_return;
     execute_command(@command,0);
{$ifdef go32v2}
     reload_fs;
{$endif go32v2}
   end
  else
{$ifdef Debug}
    Debug('error longjmp in handle_gdb_command ('+s+')');
{$endif}
   ;
{$ifdef DebugCommand}
  Debug('end of handle_gdb_command ('+s+')');
{$endif}
  quit_return:=old_quit_return;
  error_return:=old_error_return;
  dec(command_level);
end;


procedure tgdbinterface.resize_frames;
var
  i : longint;
  new_frames : ppframeentry;
begin
  if (frame_count>=frame_size) then
   begin
     getmem(new_frames,sizeof(pointer)*(frame_count+1));
     for i:=0 to frame_size-1 do
       new_frames[i]:=frames[i];
     if assigned(frames) then
       freemem(frames,sizeof(pointer)*frame_size);
     frames:=new_frames;
     frame_size:=frame_count+1;
     for i:=frame_count to frame_size-1 do
      frames[i]:=new(pframeentry,init);
  end;
end;


function tgdbinterface.add_frameentry:pframeentry;
begin
  resize_frames;
  add_frameentry:=frames[frame_count];
  inc(frame_count);
end;

function tgdbinterface.get_frameentry(level : longint) : pframeentry;
begin
  { only climb values one by one PM }
  if level>=frame_count then
    resize_frames;
  get_frameentry:=frames[level];
  frames[level]^.clear;
  if level>=frame_count then
    inc(frame_count);
end;


procedure tgdbinterface.clear_frames;
var
  i : longint;
begin
  for i:=0 to frame_size-1 do
   dispose(frames[i],done);
  freemem(frames,sizeof(pointer)*Frame_size);
  frame_count:=0;
  frame_size:=0;
end;


{*****************************************************************************
                      Highlevel tgdbinterface
*****************************************************************************}

procedure tgdbinterface.GetAddrSyminfo(addr:longint;var si:tsyminfo);
var
  sym : symtab_and_line;
  symbol : psymbol;
begin
  sym:=find_pc_line(addr,1);
  fillchar(si,sizeof(tsyminfo),0);
  si.address:=addr;
  si.offset:=addr-sym.pc;
  if assigned(sym.symtab) then
   si.fname:=sym.symtab^.filename
  else
    si.fname:=nil;
  si.line:=sym.line;
  symbol:=find_pc_function(addr);
  si.funcname:=symbol^.ginfo._name;
end;


{$ifdef kl}
char *SourceForMain(int *line)
  struct symbol *sym;
  struct symtab *symtab;
  *line = 0;
  sym = lookup_symbol(_GetMainFunction(), NULL, VAR_NAMESPACE, NULL, &symtab);
  if (!sym)
    struct minimal_symbol *msymbol =
      lookup_minimal_symbol (_GetMainFunction(), NULL, NULL);
    if (msymbol)
      *line = SYMBOL_VALUE_ADDRESS(msymbol);
    return NULL;
  if (!symtab || !symtab->filename)
    *line = BLOCK_START(SYMBOL_BLOCK_VALUE(sym));
    return NULL;
  if (symtab->linetable)
    int i;
    for (i=0;i<symtab->linetable->nitems;i++)
      if (symtab->linetable->item[i].pc
          == BLOCK_START(SYMBOL_BLOCK_VALUE(sym)))
        *line = symtab->linetable->item[i].line;
        break;
  else
    *line = 0;
  return symtab->filename;
{$endif}


procedure tgdbinterface.SelectSourceLine(fn:pchar;line:longint);
begin
  if assigned(fn) then
   DoSelectSourceLine(StrPas(fn),line);
end;


procedure tgdbinterface.StartSession;
begin
  DoStartSession;
end;


procedure tgdbinterface.BreakSession;
begin
  DoBreakSession;
end;


procedure tgdbinterface.EndSession(code:longint);
begin
  Debuggee_started:=false;
{$ifdef Go32v2}
  inferior_pid:=0;
{$endif}
  DoEndSession(code);
end;


procedure tgdbinterface.DebuggerScreen;
begin
{$ifdef Debug}
  Debug('|DebuggerScreen|');
{$endif}
  if user_screen_shown then
   DoDebuggerScreen;
  user_screen_shown:=false;
end;


procedure tgdbinterface.UserScreen;
begin
{$ifdef Debug}
  Debug('|UserScreen|');
{$endif}
  if switch_to_user then
   begin
     if (not user_screen_shown) then
      DoUserScreen;
     user_screen_shown:=true;
   end;
end;



{---------------------------------------
          Default Hooks
---------------------------------------}

procedure tgdbinterface.DoSelectSourceLine(const fn:string;line:longint);
{$ifdef Debug}
var
  s : string;
{$endif}
begin
{$ifdef Debug}
  Str(line,S);
  Debug('|SelectSource '+fn+':'+s+'|');
{$endif}
end;

procedure tgdbinterface.DoStartSession;
begin
end;

procedure tgdbinterface.DoBreakSession;
begin
end;

procedure tgdbinterface.DoEndSession(code:longint);
begin
end;

procedure tgdbinterface.DoDebuggerScreen;
begin
end;

procedure tgdbinterface.DoUserScreen;
begin
end;

function  tgdbinterface.AllowQuit : boolean;
begin
  AllowQuit:=true;
end;

var
  version : pchar;cvar;

function  GDBVersion : string;
begin
  GDBVersion:='GDB '+StrPas(version);
end;


const next_exit : pointer = nil;
procedure DoneLibGDB;
begin
  exitproc:=next_exit;
{$ifndef GDB_V416}
  if assigned(gdb_stdout) then
    dispose(gdb_stdout);
  gdb_stdout:=nil;
  if assigned(gdb_stderr) then
    dispose(gdb_stderr);
  gdb_stderr:=nil;
{$endif not GDB_V416}
end;

{$ifndef GDB_V416}
{$ifndef go32v2}
{$ifndef win32}
var
   stdout : p_c_file;cvar;external;
   stderr : p_c_file;cvar;external;
{$endif win32}
{$else go32v2}
{ the type is not really important
  for external cvars PM
  but the main problem is that stdout and stderr
  and defined as macros under DJGPP !! }
var
   __dj_stdout : c_file;cvar;external;
   __dj_stderr : c_file;cvar;external;
{$endif go32v2}
{$endif not GDB_V416}

procedure InitLibGDB;
{$ifdef supportexceptions}
var
  OldSigInt : SignalHandler;
{$endif supportexceptions}
begin
{$ifdef supportexceptions}
{$ifdef go32v2}
  OldSigInt:=Signal(SIGINT,SignalHandler(@SIG_DFL));
{$else}
  OldSigInt:=Signal(SIGINT,SignalHandler(SIG_DFL));
{$endif}
{$endif supportexceptions}

{$ifndef GDB_V416}
  new(gdb_stdout);

  gdb_stdout^.ts_streamtype := afile;
{$ifndef go32v2}
{$ifdef win32}
 gdb_stdout^.ts_filestream := _impure_ptr^.stdout;
{$else not win32 }
 gdb_stdout^.ts_filestream := stdout;{p_c_file(textrec(output).handle); was wrong PM }
{$endif not win32 }
{$else go32v2}
  gdb_stdout^.ts_filestream := @__dj_stdout;
{$endif go32v2}
  gdb_stdout^.ts_strbuf := nil;
  gdb_stdout^.ts_buflen := 0;

  new(gdb_stderr);
  gdb_stderr^.ts_streamtype := afile;
{$ifndef go32v2}
{$ifdef win32}
  gdb_stderr^.ts_filestream := _impure_ptr^.stderr;
{$else not win32 }
  gdb_stderr^.ts_filestream := stderr;
{$endif not win32 }
{$else go32v2}
  gdb_stderr^.ts_filestream := @__dj_stderr;
{$endif go32v2}
  gdb_stderr^.ts_strbuf := nil;
  gdb_stderr^.ts_buflen := 0;
{$endif not GDB_V416}

  next_exit:=exitproc;
  exitproc:=@DoneLibGDB;
  gdb_init;
{$ifdef supportexceptions}
  Signal(SIGINT,OldSigInt);
{$endif supportexceptions}
  if setjmp(error_return)=0 then
    begin
       quit_return:=error_return;
       exit;
    end
  else
    begin
{$ifdef Debug}
       Debug('|LongJump to Init|');
{$endif}
{$ifdef go32v2}
       RunError(99);
{$endif def go32v2}
    end;
  WatchDog:=0;
end;


begin
  InitLibGDB;
end.
{
  $Log$
  Revision 1.1  1999-11-24 23:36:32  peter
    * moved to packages dir

  Revision 1.16  1999/11/09 22:58:08  pierre
   + symbol structure for function name

  Revision 1.15  1999/11/03 09:35:06  peter
    * linux updates

  Revision 1.14  1999/10/08 15:22:53  pierre
    * library order fixes
    + GDB 4.18 default now

  Revision 1.13  1999/10/04 21:26:05  pierre
   * Conditional stuff clarified

  Revision 1.12  1999/09/28 23:42:06  pierre
   + win32 support changes

  Revision 1.11  1999/09/07 09:17:52  pierre
    * frames better recorded
    * some v4.18 specific suff changed

  Revision 1.10  1999/08/31 16:16:14  pierre
   * setting height and width to unlimited was wrong

  Revision 1.9  1999/08/24 21:29:29  pierre
   + reload_fs after C code calling

  Revision 1.8  1999/08/23 09:17:22  pierre
   + Errors to gdberrorbuf

  Revision 1.7  1999/07/12 14:52:57  peter
    * ifdef 418 added

  Revision 1.6  1999/07/12 13:08:18  pierre
    + added GDBVersion function
    * tries to intercept quit command from GDB Window
    + AllowQuit method

  Revision 1.5  1999/07/11 00:16:29  pierre
   + stuff for v4.18 for DJGPP

  Revision 1.4  1999/07/07 13:12:59  peter
    * @sig_fdl for go32v2

  Revision 1.3  1999/07/05 13:05:49  michael
  + Fixed default handler

  Revision 1.2  1999/06/29 12:18:34  pierre
   * new procvar syntax fix

  Revision 1.1  1999/05/22 13:43:00  peter
    * moved

  Revision 1.16  1999/02/11 13:03:26  pierre
      Problem with last commit
    + added virtuals CommandBegin and CommandEnd
    + added command_level for TGDBInterface

  Revision 1.15  1999/02/10 09:00:41  pierre
     * duplicate call_reset removed
     * frames allocation and freeing corrected
     + GetError and GetOutput pchar function added
     + stop_breakpoint_number to know why the program stopped
       (used for watches)

  Revision 1.14  1999/02/08 17:35:08  pierre
    + added Run made TraceStep TraceNext Continue virtual

  Revision 1.13  1999/02/08 13:59:59  pierre
    - removed second debugger_started in TGDBController
    + StartTrace and Reset made virtual to be able to
      change CmResetDebugger state in IDE

  Revision 1.12  1999/02/08 11:37:11  pierre
   + added procargs var and SetArgs method

  Revision 1.11  1999/02/05 17:17:45  pierre
   * invalid_line renamed invalid_breakpoint_line

  Revision 1.10  1999/02/05 08:35:38  pierre
   * removed libgdb for cond USE_GDB_OBJS

  Revision 1.9  1999/02/04 16:33:35  pierre
   + gdb_file and use_gdb_file added for debug writing

  Revision 1.8  1999/02/04 14:35:00  pierre
    * small go32v2 fixes

  Revision 1.7  1999/02/03 15:57:38  pierre
   * typo error

  Revision 1.6  1999/02/03 15:03:07  pierre
   + added error_num function

  Revision 1.5  1999/02/03 15:01:00  pierre
   * a symtab_and_line record changes from v4.16 to v4.17

  Revision 1.4  1999/01/22 18:05:41  pierre
   * change dir sep from  to / for dos

  Revision 1.3  1999/01/22 10:23:50  peter
    * small update to get it working with the IDE

  Revision 1.2  1999/01/18 11:00:34  pierre
   * frames was not initialized

  Revision 1.1  1998/10/07 15:57:38  peter
    * initial version

  Revision 1.1  1998/10/07 15:48:20  peter
    * initial version

}
