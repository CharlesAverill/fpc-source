{
    $Id$
    Copyright (c) 2002 by Florian Klaempfl

    Generic calling convention handling

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
unit parabase;

{$i fpcdefs.inc}

  interface

    uses
       cclasses,globtype,
       cpubase,cgbase,cgutils;

    type
       TCGParaReference = record
          index       : tregister;
          offset      : aint;
       end;

       PCGParaLocation = ^TCGParaLocation;
       TCGParaLocation = record
         Next : PCGParaLocation;
         Size : TCGSize; { size of this location }
         Loc  : TCGLoc;
         case TCGLoc of
           LOC_REFERENCE : (reference : TCGParaReference);
           LOC_FPUREGISTER,
           LOC_CFPUREGISTER,
           LOC_MMREGISTER,
           LOC_CMMREGISTER,
           LOC_REGISTER,
           LOC_CREGISTER : (register : tregister);
       end;

       TCGPara = object
          Location  : PCGParalocation;
          Alignment : ShortInt;
          Size      : TCGSize;  { Size of the parameter included in all locations }
          IntSize: aint; { size of the total location in bytes }
{$ifdef powerpc}
          composite: boolean; { under the AIX abi, how certain parameters are passed depends on whether they are composite or not }
{$endif powerpc}
          constructor init;
          destructor  done;
          procedure   reset;
          function    getcopy:tcgpara;
          procedure   check_simple_location;
          function    add_location:pcgparalocation;
          procedure   get_location(var newloc:tlocation);
       end;

       tvarargsinfo = (
         va_uses_float_reg
       );

       tparalist = class(tlist)
          procedure SortParas;
       end;

       tvarargsparalist = class(tparalist)
          varargsinfo : set of tvarargsinfo;
{$ifdef x86_64}
          { x86_64 requires %al to contain the no. SSE regs passed }
          mmregsused  : longint;
{$endif x86_64}
       end;



implementation

    uses
      systems,verbose,
      symsym;


{****************************************************************************
                                TCGPara
****************************************************************************}

    constructor tcgpara.init;
      begin
        alignment:=0;
        size:=OS_NO;
        intsize:=0;
        location:=nil;
{$ifdef powerpc}
        composite:=false;
{$endif powerpc}
      end;


    destructor tcgpara.done;
      begin
        reset;
      end;


    procedure tcgpara.reset;
      var
        hlocation : pcgparalocation;
      begin
        while assigned(location) do
          begin
            hlocation:=location^.next;
            dispose(location);
            location:=hlocation;
          end;
        alignment:=0;
        size:=OS_NO;
        intsize:=0;
{$ifdef powerpc}
        composite:=false;
{$endif powerpc}
      end;


    function tcgpara.getcopy:tcgpara;
      var
        hlocation : pcgparalocation;
      begin
        result.init;
        while assigned(location) do
          begin
            hlocation:=result.add_location;
            hlocation^:=location^;
            hlocation^.next:=nil;
            location:=location^.next;
          end;
        result.alignment:=alignment;
        result.size:=size;
        result.intsize:=intsize;
{$ifdef powerpc}
        result.composite:=composite;
{$endif powerpc}
      end;


    function tcgpara.add_location:pcgparalocation;
      var
        prevlocation,
        hlocation : pcgparalocation;
      begin
        prevlocation:=nil;
        hlocation:=location;
        while assigned(hlocation) do
          begin
            prevlocation:=hlocation;
            hlocation:=hlocation^.next;
          end;
        new(hlocation);
        Fillchar(hlocation^,sizeof(tcgparalocation),0);
        if assigned(prevlocation) then
          prevlocation^.next:=hlocation
        else
          location:=hlocation;
        result:=hlocation;
      end;


    procedure tcgpara.check_simple_location;
      begin
        if not assigned(location) then
          internalerror(200408161);
        if assigned(location^.next) then
          internalerror(200408162);
      end;


    procedure tcgpara.get_location(var newloc:tlocation);
      begin
        if not assigned(location) then
          internalerror(200408205);
        fillchar(newloc,sizeof(newloc),0);
        newloc.loc:=location^.loc;
        newloc.size:=size;
        case location^.loc of
          LOC_REGISTER :
            begin
{$ifndef cpu64bit}
              if size in [OS_64,OS_S64] then
                begin
                  if not assigned(location^.next) then
                    internalerror(200408206);
                  if (location^.next^.loc<>LOC_REGISTER) then
                    internalerror(200408207);
                  if (target_info.endian = ENDIAN_BIG) then
                    begin
                      newloc.register64.reghi:=location^.register;
                      newloc.register64.reglo:=location^.next^.register;
                    end
                  else
                    begin
                      newloc.register64.reglo:=location^.register;
                      newloc.register64.reghi:=location^.next^.register;
                    end;
                end
              else
{$endif}
                newloc.register:=location^.register;
            end;
          LOC_FPUREGISTER,
          LOC_MMREGISTER :
            newloc.register:=location^.register;
          LOC_REFERENCE :
            begin
              newloc.reference.base:=location^.reference.index;
              newloc.reference.offset:=location^.reference.offset;
            end;
        end;
      end;


{****************************************************************************
                          TParaList
****************************************************************************}

    function ParaNrCompare(Item1, Item2: Pointer): Integer;
      var
        I1 : tparavarsym absolute Item1;
        I2 : tparavarsym absolute Item2;
      begin
        Result:=I1.paranr-I2.paranr;
      end;


    procedure TParaList.SortParas;
      begin
        Sort(@ParaNrCompare);
      end;


end.

{
   $Log$
   Revision 1.9  2005-01-18 22:19:20  peter
     * multiple location support for i386 a_param_ref
     * remove a_param_copy_ref for i386

   Revision 1.8  2005/01/10 21:50:05  jonas
     + support for passing records in registers under darwin
     * tcgpara now also has an intsize field, which contains the size in
       bytes of the whole parameter

   Revision 1.7  2005/01/07 16:22:54  florian
     + implemented abi compliant handling of strucutured functions results on sparc platform

   Revision 1.6  2004/11/22 22:01:19  peter
     * fixed varargs
     * replaced dynarray with tlist

   Revision 1.5  2004/11/15 23:35:31  peter
     * tparaitem removed, use tparavarsym instead
     * parameter order is now calculated from paranr value in tparavarsym

   Revision 1.4  2004/10/31 21:45:03  peter
     * generic tlocation
     * move tlocation to cgutils

   Revision 1.3  2004/10/10 20:22:53  peter
     * symtable allocation rewritten
     * loading of parameters to local temps/regs cleanup
     * regvar support for parameters
     * regvar support for staticsymtable (main body)

   Revision 1.2  2004/09/21 17:25:12  peter
     * paraloc branch merged

   Revision 1.1.2.2  2004/09/14 19:09:37  jonas
     * fixed typo in IE check

   Revision 1.1.2.1  2004/09/02 15:47:58  peter
     * missing file

}

