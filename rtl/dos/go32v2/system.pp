{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1993,97 by the Free Pascal development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{ no stack check in system }
{$S-}
unit system;

{$I os.inc}

interface

{ include system-independent routine headers }

{$I systemh.inc}

{ include heap support headers }

{$I heaph.inc}

const
{ Default filehandles }
  UnusedHandle    = -1;
  StdInputHandle  = 0;
  StdOutputHandle = 1;
  StdErrorHandle  = 2;

{ Default memory segments (Tp7 compatibility) }
  seg0040 = $0040;
  segA000 = $A000;
  segB000 = $B000;
  segB800 = $B800;

var
{ Mem[] support }
  mem  : array[0..$7fffffff] of byte absolute $0;
  memw : array[0..$7fffffff] of word absolute $0;
  meml : array[0..$7fffffff] of longint absolute $0;
{ C-compatible arguments and environment }
  argc  : longint;
  argv  : ppchar;
  envp  : ppchar;
  dos_argv0 : pchar;

{$ifndef RTLLITE}
{ System info }
  LFNSupport : boolean;
{$endif RTLLITE}

type
{ Dos Extender info }
  p_stub_info = ^t_stub_info;
  t_stub_info = packed record
       magic         : array[0..15] of char;
       size          : longint;
       minstack      : longint;
       memory_handle : longint;
       initial_size  : longint;
       minkeep       : word;
       ds_selector   : word;
       ds_segment    : word;
       psp_selector  : word;
       cs_selector   : word;
       env_size      : word;
       basename      : array[0..7] of char;
       argv0         : array [0..15] of char;
       dpmi_server   : array [0..15] of char;
  end;

  p_go32_info_block = ^t_go32_info_block;
  t_go32_info_block = packed record
       size_of_this_structure_in_bytes    : longint; {offset 0}
       linear_address_of_primary_screen   : longint; {offset 4}
       linear_address_of_secondary_screen : longint; {offset 8}
       linear_address_of_transfer_buffer  : longint; {offset 12}
       size_of_transfer_buffer            : longint; {offset 16}
       pid                                : longint; {offset 20}
       master_interrupt_controller_base   : byte; {offset 24}
       slave_interrupt_controller_base    : byte; {offset 25}
       selector_for_linear_memory         : word; {offset 26}
       linear_address_of_stub_info_structure : longint; {offset 28}
       linear_address_of_original_psp     : longint; {offset 32}
       run_mode                           : word; {offset 36}
       run_mode_info                      : word; {offset 38}
  end;

var
  stub_info       : p_stub_info;
  go32_info_block : t_go32_info_block;


{
  necessary for objects.pas, should be removed (at least from the interface
  to the implementation)
}
  type
    trealregs=record
      realedi,realesi,realebp,realres,
      realebx,realedx,realecx,realeax : longint;
      realflags,
      reales,realds,realfs,realgs,
      realip,realcs,realsp,realss  : word;
    end;
  function  do_write(h,addr,len : longint) : longint;
  function  do_read(h,addr,len : longint) : longint;
  procedure syscopyfromdos(addr : longint; len : longint);
  procedure syscopytodos(addr : longint; len : longint);
  procedure sysrealintr(intnr : word;var regs : trealregs);
  function  tb : longint;

implementation

{ include system independent routines }

{$I system.inc}

const
  carryflag = 1;

type
  tseginfo=packed record
    offset  : pointer;
    segment : word;
  end;

var
  doscmd    : string[128];  { Dos commandline copied from PSP, max is 128 chars }
  old_int00,
  old_int75 : tseginfo;


{$ASMMODE DIRECT}

{*****************************************************************************
                              Go32 Helpers
*****************************************************************************}

function far_strlen(selector : word;linear_address : longint) : longint;
begin
asm
        movl linear_address,%edx
        movl %edx,%ecx
        movw selector,%gs
.Larg19:
        movb %gs:(%edx),%al
        testb %al,%al
        je .Larg20
        incl %edx
        jmp .Larg19
.Larg20:
        movl %edx,%eax
        subl %ecx,%eax
        movl %eax,__RESULT
end;
end;

{$ASMMODE ATT}


function tb : longint;
begin
  tb:=go32_info_block.linear_address_of_transfer_buffer;
end;


function tb_segment : longint;
begin
  tb_segment:=go32_info_block.linear_address_of_transfer_buffer shr 4;
end;


function tb_offset : longint;
begin
  tb_offset:=go32_info_block.linear_address_of_transfer_buffer and $f;
end;


function tb_size : longint;
begin
  tb_size:=go32_info_block.size_of_transfer_buffer;
end;


function dos_selector : word;
begin
  dos_selector:=go32_info_block.selector_for_linear_memory;
end;


function get_ds : word;assembler;
asm
        movw    %ds,%ax
end;


function get_cs : word;assembler;
asm
        movw    %cs,%ax
end;


procedure sysseg_move(sseg : word;source : longint;dseg : word;dest : longint;count : longint);
begin
   if count=0 then
     exit;
   if (sseg<>dseg) or ((sseg=dseg) and (source>dest)) then
     asm
        pushw %es
        pushw %ds
        cld
        movl count,%ecx
        movl source,%esi
        movl dest,%edi
        movw dseg,%ax
        movw %ax,%es
        movw sseg,%ax
        movw %ax,%ds
        movl %ecx,%eax
        shrl $2,%ecx
        rep
        movsl
        movl %eax,%ecx
        andl $3,%ecx
        rep
        movsb
        popw %ds
        popw %es
     end ['ESI','EDI','ECX','EAX']
   else if (source<dest) then
     { copy backward for overlapping }
     asm
        pushw %es
        pushw %ds
        std
        movl count,%ecx
        movl source,%esi
        movl dest,%edi
        movw dseg,%ax
        movw %ax,%es
        movw sseg,%ax
        movw %ax,%ds
        addl %ecx,%esi
        addl %ecx,%edi
        movl %ecx,%eax
        andl $3,%ecx
        orl %ecx,%ecx
        jz .LSEG_MOVE1

        { calculate esi and edi}
        decl %esi
        decl %edi
        rep
        movsb
        incl %esi
        incl %edi
     .LSEG_MOVE1:
        subl $4,%esi
        subl $4,%edi
        movl %eax,%ecx
        shrl $2,%ecx
        rep
        movsl
        cld
        popw %ds
        popw %es
     end ['ESI','EDI','ECX'];
end;


function atohex(s : pchar) : longint;
var
  rv : longint;
  v  : byte;
begin
  rv:=0;
  while (s^ <>#0) do
   begin
     v:=byte(s^)-byte('0');
     if (v > 9) then
       dec(v,7);
     v:=v and 15; { in case it's lower case }
     rv:=(rv shl 4) or v;
     inc(longint(s));
   end;
  atohex:=rv;
end;


procedure setup_arguments;
type  arrayword = array [0..0] of word;
var psp : word;
    i,j : byte;
    quote : char;
    proxy_s : string[7];
    tempargv : ppchar;
    al,proxy_argc,proxy_seg,proxy_ofs,lin : longint;
    largs : array[0..127] of pchar;
    rm_argv : ^arrayword;
begin
for i := 1 to 127  do
   largs[i] := nil;
psp:=stub_info^.psp_selector;
largs[0]:=dos_argv0;
argc := 1;
sysseg_move(psp, 128, get_ds, longint(@doscmd), 128);
{$IfDef SYSTEMDEBUG}
Writeln('Dos command line is #',doscmd,'# size = ',length(doscmd));
{$EndIf SYSTEMDEBUG}
j := 1;
quote := #0;
for i:=1 to length(doscmd) do
  Begin
  if doscmd[i] = quote then
    begin
    quote := #0;
    doscmd[i] := #0;
    largs[argc]:=@doscmd[j];
    inc(argc);
    j := i+1;
    end else
  if (quote = #0) and ((doscmd[i] = '''') or (doscmd[i]='"')) then
    begin
    quote := doscmd[i];
    j := i + 1;
    end else
  if (quote = #0) and ((doscmd[i] = ' ')
    or (doscmd[i] = #9) or (doscmd[i] = #10) or
    (doscmd[i] = #12) or (doscmd[i] = #9)) then
    begin
    doscmd[i]:=#0;
    if j<i then
      begin
      largs[argc]:=@doscmd[j];
      inc(argc);
      j := i+1;
      end else inc(j);
    end else
  if (i = length(doscmd)) then
    begin
    doscmd[i+1]:=#0;
    largs[argc]:=@doscmd[j];
    inc(argc);
    end;
  end;

if (argc > 1) and (far_strlen(get_ds,longint(largs[1])) = 6)  then
  begin
  move(largs[1]^,proxy_s[1],6);
  proxy_s[0] := #6;
  if (proxy_s = '!proxy') then
    begin
{$IfDef SYSTEMDEBUG}
    Writeln('proxy command line ');
{$EndIf SYSTEMDEBUG}
    proxy_argc := atohex(largs[2]);
    proxy_seg  := atohex(largs[3]);
    proxy_ofs := atohex(largs[4]);
    getmem(rm_argv,proxy_argc*sizeof(word));
    sysseg_move(dos_selector,proxy_seg*16+proxy_ofs, get_ds,longint(rm_argv),proxy_argc*sizeof(word));
    for i:=0 to proxy_argc - 1 do
      begin
      lin := proxy_seg*16 + rm_argv^[i];
      al :=far_strlen(dos_selector, lin);
      getmem(largs[i],al+1);
      sysseg_move(dos_selector, lin, get_ds,longint(largs[i]), al+1);
{$IfDef SYSTEMDEBUG}
      Writeln('arg ',i,' #',largs[i],'#');
{$EndIf SYSTEMDEBUG}
      end;
    argc := proxy_argc;
    end;
  end;
getmem(argv,argc shl 2);
for i := 0 to argc-1  do
   argv[i] := largs[i];
  tempargv:=argv;
{$ASMMODE DIRECT}
  asm
     movl tempargv,%eax
     movl %eax,_args
  end;
{$ASMMODE ATT}
end;


function strcopy(dest,source : pchar) : pchar;
begin
  asm
        cld
        movl 12(%ebp),%edi
        movl $0xffffffff,%ecx
        xorb %al,%al
        repne
        scasb
        not %ecx
        movl 8(%ebp),%edi
        movl 12(%ebp),%esi
        movl %ecx,%eax
        shrl $2,%ecx
        rep
        movsl
        movl %eax,%ecx
        andl $3,%ecx
        rep
        movsb
        movl 8(%ebp),%eax
        leave
        ret $8
  end;
end;


procedure setup_environment;
var env_selector : word;
    env_count : longint;
    dos_env,cp : pchar;
    stubaddr : p_stub_info;
begin
{$ASMMODE DIRECT}
   asm
   movl __stubinfo,%eax
   movl %eax,stubaddr
   end;
{$ASMMODE ATT}
   stub_info:=stubaddr;
   getmem(dos_env,stub_info^.env_size);
   env_count:=0;
   sysseg_move(stub_info^.psp_selector,$2c, get_ds, longint(@env_selector), 2);
   sysseg_move(env_selector, 0, get_ds, longint(dos_env), stub_info^.env_size);
  cp:=dos_env;
  while cp ^ <> #0 do
    begin
    inc(env_count);
    while (cp^ <> #0) do inc(longint(cp)); { skip to NUL }
    inc(longint(cp)); { skip to next character }
    end;
  getmem(envp,(env_count+1) * sizeof(pchar));
  if (envp = nil) then exit;
  cp:=dos_env;
  env_count:=0;
  while cp^ <> #0 do
   begin
     getmem(envp[env_count],strlen(cp)+1);
     strcopy(envp[env_count], cp);
{$IfDef SYSTEMDEBUG}
     Writeln('env ',env_count,' = "',envp[env_count],'"');
{$EndIf SYSTEMDEBUG}
     inc(env_count);
     while (cp^ <> #0) do
      inc(longint(cp)); { skip to NUL }
     inc(longint(cp)); { skip to next character }
   end;
  envp[env_count]:=nil;
  longint(cp):=longint(cp)+3;
  getmem(dos_argv0,strlen(cp)+1);
  if (dos_argv0 = nil) then halt;
  strcopy(dos_argv0, cp);
  { update ___dos_argv0 also }
{$ASMMODE DIRECT}
  asm
     movl U_SYSTEM_DOS_ARGV0,%eax
     movl %eax,___dos_argv0
  end;
{$ASMMODE ATT}
end;


procedure syscopytodos(addr : longint; len : longint);
begin
   if len > tb_size then
     HandleError(217);
   sysseg_move(get_ds,addr,dos_selector,tb,len);
end;


procedure syscopyfromdos(addr : longint; len : longint);
begin
   if len > tb_size then
     HandleError(217);
   sysseg_move(dos_selector,tb,get_ds,addr,len);
end;


procedure sysrealintr(intnr : word;var regs : trealregs);
begin
   regs.realsp:=0;
   regs.realss:=0;
   asm
      movw  intnr,%bx
      xorl  %ecx,%ecx
      movl  regs,%edi
      movw  $0x300,%ax
      int   $0x31
   end;
end;


procedure set_pm_interrupt(vector : byte;const intaddr : tseginfo);
begin
  asm
        movl intaddr,%eax
        movl (%eax),%edx
        movw 4(%eax),%cx
        movl $0x205,%eax
        movb vector,%bl
        int $0x31
  end;
end;


procedure get_pm_interrupt(vector : byte;var intaddr : tseginfo);
begin
  asm
        movb    vector,%bl
        movl    $0x204,%eax
        int     $0x31
        movl    intaddr,%eax
        movl    %edx,(%eax)
        movw    %cx,4(%eax)
  end;
end;


{*****************************************************************************
                              ParamStr/Randomize
*****************************************************************************}

{$ASMMODE DIRECT}
procedure halt(errnum : byte);
begin
  do_exit;
  set_pm_interrupt($00,old_int00);
  set_pm_interrupt($75,old_int75);
  asm
        movzbw  errnum,%ax
        pushw   %ax
        call    ___exit         {frees all dpmi memory !!}
  end;
end;


procedure new_int00;
begin
  HandleError(200);
end;


procedure new_int75;
begin
  asm
        xorl    %eax,%eax
        outb    %al,$0x0f0
        movb    $0x20,%al
        outb    %al,$0x0a0
        outb    %al,$0x020
  end;
  HandleError(200);
end;


procedure int_stackcheck(stack_size:longint);[public,alias: {$ifdef FPCNAMES}'FPC_'+{$endif}'STACKCHECK'];
{
  called when trying to get local stack if the compiler directive $S
  is set this function must preserve esi !!!! because esi is set by
  the calling proc for methods it must preserve all registers !!

  With a 2048 byte safe area used to write to StdIo without crossing
  the stack boundary
}
begin
  asm
        pushl   %eax
        pushl   %ebx
        movl    stack_size,%ebx
        addl    $2048,%ebx
        movl    %esp,%eax
        subl    %ebx,%eax
{$ifdef SYSTEMDEBUG}
        movl    U_SYSTEM_LOWESTSTACK,%ebx
        cmpl    %eax,%ebx
        jb      .L_is_not_lowest
        movl    %eax,U_SYSTEM_LOWESTSTACK
.L_is_not_lowest:
{$endif SYSTEMDEBUG}
        movl    __stkbottom,%ebx
        cmpl    %eax,%ebx
        jae     .L__short_on_stack
        popl    %ebx
        popl    %eax
        leave
        ret     $4
.L__short_on_stack:
        { can be usefull for error recovery !! }
        popl    %ebx
        popl    %eax
  end['EAX','EBX'];
  HandleError(202);
end;
{$ASMMODE ATT}



function paramcount : longint;
begin
  paramcount := argc - 1;
end;


function paramstr(l : longint) : string;
begin
  if (l>=0) and (l+1<=argc) then
   paramstr:=strpas(argv[l])
  else
   paramstr:='';
end;


procedure randomize;
var
  hl   : longint;
  regs : trealregs;
begin
  regs.realeax:=$2c00;
  sysrealintr($21,regs);
  hl:=regs.realedx and $ffff;
  randseed:=hl*$10000+ (regs.realecx and $ffff);
end;

{*****************************************************************************
                              Heap Management
*****************************************************************************}

{$ASMMODE DIRECT}

function getheapstart:pointer;assembler;
asm
        leal    HEAP,%eax
end ['EAX'];


function getheapsize:longint;assembler;
asm
        movl    HEAPSIZE,%eax
end ['EAX'];


function Sbrk(size : longint):longint;assembler;
asm
        movl    size,%eax
        pushl   %eax
        call    ___sbrk
        addl    $4,%esp
end;

{$ASMMODE ATT}

{ include standard heap management }
{$I heap.inc}


{****************************************************************************
                        Low level File Routines
 ****************************************************************************}

procedure AllowSlash(p:pchar);
var
  i : longint;
begin
{ allow slash as backslash }
  for i:=0 to strlen(p) do
   if p[i]='/' then p[i]:='\';
end;

{$ifdef SYSTEMDEBUG}

   { Keep Track of open files }
   const
      max_files = 50;
   var
      opennames : array [0..max_files-1] of pchar;
      openfiles : array [0..max_files-1] of boolean;

{$endif SYSTEMDEBUG}

procedure do_close(handle : longint);
var
  regs : trealregs;
begin
  regs.realebx:=handle;
{$ifdef SYSTEMDEBUG}
  if handle<max_files then
    openfiles[handle]:=false;
{$endif SYSTEMDEBUG}
  regs.realeax:=$3e00;
  sysrealintr($21,regs);
end;


procedure do_erase(p : pchar);
var
  regs : trealregs;
begin
  AllowSlash(p);
  syscopytodos(longint(p),strlen(p)+1);
  regs.realedx:=tb_offset;
  regs.realds:=tb_segment;
{$ifndef RTLLITE}
  if LFNSupport then
   regs.realeax:=$7141
  else
{$endif RTLLITE}
   regs.realeax:=$4100;
  regs.realesi:=0;
  regs.realecx:=0;
  sysrealintr($21,regs);
  if (regs.realflags and carryflag) <> 0 then
   InOutRes:=lo(regs.realeax);
end;


procedure do_rename(p1,p2 : pchar);
var
  regs : trealregs;
begin
  AllowSlash(p1);
  AllowSlash(p2);
  if strlen(p1)+strlen(p2)+3>tb_size then
   HandleError(217);
  sysseg_move(get_ds,longint(p2),dos_selector,tb,strlen(p2)+1);
  sysseg_move(get_ds,longint(p1),dos_selector,tb+strlen(p2)+2,strlen(p1)+1);
  regs.realedi:=tb_offset;
  regs.realedx:=tb_offset + strlen(p2)+2;
  regs.realds:=tb_segment;
  regs.reales:=tb_segment;
{$ifndef RTLLITE}
  if LFNSupport then
   regs.realeax:=$7156
  else
{$endif RTLLITE}
   regs.realeax:=$5600;
  regs.realecx:=$ff;            { attribute problem here ! }
  sysrealintr($21,regs);
  if (regs.realflags and carryflag) <> 0 then
   InOutRes:=lo(regs.realeax);
end;


function do_write(h,addr,len : longint) : longint;
var
  regs      : trealregs;
  size,
  writesize : longint;
begin
  writesize:=0;
  while len > 0 do
   begin
     if len>tb_size then
      size:=tb_size
     else
      size:=len;
     syscopytodos(addr+writesize,size);
     regs.realecx:=size;
     regs.realedx:=tb_offset;
     regs.realds:=tb_segment;
     regs.realebx:=h;
     regs.realeax:=$4000;
     sysrealintr($21,regs);
     if (regs.realflags and carryflag) <> 0 then
      begin
        InOutRes:=lo(regs.realeax);
        exit(writesize);
      end;
     len:=len-size;
     writesize:=writesize+size;
   end;
  Do_Write:=WriteSize
end;


function do_read(h,addr,len : longint) : longint;
var
  regs     : trealregs;
  size,
  readsize : longint;
begin
  readsize:=0;
  while len > 0 do
   begin
     if len>tb_size then
      size:=tb_size
     else
      size:=len;
     regs.realecx:=size;
     regs.realedx:=tb_offset;
     regs.realds:=tb_segment;
     regs.realebx:=h;
     regs.realeax:=$3f00;
     sysrealintr($21,regs);
     if (regs.realflags and carryflag) <> 0 then
      begin
        InOutRes:=lo(regs.realeax);
        do_read:=0;
        exit;
      end
     else
      if regs.realeax<size then
       begin
         syscopyfromdos(addr+readsize,regs.realeax);
         do_read:=readsize+regs.realeax;
         exit;
       end;
     syscopyfromdos(addr+readsize,regs.realeax);
     readsize:=readsize+regs.realeax;
     len:=len-regs.realeax;
   end;
  do_read:=readsize;
end;


function do_filepos(handle : longint) : longint;
var
  regs : trealregs;
begin
  regs.realebx:=handle;
  regs.realecx:=0;
  regs.realedx:=0;
  regs.realeax:=$4201;
  sysrealintr($21,regs);
  if (regs.realflags and carryflag) <> 0 then
   Begin
     InOutRes:=lo(regs.realeax);
     do_filepos:=0;
   end
  else
   do_filepos:=lo(regs.realedx) shl 16+lo(regs.realeax);
end;


procedure do_seek(handle,pos : longint);
var
  regs : trealregs;
begin
  regs.realebx:=handle;
  regs.realecx:=pos shr 16;
  regs.realedx:=pos and $ffff;
  regs.realeax:=$4200;
  sysrealintr($21,regs);
  if (regs.realflags and carryflag) <> 0 then
   InOutRes:=lo(regs.realeax);
end;



function do_seekend(handle:longint):longint;
var
  regs : trealregs;
begin
  regs.realebx:=handle;
  regs.realecx:=0;
  regs.realedx:=0;
  regs.realeax:=$4202;
  sysrealintr($21,regs);
  if (regs.realflags and carryflag) <> 0 then
   Begin
     InOutRes:=lo(regs.realeax);
     do_seekend:=0;
   end
  else
   do_seekend:=lo(regs.realedx) shl 16+lo(regs.realeax);
end;


function do_filesize(handle : longint) : longint;
var
  aktfilepos : longint;
begin
  aktfilepos:=do_filepos(handle);
  do_filesize:=do_seekend(handle);
  do_seek(handle,aktfilepos);
end;


{ truncate at a given position }
procedure do_truncate (handle,pos:longint);
var
  regs : trealregs;
begin
  do_seek(handle,pos);
  regs.realecx:=0;
  regs.realedx:=tb_offset;
  regs.realds:=tb_segment;
  regs.realebx:=handle;
  regs.realeax:=$4000;
  sysrealintr($21,regs);
  if (regs.realflags and carryflag) <> 0 then
   InOutRes:=lo(regs.realeax);
end;


procedure do_open(var f;p:pchar;flags:longint);
{
  filerec and textrec have both handle and mode as the first items so
  they could use the same routine for opening/creating.
  when (flags and $10)   the file will be append
  when (flags and $100)  the file will be truncate/rewritten
  when (flags and $1000) there is no check for close (needed for textfiles)
}
var
  regs   : trealregs;
  action : longint;
begin
  AllowSlash(p);
{ close first if opened }
  if ((flags and $1000)=0) then
   begin
     case filerec(f).mode of
      fminput,fmoutput,fminout : Do_Close(filerec(f).handle);
      fmclosed : ;
     else
      begin
        inoutres:=102; {not assigned}
        exit;
      end;
     end;
   end;
{ reset file handle }
  filerec(f).handle:=UnusedHandle;
  action:=$1;
{ convert filemode to filerec modes }
  case (flags and 3) of
   0 : filerec(f).mode:=fminput;
   1 : filerec(f).mode:=fmoutput;
   2 : filerec(f).mode:=fminout;
  end;
  if (flags and $100)<>0 then
   begin
     filerec(f).mode:=fmoutput;
     action:=$12; {create file function}
   end;
{ empty name is special }
  if p[0]=#0 then
   begin
     case filerec(f).mode of
       fminput : filerec(f).handle:=StdInputHandle;
      fmappend,
      fmoutput : begin
                   filerec(f).handle:=StdOutputHandle;
                   filerec(f).mode:=fmoutput; {fool fmappend}
                 end;
     end;
     exit;
   end;
{ real dos call }
  syscopytodos(longint(p),strlen(p)+1);
{$ifndef RTLLITE}
  if LFNSupport then
   regs.realeax:=$716c
  else
{$endif RTLLITE}
   regs.realeax:=$6c00;
  regs.realedx:=action;
  regs.realds:=tb_segment;
  regs.realesi:=tb_offset;
  regs.realebx:=$2000+(flags and $ff);
  regs.realecx:=$20;
  sysrealintr($21,regs);
  if (regs.realflags and carryflag) <> 0 then
   begin
     InOutRes:=lo(regs.realeax);
     exit;
   end
  else
   filerec(f).handle:=regs.realeax;
{$ifdef SYSTEMDEBUG}
  if regs.realeax<max_files then
    begin
       openfiles[regs.realeax]:=true;
       getmem(opennames[regs.realeax],strlen(p)+1);
       opennames[regs.realeax]:=p;
    end;
{$endif SYSTEMDEBUG}
{ append mode }
  if (flags and $10)<>0 then
   begin
     do_seekend(filerec(f).handle);
     filerec(f).mode:=fmoutput; {fool fmappend}
   end;
end;


function do_isdevice(handle:longint):boolean;
var
  regs : trealregs;
begin
  regs.realebx:=handle;
  regs.realeax:=$4400;
  sysrealintr($21,regs);
  do_isdevice:=(regs.realedx and $80)<>0;
  if (regs.realflags and carryflag) <> 0 then
   InOutRes:=lo(regs.realeax);
end;


{*****************************************************************************
                           UnTyped File Handling
*****************************************************************************}

{$i file.inc}

{*****************************************************************************
                           Typed File Handling
*****************************************************************************}

{$i typefile.inc}

{*****************************************************************************
                           Text File Handling
*****************************************************************************}

{$DEFINE EOF_CTRLZ}

{$i text.inc}

{*****************************************************************************
                           Directory Handling
*****************************************************************************}

procedure DosDir(func:byte;const s:string);
var
  buffer : array[0..255] of char;
  regs   : trealregs;
begin
  move(s[1],buffer,length(s));
  buffer[length(s)]:=#0;
  AllowSlash(pchar(@buffer));
  syscopytodos(longint(@buffer),length(s)+1);
  regs.realedx:=tb_offset;
  regs.realds:=tb_segment;
{$ifndef RTLLITE}
  if LFNSupport then
   regs.realeax:=$7100+func
  else
{$endif RTLLITE}
   regs.realeax:=func shl 8;
  sysrealintr($21,regs);
  if (regs.realflags and carryflag) <> 0 then
   InOutRes:=lo(regs.realeax);
end;


procedure mkdir(const s : string);[IOCheck];
begin
  If InOutRes <> 0 then
   exit;
  DosDir($39,s);
end;


procedure rmdir(const s : string);[IOCheck];
begin
  If InOutRes <> 0 then
   exit;
  DosDir($3a,s);
end;


procedure chdir(const s : string);[IOCheck];
var
  regs : trealregs;
begin
  If InOutRes <> 0 then
   exit;
{ First handle Drive changes }
  if (length(s)>=2) and (s[2]=':') then
   begin
     regs.realedx:=(ord(s[1]) and (not 32))-ord('A');
     regs.realeax:=$0e00;
     sysrealintr($21,regs);
     regs.realeax:=$1900;
     sysrealintr($21,regs);
     if byte(regs.realeax)<>byte(regs.realedx) then
      begin
        Inoutres:=15;
        exit;
      end;
   end;
{ do the normal dos chdir }
  DosDir($3b,s);
end;


procedure getdir(drivenr : byte;var dir : string);
var
  temp : array[0..255] of char;
  i    : longint;
  regs : trealregs;
begin
  regs.realedx:=drivenr;
  regs.realesi:=tb_offset;
  regs.realds:=tb_segment;
{$ifndef RTLLITE}
  if LFNSupport then
   regs.realeax:=$7147
  else
{$endif RTLLITE}
   regs.realeax:=$4700;
  sysrealintr($21,regs);
  if (regs.realflags and carryflag) <> 0 then
   Begin
     InOutRes:=lo(regs.realeax);
     exit;
   end
  else
   syscopyfromdos(longint(@temp),251);
{ conversation to Pascal string including slash conversion }
  i:=0;
  while (temp[i]<>#0) do
   begin
     if temp[i]='/' then
      temp[i]:='\';
     dir[i+4]:=temp[i];
     inc(i);
   end;
  dir[2]:=':';
  dir[3]:='\';
  dir[0]:=char(i+3);
{ upcase the string }
  dir:=upcase(dir);
  if drivenr<>0 then   { Drive was supplied. We know it }
   dir[1]:=char(65+drivenr-1)
  else
   begin
   { We need to get the current drive from DOS function 19H  }
   { because the drive was the default, which can be unknown }
     regs.realeax:=$1900;
     sysrealintr($21,regs);
     i:= (regs.realeax and $ff) + ord('A');
     dir[1]:=chr(i);
   end;
end;


{*****************************************************************************
                         SystemUnit Initialization
*****************************************************************************}

{$ifndef RTLLITE}
function CheckLFN:boolean;
var
  regs     : TRealRegs;
  RootName : pchar;
begin
{ Check LFN API on drive c:\ }
  RootName:='C:\';
  syscopytodos(longint(RootName),strlen(RootName)+1);
{ Call 'Get Volume Information' ($71A0) }
  regs.realeax:=$71a0;
  regs.reales:=tb_segment;
  regs.realedi:=tb_offset;
  regs.realecx:=32;
  regs.realds:=tb_segment;
  regs.realedx:=tb_offset;
  regs.realflags:=carryflag;
  sysrealintr($21,regs);
{ If carryflag=0 and LFN API bit in ebx is set then use Long file names }
  CheckLFN:=(regs.realflags and carryflag=0) and (regs.realebx and $4000=$4000);
end;
{$endif RTLLITE}


var
  temp_int : tseginfo;
Begin
{ save old int 0 and 75 }
  get_pm_interrupt($00,old_int00);
  get_pm_interrupt($75,old_int75);
  temp_int.segment:=get_cs;
  temp_int.offset:=@new_int00;
  set_pm_interrupt($00,temp_int);
{  temp_int.offset:=@new_int75;
  set_pm_interrupt($75,temp_int); }
{ to test stack depth }
  loweststack:=maxlongint;
{ Setup heap }
  InitHeap;
{ Setup stdin, stdout and stderr }
  OpenStdIO(Input,fmInput,StdInputHandle);
  OpenStdIO(Output,fmOutput,StdOutputHandle);
  OpenStdIO(StdErr,fmOutput,StdErrorHandle);
{ Setup environment and arguments }
  Setup_Environment;
  Setup_Arguments;
{ Use LFNSupport LFN }
  LFNSupport:=CheckLFN;
{ Reset IO Error }
  InOutRes:=0;
End.
{
  $Log$
  Revision 1.20  1998-10-13 21:41:06  peter
    + int 0 for divide by zero

  Revision 1.19  1998/09/14 10:48:05  peter
    * FPC_ names
    * Heap manager is now system independent

  Revision 1.18  1998/08/28 10:48:04  peter
    * fixed chdir with drive changing
    * updated checklfn from mailinglist

  Revision 1.17  1998/08/27 10:30:51  pierre
    * go32v1 RTL did not compile (LFNsupport outside go32v2 defines !)
      I renamed tb_selector to tb_segment because
        it is a real mode segment as opposed to
        a protected mode selector
      Fixed it for go32v1 (remove the $E0000000 offset !)

  Revision 1.16  1998/08/26 10:04:03  peter
    * new lfn check from mailinglist
    * renamed win95 -> LFNSupport
    + tb_selector, tb_offset for easier access to transferbuffer

  Revision 1.15  1998/08/19 10:56:34  pierre
    + added some special code for C interface
      to avoid loading of crt1.o or dpmiexcp.o from the libc.a

  Revision 1.14  1998/08/04 14:34:38  pierre
    * small bug fix to get it compiled with bugfix version !!
      (again the asmmode problem !!!
      Peter it was really not the best idea you had !!)

  Revision 1.13  1998/07/30 13:26:22  michael
  + Added support for ErrorProc variable. All internal functions are required
    to call HandleError instead of runerror from now on.
    This is necessary for exception support.

  Revision 1.12  1998/07/13 21:19:08  florian
    * some problems with ansi string support fixed

  Revision 1.11  1998/07/07 12:33:08  carl
    * added 2k buffer for stack checking for correct io on error

  Revision 1.10  1998/07/02 12:29:20  carl
    * IOCheck for rmdir,chdir and mkdir as in TP
    NOTE: I'm pretty SURE this will not compile and link correctly with FPC
  0.99.5

  Revision 1.9  1998/07/01 15:29:57  peter
    * better readln/writeln

  Revision 1.8  1998/06/26 08:19:10  pierre
    + all debug in ifdef SYSTEMDEBUG
    + added local arrays :
      opennames names of opened files
      fileopen boolean array to know if still open
      usefull with gdb if you get problems about too
      many open files !!

  Revision 1.7  1998/06/15 15:17:08  daniel
  * RTLLITE conditional added to produce smaller RTL.

  Revision 1.6  1998/05/31 14:18:29  peter
    * force att or direct assembling
    * cleanup of some files

  Revision 1.5  1998/05/21 19:30:52  peter
    * objects compiles for linux
    + assign(pchar), assign(char), rename(pchar), rename(char)
    * fixed read_text_as_array
    + read_text_as_pchar which was not yet in the rtl

  Revision 1.4  1998/05/04 17:58:41  peter
    * fix for smartlinking with _ARGS

  Revision 1.3  1998/05/04 16:21:54  florian
    + LFNSupport flag to the interface moved
}
