{
    $Id$
    Copyright (c) 2002 by Florian Klaempfl

    Generates the argument location information for i386

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published bymethodpointer
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
{ Generates the argument location information for i386.
}
unit cpupara;

{$i fpcdefs.inc}

  interface

    uses
       cclasses,globtype,
       aasmtai,
       cpubase,
       cgbase,
       symconst,symtype,symdef,paramgr;

    type
       ti386paramanager = class(tparamanager)
          function ret_in_param(def : tdef;calloption : tproccalloption) : boolean;override;
          function push_addr_param(varspez:tvarspez;def : tdef;calloption : tproccalloption) : boolean;override;
          function get_para_align(calloption : tproccalloption):byte;override;
          function get_volatile_registers_int(calloption : tproccalloption):tcpuregisterset;override;
          function get_volatile_registers_fpu(calloption : tproccalloption):tcpuregisterset;override;
          function get_volatile_registers_mm(calloption : tproccalloption):tcpuregisterset;override;
          { Returns the location for the nr-st 32 Bit int parameter
            if every parameter before is an 32 Bit int parameter as well
            and if the calling conventions for the helper routines of the
            rtl are used.
          }
          function getintparaloc(calloption : tproccalloption; nr : longint) : tparalocation;override;
          function create_paraloc_info(p : tabstractprocdef; side: tcallercallee):longint;override;
          function create_varargs_paraloc_info(p : tabstractprocdef; varargspara:tlinkedlist):longint;override;
       private
          procedure create_funcret_paraloc_info(p : tabstractprocdef; side: tcallercallee);
          function create_stdcall_paraloc_info(p : tabstractprocdef; side: tcallercallee):longint;
          function create_register_paraloc_info(p : tabstractprocdef; side: tcallercallee):longint;
       end;

  implementation

    uses
       cutils,
       systems,verbose,
       defutil,
       cpuinfo;

      const
        parasupregs : array[0..2] of tsuperregister = (RS_EAX,RS_EDX,RS_ECX);

{****************************************************************************
                                TI386PARAMANAGER
****************************************************************************}

    function ti386paramanager.ret_in_param(def : tdef;calloption : tproccalloption) : boolean;
      begin
        case target_info.system of
          system_i386_win32 :
            begin
              case def.deftype of
                recorddef :
                  begin
                    { Win32 GCC returns small records in the FUNCTION_RETURN_REG.
                      For stdcall we follow delphi instead of GCC }
                    if (calloption in [pocall_cdecl,pocall_cppdecl]) and
                       (def.size<=8) then
                     begin
                       result:=false;
                       exit;
                     end;
                  end;
              end;
            end;
        end;
        result:=inherited ret_in_param(def,calloption);
      end;


    function ti386paramanager.push_addr_param(varspez:tvarspez;def : tdef;calloption : tproccalloption) : boolean;
      begin
        case target_info.system of
          system_i386_win32 :
            begin
              case def.deftype of
                recorddef :
                  begin
                    { Win32 passes small records on the stack for call by
                      value }
                    if (calloption in [pocall_stdcall,pocall_cdecl,pocall_cppdecl]) and
                       (varspez=vs_value) and
                       (def.size<=8) then
                     begin
                       result:=false;
                       exit;
                     end;
                  end;
                arraydef :
                  begin
                    { Win32 passes arrays on the stack for call by
                      value }
                    if (calloption in [pocall_stdcall,pocall_cdecl,pocall_cppdecl]) and
                       (varspez=vs_value) and
                       (tarraydef(def).highrange>=tarraydef(def).lowrange) then
                     begin
                       result:=true;
                       exit;
                     end;
                  end;
              end;
            end;
        end;
        if calloption=pocall_register then
          begin
            case def.deftype of
              floatdef :
                begin
                  result:=true;
                  exit;
                end;
            end;
          end;
        result:=inherited push_addr_param(varspez,def,calloption);
      end;


    function ti386paramanager.get_para_align(calloption : tproccalloption):byte;
      begin
        if calloption=pocall_oldfpccall then
          begin
            if target_info.system in [system_i386_go32v2,system_i386_watcom] then
              result:=2
            else
              result:=4;
          end
        else
          result:=std_param_align;
      end;


    function ti386paramanager.get_volatile_registers_int(calloption : tproccalloption):tcpuregisterset;
      begin
        case calloption of
          pocall_internproc :
            result:=[];
          pocall_compilerproc :
            begin
              if pocall_default=pocall_oldfpccall then
                result:=[RS_EAX,RS_EDX,RS_ECX,RS_ESI,RS_EDI,RS_EBX]
              else
                result:=[RS_EAX,RS_EDX,RS_ECX];
            end;
          pocall_inline,
          pocall_register,
          pocall_safecall,
          pocall_stdcall,
          pocall_cdecl,
          pocall_cppdecl :
            result:=[RS_EAX,RS_EDX,RS_ECX];
          pocall_far16,
          pocall_pascal,
          pocall_oldfpccall :
            result:=[RS_EAX,RS_EDX,RS_ECX,RS_ESI,RS_EDI,RS_EBX];
          else
            internalerror(200309071);
        end;
      end;


    function ti386paramanager.get_volatile_registers_fpu(calloption : tproccalloption):tcpuregisterset;
      begin
        result:=[0..first_fpu_imreg-1];
      end;


    function ti386paramanager.get_volatile_registers_mm(calloption : tproccalloption):tcpuregisterset;
      begin
        result:=[0..first_sse_imreg-1];
      end;


    function ti386paramanager.getintparaloc(calloption : tproccalloption; nr : longint) : tparalocation;
      begin
         fillchar(result,sizeof(tparalocation),0);
         result.size:=OS_INT;
         if calloption=pocall_register then
           begin
             if (nr<=high(parasupregs)+1) then
               begin
                 if nr=0 then
                   internalerror(200309271);
                 result.loc:=LOC_REGISTER;
                 result.register:=newreg(R_INTREGISTER,parasupregs[nr-1],R_SUBWHOLE);
               end
             else
               begin
                 result.loc:=LOC_REFERENCE;
                 result.reference.index:=NR_STACK_POINTER_REG;
                 result.reference.offset:=POINTER_SIZE*nr;
               end;
           end
         else
           begin
             result.loc:=LOC_REFERENCE;
             result.reference.index:=NR_STACK_POINTER_REG;
             result.reference.offset:=POINTER_SIZE*nr;
           end;
      end;


    procedure ti386paramanager.create_funcret_paraloc_info(p : tabstractprocdef; side: tcallercallee);
      var
        paraloc : tparalocation;
      begin
        { Function return }
        fillchar(paraloc,sizeof(tparalocation),0);
        paraloc.size:=def_cgsize(p.rettype.def);
        { Return in FPU register? }
        if p.rettype.def.deftype=floatdef then
          begin
            paraloc.loc:=LOC_FPUREGISTER;
            paraloc.register:=NR_FPU_RESULT_REG;
          end
        else
         { Return in register? }
         if not ret_in_param(p.rettype.def,p.proccalloption) then
          begin
            paraloc.loc:=LOC_REGISTER;
{$ifndef cpu64bit}
            if paraloc.size in [OS_64,OS_S64] then
             begin
               paraloc.register64.reglo:=NR_FUNCTION_RETURN64_LOW_REG;
               paraloc.register64.reghi:=NR_FUNCTION_RETURN64_HIGH_REG;
             end
            else
{$endif cpu64bit}
             begin
               paraloc.register:=NR_FUNCTION_RETURN_REG;
             end;
          end
        else
          begin
            paraloc.loc:=LOC_REFERENCE;
          end;
        p.funcret_paraloc[side]:=paraloc;
      end;


    function ti386paramanager.create_varargs_paraloc_info(p : tabstractprocdef; varargspara:tlinkedlist):longint;
      var
        hp : tparaitem;
        paraloc : tparalocation;
        l,
        varalign,
        paraalign,
        parasize : longint;
      begin
        parasize:=0;
        paraalign:=get_para_align(p.proccalloption);
        { Retrieve last know info from normal parameters }
        hp:=tparaitem(p.para.last);
        if assigned(hp) then
          parasize:=hp.paraloc[callerside].reference.offset;
        { Assign varargs }
        hp:=tparaitem(varargspara.first);
        while assigned(hp) do
          begin
            paraloc.size:=def_cgsize(hp.paratype.def);
            paraloc.loc:=LOC_REFERENCE;
            paraloc.alignment:=paraalign;
            paraloc.reference.index:=NR_STACK_POINTER_REG;
            l:=push_size(hp.paratyp,hp.paratype.def,p.proccalloption);
            varalign:=size_2_align(l);
            paraloc.reference.offset:=parasize;
            varalign:=used_align(varalign,paraalign,paraalign);
            parasize:=align(parasize+l,varalign);
            hp.paraloc[callerside]:=paraloc;
            hp:=tparaitem(hp.next);
          end;
        { We need to return the size allocated }
        result:=parasize;
      end;


    function ti386paramanager.create_stdcall_paraloc_info(p : tabstractprocdef; side: tcallercallee):longint;
      var
        hp : tparaitem;
        paraloc : tparalocation;
        l,
        varalign,
        paraalign,
        parasize : longint;
      begin
        parasize:=0;
        paraalign:=get_para_align(p.proccalloption);
        { we push Flags and CS as long
          to cope with the IRETD
          and we save 6 register + 4 selectors }
        if po_interrupt in p.procoptions then
          inc(parasize,8+6*4+4*2);
        { Offset is calculated like:
           sub esp,12
           mov [esp+8],para3
           mov [esp+4],para2
           mov [esp],para1
           call function
          That means the for pushes the para with the
          highest offset (see para3) needs to be pushed first
        }
        hp:=tparaitem(p.para.first);
        while assigned(hp) do
          begin
            if hp.paratyp in [vs_var,vs_out] then
              paraloc.size:=OS_ADDR
            else
              paraloc.size:=def_cgsize(hp.paratype.def);
            paraloc.loc:=LOC_REFERENCE;
            paraloc.alignment:=paraalign;
            if side=callerside then
              paraloc.reference.index:=NR_STACK_POINTER_REG
            else
              paraloc.reference.index:=NR_FRAME_POINTER_REG;
            l:=push_size(hp.paratyp,hp.paratype.def,p.proccalloption);
            varalign:=used_align(size_2_align(l),paraalign,paraalign);
            paraloc.reference.offset:=parasize;
            parasize:=align(parasize+l,varalign);
            hp.paraloc[side]:=paraloc;
            hp:=tparaitem(hp.next);
          end;
        { Adapt offsets for left-to-right calling }
        if p.proccalloption in pushleftright_pocalls then
          begin
            hp:=tparaitem(p.para.first);
            while assigned(hp) do
              begin
                l:=push_size(hp.paratyp,hp.paratype.def,p.proccalloption);
                varalign:=used_align(size_2_align(l),paraalign,paraalign);
                l:=align(l,varalign);
                hp.paraloc[side].reference.offset:=parasize-hp.paraloc[side].reference.offset-l;
                if side=calleeside then
                  inc(hp.paraloc[side].reference.offset,target_info.first_parm_offset);
                hp:=tparaitem(hp.next);
              end;
          end
        else
          begin
            { Only need to adapt the callee side to include the
              standard stackframe size }
            if side=calleeside then
              begin
                hp:=tparaitem(p.para.first);
                while assigned(hp) do
                  begin
                    inc(hp.paraloc[side].reference.offset,target_info.first_parm_offset);
                    hp:=tparaitem(hp.next);
                  end;
               end;
          end;
        { We need to return the size allocated }
        result:=parasize;
      end;


    function ti386paramanager.create_register_paraloc_info(p : tabstractprocdef; side: tcallercallee):longint;
      var
        hp : tparaitem;
        paraloc : tparalocation;
        subreg : tsubregister;
        pushaddr,
        is_64bit : boolean;
        l,parareg,
        varalign,
        paraalign,
        parasize : longint;
      begin
        parareg:=0;
        parasize:=0;
        paraalign:=get_para_align(p.proccalloption);
        { Register parameters are assigned from left to right }
        hp:=tparaitem(p.para.first);
        while assigned(hp) do
          begin
            pushaddr:=push_addr_param(hp.paratyp,hp.paratype.def,p.proccalloption);
            if pushaddr then
              paraloc.size:=OS_ADDR
            else
              paraloc.size:=def_cgsize(hp.paratype.def);
            paraloc.alignment:=paraalign;
            is_64bit:=(paraloc.size in [OS_64,OS_S64,OS_F64]);
            {
              EAX
              EDX
              ECX
              Stack
              Stack

              64bit values,floats,arrays and records are always
              on the stack.
            }
            if (parareg<=high(parasupregs)) and
               not(
                   is_64bit or
                   (hp.paratype.def.deftype=floatdef) or
                   ((hp.paratype.def.deftype in [floatdef,recorddef,arraydef]) and
                    (not pushaddr))
                  ) then
              begin
                paraloc.loc:=LOC_REGISTER;
                if (paraloc.size=OS_NO) or is_64bit then
                  subreg:=R_SUBWHOLE
                else
                  subreg:=cgsize2subreg(paraloc.size);
                paraloc.alignment:=paraalign;
                paraloc.register:=newreg(R_INTREGISTER,parasupregs[parareg],subreg);
                inc(parareg);
              end
            else
              begin
                paraloc.loc:=LOC_REFERENCE;
                if side=callerside then
                  paraloc.reference.index:=NR_STACK_POINTER_REG
                else
                  paraloc.reference.index:=NR_FRAME_POINTER_REG;
                l:=push_size(hp.paratyp,hp.paratype.def,p.proccalloption);
                varalign:=size_2_align(l);
                paraloc.reference.offset:=parasize;
                varalign:=used_align(varalign,paraalign,paraalign);
                parasize:=align(parasize+l,varalign);
              end;
            hp.paraloc[side]:=paraloc;
            hp:=tparaitem(hp.next);
          end;
        { Register parameters are assigned from left-to-right, adapt offset
          for calleeside to be reversed }
        hp:=tparaitem(p.para.first);
        while assigned(hp) do
          begin
            if (hp.paraloc[side].loc=LOC_REFERENCE) then
              begin
                l:=push_size(hp.paratyp,hp.paratype.def,p.proccalloption);
                varalign:=used_align(size_2_align(l),paraalign,paraalign);
                l:=align(l,varalign);
                hp.paraloc[side].reference.offset:=parasize-hp.paraloc[side].reference.offset-l;
                if side=calleeside then
                  inc(hp.paraloc[side].reference.offset,target_info.first_parm_offset);
              end;    
            hp:=tparaitem(hp.next);
          end;
        { We need to return the size allocated }
        result:=parasize;
      end;


    function ti386paramanager.create_paraloc_info(p : tabstractprocdef; side: tcallercallee):longint;
      begin
        result:=0;
        case p.proccalloption of
          pocall_register :
            result:=create_register_paraloc_info(p,side);
          pocall_inline,
          pocall_compilerproc,
          pocall_internproc :
            begin
              { Use default calling }
              if (pocall_default=pocall_register) then
                result:=create_register_paraloc_info(p,side)
              else
                result:=create_stdcall_paraloc_info(p,side);
            end;
          else
            result:=create_stdcall_paraloc_info(p,side);
        end;
        create_funcret_paraloc_info(p,side);
      end;


begin
   paramanager:=ti386paramanager.create;
end.
{
  $Log$
  Revision 1.46  2003-12-01 18:44:15  peter
    * fixed some crashes
    * fixed varargs and register calling probs

  Revision 1.45  2003/11/28 17:24:22  peter
    * reversed offset calculation for caller side so it works
      correctly for interfaces

  Revision 1.44  2003/11/23 17:05:16  peter
    * register calling is left-right
    * parameter ordering
    * left-right calling inserts result parameter last

  Revision 1.43  2003/11/11 21:11:23  peter
    * check for push_addr

  Revision 1.42  2003/10/19 01:34:30  florian
    * some ppc stuff fixed
    * memory leak fixed

  Revision 1.41  2003/10/17 14:38:32  peter
    * 64k registers supported
    * fixed some memory leaks

  Revision 1.40  2003/10/11 16:06:42  florian
    * fixed some MMX<->SSE
    * started to fix ppc, needs an overhaul
    + stabs info improve for spilling, not sure if it works correctly/completly
    - MMX_SUPPORT removed from Makefile.fpc

  Revision 1.39  2003/10/10 17:48:14  peter
    * old trgobj moved to x86/rgcpu and renamed to trgx86fpu
    * tregisteralloctor renamed to trgobj
    * removed rgobj from a lot of units
    * moved location_* and reference_* to cgobj
    * first things for mmx register allocation

  Revision 1.38  2003/10/07 15:17:07  peter
    * inline supported again, LOC_REFERENCEs are used to pass the
      parameters
    * inlineparasymtable,inlinelocalsymtable removed
    * exitlabel inserting fixed

  Revision 1.37  2003/10/05 21:21:52  peter
    * c style array of const generates callparanodes
    * varargs paraloc fixes

  Revision 1.36  2003/10/03 22:00:33  peter
    * parameter alignment fixes

  Revision 1.35  2003/10/01 20:34:49  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.34  2003/09/30 21:02:37  peter
    * updates for inlining

  Revision 1.33  2003/09/28 17:55:04  peter
    * parent framepointer changed to hidden parameter
    * tloadparentfpnode added

  Revision 1.32  2003/09/28 13:35:24  peter
    * register calling updates

  Revision 1.31  2003/09/25 21:30:11  peter
    * parameter fixes

  Revision 1.30  2003/09/23 17:56:06  peter
    * locals and paras are allocated in the code generation
    * tvarsym.localloc contains the location of para/local when
      generating code for the current procedure

  Revision 1.29  2003/09/16 16:17:01  peter
    * varspez in calls to push_addr_param

  Revision 1.28  2003/09/10 08:31:47  marco
   * Patch from Peter for paraloc

  Revision 1.27  2003/09/09 21:03:17  peter
    * basics for x86 register calling

  Revision 1.26  2003/09/09 15:55:05  peter
    * winapi doesn't like pushing 8 byte record

  Revision 1.25  2003/09/08 18:28:51  peter
    * fix compilerproc for default=oldfpccall

  Revision 1.24  2003/09/07 22:09:35  peter
    * preparations for different default calling conventions
    * various RA fixes

  Revision 1.23  2003/09/03 15:55:01  peter
    * NEWRA branch merged

  Revision 1.22.2.2  2003/08/28 18:35:08  peter
    * tregister changed to cardinal

  Revision 1.22.2.1  2003/08/27 19:55:54  peter
    * first tregister patch

  Revision 1.22  2003/08/11 21:18:20  peter
    * start of sparc support for newra

  Revision 1.21  2003/07/05 20:11:41  jonas
    * create_paraloc_info() is now called separately for the caller and
      callee info
    * fixed ppc cycle

  Revision 1.20  2003/07/02 22:18:04  peter
    * paraloc splitted in callerparaloc,calleeparaloc
    * sparc calling convention updates

  Revision 1.19  2003/06/17 16:34:19  peter
    * freeintparaloc added

  Revision 1.18  2003/06/07 18:57:04  jonas
    + added freeintparaloc
    * ppc get/freeintparaloc now check whether the parameter regs are
      properly allocated/deallocated (and get an extra list para)
    * ppc a_call_* now internalerrors if pi_do_call is not yet set
    * fixed lot of missing pi_do_call's

  Revision 1.17  2003/06/06 14:41:22  peter
    * needs cpuinfo

  Revision 1.16  2003/06/06 07:36:06  michael
  + Forgot a line in patch from peter

  Revision 1.15  2003/06/06 07:35:14  michael
  + Patch to Patch from peter

  Revision 1.14  2003/06/06 07:34:11  michael
  + Patch from peter

  Revision 1.13  2003/06/05 20:58:05  peter
    * updated

  Revision 1.12  2003/05/30 23:57:08  peter
    * more sparc cleanup
    * accumulator removed, splitted in function_return_reg (called) and
      function_result_reg (caller)

  Revision 1.11  2003/05/13 15:16:13  peter
    * removed ret_in_acc, it's the reverse of ret_in_param
    * fixed ret_in_param for win32 cdecl array

  Revision 1.10  2003/04/22 23:50:23  peter
    * firstpass uses expectloc
    * checks if there are differences between the expectloc and
      location.loc from secondpass in EXTDEBUG

  Revision 1.9  2003/04/22 14:33:38  peter
    * removed some notes/hints

  Revision 1.8  2003/01/08 18:43:57  daniel
   * Tregister changed into a record

  Revision 1.7  2002/12/24 15:56:50  peter
    * stackpointer_alloc added for adjusting ESP. Win32 needs
      this for the pageprotection

  Revision 1.6  2002/12/17 22:19:33  peter
    * fixed pushing of records>8 bytes with stdcall
    * simplified hightree loading

  Revision 1.5  2002/11/18 17:32:00  peter
    * pass proccalloption to ret_in_xxx and push_xxx functions

  Revision 1.4  2002/11/15 01:58:56  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.3  2002/08/09 07:33:04  florian
    * a couple of interface related fixes

  Revision 1.2  2002/07/11 14:41:32  florian
    * start of the new generic parameter handling

  Revision 1.1  2002/07/07 09:52:33  florian
    * powerpc target fixed, very simple units can be compiled
    * some basic stuff for better callparanode handling, far from being finished

}
