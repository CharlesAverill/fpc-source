{***********************************************************
Copyright 1991 by Digital Equipment Corporation, Maynard, Massachusetts,
and the Massachusetts Institute of Technology, Cambridge, Massachusetts.

                        All Rights Reserved

Permission to use, copy, modify, and distribute this software and its 
documentation for any purpose and without fee is hereby granted, 
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in 
supporting documentation, and that the names of Digital or MIT not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.  

DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

******************************************************************}
{ $XFree86: xc/include/extensions/Xv.h,v 1.3 1999/05/23 06:33:22 dawes Exp $ }

{$IFNDEF FPC_DOTTEDUNITS}
unit xv;
{$ENDIF FPC_DOTTEDUNITS}

interface

{$PACKRECORDS c}

{$IFDEF FPC_DOTTEDUNITS}
uses
  Api.X11.X;
{$ELSE FPC_DOTTEDUNITS}
uses
  x;
{$ENDIF FPC_DOTTEDUNITS}

const
  XvName = 'XVideo';
  XvVersion = 2;
  XvRevision = 2;

{ Symbols }
type
  TXvPortID = TXID;
  TXvEncodingID = TXID;

const
  XvNone = 0;

  XvInput       = 0;
  XvOutput      = 1;

  XvInputMask   = 1 shl XvInput;
  XvOutputMask  = 1 shl XvOutput;
  XvVideoMask   = $00000004;
  XvStillMask   = $00000008;
  XvImageMask   = $00000010;

{ These two are not client viewable }
  XvPixmapMask  = $00010000;
  XvWindowMask  = $00020000;


  XvGettable    = $01;
  XvSettable    = $02;

  XvRGB         = 0;
  XvYUV         = 1;

  XvPacked      = 0;
  XvPlanar      = 1;

  XvTopToBottom = 0;
  XvBottomToTop = 1;


{ Events }

  XvVideoNotify = 0;
  XvPortNotify  = 1;
  XvNumEvents   = 2;

{ Video Notify Reasons }

  XvStarted    = 0;
  XvStopped    = 1;
  XvBusy       = 2;
  XvPreempted  = 3;
  XvHardError  = 4;
  XvLastReason = 4;

  XvNumReasons = XvLastReason + 1;

  XvStartedMask   = 1 shl XvStarted;
  XvStoppedMask   = 1 shl XvStopped;
  XvBusyMask      = 1 shl XvBusy;
  XvPreemptedMask = 1 shl XvPreempted;
  XvHardErrorMask = 1 shl XvHardError;

  XvAnyReasonMask = (1 shl XvNumReasons) - 1;
  XvNoReasonMask  = 0;

{ Errors }

  XvBadPort     = 0;
  XvBadEncoding = 1;
  XvBadControl  = 2;
  XvNumErrors   = 3;

{ Status }

  XvBadExtension   = 1;
  XvAlreadyGrabbed = 2;
  XvInvalidTime    = 3;
  XvBadReply       = 4;
  XvBadAlloc       = 5;

implementation

end.
