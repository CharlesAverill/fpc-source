{
     File:       HIToolbox/HIView.h
 
     Contains:   HIView routines
 
     Version:    HIToolbox-624~3
 
     Copyright:  � 2001-2008 by Apple Computer, Inc., all rights reserved.
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://bugs.freepascal.org
 
}
{     File:       HIView.p(.pas)																	    }
{ 																										}
{     Contains:   CodeWarrior Pascal( GPC) translation of Apple's Mac OS X 10.3 HIView.h		            }
{				  Translation compatible with make-gpc-interfaces.pl generated MWPInterfaces            }
{                 (GPCPInterfaces).  For the 10.2 available APIs, the CodeWarrior Pascal translation    }
{                 is linkable with Mac OS X 10.2.x or higher CFM CarbonLib and the GPC translation is   }
{                 linkable with Mac OS X 10.2.x or higher Mach-O Carbon.framework.  For the 10.3        }
{                 available APIs, the CodeWarrior Pascal translation is only selectively linkable with  }
{                 Mac OS X 10.3.x or higher CFM CarbonLib and the GPC translation is linkable with Mac  }
{                 OS X 10.3.x or higher Mach-O Carbon.framework.                                        }
{ 																										}
{     Version:    1.1																					}
{ 																										}
{	  Pascal Translation:  Gale Paeper, <gpaeper@empirenet.com>, 2004									}
{ 																										}
{     Copyright:  Subject to the constraints of Apple's original rights, you're free to use this		}
{				  translation as you deem fit.															}
{ 																										}
{     Bugs?:      This is an AS IS translation with no express guarentees of any kind.					}
{                 If you do find a bug, please help out the Macintosh Pascal programming community by   }
{				  reporting your bug finding and possible fix to either personal e-mail to Gale Paeper	}
{				  or a posting to the MacPascal mailing list.											}
{
      Change History (most recent first ):

         <4>      4/8/04    GRP     Completed new additions from HIView.h, version HIToolbox-145.33~1.
         <3>      ?/?/04    PNL     Added most new additions from HIView.h, version HIToolbox-145.33~1.
         <2>    10/02/04    GRP     Added support for GPC as well as CodeWarrior Pascal.
         <1>      9/8/03    GRP     First Pascal translation of HIView.h, version HIToolbox-123.6~10.
}
{     Translation assisted by:                                                                          }
{This file was processed by Dan's Source Converter}
{version 1.3 (this version modified by Ingemar Ragnemalm)}
{       Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, August 2005 }
{       Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{       Pascal Translation Updated:  Gorazd Krosl, <gorazd_1957@yahoo.ca>, October 2009 }
{       Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2012 }
{
    Modified for use with Free Pascal
    Version 308
    Please report any bugs to <gpc@microbizz.nl>
}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}
{$mode macpas}
{$modeswitch cblocks}
{$packenum 1}
{$macro on}
{$inline on}
{$calling mwpascal}

{$IFNDEF FPC_DOTTEDUNITS}
unit HIView;
{$ENDIF FPC_DOTTEDUNITS}
interface
{$setc UNIVERSAL_INTERFACES_VERSION := $0400}
{$setc GAP_INTERFACES_VERSION := $0308}

{$ifc not defined USE_CFSTR_CONSTANT_MACROS}
    {$setc USE_CFSTR_CONSTANT_MACROS := TRUE}
{$endc}

{$ifc defined CPUPOWERPC and defined CPUI386}
	{$error Conflicting initial definitions for CPUPOWERPC and CPUI386}
{$endc}
{$ifc defined FPC_BIG_ENDIAN and defined FPC_LITTLE_ENDIAN}
	{$error Conflicting initial definitions for FPC_BIG_ENDIAN and FPC_LITTLE_ENDIAN}
{$endc}

{$ifc not defined __ppc__ and defined CPUPOWERPC32}
	{$setc __ppc__ := 1}
{$elsec}
	{$setc __ppc__ := 0}
{$endc}
{$ifc not defined __ppc64__ and defined CPUPOWERPC64}
	{$setc __ppc64__ := 1}
{$elsec}
	{$setc __ppc64__ := 0}
{$endc}
{$ifc not defined __i386__ and defined CPUI386}
	{$setc __i386__ := 1}
{$elsec}
	{$setc __i386__ := 0}
{$endc}
{$ifc not defined __x86_64__ and defined CPUX86_64}
	{$setc __x86_64__ := 1}
{$elsec}
	{$setc __x86_64__ := 0}
{$endc}
{$ifc not defined __arm__ and defined CPUARM}
	{$setc __arm__ := 1}
{$elsec}
	{$setc __arm__ := 0}
{$endc}
{$ifc not defined __arm64__ and defined CPUAARCH64}
  {$setc __arm64__ := 1}
{$elsec}
  {$setc __arm64__ := 0}
{$endc}

{$ifc defined cpu64}
  {$setc __LP64__ := 1}
{$elsec}
  {$setc __LP64__ := 0}
{$endc}


{$ifc defined __ppc__ and __ppc__ and defined __i386__ and __i386__}
	{$error Conflicting definitions for __ppc__ and __i386__}
{$endc}

{$ifc defined __ppc__ and __ppc__}
	{$setc TARGET_CPU_PPC := TRUE}
	{$setc TARGET_CPU_PPC64 := FALSE}
	{$setc TARGET_CPU_X86 := FALSE}
	{$setc TARGET_CPU_X86_64 := FALSE}
	{$setc TARGET_CPU_ARM := FALSE}
	{$setc TARGET_CPU_ARM64 := FALSE}
	{$setc TARGET_OS_MAC := TRUE}
	{$setc TARGET_OS_IPHONE := FALSE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
	{$setc TARGET_OS_EMBEDDED := FALSE}
{$elifc defined __ppc64__ and __ppc64__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_PPC64 := TRUE}
	{$setc TARGET_CPU_X86 := FALSE}
	{$setc TARGET_CPU_X86_64 := FALSE}
	{$setc TARGET_CPU_ARM := FALSE}
	{$setc TARGET_CPU_ARM64 := FALSE}
	{$setc TARGET_OS_MAC := TRUE}
	{$setc TARGET_OS_IPHONE := FALSE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
	{$setc TARGET_OS_EMBEDDED := FALSE}
{$elifc defined __i386__ and __i386__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_PPC64 := FALSE}
	{$setc TARGET_CPU_X86 := TRUE}
	{$setc TARGET_CPU_X86_64 := FALSE}
	{$setc TARGET_CPU_ARM := FALSE}
	{$setc TARGET_CPU_ARM64 := FALSE}
{$ifc defined iphonesim}
 	{$setc TARGET_OS_MAC := FALSE}
	{$setc TARGET_OS_IPHONE := TRUE}
	{$setc TARGET_IPHONE_SIMULATOR := TRUE}
{$elsec}
	{$setc TARGET_OS_MAC := TRUE}
	{$setc TARGET_OS_IPHONE := FALSE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
{$endc}
	{$setc TARGET_OS_EMBEDDED := FALSE}
{$elifc defined __x86_64__ and __x86_64__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_PPC64 := FALSE}
	{$setc TARGET_CPU_X86 := FALSE}
	{$setc TARGET_CPU_X86_64 := TRUE}
	{$setc TARGET_CPU_ARM := FALSE}
	{$setc TARGET_CPU_ARM64 := FALSE}
{$ifc defined iphonesim}
 	{$setc TARGET_OS_MAC := FALSE}
	{$setc TARGET_OS_IPHONE := TRUE}
	{$setc TARGET_IPHONE_SIMULATOR := TRUE}
{$elsec}
	{$setc TARGET_OS_MAC := TRUE}
	{$setc TARGET_OS_IPHONE := FALSE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
{$endc}
	{$setc TARGET_OS_EMBEDDED := FALSE}
{$elifc defined __arm__ and __arm__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_PPC64 := FALSE}
	{$setc TARGET_CPU_X86 := FALSE}
	{$setc TARGET_CPU_X86_64 := FALSE}
	{$setc TARGET_CPU_ARM := TRUE}
	{$setc TARGET_CPU_ARM64 := FALSE}
	{$setc TARGET_OS_MAC := FALSE}
	{$setc TARGET_OS_IPHONE := TRUE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
	{$setc TARGET_OS_EMBEDDED := TRUE}
{$elifc defined __arm64__ and __arm64__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_PPC64 := FALSE}
	{$setc TARGET_CPU_X86 := FALSE}
	{$setc TARGET_CPU_X86_64 := FALSE}
	{$setc TARGET_CPU_ARM := FALSE}
	{$setc TARGET_CPU_ARM64 := TRUE}
{$ifc defined ios}
	{$setc TARGET_OS_MAC := FALSE}
	{$setc TARGET_OS_IPHONE := TRUE}
	{$setc TARGET_OS_EMBEDDED := TRUE}
{$elsec}
	{$setc TARGET_OS_MAC := TRUE}
	{$setc TARGET_OS_IPHONE := FALSE}
	{$setc TARGET_OS_EMBEDDED := FALSE}
{$endc}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
{$elsec}
	{$error __ppc__ nor __ppc64__ nor __i386__ nor __x86_64__ nor __arm__ nor __arm64__ is defined.}
{$endc}

{$ifc defined __LP64__ and __LP64__ }
  {$setc TARGET_CPU_64 := TRUE}
{$elsec}
  {$setc TARGET_CPU_64 := FALSE}
{$endc}

{$ifc defined FPC_BIG_ENDIAN}
	{$setc TARGET_RT_BIG_ENDIAN := TRUE}
	{$setc TARGET_RT_LITTLE_ENDIAN := FALSE}
{$elifc defined FPC_LITTLE_ENDIAN}
	{$setc TARGET_RT_BIG_ENDIAN := FALSE}
	{$setc TARGET_RT_LITTLE_ENDIAN := TRUE}
{$elsec}
	{$error Neither FPC_BIG_ENDIAN nor FPC_LITTLE_ENDIAN are defined.}
{$endc}
{$setc ACCESSOR_CALLS_ARE_FUNCTIONS := TRUE}
{$setc CALL_NOT_IN_CARBON := FALSE}
{$setc OLDROUTINENAMES := FALSE}
{$setc OPAQUE_TOOLBOX_STRUCTS := TRUE}
{$setc OPAQUE_UPP_TYPES := TRUE}
{$setc OTCARBONAPPLICATION := TRUE}
{$setc OTKERNEL := FALSE}
{$setc PM_USE_SESSION_APIS := TRUE}
{$setc TARGET_API_MAC_CARBON := TRUE}
{$setc TARGET_API_MAC_OS8 := FALSE}
{$setc TARGET_API_MAC_OSX := TRUE}
{$setc TARGET_CARBON := TRUE}
{$setc TARGET_CPU_68K := FALSE}
{$setc TARGET_CPU_MIPS := FALSE}
{$setc TARGET_CPU_SPARC := FALSE}
{$setc TARGET_OS_UNIX := FALSE}
{$setc TARGET_OS_WIN32 := FALSE}
{$setc TARGET_RT_MAC_68881 := FALSE}
{$setc TARGET_RT_MAC_CFM := FALSE}
{$setc TARGET_RT_MAC_MACHO := TRUE}
{$setc TYPED_FUNCTION_POINTERS := TRUE}
{$setc TYPE_BOOL := FALSE}
{$setc TYPE_EXTENDED := FALSE}
{$setc TYPE_LONGLONG := TRUE}
{$IFDEF FPC_DOTTEDUNITS}
uses MacOsApi.MacTypes,MacOsApi.CFArray,MacOsApi.CFBase,MacOsApi.CGBase,MacOsApi.CGContext,MacOsApi.CGImage,MacOsApi.CarbonEventsCore,MacOsApi.Drag,MacOsApi.Events,MacOsApi.QuickdrawTypes,MacOsApi.Menus,MacOsApi.Appearance,MacOsApi.Controls,MacOsApi.CarbonEvents,MacOsApi.HIGeometry,MacOsApi.HIObject,MacOsApi.IconsCore,MacOsApi.Icons,MacOsApi.HIShape,MacOsApi.HITheme,MacOsApi.CTFont;
{$ELSE FPC_DOTTEDUNITS}
uses MacTypes,CFArray,CFBase,CGBase,CGContext,CGImage,CarbonEventsCore,Drag,Events,QuickdrawTypes,Menus,Appearance,Controls,CarbonEvents,HIGeometry,HIObject,IconsCore,Icons,HIShape,HITheme,CTFont;
{$ENDIF FPC_DOTTEDUNITS}
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN MAC68K}

type
	HIViewID = ControlID;

{
 *  Discussion:
 *    HIViewZOrderOp
 }
const
{
   * Indicates we wish to order a view above another view.
   }
	kHIViewZOrderAbove = 1;

  {
   * Indicates we wish to order a view below another view.
   }
	kHIViewZOrderBelow = 2;

type
	HIViewZOrderOp = UInt32;

{
 *  HIViewFrameMetrics
 *  
 *  Summary:
 *    Describes the offsets from the structure to the content area of a
 *    view; for example, the top metric is the difference between the
 *    vertical coordinate of the top edge of the view�s structure
 *    region and the vertical coordinate of the top edge of the view�s
 *    content region. This structure is returned by a view in response
 *    to a kEventControlGetFrameMetrics event.
 }
type
	HIViewFrameMetrics = record
{
   * Height of the top of the structure area.
   }
		top: CGFloat;

  {
   * Width of the left of the structure area.
   }
		left: CGFloat;

  {
   * Height of the bottom of the structure area.
   }
		bottom: CGFloat;

  {
   * Width of the right of the structure area.
   }
		right: CGFloat;
	end;
{==============================================================================}
{  ATTRIBUTES                                                                  }
{==============================================================================}

{
 *  Summary:
 *    View attributes are generally determined by clients of the view;
 *    the view itself should observe the attributes and behave
 *    accordingly.
 *  
 *  Discussion:
 *    View Attributes
 }
const
{
   * When set, the view will send the command it generates to the user
   * focus and propagate as it would naturally from there. The default
   * is to send the command to itself and then to its parent and so
   * forth.
   }
	kHIViewAttributeSendCommandToUserFocus = 1 shl 0;

  {
   * Indicates that a text editing view should behave appropriately for
   * editing fields in a dialog; specifically, the view should ignore
   * the Return, Enter, Escape, and Tab keys, and allow them to be
   * processed by other participants in the event flow. Available on
   * Mac OS X 10.3 and later.
   }
	kHIViewAttributeIsFieldEditor = 1 shl 1;

  {
   * Legacy synonym for kHIViewAttributeSendCommandToUserFocus. Please
   * use it instead.
   }
	kHIViewSendCommandToUserFocus = kHIViewAttributeSendCommandToUserFocus;


{
 *  HIView features
 *  
 *  Summary:
 *    View feature flags are generally determined by the view itself,
 *    and are not typically changed by clients of the view. 
 *    
 *    Historical note: This list is similar to the list of Control
 *    Feature Bits in Controls.h. This list is shorter because some of
 *    the Control Manager constants were introduced to enable the
 *    Control Manager to tell whether a CDEF supported a new CDEF
 *    message. This capability is not required by the HIView Manager,
 *    because an HIView that doesn't support a particular Carbon event
 *    will simply ignore it.
 }
const
{
   * This view supports using the ghosting protocol when live tracking
   * is not enabled.
   }
	kHIViewFeatureSupportsGhosting = 1 shl 0;

  {
   * This view allows subviews to be embedded within it.
   }
	kHIViewFeatureAllowsSubviews = 1 shl 1;

  {
   * If this view is clicked, the keyboard focus should be set to this
   * view automatically. This is primarily used for edit text views.
   }
	kHIViewFeatureGetsFocusOnClick = 1 shl 8;

  {
   * This view supports the live feedback protocol. Necessary to
   * implement live scroll bar tracking. Clients of a view should never
   * disable this.
   }
	kHIViewFeatureSupportsLiveFeedback = 1 shl 10;

  {
   * This view can be put into a radio group. Radio buttons and bevel
   * buttons report this behavior.
   }
	kHIViewFeatureSupportsRadioBehavior = 1 shl 11;

  {
   * This view supports the auto-toggle protocol and should at the very
   * least auto- toggle from off to on and back. The view can support a
   * carbon event for more advanced auto-toggling of its value. The tab
   * view supports this, for example, so that when a tab is clicked its
   * value changes automatically.
   }
	kHIViewFeatureAutoToggles = 1 shl 14;

  {
   * This is merely informational. Turning it off would not necessarily
   * disable any timer a view might be using, but it could obey this
   * bit if it so desired.
   }
	kHIViewFeatureIdlesWithTimer = 1 shl 23;

  {
   * This tells the Control Manager that the up button part increases
   * the value of the view instead of decreasing it. For example, the
   * Little Arrows (Spinner) view increase its value when the up button
   * is pressed. Scroll bars, on the other hand, decrease the value
   * when their up buttons are pressed.
   }
	kHIViewFeatureInvertsUpDownValueMeaning = 1 shl 24;

  {
   * This is an optimization for determining a view's opaque region.
   * When set, the view system just uses the view's structure region,
   * and can usually avoid having to call the view at all.
   }
	kHIViewFeatureIsOpaque = 1 shl 25;

  {
   * This is an optimization for determining what gets invalidated when
   * views are dirtied. For example, on a metal window, the content
   * view is actually fully transparent, so invalidating it doesn't
   * really help things. By telling the Control Manager that the view
   * is transparent and does not do any drawing, we can avoid trying to
   * invalidate it and instead invalidate views behind it.
   }
	kHIViewFeatureDoesNotDraw = 1 shl 27;

  {
   * Indicates to the Control Manager that this view doesn't use the
   * special part codes for indicator, inactive, and disabled.
   * Available in Mac OS X 10.3 and later.
   }
	kHIViewFeatureDoesNotUseSpecialParts = 1 shl 28;

  {
   * This is an optimization for determining the clickable region of a
   * window (used for metal windows, for example, when doing async
   * window dragging). The presence of this bit tells us not to bother
   * asking the view for the clickable region. A view like the visual
   * separator would set this bit. It's typically used in conjunction
   * with the kHIViewFeatureDoesNotDraw bit.
   }
	kHIViewFeatureIgnoresClicks = 1 shl 29;


{
 *  HIView valid feature sets
 *  
 *  Summary:
 *    These are sets of features that are available on the version of
 *    Mac OS X corresponding to that named in the constant.
 }
const
	kHIViewValidFeaturesForPanther = $3B804D03;


{
 *  HIView feature synonyms
 *  
 *  Summary:
 *    Legacy synonyms for HIView feature bit names. Please use the
 *    newer names.
 }
const
	kHIViewSupportsGhosting = kHIViewFeatureSupportsGhosting;
	kHIViewAllowsSubviews = kHIViewFeatureAllowsSubviews;
	kHIViewGetsFocusOnClick = kHIViewFeatureGetsFocusOnClick;
	kHIViewSupportsLiveFeedback = kHIViewFeatureSupportsLiveFeedback;
	kHIViewSupportsRadioBehavior = kHIViewFeatureSupportsRadioBehavior;
	kHIViewAutoToggles = kHIViewFeatureAutoToggles;
	kHIViewIdlesWithTimer = kHIViewFeatureIdlesWithTimer;
	kHIViewInvertsUpDownValueMeaning = kHIViewFeatureInvertsUpDownValueMeaning;
	kHIViewIsOpaque = kHIViewFeatureIsOpaque;
	kHIViewDoesNotDraw = kHIViewFeatureDoesNotDraw;
	kHIViewDoesNotUseSpecialParts = kHIViewFeatureDoesNotUseSpecialParts;
	kHIViewIgnoresClicks = kHIViewFeatureIgnoresClicks;


type
	HIViewFeatures = UInt64;
{==============================================================================}
{  VIEW PART CODES                                                             }
{==============================================================================}
type
	HIViewPartCode = ControlPartCode;
	HIViewPartCodePtr = ^HIViewPartCode;

{
 *  HIViewPartCodes
 *  
 }
const
	kHIViewNoPart = 0;
	kHIViewIndicatorPart = 129;
	kHIViewDisabledPart = 254;
	kHIViewInactivePart = 255;

  {
   * Use this constant when not referring to a specific part, but
   * rather the entire view.
   }
	kHIViewEntireView = kHIViewNoPart;


{
 *  HIView meta-parts
 *  
 *  Summary:
 *    A meta-part is a part used in a call to the HIViewCopyShape API.
 *    These parts might be defined by a view, but should not be
 *    returned from calls such as HIViewGetPartHit. They define a
 *    region of a view. 
 *    
 *    Along with these parts, you can also pass in normal part codes to
 *    get the regions of those parts. Not all views fully support this
 *    feature.
 }
const
{
   * The entire area that the view will draw into. When a composited
   * view is drawn, the HIView Manager clips the view's drawing to the
   * structure area. This area may extend beyond the bounds of the view
   * (for example, if the view draws a focus ring outside of its
   * bounds). You may return a superset of the drawn area if this is
   * computationally easier to construct. This area is used to
   * determine the area of a window that should be invalidated and
   * redrawn when a view is invalidated. It is not necessary for a view
   * to return a shape that precisely describes the structure area; for
   * example, a view whose structure is an oval may simply return the
   * oval's bounding rectangle. The default handler for the
   * kEventControlGetPartRegion event will return the view's bounds
   * when this part is requested.
   }
	kHIViewStructureMetaPart = -1;

  {
   * The area of the view in which embedded views should be positioned.
   * This part is only defined for views that can contain other views
   * (for example, the group box). This area is largely informational
   * and is not used by the HIView Manager itself. The default handler
   * for the kEventControlGetPartRegion event will return
   * errInvalidPartCode when this part is requested.
   }
	kHIViewContentMetaPart = -2;

  {
   * The area of the view that, when drawn, is filled with opaque
   * pixels. You may also return a subset of the opaque area if this is
   * computationally easier to construct. If a view is contained in a
   * composited window, the HIView Manager will use this area to
   * optimize drawing of other views that intersect this area; views
   * that are entirely contained within the opaque area, and that are
   * z-ordered underneath this view, will not be drawn at all, since
   * any drawing would be completely overwritten by this view. The
   * default handler for the kEventControlGetPartRegion event will
   * return an empty area when this part is requested. This meta-part
   * is available in Mac OS X 10.2 or later.
   }
	kHIViewOpaqueMetaPart = -3;

  {
   * The area of the view that causes a mouse event to be captured by
   * that view. If a mouse event falls inside the view bounds but
   * outside of this area, then the Control Manager will allow the
   * event to pass through the view to the next view behind it in
   * z-order. This area is used to determine which parts of a window
   * should allow async window dragging when clicked (the draggable
   * area is computed by subtracting the clickable areas of views in
   * the window from the window's total area). You can also customize
   * the clickable area of a view if you want the view to have an
   * effectively transparent area (for example, a view that draws
   * multiple tabs might want clicks in the space between the tabs to
   * fall through to the next view rather than be captured by the
   * tab-drawing view). The default handler for the
   * kEventControlGetPartRegion event will return the view's bounds
   * when this part is requested. This meta-part is available in Mac OS
   * X 10.3 or later.
   }
	kHIViewClickableMetaPart = -4;


{
 *  HIView Focus Parts
 *  
 }
const
{
   * Tells view to clear its focus
   }
	kHIViewFocusNoPart = kHIViewNoPart;

  {
   * Tells view to focus on the next part
   }
	kHIViewFocusNextPart = -1;

  {
   * Tells view to focus on the previous part
   }
	kHIViewFocusPrevPart = -2;

{==============================================================================}
{  CONTENT                                                                     }
{==============================================================================}
type
	HIViewImageContentType = ControlContentType;
	HIViewImageContentInfo = ControlImageContentInfo;
	HIViewContentType = SInt16;

{
 *  HIViewContentTypes
 *  
 *  Summary:
 *    HIView image content types.
 }
const
{
   * The view has no content other than text.
   }
	kHIViewContentTextOnly = 0;

  {
   * The view has no content.
   }
	kHIViewContentNone = 0;

  {
   * The view's content is an IconSuiteRef. The icon suite handle
   * should be placed in HIViewContentInfo.u.iconSuite.
   }
	kHIViewContentIconSuiteRef = 129;

  {
   * The view's content is an IconRef. The IconRef should be placed in
   * HIViewContentInfo.u.iconRef.
   }
	kHIViewContentIconRef = 132;

  {
   * The view's content is a CGImageRef. The CGImageRef should be
   * placed in HIViewContentInfo.u.imageRef. Available in Mac OS X 10.4
   * and later.
   }
	kHIViewContentCGImageRef = 134;

  {
   * The view's content is an image file in the main bundle's Resources
   * directory. The CFStringRef of the full name of the image file
   * should be placed in HIViewContentInfo.u.imageResource. Available
   * in Mac OS X 10.5 and later.
   }
	kHIViewContentImageResource = 135;

  {
   * The view's content is an image file at an arbitrary location. The
   * CFURLRef identifying the image file should be placed in
   * HIViewContentInfo.u.imageFile. Available in Mac OS X 10.5 and
   * later.
   }
	kHIViewContentImageFile = 136;

  {
   * The view's content is an IconRef, specified by an icon type and
   * creator. The type and creator should be placed in
   * HIViewContentInfo.u.iconTypeAndCreator. Available in Mac OS X 10.5
   * and later.
   }
	kHIViewContentIconTypeAndCreator = 137;

  {
   * The view's content is a Note, Caution, or Stop icon, specified by
   * the corresponding icon type (kAlertNoteIcon, kAlertCautionIcon, or
   * kAlertStopIcon). When the icon is drawn, it may be modified to
   * correspond to the current Mac OS X user interface guidelines. The
   * type should be placed in
   * HIViewContentInfo.u.iconTypeAndCreator.type. The creator field of
   * the iconTypeAndCreator field is ignored in this case. Available in
   * Mac OS X 10.5 and later.
   }
	kHIViewContentAlertIconType = 138;

  {
   * The view's content is a reference to an NSImage. The NSImage*
   * should be placed in HIViewContentInfo.u.nsImage. Available in Mac
   * OS X 10.5 and later.
   }
	kHIViewContentNSImage = 139;


{
 *  HITypeAndCreator
 *  
 *  Summary:
 *    A type/creator pair used to identify an IconRef.
 }
type
	HITypeAndCreator = record
{
   * The icon type.
   }
		typ: OSType;

  {
   * The icon creator.
   }
		creator: OSType;
	end;

{
 *  HIViewContentInfo
 *  
 *  Summary:
 *    Defines the image content of a view.
 *  
 *  Discussion:
 *    This structure is the HIView equivalent of the
 *    ControlImageContentInfo structure. On Mac OS X 10.5 and later,
 *    you should use this structure with the HIViewSetImageContent and
 *    HIViewCopyImageContent APIs to set or retrieve the image content
 *    of a view. 
 *    
 *    Prior to Mac OS X 10.5, you may pass this structure to
 *    GetControlData and SetControlData with the kControlContentTag
 *    constant. Note, however, that the size of this structure as
 *    declared in the Mac OS X 10.5 headers is different (and larger)
 *    than the size of this structure as declared in the Mac OS X 10.4
 *    headers, and the Mac OS X 10.5 version is larger than the size of
 *    the ControlImageContentInfo structure. The view implementations
 *    prior to Mac OS X 10.5 only support Get/SetControlData requests
 *    if the specified data size matches the size of
 *    ControlImageContentInfo. Therefore, if you need to use
 *    Get/SetControlData with this structure prior to Mac OS X 10.5,
 *    you should pass sizeof(ControlImageContentInfo) rather than
 *    sizeof(HIViewContentInfo) as the size of the incoming/outgoing
 *    data buffer.
 }
type
	HIViewContentInfo = record
{
   * The type of content referenced in the content union.
   }
		contentType: HIViewContentType;
		case SInt16 of
{$ifc not TARGET_CPU_64}
		0: (
			iconSuite: IconSuiteRef;
			);
{$endc} {not TARGET_CPU_64}
		1: (
			iconRef: IconRef_fix;
			);
		2: (
			imagiconTypeAndCreatoreRef: HITypeAndCreator;
			);
		3: (
			imageRef: CGImageRef;
			);
		4: (
			imageResource: CFStringRef;
			);
		5: (
			imageFile: CFURLRef;
			);
	end;
type
	HIViewContentInfoPtr = ^HIViewContentInfo;
{==============================================================================}
{  ERROR CODES                                                                 }
{==============================================================================}

{
 *  Discussion:
 *    View/Control Error Codes
 }
const
{
   * This value will be returned from an HIView API or a Control
   * Manager API when an action that is only supported on a compositing
   * window is attempted on a non-compositing window. This doesn't
   * necessarily mean that the API is only callable for compositing
   * windows; sometimes the legality of the action is based on other
   * parameters of the API. See HIViewAddSubview for one particular use
   * of this error code.
   }
	errNeedsCompositedWindow = -30598;

{==============================================================================}
{  HIOBJECT SUPPORT                                                            }
{  Setting Initial Bounds                                                      }
{  When creating a view using HIObjectCreate, you can set the initial bounds   }
{  automatically by passing in an initialization event into HIObjectCreate     }
{  with a kEventParamBounds parameter as typeHIRect or typeQDRectangle.        }
{==============================================================================}
{ The HIObject class ID for the HIView class. }
{$ifc USE_CFSTR_CONSTANT_MACROS}
{$definec kHIViewClassID CFSTRP('com.apple.hiview')}
{$endc}
{==============================================================================}
{  EMBEDDING                                                                   }
{==============================================================================}
{$ifc not TARGET_CPU_64}
{
 *  HIViewGetRoot()
 *  
 *  Discussion:
 *    Returns the root view for a window.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window to get the root for.
 *  
 *  Result:
 *    The root view for the window, or NULL if an invalid window is
 *    passed.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetRoot( inWindow: WindowRef ): HIViewRef; external name '_HIViewGetRoot';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewAddSubview()
 *  
 *  Discussion:
 *    Adds a subview to the given parent. The new subview is added to
 *    the front of the list of subviews (i.e., it is made topmost).
 *    
 *    The subview being added is not retained by the new parent view.
 *    Do not release the view after adding it, or it will cease to
 *    exist. All views in a window will be released automatically when
 *    the window is destroyed. 
 *    
 *    Note that you should not use this API to transfer a window's
 *    content view from one window to another. A window's content view
 *    should always be left in its original window.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inParent:
 *      The view which will receive the new subview.
 *    
 *    inNewChild:
 *      The subview being added.
 *  
 *  Result:
 *    An operating system result code. 
 *    errNeedsCompositedWindow will be returned when you try to embed
 *    into the content view in a non-compositing window; you can only
 *    embed into the content view in compositing windows.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewAddSubview( inParent: HIViewRef; inNewChild: HIViewRef ): OSStatus; external name '_HIViewAddSubview';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewRemoveFromSuperview()
 *  
 *  Discussion:
 *    Removes a view from its parent. 
 *    The subview being removed from the parent is not released and
 *    still exists.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to remove.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewRemoveFromSuperview( inView: HIViewRef ): OSStatus; external name '_HIViewRemoveFromSuperview';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewGetSuperview()
 *  
 *  Discussion:
 *    Returns a view's parent view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose parent you are interested in getting.
 *  
 *  Result:
 *    An HIView reference, or NULL if this view has no parent or is
 *    invalid.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetSuperview( inView: HIViewRef ): HIViewRef; external name '_HIViewGetSuperview';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewGetFirstSubview()
 *  
 *  Discussion:
 *    Returns the first subview of a container. The first subview is
 *    the topmost subview in z-order.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose subview you are fetching.
 *  
 *  Result:
 *    An HIView reference, or NULL if this view has no subviews or is
 *    invalid.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetFirstSubview( inView: HIViewRef ): HIViewRef; external name '_HIViewGetFirstSubview';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewGetLastSubview()
 *  
 *  Discussion:
 *    Returns the last subview of a container. The last subview is the
 *    bottommost subview in z-order.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose subview you are fetching.
 *  
 *  Result:
 *    An HIView reference, or NULL if this view has no subviews or is
 *    invalid.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetLastSubview( inView: HIViewRef ): HIViewRef; external name '_HIViewGetLastSubview';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewGetNextView()
 *  
 *  Discussion:
 *    Returns the next view after the one given, in z-order.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to use as reference.
 *  
 *  Result:
 *    An HIView reference, or NULL if this view has no view behind it
 *    or is invalid.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetNextView( inView: HIViewRef ): HIViewRef; external name '_HIViewGetNextView';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewGetPreviousView()
 *  
 *  Discussion:
 *    Returns the previous view before the one given, in z-order.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to use as reference.
 *  
 *  Result:
 *    An HIView reference, or NULL if this view has no view in front of
 *    it or is invalid.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetPreviousView( inView: HIViewRef ): HIViewRef; external name '_HIViewGetPreviousView';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewCountSubviews()
 *  
 *  Summary:
 *    Counts the number of subviews embedded in a view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to count subviews.
 *    
 *    outSubviewCount:
 *  
 *  Result:
 *    The number of subviews of the specified view.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewCountSubviews( inView: HIViewRef ): CFIndex; external name '_HIViewCountSubviews';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetIndexedSubview()
 *  
 *  Summary:
 *    Get the Nth subview of a view.
 *  
 *  Discussion:
 *    Instead of calling HIViewGetIndexedSubview repeatedly, it may be
 *    more efficient to iterate through the subviews of a view with
 *    calls HIViewGetFirstSubview and HIViewGetNextView.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose indexed sub-view is being requested.
 *    
 *    inSubviewIndex:
 *      The index of the subview to get.
 *    
 *    outSubview:
 *      An HIViewRef to be filled with the indexed subview.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetIndexedSubview( inView: HIViewRef; inSubviewIndex: CFIndex; var outSubview: HIViewRef ): OSStatus; external name '_HIViewGetIndexedSubview';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetZOrder()
 *  
 *  Discussion:
 *    Allows you to change the front-to-back ordering of sibling views.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose Z-order you wish to change.
 *    
 *    inOp:
 *      Indicates to order inView above or below inOther.
 *    
 *    inOther:
 *      Another optional view to use as a reference. You can pass NULL
 *      to mean an absolute position. For example, passing
 *      kHIViewZOrderAbove and NULL will move a view to the front of
 *      all of its siblings. Likewise, passing kHIViewZOrderBelow and
 *      NULL will move it to the back.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetZOrder( inView: HIViewRef; inOp: HIViewZOrderOp; inOther: HIViewRef { can be NULL } ): OSStatus; external name '_HIViewSetZOrder';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{==============================================================================}
{  STATE and VALUES                                                            }
{==============================================================================}
{$endc} {not TARGET_CPU_64}


{
 *  HIViewKind
 }
type
	HIViewKind = record
{
   * The signature of the view. Apple reserves all signatures made up
   * of only lowercase characters.
   }
		signature: OSType;

  {
   * The kind of the view. Apple reserves all kinds made up of only
   * lowercase characters.
   }
		kind: OSType;
	end;

{
 *  View signature kind
 *  
 }
const
{
   * The signature of all HIToolbox views.
   }
	kHIViewKindSignatureApple = FourCharCode('appl');

{$ifc not TARGET_CPU_64}
{
 *  HIViewSetVisible()
 *  
 *  Discussion:
 *    Hides or shows a view. Marks the area the view will occupy or
 *    used to occupy as needing to be redrawn later.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to hide or show.
 *    
 *    inVisible:
 *      A boolean value which indicates whether you wish to hide the
 *      view (false) or show the view (true).
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetVisible( inView: HIViewRef; inVisible: Boolean ): OSStatus; external name '_HIViewSetVisible';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewIsVisible()
 *  
 *  Summary:
 *    Returns whether a view is visible.
 *  
 *  Discussion:
 *    Note that HIViewIsVisible returns a view's effective visibility,
 *    which is determined both by the view's own visibility and the
 *    visibility of its parent views. If a parent view is invisible,
 *    then this view is considered to be invisible also. 
 *    
 *    Latent visibility can be determined with HIViewIsLatentlyVisible.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose visibility you wish to determine.
 *  
 *  Result:
 *    A boolean value indicating whether the view is visible (true) or
 *    hidden (false).
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewIsVisible( inView: HIViewRef ): Boolean; external name '_HIViewIsVisible';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewIsLatentlyVisible()
 *  
 *  Summary:
 *    Returns whether or not a view is latently visible.
 *  
 *  Discussion:
 *    The view's visibility is also affected by the visibility of its
 *    parents; if any parent view is invisible, this view is considered
 *    invisible as well. HIViewIsLatentlyVisible returns whether a view
 *    is latently visible, even if its parents are invisible.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose latent visibility is to be checked.
 *  
 *  Result:
 *    True if the view is latently visible, otherwise false.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewIsLatentlyVisible( inView: HIViewRef ): Boolean; external name '_HIViewIsLatentlyVisible';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetHilite()
 *  
 *  Summary:
 *    Changes the highlighting of a view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view on which to set the highlight.
 *    
 *    inHilitePart:
 *      An HIViewPartCode indicating the part of the view to highlight.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetHilite( inView: HIViewRef; inHilitePart: HIViewPartCode ): OSStatus; external name '_HIViewSetHilite';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewIsActive()
 *  
 *  Summary:
 *    Returns whether or not a view is active.
 *  
 *  Discussion:
 *    The view's active state is also affected by the active state of
 *    its parents; if any parent view is inactive, this view is
 *    considered inactive as well. HIViewIsActive can optionally check
 *    to see if a view is latently active, even if its parents are
 *    inactive.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose active state is to be checked.
 *    
 *    outIsLatentActive:
 *      A pointer to a Boolean to be filled in with the latent active
 *      state of the view. The Boolean is set to true if the view is
 *      latently active, otherwise false. Can be NULL.
 *  
 *  Result:
 *    True if the view is active, otherwise false.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewIsActive( inView: HIViewRef; outIsLatentActive: BooleanPtr { can be NULL } ): Boolean; external name '_HIViewIsActive';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetActivated()
 *  
 *  Summary:
 *    Sets whether or not a view is active or inactive. If any children
 *    of the view have a latent active state, they will be adjusted
 *    accordingly.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to activate or deactivate.
 *    
 *    inSetActivated:
 *      True if setting the view to active, false if setting the view
 *      to inactive.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetActivated( inView: HIViewRef; inSetActivated: Boolean ): OSStatus; external name '_HIViewSetActivated';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewIsEnabled()
 *  
 *  Summary:
 *    Tests whether or not a view is enabled.
 *  
 *  Discussion:
 *    The view's enabled state is also affected by the enabled state of
 *    its parents; if any parent view is disabled, this view is
 *    considered disabled as well. HIViewIsEnabled can optionally check
 *    to see if a view is latently enabled, even if its parents are
 *    disabled.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to test.
 *    
 *    outIsLatentEnabled:
 *      A pointer to a Boolean to be filled in with the latent enabled
 *      state of the view. The Boolean is set to true if the view is
 *      latently enabled, otherwise false. Can be NULL.
 *  
 *  Result:
 *    True if the view is enabled, otherwise false.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewIsEnabled( inView: HIViewRef; outIsLatentEnabled: BooleanPtr { can be NULL } ): Boolean; external name '_HIViewIsEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetEnabled()
 *  
 *  Summary:
 *    Sets whether or not a view (and any subviews) are enabled or
 *    disabled.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to enable or disable.
 *    
 *    inSetEnabled:
 *      True if setting the view to enabled, false if setting the view
 *      to disabled.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetEnabled( inView: HIViewRef; inSetEnabled: Boolean ): OSStatus; external name '_HIViewSetEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewIsCompositingEnabled()
 *  
 *  Summary:
 *    Returns whether a view is being used in a compositing hierarchy.
 *  
 *  Discussion:
 *    A view that supports both compositing mode and non-compositing
 *    mode can use this routine to determine which mode it is currently
 *    running in. Looking for a window's kWindowCompositingAttribute is
 *    not sufficient, since some windows with that attribute have some
 *    of its views in non-compositing mode and vice-versa.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose compositing state you wish to determine.
 *  
 *  Result:
 *    A boolean value indicating whether the view is in compositing
 *    mode (true) or non-compositing mode (false).
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewIsCompositingEnabled( inView: HIViewRef ): Boolean; external name '_HIViewIsCompositingEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetText()
 *  
 *  Summary:
 *    Sets the text of a view to the specified string.
 *  
 *  Discussion:
 *    The "text" of the view is the text that will be displayed when
 *    drawing the view. This API first attempts to set the view's text
 *    (generally successful on views that handle the
 *    kControlEditTextCFStringTag SetControlData tag). If the attempt
 *    is unsuccessful, the view's title is set instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose text is being set.
 *    
 *    inText:
 *      The text to set for the view. The string is copied by the view,
 *      and may be released by the caller afterwards.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetText( inView: HIViewRef; inText: CFStringRef ): OSStatus; external name '_HIViewSetText';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewCopyText()
 *  
 *  Summary:
 *    Makes a copy of the view's text as a CFString.
 *  
 *  Discussion:
 *    The "text" of the view is the text that will be displayed when
 *    drawing the view. This API first attempts to get the view's text
 *    (generally successful on views that handle the
 *    kControlEditTextCFStringTag GetControlData tag). If the attempt
 *    is unsuccessful, the view's title is copied instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to get the text.
 *  
 *  Result:
 *    A CFStringRef containing a copy of the view's text. The caller of
 *    HIViewCopyText is responsible for releasing the returned text.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewCopyText( inView: HIViewRef ): CFStringRef; external name '_HIViewCopyText';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetValue()
 *  
 *  Summary:
 *    Gets a view's value.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to get the value.
 *  
 *  Result:
 *    The view's value.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetValue( inView: HIViewRef ): SInt32; external name '_HIViewGetValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetValue()
 *  
 *  Summary:
 *    Sets a view's value.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose value is to be set.
 *    
 *    inValue:
 *      The new value.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetValue( inView: HIViewRef; inValue: SInt32 ): OSStatus; external name '_HIViewSetValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetMinimum()
 *  
 *  Summary:
 *    Gets a view's minimum value.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to get the minimum value.
 *  
 *  Result:
 *    The view's minimum value.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetMinimum( inView: HIViewRef ): SInt32; external name '_HIViewGetMinimum';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetMinimum()
 *  
 *  Summary:
 *    Sets a view's minimum value.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose minimum value is to be set.
 *    
 *    inMinimum:
 *      The new minimum value.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetMinimum( inView: HIViewRef; inMinimum: SInt32 ): OSStatus; external name '_HIViewSetMinimum';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetMaximum()
 *  
 *  Summary:
 *    Gets a view's maximum value.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to get the maximum value.
 *  
 *  Result:
 *    The view's maximum value.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetMaximum( inView: HIViewRef ): SInt32; external name '_HIViewGetMaximum';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetMaximum()
 *  
 *  Summary:
 *    Sets a view's maximum value.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose maximum value is to be set.
 *    
 *    inMaximum:
 *      The new maximum value.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetMaximum( inView: HIViewRef; inMaximum: SInt32 ): OSStatus; external name '_HIViewSetMaximum';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetViewSize()
 *  
 *  Summary:
 *    Gets a view's view size.
 *  
 *  Discussion:
 *    The view size is the size of the content to which a view's
 *    display is proportioned. Most commonly used to set the
 *    proportional size of a scroll bar's thumb indicator.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to get the view size.
 *  
 *  Result:
 *    The view size.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetViewSize( inView: HIViewRef ): SInt32; external name '_HIViewGetViewSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetViewSize()
 *  
 *  Summary:
 *    Sets a view's view size.
 *  
 *  Discussion:
 *    The view size is the size of the content to which a view's
 *    display is proportioned. Most commonly used to set the
 *    proportional size of a scroll bar's thumb indicator.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose view size is to be set.
 *    
 *    inViewSize:
 *      The new view size.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetViewSize( inView: HIViewRef; inViewSize: SInt32 ): OSStatus; external name '_HIViewSetViewSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewIsValid()
 *  
 *  Summary:
 *    HIViewIsValid tests to see if the passed in view is a view that
 *    HIToolbox knows about. It does not sanity check the data in the
 *    view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to test for validity.
 *  
 *  Result:
 *    True if the view is a valid view, otherwise, false.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewIsValid( inView: HIViewRef ): Boolean; external name '_HIViewIsValid';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetID()
 *  
 *  Summary:
 *    Sets the HIViewID of a view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to set the ID.
 *    
 *    inID:
 *      The ID to set on the view.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetID( inView: HIViewRef; inID: HIViewID ): OSStatus; external name '_HIViewSetID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetID()
 *  
 *  Summary:
 *    Gets the HIViewID of a view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to get the ID.
 *    
 *    outID:
 *      A pointer to an HIViewID to be filled with the view's ID.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetID( inView: HIViewRef; var outID: HIViewID ): OSStatus; external name '_HIViewGetID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetCommandID()
 *  
 *  Summary:
 *    Sets the command ID of a view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to set the command ID.
 *    
 *    inCommandID:
 *      The command ID to set on the view.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetCommandID( inView: HIViewRef; inCommandID: UInt32 ): OSStatus; external name '_HIViewSetCommandID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetCommandID()
 *  
 *  Summary:
 *    Gets the command ID of a view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to get the command ID.
 *    
 *    outCommandID:
 *      A pointer to a UInt32 to fill with the view's command id.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetCommandID( inView: HIViewRef; var outCommandID: UInt32 ): OSStatus; external name '_HIViewGetCommandID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetKind()
 *  
 *  Summary:
 *    Returns the kind of the given view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose kind to get.
 *    
 *    outViewKind:
 *      On successful exit, this will contain the view signature and
 *      kind. See ControlDefinitions.h or HIView.h for the kinds of
 *      each system view.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetKind( inView: HIViewRef; var outViewKind: HIViewKind ): OSStatus; external name '_HIViewGetKind';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{==============================================================================}
{  POSITIONING                                                                 }
{==============================================================================}
{
 *  HIViewGetBounds()
 *  
 *  Discussion:
 *    Returns the local bounds of a view. The local bounds are the
 *    coordinate system that is completely view-relative. A view's top
 *    left coordinate starts out at 0, 0. Most operations are done in
 *    these local coordinates. Moving a view is done via the frame
 *    instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose bounds you wish to determine.
 *    
 *    outRect:
 *      The local bounds of the view.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetBounds( inView: HIViewRef; var outRect: HIRect ): OSStatus; external name '_HIViewGetBounds';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewGetFrame()
 *  
 *  Discussion:
 *    Returns the frame of a view. The frame is the bounds of a view
 *    relative to its parent's local coordinate system.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose frame you wish to determine.
 *    
 *    outRect:
 *      The frame of the view.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetFrame( inView: HIViewRef; var outRect: HIRect ): OSStatus; external name '_HIViewGetFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSetFrame()
 *  
 *  Discussion:
 *    Sets the frame of a view. This effectively moves the view within
 *    its parent. It also marks the view (and anything that was exposed
 *    behind it) to be redrawn.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose frame you wish to change.
 *    
 *    inRect:
 *      The new frame of the view.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetFrame( inView: HIViewRef; const (*var*) inRect: HIRect ): OSStatus; external name '_HIViewSetFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewMoveBy()
 *  
 *  Discussion:
 *    Moves a view by a certain distance, relative to its current
 *    location. This affects a view's frame, but not its bounds.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view you wish to move.
 *    
 *    inDX:
 *      The horizontal distance to move the view. Negative values move
 *      the view to the left, positive values to the right.
 *    
 *    inDY:
 *      The vertical distance to move the view. Negative values move
 *      the view upward, positive values downward.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewMoveBy( inView: HIViewRef; inDX: CGFloat; inDY: CGFloat ): OSStatus; external name '_HIViewMoveBy';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewPlaceInSuperviewAt()
 *  
 *  Discussion:
 *    Places a view at an absolute location within its parent. This
 *    affects the view's frame, but not its bounds.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view you wish to position.
 *    
 *    inX:
 *      The absolute horizontal coordinate at which to position the
 *      view.
 *    
 *    inY:
 *      The absolute vertical coordinate at which to position the view.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewPlaceInSuperviewAt( inView: HIViewRef; inX: CGFloat; inY: CGFloat ): OSStatus; external name '_HIViewPlaceInSuperviewAt';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewReshapeStructure()
 *  
 *  Discussion:
 *    This is for use by custom views. If a view decides that its
 *    structure will change shape, it should call this. This tells the
 *    Toolbox to recalc things and invalidate as appropriate. You might
 *    use this when gaining/losing a focus ring, for example.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to reshape and invalidate.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewReshapeStructure( inView: HIViewRef ): OSStatus; external name '_HIViewReshapeStructure';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewRegionChanged()
 *  
 *  Discussion:
 *    Allows a view to tell the view system that a region of itself has
 *    changed. The view system might choose to react in some way. For
 *    example, if a view's clickable region has changed, this can be
 *    called to tell the Toolbox to resync the region it uses for async
 *    window dragging, if enabled. Likewise, if a view's opaque region
 *    changes, we can adjust the window's opaque shape as well. When
 *    views are moved, resizes, this stuff is taken care of for you. So
 *    this only need be called when there's a change in your view that
 *    occurs outside of those times.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to deal with.
 *    
 *    inRegionCode:
 *      The region that was changed. This can only be the structure
 *      opaque, and clickable regions at present.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewRegionChanged( inView: HIViewRef; inRegionCode: HIViewPartCode ): OSStatus; external name '_HIViewRegionChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  HIViewCopyShape()
 *  
 *  Summary:
 *    Copies the shape of a part of a view. See the discussion on
 *    meta-parts in this header for more information
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view for which to copy the shape.
 *    
 *    inPart:
 *      The part of the view whose shape is to be copied.
 *    
 *    outShape:
 *      On exit, contains a newly created shape. The caller of
 *      HIViewCopyShape is responsible for releasing the copied shape.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewCopyShape( inView: HIViewRef; inPart: HIViewPartCode; var outShape: HIShapeRef ): OSStatus; external name '_HIViewCopyShape';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetOptimalBounds()
 *  
 *  Summary:
 *    Obtain a view's optimal size and/or text placement.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to examine.
 *    
 *    outBounds:
 *      A pointer to an HIRect to be filled with the view's optimal
 *      bounds. Can be NULL.
 *    
 *    outBaseLineOffset:
 *      A pointer to a float to be filled with the view's optimal text
 *      placement. Can be NULL.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetOptimalBounds( inView: HIViewRef; outBounds: HIRectPtr { can be NULL }; outBaseLineOffset: CGFloatPtr { can be NULL } ): OSStatus; external name '_HIViewGetOptimalBounds';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{==============================================================================}
{  TEXT AND FONT SUPPORT                                                       }
{==============================================================================}
{
 *  HIViewSetTextFont()
 *  
 *  Summary:
 *    Set the font that the control will use. NULL will specify the
 *    default value.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose font is to be modified.
 *    
 *    inPart:
 *      The part whose font is to be modified.
 *    
 *    inFont:
 *      The font that the view should use to draw its text. The font
 *      will be retained by the view. If NULL, the view will revert to
 *      the default font.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewSetTextFont( inView: HIViewRef; inPart: HIViewPartCode; inFont: CTFontRef { can be NULL } ): OSStatus; external name '_HIViewSetTextFont';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewSetTextHorizontalFlush()
 *  
 *  Summary:
 *    Set the horizontal flushness of the view's text.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose flushness is to be modified.
 *    
 *    inPart:
 *      The part whose flushness is to be modified.
 *    
 *    inHFlush:
 *      The horizontal flush that the view's text will be drawn with.
 *      kHIThemeTextHorizontalFlushDefault will revert to the default
 *      flush for the view.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewSetTextHorizontalFlush( inView: HIViewRef; inPart: HIViewPartCode; inHFlush: HIThemeTextHorizontalFlush ): OSStatus; external name '_HIViewSetTextHorizontalFlush';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewSetTextVerticalFlush()
 *  
 *  Summary:
 *    Set the vertical flushness of the view's text.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose flushness is to be modified.
 *    
 *    inPart:
 *      The part whose flushness is to be modified.
 *    
 *    inVFlush:
 *      The vertical flush that the view's text will be drawn with.
 *      kHIThemeTextVerticalFlushDefault will revert to the default
 *      flush for the view.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewSetTextVerticalFlush( inView: HIViewRef; inPart: HIViewPartCode; inVFlush: HIThemeTextVerticalFlush ): OSStatus; external name '_HIViewSetTextVerticalFlush';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewSetTextTruncation()
 *  
 *  Summary:
 *    Sets how the view's text will truncate.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose truncation is to be modified.
 *    
 *    inPart:
 *      The part whose truncation is to be modified.
 *    
 *    inTrunc:
 *      How the view's text will be truncated if it doesn't fit within
 *      the available label space. kHIThemeTextTruncationDefault will
 *      revert to the default truncation for the view.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewSetTextTruncation( inView: HIViewRef; inPart: HIViewPartCode; inTrunc: HIThemeTextTruncation ): OSStatus; external name '_HIViewSetTextTruncation';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewGetThemeTextInfo()
 *  
 *  Summary:
 *    Gets the HIThemeTextInfo structure that is used to draw the
 *    view's text.
 *  
 *  Discussion:
 *    This function returns the HIThemeTextInfo structure that will be
 *    used for drawing the view's text. All of the fields will be
 *    concrete values, they will not contain constants of the form
 *    HIThemeTextFooDefault. You will be unable to determine if the
 *    view is using the default values using this API. This API is
 *    useful if you need to draw a text item using the same font and
 *    attributes that the view's text is drawing with.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose text information is to be queried.
 *    
 *    inPart:
 *      The part whose text information is to be queried.
 *    
 *    inVersion:
 *      The version of the HIThemeTextInfo structure that is being
 *      passed in. This is important for future compatibility with
 *      different versions of the HIThemeTextInfo structure. Currently
 *      this must be version 1.
 *    
 *    outTextInfo:
 *      A pointer to an HIThemeTextInfo structure whose version is
 *      given in the inVersion parameter.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewGetThemeTextInfo( inView: HIViewRef; inPart: HIViewPartCode; inVersion: UInt32; var outTextInfo: HIThemeTextInfo ): OSStatus; external name '_HIViewGetThemeTextInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{==============================================================================}
{  HIT TESTING/EVENT HANDLING                                                  }
{==============================================================================}
{
 *  HIViewGetViewForMouseEvent()
 *  
 *  Discussion:
 *    Returns the appropriate view to handle a mouse event. This is a
 *    little higher-level than HIViewGetSubviewHit. This routine will
 *    find the deepest view that should handle the mouse event, but
 *    along the way, it sends Carbon Events to each view asking it to
 *    return the appropriate subview. This allows parent views to catch
 *    clicks on their subviews. This is the recommended function to use
 *    before processing mouse events. Using one of the more primitive
 *    functions may result in an undefined behavior. In general we
 *    recommend the use of the Standard Window Handler instead of
 *    calling this function yourself.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to start from. You should pass the window's root view.
 *    
 *    inEvent:
 *      The mouse event in question.
 *    
 *    outView:
 *      The view that the mouse event should be sent to.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetViewForMouseEvent( inView: HIViewRef; inEvent: EventRef; var outView: HIViewRef ): OSStatus; external name '_HIViewGetViewForMouseEvent';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewClick()
 *  
 *  Discussion:
 *    After a successful call to HIViewGetViewForMouseEvent for a mouse
 *    down event, you should call this function to have the view handle
 *    the click. In general we recommend the use of the Standard Window
 *    Handler instead of calling this function yourself.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to handle the event.
 *    
 *    inEvent:
 *      The mouse event to handle.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewClick( inView: HIViewRef; inEvent: EventRef ): OSStatus; external name '_HIViewClick';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSimulateClick()
 *  
 *  Discussion:
 *    This function is used to simulate a mouse click on a given view.
 *    It sends a kEventControlSimulateHit event to the specified view,
 *    and also sends kEventControlHit and (if the Hit event is not
 *    handled) kEventCommandProcess events.
 *    
 *    Note that not all windows will respond to the events that are
 *    sent by this API. A fully Carbon-event-based window most likely
 *    will respond exactly as if the user had really clicked in the
 *    view. A window that is handled using classic EventRecord-based
 *    APIs (WaitNextEvent or ModalDialog) will typically not respond at
 *    all; to simulate a click in such a window, you may need to post a
 *    mouse-down/mouse-up pair, or use a Dialog Manager event filter
 *    proc to simulate a hit in a dialog item.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to test the part hit.
 *    
 *    inPartToClick:
 *      The part the view should consider to be clicked.
 *    
 *    inModifiers:
 *      The modifiers the view can consider for its click action.
 *    
 *    outPartClicked:
 *      The part that was hit, can be kHIViewNoPart if no action
 *      occurred. May be NULL if you don't need the part code returned.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSimulateClick( inView: HIViewRef; inPartToClick: HIViewPartCode; inModifiers: UInt32; outPartClicked: HIViewPartCodePtr { can be NULL } ): OSStatus; external name '_HIViewSimulateClick';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewGetPartHit()
 *  
 *  Discussion:
 *    Given a view, and a view-relative point, this function returns
 *    the part code hit as determined by the view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to test the part hit.
 *    
 *    inPoint:
 *      The view-relative point to use.
 *    
 *    outPart:
 *      The part hit by inPoint.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetPartHit( inView: HIViewRef; const (*var*) inPoint: HIPoint; var outPart: HIViewPartCode ): OSStatus; external name '_HIViewGetPartHit';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewGetSubviewHit()
 *  
 *  Discussion:
 *    Returns the child of the given view hit by the point passed in.
 *    This is more primitive than using HIViewGetViewForMouseEvent, and
 *    should be used only in non-event-handling cases.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view you wish to start from.
 *    
 *    inPoint:
 *      The mouse coordinate to use. This is passed in the local
 *      coordinate system of inView.
 *    
 *    inDeep:
 *      Pass true to find the deepest child hit, false to go only one
 *      level deep (just check direct children of inView).
 *    
 *    outView:
 *      The view hit by inPoint, or NULL if no subview was hit.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetSubviewHit( inView: HIViewRef; const (*var*) inPoint: HIPoint; inDeep: Boolean; var outView: HIViewRef ): OSStatus; external name '_HIViewGetSubviewHit';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewTrackMouseLocation()
 *  
 *  Summary:
 *    An HIView-based version of TrackMouseLocationWithOptions.
 *  
 *  Discussion:
 *    This routine is similar to TrackMouseLocationWithOptions
 *    described in CarbonEvents.i. Please read the notes on that
 *    function as well. HIViewTrackMouseLocation optionally returns the
 *    EventRef that ended the tracking loop, and the caller may extend
 *    the list of events that end the loop.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIViewRef in whose coordinate space to return the mouse
 *      position.
 *    
 *    inOptions:
 *      Pass kTrackMouseLocationOptionDontConsumeMouseUp to indicate
 *      that the toolbox should leave mouse-up events in the queue.
 *      Pass kTrackMouseLocationOptionIncludeScrollWheel to indicate
 *      that the tracking loop should terminate when a
 *      kEventMouseWheelMoved or kEventMouseScroll event is received.
 *    
 *    inTimeout:
 *      The amount of time to wait for an event. If no events arrive
 *      within this time, kMouseTrackingTimedOut is returned in
 *      outResult. Pass kEventDurationForever to wait indefinitely for
 *      the next event.
 *    
 *    inClientEventCount:
 *      Number of caller-supplied EventTypeSpecs in the
 *      inClientEventList parameter. Pass 0 if you do not want any
 *      custom event types to end the tracking loop.
 *    
 *    inClientEventList:
 *      Array of caller-supplied EventTypeSpecs that the caller wants
 *      to end the tracking loop. Pass NULL if you do not want any
 *      custom event types to end the tracking loop.
 *    
 *    outWhere:
 *      On exit, this parameter receives the mouse location from the
 *      last mouse event that caused this function to exit. If a
 *      timeout or key modifiers changed event caused this function to
 *      exit, the current mouse position at the time is returned. The
 *      mouse position will be returned in the coordinate space of the
 *      specifed HIView.
 *    
 *    outModifiers:
 *      On exit, this parameter receives the most recent state of the
 *      keyboard modifiers. If a timeout caused this function to exit,
 *      the current keyboard modifiers at the time are returned. You
 *      may pass NULL if you don't need this information.
 *    
 *    outEvent:
 *      On exit, this parameter receives the EventRef that caused the
 *      function to exit. You may pass NULL if you don't need this
 *      information. The event will be NULL for mouse-tracking results
 *      that don't involve events, such as the timeout expiring. If the
 *      event is not NULL, you must release the event when you're done
 *      with it.
 *    
 *    outResult:
 *      On exit, this parameter receives a value representing what kind
 *      of event was received that cause the function to exit, such as
 *      kMouseTrackingMouseUp. If a caller-supplied EventTypeSpec ended
 *      the loop, kMouseTrackingClientEvent is returned.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewTrackMouseLocation( inView: HIViewRef; inOptions: OptionBits; inTimeout: EventTimeout; inClientEventCount: ItemCount; inClientEventList: EventTypeSpecPtr { can be NULL }; var outWhere: HIPoint; outModifiers: UInt32Ptr { can be NULL }; outEvent: EventRefPtr { can be NULL }; var outResult: MouseTrackingResult ): OSStatus; external name '_HIViewTrackMouseLocation';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewTrackMouseShape()
 *  
 *  Summary:
 *    An HIView-based version of TrackMouseRegion.
 *  
 *  Discussion:
 *    This routine is similar to TrackMouseRegion described in
 *    CarbonEvents.i. Please read the notes on that function as well.
 *    HIViewTrackMouseShape optionally returns the EventRef that ended
 *    the tracking loop, and the caller may extend the list of events
 *    that end the loop.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIViewRef in whose coordinate space to return the mouse
 *      position.
 *    
 *    inShape:
 *      The shape to observe. This shape should be in the coordinates
 *      of the view specified in the inView parameter.
 *    
 *    ioWasInShape:
 *      On entry, this parameter should be set to true if the mouse is
 *      currently inside the shape passed in inShape, or false if the
 *      mouse is currently outside the shape. On exit, this parameter
 *      is updated to reflect the current reality; e.g., if the
 *      outResult parameter returns kMouseTrackingMouseExited,
 *      ioWasInShape will be set to false when this function exits.
 *      Because it is updated from within, you should only need to set
 *      this yourself before the first call to this function in your
 *      tracking loop. Typically, you should set this value to false
 *      initially, and HIViewTrackMouseShape will return immediately
 *      with kMouseTrackingMouseEntered if your guess was wrong.
 *    
 *    inOptions:
 *      Pass kTrackMouseLocationOptionDontConsumeMouseUp to indicate
 *      that the toolbox should leave mouse-up events in the queue.
 *      Pass kTrackMouseLocationOptionIncludeScrollWheel to indicate
 *      that the tracking loop should terminate when a
 *      kEventMouseWheelMoved or kEventMouseScroll event is received.
 *    
 *    inTimeout:
 *      The amount of time to wait for an event. If no events arrive
 *      within this time, kMouseTrackingTimedOut is returned in
 *      outResult. Pass kEventDurationForever to wait indefinitely for
 *      the next event.
 *    
 *    inClientEventCount:
 *      Number of caller-supplied EventTypeSpecs in the
 *      inClientEventList parameter. Pass 0 if you do not want any
 *      custom event types to end the tracking loop.
 *    
 *    inClientEventList:
 *      Array of caller-supplied EventTypeSpecs that the caller wants
 *      to end the tracking loop. Pass NULL if you do not want any
 *      custom event types to end the tracking loop.
 *    
 *    outModifiers:
 *      On exit, this parameter receives the most recent state of the
 *      keyboard modifiers. If a timeout caused this function to exit,
 *      the current keyboard modifiers at the time are returned. You
 *      may pass NULL if you don't need this information.
 *    
 *    outEvent:
 *      On exit, this parameter receives the EventRef that caused the
 *      function to exit. You may pass NULL if you don't need this
 *      information. The event will be NULL for mouse-tracking results
 *      that don't involve events, such as the timeout expiring. If the
 *      event is not NULL, you must release the event when you're done
 *      with it.
 *    
 *    outResult:
 *      On exit, this parameter receives a value representing what kind
 *      of event was received that cause the function to exit, such as
 *      kMouseTrackingMouseUp. If a caller-supplied EventTypeSpec ended
 *      the loop, kMouseTrackingClientEvent is returned.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewTrackMouseShape( inView: HIViewRef; inShape: HIShapeRef; var ioWasInShape: Boolean; inOptions: OptionBits; inTimeout: EventTimeout; inClientEventCount: ItemCount; inClientEventList: EventTypeSpecPtr { can be NULL }; outModifiers: UInt32Ptr { can be NULL }; outEvent: EventRefPtr { can be NULL }; var outResult: MouseTrackingResult ): OSStatus; external name '_HIViewTrackMouseShape';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{==============================================================================}
{  HIView-based tracking areas                                                 }
{==============================================================================}
{$endc} {not TARGET_CPU_64}

type
	HIViewTrackingAreaRef = ^OpaqueHIViewTrackingAreaRef; { an opaque type }
	OpaqueHIViewTrackingAreaRef = record end;
	HIViewTrackingAreaRefPtr = ^HIViewTrackingAreaRef;
const
	kEventParamHIViewTrackingArea = FourCharCode('ctra'); { typeHIViewTrackingAreaRef}
	typeHIViewTrackingAreaRef = FourCharCode('ctra');

{
 *  kEventClassControl / kEventControlTrackingAreaEntered
 *  
 *  Summary:
 *    The mouse has entered a tracking area owned by your control.
 *  
 *  Discussion:
 *    If you have installed a mouse tracking area in your view, you
 *    will receive this event when the mouse enters that area. The
 *    tracking area reference is sent with the event. This event is
 *    sent only to the view, and is not propagated past it.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    --> kEventParamDirectObject (in, typeControlRef)
 *          The control that owns the tracking area and is receiving
 *          the event. This parameter is available on Mac OS X 10.5 and
 *          later.
 *    
 *    --> kEventParamHIViewTrackingArea (in, typeHIViewTrackingAreaRef)
 *          The tracking area that was entered.
 *    
 *    --> kEventParamKeyModifiers (in, typeUInt32)
 *          The keyboard modifiers that were in effect when the mouse
 *          entered.
 *    
 *    --> kEventParamMouseLocation (in, typeHIPoint)
 *          The location of the mouse in view coordinates.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework
 *    CarbonLib:        not available
 }
const
	kEventControlTrackingAreaEntered = 23;

{
 *  kEventClassControl / kEventControlTrackingAreaExited
 *  
 *  Summary:
 *    The mouse has exited a tracking area owned by your control.
 *  
 *  Discussion:
 *    If you have installed a mouse tracking area in your view, you
 *    will receive this event when the mouse leaves that area. The
 *    tracking area reference is sent with the event. This event is
 *    sent only to the view, and is not propagated past it.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    --> kEventParamDirectObject (in, typeControlRef)
 *          The control that owns the tracking area and is receiving
 *          the event. This parameter is available on Mac OS X 10.5 and
 *          later.
 *    
 *    --> kEventParamHIViewTrackingArea (in, typeHIViewTrackingAreaRef)
 *          The tracking area that was entered.
 *    
 *    --> kEventParamKeyModifiers (in, typeUInt32)
 *          The keyboard modifiers that were in effect when the mouse
 *          left.
 *    
 *    --> kEventParamMouseLocation (in, typeHIPoint)
 *          The location of the mouse in view coordinates. This point
 *          may or may not lie on the boundary of the mouse region. It
 *          is merely where the mouse was relative to the view when the
 *          exit event was generated.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework
 *    CarbonLib:        not available
 }
const
	kEventControlTrackingAreaExited = 24;


type
	HIViewTrackingAreaID = UInt64;
	HIViewTrackingAreaIDPtr = ^HIViewTrackingAreaID;
{$ifc not TARGET_CPU_64}
{
 *  HIViewNewTrackingArea()
 *  
 *  Summary:
 *    Creates a new tracking area for a view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to create a tracking area for.
 *    
 *    inShape:
 *      The shape to use. Pass NULL to indicate the entire structure
 *      region of the view is to be used.
 *    
 *    inID:
 *      An identifier for this tracking area. This value is completely
 *      up to the view to define. Pass zero if you don't care.
 *    
 *    outRef:
 *      A reference to the newly created tracking area. This reference
 *      is NOT refcounted. The tracking area will be automatically
 *      destroyed when the view is destroyed; you do not need to
 *      destroy the tracking area yourself unless you want to remove it
 *      from the view before the view is destroyed. This parameter can
 *      be NULL in Mac OS X 10.5 or later if you don't need this
 *      information.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewNewTrackingArea( inView: HIViewRef; inShape: HIShapeRef { can be NULL }; inID: HIViewTrackingAreaID; outRef: HIViewTrackingAreaRefPtr { can be NULL } ): OSStatus; external name '_HIViewNewTrackingArea';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewChangeTrackingArea()
 *  
 *  Summary:
 *    Alters the shape of an existing tracking area.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inArea:
 *      The area to change.
 *    
 *    inShape:
 *      The shape to use. Pass NULL to indicate the entire structure
 *      region of the view is to be used.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewChangeTrackingArea( inArea: HIViewTrackingAreaRef; inShape: HIShapeRef ): OSStatus; external name '_HIViewChangeTrackingArea';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetTrackingAreaID()
 *  
 *  Summary:
 *    Retrieves the HIViewTrackingAreaID of an existing tracking area.
 *    This value was set upon creation of the HIViewTrackingArea.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inArea:
 *      The area whose HIViewTrackingAreaID to retrieve.
 *    
 *    outID:
 *      The HIViewTrackingAreaID for this tracking area.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetTrackingAreaID( inArea: HIViewTrackingAreaRef; var outID: HIViewTrackingAreaID ): OSStatus; external name '_HIViewGetTrackingAreaID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewDisposeTrackingArea()
 *  
 *  Summary:
 *    Disposes an existing tracking area. The reference is considered
 *    to be invalid after calling this function. Note that all tracking
 *    areas attached to a view are automatically destroyed when the
 *    view is destroyed.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inArea:
 *      The area to dispose.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewDisposeTrackingArea( inArea: HIViewTrackingAreaRef ): OSStatus; external name '_HIViewDisposeTrackingArea';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{==============================================================================}
{  DISPLAY                                                                     }
{==============================================================================}
{
 *  HIViewGetNeedsDisplay()
 *  
 *  Discussion:
 *    Returns true if the view passed in or any subview of it requires
 *    redrawing (i.e. part of it has been invalidated).
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to inspect.
 *  
 *  Result:
 *    A boolean result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetNeedsDisplay( inView: HIViewRef ): Boolean; external name '_HIViewGetNeedsDisplay';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSetNeedsDisplay()
 *  
 *  Discussion:
 *    Marks a view as needing to be completely redrawn, or completely
 *    valid. If the view is not visible, or is obscured completely by
 *    other views, no action is taken. 
 *    
 *    Note that this API does not affect the state of subviews of this
 *    view. If you need to modify subview state, you should use either
 *    HIViewSetSubviewsNeedDisplayInShape on Mac OS X 10.5 and later,
 *    or iterate over subviews with HIViewGetFirstSubview and
 *    HIViewGetNextView.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to mark dirty.
 *    
 *    inNeedsDisplay:
 *      A boolean which indicates whether inView needs to be redrawn or
 *      not.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetNeedsDisplay( inView: HIViewRef; inNeedsDisplay: Boolean ): OSStatus; external name '_HIViewSetNeedsDisplay';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSetNeedsDisplayInRect()
 *  
 *  Discussion:
 *    Marks a portion of a view as needing to be redrawn, or valid. If
 *    the view is not visible, or is obscured completely by other
 *    views, no action is taken. The rectangle passed is effectively
 *    intersected with the view's visible region. It should be in
 *    view-relative coordinates. 
 *    
 *    Note that this API does not affect the state of subviews of this
 *    view. If you need to modify subview state, you should use either
 *    HIViewSetSubviewsNeedDisplayInShape on Mac OS X 10.5 and later,
 *    or iterate over subviews with HIViewGetFirstSubview and
 *    HIViewGetNextView.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to mark dirty.
 *    
 *    inRect:
 *      The rectangle encompassing the area to mark dirty or clean.
 *    
 *    inNeedsDisplay:
 *      A boolean which indicates whether or not inRect should be added
 *      to the invalid region or removed from it.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetNeedsDisplayInRect( inView: HIViewRef; const (*var*) inRect: HIRect; inNeedsDisplay: Boolean ): OSStatus; external name '_HIViewSetNeedsDisplayInRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetNeedsDisplayInShape()
 *  
 *  Discussion:
 *    Marks a portion of a view as needing to be redrawn, or valid. If
 *    the view is not visible, or is obscured completely by other
 *    views, no action is taken. The shape passed is effectively
 *    intersected with the view's visible region. It should be in
 *    view-relative coordinates. 
 *    
 *    Note that this API does not affect the state of subviews of this
 *    view. If you need to modify subview state, you should use either
 *    HIViewSetSubviewsNeedDisplayInShape on Mac OS X 10.5 and later,
 *    or iterate over subviews with HIViewGetFirstSubview and
 *    HIViewGetNextView.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to mark dirty.
 *    
 *    inArea:
 *      The area to mark dirty or clean, in the coordinate system of
 *      the view. This parameter may be NULL in Mac OS X 10.5 and later
 *      to indicate that the entire view should be affected.
 *    
 *    inNeedsDisplay:
 *      A boolean which indicates whether or not inArea should be added
 *      to the invalid region or removed from it.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetNeedsDisplayInShape( inView: HIViewRef; inArea: HIShapeRef; inNeedsDisplay: Boolean ): OSStatus; external name '_HIViewSetNeedsDisplayInShape';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetNeedsDisplayInRegion()
 *  
 *  Discussion:
 *    Marks a portion of a view as needing to be redrawn, or valid. If
 *    the view is not visible, or is obscured completely by other
 *    views, no action is taken. The region passed is effectively
 *    intersected with the view's visible region. It should be in
 *    view-relative coordinates. 
 *    
 *    Note that this API does not affect the state of subviews of this
 *    view. If you need to modify subview state, you should use either
 *    HIViewSetSubviewsNeedDisplayInShape on Mac OS X 10.5 and later,
 *    or iterate over subviews with HIViewGetFirstSubview and
 *    HIViewGetNextView.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to mark dirty.
 *    
 *    inRgn:
 *      The region to mark dirty or clean.
 *    
 *    inNeedsDisplay:
 *      A boolean which indicates whether or not inRgn should be added
 *      to the invalid region or removed from it.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetNeedsDisplayInRegion( inView: HIViewRef; inRgn: RgnHandle; inNeedsDisplay: Boolean ): OSStatus; external name '_HIViewSetNeedsDisplayInRegion';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSetSubviewsNeedDisplayInShape()
 *  
 *  Summary:
 *    Validates or invalidates a portion of a view and all of its
 *    subviews.
 *  
 *  Discussion:
 *    Marks a portion of a view as needing to be redrawn, or valid, and
 *    then does the same for each subview of the view. If the view or a
 *    subview is not visible, or is obscured completely by other views,
 *    no action is taken for that view. The shape passed is effectively
 *    intersected with each view's visible region. The shape should be
 *    in view-relative coordinates. 
 *    
 *    Note! It is very rare that an application truly needs to
 *    invalidate a view and all of its subviews. Normally, when a view
 *    is invalidated, its subviews will be automatically redrawn by the
 *    HIView Manager after the parent view is redrawn, so it is not
 *    necessary to explicitly invalidate the subviews. (The only
 *    exception occurs when the parent view uses
 *    kHIViewFeatureDoesNotDraw; in that case, invalidating the parent
 *    view does nothing, and subviews are not invalidated or redrawn.)
 *    In most cases, if you think you need to use this API, you should
 *    probably consider whether all of the subviews need to redraw, or
 *    just some of them, and explicitly invalidate only those subviews
 *    that need to redraw. That will give you better performance than
 *    invalidating and redrawing every subview.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to mark dirty.
 *    
 *    inArea:
 *      The area to mark dirty or clean, in the coordinate system of
 *      the view. This parameter may be NULL to indicate that the
 *      entire view should be affected.
 *    
 *    inNeedsDisplay:
 *      A boolean which indicates whether or not inArea should be added
 *      to the invalid region or removed from it.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewSetSubviewsNeedDisplayInShape( inView: HIViewRef; inArea: HIShapeRef; inNeedsDisplay: Boolean ): OSStatus; external name '_HIViewSetSubviewsNeedDisplayInShape';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewRender()
 *  
 *  Discussion:
 *    Renders the invalid portions of a view (as marked with
 *    HIViewSetNeedsDisplay[InRegion]) immediately. Normally, these
 *    areas are redrawn at event loop time, but there might be
 *    situations where you need an immediate draw. Use this sparingly,
 *    as it does cause a fully composited draw for the area of the
 *    view; that is, all other views that intersect the area of the
 *    specified view will also be drawn. Calling this for several views
 *    at a particular level of a hierarchy can be costly. We highly
 *    recommend that you only pass the root view of a window to this
 *    API. The behavior of this API when passed a non-root view was
 *    poorly defined in Mac OS X 10.3 and has changed in Mac OS X 10.4.
 *    In 10.3, calling this API on a non-root view would entirely
 *    validate all of the views in the window that intersect the
 *    specified view, including portions that did not intersect the
 *    specified view and so were not actually drawn. In 10.4, calling
 *    this API on a non-root view will only validate those portions of
 *    each view that intersect the specified view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to draw.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewRender( inView: HIViewRef ): OSStatus; external name '_HIViewRender';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  HIViewGetSizeConstraints()
 *  
 *  Discussion:
 *    Return the minimum and maximum size for a view. A view must
 *    respond to this protocol to get meaningful results. These sizes
 *    can be used to help autoposition subviews, for example.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to inspect.
 *    
 *    outMinSize:
 *      The minimum size the view can be. May be NULL if you don't need
 *      this information.
 *    
 *    outMaxSize:
 *      The maximum size the view can be. May be NULL if you don't need
 *      this information.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetSizeConstraints( inView: HIViewRef; outMinSize: HISizePtr { can be NULL }; outMaxSize: HISizePtr { can be NULL } ): OSStatus; external name '_HIViewGetSizeConstraints';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{==============================================================================}
{  COORDINATE SYSTEM CONVERSION                                                }
{==============================================================================}
{
 *  HIViewConvertPoint()
 *  
 *  Discussion:
 *    Converts a point from one view to another. Both views must have a
 *    common ancestor, i.e. they must both be in the same window.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    ioPoint:
 *      The point to convert.
 *    
 *    inSourceView:
 *      The view whose coordinate system ioPoint is starting out in.
 *      You can pass NULL to indicate that ioPoint is a window-relative
 *      point.
 *    
 *    inDestView:
 *      The view whose coordinate system ioPoint should end up in. You
 *      can pass NULL to indicate that ioPoint is a window-relative
 *      point.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewConvertPoint( var ioPoint: HIPoint; inSourceView: HIViewRef; inDestView: HIViewRef ): OSStatus; external name '_HIViewConvertPoint';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewConvertRect()
 *  
 *  Discussion:
 *    Converts a rectangle from one view to another. Both views must
 *    have a common ancestor, i.e. they must both be in the same window.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    ioRect:
 *      The rectangle to convert.
 *    
 *    inSourceView:
 *      The view whose coordinate system ioRect is starting out in. You
 *      can pass NULL to indicate that ioRect is a window-relative
 *      rectangle.
 *    
 *    inDestView:
 *      The view whose coordinate system ioRect should end up in. You
 *      can pass NULL to indicate that ioRect is a window-relative
 *      rectangle.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewConvertRect( var ioRect: HIRect; inSourceView: HIViewRef; inDestView: HIViewRef ): OSStatus; external name '_HIViewConvertRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewConvertRegion()
 *  
 *  Discussion:
 *    Converts a region from one view to another. Both views must have
 *    a common ancestor, i.e. they must both be in the same window.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    ioRgn:
 *      The region to convert.
 *    
 *    inSourceView:
 *      The view whose coordinate system ioRgn is starting out in. You
 *      can pass NULL to indicate that ioRgn is a window-relative
 *      region.
 *    
 *    inDestView:
 *      The view whose coordinate system ioRgn should end up in. You
 *      can pass NULL to indicate that ioRgn is a window-relative
 *      region.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewConvertRegion( ioRgn: RgnHandle; inSourceView: HIViewRef; inDestView: HIViewRef ): OSStatus; external name '_HIViewConvertRegion';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSetDrawingEnabled()
 *  
 *  Discussion:
 *    Turns view drawing on or off. You can use this to ensure that no
 *    drawing events are sent to the view. Even Draw1Control will not
 *    draw! HIViewSetNeedsDisplay is also rendered useless when drawing
 *    is off.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to enable or disable drawing for.
 *    
 *    inEnabled:
 *      A boolean value indicating whether drawing should be on (true)
 *      or off (false).
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetDrawingEnabled( inView: HIViewRef; inEnabled: Boolean ): OSStatus; external name '_HIViewSetDrawingEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewIsDrawingEnabled()
 *  
 *  Discussion:
 *    Determines if drawing is currently enabled for a view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to get the drawing state for.
 *  
 *  Result:
 *    A boolean value indicating whether drawing is on (true) or off
 *    (false).
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewIsDrawingEnabled( inView: HIViewRef ): Boolean; external name '_HIViewIsDrawingEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewScrollRect()
 *  
 *  Discussion:
 *    Scrolls a view's contents, or a portion thereof. A view's
 *    contents are the pixels that it or any of its descendent views
 *    has drawn into. This will actually blit the contents of the view
 *    as appropriate to scroll, and then invalidate those portions
 *    which need to be redrawn. Be warned that this is a raw bit
 *    scroll. Anything that might overlap the target view will get
 *    thrashed as well.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to scroll. The bits drawn by the view's descendent
 *      views will also be scrolled.
 *    
 *    inRect:
 *      The rect to scroll. Pass NULL to mean the entire view. The rect
 *      passed cannot be bigger than the view's bounds. It must be in
 *      the local coordinate system of the view.
 *    
 *    inDX:
 *      The horizontal distance to scroll. Positive values shift to the
 *      right, negative values shift to the left.
 *    
 *    inDY:
 *      The vertical distance to scroll. Positive values shift
 *      downward, negative values shift upward.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewScrollRect( inView: HIViewRef; {const} inRect: HIRectPtr { can be NULL }; inDX: CGFloat; inDY: CGFloat ): OSStatus; external name '_HIViewScrollRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSetBoundsOrigin()
 *  
 *  Discussion:
 *    This API sets the origin of the view. This effectively also moves
 *    all subviews of a view as well. This call will NOT invalidate the
 *    view. This is because you might want to move the contents with
 *    HIViewScrollRect instead of redrawing the complete content.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose origin you wish to adjust.
 *    
 *    inX:
 *      The X coordinate.
 *    
 *    inY:
 *      The Y coordinate.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetBoundsOrigin( inView: HIViewRef; inX: CGFloat; inY: CGFloat ): OSStatus; external name '_HIViewSetBoundsOrigin';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{==============================================================================}
{  KEYBOARD FOCUS                                                              }
{==============================================================================}
{$endc} {not TARGET_CPU_64}


{
 *  Summary:
 *    Option bits for use with HIViewAdvanceFocusWithOptions and
 *    HIViewSetFocus.
 }
const
{
   * Explicitly requests "focus on everything" mode. All controls will
   * be considered focusable, regardless of the user's current
   * preferences. If this option is not specified, then setting or
   * advancing focus will obey the user's current preferences for
   * focusing traditionally or focusing on any control.
   }
	kHIViewFocusOnAnyControl = 1 shl 0;

  {
   * Explicitly requests "traditional focus" mode. Only traditionally
   * focusable controls (text and lists) will be considered focusable,
   * regardless of the user's current preference. If this option is not
   * specified, then setting or advancing focus will obey the user's
   * current preferences for focusing traditionally or focusing on any
   * control.
   }
	kHIViewFocusTraditionally = 1 shl 1;

  {
   * If advancing the focus would wrap around to the beginning or end
   * of the focus root, then errCouldntSetFocus is returned. If this
   * option is not specified, then advancing (or reversing) the focus
   * will wrap around to the first (or last) focusable child of the
   * focus root. This option is only valid for the
   * HIViewAdvanceFocusWithOptions API.
   }
	kHIViewFocusWithoutWrapping = 1 shl 2;

{$ifc not TARGET_CPU_64}
{
 *  HIViewAdvanceFocus()
 *  
 *  Discussion:
 *    Advances the focus to the next most appropriate view. Unless
 *    overridden in some fashion (either by overriding certain carbon
 *    events or using the HIViewSetNextFocus API), the Toolbox will use
 *    a spacially determinant method of focusing, attempting to focus
 *    left to right, top to bottom in a window, taking groups of views
 *    into account.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inRootForFocus:
 *      The subtree to manipulate. The focus will never leave
 *      inRootToFocus. Typically you would pass the content of the
 *      window, or the root. If focused on the toolbar, for example,
 *      the focus is limited to the toolbar only. In this case, the
 *      Toolbox passes the toolbar view in as the focus root for
 *      example.
 *    
 *    inModifiers:
 *      The EventModifiers of the keyboard event that ultimately caused
 *      the call to HIViewAdvanceFocus. These modifiers are used to
 *      determine the focus direction as well as other alternate
 *      focusing behaviors.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewAdvanceFocus( inRootForFocus: HIViewRef; inModifiers: EventModifiers ): OSStatus; external name '_HIViewAdvanceFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewAdvanceFocusWithOptions()
 *  
 *  Summary:
 *    Changes the focus in a window to the next or previous view.
 *  
 *  Discussion:
 *    This API has the same default behavior as HIViewAdvanceFocus, but
 *    the options parameter allows you to control some aspects of the
 *    focus behavior.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inRootForFocus:
 *      The root of the view hierarchy in which focusing will occur.
 *      Typically, this will be the content view of a window, but you
 *      may pass in other subviews as well to further constrain the
 *      focus.
 *    
 *    inModifiers:
 *      The event modifiers that the user pressed. If the Shift
 *      modifier is set, focus will move to the previous view;
 *      otherwise, it will move to the next view.
 *    
 *    inOptions:
 *      Options to further customize the focusing behavior. See
 *      kHIViewFocus constants.
 *  
 *  Result:
 *    An operating system result code, including errCouldntSetFocus if
 *    the focus could not be set.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewAdvanceFocusWithOptions( inRootForFocus: HIViewRef; inModifiers: UInt32; inOptions: OptionBits ): OSStatus; external name '_HIViewAdvanceFocusWithOptions';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewGetFocusPart()
 *  
 *  Discussion:
 *    Returns the currently focused part of the given view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to inquire about.
 *    
 *    outFocusPart:
 *      The part currently focused.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetFocusPart( inView: HIViewRef; var outFocusPart: HIViewPartCode ): OSStatus; external name '_HIViewGetFocusPart';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSubtreeContainsFocus()
 *  
 *  Discussion:
 *    Given a view, this function checks to see if it or any of its
 *    children currently are the keyboard focus. If so, true is
 *    returned as the function result.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inSubtreeStart:
 *      The view to start searching at.
 *  
 *  Result:
 *    A boolean result.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSubtreeContainsFocus( inSubtreeStart: HIViewRef ): Boolean; external name '_HIViewSubtreeContainsFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSetNextFocus()
 *  
 *  Discussion:
 *    This function hard-wires the next sibling view to shift focus to
 *    whenever the keyboard focus is advanced.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to set the next focus view for. This parameter and the
 *      inNextFocus parameter must both have the same parent view.
 *    
 *    inNextFocus:
 *      The view to set focus to next. This parameter and the inView
 *      parameter must both have the same parent view. Pass NULL to
 *      tell the view system to use the default rules.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetNextFocus( inView: HIViewRef; inNextFocus: HIViewRef { can be NULL } ): OSStatus; external name '_HIViewSetNextFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSetFirstSubViewFocus()
 *  
 *  Discussion:
 *    This function hard-wires the first subview to shift focus to
 *    whenever the keyboard focus is advanced and the container view is
 *    entered.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inParent:
 *      The parent view.
 *    
 *    inSubView:
 *      The first child which should receive focus. Pass NULL to tell
 *      the view system to use the default rules.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetFirstSubViewFocus( inParent: HIViewRef; inSubView: HIViewRef { can be NULL } ): OSStatus; external name '_HIViewSetFirstSubViewFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewSetFocus()
 *  
 *  Summary:
 *    Sets the focused view in a window.
 *  
 *  Discussion:
 *    This API is a replacement for the SetKeyboardFocus API.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view that should be focused. The window is implicitly
 *      specified by this view.
 *    
 *    inPart:
 *      The view part that should be focused. This parameter may be
 *      kHIViewNoPart to remove focus from the view (and the window).
 *    
 *    inOptions:
 *      Options to further customize the focusing behavior. Only
 *      kHIViewFocusOnAnyControl and kHIViewFocusTraditionally are
 *      currently allowed.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewSetFocus( inView: HIViewRef; inPart: HIViewPartCode; inOptions: OptionBits ): OSStatus; external name '_HIViewSetFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewGetFocus()
 *  
 *  Summary:
 *    Retrieves the focused view in a window.
 *  
 *  Discussion:
 *    This API is a replacement for the GetKeyboardFocus API.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window whose focused view to retrieve.
 *    
 *    outView:
 *      On exit, contains the window's focused view.
 *    
 *    outPart:
 *      On exit, contains the focused part of the focused view. This
 *      parameter may be NULL if you don't need this information. You
 *      can also get the focused part by calling HIViewGetFocusPart on
 *      the focused view.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewGetFocus( inWindow: WindowRef; var outView: HIViewRef; outPart: HIViewPartCodePtr { can be NULL } ): OSStatus; external name '_HIViewGetFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewShowsFocus()
 *  
 *  Summary:
 *    Indicates whether a view should show focus indicators, such as
 *    focus rings.
 *  
 *  Discussion:
 *    There are several factors that control whether a view should show
 *    focus indicators, including: 
 *    
 *    - does the view have a focused part? 
 *    - is the view active? 
 *    - is the view enabled? 
 *    - is the view contained in a window that shows focus indicators?
 *    
 *    
 *    This API encapsulates checking for all of these factors.
 *    Typically, a view will call this API in its kEventControlDraw
 *    handler to determine whether it should draw focus indicators in
 *    addition to its normal drawing.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose state to examine.
 *    
 *    inPart:
 *      A view part code. If this value is kHIViewNoPart, the API
 *      returns true if any part of the view is focused. If this value
 *      is not kHIViewNoPart, the API returns true if that specific
 *      part is focused.
 *  
 *  Result:
 *    Whether the view should draw focus indicators.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewShowsFocus( inView: HIViewRef; inPart: HIViewPartCode ): Boolean; external name '_HIViewShowsFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{==============================================================================}
{  LAYOUT                                                                      }
{  Mac OS X 10.3 provides a layout engine for HIViews that allows applications }
{  to specify the layout relationships between multiple views. The layout      }
{  engine will automatically reposition and resize views that have layout      }
{  information when necessary.                                                 }
{==============================================================================}
{$endc} {not TARGET_CPU_64}


{
 *  Summary:
 *    Since horizontal and vertical bindings are very similar in
 *    application, except along different axes, the binding kinds have
 *    been abstracted to minimum and maximum. Synonyms have been
 *    provided for convenience. You are encouraged to use them.
 *  
 *  Discussion:
 *    HIBindingKind constants.
 }
const
{
   * No binding is to occur.
   }
	kHILayoutBindNone = 0;

  {
   * Bind to the minimum of the axis.
   }
	kHILayoutBindMin = 1;

  {
   * Bind to the maximum of the axis.
   }
	kHILayoutBindMax = 2;
	kHILayoutBindLeft = kHILayoutBindMin;
	kHILayoutBindRight = kHILayoutBindMax;

  {
   * Synonyms for convenience and clarity.
   }
	kHILayoutBindTop = kHILayoutBindMin;
	kHILayoutBindBottom = kHILayoutBindMax;

type
	HIBindingKind = UInt16;

{
 *  HISideBinding
 *  
 *  Summary:
 *    A binding for a side of an HIView.
 *  
 *  Discussion:
 *    A side binding is entirely related to the change of the parent's
 *    position or size (but only as the size affects the maximum edge
 *    position). A side binding doesn't mean "move to where my
 *    relative's side is" but rather "move as my relative's side has
 *    moved".
 }
type
	HISideBinding = record
{
   * An HIViewRef to the view to which this side is bound. Can be NULL,
   * indicating that the the side is bound to its parent view.
   }
		toView: HIViewRef;                 { NULL means parent}

  {
   * An HIBindingKind indicating the bind kind.
   }
		kind: HIBindingKind;

  {
   * Not currently used. Must be set to 0.
   }
		offset: CGFloat;
	end;

{
 *  HIBinding
 *  
 *  Summary:
 *    A set of Top, Left, Bottom, and Right bindings for an HIView.
 }
type
	HIBinding = record
{
   * The top side bindings.
   }
		top: HISideBinding;

  {
   * The left side bindings.
   }
		left: HISideBinding;

  {
   * The bottom side bindings.
   }
		bottom: HISideBinding;

  {
   * The right side bindings.
   }
		right: HISideBinding;
	end;

{
 *  Discussion:
 *    HIScaleKind constants.
 }
const
{
   * The scale is determined from the axis size.
   }
	kHILayoutScaleAbsolute = 0;


type
	HIScaleKind = UInt16;

{
 *  HIAxisScale
 *  
 *  Summary:
 *    A scale description for an axis of an HIView.
 }
type
	HIAxisScale = record
{
   * An HIViewRef to the view to which this axis is scaled. Can be
   * NULL, indicating that the the axis is scaled relative to its
   * parent view.
   }
		toView: HIViewRef;                 { NULL means parent}

  {
   * An HIScaleKind describing the type of scaling to be applied. 
   * Currently, this field can't be anything other than
   * kHILayoutScaleAbsolute.
   }
		kind: HIScaleKind;

  {
   * A CGFloat indicating how much to scale the HIView. 0 indicates no
   * scaling. A value of 1 indicates that the view is to always have
   * the same axial size.
   }
		ratio: CGFloat;
	end;

{
 *  HIScaling
 *  
 *  Summary:
 *    A set of scaling descriptions for the axes of an HIView.
 }
type
	HIScaling = record
{
   * An HIAxisScale describing the horizontal scaling for an HIView.
   }
		x: HIAxisScale;

  {
   * An HIAxisScale describing the vertical scaling for an HIView.
   }
		y: HIAxisScale;
	end;

{
 *  Summary:
 *    Since horizontal and vertical positions are very similar in
 *    application, except along different axes, the position kinds have
 *    been abstracted to minimum and maximum. Synonyms have been
 *    provided for convenience. You are encouraged to use them.
 *  
 *  Discussion:
 *    HIPositionKind constants.
 }
const
{
   * No positioning is to occur.
   }
	kHILayoutPositionNone = 0;

  {
   * Centered positioning will occur. The view will be centered
   * relative to the specified view.
   }
	kHILayoutPositionCenter = 1;

  {
   * Minimum positioning will occur. The view will be left or top
   * aligned relative to the specified view.
   }
	kHILayoutPositionMin = 2;

  {
   * Maximum positioning will occur. The view will be right or bottom
   * aligned relative to the specified view.
   }
	kHILayoutPositionMax = 3;

  {
   * Synonyms for convenience and clarity.
   }
	kHILayoutPositionLeft = kHILayoutPositionMin;
	kHILayoutPositionRight = kHILayoutPositionMax;
	kHILayoutPositionTop = kHILayoutPositionMin;
	kHILayoutPositionBottom = kHILayoutPositionMax;


type
	HIPositionKind = UInt16;

{
 *  HIAxisPosition
 *  
 *  Summary:
 *    An axial position description for an HIView.
 }
type
	HIAxisPosition = record
{
   * An HIViewRef to the view relative to which a view will be
   * positioned. Can be NULL, indicating that the the view is
   * positioned relative to its parent view.
   }
		toView: HIViewRef;                 { NULL means parent}

  {
   * An HIPositionKind indicating the kind of positioning to apply.
   }
		kind: HIPositionKind;

  {
   * After the position kind has been applied, the origin component
   * that corresponds to the positioning axis is offet by this value.
   * (ex: Left aligned + 10 ).
   }
		offset: CGFloat;
	end;

{
 *  HIPositioning
 *  
 *  Summary:
 *    A positioning description for an HIView.
 }
type
	HIPositioning = record
{
   * An HIAxisPosition describing the horizontal positioning for an
   * HIView.
   }
		x: HIAxisPosition;
		y: HIAxisPosition;
	end;

{
 *  HILayoutInfo
 *  
 *  Summary:
 *    A layout description for an HIView.
 *  
 *  Discussion:
 *    The different layout transformations are applied sequentially to
 *    the HIView. 
 *    
 *    First, the bindings are applied. Note that the bindings are
 *    applied recursively to a container's HIViews. This requires care
 *    on your part, especially when applying inter-relational bindings.
 *    
 *    
 *    Then the scaling is applied (which could potentially override
 *    some of the previously applied bindings). Then the positioning is
 *    applied (which could potentially override some of the previously
 *    applied scaling and bindings).
 }
type
	HILayoutInfo = record
{
   * The version of the structure. The current version is
   * kHILayoutInfoVersionZero.
   }
		version: UInt32;

  {
   * An HIBinding structure describing the bindings to apply to the
   * sides of an HIView.
   }
		binding: HIBinding;

  {
   * An HIScaling structure describing the axial scaling to apply to an
   * HIView.
   }
		scale: HIScaling;

  {
   * An HIPositioning structure describing the positioning to apply to
   * an HIView.
   }
		position: HIPositioning;
	end;
const
	kHILayoutInfoVersionZero = 0;

{$ifc not TARGET_CPU_64}
{
 *  HIViewGetLayoutInfo()
 *  
 *  Summary:
 *    Get the layout info of an HIView.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIView whose layout info is to be retreived.
 *    
 *    outLayoutInfo:
 *      A pointer to an HILayoutInfo record into which to copy the
 *      layout info of the HIView. The version field of this record
 *      must be valid or the call will fail.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetLayoutInfo( inView: HIViewRef; var outLayoutInfo: HILayoutInfo ): OSStatus; external name '_HIViewGetLayoutInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  HIViewSetLayoutInfo()
 *  
 *  Summary:
 *    Set the layout info of an HIView.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIView whose layout info is to be set.
 *    
 *    inLayoutInfo:
 *      A pointer to an HILayoutInfo record containing the layout
 *      values to be set.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSetLayoutInfo( inView: HIViewRef; const (*var*) inLayoutInfo: HILayoutInfo ): OSStatus; external name '_HIViewSetLayoutInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  HIViewSuspendLayout()
 *  
 *  Summary:
 *    Suspends all layout handling for this layout and its children.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIView whose layout handling is to be suspended.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewSuspendLayout( inView: HIViewRef ): OSStatus; external name '_HIViewSuspendLayout';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  HIViewResumeLayout()
 *  
 *  Summary:
 *    Resumes all layout handling for this layout and its children.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIView whose layout handling is to be resumed.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewResumeLayout( inView: HIViewRef ): OSStatus; external name '_HIViewResumeLayout';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  HIViewIsLayoutActive()
 *  
 *  Summary:
 *    Tests the view to determine if layout is active or suspended.
 *    Note that this test does not determine whether or not the view
 *    has a valid layout, only whether or not the layout engine is
 *    active for the view.
 *  
 *  Discussion:
 *    The view's layout active state is also affected by the layout
 *    active state of its parents; if any parent view has inactive
 *    layout, this view is considered to have inactive layout as well.
 *    See HIViewIsLayoutLatentlyActive if latent layout active state is
 *    required.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIView whose layout handling is to be tested.
 *  
 *  Result:
 *    True if the view would respond to any linked relative's changes,
 *    otherwise false.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewIsLayoutActive( inView: HIViewRef ): Boolean; external name '_HIViewIsLayoutActive';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  HIViewIsLayoutLatentlyActive()
 *  
 *  Summary:
 *    The view's layout active state is also affected by the layout
 *    active state of its parents; if any parent view has inactive
 *    layout, this view is considered to have inactive layout as well.
 *    HIViewIsLayoutLatentlyActive returns whether a view's layout is
 *    latently active, even if one of its parent's layouts is not.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIView whose latent layout handling is to be tested.
 *  
 *  Result:
 *    True if the view would latently respond to any linked relative's
 *    changes, otherwise false.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewIsLayoutLatentlyActive( inView: HIViewRef ): Boolean; external name '_HIViewIsLayoutLatentlyActive';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewApplyLayout()
 *  
 *  Summary:
 *    Applies the current layout into to the specified view. Side
 *    bindings have no effect, but positioning and scaling will occur,
 *    in that order.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIView whose layout info is to be applied.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewApplyLayout( inView: HIViewRef ): OSStatus; external name '_HIViewApplyLayout';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{==============================================================================}
{  IMAGE CONTENT MANAGEMENT                                                    }
{==============================================================================}
{
 *  HIViewSetImageContent()
 *  
 *  Summary:
 *    Sets the content of a view to a particular image.
 *  
 *  Discussion:
 *    This API attempts to set the view's image content using
 *    SetControlData and the kControlContentTag constant.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose image content to set.
 *    
 *    inPart:
 *      The view part whose image content to set. For most views, you
 *      should pass kHIViewEntireView. Some views, such as the
 *      segmented view, allow you to pass a specific partcode here to
 *      indicate a particular part of the view.
 *    
 *    inContent:
 *      The image content to set. You may pass NULL to remove content
 *      from the view.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewSetImageContent( inView: HIViewRef; inPart: HIViewPartCode; {const} inContent: HIViewContentInfoPtr { can be NULL } ): OSStatus; external name '_HIViewSetImageContent';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewCopyImageContentWithSize()
 *  
 *  Summary:
 *    Retrieves the image content of a view.
 *  
 *  Discussion:
 *    This API attempts to get the view's image content using
 *    GetControlData and the kControlContentTag constant. If
 *    successful, it calls HIViewRetainImageContent.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view whose image content to retrieve.
 *    
 *    inPart:
 *      The view part whose image content to retrieve. For most views,
 *      you should pass kHIViewEntireView. Some views, such as the
 *      segmented view, allow you to pass a specific partcode here to
 *      indicate a particular part of the view.
 *    
 *    inContentSize:
 *      The size in bytes of the HIViewContentInfo structure that you
 *      are passing to the API. At most this many bytes will be written
 *      to your HIViewContentInfo structure.
 *    
 *    outContent:
 *      On exit, contains the view's image content. For image content
 *      types that support a refcount, the content has been retained
 *      before being returned; such content should be released by the
 *      caller. For image content that does not support a refcount, the
 *      actual content reference used by the view is returned; this
 *      content should not be released. You may use
 *      HIViewReleaseImageContent to release the content returned by
 *      this API.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewCopyImageContentWithSize( inView: HIViewRef; inPart: HIViewPartCode; inContentSize: ByteCount; var outContent: HIViewContentInfo ): OSStatus; external name '_HIViewCopyImageContentWithSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewRetainImageContent()
 *  
 *  Summary:
 *    Retains refcountable content contained in an HIViewContentInfo
 *    structure.
 *  
 *  Discussion:
 *    For image content data types that are refcountable, the image
 *    content retain count is incremented. Non-refcountable image
 *    content is ignored.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inContent:
 *      The image content to retain.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure HIViewRetainImageContent( const (*var*) inContent: HIViewContentInfo ); external name '_HIViewRetainImageContent';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  HIViewReleaseImageContent()
 *  
 *  Summary:
 *    Releases refcountable content contained in an HIViewContentInfo
 *    structure.
 *  
 *  Discussion:
 *    For image content data types that are refcountable, the image
 *    content retain count is decremented. Non-refcountable image
 *    content is ignored; it is _not_ freed. You must explicitly free
 *    non-refcountable image content yourself.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    ioContent:
 *      The image content to release. On exit, ioContent->contentType
 *      is set to kHIViewContentNone.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure HIViewReleaseImageContent( var ioContent: HIViewContentInfo ); external name '_HIViewReleaseImageContent';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{==============================================================================}
{  MISCELLANEOUS                                                               }
{==============================================================================}
{
 *  HIViewGetWindow()
 *  
 *  Discussion:
 *    Returns a reference to the window a given view is bound to. If
 *    the view reference passed is invalid, or the view is not embedded
 *    into any window, NULL is returned.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to query.
 *  
 *  Result:
 *    A window reference.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetWindow( inView: HIViewRef ): WindowRef; external name '_HIViewGetWindow';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  HIViewFindByID()
 *  
 *  Discussion:
 *    Allows you to find a particular view by its ID. The HIViewID type
 *    used by this API is identical to the older ControlID type.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inStartView:
 *      The view to start searching at.
 *    
 *    inID:
 *      The ID of the view you are looking for.
 *    
 *    outView:
 *      Receives the view if found.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewFindByID( inStartView: HIViewRef; inID: HIViewID; var outView: HIViewRef ): OSStatus; external name '_HIViewFindByID';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewGetAttributes()
 *  
 *  Discussion:
 *    Allows you to get the attributes of a view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to inspect.
 *    
 *    outAttrs:
 *      The attributes of the view.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetAttributes( inView: HIViewRef; var outAttrs: OptionBits ): OSStatus; external name '_HIViewGetAttributes';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewChangeAttributes()
 *  
 *  Discussion:
 *    Allows you to change the attributes of a view. You can
 *    simultaneously set and clear attributes.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to muck with.
 *    
 *    inAttrsToSet:
 *      The attributes you wish to set.
 *    
 *    inAttrsToClear:
 *      The attributes you wish to clear.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewChangeAttributes( inView: HIViewRef; inAttrsToSet: OptionBits; inAttrsToClear: OptionBits ): OSStatus; external name '_HIViewChangeAttributes';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{$endc} {not TARGET_CPU_64}


{
 *  Summary:
 *    Option bits for use with HIViewCreateOffscreenImage.
 }
const
{
   * Requests that the offscreen image should use the resolution of the
   * window's backing store. If the window is using crisp HiDPI mode,
   * the image size will therefore be equal to the view bounds
   * multiplied by the result of HIWindowGetBackingScaleFactor on the
   * view's window. Available in Mac OS X 10.8 and later.
   }
	kHIViewOffscreenImageUseWindowBackingResolution = 1 shl 0;

{$ifc not TARGET_CPU_64}
{
 *  HIViewCreateOffscreenImage()
 *  
 *  Discussion:
 *    Creates an CGImageRef for the view passed in. The view and any
 *    children it has are rendered in the resultant image. 
 *    
 *    Note that prior to Mac OS X 10.5, we do not recommend passing the
 *    root view of a window (returned by HIViewGetRoot) to this API.
 *    The API implementation in earlier versions of Mac OS X contained
 *    a bug that would corrupt the root view state, such that
 *    subsequent QuickDraw drawing in subviews of the root view would
 *    not appear in the root view's containing window.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view you wish to create an image of.
 *    
 *    inOptions:
 *      Options. In Mac OS X 10.8 and later, you may pass
 *      kHIViewOffscreenImageUseWindowBackingResolution. Otherwise this
 *      parameter must be 0.
 *    
 *    outFrame:
 *      The frame of the view within the resultant image. It is in the
 *      coordinate system of the image, where 0,0 is the top left
 *      corner of the image. This is so you can know exactly where the
 *      view lives in the image when the view draws outside its bounds
 *      for things such as shadows.
 *    
 *    outImage:
 *      The image of the view, including anything that would be drawn
 *      outside the view's frame.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewCreateOffscreenImage( inView: HIViewRef; inOptions: OptionBits; outFrame: HIRectPtr { can be NULL }; var outImage: CGImageRef ): OSStatus; external name '_HIViewCreateOffscreenImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HIViewDrawCGImage()
 *  
 *  Discussion:
 *    Draws an image in the right direction for an HIView. This is
 *    functionally the same as CGContextDrawImage, but it flips the
 *    context appropriately so that the image is drawn correctly.
 *    Because HIViews have their origin at the top, left, you are
 *    really drawing upside-down, so if you were to use the CG image
 *    drawing, you'd see what I mean! This call attempts to insulate
 *    you from that fact.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inContext:
 *      The context to draw in.
 *    
 *    inBounds:
 *      The bounds to draw the image into.
 *    
 *    inImage:
 *      The image to draw.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewDrawCGImage( inContext: CGContextRef; const (*var*) inBounds: HIRect; inImage: CGImageRef ): OSStatus; external name '_HIViewDrawCGImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{$endc} {not TARGET_CPU_64}


{$ifc not TARGET_CPU_64}
{
 *  HIViewGetFeatures()
 *  
 *  Discussion:
 *    Returns the features for the current view. This only returns
 *    feature bits for the HIView space. Older Control Manager features
 *    such as kControlSupportsDataAccess are not returned.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to query
 *    
 *    outFeatures:
 *      On output, the features for the view.
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetFeatures( inView: HIViewRef; var outFeatures: HIViewFeatures ): OSStatus; external name '_HIViewGetFeatures';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  HIViewChangeFeatures()
 *  
 *  Discussion:
 *    Allows you to change a view's features on the fly. Typically,
 *    this is up to the view itself to control. For example, it might
 *    decide that under some situations it is opaque and in others it
 *    is transparent. In general entities outside of the view itself
 *    should not call this function. The only exception might be UI
 *    building tools, where it would want to make sure a view always
 *    responds to clicks, for example, so it could override mouse
 *    tracking to drag items around. 
 *    
 *    When implementing a custom HIView, it is common to use
 *    HIViewChangeFeatures in the view's kEventHIObjectInitialize
 *    function to set up the view's initial feature bits. If your view
 *    needs to run on Mac OS X 10.2, however, where
 *    HIViewChangeFeatures is not available, you can set the view's
 *    initial feature bits by handling kEventControlInitialize and
 *    returning the appropriate feature flags in the
 *    kEventParamControlFeatures parameter. Note that in this case, you
 *    can only return feature flag constants starting with "kControl"
 *    from the Control Feature Bits enumeration in Controls.h; you
 *    cannot return kHIViewFeature constants.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to change
 *    
 *    inFeaturesToSet:
 *      The features to enable
 *    
 *    inFeaturesToClear:
 *      The features to disable
 *  
 *  Result:
 *    An operating system status code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewChangeFeatures( inView: HIViewRef; inFeaturesToSet: HIViewFeatures; inFeaturesToClear: HIViewFeatures ): OSStatus; external name '_HIViewChangeFeatures';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{$endc} {not TARGET_CPU_64}


{
 *  Summary:
 *    Constants for use with the HICreateTransformedCGImage API.
 }
const
{
   * No visual transform should be applied.
   }
	kHITransformNone = $00;

  {
   * The image should be transformed to use a disabled appearance. This
   * transform should not be combined with any other transform.
   }
	kHITransformDisabled = $01;

  {
   * The image should be transformed to use a selected appearance. This
   * transform should not be combined with any other transform.
   }
	kHITransformSelected = $4000;

{$ifc not TARGET_CPU_64}
{
 *  HICreateTransformedCGImage()
 *  
 *  Summary:
 *    Creates a new CGImage with a standard selected or disabled
 *    appearance.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inImage:
 *      The original image.
 *    
 *    inTransform:
 *      The transform to apply to the image.
 *    
 *    outImage:
 *      The new image. This image should be released by the caller.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HICreateTransformedCGImage( inImage: CGImageRef; inTransform: OptionBits; var outImage: CGImageRef ): OSStatus; external name '_HICreateTransformedCGImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewGetEventTarget()
 *  
 *  Discussion:
 *    Returns the EventTargetRef for the specified view. Once you
 *    obtain this reference, you can send events to the target and
 *    install event handler on it.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The view to return the target for.
 *  
 *  Result:
 *    An EventTargetRef.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function HIViewGetEventTarget( inView: HIViewRef ): EventTargetRef; external name '_HIViewGetEventTarget';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  HIViewSetUpTextColor()
 *  
 *  Summary:
 *    Applies the proper text color for the given view to the current
 *    context.
 *  
 *  Discussion:
 *    An embedding-savvy view which draws text must ensure that its
 *    text color properly contrasts the background on which it draws.
 *    This routine sends kEventControlApplyTextColor to each superview
 *    in the view hierarchy to determine and apply the proper text
 *    color to the given context until the event is handled. If no
 *    superview handles the event, HIView chooses a text color which
 *    contrasts any ThemeBrush which has been associated with the
 *    owning window (see SetThemeWindowBackground).
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inView:
 *      The HIViewRef that wants to draw text.
 *    
 *    inContext:
 *      The context into which drawing will take place.
 *  
 *  Result:
 *    An OSStatus code indicating success or failure. The most likely
 *    error is a controlHandleInvalidErr, resulting from a bad
 *    HIViewRef. Any non-noErr result indicates that the color set up
 *    failed, and that the caller should probably give up its attempt
 *    to draw.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function HIViewSetUpTextColor( inView: HIViewRef; inContext: CGContextRef ): OSStatus; external name '_HIViewSetUpTextColor';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{$endc} {not TARGET_CPU_64}

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
