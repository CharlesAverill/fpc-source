{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    Generate PowerPC assembler for math nodes

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
unit nppcmat;

{$i fpcdefs.inc}

interface

    uses
      node,nmat;

    type
      tppcmoddivnode = class(tmoddivnode)
         function pass_1: tnode;override;
         procedure pass_2;override;
      end;

      tppcshlshrnode = class(tshlshrnode)
         procedure pass_2;override;
         { everything will be handled in pass_2 }
         function first_shlshr64bitint: tnode; override;
      end;

      tppcunaryminusnode = class(tunaryminusnode)
         procedure pass_2;override;
      end;

      tppcnotnode = class(tnotnode)
         procedure pass_2;override;
      end;

implementation

    uses
      globtype,systems,
      cutils,verbose,globals,
      symconst,symdef,
      aasmbase,aasmcpu,aasmtai,
      defutil,
      cgbase,cgobj,pass_1,pass_2,
      ncon,procinfo,
      cpubase,cpuinfo,
      ncgutil,cgcpu,cg64f32,rgobj;

{*****************************************************************************
                             TPPCMODDIVNODE
*****************************************************************************}

    function tppcmoddivnode.pass_1: tnode;
      begin
        result := inherited pass_1;
        if not assigned(result) then
          include(current_procinfo.flags,pi_do_call);
      end;


    procedure tppcmoddivnode.pass_2;
      const
                    { signed   overflow }
        divops: array[boolean, boolean] of tasmop =
          ((A_DIVWU,A_DIVWUO_),(A_DIVW,A_DIVWO_));
        zerocond: tasmcond = (dirhint: DH_Plus; simple: true; cond:C_NE; cr: RS_CR1);
      var
         power  : longint;
         op         : tasmop;
         numerator,
         divider,
         resultreg  : tregister;
         size       : Tcgsize;
         hl : tasmlabel;

      begin
         secondpass(left);
         secondpass(right);
         location_copy(location,left.location);

         { put numerator in register }
         size:=def_cgsize(left.resulttype.def);
         location_force_reg(exprasmlist,left.location,
           size,true);
         location_copy(location,left.location);
         numerator := location.register;
         resultreg := location.register;
         if (location.loc = LOC_CREGISTER) then
           begin
             location.loc := LOC_REGISTER;
             location.register := cg.getintregister(exprasmlist,size);
             resultreg := location.register;
           end;
         if (nodetype = modn) then
           begin
             resultreg := cg.getintregister(exprasmlist,size);
           end;

         if (nodetype = divn) and
            (right.nodetype = ordconstn) and
            ispowerof2(tordconstnode(right).value,power) then
           begin
             { From "The PowerPC Compiler Writer's Guide":                   }
             { This code uses the fact that, in the PowerPC architecture,    }
             { the shift right algebraic instructions set the Carry bit if   }
             { the source register contains a negative number and one or     }
             { more 1-bits are shifted out. Otherwise, the carry bit is      }
             { cleared. The addze instruction corrects the quotient, if      }
             { necessary, when the dividend is negative. For example, if     }
             { n = -13, (0xFFFF_FFF3), and k = 2, after executing the srawi  }
             { instruction, q = -4 (0xFFFF_FFFC) and CA = 1. After executing }
             { the addze instruction, q = -3, the correct quotient.          }
             cg.a_op_const_reg_reg(exprasmlist,OP_SAR,OS_32,aword(power),
               numerator,resultreg);
             exprasmlist.concat(taicpu.op_reg_reg(A_ADDZE,resultreg,resultreg));
           end
         else
           begin
             { load divider in a register if necessary }
             location_force_reg(exprasmlist,right.location,
               def_cgsize(right.resulttype.def),true);
             if (right.nodetype <> ordconstn) then
               exprasmlist.concat(taicpu.op_reg_reg_const(A_CMPWI,NR_CR1,
                 right.location.register,0));
             divider := right.location.register;

             { needs overflow checking, (-maxlongint-1) div (-1) overflows! }
             { And on PPC, the only way to catch a div-by-0 is by checking  }
             { the overflow flag (JM)                                       }
             op := divops[is_signed(right.resulttype.def),
                          cs_check_overflow in aktlocalswitches];
             exprasmlist.concat(taicpu.op_reg_reg_reg(op,resultreg,numerator,
               divider));

           if (nodetype = modn) then
             begin
               exprasmlist.concat(taicpu.op_reg_reg_reg(A_MULLW,resultreg,
                 divider,resultreg));
               exprasmlist.concat(taicpu.op_reg_reg_reg(A_SUB,location.register,
                 numerator,resultreg));
               resultreg := location.register;
             end;
           end;
        { set result location }
        location.loc:=LOC_REGISTER;
        location.register:=resultreg;
        if right.nodetype <> ordconstn then
          begin
            objectlibrary.getlabel(hl);
            exprasmlist.concat(taicpu.op_cond_sym(A_BC,zerocond,hl));
            cg.a_call_name(exprasmlist,'FPC_DIVBYZERO');
            cg.a_label(exprasmlist,hl);
          end;
        cg.g_overflowcheck(exprasmlist,location,resulttype.def);
      end;


{*****************************************************************************
                             TPPCSHLRSHRNODE
*****************************************************************************}

    function tppcshlshrnode.first_shlshr64bitint: tnode;
      begin
        result := nil;
      end;

    procedure tppcshlshrnode.pass_2;

      var
         resultreg, hregister1,hregister2,
         hregisterhigh,hregisterlow : tregister;
         op : topcg;
         asmop1, asmop2: tasmop;
         shiftval: aword;
         r : Tregister;

      begin
         secondpass(left);
         secondpass(right);

         if is_64bitint(left.resulttype.def) then
           begin
             location_force_reg(exprasmlist,left.location,
               def_cgsize(left.resulttype.def),true);
             location_copy(location,left.location);
             hregisterhigh := location.registerhigh;
             hregisterlow := location.registerlow;
             if (location.loc = LOC_CREGISTER) then
               begin
                 location.loc := LOC_REGISTER;
                 location.registerhigh := cg.getintregister(exprasmlist,OS_32);
                 location.registerlow := cg.getintregister(exprasmlist,OS_32);
               end;
             if (right.nodetype = ordconstn) then
               begin
                 shiftval := tordconstnode(right).value;
                 if shiftval > 63 then
                   begin
                     cg.a_load_const_reg(exprasmlist,OS_32,0,location.registerlow);
                     cg.a_load_const_reg(exprasmlist,OS_32,0,location.registerlow);
                   end
                 else if shiftval > 31 then
                   begin
                     if nodetype = shln then
                       begin
                         cg.a_op_const_reg_reg(exprasmlist,OP_SHL,OS_32,
                           shiftval and 31,hregisterlow,location.registerhigh);
                         cg.a_load_const_reg(exprasmlist,OS_32,0,location.registerlow);
                       end
                     else
                       begin
                         cg.a_op_const_reg_reg(exprasmlist,OP_SHR,OS_32,
                           shiftval and 31,hregisterhigh,location.registerlow);
                         cg.a_load_const_reg(exprasmlist,OS_32,0,location.registerhigh);
                       end;
                   end
                 else
                   begin
                     if nodetype = shln then
                       begin
                         exprasmlist.concat(taicpu.op_reg_reg_const_const_const(
                           A_RLWINM,location.registerhigh,hregisterhigh,shiftval,
                           0,31-shiftval));
                         exprasmlist.concat(taicpu.op_reg_reg_const_const_const(
                           A_RLWIMI,location.registerhigh,hregisterlow,shiftval,
                           32-shiftval,31));
                         exprasmlist.concat(taicpu.op_reg_reg_const_const_const(
                           A_RLWINM,location.registerlow,hregisterlow,shiftval,
                           0,31-shiftval));
                       end
                     else
                       begin
                         exprasmlist.concat(taicpu.op_reg_reg_const_const_const(
                           A_RLWINM,location.registerlow,hregisterlow,32-shiftval,
                           shiftval,31));
                         exprasmlist.concat(taicpu.op_reg_reg_const_const_const(
                           A_RLWIMI,location.registerlow,hregisterhigh,32-shiftval,
                           0,shiftval-1));
                         exprasmlist.concat(taicpu.op_reg_reg_const_const_const(
                           A_RLWINM,location.registerhigh,hregisterhigh,32-shiftval,
                           shiftval,31));
                       end;
                   end;
               end
             else
               { no constant shiftcount }
               begin
                 location_force_reg(exprasmlist,right.location,OS_S32,true);
                 hregister1 := right.location.register;
                 if nodetype = shln then
                   begin
                     asmop1 := A_SLW;
                     asmop2 := A_SRW;
                   end
                 else
                   begin
                     asmop1 := A_SRW;
                     asmop2 := A_SLW;
                     resultreg := hregisterhigh;
                     hregisterhigh := hregisterlow;
                     hregisterlow := resultreg;
                     resultreg := location.registerhigh;
                     location.registerhigh := location.registerlow;
                     location.registerlow := resultreg;
                   end;

                 cg.getcpuregister(exprasmlist,NR_R0);
                 exprasmlist.concat(taicpu.op_reg_reg_const(A_SUBFIC,
                   NR_R0,hregister1,32));
                 exprasmlist.concat(taicpu.op_reg_reg_reg(asmop1,
                   location.registerhigh,hregisterhigh,hregister1));
                 exprasmlist.concat(taicpu.op_reg_reg_reg(asmop2,
                   NR_R0,hregisterlow,NR_R0));
                 exprasmlist.concat(taicpu.op_reg_reg_reg(A_OR,
                   location.registerhigh,location.registerhigh,NR_R0));
                 exprasmlist.concat(taicpu.op_reg_reg_const(A_SUBI,
                   NR_R0,hregister1,32));
                 exprasmlist.concat(taicpu.op_reg_reg_reg(asmop1,
                   NR_R0,hregisterlow,NR_R0));
                 exprasmlist.concat(taicpu.op_reg_reg_reg(A_OR,
                   location.registerhigh,location.registerhigh,NR_R0));
                 exprasmlist.concat(taicpu.op_reg_reg_reg(asmop1,
                   location.registerlow,hregisterlow,hregister1));
                 cg.ungetcpuregister(exprasmlist,NR_R0);

                 if nodetype = shrn then
                   begin
                     resultreg := location.registerhigh;
                     location.registerhigh := location.registerlow;
                     location.registerlow := resultreg;
                   end;
               end
           end
         else
           begin
             { load left operators in a register }
             location_force_reg(exprasmlist,left.location,def_cgsize(left.resulttype.def),true);
             location_copy(location,left.location);
             resultreg := location.register;
             hregister1 := location.register;
             if (location.loc = LOC_CREGISTER) then
               begin
                 location.loc := LOC_REGISTER;
                 resultreg := cg.getintregister(exprasmlist,OS_32);
                 location.register := resultreg;
               end;

              { determine operator }
              if nodetype=shln then
                op:=OP_SHL
              else
                op:=OP_SHR;

              { shifting by a constant directly coded: }
              if (right.nodetype=ordconstn) then
                cg.a_op_const_reg_reg(exprasmlist,op,OS_32,
                  tordconstnode(right).value and 31,hregister1,resultreg)
              else
                begin
                  { load shift count in a register if necessary }
                  location_force_reg(exprasmlist,right.location,def_cgsize(right.resulttype.def),true);
                  hregister2 := right.location.register;

                  cg.a_op_reg_reg_reg(exprasmlist,op,OS_32,hregister2,
                    hregister1,resultreg);
                end;
           end;
      end;


{*****************************************************************************
                          TPPCUNARYMINUSNODE
*****************************************************************************}

    procedure tppcunaryminusnode.pass_2;

      var
        src1, src2, tmp: tregister;
        op: tasmop;

      begin
         secondpass(left);
         if is_64bitint(left.resulttype.def) then
           begin
             location_force_reg(exprasmlist,left.location,def_cgsize(left.resulttype.def),true);
             location_copy(location,left.location);
             if (location.loc = LOC_CREGISTER) then
               begin
                 location.registerlow := cg.getintregister(exprasmlist,OS_INT);
                 location.registerhigh := cg.getintregister(exprasmlist,OS_INT);
                 location.loc := LOC_REGISTER;
               end;
             exprasmlist.concat(taicpu.op_reg_reg_const(A_SUBFIC,
               location.registerlow,left.location.registerlow,0));
             if not(cs_check_overflow in aktlocalswitches) then
               exprasmlist.concat(taicpu.op_reg_reg(A_SUBFZE,
                 location.registerhigh,left.location.registerhigh))
             else
               exprasmlist.concat(taicpu.op_reg_reg(A_SUBFZEO_,
                 location.registerhigh,left.location.registerhigh));
           end
         else
           begin
              location_copy(location,left.location);
              location.loc:=LOC_REGISTER;
              case left.location.loc of
                LOC_FPUREGISTER, LOC_REGISTER:
                  begin
                    src1 := left.location.register;
                    location.register := src1;
                  end;
                LOC_CFPUREGISTER, LOC_CREGISTER:
                  begin
                     src1 := left.location.register;
                     if left.location.loc = LOC_CREGISTER then
                       location.register := cg.getintregister(exprasmlist,OS_INT)
                     else
                       location.register := cg.getfpuregister(exprasmlist,location.size);
                  end;
                LOC_REFERENCE,LOC_CREFERENCE:
                  begin
                     if (left.resulttype.def.deftype=floatdef) then
                       begin
                          src1 := cg.getfpuregister(exprasmlist,def_cgsize(left.resulttype.def));
                          location.register := src1;
                          cg.a_loadfpu_ref_reg(exprasmlist,
                            def_cgsize(left.resulttype.def),
                            left.location.reference,src1);
                       end
                     else
                       begin
                          src1 := cg.getintregister(exprasmlist,OS_32);
                          location.register:= src1;
                          cg.a_load_ref_reg(exprasmlist,OS_32,OS_32,
                            left.location.reference,src1);
                       end;
                  end;
              end;
              { choose appropriate operand }
              if left.resulttype.def.deftype <> floatdef then
                begin
                  if not(cs_check_overflow in aktlocalswitches) then
                    op := A_NEG
                  else
                    op := A_NEGO_;
                  location.loc := LOC_REGISTER;
                end
              else
                begin
                  op := A_FNEG;
                  location.loc := LOC_FPUREGISTER;
                end;
              { emit operation }
              exprasmlist.concat(taicpu.op_reg_reg(op,location.register,src1));
           end;
{ Here was a problem...     }
{ Operand to be negated always     }
{ seems to be converted to signed  }
{ 32-bit before doing neg!!     }
{ So this is useless...     }
{ that's not true: -2^31 gives an overflow error if it is negated (FK) }
        cg.g_overflowcheck(exprasmlist,location,resulttype.def);
      end;


{*****************************************************************************
                               TPPCNOTNODE
*****************************************************************************}

    procedure tppcnotnode.pass_2;

      var
         hl : tasmlabel;
         regl, regh: tregister;

      begin
         if is_boolean(resulttype.def) then
          begin
            { if the location is LOC_JUMP, we do the secondpass after the
              labels are allocated
            }
            if left.expectloc=LOC_JUMP then
              begin
                hl:=truelabel;
                truelabel:=falselabel;
                falselabel:=hl;
                secondpass(left);
                maketojumpbool(exprasmlist,left,lr_load_regvars);
                hl:=truelabel;
                truelabel:=falselabel;
                falselabel:=hl;
                location.loc:=LOC_JUMP;
              end
            else
              begin
                secondpass(left);
                case left.location.loc of
                  LOC_FLAGS :
                    begin
                      location_copy(location,left.location);
                      inverse_flags(location.resflags);
                    end;
                  LOC_REGISTER, LOC_CREGISTER, LOC_REFERENCE, LOC_CREFERENCE :
                    begin
                      location_force_reg(exprasmlist,left.location,def_cgsize(left.resulttype.def),true);
                      exprasmlist.concat(taicpu.op_reg_const(A_CMPWI,left.location.register,0));
                      location_reset(location,LOC_FLAGS,OS_NO);
                      location.resflags.cr:=RS_CR0;
                      location.resflags.flag:=F_EQ;
                   end;
                  else
                    internalerror(2003042401);
                end;
              end;
          end
         else if is_64bitint(left.resulttype.def) then
           begin
             secondpass(left);
             location_force_reg(exprasmlist,left.location,def_cgsize(left.resulttype.def),false);
             location_copy(location,left.location);
             { perform the NOT operation }
             exprasmlist.concat(taicpu.op_reg_reg(A_NOT,location.registerhigh,
               location.registerhigh));
             exprasmlist.concat(taicpu.op_reg_reg(A_NOT,location.registerlow,
               location.registerlow));
           end
         else
           begin
             secondpass(left);
             location_force_reg(exprasmlist,left.location,def_cgsize(left.resulttype.def),true);
             location_copy(location,left.location);
             location.loc := LOC_REGISTER;
             location.register := cg.getintregister(exprasmlist,OS_INT);
             { perform the NOT operation }
             cg.a_op_reg_reg(exprasmlist,OP_NOT,def_cgsize(resulttype.def),left.location.register,
               location.register);
          end;
      end;

begin
   cmoddivnode:=tppcmoddivnode;
   cshlshrnode:=tppcshlshrnode;
   cunaryminusnode:=tppcunaryminusnode;
   cnotnode:=tppcnotnode;
end.
{
  $Log$
  Revision 1.40  2004-09-25 14:23:55  peter
    * ungetregister is now only used for cpuregisters, renamed to
      ungetcpuregister
    * renamed (get|unget)explicitregister(s) to ..cpuregister
    * removed location-release/reference_release

  Revision 1.39  2004/06/20 08:55:32  florian
    * logs truncated

  Revision 1.38  2004/01/01 17:58:16  jonas
    + integer division-by-zero detection support for ppc
    + compilerproc FPC_DIVBYZERO

}
