{
    $Id$
    Copyright (c) 2000-2002 by Florian Klaempfl

    Code generation for add nodes on the i386

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
unit n386add;

{$i fpcdefs.inc}

interface

    uses
       node,nadd,cpubase;

    type
       ti386addnode = class(tx86addnode)
          procedure pass_2;override;
         protected
          function  first_addstring : tnode; override;
         private
          procedure pass_left_and_right(var pushedfpu:boolean);
          function  getresflags(unsigned : boolean) : tresflags;
          procedure left_must_be_reg(opsize:TOpSize;noswap:boolean);
          procedure emit_op_right_left(op:TAsmOp;opsize:TOpSize);
          procedure emit_generic_code(op:TAsmOp;opsize:TOpSize;unsigned,extra_not,mboverflow:boolean);
          procedure set_result_location(cmpop,unsigned:boolean);
          procedure second_addstring;
          procedure second_addboolean;
          procedure second_addfloat;
          procedure second_addsmallset;
          procedure second_mul;
{$ifdef SUPPORT_MMX}
          procedure second_addmmx;
{$endif SUPPORT_MMX}
          procedure second_add64bit;
       end;

  implementation

    uses
      globtype,systems,
      cutils,verbose,globals,
      symconst,symdef,paramgr,
      aasmbase,aasmtai,aasmcpu,defutil,htypechk,
      cgbase,pass_2,regvars,
      ncon,nset,
      cga,cgx86,ncgutil,cgobj,cg64f32;

{*****************************************************************************
                                  Helpers
*****************************************************************************}

      const
         opsize_2_cgsize : array[S_B..S_L] of tcgsize = (OS_8,OS_16,OS_32);

    procedure ti386addnode.pass_left_and_right(var pushedfpu:boolean);
      begin
        { calculate the operator which is more difficult }
        firstcomplex(self);

        { in case of constant put it to the left }
        if (left.nodetype=ordconstn) then
         swapleftright;
        secondpass(left);

        { are too few registers free? }
        if location.loc=LOC_FPUREGISTER then
          pushedfpu:=maybe_pushfpu(exprasmlist,right.registersfpu,left.location)
        else
          pushedfpu:=false;
        secondpass(right);
      end;


    function ti386addnode.getresflags(unsigned : boolean) : tresflags;
      begin
         case nodetype of
           equaln : getresflags:=F_E;
           unequaln : getresflags:=F_NE;
          else
           if not(unsigned) then
             begin
                if nf_swaped in flags then
                  case nodetype of
                     ltn : getresflags:=F_G;
                     lten : getresflags:=F_GE;
                     gtn : getresflags:=F_L;
                     gten : getresflags:=F_LE;
                  end
                else
                  case nodetype of
                     ltn : getresflags:=F_L;
                     lten : getresflags:=F_LE;
                     gtn : getresflags:=F_G;
                     gten : getresflags:=F_GE;
                  end;
             end
           else
             begin
                if nf_swaped in flags then
                  case nodetype of
                     ltn : getresflags:=F_A;
                     lten : getresflags:=F_AE;
                     gtn : getresflags:=F_B;
                     gten : getresflags:=F_BE;
                  end
                else
                  case nodetype of
                     ltn : getresflags:=F_B;
                     lten : getresflags:=F_BE;
                     gtn : getresflags:=F_A;
                     gten : getresflags:=F_AE;
                  end;
             end;
         end;
      end;


    procedure ti386addnode.left_must_be_reg(opsize:TOpSize;noswap:boolean);
      begin
        { left location is not a register? }
        if (left.location.loc<>LOC_REGISTER) then
         begin
           { if right is register then we can swap the locations }
           if (not noswap) and
              (right.location.loc=LOC_REGISTER) then
            begin
              location_swap(left.location,right.location);
              toggleflag(nf_swaped);
            end
           else
            begin
              { maybe we can reuse a constant register when the
                operation is a comparison that doesn't change the
                value of the register }
              location_force_reg(exprasmlist,left.location,opsize_2_cgsize[opsize],(nodetype in [ltn,lten,gtn,gten,equaln,unequaln]));
            end;
          end;
       end;


    procedure ti386addnode.emit_op_right_left(op:TAsmOp;opsize:TOpsize);
      begin
        { left must be a register }
        case right.location.loc of
          LOC_REGISTER,
          LOC_CREGISTER :
            exprasmlist.concat(taicpu.op_reg_reg(op,opsize,right.location.register,left.location.register));
          LOC_REFERENCE,
          LOC_CREFERENCE :
            exprasmlist.concat(taicpu.op_ref_reg(op,opsize,right.location.reference,left.location.register));
          LOC_CONSTANT :
            exprasmlist.concat(taicpu.op_const_reg(op,opsize,right.location.value,left.location.register));
          else
            internalerror(200203232);
        end;
      end;


    procedure ti386addnode.set_result_location(cmpop,unsigned:boolean);
      begin
        if cmpop then
         begin
           location_reset(location,LOC_FLAGS,OS_NO);
           location.resflags:=getresflags(unsigned);
         end
        else
         location_copy(location,left.location);
      end;


    procedure ti386addnode.emit_generic_code(op:TAsmOp;opsize:TOpSize;unsigned,extra_not,mboverflow:boolean);
      var
        power : longint;
        hl4   : tasmlabel;
        r     : Tregister;
      begin
        { at this point, left.location.loc should be LOC_REGISTER }
        if right.location.loc=LOC_REGISTER then
         begin
           { right.location is a LOC_REGISTER }
           { when swapped another result register }
           if (nodetype=subn) and (nf_swaped in flags) then
            begin
              if extra_not then
               emit_reg(A_NOT,S_L,left.location.register);
              emit_reg_reg(op,opsize,left.location.register,right.location.register);
              { newly swapped also set swapped flag }
              location_swap(left.location,right.location);
              toggleflag(nf_swaped);
            end
           else
            begin
              if extra_not then
                emit_reg(A_NOT,S_L,right.location.register);
              if (op=A_ADD) or (op=A_OR) or (op=A_AND) or (op=A_XOR) or (op=A_IMUL) then
                location_swap(left.location,right.location);
              emit_reg_reg(op,opsize,right.location.register,left.location.register);
            end;
         end
        else
         begin
           { right.location is not a LOC_REGISTER }
           if (nodetype=subn) and (nf_swaped in flags) then
            begin
              if extra_not then
                emit_reg(A_NOT,opsize,left.location.register);
              r:=cg.getintregister(exprasmlist,OS_INT);
              cg.a_load_loc_reg(exprasmlist,OS_INT,right.location,r);
              emit_reg_reg(op,opsize,left.location.register,r);
              emit_reg_reg(A_MOV,opsize,r,left.location.register);
              cg.ungetregister(exprasmlist,r);
            end
           else
            begin
               { Optimizations when right.location is a constant value }
               if (op=A_CMP) and
                  (nodetype in [equaln,unequaln]) and
                  (right.location.loc=LOC_CONSTANT) and
                  (right.location.value=0) then
                 begin
                   emit_reg_reg(A_TEST,opsize,left.location.register,left.location.register);
                 end
               else
                 if (op=A_ADD) and
                    (right.location.loc=LOC_CONSTANT) and
                    (right.location.value=1) and
                    not(cs_check_overflow in aktlocalswitches) then
                  begin
                    emit_reg(A_INC,opsize,left.location.register);
                  end
               else
                 if (op=A_SUB) and
                    (right.location.loc=LOC_CONSTANT) and
                    (right.location.value=1) and
                    not(cs_check_overflow in aktlocalswitches) then
                  begin
                    emit_reg(A_DEC,opsize,left.location.register);
                  end
               else
                 if (op=A_IMUL) and
                    (right.location.loc=LOC_CONSTANT) and
                    (ispowerof2(right.location.value,power)) and
                    not(cs_check_overflow in aktlocalswitches) then
                  begin
                    emit_const_reg(A_SHL,opsize,power,left.location.register);
                  end
               else
                 begin
                   if extra_not then
                     begin
                        r:=cg.getintregister(exprasmlist,OS_INT);
                        cg.a_load_loc_reg(exprasmlist,OS_INT,right.location,r);
                        emit_reg(A_NOT,S_L,r);
                        emit_reg_reg(A_AND,S_L,r,left.location.register);
                        cg.ungetregister(exprasmlist,r);
                     end
                   else
                     begin
                        emit_op_right_left(op,opsize);
                     end;
                 end;
            end;
         end;

        { only in case of overflow operations }
        { produce overflow code }
        { we must put it here directly, because sign of operation }
        { is in unsigned VAR!!                                   }
        if mboverflow then
         begin
           if cs_check_overflow in aktlocalswitches  then
            begin
              objectlibrary.getlabel(hl4);
              if unsigned then
                cg.a_jmp_flags(exprasmlist,F_AE,hl4)
              else
                cg.a_jmp_flags(exprasmlist,F_NO,hl4);
              cg.a_call_name(exprasmlist,'FPC_OVERFLOW');
              cg.a_label(exprasmlist,hl4);
            end;
         end;
      end;

{*****************************************************************************
                                Addstring
*****************************************************************************}

    { note: if you implemented an fpc_shortstr_concat similar to the    }
    { one in i386.inc, you have to override first_addstring like in     }
    { ti386addnode.first_string and implement the shortstring concat    }
    { manually! The generic routine is different from the i386 one (JM) }
    function ti386addnode.first_addstring : tnode;

      begin
        { special cases for shortstrings, handled in pass_2 (JM) }
        { can't handle fpc_shortstr_compare with compilerproc either because it }
        { returns its results in the flags instead of in eax                    }
        if (nodetype in [ltn,lten,gtn,gten,equaln,unequaln]) and
           is_shortstring(left.resulttype.def) and
           not(((left.nodetype=stringconstn) and (str_length(left)=0)) or
              ((right.nodetype=stringconstn) and (str_length(right)=0))) then
         begin
           expectloc:=LOC_FLAGS;
           calcregisters(self,0,0,0);
           result := nil;
           exit;
         end;
        { otherwise, use the generic code }
        result := inherited first_addstring;
      end;


    procedure ti386addnode.second_addstring;
      var
        paraloc1,
        paraloc2   : tparalocation;
        hregister1,
        hregister2 : tregister;
      begin
        { string operations are not commutative }
        if nf_swaped in flags then
          swapleftright;
        case tstringdef(left.resulttype.def).string_typ of
           st_shortstring:
             begin
                case nodetype of
                   ltn,lten,gtn,gten,equaln,unequaln :
                     begin
{$warning forced stdcall calling}
                       paraloc1:=paramanager.getintparaloc(pocall_stdcall,1);
                       paraloc2:=paramanager.getintparaloc(pocall_stdcall,2);
                       { process parameters }
                       secondpass(left);
                       location_release(exprasmlist,left.location);
                       if paraloc2.loc=LOC_REGISTER then
                         begin
                           hregister2:=cg.getaddressregister(exprasmlist);
                           cg.a_loadaddr_ref_reg(exprasmlist,left.location.reference,hregister2);
                         end
                       else
                         begin
                           paramanager.allocparaloc(exprasmlist,paraloc2);
                           cg.a_paramaddr_ref(exprasmlist,left.location.reference,paraloc2);
                         end;
                       secondpass(right);
                       location_release(exprasmlist,right.location);
                       if paraloc1.loc=LOC_REGISTER then
                         begin
                           hregister1:=cg.getaddressregister(exprasmlist);
                           cg.a_loadaddr_ref_reg(exprasmlist,right.location.reference,hregister1);
                         end
                       else
                         begin
                           paramanager.allocparaloc(exprasmlist,paraloc1);
                           cg.a_paramaddr_ref(exprasmlist,right.location.reference,paraloc1);
                         end;
                       { push parameters }
                       if paraloc1.loc=LOC_REGISTER then
                         begin
                           cg.ungetregister(exprasmlist,hregister2);
                           paramanager.allocparaloc(exprasmlist,paraloc2);
                           cg.a_param_reg(exprasmlist,OS_ADDR,hregister2,paraloc2);
                         end;
                       if paraloc2.loc=LOC_REGISTER then
                         begin
                           cg.ungetregister(exprasmlist,hregister1);
                           paramanager.allocparaloc(exprasmlist,paraloc1);
                           cg.a_param_reg(exprasmlist,OS_ADDR,hregister1,paraloc1);
                         end;
                       paramanager.freeparaloc(exprasmlist,paraloc1);
                       paramanager.freeparaloc(exprasmlist,paraloc2);
                       cg.allocexplicitregisters(exprasmlist,R_INTREGISTER,paramanager.get_volatile_registers_int(pocall_default));
                       cg.a_call_name(exprasmlist,'FPC_SHORTSTR_COMPARE');
                       cg.deallocexplicitregisters(exprasmlist,R_INTREGISTER,paramanager.get_volatile_registers_int(pocall_default));
                       location_freetemp(exprasmlist,left.location);
                       location_freetemp(exprasmlist,right.location);
                     end;
                end;
                set_result_location(true,true);
             end;
           else
             { rest should be handled in first pass (JM) }
             internalerror(200108303);
       end;
     end;

{*****************************************************************************
                                AddBoolean
*****************************************************************************}

    procedure ti386addnode.second_addboolean;
      var
        op      : TAsmOp;
        opsize  : TOpsize;
        cmpop,
        isjump  : boolean;
        otl,ofl : tasmlabel;
      begin
        { calculate the operator which is more difficult }
        firstcomplex(self);

        cmpop:=false;
        if (torddef(left.resulttype.def).typ=bool8bit) or
           (torddef(right.resulttype.def).typ=bool8bit) then
         opsize:=S_B
        else
          if (torddef(left.resulttype.def).typ=bool16bit) or
             (torddef(right.resulttype.def).typ=bool16bit) then
           opsize:=S_W
        else
           opsize:=S_L;

        if (cs_full_boolean_eval in aktlocalswitches) or
           (nodetype in [unequaln,ltn,lten,gtn,gten,equaln,xorn]) then
          begin
            if left.nodetype in [ordconstn,realconstn] then
             swapleftright;

            isjump:=(left.expectloc=LOC_JUMP);
            if isjump then
              begin
                 otl:=truelabel;
                 objectlibrary.getlabel(truelabel);
                 ofl:=falselabel;
                 objectlibrary.getlabel(falselabel);
              end;
            secondpass(left);
            if left.location.loc in [LOC_FLAGS,LOC_JUMP] then
             location_force_reg(exprasmlist,left.location,opsize_2_cgsize[opsize],false);
            if isjump then
             begin
               truelabel:=otl;
               falselabel:=ofl;
             end
            else if left.location.loc=LOC_JUMP then
              internalerror(200310081);

            isjump:=(right.expectloc=LOC_JUMP);
            if isjump then
              begin
                 otl:=truelabel;
                 objectlibrary.getlabel(truelabel);
                 ofl:=falselabel;
                 objectlibrary.getlabel(falselabel);
              end;
            secondpass(right);
            if right.location.loc in [LOC_FLAGS,LOC_JUMP] then
             location_force_reg(exprasmlist,right.location,opsize_2_cgsize[opsize],false);
            if isjump then
             begin
               truelabel:=otl;
               falselabel:=ofl;
             end
            else if left.location.loc=LOC_JUMP then
              internalerror(200310082);

            { left must be a register }
            left_must_be_reg(opsize,false);
            { compare the }
            case nodetype of
              ltn,lten,gtn,gten,
              equaln,unequaln :
                begin
                  op:=A_CMP;
                  cmpop:=true;
                end;
              xorn :
                op:=A_XOR;
              orn :
                op:=A_OR;
              andn :
                op:=A_AND;
              else
                internalerror(200203247);
            end;
            emit_op_right_left(op,opsize);
            location_freetemp(exprasmlist,right.location);
            location_release(exprasmlist,right.location);
            if cmpop then
             begin
               location_freetemp(exprasmlist,left.location);
               location_release(exprasmlist,left.location);
             end;
            set_result_location(cmpop,true);
         end
        else
         begin
           case nodetype of
             andn,
             orn :
               begin
                 location_reset(location,LOC_JUMP,OS_NO);
                 case nodetype of
                   andn :
                     begin
                        otl:=truelabel;
                        objectlibrary.getlabel(truelabel);
                        secondpass(left);
                        maketojumpbool(exprasmlist,left,lr_load_regvars);
                        cg.a_label(exprasmlist,truelabel);
                        truelabel:=otl;
                     end;
                   orn :
                     begin
                        ofl:=falselabel;
                        objectlibrary.getlabel(falselabel);
                        secondpass(left);
                        maketojumpbool(exprasmlist,left,lr_load_regvars);
                        cg.a_label(exprasmlist,falselabel);
                        falselabel:=ofl;
                     end;
                   else
                     internalerror(2003042212);
                 end;
                 secondpass(right);
                 maketojumpbool(exprasmlist,right,lr_load_regvars);
               end;
             else
               internalerror(2003042213);
           end;
         end;
      end;


{*****************************************************************************
                                AddFloat
*****************************************************************************}

    procedure ti386addnode.second_addfloat;
      var
        op         : TAsmOp;
        resflags   : tresflags;
        pushedfpu,
        cmpop      : boolean;
      begin
        pass_left_and_right(pushedfpu);

        cmpop:=false;
        case nodetype of
          addn :
            op:=A_FADDP;
          muln :
            op:=A_FMULP;
          subn :
            op:=A_FSUBP;
          slashn :
            op:=A_FDIVP;
          ltn,lten,gtn,gten,
          equaln,unequaln :
            begin
              op:=A_FCOMPP;
              cmpop:=true;
            end;
          else
            internalerror(2003042214);
        end;

        if (right.location.loc<>LOC_FPUREGISTER) then
         begin
           cg.a_loadfpu_loc_reg(exprasmlist,right.location,NR_ST);
           if (right.location.loc <> LOC_CFPUREGISTER) and
              pushedfpu then
             location_freetemp(exprasmlist,left.location);
           if (left.location.loc<>LOC_FPUREGISTER) then
            begin
              cg.a_loadfpu_loc_reg(exprasmlist,left.location,NR_ST);
              if (left.location.loc <> LOC_CFPUREGISTER) and
                 pushedfpu then
                location_freetemp(exprasmlist,left.location);
            end
           else
            begin
              { left was on the stack => swap }
              toggleflag(nf_swaped);
            end;

           { releases the right reference }
           location_release(exprasmlist,right.location);
         end
        { the nominator in st0 }
        else if (left.location.loc<>LOC_FPUREGISTER) then
         begin
           cg.a_loadfpu_loc_reg(exprasmlist,left.location,NR_ST);
           if (left.location.loc <> LOC_CFPUREGISTER) and
              pushedfpu then
             location_freetemp(exprasmlist,left.location);
         end
        else
         begin
           { fpu operands are always in the wrong order on the stack }
           toggleflag(nf_swaped);
         end;

        { releases the left reference }
        if (left.location.loc in [LOC_CREFERENCE,LOC_REFERENCE]) then
          location_release(exprasmlist,left.location);

        { if we swaped the tree nodes, then use the reverse operator }
        if nf_swaped in flags then
          begin
             if (nodetype=slashn) then
               op:=A_FDIVRP
             else if (nodetype=subn) then
               op:=A_FSUBRP;
          end;
        { to avoid the pentium bug
        if (op=FDIVP) and (opt_processors=pentium) then
          cg.a_call_name(exprasmlist,'EMUL_FDIVP')
        else
        }
        { the Intel assemblers want operands }
        if op<>A_FCOMPP then
          begin
             emit_reg_reg(op,S_NO,NR_ST,NR_ST1);
             tcgx86(cg).dec_fpu_stack;
          end
        else
          begin
             emit_none(op,S_NO);
             tcgx86(cg).dec_fpu_stack;
             tcgx86(cg).dec_fpu_stack;
          end;

        { on comparison load flags }
        if cmpop then
         begin
           cg.getexplicitregister(exprasmlist,NR_AX);
           emit_reg(A_FNSTSW,S_NO,NR_AX);
           emit_none(A_SAHF,S_NO);
           cg.ungetregister(exprasmlist,NR_AX);
           if nf_swaped in flags then
            begin
              case nodetype of
                  equaln : resflags:=F_E;
                unequaln : resflags:=F_NE;
                     ltn : resflags:=F_A;
                    lten : resflags:=F_AE;
                     gtn : resflags:=F_B;
                    gten : resflags:=F_BE;
              end;
            end
           else
            begin
              case nodetype of
                  equaln : resflags:=F_E;
                unequaln : resflags:=F_NE;
                     ltn : resflags:=F_B;
                    lten : resflags:=F_BE;
                     gtn : resflags:=F_A;
                    gten : resflags:=F_AE;
              end;
            end;
           location_reset(location,LOC_FLAGS,OS_NO);
           location.resflags:=resflags;
         end
        else
         begin
           location_reset(location,LOC_FPUREGISTER,def_cgsize(resulttype.def));
           location.register:=NR_ST;
         end;
      end;


{*****************************************************************************
                                AddSmallSet
*****************************************************************************}

    procedure ti386addnode.second_addsmallset;
      var
        opsize : TOpSize;
        op     : TAsmOp;
        cmpop,
        pushedfpu,
        extra_not,
        noswap : boolean;
      begin
        pass_left_and_right(pushedfpu);

        { when a setdef is passed, it has to be a smallset }
        if ((left.resulttype.def.deftype=setdef) and
            (tsetdef(left.resulttype.def).settype<>smallset)) or
           ((right.resulttype.def.deftype=setdef) and
            (tsetdef(right.resulttype.def).settype<>smallset)) then
         internalerror(200203301);

        cmpop:=false;
        noswap:=false;
        extra_not:=false;
        opsize:=S_L;
        case nodetype of
          addn :
            begin
              { this is a really ugly hack!!!!!!!!!! }
              { this could be done later using EDI   }
              { as it is done for subn               }
              { instead of two registers!!!!         }
              { adding elements is not commutative }
              if (nf_swaped in flags) and (left.nodetype=setelementn) then
               swapleftright;
              { are we adding set elements ? }
              if right.nodetype=setelementn then
               begin
                 { no range support for smallsets! }
                 if assigned(tsetelementnode(right).right) then
                  internalerror(43244);
                 { bts requires both elements to be registers }
                 location_force_reg(exprasmlist,left.location,opsize_2_cgsize[opsize],false);
                 location_force_reg(exprasmlist,right.location,opsize_2_cgsize[opsize],true);
                 op:=A_BTS;
                 noswap:=true;
               end
              else
               op:=A_OR;
            end;
          symdifn :
            op:=A_XOR;
          muln :
            op:=A_AND;
          subn :
            begin
              op:=A_AND;
              if (not(nf_swaped in flags)) and
                 (right.location.loc=LOC_CONSTANT) then
                right.location.value := not(right.location.value)
              else if (nf_swaped in flags) and
                      (left.location.loc=LOC_CONSTANT) then
                left.location.value := not(left.location.value)
              else
                extra_not:=true;
            end;
          equaln,
          unequaln :
            begin
              op:=A_CMP;
              cmpop:=true;
            end;
          lten,gten:
            begin
              If (not(nf_swaped in flags) and
                  (nodetype = lten)) or
                 ((nf_swaped in flags) and
                  (nodetype = gten)) then
                swapleftright;
              location_force_reg(exprasmlist,left.location,opsize_2_cgsize[opsize],true);
              emit_op_right_left(A_AND,opsize);
              op:=A_CMP;
              cmpop:=true;
              { warning: ugly hack, we need a JE so change the node to equaln }
              nodetype:=equaln;
            end;
          xorn :
            op:=A_XOR;
          orn :
            op:=A_OR;
          andn :
            op:=A_AND;
          else
            internalerror(2003042215);
        end;
        { left must be a register }
        left_must_be_reg(opsize,noswap);
        emit_generic_code(op,opsize,true,extra_not,false);
        location_freetemp(exprasmlist,right.location);
        location_release(exprasmlist,right.location);
        if cmpop then
         begin
           location_freetemp(exprasmlist,left.location);
           location_release(exprasmlist,left.location);
         end;
        set_result_location(cmpop,true);
      end;


{*****************************************************************************
                                Add64bit
*****************************************************************************}

    procedure ti386addnode.second_add64bit;
      var
        op         : TOpCG;
        op1,op2    : TAsmOp;
        opsize     : TOpSize;
        hregister,
        hregister2 : tregister;
        href       : treference;
        hl4        : tasmlabel;
        pushedfpu,
        mboverflow,
        cmpop,
        unsigned,delete:boolean;
        r:Tregister;

      procedure firstjmp64bitcmp;

        var
           oldnodetype : tnodetype;

        begin
           load_all_regvars(exprasmlist);
           { the jump the sequence is a little bit hairy }
           case nodetype of
              ltn,gtn:
                begin
                   cg.a_jmp_flags(exprasmlist,getresflags(unsigned),truelabel);
                   { cheat a little bit for the negative test }
                   toggleflag(nf_swaped);
                   cg.a_jmp_flags(exprasmlist,getresflags(unsigned),falselabel);
                   toggleflag(nf_swaped);
                end;
              lten,gten:
                begin
                   oldnodetype:=nodetype;
                   if nodetype=lten then
                     nodetype:=ltn
                   else
                     nodetype:=gtn;
                   cg.a_jmp_flags(exprasmlist,getresflags(unsigned),truelabel);
                   { cheat for the negative test }
                   if nodetype=ltn then
                     nodetype:=gtn
                   else
                     nodetype:=ltn;
                   cg.a_jmp_flags(exprasmlist,getresflags(unsigned),falselabel);
                   nodetype:=oldnodetype;
                end;
              equaln:
                cg.a_jmp_flags(exprasmlist,F_NE,falselabel);
              unequaln:
                cg.a_jmp_flags(exprasmlist,F_NE,truelabel);
           end;
        end;

      procedure secondjmp64bitcmp;

        begin
           { the jump the sequence is a little bit hairy }
           case nodetype of
              ltn,gtn,lten,gten:
                begin
                   { the comparisaion of the low dword have to be }
                   {  always unsigned!                            }
                   cg.a_jmp_flags(exprasmlist,getresflags(true),truelabel);
                   cg.a_jmp_always(exprasmlist,falselabel);
                end;
              equaln:
                begin
                   cg.a_jmp_flags(exprasmlist,F_NE,falselabel);
                   cg.a_jmp_always(exprasmlist,truelabel);
                end;
              unequaln:
                begin
                   cg.a_jmp_flags(exprasmlist,F_NE,truelabel);
                   cg.a_jmp_always(exprasmlist,falselabel);
                end;
           end;
        end;

      begin
        firstcomplex(self);

        pass_left_and_right(pushedfpu);

        op1:=A_NONE;
        op2:=A_NONE;
        mboverflow:=false;
        cmpop:=false;
        opsize:=S_L;
        unsigned:=((left.resulttype.def.deftype=orddef) and
                   (torddef(left.resulttype.def).typ=u64bit)) or
                  ((right.resulttype.def.deftype=orddef) and
                   (torddef(right.resulttype.def).typ=u64bit));
        case nodetype of
          addn :
            begin
              op:=OP_ADD;
              mboverflow:=true;
            end;
          subn :
            begin
              op:=OP_SUB;
              op1:=A_SUB;
              op2:=A_SBB;
              mboverflow:=true;
            end;
          ltn,lten,
          gtn,gten,
          equaln,unequaln:
            begin
              op:=OP_NONE;
              cmpop:=true;
            end;
          xorn:
            op:=OP_XOR;
          orn:
            op:=OP_OR;
          andn:
            op:=OP_AND;
          else
            begin
              { everything should be handled in pass_1 (JM) }
              internalerror(200109051);
            end;
        end;

        { left and right no register?  }
        { then one must be demanded    }
        if (left.location.loc<>LOC_REGISTER) then
         begin
           if (right.location.loc<>LOC_REGISTER) then
            begin
              { we can reuse a CREGISTER for comparison }
              if not((left.location.loc=LOC_CREGISTER) and cmpop) then
               begin
                 delete:=left.location.loc<>LOC_CREGISTER;
                 hregister:=cg.getintregister(exprasmlist,OS_INT);
                 hregister2:=cg.getintregister(exprasmlist,OS_INT);
                 cg64.a_load64_loc_reg(exprasmlist,left.location,joinreg64(hregister,hregister2),delete);
                 location_reset(left.location,LOC_REGISTER,OS_64);
                 left.location.registerlow:=hregister;
                 left.location.registerhigh:=hregister2;
               end;
            end
           else
            begin
              location_swap(left.location,right.location);
              toggleflag(nf_swaped);
            end;
         end;

        { at this point, left.location.loc should be LOC_REGISTER }
        if right.location.loc=LOC_REGISTER then
         begin
           { when swapped another result register }
           if (nodetype=subn) and (nf_swaped in flags) then
            begin
              cg64.a_op64_reg_reg(exprasmlist,op,
                left.location.register64,
                right.location.register64);
              location_swap(left.location,right.location);
              toggleflag(nf_swaped);
            end
           else if cmpop then
            begin
              emit_reg_reg(A_CMP,S_L,right.location.registerhigh,left.location.registerhigh);
              firstjmp64bitcmp;
              emit_reg_reg(A_CMP,S_L,right.location.registerlow,left.location.registerlow);
              secondjmp64bitcmp;
            end
           else
            begin
              cg64.a_op64_reg_reg(exprasmlist,op,
                right.location.register64,
                left.location.register64);
            end;
           location_release(exprasmlist,right.location);
         end
        else
         begin
           { right.location<>LOC_REGISTER }
           if (nodetype=subn) and (nf_swaped in flags) then
            begin
              r:=cg.getintregister(exprasmlist,OS_INT);
              cg64.a_load64low_loc_reg(exprasmlist,right.location,r);
              emit_reg_reg(op1,opsize,left.location.registerlow,r);
              emit_reg_reg(A_MOV,opsize,r,left.location.registerlow);
              cg64.a_load64high_loc_reg(exprasmlist,right.location,r);
              { the carry flag is still ok }
              emit_reg_reg(op2,opsize,left.location.registerhigh,r);
              emit_reg_reg(A_MOV,opsize,r,left.location.registerhigh);
              cg.ungetregister(exprasmlist,r);
              if right.location.loc<>LOC_CREGISTER then
               begin
                 location_freetemp(exprasmlist,right.location);
                 location_release(exprasmlist,right.location);
               end;
            end
           else if cmpop then
            begin
              case right.location.loc of
                LOC_CREGISTER :
                  begin
                    emit_reg_reg(A_CMP,S_L,right.location.registerhigh,left.location.registerhigh);
                    firstjmp64bitcmp;
                    emit_reg_reg(A_CMP,S_L,right.location.registerlow,left.location.registerlow);
                    secondjmp64bitcmp;
                  end;
                LOC_CREFERENCE,
                LOC_REFERENCE :
                  begin
                    href:=right.location.reference;
                    inc(href.offset,4);
                    emit_ref_reg(A_CMP,S_L,href,left.location.registerhigh);
                    firstjmp64bitcmp;
                    emit_ref_reg(A_CMP,S_L,right.location.reference,left.location.registerlow);
                    secondjmp64bitcmp;
                    cg.a_jmp_always(exprasmlist,falselabel);
                    location_freetemp(exprasmlist,right.location);
                    location_release(exprasmlist,right.location);
                  end;
                LOC_CONSTANT :
                  begin
                    exprasmlist.concat(taicpu.op_const_reg(A_CMP,S_L,hi(right.location.valueqword),left.location.registerhigh));
                    firstjmp64bitcmp;
                    exprasmlist.concat(taicpu.op_const_reg(A_CMP,S_L,lo(right.location.valueqword),left.location.registerlow));
                    secondjmp64bitcmp;
                  end;
                else
                  internalerror(200203282);
              end;
            end

           else
            begin
              cg64.a_op64_loc_reg(exprasmlist,op,right.location,
                left.location.register64);
              if (right.location.loc<>LOC_CREGISTER) then
               begin
                 location_freetemp(exprasmlist,right.location);
                 location_release(exprasmlist,right.location);
               end;
            end;
         end;

        if (left.location.loc<>LOC_CREGISTER) and cmpop then
         begin
           location_freetemp(exprasmlist,left.location);
           location_release(exprasmlist,left.location);
         end;

        { only in case of overflow operations }
        { produce overflow code }
        { we must put it here directly, because sign of operation }
        { is in unsigned VAR!!                              }
        if mboverflow then
         begin
           if cs_check_overflow in aktlocalswitches  then
            begin
              objectlibrary.getlabel(hl4);
              if unsigned then
               cg.a_jmp_flags(exprasmlist,F_AE,hl4)
              else
               cg.a_jmp_flags(exprasmlist,F_NO,hl4);
              cg.a_call_name(exprasmlist,'FPC_OVERFLOW');
              cg.a_label(exprasmlist,hl4);
            end;
         end;

        { we have LOC_JUMP as result }
        if cmpop then
         location_reset(location,LOC_JUMP,OS_NO)
        else
         location_copy(location,left.location);
      end;


{*****************************************************************************
                                AddMMX
*****************************************************************************}

{$ifdef SUPPORT_MMX}
    procedure ti386addnode.second_addmmx;
      var
        op         : TAsmOp;
        pushedfpu,
        cmpop      : boolean;
        mmxbase    : tmmxtype;
        hreg,
        hregister  : tregister;
      begin
        pass_left_and_right(pushedfpu);

        cmpop:=false;
        mmxbase:=mmx_type(left.resulttype.def);
        case nodetype of
          addn :
            begin
              if (cs_mmx_saturation in aktlocalswitches) then
                begin
                   case mmxbase of
                      mmxs8bit:
                        op:=A_PADDSB;
                      mmxu8bit:
                        op:=A_PADDUSB;
                      mmxs16bit,mmxfixed16:
                        op:=A_PADDSB;
                      mmxu16bit:
                        op:=A_PADDUSW;
                   end;
                end
              else
                begin
                   case mmxbase of
                      mmxs8bit,mmxu8bit:
                        op:=A_PADDB;
                      mmxs16bit,mmxu16bit,mmxfixed16:
                        op:=A_PADDW;
                      mmxs32bit,mmxu32bit:
                        op:=A_PADDD;
                   end;
                end;
            end;
          muln :
            begin
               case mmxbase of
                  mmxs16bit,mmxu16bit:
                    op:=A_PMULLW;
                  mmxfixed16:
                    op:=A_PMULHW;
               end;
            end;
          subn :
            begin
              if (cs_mmx_saturation in aktlocalswitches) then
                begin
                   case mmxbase of
                      mmxs8bit:
                        op:=A_PSUBSB;
                      mmxu8bit:
                        op:=A_PSUBUSB;
                      mmxs16bit,mmxfixed16:
                        op:=A_PSUBSB;
                      mmxu16bit:
                        op:=A_PSUBUSW;
                   end;
                end
              else
                begin
                   case mmxbase of
                      mmxs8bit,mmxu8bit:
                        op:=A_PSUBB;
                      mmxs16bit,mmxu16bit,mmxfixed16:
                        op:=A_PSUBW;
                      mmxs32bit,mmxu32bit:
                        op:=A_PSUBD;
                   end;
                end;
            end;
          xorn:
            op:=A_PXOR;
          orn:
            op:=A_POR;
          andn:
            op:=A_PAND;
          else
            internalerror(2003042214);
        end;

        { left and right no register?  }
        { then one must be demanded    }
        if (left.location.loc<>LOC_MMXREGISTER) then
         begin
           if (right.location.loc=LOC_MMXREGISTER) then
            begin
              location_swap(left.location,right.location);
              toggleflag(nf_swaped);
            end
           else
            begin
              { register variable ? }
              if (left.location.loc=LOC_CMMXREGISTER) then
               begin
                 hregister:=cg.getmmxregister(exprasmlist,OS_M64);
                 emit_reg_reg(A_MOVQ,S_NO,left.location.register,hregister);
               end
              else
               begin
                 if not(left.location.loc in [LOC_REFERENCE,LOC_CREFERENCE]) then
                  internalerror(200203245);

                 location_release(exprasmlist,left.location);

                 hregister:=cg.getmmxregister(exprasmlist,OS_M64);
                 emit_ref_reg(A_MOVQ,S_NO,left.location.reference,hregister);
               end;

              location_reset(left.location,LOC_MMXREGISTER,OS_NO);
              left.location.register:=hregister;
            end;
         end;

        { at this point, left.location.loc should be LOC_MMXREGISTER }
        if right.location.loc<>LOC_MMXREGISTER then
         begin
           if (nodetype=subn) and (nf_swaped in flags) then
            begin
              if right.location.loc=LOC_CMMXREGISTER then
               begin
                 hreg:=cg.getmmxregister(exprasmlist,OS_M64);
                 emit_reg_reg(A_MOVQ,S_NO,right.location.register,hreg);
                 emit_reg_reg(op,S_NO,left.location.register,hreg);
                 cg.ungetregister(exprasmlist,hreg);
                 emit_reg_reg(A_MOVQ,S_NO,hreg,left.location.register);
               end
              else
               begin
                 if not(left.location.loc in [LOC_REFERENCE,LOC_CREFERENCE]) then
                  internalerror(200203247);
                 location_release(exprasmlist,right.location);
                 hreg:=cg.getmmxregister(exprasmlist,OS_M64);
                 emit_ref_reg(A_MOVQ,S_NO,right.location.reference,hreg);
                 emit_reg_reg(op,S_NO,left.location.register,hreg);
                 cg.ungetregister(exprasmlist,hreg);
                 emit_reg_reg(A_MOVQ,S_NO,hreg,left.location.register);
               end;
            end
           else
            begin
              if (right.location.loc=LOC_CMMXREGISTER) then
                emit_reg_reg(op,S_NO,right.location.register,left.location.register)
              else
               begin
                 if not(right.location.loc in [LOC_REFERENCE,LOC_CREFERENCE]) then
                  internalerror(200203246);
                 emit_ref_reg(op,S_NO,right.location.reference,left.location.register);
                 location_release(exprasmlist,right.location);
               end;
            end;
          end
        else
          begin
            { right.location=LOC_MMXREGISTER }
            if (nodetype=subn) and (nf_swaped in flags) then
             begin
               emit_reg_reg(op,S_NO,left.location.register,right.location.register);
               location_swap(left.location,right.location);
               toggleflag(nf_swaped);
             end
            else
             begin
               emit_reg_reg(op,S_NO,right.location.register,left.location.register);
             end;
          end;

        location_freetemp(exprasmlist,right.location);
        location_release(exprasmlist,right.location);
        if cmpop then
         begin
           location_freetemp(exprasmlist,left.location);
           location_release(exprasmlist,left.location);
         end;
        set_result_location(cmpop,true);
      end;
{$endif SUPPORT_MMX}

{*****************************************************************************
                                MUL
*****************************************************************************}

    procedure ti386addnode.second_mul;

    var r:Tregister;

    begin
      {The location.register will be filled in later (JM)}
      location_reset(location,LOC_REGISTER,OS_INT);
      {Get a temp register and load the left value into it
       and free the location.}
      r:=cg.getintregister(exprasmlist,OS_INT);
      cg.a_load_loc_reg(exprasmlist,OS_INT,left.location,r);
      location_release(exprasmlist,left.location);
      {Allocate EAX.}
      cg.getexplicitregister(exprasmlist,NR_EAX);
      {Load the right value.}
      cg.a_load_loc_reg(exprasmlist,OS_INT,right.location,NR_EAX);
      location_release(exprasmlist,right.location);
      {The mul instruction frees register r.}
      cg.ungetregister(exprasmlist,r);
      {Also allocate EDX, since it is also modified by a mul (JM).}
      cg.getexplicitregister(exprasmlist,NR_EDX);
      emit_reg(A_MUL,S_L,r);
      {Free EDX}
      cg.ungetregister(exprasmlist,NR_EDX);
      {Free EAX}
      cg.ungetregister(exprasmlist,NR_EAX);
      {Allocate a new register and store the result in EAX in it.}
      location.register:=cg.getintregister(exprasmlist,OS_INT);
      emit_reg_reg(A_MOV,S_L,NR_EAX,location.register);
      location_freetemp(exprasmlist,left.location);
      location_freetemp(exprasmlist,right.location);
    end;


{*****************************************************************************
                                pass_2
*****************************************************************************}

    procedure ti386addnode.pass_2;
    { is also being used for xor, and "mul", "sub, or and comparative }
    { operators                                                }
      var
         pushedfpu,
         mboverflow,cmpop : boolean;
         op : tasmop;
         opsize : topsize;

         { true, if unsigned types are compared }
         unsigned : boolean;
         { is_in_dest if the result is put directly into }
         { the resulting refernce or varregister }
         {is_in_dest : boolean;}
         { true, if for sets subtractions the extra not should generated }
         extra_not : boolean;

      begin
         { to make it more readable, string and set (not smallset!) have their
           own procedures }
         case left.resulttype.def.deftype of
           orddef :
             begin
               { handling boolean expressions }
               if is_boolean(left.resulttype.def) and
                  is_boolean(right.resulttype.def) then
                 begin
                   second_addboolean;
                   exit;
                 end
               { 64bit operations }
               else if is_64bit(left.resulttype.def) then
                 begin
                   second_add64bit;
                   exit;
                 end;
             end;
           stringdef :
             begin
               second_addstring;
               exit;
             end;
           setdef :
             begin
               { normalsets are already handled in pass1 }
               if (tsetdef(left.resulttype.def).settype<>smallset) then
                internalerror(200109041);
               second_addsmallset;
               exit;
             end;
           arraydef :
             begin
{$ifdef SUPPORT_MMX}
               if is_mmx_able_array(left.resulttype.def) then
                begin
                  second_addmmx;
                  exit;
                end;
{$endif SUPPORT_MMX}
             end;
           floatdef :
             begin
               second_addfloat;
               exit;
             end;
         end;

         { defaults }
         {is_in_dest:=false;}
         extra_not:=false;
         mboverflow:=false;
         cmpop:=false;
         unsigned:=not(is_signed(left.resulttype.def)) or
                   not(is_signed(right.resulttype.def));
         opsize:=def_opsize(left.resulttype.def);

         pass_left_and_right(pushedfpu);

         if (left.resulttype.def.deftype=pointerdef) or
            (right.resulttype.def.deftype=pointerdef) or

            (is_class_or_interface(right.resulttype.def) and is_class_or_interface(left.resulttype.def)) or

            (left.resulttype.def.deftype=classrefdef) or

            (left.resulttype.def.deftype=procvardef) or

            ((left.resulttype.def.deftype=enumdef) and
             (left.resulttype.def.size=4)) or

            ((left.resulttype.def.deftype=orddef) and
             (torddef(left.resulttype.def).typ in [s32bit,u32bit])) or
            ((right.resulttype.def.deftype=orddef) and
             (torddef(right.resulttype.def).typ in [s32bit,u32bit])) then
          begin
            case nodetype of
              addn :
                begin
                  op:=A_ADD;
                  mboverflow:=true;
                end;
              muln :
                begin
                  if unsigned then
                    op:=A_MUL
                  else
                    op:=A_IMUL;
                  mboverflow:=true;
                end;
              subn :
                begin
                  op:=A_SUB;
                  mboverflow:=true;
                end;
              ltn,lten,
              gtn,gten,
              equaln,unequaln :
                begin
                  op:=A_CMP;
                  cmpop:=true;
                end;
              xorn :
                op:=A_XOR;
              orn :
                op:=A_OR;
              andn :
                op:=A_AND;
              else
                internalerror(200304229);
            end;

            { filter MUL, which requires special handling }
            if op=A_MUL then
             begin
               second_mul;
               exit;
             end;

            { Convert flags to register first }
            if (left.location.loc=LOC_FLAGS) then
             location_force_reg(exprasmlist,left.location,opsize_2_cgsize[opsize],false);
            if (right.location.loc=LOC_FLAGS) then
             location_force_reg(exprasmlist,right.location,opsize_2_cgsize[opsize],false);

            left_must_be_reg(opsize,false);
            emit_generic_code(op,opsize,unsigned,extra_not,mboverflow);
            location_freetemp(exprasmlist,right.location);
            location_release(exprasmlist,right.location);
            if cmpop and
               (left.location.loc<>LOC_CREGISTER) then
             begin
               location_freetemp(exprasmlist,left.location);
               location_release(exprasmlist,left.location);
             end;
            set_result_location(cmpop,unsigned);
          end

         { 8/16 bit enum,char,wchar types }
         else
          if ((left.resulttype.def.deftype=orddef) and
              (torddef(left.resulttype.def).typ in [uchar,uwidechar])) or
             ((left.resulttype.def.deftype=enumdef) and
              ((left.resulttype.def.size=1) or
               (left.resulttype.def.size=2))) then
           begin
             case nodetype of
               ltn,lten,gtn,gten,
               equaln,unequaln :
                 cmpop:=true;
               else
                 internalerror(2003042210);
             end;
             left_must_be_reg(opsize,false);
             emit_op_right_left(A_CMP,opsize);
             location_freetemp(exprasmlist,right.location);
             location_release(exprasmlist,right.location);
             if left.location.loc<>LOC_CREGISTER then
              begin
                location_freetemp(exprasmlist,left.location);
                location_release(exprasmlist,left.location);
              end;
             set_result_location(true,true);
           end
         else
           internalerror(2003042211);
      end;

begin
   caddnode:=ti386addnode;
end.
{
  $Log$
  Revision 1.84  2003-10-13 01:58:03  florian
    * some ideas for mm support implemented

  Revision 1.83  2003/10/10 17:48:14  peter
    * old trgobj moved to x86/rgcpu and renamed to trgx86fpu
    * tregisteralloctor renamed to trgobj
    * removed rgobj from a lot of units
    * moved location_* and reference_* to cgobj
    * first things for mmx register allocation

  Revision 1.82  2003/10/09 21:31:37  daniel
    * Register allocator splitted, ans abstract now

  Revision 1.81  2003/10/08 09:13:16  florian
    * fixed full bool evalution and bool xor, if the left or right side have LOC_JUMP

  Revision 1.80  2003/10/01 20:34:49  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.79  2003/09/28 21:48:20  peter
    * fix register leaks

  Revision 1.78  2003/09/28 13:35:40  peter
    * shortstr compare updated for different calling conventions

  Revision 1.77  2003/09/10 08:31:48  marco
   * Patch from Peter for paraloc

  Revision 1.76  2003/09/03 15:55:01  peter
    * NEWRA branch merged

  Revision 1.75.2.2  2003/08/31 13:50:16  daniel
    * Remove sorting and use pregenerated indexes
    * Some work on making things compile

  Revision 1.75.2.1  2003/08/29 17:29:00  peter
    * next batch of updates

  Revision 1.75  2003/08/03 20:38:00  daniel
    * Made code generator reverse or/add/and/xor/imul instructions when
      possible to reduce the slowdown of spills.

  Revision 1.74  2003/08/03 20:19:43  daniel
    - Removed cmpop from Ti386addnode.second_addstring

  Revision 1.73  2003/07/06 15:31:21  daniel
    * Fixed register allocator. *Lots* of fixes.

  Revision 1.72  2003/06/17 16:51:30  peter
    * cycle fixes

  Revision 1.71  2003/06/07 18:57:04  jonas
    + added freeintparaloc
    * ppc get/freeintparaloc now check whether the parameter regs are
      properly allocated/deallocated (and get an extra list para)
    * ppc a_call_* now internalerrors if pi_do_call is not yet set
    * fixed lot of missing pi_do_call's

  Revision 1.70  2003/06/03 13:01:59  daniel
    * Register allocator finished

  Revision 1.69  2003/05/30 23:49:18  jonas
    * a_load_loc_reg now has an extra size parameter for the destination
      register (properly fixes what I worked around in revision 1.106 of
      ncgutil.pas)

  Revision 1.68  2003/05/26 19:38:28  peter
    * generic fpc_shorstr_concat
    + fpc_shortstr_append_shortstr optimization

  Revision 1.67  2003/05/22 21:32:29  peter
    * removed some unit dependencies

  Revision 1.66  2003/04/26 09:12:55  peter
    * add string returns in LOC_REFERENCE

  Revision 1.65  2003/04/23 20:16:04  peter
    + added currency support based on int64
    + is_64bit for use in cg units instead of is_64bitint
    * removed cgmessage from n386add, replace with internalerrors

  Revision 1.64  2003/04/23 09:51:16  daniel
    * Removed usage of edi in a lot of places when new register allocator used
    + Added newra versions of g_concatcopy and secondadd_float

  Revision 1.63  2003/04/22 23:50:23  peter
    * firstpass uses expectloc
    * checks if there are differences between the expectloc and
      location.loc from secondpass in EXTDEBUG

  Revision 1.62  2003/04/22 10:09:35  daniel
    + Implemented the actual register allocator
    + Scratch registers unavailable when new register allocator used
    + maybe_save/maybe_restore unavailable when new register allocator used

  Revision 1.61  2003/04/17 10:02:48  daniel
    * Tweaked register allocate/deallocate positition to less interferences
      are generated.

  Revision 1.60  2003/03/28 19:16:57  peter
    * generic constructor working for i386
    * remove fixed self register
    * esi added as address register for i386

  Revision 1.59  2003/03/13 19:52:23  jonas
    * and more new register allocator fixes (in the i386 code generator this
      time). At least now the ppc cross compiler can compile the linux
      system unit again, but I haven't tested it.

  Revision 1.58  2003/03/08 20:36:41  daniel
    + Added newra version of Ti386shlshrnode
    + Added interference graph construction code

  Revision 1.57  2003/03/08 13:59:17  daniel
    * Work to handle new register notation in ag386nsm
    + Added newra version of Ti386moddivnode

  Revision 1.56  2003/03/08 10:53:48  daniel
    * Created newra version of secondmul in n386add.pas

  Revision 1.55  2003/02/19 22:00:15  daniel
    * Code generator converted to new register notation
    - Horribily outdated todo.txt removed

  Revision 1.54  2003/01/13 18:37:44  daniel
    * Work on register conversion

  Revision 1.53  2003/01/08 18:43:57  daniel
   * Tregister changed into a record

  Revision 1.52  2002/11/25 17:43:26  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.51  2002/11/15 01:58:56  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.50  2002/10/20 13:11:27  jonas
    * re-enabled optimized version of comparisons with the empty string that
      I accidentally disabled in revision 1.26

  Revision 1.49  2002/08/23 16:14:49  peter
    * tempgen cleanup
    * tt_noreuse temp type added that will be used in genentrycode

  Revision 1.48  2002/08/14 18:41:48  jonas
    - remove valuelow/valuehigh fields from tlocation, because they depend
      on the endianess of the host operating system -> difficult to get
      right. Use lo/hi(location.valueqword) instead (remember to use
      valueqword and not value!!)

  Revision 1.47  2002/08/11 14:32:29  peter
    * renamed current_library to objectlibrary

  Revision 1.46  2002/08/11 13:24:16  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.45  2002/07/26 11:17:52  jonas
    * the optimization of converting a multiplication with a power of two to
      a shl is moved from n386add/secondpass to nadd/resulttypepass

  Revision 1.44  2002/07/20 11:58:00  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.43  2002/07/11 14:41:32  florian
    * start of the new generic parameter handling

  Revision 1.42  2002/07/07 09:52:33  florian
    * powerpc target fixed, very simple units can be compiled
    * some basic stuff for better callparanode handling, far from being finished

  Revision 1.41  2002/07/01 18:46:31  peter
    * internal linker
    * reorganized aasm layer

  Revision 1.40  2002/07/01 16:23:55  peter
    * cg64 patch
    * basics for currency
    * asnode updates for class and interface (not finished)

  Revision 1.39  2002/05/18 13:34:22  peter
    * readded missing revisions

  Revision 1.38  2002/05/16 19:46:51  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.36  2002/05/13 19:54:37  peter
    * removed n386ld and n386util units
    * maybe_save/maybe_restore added instead of the old maybe_push

  Revision 1.35  2002/05/12 16:53:17  peter
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

  Revision 1.34  2002/04/25 20:16:40  peter
    * moved more routines from cga/n386util

  Revision 1.33  2002/04/05 15:09:13  jonas
    * fixed web bug 1915

  Revision 1.32  2002/04/04 19:06:10  peter
    * removed unused units
    * use tlocation.size in cg.a_*loc*() routines

  Revision 1.31  2002/04/02 17:11:35  peter
    * tlocation,treference update
    * LOC_CONSTANT added for better constant handling
    * secondadd splitted in multiple routines
    * location_force_reg added for loading a location to a register
      of a specified size
    * secondassignment parses now first the right and then the left node
      (this is compatible with Kylix). This saves a lot of push/pop especially
      with string operations
    * adapted some routines to use the new cg methods

  Revision 1.29  2002/03/04 19:10:13  peter
    * removed compiler warnings

}