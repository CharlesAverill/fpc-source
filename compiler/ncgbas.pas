{
    $Id$
    Copyright (c) 2000-2002 by Florian Klaempfl

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

{$i fpcdefs.inc}

interface

    uses
       cpubase,
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
          { Changes the location of this temp to ref. Useful when assigning }
          { another temp to this one. The current location will be freed.   }
          { Can only be called in pass 2 (since earlier, the temp location  }
          { isn't known yet)                                                }
          procedure changelocation(const ref: treference);
       end;

       tcgtempdeletenode = class(ttempdeletenode)
          procedure pass_2;override;
       end;

  implementation

    uses
      globtype,systems,
      cutils,verbose,cpuinfo,
      aasmbase,aasmtai,aasmcpu,symsym,
      defutil,
      nflw,pass_2,
      cgbase,
      cgutils,cgobj,
      procinfo,
      tgobj
      ;

{*****************************************************************************
                                 TNOTHING
*****************************************************************************}

    procedure tcgnothingnode.pass_2;
      begin
         location_reset(location,LOC_VOID,OS_NO);

         { avoid an abstract rte }
      end;


{*****************************************************************************
                               TSTATEMENTNODE
*****************************************************************************}

    procedure tcgstatementnode.pass_2;
      var
         hp : tstatementnode;
      begin
         location_reset(location,LOC_VOID,OS_NO);

         hp:=self;
         while assigned(hp) do
          begin
            if assigned(hp.left) then
             begin
               secondpass(hp.left);
               { Compiler inserted blocks can return values }
               location_copy(hp.location,hp.left.location);
             end;
            hp:=tstatementnode(hp.right);
          end;
      end;


{*****************************************************************************
                               TASMNODE
*****************************************************************************}

    procedure tcgasmnode.pass_2;

      procedure ReLabel(var p:tasmsymbol);
        begin
          { Only relabel local tasmlabels }
          if (p.defbind = AB_LOCAL) and
             (p is tasmlabel) then
           begin
             if not assigned(p.altsymbol) then
               objectlibrary.GenerateAltSymbol(p);
             p:=p.altsymbol;
             p.increfs;
           end;
        end;

      procedure ResolveRef(var op:toper);
        var
          sym : tvarsym;
{$ifdef x86}
          scale : byte;
{$endif x86}
          getoffset : boolean;
          indexreg : tregister;
          sofs : longint;
        begin
          if (op.typ=top_local) then
            begin
              sofs:=op.localoper^.localsymofs;
              indexreg:=op.localoper^.localindexreg;
{$ifdef x86}
              scale:=op.localoper^.localscale;
{$endif x86}
              getoffset:=op.localoper^.localgetoffset;
              sym:=tvarsym(pointer(op.localoper^.localsym));
              case sym.localloc.loc of
                LOC_REFERENCE :
                  begin
                    if getoffset then
                      begin
                        if indexreg=NR_NO then
                          begin
                            op.typ:=top_const;
                            op.val:=aword(sym.localloc.reference.offset+sofs);
                          end
                        else
                          begin
                            op.typ:=top_ref;
                            new(op.ref);
                            reference_reset_base(op.ref^,indexreg,
                                sym.localloc.reference.offset+sofs);
                          end;
                      end
                    else
                      begin
                        op.typ:=top_ref;
                        new(op.ref);
                        reference_reset_base(op.ref^,sym.localloc.reference.index,
                            sym.localloc.reference.offset+sofs);
                        op.ref^.index:=indexreg;
{$ifdef x86}
                        op.ref^.scalefactor:=scale;
{$endif x86}
                      end;
                  end;
                LOC_REGISTER :
                  begin
                    if getoffset then
                      Message(asmr_e_invalid_reference_syntax);
                    { Subscribed access }
                    if sofs<>0 then
                      begin
                        op.typ:=top_ref;
                        new(op.ref);
                        reference_reset_base(op.ref^,sym.localloc.register,sofs);
                      end
                    else
                      begin
                        op.typ:=top_reg;
                        op.reg:=sym.localloc.register;
                      end;
                  end;
              end;
            end;
        end;

      var
        hp,hp2 : tai;
        i : longint;
        skipnode : boolean;
      begin
         location_reset(location,LOC_VOID,OS_NO);

         if getposition then
           begin
             { Add a marker, to be sure the list is not empty }
             exprasmlist.concat(tai_marker.create(marker_position));
             currenttai:=tai(exprasmlist.last);
             exit;
           end;

         { Allocate registers used in the assembler block }
         cg.allocexplicitregisters(exprasmlist,R_INTREGISTER,used_regs_int);

         if (current_procinfo.procdef.proccalloption=pocall_inline) then
           begin
             objectlibrary.CreateUsedAsmSymbolList;
             hp:=tai(p_asm.first);
             while assigned(hp) do
              begin
                hp2:=tai(hp.getcopy);
                skipnode:=false;
                case hp2.typ of
                  ait_label :
                     ReLabel(tasmsymbol(tai_label(hp2).l));
                  ait_const_rva,
                  ait_const_symbol :
                     ReLabel(tai_const_symbol(hp2).sym);
                  ait_instruction :
                     begin
                       { remove cached insentry, because the new code can
                         require an other less optimized instruction }
{$ifdef i386}
{$ifndef NOAG386BIN}
                       taicpu(hp2).ResetPass1;
{$endif}
{$endif}
                       { fixup the references }
                       for i:=1 to taicpu(hp2).ops do
                        begin
                          ResolveRef(taicpu(hp2).oper[i-1]^);
                          with taicpu(hp2).oper[i-1]^ do
                           begin
                             case typ of
                               top_ref :
                                 begin
                                   if assigned(ref^.symbol) then
                                     ReLabel(ref^.symbol);
                                   if assigned(ref^.relsymbol) then
                                     ReLabel(ref^.symbol);
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
                end;
                if not skipnode then
                  exprasmList.concat(hp2)
                else
                  hp2.free;
                hp:=tai(hp.next);
              end;
             { restore used symbols }
             objectlibrary.UsedAsmSymbolListResetAltSym;
             objectlibrary.DestroyUsedAsmSymbolList;
           end
         else
           begin
             hp:=tai(p_asm.first);
             while assigned(hp) do
              begin
                case hp.typ of
                  ait_instruction :
                     begin
                       { remove cached insentry, because the new code can
                         require an other less optimized instruction }
{$ifdef i386}
{$ifndef NOAG386BIN}
                       taicpu(hp).ResetPass1;
{$endif}
{$endif}
                       { fixup the references }
                       for i:=1 to taicpu(hp).ops do
                         ResolveRef(taicpu(hp).oper[i-1]^);
                     end;
                end;
                hp:=tai(hp.next);
              end;
             { insert the list }
             exprasmList.concatlist(p_asm);
           end;

         { Release register used in the assembler block }
         cg.deallocexplicitregisters(exprasmlist,R_INTREGISTER,used_regs_int);
       end;


{*****************************************************************************
                             TBLOCKNODE
*****************************************************************************}

    procedure tcgblocknode.pass_2;
      var
        hp : tstatementnode;
      begin
        location_reset(location,LOC_VOID,OS_NO);

        { do second pass on left node }
        if assigned(left) then
         begin
           hp:=tstatementnode(left);
           while assigned(hp) do
            begin
              if assigned(hp.left) then
               begin
                 secondpass(hp.left);
                 location_copy(hp.location,hp.left.location);
               end;
              location_copy(location,hp.location);
              hp:=tstatementnode(hp.right);
            end;
         end;
      end;

{*****************************************************************************
                          TTEMPCREATENODE
*****************************************************************************}

    procedure tcgtempcreatenode.pass_2;
      var
        cgsize: tcgsize;
      begin
        location_reset(location,LOC_VOID,OS_NO);

        { if we're secondpassing the same tcgtempcreatenode twice, we have a bug }
        if tempinfo^.valid then
          internalerror(200108222);

        { get a (persistent) temp }
        if tempinfo^.restype.def.needs_inittable then
          begin
            tg.GetTempTyped(exprasmlist,tempinfo^.restype.def,tempinfo^.temptype,tempinfo^.loc.ref);
            tempinfo^.loc.loc := LOC_REFERENCE;
          end
        else if may_be_in_reg then
          begin
            cgsize := def_cgsize(tempinfo^.restype.def);
            if (TCGSize2Size[cgsize]>TCGSize2Size[OS_INT]) then
              internalerror(2004020202);
            tempinfo^.loc.reg := cg.getintregister(exprasmlist,cgsize);
            if (tempinfo^.temptype = tt_persistent) then
              begin
                { !!tell rgobj this register is now a regvar, so it can't be freed!! }
                tempinfo^.loc.loc := LOC_CREGISTER
              end
            else
              tempinfo^.loc.loc := LOC_REGISTER;
          end
        else
          begin
            tg.GetTemp(exprasmlist,size,tempinfo^.temptype,tempinfo^.loc.ref);
            tempinfo^.loc.loc := LOC_REFERENCE;
          end;
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
        case tempinfo^.loc.loc of
          LOC_REFERENCE:
            begin
              { set the temp's location }
              location_reset(location,LOC_REFERENCE,def_cgsize(tempinfo^.restype.def));
              location.reference := tempinfo^.loc.ref;
              inc(location.reference.offset,offset);
            end;
          LOC_REGISTER,
          LOC_CREGISTER:
            begin
              if offset <> 0 then
                internalerror(2004020205);
              { LOC_CREGISTER, not LOC_REGISTER, otherwise we can't assign anything to it }
              location_reset(location,tempinfo^.loc.loc,def_cgsize(tempinfo^.restype.def));
              location.register := tempinfo^.loc.reg;
            end;
          else
            internalerror(2004020204);
        end;
      end;


    procedure tcgtemprefnode.changelocation(const ref: treference);
      begin
        { check if the temp is valid }
        if not tempinfo^.valid then
          internalerror(200306081);
        if (tempinfo^.loc.loc = LOC_REGISTER) then
          internalerror(2004020203);
        if (tempinfo^.temptype = tt_persistent) then
          tg.ChangeTempType(exprasmlist,tempinfo^.loc.ref,tt_normal);
        tg.ungettemp(exprasmlist,tempinfo^.loc.ref);
        tempinfo^.loc.ref := ref;
        tg.ChangeTempType(exprasmlist,tempinfo^.loc.ref,tempinfo^.temptype);
        { adapt location }
        location.reference := ref;
        inc(location.reference.offset,offset);
      end;


{*****************************************************************************
                           TTEMPDELETENODE
*****************************************************************************}

    procedure tcgtempdeletenode.pass_2;
      begin
        location_reset(location,LOC_VOID,OS_NO);

        case tempinfo^.loc.loc of
          LOC_REFERENCE:
            begin
              if release_to_normal then
                tg.ChangeTempType(exprasmlist,tempinfo^.loc.ref,tt_normal)
              else
                tg.UnGetTemp(exprasmlist,tempinfo^.loc.ref);
            end;
          LOC_CREGISTER,
          LOC_REGISTER:
            begin
              { make sure the register allocator doesn't reuse the }
              { register e.g. in the middle of a loop              }
              cg.a_load_reg_reg(exprasmlist,OS_INT,OS_INT,tempinfo^.loc.reg,
                tempinfo^.loc.reg);
              if release_to_normal then
                tempinfo^.loc.loc := LOC_REGISTER
              else
                { !!tell rgobj this register is no longer a regvar!! }
                cg.ungetregister(exprasmlist,tempinfo^.loc.reg);
            end;
        end;
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
  Revision 1.56  2004-02-27 10:21:05  florian
    * top_symbol killed
    + refaddr to treference added
    + refsymbol to treference added
    * top_local stuff moved to an extra record to save memory
    + aint introduced
    * tppufile.get/putint64/aint implemented

  Revision 1.55  2004/02/04 18:45:29  jonas
    + some more usage of register temps

  Revision 1.54  2004/02/03 19:48:06  jonas
    * fixed and re-enabled temps in registers

  Revision 1.53  2004/02/03 17:55:50  jonas
    * cleanup

  Revision 1.52  2004/02/03 16:46:51  jonas
    + support to store ttempcreate/ref/deletenodes in registers
    * put temps for withnodes and some newnodes in registers
     Note: this currently only works because calling ungetregister()
       multiple times for the same register doesn't matter. We need again
       a way to specify that a register is currently a regvar and as such
       should not be freed when you call ungetregister() on it.

  Revision 1.51  2003/11/07 15:58:32  florian
    * Florian's culmutative nr. 1; contains:
      - invalid calling conventions for a certain cpu are rejected
      - arm softfloat calling conventions
      - -Sp for cpu dependend code generation
      - several arm fixes
      - remaining code for value open array paras on heap

  Revision 1.50  2003/11/04 15:35:13  peter
    * fix for referencecounted temps

  Revision 1.49  2003/11/02 13:30:05  jonas
    * fixed ppc compilation

  Revision 1.48  2003/10/30 19:59:00  peter
    * support scalefactor for opr_local
    * support reference with opr_local set, fixes tw2631

  Revision 1.47  2003/10/29 15:40:20  peter
    * support indexing and offset retrieval for locals

  Revision 1.46  2003/10/24 17:39:41  peter
    * asmnode.get_position now inserts a marker

  Revision 1.45  2003/10/21 15:15:36  peter
    * taicpu_abstract.oper[] changed to pointers

  Revision 1.44  2003/10/10 17:48:13  peter
    * old trgobj moved to x86/rgcpu and renamed to trgx86fpu
    * tregisteralloctor renamed to trgobj
    * removed rgobj from a lot of units
    * moved location_* and reference_* to cgobj
    * first things for mmx register allocation

  Revision 1.43  2003/10/09 21:31:37  daniel
    * Register allocator splitted, ans abstract now

  Revision 1.42  2003/10/07 18:18:16  peter
    * fix register calling for assembler procedures
    * fix result loading for assembler procedures

  Revision 1.41  2003/10/01 20:34:48  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.40  2003/09/23 17:56:05  peter
    * locals and paras are allocated in the code generation
    * tvarsym.localloc contains the location of para/local when
      generating code for the current procedure

  Revision 1.39  2003/09/07 22:09:35  peter
    * preparations for different default calling conventions
    * various RA fixes

  Revision 1.38  2003/09/03 15:55:00  peter
    * NEWRA branch merged

  Revision 1.37.2.1  2003/08/27 20:23:55  peter
    * remove old ra code

  Revision 1.37  2003/06/13 21:19:30  peter
    * current_procdef removed, use current_procinfo.procdef instead

  Revision 1.36  2003/06/09 18:26:46  peter
    * remove temptype, use tempinfo.temptype instead

  Revision 1.35  2003/06/09 12:20:47  peter
    * getposition added to retrieve the the current tai item

  Revision 1.34  2003/05/17 13:30:08  jonas
    * changed tt_persistant to tt_persistent :)
    * tempcreatenode now doesn't accept a boolean anymore for persistent
      temps, but a ttemptype, so you can also create ansistring temps etc

  Revision 1.33  2003/04/27 11:21:33  peter
    * aktprocdef renamed to current_procinfo.procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.32  2002/04/25 20:15:39  florian
    * block nodes within expressions shouldn't release the used registers,
      fixed using a flag till the new rg is ready

  Revision 1.31  2003/04/22 23:50:22  peter
    * firstpass uses expectloc
    * checks if there are differences between the expectloc and
      location.loc from secondpass in EXTDEBUG

  Revision 1.30  2003/04/17 07:50:24  daniel
    * Some work on interference graph construction

  Revision 1.29  2003/03/28 19:16:56  peter
    * generic constructor working for i386
    * remove fixed self register
    * esi added as address register for i386

  Revision 1.28  2002/11/27 15:33:19  peter
    * fixed relabeling to relabel only tasmlabel (formerly proclocal)

  Revision 1.27  2002/11/27 02:37:13  peter
    * case statement inlining added
    * fixed inlining of write()
    * switched statementnode left and right parts so the statements are
      processed in the correct order when getcopy is used. This is
      required for tempnodes

  Revision 1.26  2002/11/17 16:31:56  carl
    * memory optimization (3-4%) : cleanup of tai fields,
       cleanup of tdef and tsym fields.
    * make it work for m68k

  Revision 1.25  2002/11/15 16:29:30  peter
    * made tasmsymbol.refs private (merged)

  Revision 1.24  2002/11/15 01:58:51  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.23  2002/08/23 16:14:48  peter
    * tempgen cleanup
    * tt_noreuse temp type added that will be used in genentrycode

  Revision 1.22  2002/08/11 14:32:26  peter
    * renamed current_library to objectlibrary

  Revision 1.21  2002/08/11 13:24:11  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.20  2002/07/01 18:46:22  peter
    * internal linker
    * reorganized aasm layer

  Revision 1.19  2002/05/18 13:34:09  peter
    * readded missing revisions

  Revision 1.18  2002/05/16 19:46:37  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.16  2002/05/13 19:54:37  peter
    * removed n386ld and n386util units
    * maybe_save/maybe_restore added instead of the old maybe_push

  Revision 1.15  2002/05/12 16:53:07  peter
    * moved entry and exitcode to ncgutil and cgobj
    * foreach gets extra argument for passing local data to the
      iterator function
    * -CR checks also class typecasts at runtime by changing them
      into as
    * fixed compiler to cycle with the -CR option
    * fixed stabs with elf writer, finally the global variables can
      be watched
    * removed a lot of routines from cga unit and replaced them by
      calls to cgobj
    * u32bit-s32bit updates for and,or,xor nodes. When one element is
      u32bit then the other is typecasted also to u32bit without giving
      a rangecheck warning/error.
    * fixed pascal calling method with reversing also the high tree in
      the parast, detected by tcalcst3 test

  Revision 1.14  2002/04/23 19:16:34  peter
    * add pinline unit that inserts compiler supported functions using
      one or more statements
    * moved finalize and setlength from ninl to pinline

  Revision 1.13  2002/04/21 19:02:03  peter
    * removed newn and disposen nodes, the code is now directly
      inlined from pexpr
    * -an option that will write the secondpass nodes to the .s file, this
      requires EXTDEBUG define to actually write the info
    * fixed various internal errors and crashes due recent code changes

  Revision 1.12  2002/04/04 19:05:57  peter
    * removed unused units
    * use tlocation.size in cg.a_*loc*() routines

  Revision 1.11  2002/03/31 20:26:34  jonas
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

}
