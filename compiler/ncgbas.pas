{
    $Id$
    Copyright (c) 2000 by Florian Klaempfl

    This unit implements some basic nodes

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
unit ncgbas;

{$i defines.inc}

interface

    uses
       node,nbas;

    type
       tcgnothingnode = class(tnothingnode)
          procedure pass_2;override;
       end;

       tcgasmnode = class(tasmnode)
          procedure pass_2;override;
       end;

       tcgstatementnode = class(tstatementnode)
          procedure pass_2;override;
       end;

       tcgblocknode = class(tblocknode)
          procedure pass_2;override;
       end;
       
       tcgtempcreatenode = class(ttempcreatenode)
          procedure pass_2;override;
       end;

       tcgtemprefnode = class(ttemprefnode)
          procedure pass_2;override;
       end;

       tcgtempdeletenode = class(ttempdeletenode)
          procedure pass_2;override;
       end;

  implementation

    uses
      globtype,systems,
      cutils,cclasses,verbose,globals,
      aasm,symconst,symsym,symtable,types,
      htypechk,
      cpubase,cpuasm,
      nflw,pass_2
{$ifdef newcg}
      ,cgbase
{$else newcg}
      ,hcodegen
{$endif}
{$ifdef i386}
      ,cgai386
{$endif}
      ,tgcpu,temp_gen
      ;
{*****************************************************************************
                                 TNOTHING
*****************************************************************************}

    procedure tcgnothingnode.pass_2;
      begin
         { avoid an abstract rte }
      end;


{*****************************************************************************
                               TSTATEMENTNODE
*****************************************************************************}

    procedure tcgstatementnode.pass_2;
      var
         hp : tnode;
      begin
         hp:=self;
         while assigned(hp) do
          begin
            if assigned(tstatementnode(hp).right) then
             begin
               cleartempgen;
               secondpass(tstatementnode(hp).right);
             end;
            hp:=tstatementnode(hp).left;
          end;
      end;


{*****************************************************************************
                               TASMNODE
*****************************************************************************}

    procedure tcgasmnode.pass_2;

      procedure ReLabel(var p:tasmsymbol);
        begin
          if p.proclocal then
           begin
             if not assigned(p.altsymbol) then
              begin
                { generatealtsymbol will also increase the refs }
                p.GenerateAltSymbol;
                UsedAsmSymbolListInsert(p);
              end
             else
              begin
                { increase the refs, they will be decreased when the
                  asmnode is destroyed }
                inc(p.refs);
              end;
             p:=p.altsymbol;
           end;
        end;

      var
        hp,hp2 : tai;
        localfixup,parafixup,
        i : longint;
        skipnode : boolean;
      begin
         if inlining_procedure then
           begin
             CreateUsedAsmSymbolList;
             localfixup:=aktprocsym.definition.localst.address_fixup;
             parafixup:=aktprocsym.definition.parast.address_fixup;
             hp:=tai(p_asm.first);
             while assigned(hp) do
              begin
                hp2:=tai(hp.getcopy);
                skipnode:=false;
                case hp2.typ of
                  ait_label :
                     begin
                       { regenerate the labels by setting altsymbol }
                       ReLabel(tasmsymbol(tai_label(hp2).l));
                     end;
                  ait_const_rva,
                  ait_const_symbol :
                     begin
                       ReLabel(tai_const_symbol(hp2).sym);
                     end;
                  ait_instruction :
                     begin
                       { fixup the references }
                       for i:=1 to taicpu(hp2).ops do
                        begin
                          with taicpu(hp2).oper[i-1] do
                           begin
                             case typ of
                               top_ref :
                                 begin
                                   case ref^.options of
                                     ref_parafixup :
                                       ref^.offsetfixup:=parafixup;
                                     ref_localfixup :
                                       ref^.offsetfixup:=localfixup;
                                   end;
                                   if assigned(ref^.symbol) then
                                    ReLabel(ref^.symbol);
                                 end;
                               top_symbol :
                                 begin
                                   ReLabel(sym);
                                 end;
                              end;
                           end;
                        end;
                     end;
                   ait_marker :
                     begin
                     { it's not an assembler block anymore }
                       if (tai_marker(hp2).kind in [AsmBlockStart, AsmBlockEnd]) then
                        skipnode:=true;
                     end;
                   else
                end;
                if not skipnode then
                 exprasmList.concat(hp2)
                else
                 hp2.free;
                hp:=tai(hp.next);
              end;
             { restore used symbols }
             UsedAsmSymbolListResetAltSym;
             DestroyUsedAsmSymbolList;
           end
         else
           begin
             { if the routine is an inline routine, then we must hold a copy
               because it can be necessary for inlining later }
             if (pocall_inline in aktprocsym.definition.proccalloptions) then
               exprasmList.concatlistcopy(p_asm)
             else
               exprasmList.concatlist(p_asm);
           end;
         if not (nf_object_preserved in flags) then
           maybe_loadself;
       end;


{*****************************************************************************
                             TBLOCKNODE
*****************************************************************************}

    procedure tcgblocknode.pass_2;
      begin
        { do second pass on left node }
        if assigned(left) then
         secondpass(left);
      end;

{*****************************************************************************
                          TTEMPCREATENODE
*****************************************************************************}

    procedure tcgtempcreatenode.pass_2;
      begin
        { if we're secondpassing the same tcgtempcreatenode twice, we have a bug }
        if tempinfo^.valid then
          internalerror(200108222);

        { get a (persistent) temp }
        if persistent then
          gettempofsizereferencepersistant(size,tempinfo^.ref)
        else
          gettempofsizereference(size,tempinfo^.ref);
        tempinfo^.valid := true;
      end;


{*****************************************************************************
                             TTEMPREFNODE
*****************************************************************************}

    procedure tcgtemprefnode.pass_2;
      begin
        { check if the temp is valid }
        if not tempinfo^.valid then
          internalerror(200108231);
        { set the temp's location }
        location.loc := LOC_REFERENCE;
        location.reference := tempinfo^.ref;
      end;

{*****************************************************************************
                           TTEMPDELETENODE
*****************************************************************************}

    procedure tcgtempdeletenode.pass_2;
      begin
        ungetpersistanttempreference(tempinfo^.ref);
      end;


begin
   cnothingnode:=tcgnothingnode;
   casmnode:=tcgasmnode;
   cstatementnode:=tcgstatementnode;
   cblocknode:=tcgblocknode;
   ctempcreatenode:=tcgtempcreatenode;
   ctemprefnode:=tcgtemprefnode;
   ctempdeletenode:=tcgtempdeletenode;
end.
{
  $Log$
  Revision 1.6  2001-08-24 13:47:27  jonas
    * moved "reverseparameters" from ninl.pas to ncal.pas
    + support for non-persistent temps in ttempcreatenode.create, for use
      with typeconversion nodes

  Revision 1.5  2001/08/23 14:28:35  jonas
    + tempcreate/ref/delete nodes (allows the use of temps in the
      resulttype and first pass)
    * made handling of read(ln)/write(ln) processor independent
    * moved processor independent handling for str and reset/rewrite-typed
      from firstpass to resulttype pass
    * changed names of helpers in text.inc to be generic for use as
      compilerprocs + added "iocheck" directive for most of them
    * reading of ordinals is done by procedures instead of functions
      because otherwise FPC_IOCHECK overwrote the result before it could
      be stored elsewhere (range checking still works)
    * compilerprocs can now be used in the system unit before they are
      implemented
    * added note to errore.msg that booleans can't be read using read/readln

  Revision 1.4  2001/06/02 19:22:15  peter
    * refs count for relabeled asmsymbols fixed

  Revision 1.3  2001/05/18 22:31:06  peter
    * tasmnode.pass_2 is independent of cpu, moved to ncgbas
    * include ncgbas for independent nodes

  Revision 1.2  2001/04/13 01:22:08  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.1  2000/10/14 10:14:50  peter
    * moehrendorf oct 2000 rewrite

}
