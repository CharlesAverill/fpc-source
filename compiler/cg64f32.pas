{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl
    Member of the Free Pascal development team

    This unit implements the code generation for 64 bit int
    arithmethics on 32 bit processors

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
{# This unit implements the code generation for 64 bit int arithmethics on
   32 bit processors.
}
unit cg64f32;

  {$i fpcdefs.inc}

  interface

    uses
       aasmbase,aasmtai,aasmcpu,
       cpuinfo,cpubase,cpupara,
       cgbase,cgobj,parabase,
       node,symtype
{$ifdef delphi}
       ,dmisc
{$endif}
       ;

    type
      {# Defines all the methods required on 32-bit processors
         to handle 64-bit integers.
      }
      tcg64f32 = class(tcg64)
        procedure a_load64_const_ref(list : taasmoutput;value : int64;const ref : treference);override;
        procedure a_load64_reg_ref(list : taasmoutput;reg : tregister64;const ref : treference);override;
        procedure a_load64_ref_reg(list : taasmoutput;const ref : treference;reg : tregister64);override;
        procedure a_load64_reg_reg(list : taasmoutput;regsrc,regdst : tregister64);override;
        procedure a_load64_const_reg(list : taasmoutput;value: int64;reg : tregister64);override;
        procedure a_load64_loc_reg(list : taasmoutput;const l : tlocation;reg : tregister64);override;
        procedure a_load64_loc_ref(list : taasmoutput;const l : tlocation;const ref : treference);override;
        procedure a_load64_const_loc(list : taasmoutput;value : int64;const l : tlocation);override;
        procedure a_load64_reg_loc(list : taasmoutput;reg : tregister64;const l : tlocation);override;

        procedure a_load64high_reg_ref(list : taasmoutput;reg : tregister;const ref : treference);override;
        procedure a_load64low_reg_ref(list : taasmoutput;reg : tregister;const ref : treference);override;
        procedure a_load64high_ref_reg(list : taasmoutput;const ref : treference;reg : tregister);override;
        procedure a_load64low_ref_reg(list : taasmoutput;const ref : treference;reg : tregister);override;
        procedure a_load64high_loc_reg(list : taasmoutput;const l : tlocation;reg : tregister);override;
        procedure a_load64low_loc_reg(list : taasmoutput;const l : tlocation;reg : tregister);override;

        procedure a_op64_ref_reg(list : taasmoutput;op:TOpCG;const ref : treference;reg : tregister64);override;
        procedure a_op64_reg_ref(list : taasmoutput;op:TOpCG;reg : tregister64; const ref: treference);override;
        procedure a_op64_const_loc(list : taasmoutput;op:TOpCG;value : int64;const l: tlocation);override;
        procedure a_op64_reg_loc(list : taasmoutput;op:TOpCG;reg : tregister64;const l : tlocation);override;
        procedure a_op64_loc_reg(list : taasmoutput;op:TOpCG;const l : tlocation;reg : tregister64);override;
        procedure a_op64_const_ref(list : taasmoutput;op:TOpCG;value : int64;const ref : treference);override;

        procedure a_param64_reg(list : taasmoutput;reg : tregister64;const paraloc : tcgpara);override;
        procedure a_param64_const(list : taasmoutput;value : int64;const paraloc : tcgpara);override;
        procedure a_param64_ref(list : taasmoutput;const r : treference;const paraloc : tcgpara);override;
        procedure a_param64_loc(list : taasmoutput;const l : tlocation;const paraloc : tcgpara);override;

        {# This routine tries to optimize the a_op64_const_reg operation, by
           removing superfluous opcodes. Returns TRUE if normal processing
           must continue in op64_const_reg, otherwise, everything is processed
           entirely in this routine, by emitting the appropriate 32-bit opcodes.
        }
        function optimize64_op_const_reg(list: taasmoutput; var op: topcg; var a : int64; var reg: tregister64): boolean;override;

        procedure g_rangecheck64(list: taasmoutput; const l:tlocation;fromdef,todef: tdef); override;
      end;

    {# Creates a tregister64 record from 2 32 Bit registers. }
    function joinreg64(reglo,reghi : tregister) : tregister64;

  implementation

    uses
       globtype,systems,
       verbose,
       symbase,symconst,symdef,defutil,paramgr;

{****************************************************************************
                                     Helpers
****************************************************************************}

    function joinreg64(reglo,reghi : tregister) : tregister64;
      begin
         result.reglo:=reglo;
         result.reghi:=reghi;
      end;


    procedure swap64(var q : int64);
      begin
         q:=(int64(lo(q)) shl 32) or hi(q);
      end;


    procedure splitparaloc64(const cgpara:tcgpara;var cgparalo,cgparahi:tcgpara);
      var
        paraloclo,
        paralochi : pcgparalocation;
      begin
        if not(cgpara.size in [OS_64,OS_S64]) then
          internalerror(200408231);
        if not assigned(cgpara.location) then
          internalerror(200408201);
        { init lo/hi para }
        cgparahi.reset;
        if cgpara.size=OS_S64 then
          cgparahi.size:=OS_S32
        else
          cgparahi.size:=OS_32;
        cgparahi.alignment:=cgpara.alignment;
        paralochi:=cgparahi.add_location;
        cgparalo.reset;
        cgparalo.size:=OS_32;
        cgparalo.alignment:=cgpara.alignment;
        paraloclo:=cgparalo.add_location;
        { 2 parameter fields? }
        if assigned(cgpara.location^.next) then
          begin
            if target_info.endian = endian_big then
              begin
                { low is in second location }
                move(cgpara.location^.next^,paraloclo^,sizeof(paraloclo^));
                move(cgpara.location^,paralochi^,sizeof(paralochi^));
              end
            else
              begin
                { low is in first location }
                move(cgpara.location^,paraloclo^,sizeof(paraloclo^));
                move(cgpara.location^.next^,paralochi^,sizeof(paralochi^));
              end;
          end
        else
          begin
            { single parameter, this can only be in memory }
            if cgpara.location^.loc<>LOC_REFERENCE then
              internalerror(200408282);
            move(cgpara.location^,paraloclo^,sizeof(paraloclo^));
            move(cgpara.location^,paralochi^,sizeof(paralochi^));
            { for big endian low is at +4, for little endian high }
            if target_info.endian = endian_big then
              inc(cgparalo.location^.reference.offset,tcgsize2size[cgparahi.size])
            else
              inc(cgparahi.location^.reference.offset,tcgsize2size[cgparalo.size]);
          end;
        { fix size }
        paraloclo^.size:=cgparalo.size;
        paraloclo^.next:=nil;
        paralochi^.size:=cgparahi.size;
        paralochi^.next:=nil;
      end;


{****************************************************************************
                                   TCG64F32
****************************************************************************}

    procedure tcg64f32.a_load64_reg_ref(list : taasmoutput;reg : tregister64;const ref : treference);
      var
        tmpreg: tregister;
        tmpref: treference;
      begin
        if target_info.endian = endian_big then
          begin
            tmpreg:=reg.reglo;
            reg.reglo:=reg.reghi;
            reg.reghi:=tmpreg;
          end;
        cg.a_load_reg_ref(list,OS_32,OS_32,reg.reglo,ref);
        tmpref := ref;
        inc(tmpref.offset,4);
        cg.a_load_reg_ref(list,OS_32,OS_32,reg.reghi,tmpref);
      end;


    procedure tcg64f32.a_load64_const_ref(list : taasmoutput;value : int64;const ref : treference);
      var
        tmpref: treference;
      begin
        if target_info.endian = endian_big then
          swap64(value);
        cg.a_load_const_ref(list,OS_32,aint(lo(value)),ref);
        tmpref := ref;
        inc(tmpref.offset,4);
        cg.a_load_const_ref(list,OS_32,aint(hi(value)),tmpref);
      end;


    procedure tcg64f32.a_load64_ref_reg(list : taasmoutput;const ref : treference;reg : tregister64);
      var
        tmpreg: tregister;
        tmpref: treference;
      begin
        if target_info.endian = endian_big then
          begin
            tmpreg := reg.reglo;
            reg.reglo := reg.reghi;
            reg.reghi := tmpreg;
          end;
        tmpref := ref;
        if (tmpref.base=reg.reglo) then
         begin
           tmpreg:=cg.getaddressregister(list);
           cg.a_load_reg_reg(list,OS_ADDR,OS_ADDR,tmpref.base,tmpreg);
           tmpref.base:=tmpreg;
         end
        else
         { this works only for the i386, thus the i386 needs to override  }
         { this method and this method must be replaced by a more generic }
         { implementation FK                                              }
         if (tmpref.index=reg.reglo) then
          begin
            tmpreg:=cg.getaddressregister(list);
            cg.a_load_reg_reg(list,OS_ADDR,OS_ADDR,tmpref.index,tmpreg);
            tmpref.index:=tmpreg;
          end;
        cg.a_load_ref_reg(list,OS_32,OS_32,tmpref,reg.reglo);
        inc(tmpref.offset,4);
        cg.a_load_ref_reg(list,OS_32,OS_32,tmpref,reg.reghi);
      end;


    procedure tcg64f32.a_load64_reg_reg(list : taasmoutput;regsrc,regdst : tregister64);

      begin
        cg.a_load_reg_reg(list,OS_32,OS_32,regsrc.reglo,regdst.reglo);
        cg.a_load_reg_reg(list,OS_32,OS_32,regsrc.reghi,regdst.reghi);
      end;


    procedure tcg64f32.a_load64_const_reg(list : taasmoutput;value : int64;reg : tregister64);

      begin
        cg.a_load_const_reg(list,OS_32,aint(lo(value)),reg.reglo);
        cg.a_load_const_reg(list,OS_32,aint(hi(value)),reg.reghi);
      end;


    procedure tcg64f32.a_load64_loc_reg(list : taasmoutput;const l : tlocation;reg : tregister64);

      begin
        case l.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_load64_ref_reg(list,l.reference,reg);
          LOC_REGISTER,LOC_CREGISTER:
            a_load64_reg_reg(list,l.register64,reg);
          LOC_CONSTANT :
            a_load64_const_reg(list,l.value64,reg);
          else
            internalerror(200112292);
        end;
      end;


    procedure tcg64f32.a_load64_loc_ref(list : taasmoutput;const l : tlocation;const ref : treference);
      begin
        case l.loc of
          LOC_REGISTER,LOC_CREGISTER:
            a_load64_reg_ref(list,l.register64,ref);
          LOC_CONSTANT :
            a_load64_const_ref(list,l.value64,ref);
          else
            internalerror(200203288);
        end;
      end;


    procedure tcg64f32.a_load64_const_loc(list : taasmoutput;value : int64;const l : tlocation);

      begin
        case l.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_load64_const_ref(list,value,l.reference);
          LOC_REGISTER,LOC_CREGISTER:
            a_load64_const_reg(list,value,l.register64);
          else
            internalerror(200112293);
        end;
      end;


    procedure tcg64f32.a_load64_reg_loc(list : taasmoutput;reg : tregister64;const l : tlocation);

      begin
        case l.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_load64_reg_ref(list,reg,l.reference);
          LOC_REGISTER,LOC_CREGISTER:
            a_load64_reg_reg(list,reg,l.register64);
          else
            internalerror(200112293);
        end;
      end;


    procedure tcg64f32.a_load64high_reg_ref(list : taasmoutput;reg : tregister;const ref : treference);
      var
        tmpref: treference;
      begin
        if target_info.endian = endian_big then
          cg.a_load_reg_ref(list,OS_32,OS_32,reg,ref)
        else
          begin
            tmpref := ref;
            inc(tmpref.offset,4);
            cg.a_load_reg_ref(list,OS_32,OS_32,reg,tmpref)
          end;
      end;

    procedure tcg64f32.a_load64low_reg_ref(list : taasmoutput;reg : tregister;const ref : treference);
      var
        tmpref: treference;
      begin
        if target_info.endian = endian_little then
          cg.a_load_reg_ref(list,OS_32,OS_32,reg,ref)
        else
          begin
            tmpref := ref;
            inc(tmpref.offset,4);
            cg.a_load_reg_ref(list,OS_32,OS_32,reg,tmpref)
          end;
      end;


    procedure tcg64f32.a_load64high_ref_reg(list : taasmoutput;const ref : treference;reg : tregister);
      var
        tmpref: treference;
      begin
        if target_info.endian = endian_big then
          cg.a_load_ref_reg(list,OS_32,OS_32,ref,reg)
        else
          begin
            tmpref := ref;
            inc(tmpref.offset,4);
            cg.a_load_ref_reg(list,OS_32,OS_32,tmpref,reg)
          end;
      end;


    procedure tcg64f32.a_load64low_ref_reg(list : taasmoutput;const ref : treference;reg : tregister);
      var
        tmpref: treference;
      begin
        if target_info.endian = endian_little then
          cg.a_load_ref_reg(list,OS_32,OS_32,ref,reg)
        else
          begin
            tmpref := ref;
            inc(tmpref.offset,4);
            cg.a_load_ref_reg(list,OS_32,OS_32,tmpref,reg)
          end;
      end;


    procedure tcg64f32.a_load64low_loc_reg(list : taasmoutput;const l : tlocation;reg : tregister);
      begin
        case l.loc of
          LOC_REFERENCE,
          LOC_CREFERENCE :
            a_load64low_ref_reg(list,l.reference,reg);
          LOC_REGISTER :
            cg.a_load_reg_reg(list,OS_32,OS_32,l.registerlow,reg);
          LOC_CONSTANT :
            cg.a_load_const_reg(list,OS_32,aint(lo(l.value64)),reg);
          else
            internalerror(200203244);
        end;
      end;


    procedure tcg64f32.a_load64high_loc_reg(list : taasmoutput;const l : tlocation;reg : tregister);
      begin
        case l.loc of
          LOC_REFERENCE,
          LOC_CREFERENCE :
            a_load64high_ref_reg(list,l.reference,reg);
          LOC_REGISTER :
            cg.a_load_reg_reg(list,OS_32,OS_32,l.registerhigh,reg);
          LOC_CONSTANT :
            cg.a_load_const_reg(list,OS_32,hi(l.value64),reg);
          else
            internalerror(200203244);
        end;
      end;


    procedure tcg64f32.a_op64_const_loc(list : taasmoutput;op:TOpCG;value : int64;const l: tlocation);
      begin
        case l.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_op64_const_ref(list,op,value,l.reference);
          LOC_REGISTER,LOC_CREGISTER:
            a_op64_const_reg(list,op,value,l.register64);
          else
            internalerror(200203292);
        end;
      end;


    procedure tcg64f32.a_op64_reg_loc(list : taasmoutput;op:TOpCG;reg : tregister64;const l : tlocation);
      begin
        case l.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_op64_reg_ref(list,op,reg,l.reference);
          LOC_REGISTER,LOC_CREGISTER:
            a_op64_reg_reg(list,op,reg,l.register64);
          else
            internalerror(2002032422);
        end;
      end;



    procedure tcg64f32.a_op64_loc_reg(list : taasmoutput;op:TOpCG;const l : tlocation;reg : tregister64);
      begin
        case l.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_op64_ref_reg(list,op,l.reference,reg);
          LOC_REGISTER,LOC_CREGISTER:
            a_op64_reg_reg(list,op,l.register64,reg);
          LOC_CONSTANT :
            a_op64_const_reg(list,op,l.value64,reg);
          else
            internalerror(200203242);
        end;
      end;


    procedure tcg64f32.a_op64_ref_reg(list : taasmoutput;op:TOpCG;const ref : treference;reg : tregister64);
      var
        tempreg: tregister64;
      begin
        tempreg.reghi:=cg.getintregister(list,OS_32);
        tempreg.reglo:=cg.getintregister(list,OS_32);
        a_load64_ref_reg(list,ref,tempreg);
        a_op64_reg_reg(list,op,tempreg,reg);
      end;


    procedure tcg64f32.a_op64_reg_ref(list : taasmoutput;op:TOpCG;reg : tregister64; const ref: treference);
      var
        tempreg: tregister64;
      begin
        tempreg.reghi:=cg.getintregister(list,OS_32);
        tempreg.reglo:=cg.getintregister(list,OS_32);
        a_load64_ref_reg(list,ref,tempreg);
        a_op64_reg_reg(list,op,reg,tempreg);
        a_load64_reg_ref(list,tempreg,ref);
      end;


    procedure tcg64f32.a_op64_const_ref(list : taasmoutput;op:TOpCG;value : int64;const ref : treference);
      var
        tempreg: tregister64;
      begin
        tempreg.reghi:=cg.getintregister(list,OS_32);
        tempreg.reglo:=cg.getintregister(list,OS_32);
        a_load64_ref_reg(list,ref,tempreg);
        a_op64_const_reg(list,op,value,tempreg);
        a_load64_reg_ref(list,tempreg,ref);
      end;


    procedure tcg64f32.a_param64_reg(list : taasmoutput;reg : tregister64;const paraloc : tcgpara);
      var
        tmplochi,tmploclo: tcgpara;
      begin
        tmploclo.init;
        tmplochi.init;
        splitparaloc64(paraloc,tmploclo,tmplochi);
        cg.a_param_reg(list,OS_32,reg.reghi,tmplochi);
        cg.a_param_reg(list,OS_32,reg.reglo,tmploclo);
        tmploclo.done;
        tmplochi.done;
      end;


    procedure tcg64f32.a_param64_const(list : taasmoutput;value : int64;const paraloc : tcgpara);
      var
        tmplochi,tmploclo: tcgpara;
      begin
        tmploclo.init;
        tmplochi.init;
        splitparaloc64(paraloc,tmploclo,tmplochi);
        cg.a_param_const(list,OS_32,aint(hi(value)),tmplochi);
        cg.a_param_const(list,OS_32,aint(lo(value)),tmploclo);
        tmploclo.done;
        tmplochi.done;
      end;


    procedure tcg64f32.a_param64_ref(list : taasmoutput;const r : treference;const paraloc : tcgpara);
      var
        tmprefhi,tmpreflo : treference;
        tmploclo,tmplochi : tcgpara;
      begin
        tmploclo.init;
        tmplochi.init;
        splitparaloc64(paraloc,tmploclo,tmplochi);
        tmprefhi:=r;
        tmpreflo:=r;
        if target_info.endian=endian_big then
          inc(tmpreflo.offset,4)
        else
          inc(tmprefhi.offset,4);
        cg.a_param_ref(list,OS_32,tmprefhi,tmplochi);
        cg.a_param_ref(list,OS_32,tmpreflo,tmploclo);
        tmploclo.done;
        tmplochi.done;
      end;


    procedure tcg64f32.a_param64_loc(list : taasmoutput;const l:tlocation;const paraloc : tcgpara);
      begin
        case l.loc of
          LOC_REGISTER,
          LOC_CREGISTER :
            a_param64_reg(list,l.register64,paraloc);
          LOC_CONSTANT :
            a_param64_const(list,l.value64,paraloc);
          LOC_CREFERENCE,
          LOC_REFERENCE :
            a_param64_ref(list,l.reference,paraloc);
          else
            internalerror(200203287);
        end;
      end;


    procedure tcg64f32.g_rangecheck64(list : taasmoutput;const l:tlocation;fromdef,todef:tdef);

      var
        neglabel,
        poslabel,
        endlabel: tasmlabel;
        hreg   : tregister;
        hdef   :  torddef;
        opsize   : tcgsize;
        oldregisterdef: boolean;
        from_signed,to_signed: boolean;
        temploc : tlocation;

      begin
         from_signed := is_signed(fromdef);
         to_signed := is_signed(todef);

         if not is_64bit(todef) then
           begin
             oldregisterdef := registerdef;
             registerdef := false;

             { get the high dword in a register }
             if l.loc in [LOC_REGISTER,LOC_CREGISTER] then
               begin
                 hreg := l.registerhigh;
               end
             else
               begin
                 hreg:=cg.getintregister(list,OS_32);
                 a_load64high_ref_reg(list,l.reference,hreg);
               end;
             objectlibrary.getlabel(poslabel);

             { check high dword, must be 0 (for positive numbers) }
             cg.a_cmp_const_reg_label(list,OS_32,OC_EQ,0,hreg,poslabel);

             { It can also be $ffffffff, but only for negative numbers }
             if from_signed and to_signed then
               begin
                 objectlibrary.getlabel(neglabel);
                 cg.a_cmp_const_reg_label(list,OS_32,OC_EQ,-1,hreg,neglabel);
               end;
             { For all other values we have a range check error }
             cg.a_call_name(list,'FPC_RANGEERROR');

             { if the high dword = 0, the low dword can be considered a }
             { simple cardinal                                          }
             cg.a_label(list,poslabel);
             hdef:=torddef.create(u32bit,0,$ffffffff);

             location_copy(temploc,l);
             temploc.size:=OS_32;

             if (temploc.loc in [LOC_REFERENCE,LOC_CREFERENCE]) and
                (target_info.endian = endian_big) then
               inc(temploc.reference.offset,4);

             cg.g_rangecheck(list,temploc,hdef,todef);
             hdef.free;

             if from_signed and to_signed then
               begin
                 objectlibrary.getlabel(endlabel);
                 cg.a_jmp_always(list,endlabel);
                 { if the high dword = $ffffffff, then the low dword (when }
                 { considered as a longint) must be < 0                    }
                 cg.a_label(list,neglabel);
                 if l.loc in [LOC_REGISTER,LOC_CREGISTER] then
                   begin
                     hreg := l.registerlow;
                   end
                 else
                   begin
                     hreg:=cg.getintregister(list,OS_32);
                     a_load64low_ref_reg(list,l.reference,hreg);
                   end;
                 { get a new neglabel (JM) }
                 objectlibrary.getlabel(neglabel);
                 cg.a_cmp_const_reg_label(list,OS_32,OC_LT,0,hreg,neglabel);

                 cg.a_call_name(list,'FPC_RANGEERROR');

                 { if we get here, the 64bit value lies between }
                 { longint($80000000) and -1 (JM)               }
                 cg.a_label(list,neglabel);
                 hdef:=torddef.create(s32bit,longint($80000000),-1);
                 location_copy(temploc,l);
                 temploc.size:=OS_32;
                 cg.g_rangecheck(list,temploc,hdef,todef);
                 hdef.free;
                 cg.a_label(list,endlabel);
               end;
             registerdef := oldregisterdef;
           end
         else
           { todef = 64bit int }
           { no 64bit subranges supported, so only a small check is necessary }

           { if both are signed or both are unsigned, no problem! }
           if (from_signed xor to_signed) and
              { also not if the fromdef is unsigned and < 64bit, since that will }
              { always fit in a 64bit int (todef is 64bit)                       }
              (from_signed or
               (torddef(fromdef).typ = u64bit)) then
             begin
               { in all cases, there is only a problem if the higest bit is set }
               if l.loc in [LOC_REGISTER,LOC_CREGISTER] then
                 begin
                   if is_64bit(fromdef) then
                     begin
                       hreg := l.registerhigh;
                       opsize := OS_32;
                     end
                   else
                     begin
                       hreg := l.register;
                       opsize := def_cgsize(fromdef);
                     end;
                 end
               else
                 begin
                   hreg:=cg.getintregister(list,OS_32);

                   opsize := def_cgsize(fromdef);
                   if opsize in [OS_64,OS_S64] then
                     a_load64high_ref_reg(list,l.reference,hreg)
                   else
                     cg.a_load_ref_reg(list,opsize,OS_32,l.reference,hreg);
                 end;
               objectlibrary.getlabel(poslabel);
               cg.a_cmp_const_reg_label(list,opsize,OC_GTE,0,hreg,poslabel);

               cg.a_call_name(list,'FPC_RANGEERROR');
               cg.a_label(list,poslabel);
             end;
      end;


    function tcg64f32.optimize64_op_const_reg(list: taasmoutput; var op: topcg; var a : int64; var reg: tregister64): boolean;
      var
        lowvalue, highvalue : longint;
        hreg: tregister;
      begin
        lowvalue := longint(a);
        highvalue:= longint(a shr 32);
        { assume it will be optimized out }
        optimize64_op_const_reg := true;
        case op of
        OP_ADD:
           begin
             if a = 0 then
                exit;
           end;
        OP_AND:
           begin
              if lowvalue <> -1 then
                cg.a_op_const_reg(list,op,OS_32,lowvalue,reg.reglo);
              if highvalue <> -1 then
                cg.a_op_const_reg(list,op,OS_32,highvalue,reg.reghi);
              { already emitted correctly }
              exit;
           end;
        OP_OR:
           begin
              if lowvalue <> 0 then
                cg.a_op_const_reg(list,op,OS_32,lowvalue,reg.reglo);
              if highvalue <> 0 then
                cg.a_op_const_reg(list,op,OS_32,highvalue,reg.reghi);
              { already emitted correctly }
              exit;
           end;
        OP_SUB:
           begin
             if a = 0 then
                exit;
           end;
        OP_XOR:
           begin
           end;
        OP_SHL:
           begin
             if a = 0 then
                 exit;
             { simply clear low-register
               and shift the rest and swap
               registers.
             }
             if (a > 31) then
               begin
                 cg.a_load_const_reg(list,OS_32,0,reg.reglo);
                 cg.a_op_const_reg(list,OP_SHL,OS_32,a mod 32,reg.reghi);
                 { swap the registers }
                 hreg := reg.reghi;
                 reg.reghi := reg.reglo;
                 reg.reglo := hreg;
                 exit;
               end;
           end;
        OP_SHR:
           begin
             if a = 0 then exit;
             { simply clear high-register
               and shift the rest and swap
               registers.
             }
             if (a > 31) then
               begin
                 cg.a_load_const_reg(list,OS_32,0,reg.reghi);
                 cg.a_op_const_reg(list,OP_SHL,OS_32,a mod 32,reg.reglo);
                 { swap the registers }
                 hreg := reg.reghi;
                 reg.reghi := reg.reglo;
                 reg.reglo := hreg;
                 exit;
               end;
           end;
        OP_IMUL,OP_MUL:
           begin
             if a = 1 then exit;
           end;
        OP_IDIV,OP_DIV:
            begin
             if a = 1 then exit;
            end;
        else
           internalerror(20020817);
        end;
        optimize64_op_const_reg := false;
      end;

end.
{
  $Log$
  Revision 1.63  2004-09-25 14:23:54  peter
    * ungetregister is now only used for cpuregisters, renamed to
      ungetcpuregister
    * renamed (get|unget)explicitregister(s) to ..cpuregister
    * removed location-release/reference_release

  Revision 1.62  2004/09/21 17:25:12  peter
    * paraloc branch merged

  Revision 1.61.4.2  2004/09/20 20:46:34  peter
    * register allocation optimized for 64bit loading of parameters
      and return values

  Revision 1.61.4.1  2004/08/31 20:43:06  peter
    * paraloc patch

  Revision 1.61  2004/06/20 08:55:28  florian
    * logs truncated

  Revision 1.60  2004/06/18 15:16:46  peter
    * remove obsolete cardinal() typecasts

  Revision 1.59  2004/06/17 16:55:46  peter
    * powerpc compiles again

  Revision 1.58  2004/06/16 20:07:07  florian
    * dwarf branch merged

  Revision 1.57.2.5  2004/06/13 10:51:16  florian
    * fixed several register allocator problems (sparc/arm)

  Revision 1.57.2.4  2004/06/12 17:01:01  florian
    * fixed compilation of arm compiler

}
