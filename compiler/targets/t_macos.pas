{
    $Id$
    Copyright (c) 2001 by Peter Vreman

    This unit implements support import,export,link routines
    for the (i386) Amiga target

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
unit t_macos;

{$i defines.inc}

interface


implementation

    uses
       link,
       cutils,cclasses,
       globtype,globals,systems,verbose,script,fmodule;

{*****************************************************************************
                                  Initialize
*****************************************************************************}

{$ifdef m68k}
    const
       target_m68k_macos_info : ttargetinfo =
          (
            target       : target_m68k_Mac;
            name         : 'Macintosh m68k';
            shortname    : 'mac';
            flags        : [];
            cpu          : m68k;
            short_name   : 'MACOS';
            unit_env     : '';
            sharedlibext : 'Lib';
            staticlibext : 'Lib';
            sourceext    : '.pp';
            pasext       : '.pas';
            exeext       : '';
            defext       : '';
            scriptext    : '';
            smartext     : '.sl';
            unitext      : '.ppt';
            unitlibext   : '.ppl';
            asmext       : '.a';
            objext       : '.o';
            resext       : '.res';
            resobjext    : '.or';
            libprefix    : '';
            Cprefix      : '_';
            newline      : #13;
            assem        : as_m68k_mpw;
            assemextern  : as_m68k_mpw;
            link         : ld_m68k_mac;
            linkextern   : ld_m68k_mac;
            ar           : ar_m68k_ar;
            res          : res_none;
            endian       : endian_big;
            stackalignment : 2;
            maxCrecordalignment : 4;
            size_of_pointer : 4;
            size_of_longint : 4;
            heapsize     : 128*1024;
            maxheapsize  : 32768*1024;
            stacksize    : 8192;
            DllScanSupported:false;
            use_bound_instruction : false;
            use_function_relative_addresses : false
          );
{$endif m68k}

{$ifdef powerpc}
     const
       target_powerpc_macos_info : ttargetinfo =
          (
            target       : target_powerpc_MACOS;
            name         : 'MacOs (PowerPC)';
            shortname    : 'MacOs/PPC';
            flags        : [];
            cpu          : powerpc;
            short_name   : 'MACOS';
            unit_env     : '';
            sharedlibext : 'Lib';
            staticlibext : 'Lib';
            sourceext    : '.pp';
            pasext       : '.pas';
            exeext       : '';
            defext       : '';
            scriptext    : '';
            smartext     : '.sl';
            unitext      : '.ppt';
            unitlibext   : '.ppl';
            asmext       : '.a';
            objext       : '.o';
            resext       : '.res';
            resobjext    : '.or';
            libprefix    : '';
            Cprefix      : '';
            newline      : #13;
            assem        : as_powerpc_mpw;
            assemextern  : as_powerpc_mpw;
            link         : ld_powerpc_macos;
            linkextern   : ld_powerpc_macos;
            ar           : ar_powerpc_ar;
            res          : res_powerpc_mpw;
            endian       : endian_big;
            stackalignment : 8;
            maxCrecordalignment : 32;
            size_of_pointer : 4;
            size_of_longint : 4;
            heapsize     : 256*1024;
            maxheapsize  : 32768*1024;
            stacksize    : 8192;
            DllScanSupported:false;
            use_bound_instruction : false;
            use_function_relative_addresses : true
          );
{$endif powerpc}


initialization
{$ifdef m68k}
  RegisterTarget(target_m68k_macos_info);
{$endif m68k}
{$ifdef powerpc}
  RegisterTarget(target_powerpc_macos_info);
{$endif powerpc}
end.
{
  $Log$
  Revision 1.1  2001-04-18 22:02:04  peter
    * registration of targets and assemblers

}
