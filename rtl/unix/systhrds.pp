{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 2002 by Peter Vreman,
    member of the Free Pascal development team.

    Linux (pthreads) threading support implementation

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit systhrds;
interface
{$S-}

{$ifndef BSD}
 {$linklib c}
 {$linklib pthread}
{$else}
 // Link reentrant libc with pthreads
 {$linklib c_r}
{$endif}

  type
     PRTLCriticalSection = ^TRTLCriticalSection;
     TRTLCriticalSection = record
          m_spinlock : longint;
          m_count : longint;
          m_owner : pointer {pthread_t};
          m_kind : longint;
          m_waiting : record
            head,tail : pointer;
          end; {_pthread_queue}
       end;

{ Include generic thread interface }
{$i threadh.inc}


implementation

Uses BaseUnix,unix;

{*****************************************************************************
                             Generic overloaded
*****************************************************************************}
{$i ostypes.inc}
{$i ossysch.inc}
{ Include generic overloaded routines }
{$i thread.inc}

{$ifndef BSD}
{$i pthread.inc}
{$else}
{$i ptypes.inc}

CONST PTHREAD_EXPLICIT_SCHED       = 0;
      PTHREAD_CREATE_DETACHED      = 1;
      PTHREAD_SCOPE_PROCESS        = 0;

 TYPE
    pthread_t       = pointer;
    ppthread_t      = ^pthread_t;
    pthread_key_t   = cint;
    ppthread_key_t  = ^pthread_key_t;
    pthread_mutex_t = pointer;
    ppthread_mutex_t= ^pthread_mutex_t;
    pthread_attr_t  = pointer; // opague
    ppthread_attr_t = ^pthread_attr_t; // opague
    __destr_func_t  = procedure (p :pointer);cdecl;
    __startroutine_t= function (p :pointer):pointer;cdecl;
    pthread_mutex_attr_t  = pointer;
    ppthread_mutex_attr_t = ^pthread_mutex_t;

function  pthread_getspecific      (t : pthread_key_t):pointer; cdecl; external;
function  pthread_setspecific      (t : pthread_key_t;p:pointer):cint; cdecl; external;
function  pthread_key_create       (p : ppthread_key_t;f: __destr_func_t):cint; cdecl;external;
function  pthread_attr_init           (p : ppthread_key_t):cint; cdecl; external;
function  pthread_attr_setinheritsched(p : ppthread_attr_t;i:cint):cint; cdecl; external;
function  pthread_attr_setscope      (p : ppthread_attr_t;i:cint):cint;cdecl;external;
function  pthread_attr_setdetachstate (p : ppthread_attr_t;i:cint):cint;cdecl;external;
function  pthread_create ( p: ppthread_t;attr : ppthread_attr_t;f:__startroutine_t;arg:pointer):cint;cdecl;external;
procedure pthread_exit  ( p: pointer); cdecl;external;
function  pthread_self:cint; cdecl;external;
function  pthread_mutex_init (p:ppthread_mutex_t;o:ppthread_mutex_attr_t):cint; cdecl;external;
function  pthread_mutex_destroy (p:ppthread_mutex_attr_t):cint; cdecl;external;
function  pthread_mutex_lock    (p:ppthread_mutex_attr_t):cint; cdecl;external;
function  pthread_mutex_unlock  (p:ppthread_mutex_attr_t):cint; cdecl;external;
function  pthread_cancel(_para1:pthread_t):cint;cdecl;external;
function  pthread_detach(_para1:pthread_t):cint;cdecl;external;
function  pthread_join(_para1:pthread_t; _para2:Ppointer):cint;cdecl;external;
{$endif}

{*****************************************************************************
                       System dependent memory allocation
*****************************************************************************}

{$ifndef BSD}

Const

  { Constants for MMAP }
  MAP_PRIVATE   =2;
  MAP_ANONYMOUS =$20;

{$else}

{$ifdef FreeBSD}
CONST
  { Constants for MMAP. These are still private for *BSD }
  MAP_PRIVATE   =2;
  MAP_ANONYMOUS =$1000;
{$ELSE}
 {$ENTER ME}
{$ENDIF}
{$ENDIF}

{*****************************************************************************
                             Threadvar support
*****************************************************************************}

{$ifdef HASTHREADVAR}
    const
      threadvarblocksize : dword = 0;

    var
      TLSKey : pthread_key_t;

    procedure SysInitThreadvar(var offset : dword;size : dword);
      begin
        offset:=threadvarblocksize;
        inc(threadvarblocksize,size);
      end;

    function SysRelocateThreadvar(offset : dword) : pointer;
      begin
        SysRelocateThreadvar:=pthread_getspecific(tlskey)+Offset;
      end;


    procedure SysAllocateThreadVars;
      var
        dataindex : pointer;
      begin
        { we've to allocate the memory from system  }
        { because the FPC heap management uses      }
        { exceptions which use threadvars but       }
        { these aren't allocated yet ...            }
        { allocate room on the heap for the thread vars }
        DataIndex:=Pointer(Fpmmap(0,threadvarblocksize,3,MAP_PRIVATE+MAP_ANONYMOUS,-1,0));
        FillChar(DataIndex^,threadvarblocksize,0);
        pthread_setspecific(tlskey,dataindex);
      end;


    procedure SysReleaseThreadVars;
      begin
        {$ifdef ver1_0}
        Fpmunmap(longint(pthread_getspecific(tlskey)),threadvarblocksize);
        {$else}
        Fpmunmap(pointer(pthread_getspecific(tlskey)),threadvarblocksize);
        {$endif}
      end;

{ Include OS independent Threadvar initialization }
{$i threadvr.inc}


{$endif HASTHREADVAR}


{*****************************************************************************
                            Thread starting
*****************************************************************************}

    type
      pthreadinfo = ^tthreadinfo;
      tthreadinfo = record
        f : tthreadfunc;
        p : pointer;
        stklen : cardinal;
      end;

    procedure DoneThread;
      begin
        { Release Threadvars }
{$ifdef HASTHREADVAR}
        SysReleaseThreadVars;
{$endif HASTHREADVAR}
      end;


    function ThreadMain(param : pointer) : pointer;cdecl;
      var
        ti : tthreadinfo;
{$ifdef DEBUG_MT}
        // in here, don't use write/writeln before having called
        // InitThread! I wonder if anyone ever debugged these routines,
        // because they will have crashed if DEBUG_MT was enabled!
        // this took me the good part of an hour to figure out
        // why it was crashing all the time!
        // this is kind of a workaround, we simply write(2) to fd 0
        s: string[100]; // not an ansistring
{$endif DEBUG_MT}
      begin
{$ifdef DEBUG_MT}
        s := 'New thread started, initing threadvars'#10;
        fpwrite(0,s[1],length(s));
{$endif DEBUG_MT}
{$ifdef HASTHREADVAR}
        { Allocate local thread vars, this must be the first thing,
          because the exception management and io depends on threadvars }
        SysAllocateThreadVars;
{$endif HASTHREADVAR}
        { Copy parameter to local data }
{$ifdef DEBUG_MT}
        s := 'New thread started, initialising ...'#10;
        fpwrite(0,s[1],length(s));
{$endif DEBUG_MT}
        ti:=pthreadinfo(param)^;
        dispose(pthreadinfo(param));
        { Initialize thread }
        InitThread(ti.stklen);
        { Start thread function }
{$ifdef DEBUG_MT}
        writeln('Jumping to thread function');
{$endif DEBUG_MT}
        ThreadMain:=pointer(ti.f(ti.p));
        DoneThread;
	pthread_detach(pointer(pthread_self));
      end;


    function BeginThread(sa : Pointer;stacksize : dword;
                         ThreadFunction : tthreadfunc;p : pointer;
                         creationFlags : dword; var ThreadId : DWord) : DWord;
      var
        ti : pthreadinfo;
        thread_attr : pthread_attr_t;
      begin
{$ifdef DEBUG_MT}
        writeln('Creating new thread');
{$endif DEBUG_MT}
        { Initialize multithreading if not done }
        if not IsMultiThread then
         begin
{$ifdef HASTHREADVAR}
          { We're still running in single thread mode, setup the TLS }
           pthread_key_create(@TLSKey,nil);
           InitThreadVars(@SysRelocateThreadvar);
{$endif HASTHREADVAR}
           IsMultiThread:=true;
         end;
        { the only way to pass data to the newly created thread
          in a MT safe way, is to use the heap }
        new(ti);
        ti^.f:=ThreadFunction;
        ti^.p:=p;
        ti^.stklen:=stacksize;
        { call pthread_create }
{$ifdef DEBUG_MT}
        writeln('Starting new thread');
{$endif DEBUG_MT}
        pthread_attr_init(@thread_attr);
        pthread_attr_setinheritsched(@thread_attr, PTHREAD_EXPLICIT_SCHED);
        
        // will fail under linux -- apparently unimplemented
        pthread_attr_setscope(@thread_attr, PTHREAD_SCOPE_PROCESS);

        // don't create detached, we need to be able to join (waitfor) on
        // the newly created thread!
        //pthread_attr_setdetachstate(@thread_attr, PTHREAD_CREATE_DETACHED);
        if pthread_create(@threadid, @thread_attr, @ThreadMain,ti) <> 0 then begin
          threadid := 0;
        end;
        BeginThread:=threadid;
{$ifdef DEBUG_MT}
        writeln('BeginThread returning ',BeginThread);
{$endif DEBUG_MT}
      end;


    procedure EndThread(ExitCode : DWord);
      begin
        DoneThread;
        pthread_detach(pointer(pthread_self));
        pthread_exit(pointer(ExitCode));
      end;


    function  SuspendThread (threadHandle : dword) : dword;
    begin
      {$Warning SuspendThread needs to be implemented}
    end;

    function  ResumeThread  (threadHandle : dword) : dword;
    begin
      {$Warning ResumeThread needs to be implemented}
    end;

    procedure ThreadSwitch;  {give time to other threads}
    begin
      {extern int pthread_yield (void) __THROW;}
      {$Warning ThreadSwitch needs to be implemented}
    end;

    function  KillThread (threadHandle : dword) : dword;
    begin
      pthread_detach(pointer(threadHandle));
      KillThread := pthread_cancel(Pointer(threadHandle));
    end;

    function  WaitForThreadTerminate (threadHandle : dword; TimeoutMs : longint) : dword;  {0=no timeout}
    var
      LResultP: Pointer;
      LResult: DWord;
    begin
      LResult := 0;
      LResultP := @LResult;
      pthread_join(Pointer(threadHandle), @LResultP);
      WaitForThreadTerminate := LResult;
    end;

    function  ThreadSetPriority (threadHandle : dword; Prio: longint): boolean; {-15..+15, 0=normal}
    begin
      {$Warning ThreadSetPriority needs to be implemented}
    end;


    function  ThreadGetPriority (threadHandle : dword): Integer;
    begin
      {$Warning ThreadGetPriority needs to be implemented}
    end;

    function  GetCurrentThreadId : dword;
    begin
      GetCurrentThreadId:=dword(pthread_self);
    end;


{*****************************************************************************
                          Delphi/Win32 compatibility
*****************************************************************************}

    procedure InitCriticalSection(var CS:TRTLCriticalSection);
      begin
         cs.m_spinlock:=0;
         cs.m_count:=0;
         cs.m_owner:=0;
         cs.m_kind:=1;
         cs.m_waiting.head:=0;
         cs.m_waiting.tail:=0;
         pthread_mutex_init(@CS,NIL);
      end;

    procedure EnterCriticalSection(var CS:TRTLCriticalSection);
      begin
         pthread_mutex_lock(@CS);
      end;

    procedure LeaveCriticalSection(var CS:TRTLCriticalSection);
      begin
         pthread_mutex_unlock(@CS);
      end;

    procedure DoneCriticalSection(var CS:TRTLCriticalSection);
      begin
         pthread_mutex_destroy(@CS);
      end;


{*****************************************************************************
                           Heap Mutex Protection
*****************************************************************************}

    var
      HeapMutex : pthread_mutex_t;

    procedure PThreadHeapMutexInit;
      begin
         pthread_mutex_init(@heapmutex,nil);
      end;

    procedure PThreadHeapMutexDone;
      begin
         pthread_mutex_destroy(@heapmutex);
      end;

    procedure PThreadHeapMutexLock;
      begin
         pthread_mutex_lock(@heapmutex);
      end;

    procedure PThreadHeapMutexUnlock;
      begin
         pthread_mutex_unlock(@heapmutex);
      end;

    const
      PThreadMemoryMutexManager : TMemoryMutexManager = (
        MutexInit : @PThreadHeapMutexInit;
        MutexDone : @PThreadHeapMutexDone;
        MutexLock : @PThreadHeapMutexLock;
        MutexUnlock : @PThreadHeapMutexUnlock;
      );

    procedure InitHeapMutexes;
      begin
        SetMemoryMutexManager(PThreadMemoryMutexManager);
      end;


initialization
  InitHeapMutexes;
end.
{
  $Log$
  Revision 1.17  2003-11-17 10:05:51  marco
   * threads for FreeBSD. Not working tho

  Revision 1.16  2003/11/17 08:27:50  marco
   * pthreads based ttread from Johannes Berg

  Revision 1.15  2003/10/01 21:00:09  peter
    * GetCurrentThreadHandle renamed to GetCurrentThreadId

  Revision 1.14  2003/10/01 20:53:08  peter
    * GetCurrentThreadId implemented

  Revision 1.13  2003/09/20 12:38:29  marco
   * FCL now compiles for FreeBSD with new 1.1. Now Linux.

  Revision 1.12  2003/09/16 13:17:03  marco
   * Wat cleanup, ouwe syscalls nu via baseunix e.d.

  Revision 1.11  2003/09/16 13:00:02  marco
   * small BSD gotcha removed (typing mmap params)

  Revision 1.10  2003/09/15 20:08:49  marco
   * small fixes. FreeBSD now cycles

  Revision 1.9  2003/09/14 20:15:01  marco
   * Unix reform stage two. Remove all calls from Unix that exist in Baseunix.

  Revision 1.8  2003/03/27 17:14:27  armin
  * more platform independent thread routines, needs to be implemented for unix

  Revision 1.7  2003/01/05 19:11:32  marco
   * small changes originating from introduction of Baseunix to FreeBSD

  Revision 1.6  2002/11/11 21:41:06  marco
   * syscall.inc -> syscallo.inc

  Revision 1.5  2002/10/31 13:45:21  carl
    * threadvar.inc -> threadvr.inc

  Revision 1.4  2002/10/26 18:27:52  marco
   * First series POSIX calls commits. Including getcwd.

  Revision 1.3  2002/10/18 18:05:06  marco
   * $I pthread.inc instead of pthreads.inc

  Revision 1.2  2002/10/18 12:19:59  marco
   * Fixes to get the generic *BSD RTL compiling again + fixes for thread
     support. Still problems left in fexpand. (inoutres?) Therefore fixed
     sysposix not yet commited

  Revision 1.1  2002/10/16 06:22:56  michael
  Threads renamed from threads to systhrds

  Revision 1.1  2002/10/14 19:39:17  peter
    * threads unit added for thread support

}

