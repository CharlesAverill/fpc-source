{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    This unit exports some help routines for the code generation

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
unit cgbase;

{$i fpcdefs.inc}

  interface

    uses
      { common }
      cclasses,
      { global }
      globals,verbose,
      { symtable }
      symconst,symtype,symdef,symsym,
      { aasm }
      cpubase,cpuinfo,cginfo,aasmbase,aasmtai
      ;



    const
       {# bitmask indicating if the procedure uses asm }
       pi_uses_asm  = $1;
       {# bitmask indicating if the procedure is exported by an unit }
       pi_is_global = $2;
       {# bitmask indicating if the procedure does a call }
       pi_do_call   = $4;
       {# bitmask indicating if the procedure is an operator   }
       pi_operator  = $8;
       {# bitmask indicating if the procedure is an external C function }
       pi_c_import  = $10;
       {# bitmask indicating if the procedure has a try statement = no register optimization }
       pi_uses_exceptions = $20;
       {# bitmask indicating if the procedure is declared as @var(assembler), don't optimize}
       pi_is_assembler = $40;
       {# bitmask indicating if the procedure contains data which needs to be finalized }
       pi_needs_implicit_finally = $80;

    type
       pprocinfo = ^tprocinfo;
       tprocinfo = object
          {# pointer to parent in nested procedures }
          parent : pprocinfo;
          {# current class, if we are in a method }
          _class : tobjectdef;
          {# the definition of the routine itself }
          procdef : tprocdef;
          {# frame pointer offset??? }
          framepointer_offset : longint;
          { self pointer offset???? }
          selfpointer_offset : longint;
          {# result value offset in stack (functions only) }
          return_offset : longint;
          {# firsttemp position }
          firsttemp_offset : longint;
          {# parameter offset in stack }
          para_offset : longint;

          {# some collected informations about the procedure
             see pi_xxxx above                               }
          flags : longint;

          {# register used as frame pointer }
          framepointer : tregister;

          {# true, if the procedure is exported by a unit }
          globalsymbol : boolean;

          {# true, if the procedure should be exported (only OS/2) }
          exported : boolean;

          {# true, if we can not use fast exit code }
          no_fast_exit : boolean;
          
          {# Holds the environment reference for default exceptions 
             
             The exception reference is created when ansistrings
             or classes are used. It holds buffer for exception
             frames. It is allocted by g_new_exception.
          }
          exception_env_ref : treference;
          {# Holds the environment reference for default exceptions 
             
             The exception reference is created when ansistrings
             or classes are used. It holds buffer for setjmp
             It is allocted by g_new_exception.
          }
          exception_jmp_ref :treference;
          {# Holds the environment reference for default exceptions 
             
             The exception reference is created when ansistrings
             or classes are used. It holds the location where
             temporary storage of the setjmp result is stored.
             
             This reference can be nil, if the result is instead
             saved on the stack.
          }
          exception_result_ref :treference;

          aktproccode,aktentrycode,
          aktexitcode,aktlocaldata : taasmoutput;
          constructor init;
          destructor done;
       end;

       pregvarinfo = ^tregvarinfo;
       tregvarinfo = record
          regvars : array[1..maxvarregs] of tvarsym;
          regvars_para : array[1..maxvarregs] of boolean;
          regvars_refs : array[1..maxvarregs] of longint;

          fpuregvars : array[1..maxfpuvarregs] of tvarsym;
          fpuregvars_para : array[1..maxfpuvarregs] of boolean;
          fpuregvars_refs : array[1..maxfpuvarregs] of longint;
       end;


    var
       {# information about the current sub routine being parsed (@var(pprocinfo))}
       procinfo : pprocinfo;

       { labels for BREAK and CONTINUE }
       aktbreaklabel,aktcontinuelabel : tasmlabel;

       { label when the result is true or false }
       truelabel,falselabel : tasmlabel;

       { label to leave the sub routine }
       aktexitlabel : tasmlabel;

       { also an exit label, only used we need to clear only the stack }
       aktexit2label : tasmlabel;

       {# only used in constructor for fail keyword or if getmem fails }
       faillabel      : tasmlabel;
       quickexitlabel : tasmlabel;

       {# true, if there was an error while code generation occurs }
       codegenerror : boolean;

       { save the size of pushed parameter, needed for aligning }
       pushedparasize : longint;


    { message calls with codegenerror support }
    procedure cgmessage(t : longint);
    procedure cgmessage1(t : longint;const s : string);
    procedure cgmessage2(t : longint;const s1,s2 : string);
    procedure cgmessage3(t : longint;const s1,s2,s3 : string);
    procedure CGMessagePos(const pos:tfileposinfo;t:longint);
    procedure CGMessagePos1(const pos:tfileposinfo;t:longint;const s1:string);
    procedure CGMessagePos2(const pos:tfileposinfo;t:longint;const s1,s2:string);
    procedure CGMessagePos3(const pos:tfileposinfo;t:longint;const s1,s2,s3:string);

    { initialize respectively terminates the code generator }
    { for a new module or procedure                      }
    procedure codegen_doneprocedure;
    procedure codegen_donemodule;
    procedure codegen_newmodule;
    procedure codegen_newprocedure;

    {# From a definition return the abstract code generator size (@var(tcgsize) enum). It is
       to note that the value returned can be @var(OS_NO) }
    function def_cgsize(def: tdef): tcgsize;
    function int_cgsize(const l: aword): tcgsize;

    {# return the inverse condition of opcmp }
    function inverse_opcmp(opcmp: topcmp): topcmp;

    {# return whether op is commutative }
    function commutativeop(op: topcg): boolean;


implementation

     uses
        systems,
        cresstr,
        rgobj,
        defbase
{$ifdef fixLeaksOnError}
        ,comphook
{$endif fixLeaksOnError}

        ;

{$ifdef fixLeaksOnError}
     var procinfoStack: TStack;
         hcodegen_old_do_stop: tstopprocedure;
{$endif fixLeaksOnError}

{*****************************************************************************
            override the message calls to set codegenerror
*****************************************************************************}

    procedure cgmessage(t : longint);
      var
         olderrorcount : longint;
      begin
         if not(codegenerror) then
           begin
              olderrorcount:=Errorcount;
              verbose.Message(t);
              codegenerror:=olderrorcount<>Errorcount;
           end;
      end;

    procedure cgmessage1(t : longint;const s : string);
      var
         olderrorcount : longint;
      begin
         if not(codegenerror) then
           begin
              olderrorcount:=Errorcount;
              verbose.Message1(t,s);
              codegenerror:=olderrorcount<>Errorcount;
           end;
      end;

    procedure cgmessage2(t : longint;const s1,s2 : string);
      var
         olderrorcount : longint;
      begin
         if not(codegenerror) then
           begin
              olderrorcount:=Errorcount;
              verbose.Message2(t,s1,s2);
              codegenerror:=olderrorcount<>Errorcount;
           end;
      end;

    procedure cgmessage3(t : longint;const s1,s2,s3 : string);
      var
         olderrorcount : longint;
      begin
         if not(codegenerror) then
           begin
              olderrorcount:=Errorcount;
              verbose.Message3(t,s1,s2,s3);
              codegenerror:=olderrorcount<>Errorcount;
           end;
      end;


    procedure cgmessagepos(const pos:tfileposinfo;t : longint);
      var
         olderrorcount : longint;
      begin
         if not(codegenerror) then
           begin
              olderrorcount:=Errorcount;
              verbose.MessagePos(pos,t);
              codegenerror:=olderrorcount<>Errorcount;
           end;
      end;

    procedure cgmessagepos1(const pos:tfileposinfo;t : longint;const s1 : string);
      var
         olderrorcount : longint;
      begin
         if not(codegenerror) then
           begin
              olderrorcount:=Errorcount;
              verbose.MessagePos1(pos,t,s1);
              codegenerror:=olderrorcount<>Errorcount;
           end;
      end;

    procedure cgmessagepos2(const pos:tfileposinfo;t : longint;const s1,s2 : string);
      var
         olderrorcount : longint;
      begin
         if not(codegenerror) then
           begin
              olderrorcount:=Errorcount;
              verbose.MessagePos2(pos,t,s1,s2);
              codegenerror:=olderrorcount<>Errorcount;
           end;
      end;

    procedure cgmessagepos3(const pos:tfileposinfo;t : longint;const s1,s2,s3 : string);
      var
         olderrorcount : longint;
      begin
         if not(codegenerror) then
           begin
              olderrorcount:=Errorcount;
              verbose.MessagePos3(pos,t,s1,s2,s3);
              codegenerror:=olderrorcount<>Errorcount;
           end;
      end;


{****************************************************************************
                                 TProcInfo
****************************************************************************}

    constructor tprocinfo.init;
      begin
        parent:=nil;
        _class:=nil;
        procdef:=nil;
        framepointer_offset:=0;
        selfpointer_offset:=0;
        return_offset:=0;
        firsttemp_offset:=0;
        para_offset:=0;
        flags:=0;
        framepointer:=R_NO;
        globalsymbol:=false;
        exported:=false;
        no_fast_exit:=false;

        aktentrycode:=Taasmoutput.Create;
        aktexitcode:=Taasmoutput.Create;
        aktproccode:=Taasmoutput.Create;
        aktlocaldata:=Taasmoutput.Create;
        reference_reset(exception_env_ref);
        reference_reset(exception_jmp_ref);
        reference_reset(exception_result_ref);
      end;


    destructor tprocinfo.done;
      begin
         aktentrycode.free;
         aktexitcode.free;
         aktproccode.free;
         aktlocaldata.free;
      end;


{*****************************************************************************
         initialize/terminate the codegen for procedure and modules
*****************************************************************************}

    procedure codegen_newprocedure;
      begin
         aktbreaklabel:=nil;
         aktcontinuelabel:=nil;
         { aktexitlabel:=0; is store in oldaktexitlabel
           so it must not be reset to zero before this storage !}
         { new procinfo }
         new(procinfo,init);
{$ifdef fixLeaksOnError}
         procinfoStack.push(procinfo);
{$endif fixLeaksOnError}
      end;



    procedure codegen_doneprocedure;
      begin
{$ifdef fixLeaksOnError}
         if procinfo <> procinfoStack.pop then
           writeln('problem with procinfoStack!');
{$endif fixLeaksOnError}
         dispose(procinfo,done);
         procinfo:=nil;
      end;



    procedure codegen_newmodule;
      begin
         exprasmlist:=taasmoutput.create;
         datasegment:=taasmoutput.create;
         codesegment:=taasmoutput.create;
         bsssegment:=taasmoutput.create;
         debuglist:=taasmoutput.create;
         withdebuglist:=taasmoutput.create;
         consts:=taasmoutput.create;
         rttilist:=taasmoutput.create;
         ResourceStringList:=Nil;
         importssection:=nil;
         exportssection:=nil;
         resourcesection:=nil;
         { assembler symbols }
         asmsymbollist:=tdictionary.create;
         asmsymbollist.usehash;
         { resourcestrings }
         ResourceStrings:=TResourceStrings.Create;
      end;



    procedure codegen_donemodule;
{$ifdef MEMDEBUG}
      var
        d : tmemdebug;
{$endif}
      begin
{$ifdef MEMDEBUG}
         d:=tmemdebug.create('asmlist');
{$endif}
         exprasmlist.free;
         codesegment.free;
         bsssegment.free;
         datasegment.free;
         debuglist.free;
         withdebuglist.free;
         consts.free;
         rttilist.free;
         if assigned(ResourceStringList) then
          ResourceStringList.free;
         if assigned(importssection) then
          importssection.free;
         if assigned(exportssection) then
          exportssection.free;
         if assigned(resourcesection) then
          resourcesection.free;
{$ifdef MEMDEBUG}
         d.free;
{$endif}
         { assembler symbols }
{$ifdef MEMDEBUG}
         d:=tmemdebug.create('asmsymbol');
{$endif}
         asmsymbollist.free;
{$ifdef MEMDEBUG}
         d.free;
{$endif}
         { resource strings }
         ResourceStrings.free;
      end;


    function def_cgsize(def: tdef): tcgsize;
      begin
        case def.deftype of
          orddef,
          enumdef,
          setdef:
            begin
              result := int_cgsize(def.size);
              if is_signed(def) then
                result := tcgsize(ord(result)+(ord(OS_S8)-ord(OS_8)));
            end;
          classrefdef,
          pointerdef,
          procvardef:
            result := OS_ADDR;
          stringdef :
            begin
              if is_ansistring(def) or is_widestring(def) then
                result := OS_ADDR
              else
                result := OS_NO;
            end;
          objectdef :
            begin
              if is_class_or_interface(def) then
                result := OS_ADDR
              else
                result := OS_NO;
            end;
          floatdef:
            result := tfloat2tcgsize[tfloatdef(def).typ];
          recorddef :
            result:=int_cgsize(def.size);
          arraydef :
            begin
              if not is_special_array(def) then
                result := int_cgsize(def.size)
              else
                result := OS_NO;
            end;
          else
            begin
              { undefined size }
              result:=OS_NO;
            end;
        end;
      end;

    function int_cgsize(const l: aword): tcgsize;
      begin
        case l of
          1 :
            result := OS_8;
          2 :
            result := OS_16;
          3,4 :
            result := OS_32;
          5..8 :
            result := OS_64;
          else
            result:=OS_NO;
        end;
      end;


    function inverse_opcmp(opcmp: topcmp): topcmp;
      const
        list: array[TOpCmp] of TOpCmp =
          (OC_NONE,OC_NE,OC_LTE,OC_GTE,OC_LT,OC_GT,OC_EQ,OC_A,OC_AE,
           OC_B,OC_BE);
      begin
        inverse_opcmp := list[opcmp];
      end;


    function commutativeop(op: topcg): boolean;
      const
        list: array[topcg] of boolean =
          (true,true,true,false,false,true,true,false,false,
           true,false,false,false,false,true);
      begin
        commutativeop := list[op];
      end;


{$ifdef fixLeaksOnError}
procedure hcodegen_do_stop;
var p: pprocinfo;
begin
  p := pprocinfo(procinfoStack.pop);
  while p <> nil Do
    begin
      dispose(p,done);
      p := pprocinfo(procinfoStack.pop);
    end;
  procinfoStack.done;
  do_stop := hcodegen_old_do_stop;
  do_stop{$ifdef FPCPROCVAR}(){$endif};
end;

begin
  hcodegen_old_do_stop := do_stop;
  do_stop := {$ifdef FPCPROCVAR}@{$endif}hcodegen_do_stop;
  procinfoStack.init;
{$endif fixLeaksOnError}
end.
{
  $Log$
  Revision 1.20  2002-08-04 19:06:41  carl
    + added generic exception support (still does not work!)
    + more documentation

  Revision 1.19  2002/07/20 11:57:53  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.18  2002/07/01 18:46:22  peter
    * internal linker
    * reorganized aasm layer

  Revision 1.17  2002/05/20 13:30:40  carl
  * bugfix of hdisponen (base must be set, not index)
  * more portability fixes

  Revision 1.16  2002/05/18 13:34:05  peter
    * readded missing revisions

  Revision 1.15  2002/05/16 19:46:35  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.13  2002/04/25 20:16:38  peter
    * moved more routines from cga/n386util

  Revision 1.12  2002/04/21 15:28:06  carl
  - remove duplicate constants
  - move some constants to cginfo

  Revision 1.11  2002/04/20 21:32:23  carl
  + generic FPC_CHECKPOINTER
  + first parameter offset in stack now portable
  * rename some constants
  + move some cpu stuff to other units
  - remove unused constents
  * fix stacksize for some targets
  * fix generic size problems which depend now on EXTEND_SIZE constant

  Revision 1.10  2002/04/07 09:13:39  carl
  + documentation
  - remove unused variables

  Revision 1.9  2002/04/04 19:05:54  peter
    * removed unused units
    * use tlocation.size in cg.a_*loc*() routines

  Revision 1.8  2002/04/02 17:11:27  peter
    * tlocation,treference update
    * LOC_CONSTANT added for better constant handling
    * secondadd splitted in multiple routines
    * location_force_reg added for loading a location to a register
      of a specified size
    * secondassignment parses now first the right and then the left node
      (this is compatible with Kylix). This saves a lot of push/pop especially
      with string operations
    * adapted some routines to use the new cg methods

  Revision 1.7  2002/03/31 20:26:33  jonas
    + a_loadfpu_* and a_loadmm_* methods in tcg
    * register allocation is now handled by a class and is mostly processor
      independent (+rgobj.pas and i386/rgcpu.pas)
    * temp allocation is now handled by a class (+tgobj.pas, -i386\tgcpu.pas)
    * some small improvements and fixes to the optimizer
    * some register allocation fixes
    * some fpuvaroffset fixes in the unary minus node
    * push/popusedregisters is now called rg.save/restoreusedregisters and
      (for i386) uses temps instead of push/pop's when using -Op3 (that code is
      also better optimizable)
    * fixed and optimized register saving/restoring for new/dispose nodes
    * LOC_FPU locations now also require their "register" field to be set to
      R_ST, not R_ST0 (the latter is used for LOC_CFPUREGISTER locations only)
    - list field removed of the tnode class because it's not used currently
      and can cause hard-to-find bugs

  Revision 1.6  2002/03/04 19:10:11  peter
    * removed compiler warnings

}
