{
    $Id$
    This file is part of the Free Pascal run time library.
    This unit contains the record definition for the Win32 API
    Copyright (c) 1999-2000 by Florian KLaempfl,
    member of the Free Pascal development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit windows;


{$ifndef VER0_99_14}
{$ifndef NO_SMART_LINK}
{$define support_smartlink}
{$endif}
{$endif}


{$ifdef support_smartlink}
{$smartlink on}
{$endif}

interface

{$define read_interface}
{$undef read_implementation}

{$i base.inc}
{$i errors.inc}
{$i defines.inc}
{$i messages.inc}
{$i struct.inc}
{$i ascfun.inc}
{$i unifun.inc}
{$ifdef UNICODE}
{$i unidef.inc}
{$else not UNICODE}
{$i ascdef.inc}
{$endif UNICODE}
{$i func.inc}
{$i redef.inc}

implementation

{$undef read_interface}
{$define read_implementation}

{$i base.inc}
{$i errors.inc}
{$i defines.inc}
{$i messages.inc}
{$i struct.inc}
{$i ascfun.inc}
{$i unifun.inc}
{$ifdef UNICODE}
{$i unidef.inc}
{$else not UNICODE}
{$i ascdef.inc}
{$endif UNICODE}
{$i func.inc}
{$i redef.inc}

end.
{
  $Log$
  Revision 1.2  2000-07-13 11:33:58  michael
  + removed logs
 
}
