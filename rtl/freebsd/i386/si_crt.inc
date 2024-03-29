{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2005 by Michael Van Canneyt, Peter Vreman,
    & Daniel Mantione, members of the Free Pascal development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{
 FreeBSD/x86 ELF startup code for Free Pascal

 Stack layout at program start:

         nil
         envn
         ....
         ....           ENVIRONMENT VARIABLES
         env1
         env0
         nil
         argn
         ....
         ....           COMMAND LINE OPTIONS
         arg1
         arg0
         argc <--- esp
}

var
  libc_fpc_ret, libc_fpc_ret_ebx, libc_fpc_ret_ebp: ptrint; { return address to libc }
  __progname : PAnsiChar; cvar;

procedure get_rtld_cleanup; external name 'get_rtld_cleanup';
procedure atexit; external name 'atexit';
procedure init_tls; external name '_init_tls';
procedure libc_start_main; external name '__libc_start_main';

procedure PASCALMAIN; external name 'PASCALMAIN';

var progname : PAnsiChar cvar; // = '';
    __fpucw  : word; cvar; // = 0x1332;

{******************************************************************************
                         libc 2.1 library start/halt
 ******************************************************************************}
{$asmmode ATT}

procedure _FPC_libc_start; assembler; nostackframe; public name '_start';
asm
        pushl %ebp
        movl %esp,%ebp
	subl $40,%esp
	call get_rtld_cleanup
	movl %eax,%edx

        pushl %edi
        pushl %esi
        pushl %ebx
#APP
        movl %edx,%edx
#NO_APP
        leal 8(%ebp),%edi
        movl %edi,operatingsystem_parameter_argv
        mov -4(%edi),%eax
        movl %eax,operatingsystem_parameter_argc
        movl 4(%ebp),%ebx
        leal 12(%ebp,%ebx,4),%esi
        movl %esi,operatingsystem_parameter_envp
        movl %esi,environ
        testl %ebx,%ebx
        jle .L2
        movl 8(%ebp),%eax
        testl %eax,%eax
        je .L2
        movl %eax,__progname
        cmpb $0,(%eax)
        je .L2
        .p2align 2,0x90
.L6:
        cmpb $47,(%eax)
        jne .L5
        leal 1(%eax),%ecx
        movl %ecx,__progname
.L5:
        incl %eax
        cmpb $0,(%eax)
        jne .L6
.L2:
        movl $_DYNAMIC,%eax
        testl %eax,%eax
        je .LTLS
        pushl %edx
        call atexit
        addl $4,%esp
.L9:
        pushl $_fini
        call atexit
        call _init
#       pushl %esi
#       pushl %edi
#       pushl %ebx
#       call main
#       pushl %eax
#       call exit


        finit                           /* initialize fpu */
        fwait
        fldcw   ___fpucw

        xorl    %ebp,%ebp

        call main
        pushl %eax
        jmp   _haltproc
.LTLS:  
	call _init_tls
	jmp .L9
get_rtld_cleanup:
        pushl   %ebp
        movl    %esp, %ebp
        subl    $4, %esp
#APP
        movl %edx,-4(%ebp)
#NO_APP
        movl    -4(%ebp), %eax
        leave
        ret
end;

procedure _FPC_libc_haltproc; assembler; nostackframe; public name '_haltproc';
asm
           mov $1,%eax  
           movzwl operatingsystem_result,%ebx
           pushl %ebx
           call .Lactualsyscall
           addl  $4,%esp
           jmp   _haltproc

.Lactualsyscall:
         int $0x80
         jb .LErrorcode
         xor %ebx,%ebx
         ret
.section        .note.ABI-tag,"a",@progbits
        .p2align 2
        .type   abitag, @object
        .size   abitag, 24
abitag:
        .long   8
        .long   4
        .long   1
        .string "FreeBSD"
	.long	900044


.LErrorcode:
         mov %eax,%ebx
         mov $-1,%eax
end;


        .file   "cprt0.as"
        .ident  "FreePascal 2.2.x series dynlinked"

        .section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
        .string ""
	.data
        .p2align 2
	.globl __progname
        .type    __progname,@object
        .size    __progname,4
__progname:
        .long .LC0
        .text
        .p2align  2,,3
	.type   __fpucw,@object
        .size   __fpucw,4
        .global __fpucw
___fpucw:
        .long   0x1332
        .globl  ___fpc_brk_addr         /* heap management */
        .type   ___fpc_brk_addr,@object
        .size   ___fpc_brk_addr,4
___fpc_brk_addr:
        .long   0

	.text
        .p2align 4,,15
.globl _start
        .type    _start,@function
_start:

        .p2align 2,0x90
.Lfe1:
        .size    _start,.Lfe1-_start
        .comm   environ,4,4
        .p2align 4,,15
        .type   get_rtld_cleanup, @function

        .weak   _DYNAMIC
        .ident  "GCC: (GNU) 3.4.2 - FPC: 2.2.0"

.bss
        .type   __stkptr,@object
        .size   __stkptr,4
        .global __stkptr
__stkptr:
        .skip   4

        .type operatingsystem_parameters,@object
        .size operatingsystem_parameters,12
operatingsystem_parameters:
        .skip 3*4

        .global operatingsystem_parameter_envp
        .global operatingsystem_parameter_argc
        .global operatingsystem_parameter_argv
        .set operatingsystem_parameter_envp,operatingsystem_parameters+0
        .set operatingsystem_parameter_argc,operatingsystem_parameters+4
        .set operatingsystem_parameter_argv,operatingsystem_parameters+8

//.section .threadvar,"aw",@nobits
        .comm   ___fpc_threadvar_offset,4
