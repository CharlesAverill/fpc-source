{
    $Id$
    Copyright (c) 1996-98 by Florian Klaempfl

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
unit hcodegen;

{$ifdef newcg}
interface

implementation
{$else newcg}

  interface

    uses
      cobjects,
      tokens,verbose,
      aasm,symconst,symtable,cpubase;

    const
       pi_uses_asm  = $1;       { set, if the procedure uses asm }
       pi_is_global = $2;       { set, if the procedure is exported by an unit }
       pi_do_call   = $4;       { set, if the procedure does a call }
       pi_operator  = $8;       { set, if the procedure is an operator   }
       pi_C_import  = $10;      { set, if the procedure is an external C function }
       pi_uses_exceptions = $20;{ set, if the procedure has a try statement => }
                                { no register variables                 }
       pi_is_assembler = $40;   { set if the procedure is declared as ASSEMBLER
                                  => don't optimize}
       pi_needs_implicit_finally = $80; { set, if the procedure contains data which }
                                        { needs to be finalized              }
    type
       pprocinfo = ^tprocinfo;
       tprocinfo = record
          { pointer to parent in nested procedures }
          parent : pprocinfo;
          { current class, if we are in a method }
          _class : pobjectdef;
          { return type }
          retdef : pdef;
          { return type }
          sym : pprocsym;
          { symbol of the function, and the sym for result variable }
          resultfuncretsym,
          funcretsym : pfuncretsym;
          { the definition of the proc itself }
          { why was this a pdef only ?? PM    }
          def : pprocdef;
          { frame pointer offset }
          framepointer_offset : longint;
          { self pointer offset }
          selfpointer_offset : longint;
          { result value offset }
          retoffset : longint;

          { firsttemp position }
          firsttemp : longint;

          { funcret_is_valid : boolean; }
          funcret_state : tvarstate;

          { parameter offset }
          call_offset : longint;

          { some collected informations about the procedure }
          { see pi_xxxx above                          }
          flags : longint;

          { register used as frame pointer }
          framepointer : tregister;

          { true, if the procedure is exported by an unit }
          globalsymbol : boolean;

          { true, if the procedure should be exported (only OS/2) }
          exported : boolean;

          { code for the current procedure }
          aktproccode,aktentrycode,
          aktexitcode,aktlocaldata : paasmoutput;
          { local data is used for smartlink }
       end;

       { some kind of temp. types needs to be destructed }
       { for example ansistring, this is done using this }
       { list                                       }
       ptemptodestroy = ^ttemptodestroy;
       ttemptodestroy = object(tlinkedlist_item)
          typ : pdef;
          address : treference;
          constructor init(const a : treference;p : pdef);
       end;

    var
       { info about the current sub routine }
       procinfo : pprocinfo;

       { labels for BREAK and CONTINUE }
       aktbreaklabel,aktcontinuelabel : pasmlabel;

       { label when the result is true or false }
       truelabel,falselabel : pasmlabel;

       { label to leave the sub routine }
       aktexitlabel : pasmlabel;

       { also an exit label, only used we need to clear only the stack }
       aktexit2label : pasmlabel;

       { only used in constructor for fail or if getmem fails }
       faillabel,quickexitlabel : pasmlabel;

       { Boolean, wenn eine loadn kein Assembler erzeugt hat }
       simple_loadn : boolean;

       { tries to hold the amount of times which the current tree is processed  }
       t_times : longint;

       { true, if an error while code generation occurs }
       codegenerror : boolean;

       { save the size of pushed parameter, needed for aligning }
       pushedparasize : longint;

       make_const_global : boolean;

    { message calls with codegenerror support }
    procedure cgmessage(t : tmsgconst);
    procedure cgmessage1(t : tmsgconst;const s : string);
    procedure cgmessage2(t : tmsgconst;const s1,s2 : string);
    procedure cgmessage3(t : tmsgconst;const s1,s2,s3 : string);
    procedure CGMessagePos(const pos:tfileposinfo;t:tmsgconst);
    procedure CGMessagePos1(const pos:tfileposinfo;t:tmsgconst;const s1:string);
    procedure CGMessagePos2(const pos:tfileposinfo;t:tmsgconst;const s1,s2:string);
    procedure CGMessagePos3(const pos:tfileposinfo;t:tmsgconst;const s1,s2,s3:string);

    { initialize respectively terminates the code generator }
    { for a new module or procedure                      }
    procedure codegen_doneprocedure;
    procedure codegen_donemodule;
    procedure codegen_newmodule;
    procedure codegen_newprocedure;


implementation

     uses
        systems,globals,files,strings,cresstr;

{*****************************************************************************
            override the message calls to set codegenerror
*****************************************************************************}

    procedure cgmessage(t : tmsgconst);
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

    procedure cgmessage1(t : tmsgconst;const s : string);
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

    procedure cgmessage2(t : tmsgconst;const s1,s2 : string);
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

    procedure cgmessage3(t : tmsgconst;const s1,s2,s3 : string);
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


    procedure cgmessagepos(const pos:tfileposinfo;t : tmsgconst);
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

    procedure cgmessagepos1(const pos:tfileposinfo;t : tmsgconst;const s1 : string);
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

    procedure cgmessagepos2(const pos:tfileposinfo;t : tmsgconst;const s1,s2 : string);
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

    procedure cgmessagepos3(const pos:tfileposinfo;t : tmsgconst;const s1,s2,s3 : string);
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
         new(procinfo);
         fillchar(procinfo^,sizeof(tprocinfo),0);
         { the type of this lists isn't important }
         { because the code of this lists is      }
         { copied to the code segment        }
         procinfo^.aktentrycode:=new(paasmoutput,init);
         procinfo^.aktexitcode:=new(paasmoutput,init);
         procinfo^.aktproccode:=new(paasmoutput,init);
         procinfo^.aktlocaldata:=new(paasmoutput,init);
      end;



    procedure codegen_doneprocedure;
      begin
         dispose(procinfo^.aktentrycode,done);
         dispose(procinfo^.aktexitcode,done);
         dispose(procinfo^.aktproccode,done);
         dispose(procinfo^.aktlocaldata,done);
         dispose(procinfo);
         procinfo:=nil;
      end;



    procedure codegen_newmodule;
      begin
         exprasmlist:=new(paasmoutput,init);
         datasegment:=new(paasmoutput,init);
         codesegment:=new(paasmoutput,init);
         bsssegment:=new(paasmoutput,init);
         debuglist:=new(paasmoutput,init);
         consts:=new(paasmoutput,init);
         rttilist:=new(paasmoutput,init);
         importssection:=nil;
         exportssection:=nil;
         resourcesection:=nil;
         { assembler symbols }
         asmsymbollist:=new(pasmsymbollist,init);
         asmsymbollist^.usehash;
      end;



    procedure codegen_donemodule;
{$ifdef MEMDEBUG}
      var
        d : tmemdebug;
{$endif}
      begin
{$ifdef MEMDEBUG}
         d.init('asmlist');
{$endif}
         dispose(exprasmlist,done);
         dispose(codesegment,done);
         dispose(bsssegment,done);
         dispose(datasegment,done);
         dispose(debuglist,done);
         dispose(consts,done);
         dispose(rttilist,done);
         if assigned(importssection) then
          dispose(importssection,done);
         if assigned(exportssection) then
          dispose(exportssection,done);
         if assigned(resourcesection) then
          dispose(resourcesection,done);
{$ifdef MEMDEBUG}
         d.done;
{$endif}
         { assembler symbols }
{$ifdef MEMDEBUG}
         d.init('asmsymbol');
{$endif}
         dispose(asmsymbollist,done);
{$ifdef MEMDEBUG}
         d.done;
{$endif}
         { resourcestrings }
         ResetResourceStrings;
      end;


{*****************************************************************************
                              TTempToDestroy
*****************************************************************************}

    constructor ttemptodestroy.init(const a : treference;p : pdef);
      begin
         inherited init;
         address:=a;
         typ:=p;
      end;
{$endif newcg}
end.

{
  $Log$
  Revision 1.49  1999-11-17 17:04:59  pierre
   * Notes/hints changes

  Revision 1.48  1999/11/09 23:06:45  peter
    * esi_offset -> selfpointer_offset to be newcg compatible
    * hcogegen -> cgbase fixes for newcg

  Revision 1.47  1999/11/06 14:34:21  peter
    * truncated log to 20 revs

  Revision 1.46  1999/10/21 14:18:54  peter
    * tp7 fix

  Revision 1.45  1999/10/14 14:57:52  florian
    - removed the hcodegen use in the new cg, use cgbase instead

  Revision 1.44  1999/10/13 10:42:15  peter
    * cgmessagepos functions

  Revision 1.43  1999/09/27 23:44:51  peter
    * procinfo is now a pointer
    * support for result setting in sub procedure

  Revision 1.42  1999/08/26 20:24:40  michael
  + Hopefuly last fixes for resourcestrings

  Revision 1.41  1999/08/24 13:14:03  peter
    * MEMDEBUG to see the sizes of asmlist,asmsymbols,symtables

  Revision 1.40  1999/08/24 12:01:32  michael
  + changes for resourcestrings

  Revision 1.39  1999/08/19 13:10:18  pierre
   + faillabel for _FAIL

  Revision 1.38  1999/08/16 18:23:56  peter
    * reset resourcestringlist in newmodule.

  Revision 1.37  1999/08/04 00:23:02  florian
    * renamed i386asm and i386base to cpuasm and cpubase

  Revision 1.36  1999/08/01 23:09:26  michael
  * procbase -> cpubase

  Revision 1.35  1999/08/01 23:04:49  michael
  + Changes for Alpha

  Revision 1.34  1999/07/22 09:37:42  florian
    + resourcestring implemented
    + start of longstring support

  Revision 1.33  1999/05/27 19:44:31  peter
    * removed oldasm
    * plabel -> pasmlabel
    * -a switches to source writing automaticly
    * assembler readers OOPed
    * asmsymbol automaticly external
    * jumptables and other label fixes for asm readers

  Revision 1.32  1999/05/21 13:55:01  peter
    * NEWLAB for label as symbol

  Revision 1.31  1999/05/17 21:57:08  florian
    * new temporary ansistring handling

  Revision 1.30  1999/05/01 13:24:22  peter
    * merged nasm compiler
    * old asm moved to oldasm/

  Revision 1.29  1999/04/21 09:43:38  peter
    * storenumber works
    * fixed some typos in double_checksum
    + incompatible types type1 and type2 message (with storenumber)

  Revision 1.28  1999/03/24 23:17:00  peter
    * fixed bugs 212,222,225,227,229,231,233

  Revision 1.27  1999/02/25 21:02:37  peter
    * ag386bin updates
    + coff writer

}
