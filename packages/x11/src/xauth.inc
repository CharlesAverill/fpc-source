(*

Copyright 1988, 1998  The Open Group

Permission to use, copy, modify, distribute, and sell this software and its
documentation for any purpose is hereby granted without fee, provided that
the above copyright notice appear in all copies and that both that
copyright notice and this permission notice appear in supporting
documentation.

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of The Open Group shall not be
used in advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from The Open Group.

*)

type
  PXauth = ^TXauth;
  TXauth = record
    family: cushort;
    address_length: cushort;
    address: PAnsiChar;
    number_length: cushort;
    number: PAnsiChar;
    name_length: cushort;
    name: PAnsiChar;
    data_length: cushort;
    data: PAnsiChar;
  end;

{$ifndef _XAUTH_STRUCT_ONLY}

# include   <X11/Xfuncproto.h>
# include   <X11/Xfuncs.h>

# include   <stdio.h>

# define FamilyLocal (256)	/* not part of X standard (i.e. X.h) */
# define FamilyWild  (65535)
# define FamilyNetname    (254)   /* not part of X standard */
# define FamilyKrb5Principal (253) /* Kerberos 5 principal name */
# define FamilyLocalHost (252)	/* for local non-net authentication */


_XFUNCPROTOBEGIN

AnsiChar *XauFileName(void);

Xauth *XauReadAuth(
FILE*	/* auth_file */
);

int XauLockAuth(
_Xconst AnsiChar*	/* file_name */,
int		/* retries */,
int		/* timeout */,
long		/* dead */
);

int XauUnlockAuth(
_Xconst AnsiChar*	/* file_name */
);

int XauWriteAuth(
FILE*		/* auth_file */,
Xauth*		/* auth */
);

Xauth *XauGetAuthByAddr(
#if NeedWidePrototypes
unsigned int	/* family */,
unsigned int	/* address_length */,
#else
unsigned short	/* family */,
unsigned short	/* address_length */,
#endif
_Xconst AnsiChar*	/* address */,
#if NeedWidePrototypes
unsigned int	/* number_length */,
#else
unsigned short	/* number_length */,
#endif
_Xconst AnsiChar*	/* number */,
#if NeedWidePrototypes
unsigned int	/* name_length */,
#else
unsigned short	/* name_length */,
#endif
_Xconst AnsiChar*	/* name */
);

Xauth *XauGetBestAuthByAddr(
#if NeedWidePrototypes
unsigned int	/* family */,
unsigned int	/* address_length */,
#else
unsigned short	/* family */,
unsigned short	/* address_length */,
#endif
_Xconst AnsiChar*	/* address */,
#if NeedWidePrototypes
unsigned int	/* number_length */,
#else
unsigned short	/* number_length */,
#endif
_Xconst AnsiChar*	/* number */,
int		/* types_length */,
AnsiChar**		/* type_names */,
_Xconst int*	/* type_lengths */
);

void XauDisposeAuth(
Xauth*		/* auth */
);

_XFUNCPROTOEND

/* Return values from XauLockAuth */

# define LOCK_SUCCESS	0	/* lock succeeded */
# define LOCK_ERROR	1	/* lock unexpectely failed, check errno */
# define LOCK_TIMEOUT	2	/* lock failed, timeouts expired */

{$endif _XAUTH_STRUCT_ONLY}
