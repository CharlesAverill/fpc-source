{
    $Id$
    Copyright (c) 1998-2000 by Jonas Maebe

    This unit implements the 80x86 implementation of optimized nodes

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
unit n386opt;

{$i defines.inc}

interface
uses node, nopt;

type
  ti386addsstringcharoptnode = class(taddsstringcharoptnode)
     function det_resulttype: tnode; override;
     function pass_1: tnode; override;
     procedure pass_2; override;
  end;

  ti386addsstringcsstringoptnode = class(taddsstringcsstringoptnode)
     { must be duplicated from ti386addnode :( }
     procedure pass_2; override;
  end;

implementation

uses pass_1, types, htypechk, cginfo, cgbase, cpubase, cga,
     tgobj, aasm, ncnv, ncon, pass_2, symdef, rgobj;


{*****************************************************************************
                             TI386ADDOPTNODE
*****************************************************************************}

function ti386addsstringcharoptnode.det_resulttype: tnode;
begin
  det_resulttype := nil;
  resulttypepass(left);
  resulttypepass(right);
  if codegenerror then
    exit;
  { update the curmaxlen field (before converting to a string!) }
  updatecurmaxlen;
  if not is_shortstring(left.resulttype.def) then
    inserttypeconv(left,cshortstringtype);
  resulttype:=left.resulttype;
end;


function ti386addsstringcharoptnode.pass_1: tnode;
begin
  pass_1 := nil;
  firstpass(left);
  firstpass(right);
  if codegenerror then
    exit;
  location.loc := LOC_CREFERENCE;
  if not is_constcharnode(right) then
    { it's not sure we need the register, but we can't know it here yet }
    calcregisters(self,2,0,0)
  else
    calcregisters(self,1,0,0);
end;


procedure ti386addsstringcharoptnode.pass_2;
var
  l: tasmlabel;
  href,href2 :  treference;
  hreg, lengthreg: tregister;
  checklength: boolean;
begin
  { first, we have to more or less replicate some code from }
  { ti386addnode.pass_2                                     }
  secondpass(left);
  if not(tg.istemp(left.location.reference) and
         (tg.getsizeoftemp(left.location.reference) = 256)) and
     not(nf_use_strconcat in flags) then
    begin
       tg.gettempofsizereference(exprasmlist,256,href);
       copyshortstring(href,left.location.reference,255,false,true);
       { release the registers }
       tg.ungetiftemp(exprasmlist,left.location.reference);
       { does not hurt: }
       location_reset(left.location,LOC_CREFERENCE,def_cgsize_ref(resulttype.def));
       left.location.reference:=href;
    end;
  secondpass(right);
  { special case for string := string + char (JM) }
  hreg := R_NO;

  { we have to load the char before checking the length, because we }
  { may need registers from the reference                           }

  { is it a constant char? }
  if not is_constcharnode(right) then
    { no, make sure it is in a register }
    if right.location.loc in [LOC_REFERENCE,LOC_CREFERENCE] then
      begin
        { free the registers of right }
        reference_release(exprasmlist,right.location.reference);
        { get register for the char }
        hreg := reg32toreg8(rg.getregisterint(exprasmlist));
        emit_ref_reg(A_MOV,S_B,right.location.reference,hreg);
       { I don't think a temp char exists, but it won't hurt (JM) }
       tg.ungetiftemp(exprasmlist,right.location.reference);
      end
    else hreg := right.location.register;

  { load the current string length }
  lengthreg := rg.getregisterint(exprasmlist);
  emit_ref_reg(A_MOVZX,S_BL,left.location.reference,lengthreg);

  { do we have to check the length ? }
  if tg.istemp(left.location.reference) then
    checklength := curmaxlen = 255
  else
    checklength := curmaxlen >= tstringdef(left.resulttype.def).len;
  if checklength then
    begin
      { is it already maximal? }
      getlabel(l);
      if tg.istemp(left.location.reference) then
        emit_const_reg(A_CMP,S_L,255,lengthreg)
      else
        emit_const_reg(A_CMP,S_L,tstringdef(left.resulttype.def).len,lengthreg);
      emitjmp(C_E,l);
    end;

  { no, so increase the length and add the new character }
  href2 := left.location.reference;

  { we need a new reference to store the character }
  { at the end of the string. Check if the base or }
  { index register is still free                   }
  if (href2.base <> R_NO) and
     (href2.index <> R_NO) then
    begin
      { they're not free, so add the base reg to       }
      { the string length (since the index can         }
      { have a scalefactor) and use lengthreg as base  }
      emit_reg_reg(A_ADD,S_L,href2.base,lengthreg);
      href2.base := lengthreg;
    end
  else
    { at least one is still free, so put EDI there }
    if href2.base = R_NO then
      href2.base := lengthreg
    else
      begin
        href2.index := lengthreg;
        href2.scalefactor := 1;
      end;
  { we need to be one position after the last char }
  inc(href2.offset);
  { store the character at the end of the string }
  if (right.nodetype <> ordconstn) then
    begin
      { no new_reference(href2) because it's only }
      { used once (JM)                            }
      emit_reg_ref(A_MOV,S_B,hreg,href2);
      rg.ungetregister(exprasmlist,hreg);
    end
  else
    emit_const_ref(A_MOV,S_B,tordconstnode(right).value,href2);
  { increase the string length }
  emit_reg(A_INC,S_B,reg32toreg8(lengthreg));
  emit_reg_ref(A_MOV,S_B,reg32toreg8(lengthreg),left.location.reference);
  rg.ungetregisterint(exprasmlist,lengthreg);
  if checklength then
    emitlab(l);
  location_copy(location,left.location);
end;

procedure ti386addsstringcsstringoptnode.pass_2;
var
  href: treference;
  pushedregs: tpushedsaved;
  regstopush: tregisterset;
begin
  { first, we have to more or less replicate some code from }
  { ti386addnode.pass_2                                     }
  secondpass(left);
  if not(tg.istemp(left.location.reference) and
         (tg.getsizeoftemp(left.location.reference) = 256)) and
     not(nf_use_strconcat in flags) then
    begin
       tg.gettempofsizereference(exprasmlist,256,href);
       copyshortstring(href,left.location.reference,255,false,true);
       { release the registers }
       tg.ungetiftemp(exprasmlist,left.location.reference);
       { does not hurt: }
       location_reset(left.location,LOC_CREFERENCE,def_cgsize_ref(resulttype.def));
       left.location.reference:=href;
    end;
  secondpass(right);
  { on the right we do not need the register anymore too }
  { Instead of releasing them already, simply do not }
  { push them (so the release is in the right place, }
  { because emitpushreferenceaddr doesn't need extra }
  { registers) (JM)                                  }
  regstopush := all_registers;
  remove_non_regvars_from_loc(right.location,regstopush);
  rg.saveusedregisters(exprasmlist,pushedregs,regstopush);
  { push the maximum possible length of the result }
  emitpushreferenceaddr(left.location.reference);
  { the optimizer can more easily put the          }
  { deallocations in the right place if it happens }
  { too early than when it happens too late (if    }
  { the pushref needs a "lea (..),edi; push edi")  }
  reference_release(exprasmlist,right.location.reference);
  emitpushreferenceaddr(right.location.reference);
  rg.saveregvars(exprasmlist,regstopush);
  emitcall('FPC_SHORTSTR_CONCAT');
  tg.ungetiftemp(exprasmlist,right.location.reference);
  maybe_loadself;
  rg.restoreusedregisters(exprasmlist,pushedregs);
  location_copy(location,left.location);
end;

begin
  caddsstringcharoptnode := ti386addsstringcharoptnode;
  caddsstringcsstringoptnode := ti386addsstringcsstringoptnode
end.

{
  $Log$
  Revision 1.8  2002-04-02 17:11:36  peter
    * tlocation,treference update
    * LOC_CONSTANT added for better constant handling
    * secondadd splitted in multiple routines
    * location_force_reg added for loading a location to a register
      of a specified size
    * secondassignment parses now first the right and then the left node
      (this is compatible with Kylix). This saves a lot of push/pop especially
      with string operations
    * adapted some routines to use the new cg methods

  Revision 1.7  2002/03/31 20:26:39  jonas
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

  Revision 1.6  2001/12/31 09:53:15  jonas
    * changed remaining "getregister32" calls to ":=rg.getregisterint(exprasmlist);"

  Revision 1.5  2001/08/26 13:37:00  florian
    * some cg reorganisation
    * some PPC updates

  Revision 1.4  2001/04/13 01:22:19  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.3  2001/04/02 21:20:38  peter
    * resulttype rewrite

  Revision 1.2  2001/01/06 19:12:31  jonas
    * fixed IE 10 (but code is less efficient now :( )

  Revision 1.1  2001/01/04 11:24:19  jonas
    + initial implementation (still needs to be made more modular)

}
