{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by the Free Pascal development team.

    Heap tracer

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit heaptrc;
interface

Procedure DumpHeap;
Procedure MarkHeap;

{ define EXTRA to add more
  tests :
   - keep all memory after release and
   check by CRC value if not changed after release
   WARNING this needs extremely much memory (PM) }

type
   tFillExtraInfoProc = procedure(p : pointer);
   tdisplayextrainfoProc = procedure (var ptext : text;p : pointer);

{ Allows to add info pre memory block, see ppheap.pas of the compiler
  for example source }
procedure SetHeapExtraInfo( size : longint;fillproc : tfillextrainfoproc;displayproc : tdisplayextrainfoproc);

{ Redirection of the output to a file }
procedure SetHeapTraceOutput(const name : string);

const
  { tracing level
    splitted in two if memory is released !! }
{$ifdef EXTRA}
  tracesize = 16;
{$else EXTRA}
  tracesize = 8;
{$endif EXTRA}
  quicktrace : boolean=true;
  { calls halt() on error by default !! }
  HaltOnError : boolean = true;
  { set this to true if you suspect that memory
    is freed several times }
{$ifdef EXTRA}
  keepreleased : boolean=true;
{$else EXTRA}
  keepreleased : boolean=false;
{$endif EXTRA}
  { add a small footprint at the end of memory blocks, this
    can check for memory overwrites at the end of a block }
  add_tail : boolean = true;
  { put crc in sig
    this allows to test for writing into that part }
  usecrc : boolean = true;


implementation

type
   plongint = ^longint;

const
  { allows to add custom info in heap_mem_info, this is the size that will
    be allocated for this information }
  extra_info_size : longint = 0;
  exact_info_size : longint = 0;
  EntryMemUsed    : longint = 0;
  { function to fill this info up }
  fill_extra_info_proc : TFillExtraInfoProc = nil;
  display_extra_info_proc : TDisplayExtraInfoProc = nil;
  error_in_heap : boolean = false;
  inside_trace_getmem : boolean = false;

type
  pheap_extra_info = ^theap_extra_info;
  theap_extra_info = record
    fillproc : tfillextrainfoProc;
    displayproc : tdisplayextrainfoProc;
    data : record
           end;
  end;

  { warning the size of theap_mem_info
    must be a multiple of 8
    because otherwise you will get
    problems when releasing the usual memory part !!
    sizeof(theap_mem_info = 16+tracesize*4 so
    tracesize must be even !! PM }
  pheap_mem_info = ^theap_mem_info;
  theap_mem_info = record
    previous,
    next     : pheap_mem_info;
    size     : longint;
    sig      : longword;
{$ifdef EXTRA}
    release_sig : longword;
    prev_valid  : pheap_mem_info;
{$endif EXTRA}
    calls    : array [1..tracesize] of longint;
    exact_info_size : word;
    extra_info_size : word;
    extra_info      : pheap_extra_info;
  end;

var
  ptext : ^text;
  ownfile : text;
{$ifdef EXTRA}
  error_file : text;
  heap_valid_first,
  heap_valid_last : pheap_mem_info;
{$endif EXTRA}
  heap_mem_root : pheap_mem_info;
  getmem_cnt,
  freemem_cnt   : longint;
  getmem_size,
  freemem_size   : longint;
  getmem8_size,
  freemem8_size   : longint;


{*****************************************************************************
                                   Crc 32
*****************************************************************************}

var
  Crc32Tbl : array[0..255] of longword;

procedure MakeCRC32Tbl;
var
  crc : longword;
  i,n : byte;
begin
  for i:=0 to 255 do
   begin
     crc:=i;
     for n:=1 to 8 do
      if odd(crc) then
       crc:=(crc shr 1) xor $edb88320
      else
       crc:=crc shr 1;
     Crc32Tbl[i]:=crc;
   end;
end;


Function UpdateCrc32(InitCrc:longword;var InBuf;InLen:Longint):longword;
var
  i : longint;
  p : pchar;
begin
  p:=@InBuf;
  for i:=1 to InLen do
   begin
     InitCrc:=Crc32Tbl[byte(InitCrc) xor byte(p^)] xor (InitCrc shr 8);
     inc(p);
   end;
  UpdateCrc32:=InitCrc;
end;

Function calculate_sig(p : pheap_mem_info) : longword;
var
   crc : longword;
   pl : plongint;
begin
   crc:=longword($ffffffff);
   crc:=UpdateCrc32(crc,p^.size,sizeof(longint));
   crc:=UpdateCrc32(crc,p^.calls,tracesize*sizeof(longint));
   if p^.extra_info_size>0 then
     crc:=UpdateCrc32(crc,p^.extra_info^,p^.exact_info_size);
   if add_tail then
     begin
        { Check also 4 bytes just after allocation !! }
        pl:=pointer(p)+p^.extra_info_size+sizeof(theap_mem_info)+p^.size;
        crc:=UpdateCrc32(crc,pl^,sizeof(longint));
     end;
   calculate_sig:=crc;
end;

{$ifdef EXTRA}
Function calculate_release_sig(p : pheap_mem_info) : longint;
var
   crc : longword;
   pl : plongint;
begin
   crc:=$ffffffff;
   crc:=UpdateCrc32(crc,p^.size,sizeof(longint));
   crc:=UpdateCrc32(crc,p^.calls,tracesize*sizeof(longint));
   if p^.extra_info_size>0 then
     crc:=UpdateCrc32(crc,p^.extra_info^,p^.exact_info_size);
   { Check the whole of the whole allocation }
   pl:=pointer(p)+p^.extra_info_size+sizeof(theap_mem_info);
   crc:=UpdateCrc32(crc,pl^,p^.size);
   { Check also 4 bytes just after allocation !! }
   if add_tail then
     begin
        { Check also 4 bytes just after allocation !! }
        pl:=pointer(p)+p^.extra_info_size+sizeof(theap_mem_info)+p^.size;
        crc:=UpdateCrc32(crc,pl^,sizeof(longint));
     end;
   calculate_release_sig:=crc;
end;
{$endif EXTRA}


{*****************************************************************************
                                Helpers
*****************************************************************************}

procedure call_stack(pp : pheap_mem_info;var ptext : text);
var
  i  : longint;
begin
  writeln(ptext,'Call trace for block 0x',hexstr(longint(pointer(pp)+sizeof(theap_mem_info)),8),' size ',pp^.size);
  for i:=1 to tracesize do
   if pp^.calls[i]<>0 then
     writeln(ptext,BackTraceStrFunc(pp^.calls[i]));
  if assigned(pp^.extra_info^.displayproc) then
   pp^.extra_info^.displayproc(ptext,@pp^.extra_info^.data);
end;


procedure call_free_stack(pp : pheap_mem_info;var ptext : text);
var
  i  : longint;
begin
  writeln(ptext,'Call trace for block at 0x',hexstr(longint(pointer(pp)+sizeof(theap_mem_info)),8),' size ',pp^.size);
  for i:=1 to tracesize div 2 do
   if pp^.calls[i]<>0 then
     writeln(ptext,BackTraceStrFunc(pp^.calls[i]));
  writeln(ptext,' was released at ');
  for i:=(tracesize div 2)+1 to tracesize do
   if pp^.calls[i]<>0 then
     writeln(ptext,BackTraceStrFunc(pp^.calls[i]));
  for i:=0 to (pp^.exact_info_size div 4)-1 do
    writeln(ptext,'info ',i,'=',plongint(pointer(pp^.extra_info)+4*i)^);
end;


procedure dump_already_free(p : pheap_mem_info;var ptext : text);
begin
  Writeln(ptext,'Marked memory at 0x',HexStr(longint(pointer(p)+sizeof(theap_mem_info)),8),' released');
  call_free_stack(p,ptext);
  Writeln(ptext,'freed again at');
  dump_stack(ptext,get_caller_frame(get_frame));
end;

procedure dump_error(p : pheap_mem_info;var ptext : text);
begin
  Writeln(ptext,'Marked memory at 0x',HexStr(longint(pointer(p)+sizeof(theap_mem_info)),8),' invalid');
  Writeln(ptext,'Wrong signature $',hexstr(p^.sig,8),' instead of ',hexstr(calculate_sig(p),8));
  dump_stack(ptext,get_caller_frame(get_frame));
end;

{$ifdef EXTRA}
procedure dump_change_after(p : pheap_mem_info;var ptext : text);
 var pp : pchar;
     i : longint;
begin
  Writeln(ptext,'Marked memory at 0x',HexStr(longint(pointer(p)+sizeof(theap_mem_info)),8),' invalid');
  Writeln(ptext,'Wrong release CRC $',hexstr(p^.release_sig,8),' instead of ',hexstr(calculate_release_sig(p),8));
  Writeln(ptext,'This memory was changed after call to freemem !');
  call_free_stack(p,ptext);
  pp:=pointer(p)+sizeof(theap_mem_info);
  for i:=0 to p^.size-1 do
    if byte(pp[i])<>$F0 then
      Writeln(ptext,'offset',i,':$',hexstr(i,8),'"',pp[i],'"');
end;
{$endif EXTRA}

procedure dump_wrong_size(p : pheap_mem_info;size : longint;var ptext : text);
var
  i : longint;
begin
  Writeln(ptext,'Marked memory at 0x',HexStr(longint(pointer(p)+sizeof(theap_mem_info)),8),' invalid');
  Writeln(ptext,'Wrong size : ',p^.size,' allocated ',size,' freed');
  dump_stack(ptext,get_caller_frame(get_frame));
  for i:=0 to (p^.exact_info_size div 4)-1 do
    writeln(ptext,'info ',i,'=',plongint(p^.extra_info+4*i)^);
  call_stack(p,ptext);
end;


function is_in_getmem_list (p : pheap_mem_info) : boolean;
var
  i  : longint;
  pp : pheap_mem_info;
begin
  is_in_getmem_list:=false;
  pp:=heap_mem_root;
  i:=0;
  while pp<>nil do
   begin
     if ((pp^.sig<>$DEADBEEF) or usecrc) and
        ((pp^.sig<>calculate_sig(pp)) or not usecrc) and
        (pp^.sig <>$AAAAAAAA) then
      begin
        writeln(ptext^,'error in linked list of heap_mem_info');
        RunError(204);
      end;
     if pp=p then
      is_in_getmem_list:=true;
     pp:=pp^.previous;
     inc(i);
     if i>getmem_cnt-freemem_cnt then
      writeln(ptext^,'error in linked list of heap_mem_info');
   end;
end;


{*****************************************************************************
                               TraceGetMem
*****************************************************************************}

Function TraceGetMem(size:longint):pointer;
var
  i,bp : longint;
  pl : plongint;
  p : pointer;
  pp : pheap_mem_info;
begin
  inc(getmem_size,size);
  inc(getmem8_size,((size+7) div 8)*8);
{ Do the real GetMem, but alloc also for the info block }
  bp:=size+sizeof(theap_mem_info)+extra_info_size;
  if add_tail then
    inc(bp,sizeof(longint));
  p:=SysGetMem(bp);
  pp:=pheap_mem_info(p);
{ Create the info block }
  pp^.sig:=$DEADBEEF;
  pp^.size:=size;
  pp^.extra_info_size:=extra_info_size;
  pp^.exact_info_size:=exact_info_size;
  {
    the end of the block contains:
    <tail>   4 bytes
    <extra_info>   X bytes
  }
  if extra_info_size>0 then
   begin
     pp^.extra_info:=pointer(p)+bp-extra_info_size;
     fillchar(pp^.extra_info^,extra_info_size,0);
     pp^.extra_info^.fillproc:=fill_extra_info_proc;
     pp^.extra_info^.displayproc:=display_extra_info_proc;
     if assigned(fill_extra_info_proc) then
      begin
        inside_trace_getmem:=true;
        fill_extra_info_proc(@pp^.extra_info^.data);
        inside_trace_getmem:=false;
      end;
   end
  else
   pp^.extra_info:=nil;    
  if add_tail then
    begin
      pl:=pointer(p)+bp-extra_info_size-sizeof(longint);
      pl^:=$DEADBEEF;
    end;
  { retrieve backtrace info }
  bp:=get_caller_frame(get_frame);
  for i:=1 to tracesize do
   begin
     pheap_mem_info(p)^.calls[i]:=get_caller_addr(bp);
     bp:=get_caller_frame(bp);
   end;
  { insert in the linked list }
  if heap_mem_root<>nil then
   heap_mem_root^.next:=pheap_mem_info(p);
  pheap_mem_info(p)^.previous:=heap_mem_root;
  pheap_mem_info(p)^.next:=nil;
{$ifdef EXTRA}
  pheap_mem_info(p)^.prev_valid:=heap_valid_last;
  heap_valid_last:=pheap_mem_info(p);
  if not assigned(heap_valid_first) then
    heap_valid_first:=pheap_mem_info(p);
{$endif EXTRA}
  heap_mem_root:=p;
  { must be changed before fill_extra_info is called
    because checkpointer can be called from within
    fill_extra_info PM }
  inc(getmem_cnt);
{ update the pointer }
  if usecrc then
    pheap_mem_info(p)^.sig:=calculate_sig(pheap_mem_info(p));
  inc(p,sizeof(theap_mem_info));
  TraceGetmem:=p;
end;


{*****************************************************************************
                                TraceFreeMem
*****************************************************************************}

function TraceFreeMemSize(var p:pointer;size:longint):longint;
var
  i,bp, ppsize : longint;
  pp : pheap_mem_info;
{$ifdef EXTRA}
  pp2 : pheap_mem_info;
{$endif}
  extra_size : longint;
begin
  inc(freemem_size,size);
  inc(freemem8_size,((size+7) div 8)*8);
  dec(p,sizeof(theap_mem_info));
  pp:=pheap_mem_info(p);
  extra_size:=pp^.extra_info_size;
  ppsize:= size + sizeof(theap_mem_info)+pp^.extra_info_size;
  if add_tail then
    inc(ppsize,sizeof(longint));
  if not quicktrace and not(is_in_getmem_list(pp)) then
    RunError(204);
  if (pp^.sig=$AAAAAAAA) and not usecrc then
    begin
       error_in_heap:=true;
       dump_already_free(pp,ptext^);
       if haltonerror then halt(1);
    end
  else if ((pp^.sig<>$DEADBEEF) or usecrc) and
        ((pp^.sig<>calculate_sig(pp)) or not usecrc) then
    begin
       error_in_heap:=true;
       dump_error(pp,ptext^);
{$ifdef EXTRA}
       dump_error(pp,error_file);
{$endif EXTRA}
       { don't release anything in this case !! }
       if haltonerror then halt(1);
       exit;
    end
  else if pp^.size<>size then
    begin
       error_in_heap:=true;
       dump_wrong_size(pp,size,ptext^);
{$ifdef EXTRA}
       dump_wrong_size(pp,size,error_file);
{$endif EXTRA}
       if haltonerror then halt(1);
       { don't release anything in this case !! }
       exit;
    end;
  { now it is released !! }
  pp^.sig:=$AAAAAAAA;
  if not keepreleased then
    begin
       if pp^.next<>nil then
         pp^.next^.previous:=pp^.previous;
       if pp^.previous<>nil then
         pp^.previous^.next:=pp^.next;
       if pp=heap_mem_root then
         heap_mem_root:=heap_mem_root^.previous;
    end
  else
    begin
       bp:=get_caller_frame(get_frame);
       for i:=(tracesize div 2)+1 to tracesize do
        begin
          pp^.calls[i]:=get_caller_addr(bp);
          bp:=get_caller_frame(bp);
        end;
    end;
  inc(freemem_cnt);
  { release the normal memory at least !! }
  { this way we keep all info about all released memory !! }
  if keepreleased then
    begin
       i:=ppsize;
       inc(p,sizeof(theap_mem_info));
       fillchar(p^,size,#240); { $F0 will lead to GFP if used as pointer ! }
{$ifdef EXTRA}
       { We want to check if the memory was changed after release !! }
       pp^.release_sig:=calculate_release_sig(pp);
       if pp=heap_valid_last then
         begin
            heap_valid_last:=pp^.prev_valid;
            if pp=heap_valid_first then
              heap_valid_first:=nil;
            exit;
         end;
       pp2:=heap_valid_last;
       while assigned(pp2) do
         begin
            if pp2^.prev_valid=pp then
              begin
                 pp2^.prev_valid:=pp^.prev_valid;
                 if pp=heap_valid_first then
                   heap_valid_first:=pp2;
                 exit;
              end
            else
              pp2:=pp2^.prev_valid;
         end;
{$endif EXTRA}
       exit;
    end
  else
    i:=SysFreeMemSize(p,ppsize);
  dec(i,sizeof(theap_mem_info)+extra_size);
  if add_tail then
   dec(i,sizeof(longint));
  TraceFreeMemSize:=i;
end;


function TraceMemSize(p:pointer):Longint;
var
  l : longint;
  pp : pheap_mem_info;
begin
  dec(p,sizeof(theap_mem_info));
  pp:=pheap_mem_info(p);
  l:=SysMemSize(pp);
  dec(l,sizeof(theap_mem_info)+pp^.extra_info_size);
  if add_tail then
   dec(l,sizeof(longint));
  TraceMemSize:=l;
end;


function TraceFreeMem(var p:pointer):longint;
var
  size : longint;
  pp : pheap_mem_info;
begin
  pp:=pheap_mem_info(p-sizeof(theap_mem_info));
  size:=TraceMemSize(p);
  size:=TraceMemSize(p);
  { this can never happend normaly }
  if pp^.size>size then
   begin
     dump_wrong_size(pp,size,ptext^);
{$ifdef EXTRA}
     dump_wrong_size(pp,size,error_file);
{$endif EXTRA}
   end;
  TraceFreeMem:=TraceFreeMemSize(p,pp^.size);
end;


{*****************************************************************************
                                ReAllocMem
*****************************************************************************}

function TraceReAllocMem(var p:pointer;size:longint):Pointer;
var
  newP: pointer;
  oldsize,
  allocsize,
  i,bp : longint;
  pl : plongint;
  pp : pheap_mem_info;
  oldextrasize,
  oldexactsize : longint;
  old_fill_extra_info_proc : tfillextrainfoproc;
  old_display_extra_info_proc : tdisplayextrainfoproc;
begin
{ Free block? }
  if size=0 then
   begin
     if p<>nil then
      TraceFreeMem(p);
     TraceReallocMem:=P;
     exit;
   end;
{ Allocate a new block? }
  if p=nil then
   begin
     p:=TraceGetMem(size);
     TraceReallocMem:=P;
     exit;
   end;
{ Resize block }
  dec(p,sizeof(theap_mem_info));
  pp:=pheap_mem_info(p);
  { test block }
  if ((pp^.sig<>$DEADBEEF) or usecrc) and
     ((pp^.sig<>calculate_sig(pp)) or not usecrc) then
   begin
     error_in_heap:=true;
     dump_error(pp,ptext^);
{$ifdef EXTRA}
     dump_error(pp,error_file);
{$endif EXTRA}
     { don't release anything in this case !! }
     if haltonerror then halt(1);
     exit;
   end;
  { save info }
  oldextrasize:=pp^.extra_info_size;
  oldexactsize:=pp^.exact_info_size;
  if pp^.extra_info_size>0 then
   begin
     old_fill_extra_info_proc:=pp^.extra_info^.fillproc;
     old_display_extra_info_proc:=pp^.extra_info^.displayproc;
   end;  
  { Do the real ReAllocMem, but alloc also for the info block }
  allocsize:=size+sizeof(theap_mem_info)+pp^.extra_info_size;
  if add_tail then
   inc(allocsize,sizeof(longint));
  { Try to resize the block, if not possible we need to do a
    getmem, move data, freemem }
  if not SysTryResizeMem(p,allocsize) then
   begin
     { restore p }
     inc(p,sizeof(theap_mem_info));
     { get a new block }
     oldsize:=TraceMemSize(p);
     newP := TraceGetMem(size);
     { move the data }
     if newP <> nil then
       move(p^,newP^,oldsize);
     { release p }
     traceFreeMem(p);
     p := newP;
     traceReAllocMem := p;
     exit;
   end;
  pp:=pheap_mem_info(p);
{ adjust like a freemem and then a getmem, so you get correct
  results in the summary display }
  inc(freemem_size,pp^.size);
  inc(freemem8_size,((pp^.size+7) div 8)*8);
  inc(getmem_size,size);
  inc(getmem8_size,((size+7) div 8)*8);
{ Create the info block }
  pp^.sig:=$DEADBEEF;
  pp^.size:=size;
  pp^.extra_info_size:=oldextrasize;
  pp^.exact_info_size:=oldexactsize;
  { add the new extra_info and tail }
  if pp^.extra_info_size>0 then
   begin
     pp^.extra_info:=p+allocsize-pp^.extra_info_size;
     fillchar(pp^.extra_info^,extra_info_size,0);
     pp^.extra_info^.fillproc:=old_fill_extra_info_proc;
     pp^.extra_info^.displayproc:=old_display_extra_info_proc;
     if assigned(pp^.extra_info^.fillproc) then
      pp^.extra_info^.fillproc(@pp^.extra_info^.data);
   end
  else
   pp^.extra_info:=nil;    
  if add_tail then
    begin
      pl:=pointer(p)+allocsize-pp^.extra_info_size-sizeof(longint);
      pl^:=$DEADBEEF;
    end;
  { generate new backtrace }
  bp:=get_caller_frame(get_frame);
  for i:=1 to tracesize do
   begin
     pp^.calls[i]:=get_caller_addr(bp);
     bp:=get_caller_frame(bp);
   end;
  { regenerate signature }
  if usecrc then
    pp^.sig:=calculate_sig(pp);
{ update the pointer }
  inc(p,sizeof(theap_mem_info));
  TraceReAllocmem:=p;
end;



{*****************************************************************************
                              Check pointer
*****************************************************************************}

{$ifndef Unix}
  {$S-}
{$endif}

{$ifdef go32v2}
var
   __stklen : cardinal;external name '__stklen';
   __stkbottom : cardinal;external name '__stkbottom';
   edata : cardinal; external name 'edata';
   heap_at_init : pointer;
{$endif go32v2}

{$ifdef win32}
var
   StartUpHeapEnd : pointer;
   { I found no symbol for start of text section :(
     so we usee the _mainCRTStartup which should be
     in wprt0.ow or wdllprt0.ow PM }
   text_begin : cardinal;external name '_mainCRTStartup';
   data_end : cardinal;external name '__data_end__';
{$endif}

procedure CheckPointer(p : pointer);[public, alias : 'FPC_CHECKPOINTER'];
var
  i  : longint;
  pp : pheap_mem_info;
  get_ebp,stack_top : cardinal;
  data_end : cardinal;
label
  _exit;
begin
  asm
     pushal
  end;
  if p=nil then
    goto _exit;

  i:=0;

{$ifdef go32v2}
  if cardinal(p)<$1000 then
    runerror(216);
  asm
     movl %ebp,get_ebp
     leal edata,%eax
     movl %eax,data_end
  end;
  stack_top:=__stkbottom+__stklen;
  { allow all between start of code and end of data }
  if cardinal(p)<=data_end then
    goto _exit;
  { .bss section }
  if cardinal(p)<=cardinal(heap_at_init) then
    goto _exit;
  { stack can be above heap !! }

  if (cardinal(p)>=get_ebp) and (cardinal(p)<=stack_top) then
    goto _exit;
{$endif go32v2}

  { I don't know where the stack is in other OS !! }
{$ifdef win32}
  if (cardinal(p)>=$40000) and (p<=HeapOrg) then
    goto _exit;
  { inside stack ? }
  asm
     movl %ebp,get_ebp
  end;
  if (cardinal(p)>get_ebp) and
     (cardinal(p)<Win32StackTop) then
    goto _exit;
{$endif win32}

  if p>=heapptr then
    runerror(216);
  { first try valid list faster }

{$ifdef EXTRA}
  pp:=heap_valid_last;
  while pp<>nil do
   begin
     { inside this valid block ! }
     { we can be changing the extrainfo !! }
     if (cardinal(p)>=cardinal(pp)+sizeof(theap_mem_info){+extra_info_size}) and
        (cardinal(p)<=cardinal(pp)+sizeof(theap_mem_info)+extra_info_size+pp^.size) then
       begin
          { check allocated block }
          if ((pp^.sig=$DEADBEEF) and not usecrc) or
             ((pp^.sig=calculate_sig(pp)) and usecrc) or
          { special case of the fill_extra_info call }
             ((pp=heap_valid_last) and usecrc and (pp^.sig=$DEADBEEF)
              and inside_trace_getmem) then
            goto _exit
          else
            begin
              writeln(ptext^,'corrupted heap_mem_info');
              dump_error(pp,ptext^);
              halt(1);
            end;
       end
     else
       pp:=pp^.prev_valid;
     inc(i);
     if i>getmem_cnt-freemem_cnt then
      begin
         writeln(ptext^,'error in linked list of heap_mem_info');
         halt(1);
      end;
   end;
  i:=0;
{$endif EXTRA}
  pp:=heap_mem_root;
  while pp<>nil do
   begin
     { inside this block ! }
     if (cardinal(p)>=cardinal(pp)+sizeof(theap_mem_info)+cardinal(extra_info_size)) and
        (cardinal(p)<=cardinal(pp)+sizeof(theap_mem_info)+cardinal(extra_info_size)+cardinal(pp^.size)) then
        { allocated block }
       if ((pp^.sig=$DEADBEEF) and not usecrc) or
          ((pp^.sig=calculate_sig(pp)) and usecrc) then
          goto _exit
       else
         begin
            writeln(ptext^,'pointer $',hexstr(longint(p),8),' points into invalid memory block');
            dump_error(pp,ptext^);
            runerror(204);
         end;
     pp:=pp^.previous;
     inc(i);
     if i>getmem_cnt then
      begin
         writeln(ptext^,'error in linked list of heap_mem_info');
         halt(1);
      end;
   end;
  writeln(ptext^,'pointer $',hexstr(longint(p),8),' does not point to valid memory block');
  runerror(204);
_exit:
  asm
     popal
  end;
end;

{*****************************************************************************
                              Dump Heap
*****************************************************************************}

procedure dumpheap;
var
  pp : pheap_mem_info;
  i : longint;
  ExpectedMemAvail : longint;
begin
  pp:=heap_mem_root;
  Writeln(ptext^,'Heap dump by heaptrc unit');
  Writeln(ptext^,getmem_cnt, ' memory blocks allocated : ',getmem_size,'/',getmem8_size);
  Writeln(ptext^,freemem_cnt,' memory blocks freed     : ',freemem_size,'/',freemem8_size);
  Writeln(ptext^,getmem_cnt-freemem_cnt,' unfreed memory blocks : ',getmem_size-freemem_size);
  Write(ptext^,'True heap size : ',system.HeapSize);
  if EntryMemUsed > 0 then
    Writeln(ptext^,' (',EntryMemUsed,' used in System startup)')
  else
    Writeln(ptext^);
  Writeln(ptext^,'True free heap : ',MemAvail);
  ExpectedMemAvail:=system.HeapSize-(getmem8_size-freemem8_size)-
    (getmem_cnt-freemem_cnt)*(sizeof(theap_mem_info)+extra_info_size)-EntryMemUsed;
  If ExpectedMemAvail<>MemAvail then
    Writeln(ptext^,'Should be : ',ExpectedMemAvail);
  i:=getmem_cnt-freemem_cnt;
  while pp<>nil do
   begin
     if i<0 then
       begin
          Writeln(ptext^,'Error in heap memory list');
          Writeln(ptext^,'More memory blocks than expected');
          exit;
       end;
     if ((pp^.sig=$DEADBEEF) and not usecrc) or
        ((pp^.sig=calculate_sig(pp)) and usecrc) then
       begin
          { this one was not released !! }
          if exitcode<>203 then
            call_stack(pp,ptext^);
          dec(i);
       end
     else if pp^.sig<>$AAAAAAAA then
       begin
          dump_error(pp,ptext^);
{$ifdef EXTRA}
          dump_error(pp,error_file);
{$endif EXTRA}
          error_in_heap:=true;
       end
{$ifdef EXTRA}
     else if pp^.release_sig<>calculate_release_sig(pp) then
       begin
          dump_change_after(pp,ptext^);
          dump_change_after(pp,error_file);
          error_in_heap:=true;
       end
{$endif EXTRA}
       ;
     pp:=pp^.previous;
   end;
end;


procedure markheap;
var
  pp : pheap_mem_info;
begin
  pp:=heap_mem_root;
  while pp<>nil do
   begin
     pp^.sig:=$AAAAAAAA;
     pp:=pp^.previous;
   end;
end;


{*****************************************************************************
                                AllocMem
*****************************************************************************}

function TraceAllocMem(size:longint):Pointer;
begin
  TraceAllocMem:=SysAllocMem(size);
end;


{*****************************************************************************
                            No specific tracing calls
*****************************************************************************}

function TraceMemAvail:longint;
begin
  TraceMemAvail:=SysMemAvail;
end;

function TraceMaxAvail:longint;
begin
  TraceMaxAvail:=SysMaxAvail;
end;

function TraceHeapSize:longint;
begin
  TraceHeapSize:=SysHeapSize;
end;


{*****************************************************************************
                           Install MemoryManager
*****************************************************************************}

const
  TraceManager:TMemoryManager=(
    Getmem  : TraceGetMem;
    Freemem : TraceFreeMem;
    FreememSize : TraceFreeMemSize;
    AllocMem : TraceAllocMem;
    ReAllocMem : TraceReAllocMem;
    MemSize : TraceMemSize;
    MemAvail : TraceMemAvail;
    MaxAvail : TraceMaxAvail;
    HeapSize : TraceHeapsize;
  );

procedure TraceExit;
begin
  { no dump if error
    because this gives long long listings }
  { clear inoutres, in case the program that quit didn't }
  ioresult;
  if (exitcode<>0) and (erroraddr<>nil) then
    begin
       Writeln(ptext^,'No heap dump by heaptrc unit');
       Writeln(ptext^,'Exitcode = ',exitcode);
       if ptext<>@stderr then
         begin
            ptext:=@stderr;
            close(ownfile);
         end;
       exit;
    end;
  if not error_in_heap then
    Dumpheap;
  if error_in_heap and (exitcode=0) then
    exitcode:=203;
{$ifdef EXTRA}
  Close(error_file);
{$endif EXTRA}
   if ptext<>@stderr then
     begin
        ptext:=@stderr;
        close(ownfile);
     end;
end;

Procedure SetHeapTraceOutput(const name : string);
var i : longint;
begin
   if ptext<>@stderr then
     begin
        ptext:=@stderr;
        close(ownfile);
     end;
   assign(ownfile,name);
{$I-}
   append(ownfile);
   if IOResult<>0 then
     Rewrite(ownfile);
{$I+}
   ptext:=@ownfile;
   for i:=0 to Paramcount do
     write(ptext^,paramstr(i),' ');
   writeln(ptext^);
end;

procedure SetHeapExtraInfo( size : longint;fillproc : tfillextrainfoproc;displayproc : tdisplayextrainfoproc);
begin
  { the total size must stay multiple of 8, also allocate 2 pointers for
    the fill and display procvars }
  exact_info_size:=size + sizeof(pointer)*2;
  extra_info_size:=((exact_info_size+7) div 8)*8;
  fill_extra_info_proc:=fillproc;
  display_extra_info_proc:=displayproc;
end;


Initialization
  EntryMemUsed:=System.HeapSize-MemAvail;
  MakeCRC32Tbl;
  SetMemoryManager(TraceManager);
  ptext:=@stderr;
{$ifdef EXTRA}
  Assign(error_file,'heap.err');
  Rewrite(error_file);
{$endif EXTRA}
  { checkpointer init }
{$ifdef go32v2}
  Heap_at_init:=HeapPtr;
{$endif}
{$ifdef win32}
  StartupHeapEnd:=HeapEnd;
{$endif}
finalization
  TraceExit;
end.
{
  $Log$
  Revision 1.8  2001-04-11 14:08:31  peter
    * some small fixes to my previous commit

  Revision 1.7  2001/04/11 12:34:50  peter
    * extra info update so it can be always be set on/off

  Revision 1.6  2000/12/16 15:57:17  jonas
    * removed 64bit evaluations when range checking is on

  Revision 1.5  2000/12/07 17:19:47  jonas
    * new constant handling: from now on, hex constants >$7fffffff are
      parsed as unsigned constants (otherwise, $80000000 got sign extended
      and became $ffffffff80000000), all constants in the longint range
      become longints, all constants >$7fffffff and <=cardinal($ffffffff)
      are cardinals and the rest are int64's.
    * added lots of longint typecast to prevent range check errors in the
      compiler and rtl
    * type casts of symbolic ordinal constants are now preserved
    * fixed bug where the original resulttype wasn't restored correctly
      after doing a 64bit rangecheck

  Revision 1.4  2000/11/13 13:40:03  marco
   * Renamefest

  Revision 1.3  2000/08/24 09:01:07  jonas
    * clear inoutres in traceexit before writing anything (to avoid an RTE
      when writing the heaptrc output when a program didn't handle ioresult)
      (merged from fixes branch)

  Revision 1.2  2000/07/13 11:33:44  michael
  + removed logs

}
