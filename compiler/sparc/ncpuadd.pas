{
    $Id$
    Copyright (c) 2000-2002 by Florian Klaempfl

    Code generation for add nodes on the SPARC

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
unit ncpuadd;

{$i fpcdefs.inc}

interface

    uses
       node,ncgadd,cpubase;

    type
       tsparcaddnode = class(tcgaddnode)
       private
          function  GetResFlags(unsigned:Boolean):TResFlags;
          function  GetFPUResFlags:TResFlags;
       protected
          procedure second_addfloat;override;
          procedure second_cmpfloat;override;
          procedure second_cmpboolean;override;
          procedure second_cmpsmallset;override;
          procedure second_cmp64bit;override;
          procedure second_cmpordinal;override;
       end;

  implementation

    uses
      systems,
      cutils,verbose,
      paramgr,
      aasmtai,aasmcpu,defutil,
      cgbase,cgcpu,
      cpupara,
      ncon,nset,nadd,
      ncgutil,cgobj;

{*****************************************************************************
                               TSparcAddNode
*****************************************************************************}

    function TSparcAddNode.GetResFlags(unsigned:Boolean):TResFlags;
      begin
        case NodeType of
          equaln:
            GetResFlags:=F_E;
          unequaln:
            GetResFlags:=F_NE;
          else
            if not(unsigned) then
              begin
                if nf_swaped in flags then
                  case NodeType of
                    ltn:
                      GetResFlags:=F_G;
                    lten:
                      GetResFlags:=F_GE;
                    gtn:
                      GetResFlags:=F_L;
                    gten:
                      GetResFlags:=F_LE;
                  end
                else
                  case NodeType of
                    ltn:
                      GetResFlags:=F_L;
                    lten:
                      GetResFlags:=F_LE;
                    gtn:
                      GetResFlags:=F_G;
                    gten:
                      GetResFlags:=F_GE;
                  end;
              end
            else
              begin
                if nf_swaped in Flags then
                  case NodeType of
                    ltn:
                      GetResFlags:=F_A;
                    lten:
                      GetResFlags:=F_AE;
                    gtn:
                      GetResFlags:=F_B;
                    gten:
                      GetResFlags:=F_BE;
                  end
                else
                  case NodeType of
                    ltn:
                      GetResFlags:=F_B;
                    lten:
                      GetResFlags:=F_BE;
                    gtn:
                      GetResFlags:=F_A;
                    gten:
                      GetResFlags:=F_AE;
                  end;
              end;
        end;
      end;


    function TSparcAddNode.GetFPUResFlags:TResFlags;
      begin
        case NodeType of
          equaln:
            result:=F_FE;
          unequaln:
            result:=F_FNE;
          else
            begin
              if nf_swaped in Flags then
                case NodeType of
                  ltn:
                    result:=F_FG;
                  lten:
                    result:=F_FGE;
                  gtn:
                    result:=F_FL;
                  gten:
                    result:=F_FLE;
                end
              else
                case NodeType of
                  ltn:
                    result:=F_FL;
                  lten:
                    result:=F_FLE;
                  gtn:
                    result:=F_FG;
                  gten:
                    result:=F_FGE;
                end;
            end;
        end;
      end;


    procedure tsparcaddnode.second_addfloat;
      var
        op : TAsmOp;
      begin
        pass_left_right;
        if (nf_swaped in flags) then
          swapleftright;

        { force fpureg as location, left right doesn't matter
          as both will be in a fpureg }
        location_force_fpureg(exprasmlist,left.location,true);
        location_force_fpureg(exprasmlist,right.location,(left.location.loc<>LOC_CFPUREGISTER));

        location_reset(location,LOC_FPUREGISTER,def_cgsize(resulttype.def));
        if left.location.loc<>LOC_CFPUREGISTER then
          location.register:=left.location.register
        else
          location.register:=right.location.register;

        case nodetype of
          addn :
            begin
              if location.size=OS_F64 then
                op:=A_FADDd
              else
                op:=A_FADDs;
            end;
          muln :
            begin
              if location.size=OS_F64 then
                op:=A_FMULd
              else
                op:=A_FMULs;
            end;
          subn :
            begin
              if location.size=OS_F64 then
                op:=A_FSUBd
              else
                op:=A_FSUBs;
            end;
          slashn :
            begin
              if location.size=OS_F64 then
                op:=A_FDIVd
              else
                op:=A_FDIVs;
            end;
          else
            internalerror(200306014);
        end;

        exprasmlist.concat(taicpu.op_reg_reg_reg(op,
           left.location.register,right.location.register,location.register));

        release_reg_left_right;
      end;


    procedure tsparcaddnode.second_cmpfloat;
      var
        op : tasmop;
      begin
        pass_left_right;
        if (nf_swaped in flags) then
          swapleftright;

        { force fpureg as location, left right doesn't matter
          as both will be in a fpureg }
        location_force_fpureg(exprasmlist,left.location,true);
        location_force_fpureg(exprasmlist,right.location,true);

        location_reset(location,LOC_FLAGS,OS_NO);
        location.resflags:=getfpuresflags;

        if left.location.size=OS_F64 then
          op:=A_FCMPd
        else
          op:=A_FCMPs;
        exprasmlist.concat(taicpu.op_reg_reg(op,
             left.location.register,right.location.register));
        { Delay slot (can only contain integer operation) }
        exprasmlist.concat(taicpu.op_none(A_NOP));

        release_reg_left_right;
      end;


    procedure tsparcaddnode.second_cmpboolean;
      begin
        pass_left_right;
        force_reg_left_right(true,true);

        if right.location.loc = LOC_CONSTANT then
          tcgsparc(cg).handle_reg_const_reg(exprasmlist,A_SUBcc,left.location.register,right.location.value,NR_G0)
        else
          exprasmlist.concat(taicpu.op_reg_reg_reg(A_SUBcc,left.location.register,right.location.register,NR_G0));

        location_reset(location,LOC_FLAGS,OS_NO);
        location.resflags:=getresflags(true);

        release_reg_left_right;
      end;


    procedure tsparcaddnode.second_cmpsmallset;
      begin
        pass_left_right;
        force_reg_left_right(true,true);

        if right.location.loc = LOC_CONSTANT then
          tcgsparc(cg).handle_reg_const_reg(exprasmlist,A_SUBcc,left.location.register,right.location.value,NR_G0)
        else
          exprasmlist.concat(taicpu.op_reg_reg_reg(A_SUBcc,left.location.register,right.location.register,NR_G0));

        location_reset(location,LOC_FLAGS,OS_NO);
        location.resflags:=getresflags(true);

        release_reg_left_right;
      end;


    procedure tsparcaddnode.second_cmp64bit;
      var
        unsigned : boolean;
      begin
{$warning TODO 64bit compare}
        unsigned:=not(is_signed(left.resulttype.def)) or
                  not(is_signed(right.resulttype.def));

        location_reset(location,LOC_FLAGS,OS_NO);
        location.resflags:=getresflags(unsigned);

        release_reg_left_right;
      end;


    procedure tsparcaddnode.second_cmpordinal;
      var
        unsigned : boolean;
      begin
        pass_left_right;
        force_reg_left_right(true,true);

        unsigned:=not(is_signed(left.resulttype.def)) or
                  not(is_signed(right.resulttype.def));

        if right.location.loc = LOC_CONSTANT then
          tcgsparc(cg).handle_reg_const_reg(exprasmlist,A_SUBcc,left.location.register,right.location.value,NR_G0)
        else
          exprasmlist.concat(taicpu.op_reg_reg_reg(A_SUBcc,left.location.register,right.location.register,NR_G0));

        location_reset(location,LOC_FLAGS,OS_NO);
        location.resflags:=getresflags(unsigned);

        release_reg_left_right;
      end;

begin
  caddnode:=tsparcaddnode;
end.
{
  $Log$
  Revision 1.23  2004-01-12 22:11:39  peter
    * use localalign info for alignment for locals and temps
    * sparc fpu flags branching added
    * moved powerpc copy_valye_openarray to generic

  Revision 1.22  2004/01/12 16:39:41  peter
    * sparc updates, mostly float related

  Revision 1.21  2003/10/24 11:28:35  mazen
  -unused units removed from uses clause

  Revision 1.20  2003/10/01 20:34:50  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.19  2003/09/03 15:55:01  peter
    * NEWRA branch merged

  Revision 1.18.2.1  2003/09/01 21:02:55  peter
    * sparc updates for new tregister

  Revision 1.18  2003/07/08 21:25:00  peter
    * sparc fixes

  Revision 1.17  2003/07/06 22:09:50  peter
    * signed compare fixed

  Revision 1.16  2003/07/06 17:44:12  peter
    * cleanup and first sparc implementation

  Revision 1.15  2003/06/01 21:38:06  peter
    * getregisterfpu size parameter added
    * op_const_reg size parameter added
    * sparc updates

}
