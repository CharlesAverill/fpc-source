{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 2001 by Carl Eric Codere development team

    Base Unix unit modelled after POSIX 2001.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
Unit BaseUnix;

Interface
{$packrecords C}
{$define oldreaddir}		// Keep using readdir system call instead
				// of userland getdents stuff.
{$define usedomain}		// Allow uname with "domain" entry.
				// (which is a GNU extension)
{$define posixworkaround}	// Temporary ugly workaround for signal handler.
				// (mainly until baseunix migration is complete)

{$i errno.inc}		{ Error numbers }
{$i bunxtype.inc}	{ Types }
{$i bunxh.inc}		{ Functions}

function fpgeterrno:longint; 
procedure fpseterrno(err:longint); 

property errno : cint read fpgeterrno write fpseterrno;

implementation


{$i bunxmain.inc}	{ implementation}
{$i bunxovl.inc}	{ redefs and overloads implementation}

function fpgeterrno:longint; external name 'FPC_SYS_GETERRNO';
procedure fpseterrno(err:longint); external name 'FPC_SYS_SETERRNO';

end.

{
  $Log$
  Revision 1.4  2003-12-10 17:08:33  marco
   * property errno defined

  Revision 1.3  2003/09/14 20:15:01  marco
   * Unix reform stage two. Remove all calls from Unix that exist in Baseunix.

  Revision 1.2  2003/06/03 14:23:45  marco
   * Moved prototypes outside of baseunix. And shared with linux for now

  Revision 1.1  2003/01/05 19:01:28  marco
   * FreeBSD compiles now with baseunix mods.

  Revision 1.1  2002/12/18 16:44:09  marco
   * more new RTL

  Revision 1.2  2002/11/14 12:17:28  marco
   * for now.

}