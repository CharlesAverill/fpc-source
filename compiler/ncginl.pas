{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl and Carl Eric Codere

    Generate generic inline nodes

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
unit ncginl;

{$i fpcdefs.inc}

interface

    uses
       node,ninl;

    type
       tcginlinenode = class(tinlinenode)
          procedure pass_2;override;
          procedure second_assert;virtual;
          procedure second_sizeoftypeof;virtual;
          procedure second_length;virtual;
          procedure second_predsucc;virtual;
          procedure second_incdec;virtual;
          procedure second_typeinfo;virtual;
          procedure second_includeexclude;virtual;
          procedure second_pi; virtual;
          procedure second_arctan_real; virtual;
          procedure second_abs_real; virtual;
          procedure second_sqr_real; virtual;
          procedure second_sqrt_real; virtual;
          procedure second_ln_real; virtual;
          procedure second_cos_real; virtual;
          procedure second_sin_real; virtual;
          procedure second_assigned; virtual;
       end;

implementation

    uses
      globtype,systems,
      cutils,verbose,globals,fmodule,
      symconst,symdef,defutil,symsym,
      aasmbase,aasmtai,aasmcpu,
      cgbase,pass_1,pass_2,
      cpuinfo,cpubase,paramgr,procinfo,
      nbas,ncon,ncal,ncnv,nld,
      tgobj,ncgutil,cgobj
{$ifndef cpu64bit}
      ,cg64f32
{$endif cpu64bit}
      ;


{*****************************************************************************
                              TCGINLINENODE
*****************************************************************************}


    procedure tcginlinenode.pass_2;
      begin
         location_reset(location,LOC_VOID,OS_NO);

         case inlinenumber of
            in_assert_x_y:
              begin
                 second_Assert;
              end;
            in_sizeof_x,
            in_typeof_x :
              begin
                 second_SizeofTypeOf;
              end;
            in_length_x :
              begin
                 second_Length;
              end;
            in_pred_x,
            in_succ_x:
              begin
                 second_PredSucc;
              end;
            in_dec_x,
            in_inc_x :
              begin
                second_IncDec;
              end;
            in_typeinfo_x:
               begin
                  second_TypeInfo;
               end;
            in_include_x_y,
            in_exclude_x_y:
              begin
                 second_IncludeExclude;
              end;
            in_pi:
              begin
                second_pi;
              end;
            in_sin_extended:
              begin
                second_sin_real;
              end;
            in_arctan_extended:
              begin
                second_arctan_real;
              end;
            in_abs_extended:
              begin
                second_abs_real;
              end;
            in_sqr_extended:
              begin
                second_sqr_real;
              end;
            in_sqrt_extended:
              begin
                second_sqrt_real;
              end;
            in_ln_extended:
              begin
                second_ln_real;
              end;
            in_cos_extended:
              begin
                 second_cos_real;
              end;
            in_assigned_x:
              begin
                second_assigned;
              end;
{$ifdef SUPPORT_MMX}
            in_mmx_pcmpeqb..in_mmx_pcmpgtw:
              begin
                 location_reset(location,LOC_MMXREGISTER,OS_NO);
                 if left.location.loc=LOC_REGISTER then
                   begin
                      {!!!!!!!}
                   end
                 else if tcallparanode(left).left.location.loc=LOC_REGISTER then
                   begin
                      {!!!!!!!}
                   end
                 else
                   begin
                      {!!!!!!!}
                   end;
              end;
{$endif SUPPORT_MMX}
            else internalerror(9);
         end;
      end;


{*****************************************************************************
                          ASSERT GENERIC HANDLING
*****************************************************************************}
    procedure tcginlinenode.second_Assert;
     var
       hp2 : tstringconstnode;
       otlabel,oflabel : tasmlabel;
       paraloc1,paraloc2,
       paraloc3,paraloc4 : tparalocation;
     begin
       { the node should be removed in the firstpass }
       if not (cs_do_assertion in aktlocalswitches) then
          internalerror(7123458);
       paraloc1:=paramanager.getintparaloc(pocall_default,1);
       paraloc2:=paramanager.getintparaloc(pocall_default,2);
       paraloc3:=paramanager.getintparaloc(pocall_default,3);
       paraloc4:=paramanager.getintparaloc(pocall_default,4);
       otlabel:=truelabel;
       oflabel:=falselabel;
       objectlibrary.getlabel(truelabel);
       objectlibrary.getlabel(falselabel);
       secondpass(tcallparanode(left).left);
       maketojumpbool(exprasmlist,tcallparanode(left).left,lr_load_regvars);
       cg.a_label(exprasmlist,falselabel);
       { erroraddr }
       paramanager.allocparaloc(exprasmlist,paraloc4);
       cg.a_param_reg(exprasmlist,OS_ADDR,NR_FRAME_POINTER_REG,paraloc4);
       { lineno }
       paramanager.allocparaloc(exprasmlist,paraloc3);
       cg.a_param_const(exprasmlist,OS_INT,aktfilepos.line,paraloc3);
       { filename string }
       hp2:=cstringconstnode.createstr(current_module.sourcefiles.get_file_name(aktfilepos.fileindex),st_shortstring);
       firstpass(tnode(hp2));
       secondpass(tnode(hp2));
       if codegenerror then
          exit;
       paramanager.allocparaloc(exprasmlist,paraloc2);
       cg.a_paramaddr_ref(exprasmlist,hp2.location.reference,paraloc2);
       hp2.free;
       { push msg }
       secondpass(tcallparanode(tcallparanode(left).right).left);
       paramanager.allocparaloc(exprasmlist,paraloc1);
       cg.a_paramaddr_ref(exprasmlist,tcallparanode(tcallparanode(left).right).left.location.reference,paraloc1);
       { call }
       paramanager.freeparaloc(exprasmlist,paraloc1);
       paramanager.freeparaloc(exprasmlist,paraloc2);
       paramanager.freeparaloc(exprasmlist,paraloc3);
       paramanager.freeparaloc(exprasmlist,paraloc4);
       cg.allocexplicitregisters(exprasmlist,R_INTREGISTER,paramanager.get_volatile_registers_int(pocall_default));
       cg.a_call_name(exprasmlist,'FPC_ASSERT');
       cg.deallocexplicitregisters(exprasmlist,R_INTREGISTER,paramanager.get_volatile_registers_int(pocall_default));
       cg.a_label(exprasmlist,truelabel);
       truelabel:=otlabel;
       falselabel:=oflabel;
     end;


{*****************************************************************************
                          SIZEOF / TYPEOF GENERIC HANDLING
*****************************************************************************}

    { second_handle_ the sizeof and typeof routines }
    procedure tcginlinenode.second_SizeOfTypeOf;
      var
         href,
         hrefvmt   : treference;
         hregister : tregister;
      begin
        location_reset(location,LOC_REGISTER,OS_ADDR);
        { for both cases load vmt }
        if left.nodetype=typen then
          begin
            hregister:=cg.getaddressregister(exprasmlist);
            reference_reset_symbol(href,objectlibrary.newasmsymboldata(tobjectdef(left.resulttype.def).vmt_mangledname),0);
            cg.a_loadaddr_ref_reg(exprasmlist,href,hregister);
          end
        else
          begin
            secondpass(left);
            location_release(exprasmlist,left.location);
            hregister:=cg.getaddressregister(exprasmlist);

            { handle self inside a method of a class }
            case left.location.loc of
              LOC_CREGISTER,
              LOC_REGISTER :
                begin
                  if (left.resulttype.def.deftype=classrefdef) or
                     (po_staticmethod in current_procinfo.procdef.procoptions) then
                    cg.a_load_reg_reg(exprasmlist,OS_ADDR,OS_ADDR,left.location.register,hregister)
                  else
                   begin
                     { load VMT pointer }
                     reference_reset_base(hrefvmt,left.location.register,tobjectdef(left.resulttype.def).vmt_offset);
                     cg.a_load_ref_reg(exprasmlist,OS_ADDR,OS_ADDR,hrefvmt,hregister);
                   end
                end;
              LOC_REFERENCE,
              LOC_CREFERENCE :
                begin
                  if is_class(left.resulttype.def) then
                   begin
                     { deref class }
                     cg.a_load_ref_reg(exprasmlist,OS_ADDR,OS_ADDR,left.location.reference,hregister);
                     cg.g_maybe_testself(exprasmlist,hregister);
                     { load VMT pointer }
                     reference_reset_base(hrefvmt,hregister,tobjectdef(left.resulttype.def).vmt_offset);
                     cg.a_load_ref_reg(exprasmlist,OS_ADDR,OS_ADDR,hrefvmt,hregister);
                   end
                  else
                   begin
                     { load VMT pointer, but not for classrefdefs }
                     if (left.resulttype.def.deftype=objectdef) then
                       inc(left.location.reference.offset,tobjectdef(left.resulttype.def).vmt_offset);
                     cg.a_load_ref_reg(exprasmlist,OS_ADDR,OS_ADDR,left.location.reference,hregister);
                   end;
                end;
              else
                internalerror(200301301);
            end;
          end;
        { in sizeof load size }
        if inlinenumber=in_sizeof_x then
           begin
             reference_reset_base(href,hregister,0);
             cg.ungetregister(exprasmlist,hregister);
             hregister:=cg.getintregister(exprasmlist,OS_INT);
             cg.a_load_ref_reg(exprasmlist,OS_INT,OS_INT,href,hregister);
           end;
        location.register:=hregister;
     end;



{*****************************************************************************
                          LENGTH GENERIC HANDLING
*****************************************************************************}

    procedure tcginlinenode.second_Length;
      var
        lengthlab : tasmlabel;
        hregister : tregister;
        href : treference;
      begin
        secondpass(left);
        if is_shortstring(left.resulttype.def) then
         begin
           location_copy(location,left.location);
           location.size:=OS_8;
         end
        else
         begin
           { length in ansi strings is at offset -8 }
           location_force_reg(exprasmlist,left.location,OS_ADDR,false);
           hregister:=left.location.register;
           objectlibrary.getlabel(lengthlab);
           cg.a_cmp_const_reg_label(exprasmlist,OS_ADDR,OC_EQ,0,hregister,lengthlab);
           reference_reset_base(href,hregister,-8);
           cg.a_load_ref_reg(exprasmlist,OS_32,OS_32,href,hregister);
           cg.a_label(exprasmlist,lengthlab);
           location_reset(location,LOC_REGISTER,OS_32);
           location.register:=hregister;
         end;
      end;


{*****************************************************************************
                         PRED/SUCC GENERIC HANDLING
*****************************************************************************}

    procedure tcginlinenode.second_PredSucc;
      var
         cgsize : TCGSize;
         cgop : topcg;
      begin
        secondpass(left);
        if inlinenumber=in_pred_x then
           cgop:=OP_SUB
        else
           cgop:=OP_ADD;
        cgsize:=def_cgsize(resulttype.def);

        { we need a value in a register }
        location_copy(location,left.location);
        location_force_reg(exprasmlist,location,cgsize,false);

        if cgsize in [OS_64,OS_S64] then
          cg64.a_op64_const_reg(exprasmlist,cgop,1,
                      location.register64)
        else
          cg.a_op_const_reg(exprasmlist,cgop,location.size,1,location.register);

        cg.g_rangecheck(exprasmlist,location,resulttype.def,resulttype.def);
      end;


{*****************************************************************************
                         INC/DEC GENERIC HANDLING
*****************************************************************************}
      procedure tcginlinenode.second_IncDec;
       const
         addsubop:array[in_inc_x..in_dec_x] of TOpCG=(OP_ADD,OP_SUB);
        var
         addvalue : TConstExprInt;
         addconstant : boolean;
{$ifndef cpu64bit}
         hregisterhi,
{$endif cpu64bit}
         hregister : tregister;
         cgsize : tcgsize;
        begin
          { set defaults }
          addconstant:=true;
          { load first parameter, must be a reference }
          secondpass(tcallparanode(left).left);
          cgsize:=def_cgsize(tcallparanode(left).left.resulttype.def);
          { get addvalue }
          case tcallparanode(left).left.resulttype.def.deftype of
            orddef,
            enumdef :
                addvalue:=1;
            pointerdef :
               begin
                 if is_void(tpointerdef(tcallparanode(left).left.resulttype.def).pointertype.def) then
                   addvalue:=1
                 else
                   addvalue:=tpointerdef(tcallparanode(left).left.resulttype.def).pointertype.def.size;
               end;
           else
               internalerror(10081);
          end;
          { second_ argument specified?, must be a s32bit in register }
          if assigned(tcallparanode(left).right) then
            begin
              secondpass(tcallparanode(tcallparanode(left).right).left);
              { when constant, just multiply the addvalue }
              if is_constintnode(tcallparanode(tcallparanode(left).right).left) then
                 addvalue:=addvalue*get_ordinal_value(tcallparanode(tcallparanode(left).right).left)
              else
                begin
                  location_force_reg(exprasmlist,tcallparanode(tcallparanode(left).right).left.location,cgsize,false);
                  hregister:=tcallparanode(tcallparanode(left).right).left.location.register;
{$ifndef cpu64bit}
                  hregisterhi:=tcallparanode(tcallparanode(left).right).left.location.registerhigh;
{$endif cpu64bit}
                  { insert multiply with addvalue if its >1 }
                  if addvalue>1 then
                    cg.a_op_const_reg(exprasmlist,OP_IMUL,cgsize,addvalue,hregister);
                  addconstant:=false;
                end;
            end;
          { write the add instruction }
          if addconstant then
            begin
              if cgsize in [OS_64,OS_S64] then
               cg64.a_op64_const_loc(exprasmlist,addsubop[inlinenumber],
                  addvalue,tcallparanode(left).left.location)
              else
               cg.a_op_const_loc(exprasmlist,addsubop[inlinenumber],
                  aword(addvalue),tcallparanode(left).left.location);
            end
           else
             begin
{$ifndef cpu64bit}
               if cgsize in [OS_64,OS_S64] then
                 cg64.a_op64_reg_loc(exprasmlist,addsubop[inlinenumber],
                   joinreg64(hregister,hregisterhi),tcallparanode(left).left.location)
               else
{$endif cpu64bit}
                 cg.a_op_reg_loc(exprasmlist,addsubop[inlinenumber],
                   hregister,tcallparanode(left).left.location);
               location_release(exprasmlist,tcallparanode(tcallparanode(left).right).left.location);
             end;
          location_release(exprasmlist,tcallparanode(left).left.location);
          cg.g_overflowcheck(exprasmlist,tcallparanode(left).left.location,tcallparanode(left).resulttype.def);
          cg.g_rangecheck(exprasmlist,tcallparanode(left).left.location,tcallparanode(left).left.resulttype.def,
              tcallparanode(left).left.resulttype.def);
        end;


{*****************************************************************************
                         TYPEINFO GENERIC HANDLING
*****************************************************************************}
      procedure tcginlinenode.second_typeinfo;
        var
         href : treference;
        begin
          location_reset(location,LOC_REGISTER,OS_ADDR);
          location.register:=cg.getaddressregister(exprasmlist);
          reference_reset_symbol(href,tstoreddef(left.resulttype.def).get_rtti_label(fullrtti),0);
          cg.a_loadaddr_ref_reg(exprasmlist,href,location.register);
        end;


{*****************************************************************************
                     INCLUDE/EXCLUDE GENERIC HANDLING
*****************************************************************************}

      procedure tcginlinenode.second_IncludeExclude;
        var
          L : longint;
          cgop : topcg;
          addrreg2,addrreg,
          hregister,hregister2: tregister;
          use_small : boolean;
          cgsize : tcgsize;
          href : treference;
        begin
          secondpass(tcallparanode(left).left);
          if tcallparanode(tcallparanode(left).right).left.nodetype=ordconstn then
            begin
              { calculate bit position }
              l:=1 shl (tordconstnode(tcallparanode(tcallparanode(left).right).left).value mod 32);

              { determine operator }
              if inlinenumber=in_include_x_y then
                cgop:=OP_OR
              else
                begin
                  cgop:=OP_AND;
                  l:=not(l);
                end;
              if (tcallparanode(left).left.location.loc=LOC_REFERENCE) then
                begin
                  inc(tcallparanode(left).left.location.reference.offset,
                    (tordconstnode(tcallparanode(tcallparanode(left).right).left).value div 32)*4);
                  cg.a_op_const_ref(exprasmlist,cgop,OS_INT,aword(l),tcallparanode(left).left.location.reference);
                  location_release(exprasmlist,tcallparanode(left).left.location);
                end
              else
                { LOC_CREGISTER }
                begin
                  cg.a_op_const_reg(exprasmlist,cgop,tcallparanode(left).left.location.size,aword(l),tcallparanode(left).left.location.register);
                end;
            end
          else
            begin
              use_small:=
                 { set type }
                 (tsetdef(tcallparanode(left).left.resulttype.def).settype=smallset)
                  and
                   { elemenut number between 1 and 32 }
                  ((tcallparanode(tcallparanode(left).right).left.resulttype.def.deftype=orddef) and
                   (torddef(tcallparanode(tcallparanode(left).right).left.resulttype.def).high<=32) or
                   (tcallparanode(tcallparanode(left).right).left.resulttype.def.deftype=enumdef) and
                   (tenumdef(tcallparanode(tcallparanode(left).right).left.resulttype.def).max<=32));

              { generate code for the element to set }
              secondpass(tcallparanode(tcallparanode(left).right).left);

              { bitnumber - which must be loaded into register }
              hregister:=cg.getintregister(exprasmlist,OS_32);
              hregister2:=cg.getintregister(exprasmlist,OS_32);

              cg.a_load_loc_reg(exprasmlist,OS_32,
                  tcallparanode(tcallparanode(left).right).left.location,hregister);

              if use_small then
                begin
                  { hregister contains the bitnumber to add }
                  cg.a_load_const_reg(exprasmlist, OS_32, 1, hregister2);
                  cg.a_op_reg_reg(exprasmlist, OP_SHL, OS_32, hregister, hregister2);

                  { possiblities :
                       bitnumber : LOC_REFERENCE, LOC_REGISTER, LOC_CREGISTER
                       set value : LOC_REFERENCE, LOC_REGISTER
                  }
                  { location of set }
                  if (tcallparanode(left).left.location.loc=LOC_REFERENCE) then
                    begin
                      if inlinenumber=in_include_x_y then
                        begin
                          cg.a_op_reg_ref(exprasmlist, OP_OR, OS_32, hregister2,
                          tcallparanode(left).left.location.reference);
                        end
                      else
                        begin
                          cg.a_op_reg_reg(exprasmlist, OP_NOT, OS_32, hregister2,hregister2);
                          cg.a_op_reg_ref(exprasmlist, OP_AND, OS_32, hregister2,
                              tcallparanode(left).left.location.reference);
                        end;
                    end
                  else
                    internalerror(20020728);
                end
              else
                begin
                  { possiblities :
                       bitnumber : LOC_REFERENCE, LOC_REGISTER, LOC_CREGISTER
                       set value : LOC_REFERENCE
                  }
                  { hregister contains the bitnumber (div 32 to get the correct offset) }
                  { hregister contains the bitnumber to add }

                  cg.a_op_const_reg_reg(exprasmlist, OP_SHR, OS_32, 5, hregister,hregister2);
                  cg.a_op_const_reg(exprasmlist, OP_SHL, OS_32, 2, hregister2);
                  addrreg:=cg.getaddressregister(exprasmlist);
                  { we need an extra address register to be able to do an ADD operation }
                  addrreg2:=cg.getaddressregister(exprasmlist);
                  cg.a_load_reg_reg(exprasmlist,OS_32,OS_ADDR,hregister2,addrreg2);
                  { calculate the correct address of the operand }
                  cg.a_loadaddr_ref_reg(exprasmlist, tcallparanode(left).left.location.reference,addrreg);
                  cg.a_op_reg_reg(exprasmlist, OP_ADD, OS_32, addrreg2, addrreg);
                  cg.ungetregister(exprasmlist,addrreg2);

                  { hregister contains the bitnumber to add }
                  cg.a_load_const_reg(exprasmlist, OS_32, 1, hregister2);
                  cg.a_op_const_reg(exprasmlist, OP_AND, OS_32, 31, hregister);
                  cg.a_op_reg_reg(exprasmlist, OP_SHL, OS_32, hregister, hregister2);

                  reference_reset_base(href,addrreg,0);

                  if inlinenumber=in_include_x_y then
                    cg.a_op_reg_ref(exprasmlist, OP_OR, OS_32, hregister2, href)
                  else
                    begin
                      cg.a_op_reg_reg(exprasmlist, OP_NOT, OS_32, hregister2, hregister2);
                      cg.a_op_reg_ref(exprasmlist, OP_AND, OS_32, hregister2, href);
                    end;
                  cg.ungetregister(exprasmlist,addrreg);
                end;
              cg.ungetregister(exprasmlist,hregister);
              cg.ungetregister(exprasmlist,hregister2);
            end;
        end;


{*****************************************************************************
                            FLOAT GENERIC HANDLING
*****************************************************************************}

{
  These routines all call internal RTL routines, so if they are
  called here, they give an internal error
}
    procedure tcginlinenode.second_pi;
      begin
        internalerror(20020718);
      end;

    procedure tcginlinenode.second_arctan_real;
      begin
        internalerror(20020718);
      end;

    procedure tcginlinenode.second_abs_real;
      begin
        internalerror(20020718);
      end;


    procedure tcginlinenode.second_sqr_real;
      begin
        internalerror(20020718);
      end;

    procedure tcginlinenode.second_sqrt_real;
      begin
        internalerror(20020718);
      end;

    procedure tcginlinenode.second_ln_real;
      begin
        internalerror(20020718);
      end;

    procedure tcginlinenode.second_cos_real;
      begin
        internalerror(20020718);
      end;

    procedure tcginlinenode.second_sin_real;
      begin
        internalerror(20020718);
      end;

{*****************************************************************************
                         ASSIGNED GENERIC HANDLING
*****************************************************************************}

    procedure tcginlinenode.second_assigned;
      begin
        secondpass(tcallparanode(left).left);
        { force left to be an OS_ADDR, since in case of method procvars }
        { the size is 2*OS_ADDR (JM)                                    }
        cg.a_cmp_const_loc_label(exprasmlist,OS_ADDR,OC_NE,0,tcallparanode(left).left.location,truelabel);
        cg.a_jmp_always(exprasmlist,falselabel);
        location_reset(location,LOC_JUMP,OS_NO);
      end;


begin
   cinlinenode:=tcginlinenode;
end.

{
  $Log$
  Revision 1.51  2004-01-31 17:45:17  peter
    * Change several $ifdef i386 to x86
    * Change several OS_32 to OS_INT/OS_ADDR

  Revision 1.50  2003/12/31 20:47:02  jonas
    * properly fixed assigned() mess (by handling it separately in ncginl)
      -> all assigned()-related tests in the test suite work again

  Revision 1.49  2003/12/06 01:15:22  florian
    * reverted Peter's alloctemp patch; hopefully properly

  Revision 1.48  2003/12/03 23:13:20  peter
    * delayed paraloc allocation, a_param_*() gets extra parameter
      if it needs to allocate temp or real paralocation
    * optimized/simplified int-real loading

  Revision 1.47  2003/10/10 17:48:13  peter
    * old trgobj moved to x86/rgcpu and renamed to trgx86fpu
    * tregisteralloctor renamed to trgobj
    * removed rgobj from a lot of units
    * moved location_* and reference_* to cgobj
    * first things for mmx register allocation

  Revision 1.46  2003/10/09 21:31:37  daniel
    * Register allocator splitted, ans abstract now

  Revision 1.45  2003/10/08 19:19:45  peter
    * set_varstate cleanup

  Revision 1.44  2003/10/05 21:21:52  peter
    * c style array of const generates callparanodes
    * varargs paraloc fixes

  Revision 1.43  2003/10/01 20:34:48  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.42  2003/09/10 08:31:47  marco
   * Patch from Peter for paraloc

  Revision 1.41  2003/09/07 22:09:35  peter
    * preparations for different default calling conventions
    * various RA fixes

  Revision 1.40  2003/09/03 15:55:00  peter
    * NEWRA branch merged

  Revision 1.39.2.1  2003/08/29 17:28:59  peter
    * next batch of updates

  Revision 1.39  2003/07/23 11:01:14  jonas
    * several rg.allocexplicitregistersint/rg.deallocexplicitregistersint
      pairs round calls to helpers

  Revision 1.38  2003/07/05 20:07:24  jonas
    * fixed range check errors

  Revision 1.37  2003/06/13 21:19:30  peter
    * current_procdef removed, use current_procinfo.procdef instead

  Revision 1.36  2003/06/07 18:57:04  jonas
    + added freeintparaloc
    * ppc get/freeintparaloc now check whether the parameter regs are
      properly allocated/deallocated (and get an extra list para)
    * ppc a_call_* now internalerrors if pi_do_call is not yet set
    * fixed lot of missing pi_do_call's

  Revision 1.35  2003/06/03 21:11:09  peter
    * cg.a_load_* get a from and to size specifier
    * makeregsize only accepts newregister
    * i386 uses generic tcgnotnode,tcgunaryminus

  Revision 1.34  2003/06/01 21:38:06  peter
    * getregisterfpu size parameter added
    * op_const_reg size parameter added
    * sparc updates

  Revision 1.33  2003/05/24 17:15:59  jonas
    - removed bogus location_copy for include/exclude

  Revision 1.32  2003/05/23 21:10:38  jonas
    * fixed exclude

  Revision 1.31  2003/05/23 14:27:35  peter
    * remove some unit dependencies
    * current_procinfo changes to store more info

  Revision 1.30  2003/05/09 17:47:02  peter
    * self moved to hidden parameter
    * removed hdisposen,hnewn,selfn

  Revision 1.29  2003/05/01 12:27:08  jonas
    * fixed include/exclude for normalsets

  Revision 1.28  2003/04/27 11:21:33  peter
    * aktprocdef renamed to current_procinfo.procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.27  2003/04/25 08:25:26  daniel
    * Ifdefs around a lot of calls to cleartempgen
    * Fixed registers that are allocated but not freed in several nodes
    * Tweak to register allocator to cause less spills
    * 8-bit registers now interfere with esi,edi and ebp
      Compiler can now compile rtl successfully when using new register
      allocator

  Revision 1.26  2003/04/24 22:29:57  florian
    * fixed a lot of PowerPC related stuff

  Revision 1.25  2003/04/22 23:50:22  peter
    * firstpass uses expectloc
    * checks if there are differences between the expectloc and
      location.loc from secondpass in EXTDEBUG

  Revision 1.24  2003/04/22 10:09:35  daniel
    + Implemented the actual register allocator
    + Scratch registers unavailable when new register allocator used
    + maybe_save/maybe_restore unavailable when new register allocator used

  Revision 1.23  2003/04/06 21:11:23  olle
    * changed newasmsymbol to newasmsymboldata for data symbols

  Revision 1.22  2003/03/28 19:16:56  peter
    * generic constructor working for i386
    * remove fixed self register
    * esi added as address register for i386

  Revision 1.21  2003/02/19 22:00:14  daniel
    * Code generator converted to new register notation
    - Horribily outdated todo.txt removed

  Revision 1.20  2003/01/31 22:47:27  peter
    * fix previous typeof change

  Revision 1.19  2003/01/30 21:46:57  peter
    * self fixes for static methods (merged)

  Revision 1.18  2003/01/08 18:43:56  daniel
   * Tregister changed into a record

  Revision 1.17  2002/11/25 17:43:18  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.16  2002/10/05 12:43:25  carl
    * fixes for Delphi 6 compilation
     (warning : Some features do not work under Delphi)

  Revision 1.15  2002/09/30 07:00:46  florian
    * fixes to common code to get the alpha compiler compiled applied

  Revision 1.14  2002/09/17 18:54:02  jonas
    * a_load_reg_reg() now has two size parameters: source and dest. This
      allows some optimizations on architectures that don't encode the
      register size in the register name.

  Revision 1.13  2002/08/13 18:01:52  carl
    * rename swatoperands to swapoperands
    + m68k first compilable version (still needs a lot of testing):
        assembler generator, system information , inline
        assembler reader.

  Revision 1.12  2002/08/11 14:32:26  peter
    * renamed current_library to objectlibrary

  Revision 1.11  2002/08/11 13:24:11  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.10  2002/08/05 18:27:48  carl
    + more more more documentation
    + first version include/exclude (can't test though, not enough scratch for i386 :()...

  Revision 1.9  2002/08/04 19:06:41  carl
    + added generic exception support (still does not work!)
    + more documentation

  Revision 1.8  2002/07/31 07:54:59  jonas
    * re-enabled second_assigned()

  Revision 1.7  2002/07/30 20:50:43  florian
    * the code generator knows now if parameters are in registers

  Revision 1.6  2002/07/29 21:23:42  florian
    * more fixes for the ppc
    + wrappers for the tcnvnode.first_* stuff introduced

  Revision 1.5  2002/07/28 20:45:22  florian
    + added direct assembler reader for PowerPC

  Revision 1.4  2002/07/26 09:45:20  florian
    * fixed a mistake in yesterday's commit, forgot to commit it

  Revision 1.3  2002/07/25 22:58:30  florian
  no message

  Revision 1.2  2002/07/25 17:55:41  carl
    + First working revision

  Revision 1.1  2002/07/24 04:07:49  carl
   + first revision (incomplete)
}
