#
#   $Id$
#   This file is part of the Free Pascal run time library.
#   Copyright (c) 1999-2000 by Michael Van Canneyt and Peter Vreman
#   members of the Free Pascal development team.
#
#   See the file COPYING.FPC, included in this distribution,
#   for details about the copyright.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY;without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
#**********************************************************************}
#
# Linux ELF startup code for Free Pascal
#

        .file   "prt1.as"
        .text
        .globl  _start
        .type   _start,@function
_start:
        /* First locate the start of the environment variables */
        popl    %ecx
        movl    %esp,%ebx               /* Points to the arguments */
        movl    %ecx,%eax
        incl    %eax
        shll    $2,%eax
        addl    %esp,%eax
        andl    $0xfffffff8,%esp        /* Align stack */

        movl    %eax,U_SYSLINUX_ENVP    /* Move the environment pointer */
        movl    %ecx,U_SYSLINUX_ARGC    /* Move the argument counter    */
        movl    %ebx,U_SYSLINUX_ARGV    /* Move the argument pointer    */

        finit                           /* initialize fpu */
        fwait
        fldcw   ___fpucw

        xorl    %ebp,%ebp
        call    PASCALMAIN

        .globl  _haltproc
        .type   _haltproc,@function
_haltproc:
        movl    $1,%eax                 /* exit call */
        xorl    %ebx,%ebx
        movw    U_SYSLINUX_EXITCODE,%bx
        int     $0x80
        jmp     _haltproc

.data
        .align  4
___fpucw:
        .long   0x1332

        .globl  ___fpc_brk_addr         /* heap management */
        .type   ___fpc_brk_addr,@object
        .size   ___fpc_brk_addr,4
___fpc_brk_addr:
        .long   0

#
# $Log$
# Revision 1.2  2001-05-09 19:57:07  peter
# *** empty log message ***
#
# Revision 1.1  2000/10/15 09:09:24  peter
#   * startup code also needed syslinux->system updates
#
#
