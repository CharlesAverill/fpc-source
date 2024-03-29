{
    This file is part of the Free Pascal run time library.

    A file in Amiga system run time library.
    Copyright (c) 1998 by Nils Sjoholm
    member of the Amiga RTL development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{
    This is all triton macros translated to procedures.
    Check the tritondemos on how to use the procedures.

    Some time the compiler tell you that it can't pick the
    right overlay function, well the only one so far is TextId.
    Why I don't know, the fix is just to use a PAnsiChar if there
    is a problem (TextId(PAnsiChar('your text'#0)).

    A few fixes, overlay should work with fpc 1.0.7
    Added overlay for SetTRTag, PAnsiChar, string ,boolean and
    pointer.
    09 Jan 2003.

    Added the define use_amiga_smartlink.
    12 Jan 2003.

    Changed integr > smallint.
    11 Feb 2003.

    nils.sjoholm@mailbox.xwipnet.se
}

{$IFNDEF FPC_DOTTEDUNITS}
unit tritonmacros;
{$ENDIF FPC_DOTTEDUNITS}

interface

{$IFDEF FPC_DOTTEDUNITS}
uses Amiga.Other.Triton, Amiga.Core.Utility;
{$ELSE FPC_DOTTEDUNITS}
uses triton, utility;
{$ENDIF FPC_DOTTEDUNITS}

var
   tritontags : array[0..400] of tTagItem;
   tindex : longint;

PROCEDURE ProjectStart;
PROCEDURE EndProject;
PROCEDURE WindowTitle(t : ShortString);
PROCEDURE WindowTitle(t : PAnsiChar);
PROCEDURE ScreenTitle(t : ShortString);
PROCEDURE ScreenTitle(t : PAnsiChar);
PROCEDURE WindowID(gadid : longint);
PROCEDURE WindowFlags(f : longint);
PROCEDURE WindowPosition(pos : longint);
PROCEDURE WindowUnderscore(und : ShortString);
PROCEDURE WindowUnderscore(und : PAnsiChar);
PROCEDURE WindowDimensions(dim : pTR_Dimensions);
PROCEDURE WindowBackfillWin;
PROCEDURE WindowBackfillReq;
PROCEDURE WindowBackfillNone;
PROCEDURE WindowBackfillS;
PROCEDURE WindowBackfillSA;
PROCEDURE WindowBackfillSF;
PROCEDURE WindowBackfillSB;
PROCEDURE WindowBackfillA;
PROCEDURE WindowBackfillAF;
PROCEDURE WindowBackfillAB;
PROCEDURE WindowBackfillF;
PROCEDURE WindowBackfillFB;
PROCEDURE CustomScreen(scr : Pointer);
PROCEDURE PubScreen(scr : Pointer);
PROCEDURE PubScreenName(wname : ShortString);
PROCEDURE PubScreenName(wname : PAnsiChar);
PROCEDURE QuickHelpOn(onn : smallint);
{ Menus }
PROCEDURE BeginMenu(t : ShortString);
PROCEDURE BeginMenu(t : PAnsiChar);
PROCEDURE MenuFlags(f : longint);
PROCEDURE MenuItem(t : ShortString ;gadid : longint);
PROCEDURE MenuItem(t : PAnsiChar ;gadid : longint);
PROCEDURE MenuItemC(t : ShortString; gadid : longint);
PROCEDURE MenuItemC(t : PAnsiChar; gadid : longint);
PROCEDURE MenuItemCC(t : ShortString; gadid : longint);
PROCEDURE MenuItemCC(t : PAnsiChar; gadid : longint);
PROCEDURE BeginSub(t : ShortString);
PROCEDURE BeginSub(t : PAnsiChar);
PROCEDURE MenuItemD(t : ShortString; gadid : longint);
PROCEDURE MenuItemD(t : PAnsiChar; gadid : longint);
PROCEDURE SubItem(t : ShortString; gadid : longint);
PROCEDURE SubItem(t : PAnsiChar; gadid : longint);
PROCEDURE SubItemC(t : ShortString; gadid : longint);
PROCEDURE SubItemC(t : PAnsiChar; gadid : longint);
PROCEDURE SubItemCC(t : ShortString; gadid : longint);
PROCEDURE SubItemCC(t : PAnsiChar; gadid : longint);
PROCEDURE SubItemD(t : ShortString ;gadid : longint);
PROCEDURE SubItemD(t : PAnsiChar ;gadid : longint);
PROCEDURE ItemBarlabel;
PROCEDURE SubBarlabel;
{ Groups }
PROCEDURE HorizGroup;
PROCEDURE HorizGroupE;
PROCEDURE HorizGroupS;
PROCEDURE HorizGroupA;
PROCEDURE HorizGroupEA;
PROCEDURE HorizGroupSA;
PROCEDURE HorizGroupC;
PROCEDURE HorizGroupEC;
PROCEDURE HorizGroupSC;
PROCEDURE HorizGroupAC;
PROCEDURE HorizGroupEAC;
PROCEDURE HorizGroupSAC;
PROCEDURE VertGroup;
PROCEDURE VertGroupE;
PROCEDURE VertGroupS;
PROCEDURE VertGroupA;
PROCEDURE VertGroupEA;
PROCEDURE VertGroupSA;
PROCEDURE VertGroupC;
PROCEDURE VertGroupEC;
PROCEDURE VertGroupSC;
PROCEDURE VertGroupAC;
PROCEDURE VertGroupEAC;
PROCEDURE VertGroupSAC;
PROCEDURE EndGroup;
PROCEDURE ColumnArray;
PROCEDURE LineArray;
PROCEDURE BeginColumn;
PROCEDURE BeginLine;
PROCEDURE BeginColumnI;
PROCEDURE BeginLineI;
PROCEDURE BeginColumnE;
PROCEDURE BeginLineE;
PROCEDURE EndColumn;
PROCEDURE EndLine;
PROCEDURE EndArray;
{ DisplayObject }
PROCEDURE QuickHelp(Str : ShortString);
PROCEDURE QuickHelp(Str : PAnsiChar);
{ Space }
PROCEDURE SpaceB;
PROCEDURE Space;
PROCEDURE SpaceS;
PROCEDURE SpaceN;
{ Text }
PROCEDURE TextN(ttext : ShortString);
PROCEDURE TextN(ttext : PAnsiChar);

PROCEDURE TextH(ttext : ShortString);
PROCEDURE TextH(ttext : PAnsiChar);

PROCEDURE Text3(ttext : ShortString);
PROCEDURE Text3(ttext : PAnsiChar);
PROCEDURE TextB(ttext : ShortString);
PROCEDURE TextB(ttext : PAnsiChar);
PROCEDURE TextT(ttext : ShortString);
PROCEDURE TextT(ttext : PAnsiChar);
PROCEDURE TextID(ttext : ShortString ; gadid : longint);
PROCEDURE TextID(ttext : PAnsiChar ; gadid : longint);
PROCEDURE TextNR(t : ShortString);
PROCEDURE TextNR(t : PAnsiChar);
PROCEDURE ClippedText(t : ShortString);
PROCEDURE ClippedText(t : PAnsiChar);
PROCEDURE ClippedTextID(t : ShortString; gadid : longint);
PROCEDURE ClippedTextID(t : PAnsiChar; gadid : longint);
PROCEDURE CenteredText(ttext : ShortString);
PROCEDURE CenteredText(ttext : PAnsiChar);
PROCEDURE CenteredTextH(ttext : ShortString);
PROCEDURE CenteredTextH(ttext : PAnsiChar);
PROCEDURE CenteredText3(ttext : ShortString);
PROCEDURE CenteredText3(ttext : PAnsiChar);
PROCEDURE CenteredTextB(ttext : ShortString);
PROCEDURE CenteredTextB(ttext : PAnsiChar);
PROCEDURE CenteredTextID(ttext : ShortString ; gadid : longint);
PROCEDURE CenteredTextID(ttext : PAnsiChar ; gadid : longint);
PROCEDURE CenteredText_BS(ttext : ShortString);
PROCEDURE CenteredText_BS(ttext : PAnsiChar);
PROCEDURE TextBox(ttext : ShortString ; gadid : longint ; mwid : longint);
PROCEDURE TextBox(ttext : PAnsiChar ; gadid : longint ; mwid : longint);
PROCEDURE ClippedTextBox(ttext : ShortString ; gadid : longint);
PROCEDURE ClippedTextBox(ttext : PAnsiChar ; gadid : longint);
PROCEDURE ClippedTextBoxMW(ttext : ShortString ; gadid : longint ; mwid : longint);
PROCEDURE ClippedTextBoxMW(ttext : PAnsiChar ; gadid : longint ; mwid : longint);
PROCEDURE TextRIGHT(t : ShortString ;gadid : longint);
PROCEDURE TextRIGHT(t : PAnsiChar ;gadid : longint);
PROCEDURE IntegerS(i : longint);
PROCEDURE IntegerH(i : longint);
PROCEDURE Integer3(i : longint);
PROCEDURE IntegerB(i : longint);
PROCEDURE CenteredInteger(i : longint);
PROCEDURE CenteredIntegerH(i : longint);
PROCEDURE CenteredInteger3(i : longint);
PROCEDURE CenteredIntegerB(i : longint);
PROCEDURE IntegerBox(def,gadid,mwid : longint);
{ Button }
PROCEDURE Button(ttext : ShortString ; gadid : longint);
PROCEDURE Button(ttext : PAnsiChar ; gadid : longint);
PROCEDURE ButtonR(ttext : ShortString ; gadid : longint);
PROCEDURE ButtonR(ttext : PAnsiChar ; gadid : longint);
PROCEDURE ButtonE(ttext : ShortString ;gadid : longint);
PROCEDURE ButtonE(ttext : PAnsiChar ;gadid : longint);
PROCEDURE ButtonRE(ttext : ShortString ;gadid : longint);
PROCEDURE ButtonRE(ttext : PAnsiChar ;gadid : longint);
PROCEDURE CenteredButton(t : ShortString;i : longint);
PROCEDURE CenteredButton(t : PAnsiChar;i : longint);
PROCEDURE CenteredButtonR(t : ShortString ;i : longint);
PROCEDURE CenteredButtonR(t : PAnsiChar ;i : longint);
PROCEDURE CenteredButtonE(t : ShortString;i : longint);
PROCEDURE CenteredButtonE(t : PAnsiChar;i : longint);
PROCEDURE CenteredButtonRE(t : ShortString ;i : longint);
PROCEDURE CenteredButtonRE(t : PAnsiChar ;i : longint);
PROCEDURE EmptyButton(gadid : longint);
PROCEDURE GetFileButton(gadid : longint);
PROCEDURE GetDrawerButton(gadid : longint);
PROCEDURE GetEntryButton(gadid : longint);
PROCEDURE GetFileButtonS(s : ShortString ;gadid : longint);
PROCEDURE GetFileButtonS(s : PAnsiChar ;gadid : longint);
PROCEDURE GetDrawerButtonS(s : ShortString;gadid : longint);
PROCEDURE GetDrawerButtonS(s : PAnsiChar;gadid : longint);
PROCEDURE GetEntryButtonS(s : ShortString ;gadid : longint);
PROCEDURE GetEntryButtonS(s : PAnsiChar ;gadid : longint);
{ Line }
PROCEDURE Line(flags : longint);
PROCEDURE HorizSeparator;
PROCEDURE VertSeparator;
PROCEDURE NamedSeparator(ttext : ShortString);
PROCEDURE NamedSeparator(ttext : PAnsiChar);
PROCEDURE NamedSeparatorI(te : ShortString ;gadid : longint);
PROCEDURE NamedSeparatorI(te : PAnsiChar ;gadid : longint);
PROCEDURE NamedSeparatorN(ttext : ShortString);
PROCEDURE NamedSeparatorN(ttext : PAnsiChar);
PROCEDURE NamedSeparatorIN(te : ShortString ;gadid : longint);
PROCEDURE NamedSeparatorIN(te : PAnsiChar ;gadid : longint);
{ FrameBox }
PROCEDURE GroupBox;
PROCEDURE NamedFrameBox(t : ShortString);
PROCEDURE NamedFrameBox(t : PAnsiChar);
PROCEDURE TTextBox;
{ DropBox }
PROCEDURE DropBox(gadid : longint);
{ CheckBox gadget }
PROCEDURE CheckBox(gadid : longint);
PROCEDURE CheckBoxV(value : longint; gadid : longint);
PROCEDURE CheckBoxC(gadid : longint);
PROCEDURE CheckBoxLEFT(gadid : longint);
PROCEDURE CheckBoxCLEFT(gadid : longint);
{ String gadget }
PROCEDURE StringGadget(def : ShortString;gadid : longint);
PROCEDURE StringGadget(def : PAnsiChar;gadid : longint);
PROCEDURE StringGadgetNR(def : ShortString ;gadid : longint);
PROCEDURE StringGadgetNR(def : PAnsiChar ;gadid : longint);
PROCEDURE PasswordGadget(def : ShortString ;gadid : longint);
PROCEDURE PasswordGadget(def : PAnsiChar ;gadid : longint);
{ Cycle gadget }
PROCEDURE CycleGadget(ent : Pointer ; val,gadid : longint);
PROCEDURE MXGadget(ent : Pointer ; val,gadid : longint);
PROCEDURE MXGadgetR(ent : Pointer; val,gadid : longint);
{ Slider gadget }
PROCEDURE SliderGadget(mini,maxi,val,gadid : longint);
PROCEDURE SliderGadgetV(mini,maxi,val,gadid : longint);
{ Scroller gadget }
PROCEDURE ScrollerGadget(total,visible,val,id : longint);
PROCEDURE ScrollerGadgetV(total,visible,val,id : longint);
{ Palette gadget }
PROCEDURE PaletteGadget(val,gadid : longint);
{ Listview gadget }
PROCEDURE ListRO(ent : Pointer;gadid,top : longint);
PROCEDURE ListSel(ent : Pointer ;gadid,top : longint);
PROCEDURE ListSS(e : Pointer ;gadid,top,v : longint);
PROCEDURE ListSSM(e : Pointer ;gadid,top,v,min : longint);
PROCEDURE ListROC(ent : Pointer;gadid,top : longint);
PROCEDURE ListSelC(ent : Pointer;gadid,top : longint);
PROCEDURE ListSSC(e : Pointer;gadid,top,v : longint);
PROCEDURE ListRON(ent : Pointer ;gadid,top : longint);
PROCEDURE ListSelN(ent : Pointer;gadid,top : longint);
PROCEDURE ListSSN(e : Pointer;gadid,top,v : longint);
PROCEDURE ListROCN(ent : Pointer;gadid,top : longint);
PROCEDURE ListSelCN(ent : Pointer;gadid,top : longint);
PROCEDURE ListSSCN(e : Pointer;gadid,top,v : longint);
PROCEDURE FWListRO(ent : Pointer;gadid,top : longint);
PROCEDURE FWListSel(ent : Pointer;gadid,top : longint);
PROCEDURE FWListSS(e : Pointer;gadid,top,v : longint);
PROCEDURE FWListROC(ent : Pointer;gadid,top : longint);
PROCEDURE FWListSelC(ent : Pointer;gadid,top : longint);
PROCEDURE FWListSSC(e : Pointer;gadid,top,v : longint);
PROCEDURE FWListRON(ent : Pointer;gadid,top : longint);
PROCEDURE FWListSelN(ent : Pointer;gadid,top : longint);
PROCEDURE FWListSSN(e : Pointer;gadid,top,v : longint);
PROCEDURE FWListROCN(ent : Pointer;gadid,top : longint);
PROCEDURE FWListSelCN(ent : Pointer;gadid,top : longint);
PROCEDURE FWListSSCN(e : Pointer;gadid,top,v : longint);
{ Progress indicator }
PROCEDURE Progress(maxi,value,gadid : longint);
{ Image }
PROCEDURE BoopsiImage(img : Pointer);
PROCEDURE BoopsiImageD(img : Pointer;mw,mh : longint);
{ Attributes }
PROCEDURE ID(gadid : longint);
PROCEDURE Disabled;
PROCEDURE ObjectBackfillWin;
PROCEDURE ObjectBackfillReq;
PROCEDURE ObjectBackfillB;
PROCEDURE ObjectBackfillS;
PROCEDURE ObjectBackfillSA;
PROCEDURE ObjectBackfillSF;
PROCEDURE ObjectBackfillSB;
PROCEDURE ObjectBackfillA;
PROCEDURE ObjectBackfillAF;
PROCEDURE ObjectBackfillAB;
PROCEDURE ObjectBackfillF;
PROCEDURE ObjectBackfillFB;
{ Requester support }
PROCEDURE BeginRequester(t : ShortString; p : longint);
PROCEDURE BeginRequester(t : PAnsiChar; p : longint);
PROCEDURE BeginRequesterGads;
PROCEDURE EndRequester;
PROCEDURE SetTRTag( thetag, thedata : longint);
PROCEDURE SetTRTag( thetag : longint; thedata : ShortString);
PROCEDURE SetTRTag( thetag : longint; thedata : PAnsiChar);
PROCEDURE SetTRTag( thetag : longint; thedata : boolean);
PROCEDURE SetTRTag( thetag : longint; thedata : pointer);


IMPLEMENTATION

{$IFDEF FPC_DOTTEDUNITS}
uses Amiga.Utils.Pastoc;
{$ELSE FPC_DOTTEDUNITS}
uses pastoc;
{$ENDIF FPC_DOTTEDUNITS}

PROCEDURE ProjectStart;
BEGIN
    tindex := 0;
END;

PROCEDURE EndProject;
BEGIN
    tritontags[tindex].ti_Tag := TAG_DONE;
END;

PROCEDURE WindowTitle(t : ShortString);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_Title;
    tritontags[tindex].ti_Data := longint(pas2c(t));
    Inc(tindex);
END;

PROCEDURE WindowTitle(t : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_Title;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
END;

PROCEDURE ScreenTitle(t : ShortString);
BEGIN
    ScreenTitle(pas2c(t));
END;

PROCEDURE ScreenTitle(t : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_ScreenTitle;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
END;

PROCEDURE WindowID(gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE WindowFlags(f : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_Flags;
    tritontags[tindex].ti_Data := longint(f);
    Inc(tindex);
END;

PROCEDURE WindowPosition(pos : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_Position;
    tritontags[tindex].ti_Data := longint(pos);
    Inc(tindex);
END;

PROCEDURE WindowUnderscore(und : ShortString);
BEGIN
    WindowUnderscore(pas2c(und));
END;

PROCEDURE WindowUnderscore(und : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_Underscore;
    tritontags[tindex].ti_Data := longint(und);
    Inc(tindex);
END;

PROCEDURE WindowDimensions(dim : pTR_Dimensions);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_Dimensions;
    tritontags[tindex].ti_Data := longint(dim);
    Inc(tindex);
END;

PROCEDURE WindowBackfillWin;
BEGIN
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_WINDOWBACK;
    Inc(tindex);
END;

PROCEDURE WindowBackfillReq;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_REQUESTERBACK;
    Inc(tindex);
END;

PROCEDURE WindowBackfillNone;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_NONE;
    Inc(tindex);
END;

PROCEDURE WindowBackfillS;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHINE;
    Inc(tindex);
END;

PROCEDURE WindowBackfillSA;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHINE_SHADOW;
    Inc(tindex);
END;

PROCEDURE WindowBackfillSF;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHINE_FILL;
    Inc(tindex);
END;

PROCEDURE WindowBackfillSB;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHINE_BACKGROUND;
    Inc(tindex);
END;

PROCEDURE WindowBackfillA;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHADOW;
    Inc(tindex);
END;

PROCEDURE WindowBackfillAF;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHADOW_FILL;
    Inc(tindex);
END;

PROCEDURE WindowBackfillAB;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHADOW_BACKGROUND;
    Inc(tindex);
END;

PROCEDURE WindowBackfillF;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_FILL;
    Inc(tindex);
END;

PROCEDURE WindowBackfillFB;
begin
    tritontags[tindex].ti_Tag := TRWI_Backfill;
    tritontags[tindex].ti_Data := TRBF_FILL_BACKGROUND;
    Inc(tindex);
END;

PROCEDURE CustomScreen(scr : Pointer);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_CustomScreen;
    tritontags[tindex].ti_Data := longint(scr);
    Inc(tindex);
END;

PROCEDURE PubScreen(scr : Pointer);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_PubScreen;
    tritontags[tindex].ti_Data := longint(scr);
END;

PROCEDURE PubScreenName(wname : ShortString);
BEGIN
    PubScreenName(pas2c(wname));
END;

PROCEDURE PubScreenName(wname : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_PubScreenName;
    tritontags[tindex].ti_Data := longint(wname);
    Inc(tindex);
END;

PROCEDURE QuickHelpOn(onn : smallint);
BEGIN
    tritontags[tindex].ti_Tag := TRWI_QuickHelp;
    tritontags[tindex].ti_Data := longint(onn);
    Inc(tindex);
END;

{ Menus }
PROCEDURE BeginMenu(t : ShortString);
BEGIN
    BeginMenu(pas2c(t));
END;

PROCEDURE BeginMenu(t : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Title;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
END;

PROCEDURE MenuFlags(f : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Flags;
    tritontags[tindex].ti_Data := longint(f);
    Inc(tindex);
END;

PROCEDURE MenuItem(t : ShortString ;gadid : longint);
BEGIN
    MenuItem(pas2c(t),gadid);
END;

PROCEDURE MenuItem(t : PAnsiChar ;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Item;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE MenuItemC(t : ShortString; gadid : longint);
BEGIN
    MenuItemC(pas2c(t),gadid);
END;

PROCEDURE MenuItemC(t : PAnsiChar; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Item;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRMN_Flags;
    tritontags[tindex].ti_Data := TRMF_CHECKIT;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE MenuItemCC(t : ShortString; gadid : longint);
BEGIN
    MenuItemCC(pas2c(t),gadid);
END;

PROCEDURE MenuItemCC(t : PAnsiChar; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Item;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRMN_Flags;
    tritontags[tindex].ti_Data := TRMF_CHECKED;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE BeginSub(t : ShortString);
BEGIN
    BeginSub(pas2c(t));
END;

PROCEDURE BeginSub(t : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Item;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
END;

PROCEDURE MenuItemD(t : ShortString; gadid : longint);
BEGIN
    MenuItemD(pas2c(t),gadid);
END;

PROCEDURE MenuItemD(t : PAnsiChar; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Item;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    MenuFlags(TRMF_DISABLED);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE SubItem(t : ShortString; gadid : longint);
BEGIN
    SubItem(pas2c(t),gadid);
END;

PROCEDURE SubItem(t : PAnsiChar; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Sub;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE SubItemC(t : ShortString; gadid : longint);
BEGIN
    SubItemC(pas2c(t),gadid);
END;

PROCEDURE SubItemC(t : PAnsiChar; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Sub;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRMN_Flags;
    tritontags[tindex].ti_Data := TRMF_CHECKIT;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE SubItemCC(t : ShortString; gadid : longint);
BEGIN
    SubItemCC(pas2c(t),gadid);
END;

PROCEDURE SubItemCC(t : PAnsiChar; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Sub;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRMN_Flags;
    tritontags[tindex].ti_Data := TRMF_CHECKED;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE SubItemD(t : ShortString ;gadid : longint);
BEGIN
    SubItemD(pas2c(t),gadid);
END;

PROCEDURE SubItemD(t : PAnsiChar ;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRMN_Sub;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    MenuFlags(TRMF_DISABLED);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE ItemBarlabel;
begin
    tritontags[tindex].ti_Tag := TRMN_Item;
    tritontags[tindex].ti_Data := TRMN_BARLABEL;
    Inc(tindex);
END;

PROCEDURE SubBarlabel;
begin
    tritontags[tindex].ti_Tag := TRMN_Sub;
    tritontags[tindex].ti_Data := TRMN_BARLABEL;
    Inc(tindex);
END;

{ Groups }
PROCEDURE HorizGroup;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
END;

PROCEDURE HorizGroupE;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := TRGR_EQUALSHARE;
    Inc(tindex);
END;

PROCEDURE HorizGroupS;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := TRGR_PROPSPACES;
    Inc(tindex);
END;

PROCEDURE HorizGroupA;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := TRGR_ALIGN;
    Inc(tindex);
END;

PROCEDURE HorizGroupEA;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_EQUALSHARE OR TRGR_ALIGN);
    Inc(tindex);
END;

PROCEDURE HorizGroupSA;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_PROPSPACES OR TRGR_ALIGN);
    Inc(tindex);
END;

PROCEDURE HorizGroupC;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := TRGR_CENTER;
    Inc(tindex);
END;

PROCEDURE HorizGroupEC;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_EQUALSHARE OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE HorizGroupSC;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_PROPSPACES OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE HorizGroupAC;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE HorizGroupEAC;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE HorizGroupSAC;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE VertGroup;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
END;

PROCEDURE VertGroupE;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := TRGR_EQUALSHARE;
    Inc(tindex);
END;

PROCEDURE VertGroupS;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := TRGR_PROPSPACES;
    Inc(tindex);
END;

PROCEDURE VertGroupA;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := TRGR_ALIGN;
    Inc(tindex);
END;

PROCEDURE VertGroupEA;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_EQUALSHARE OR TRGR_ALIGN);
    Inc(tindex);
END;

PROCEDURE VertGroupSA;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_PROPSPACES OR TRGR_ALIGN);
    Inc(tindex);
END;

PROCEDURE VertGroupC;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := TRGR_CENTER;
    Inc(tindex);
END;

PROCEDURE VertGroupEC;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_EQUALSHARE OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE VertGroupSC;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_PROPSPACES OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE VertGroupAC;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE VertGroupEAC;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE VertGroupSAC;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE EndGroup;
begin
    tritontags[tindex].ti_Tag := TRGR_End;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
END;

PROCEDURE ColumnArray;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_ARRAY OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE LineArray;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_ARRAY OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE BeginColumn;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE BeginLine;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE BeginColumnI;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER OR
TRGR_INDEP);
    Inc(tindex);
END;

PROCEDURE BeginLineI;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER OR
TRGR_INDEP);
    Inc(tindex);
END;

PROCEDURE BeginColumnE;
begin
    tritontags[tindex].ti_Tag := TRGR_Vert;
    tritontags[tindex].ti_Data := (TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE BeginLineE;
begin
    tritontags[tindex].ti_Tag := TRGR_Horiz;
    tritontags[tindex].ti_Data := (TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER);
    Inc(tindex);
END;

PROCEDURE EndColumn;
BEGIN
    EndGroup;
END;

PROCEDURE EndLine;
BEGIN
    EndGroup;
END;

PROCEDURE EndArray;
BEGIN
    EndGroup;
END;

{ DisplayObject }
PROCEDURE QuickHelp(Str : ShortString);
BEGIN
    QuickHelp(pas2c(Str));
END;

PROCEDURE QuickHelp(Str : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TRDO_QuickHelpString;
    tritontags[tindex].ti_Data := longint(Str);
    Inc(tindex);
END;

{ Space }
PROCEDURE SpaceB;
begin
    tritontags[tindex].ti_Tag := TROB_Space;
    tritontags[tindex].ti_Data := TRST_BIG;
    Inc(tindex);
END;

PROCEDURE Space;
begin
    tritontags[tindex].ti_Tag := TROB_Space;
    tritontags[tindex].ti_Data := TRST_NORMAL;
    Inc(tindex);
END;

PROCEDURE SpaceS;
begin
    tritontags[tindex].ti_Tag := TROB_Space;
    tritontags[tindex].ti_Data := TRST_SMALL;
    Inc(tindex);
END;

PROCEDURE SpaceN;
begin
    tritontags[tindex].ti_Tag := TROB_Space;
    tritontags[tindex].ti_Data := TRST_NONE;
    Inc(tindex);
END;

{ Text }
PROCEDURE TextN(ttext : ShortString);
BEGIN
    TextN(pas2c(ttext));
END;

PROCEDURE TextN(ttext : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
END;


PROCEDURE TextH(ttext : ShortString);
BEGIN
    TextH(pas2c(ttext));
END;

PROCEDURE TextH(ttext : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRTX_HIGHLIGHT;
    Inc(tindex);
END;


PROCEDURE Text3(ttext : ShortString);
BEGIN
    Text3(pas2c(ttext));
END;

PROCEDURE Text3(ttext : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRTX_3D;
    Inc(tindex);
END;

PROCEDURE TextB(ttext : ShortString);
BEGIN
    TextB(pas2c(ttext));
END;

PROCEDURE TextB(ttext : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRTX_BOLD;
    Inc(tindex);
END;

PROCEDURE TextT(ttext : ShortString);
BEGIN
    TextT(pas2c(ttext));
END;

PROCEDURE TextT(ttext : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRTX_TITLE;
    Inc(tindex);
END;

PROCEDURE TextID(ttext : ShortString ; gadid : longint);
BEGIN
    TextID(pas2c(ttext),gadid);
END;

PROCEDURE TextID(ttext : PAnsiChar ; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE TextNR(t : ShortString);
BEGIN
    TextNR(pas2c(t));
END;

PROCEDURE TextNR(t : PAnsiChar);
BEGIN
    TextN(t);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TROF_RIGHTALIGN;
    Inc(tindex);
END;

PROCEDURE ClippedText(t : ShortString);
BEGIN
    ClippedText(pas2c(t));
END;

PROCEDURE ClippedText(t : PAnsiChar);
BEGIN
    TextN(t);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRTX_CLIPPED OR TRTX_NOUNDERSCORE);
    Inc(tindex);
END;

PROCEDURE ClippedTextID(t : ShortString; gadid : longint);
BEGIN
    ClippedTextID(pas2c(t),gadid);
END;

PROCEDURE ClippedTextID(t : PAnsiChar; gadid : longint);
BEGIN
    TextN(t);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRTX_CLIPPED OR TRTX_NOUNDERSCORE);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE CenteredText(ttext : ShortString);
BEGIN
    CenteredText(pas2c(ttext));
END;

PROCEDURE CenteredText(ttext : PAnsiChar);
BEGIN
    HorizGroupSC; Space; TextN(ttext);Space; EndGroup;
END;

PROCEDURE CenteredTextH(ttext : ShortString);
BEGIN
    CenteredTextH(pas2c(ttext));
END;

PROCEDURE CenteredTextH(ttext : PAnsiChar);
BEGIN
    HorizGroupSC; Space; TextH(ttext); Space; EndGroup;
END;

PROCEDURE CenteredText3(ttext : ShortString);
BEGIN
    CenteredText3(pas2c(ttext));
END;

PROCEDURE CenteredText3(ttext : PAnsiChar);
BEGIN
    HorizGroupSC; Space; Text3(ttext); Space; EndGroup;
END;

PROCEDURE CenteredTextB(ttext : ShortString);
BEGIN
    CenteredTextB(pas2c(ttext));
END;

PROCEDURE CenteredTextB(ttext : PAnsiChar);
BEGIN
    HorizGroupSC; Space; TextB(ttext); Space; EndGroup;
END;

PROCEDURE CenteredTextID(ttext : ShortString ; gadid : longint);
BEGIN
    CenteredTextID(pas2c(ttext),gadid);
END;

PROCEDURE CenteredTextID(ttext : PAnsiChar ; gadid : longint);
BEGIN
    HorizGroupSC; Space; TextID(ttext,gadid); Space; EndGroup;
END;

PROCEDURE CenteredText_BS(ttext : ShortString);
BEGIN
    CenteredText_BS(pas2c(ttext));
END;

PROCEDURE CenteredText_BS(ttext : PAnsiChar);
BEGIN
    HorizGroupSC; SpaceB; TextN(ttext); SpaceB; EndGroup;
END;

PROCEDURE TextBox(ttext : ShortString ; gadid : longint ; mwid : longint);
BEGIN
    TextBox(pas2c(ttext),gadid,mwid);
END;

PROCEDURE TextBox(ttext : PAnsiChar ; gadid : longint ; mwid : longint);
BEGIN
    TTextBox; ObjectBackfillB; VertGroup; SpaceS;
    HorizGroupSC; Space; TextN(ttext);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_MinWidth;
    tritontags[tindex].ti_Data := longint(mwid);
    Inc(tindex);
    Space; EndGroup; SpaceS; EndGroup;
END;

PROCEDURE ClippedTextBox(ttext : ShortString ; gadid : longint);
BEGIN
    ClippedTextBox(pas2c(ttext),gadid);
END;

PROCEDURE ClippedTextBox(ttext : PAnsiChar ; gadid : longint);
BEGIN
    TTextBox; ObjectBackfillB; VertGroupAC; SpaceS; HorizGroupAC; Space;
    ClippedTextID(ttext,gadid); Space; EndGroup; SpaceS; EndGroup;
END;

PROCEDURE ClippedTextBoxMW(ttext : ShortString ; gadid : longint ; mwid : longint);
BEGIN
    ClippedTextBoxMW(pas2c(ttext),gadid,mwid);
END;

PROCEDURE ClippedTextBoxMW(ttext : PAnsiChar ; gadid : longint ; mwid : longint);
BEGIN
    TTextBox; ObjectBackfillB; VertGroupAC; SpaceS; HorizGroupAC; Space;
    ClippedTextID(ttext,gadid);
    tritontags[tindex].ti_Tag := TRAT_MinWidth;
    tritontags[tindex].ti_Data := longint(mwid);
    Inc(tindex);
    Space; EndGroup; SpaceS; EndGroup;
END;

PROCEDURE TextRIGHT(t : ShortString ;gadid : longint);
BEGIN
    TextRIGHT(pas2c(t),gadid);
END;

PROCEDURE TextRIGHT(t : PAnsiChar ;gadid : longint);
BEGIN
    HorizGroupS; Space; TextN(t); ID(gadid); EndGroup;
END;

PROCEDURE IntegerS(i : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(i);
    Inc(tindex);
END;

PROCEDURE IntegerH(i : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(i);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRTX_HIGHLIGHT;
    Inc(tindex);
END;

PROCEDURE Integer3(i : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(i);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRTX_3D;
    Inc(tindex);
END;

PROCEDURE IntegerB(i : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Text;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(i);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRTX_BOLD;
    Inc(tindex);
END;

PROCEDURE CenteredInteger(i : longint);
BEGIN
    HorizGroupSC; Space; IntegerS(i); Space; EndGroup;
END;

PROCEDURE CenteredIntegerH(i : longint);
BEGIN
    HorizGroupSC; Space; IntegerH(i); Space; EndGroup;
END;

PROCEDURE CenteredInteger3(i : longint);
BEGIN
    HorizGroupSC; Space; Integer3(i); Space; EndGroup;
END;

PROCEDURE CenteredIntegerB(i : longint);
BEGIN
    HorizGroupSC; Space; IntegerB(i); Space; EndGroup;
END;

PROCEDURE IntegerBox(def,gadid,mwid : longint);
BEGIN
    GroupBox; ObjectBackfillB; VertGroup; SpaceS; HorizGroupSC;
    Space; IntegerS(def);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_MinWidth;
    tritontags[tindex].ti_Data := longint(mwid);
    Inc(tindex);
    Space; EndGroup; SpaceS; EndGroup;
END;

{ Button }
PROCEDURE Button(ttext : ShortString ; gadid : longint);
BEGIN
    Button(pas2c(ttext),gadid);
END;

PROCEDURE Button(ttext : PAnsiChar ; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE ButtonR(ttext : ShortString ; gadid : longint);
BEGIN
    ButtonR(pas2c(ttext),gadid);
END;

PROCEDURE ButtonR(ttext : PAnsiChar ; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_RETURNOK;
    Inc(tindex);
END;

PROCEDURE ButtonE(ttext : ShortString ;gadid : longint);
BEGIN
    ButtonE(pas2c(ttext),gadid);
END;

PROCEDURE ButtonE(ttext : PAnsiChar ;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_ESCOK;
    Inc(tindex);
END;

PROCEDURE ButtonRE(ttext : ShortString ;gadid : longint);
BEGIN
    ButtonRE(pas2c(ttext),gadid);
END;

PROCEDURE ButtonRE(ttext : PAnsiChar ;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(ttext);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRBU_RETURNOK OR TRBU_ESCOK);
    Inc(tindex);
END;

PROCEDURE CenteredButton(t : ShortString;i : longint);
BEGIN
    CenteredButton(pas2c(t),i);
END;

PROCEDURE CenteredButton(t : PAnsiChar;i : longint);
BEGIN
    HorizGroupSC; Space;
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(i);
    Inc(tindex);
    Space; EndGroup;
END;

PROCEDURE CenteredButtonR(t : ShortString ;i : longint);
BEGIN
    CenteredButtonR(pas2c(t),i);
END;

PROCEDURE CenteredButtonR(t : PAnsiChar ;i : longint);
BEGIN
    HorizGroupSC; Space;
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_RETURNOK;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(i);
    Inc(tindex);
    Space; EndGroup;
END;

PROCEDURE CenteredButtonE(t : ShortString;i : longint);
BEGIN
    CenteredButtonE(pas2c(t),i);
END;

PROCEDURE CenteredButtonE(t : PAnsiChar;i : longint);
BEGIN
    HorizGroupSC; Space;
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_ESCOK;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(i);
    Inc(tindex);
    Space; EndGroup;
END;

PROCEDURE CenteredButtonRE(t : ShortString ;i : longint);
BEGIN
    CenteredButtonRE(pas2c(t),i);
END;

PROCEDURE CenteredButtonRE(t : PAnsiChar ;i : longint);
BEGIN
    HorizGroupSC; Space;
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRBU_RETURNOK OR TRBU_ESCOK);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(i);
    Inc(tindex);
    Space; EndGroup;
END;

PROCEDURE EmptyButton(gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(pas2c(''));
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE GetFileButton(gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := TRBT_GETFILE;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(pas2c(''));
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_YRESIZE;
    Inc(tindex);
END;

PROCEDURE GetDrawerButton(gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := TRBT_GETDRAWER;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(pas2c(''));
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_YRESIZE;
    Inc(tindex);
END;

PROCEDURE GetEntryButton(gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := TRBT_GETENTRY;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(pas2c(''));
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_YRESIZE;
    Inc(tindex);
END;

PROCEDURE GetFileButtonS(s : ShortString ;gadid : longint);
BEGIN
    GetFileButtonS(pas2c(s),gadid);
END;

PROCEDURE GetFileButtonS(s : PAnsiChar ;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := TRBT_GETFILE;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(s);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_YRESIZE;
    Inc(tindex);
END;

PROCEDURE GetDrawerButtonS(s : ShortString;gadid : longint);
BEGIN
    GetDrawerButtonS(pas2c(s),gadid);
END;

PROCEDURE GetDrawerButtonS(s : PAnsiChar;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := TRBT_GETDRAWER;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(s);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_YRESIZE;
    Inc(tindex);
END;

PROCEDURE GetEntryButtonS(s : ShortString ;gadid : longint);
BEGIN
    GetEntryButtonS(pas2c(s),gadid);
END;

PROCEDURE GetEntryButtonS(s : PAnsiChar ;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Button;
    tritontags[tindex].ti_Data := TRBT_GETENTRY;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(s);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRBU_YRESIZE;
    Inc(tindex);
END;

{ Line }
PROCEDURE Line(flags : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Line;
    tritontags[tindex].ti_Data := longint(flags);
    Inc(tindex);
END;

PROCEDURE HorizSeparator;
BEGIN
    HorizGroupEC; Space; Line(TROF_HORIZ); Space; EndGroup;
end;

PROCEDURE VertSeparator;
BEGIN
    VertGroupEC; Space; Line(TROF_VERT); Space; EndGroup;
end;

PROCEDURE NamedSeparator(ttext : ShortString);
BEGIN
    NamedSeparator(pas2c(ttext));
END;

PROCEDURE NamedSeparator(ttext : PAnsiChar);
BEGIN
    HorizGroupEC; Space; Line(TROF_HORIZ); Space; TextT(ttext);
    Space; Line(TROF_HORIZ); Space; EndGroup;
END;

PROCEDURE NamedSeparatorI(te : ShortString ;gadid : longint);
BEGIN
    NamedSeparatorI(pas2c(te),gadid);
END;

PROCEDURE NamedSeparatorI(te : PAnsiChar ;gadid : longint);
BEGIN
    HorizGroupEC; Space; Line(TROF_HORIZ); Space; TextT(te);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    Space; Line(TROF_HORIZ); Space; EndGroup;
END;

PROCEDURE NamedSeparatorN(ttext : ShortString);
BEGIN
    NamedSeparator(pas2c(ttext));
END;

PROCEDURE NamedSeparatorN(ttext : PAnsiChar);
BEGIN
    HorizGroupEC; Line(TROF_HORIZ); Space; TextT(ttext); Space; Line(TROF_HORIZ);
EndGroup;
END;

PROCEDURE NamedSeparatorIN(te : ShortString ;gadid : longint);
BEGIN
    NamedSeparatorIN(pas2c(te),gadid);
END;

PROCEDURE NamedSeparatorIN(te : PAnsiChar ;gadid : longint);
BEGIN
    HorizGroupEC; Line(TROF_HORIZ); Space; TextT(te);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    Space; Line(TROF_HORIZ); EndGroup;
END;

{ FrameBox }
PROCEDURE GroupBox;
begin
    tritontags[tindex].ti_Tag := TROB_FrameBox;
    tritontags[tindex].ti_Data := TRFB_GROUPING;
    Inc(tindex);
END;

PROCEDURE NamedFrameBox(t : ShortString);
BEGIN
    NamedFrameBox(pas2c(t));
END;

PROCEDURE NamedFrameBox(t : PAnsiChar);
BEGIN
    tritontags[tindex].ti_Tag := TROB_FrameBox;
    tritontags[tindex].ti_Data := TRFB_FRAMING;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Text;
    tritontags[tindex].ti_Data := longint(t);
    Inc(tindex);
END;

PROCEDURE TTextBox;
begin
    tritontags[tindex].ti_Tag := TROB_FrameBox;
    tritontags[tindex].ti_Data := TRFB_TEXT;
    Inc(tindex);
END;

{ DropBox }
PROCEDURE DropBox(gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_DropBox;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

{ CheckBox gadget }
PROCEDURE CheckBox(gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_CheckBox;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE CheckBoxV(value : longint; gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_CheckBox;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(value);
    Inc(tindex);
END;

PROCEDURE CheckBoxC(gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_CheckBox;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(1);
    Inc(tindex);
END;

PROCEDURE CheckBoxLEFT(gadid : longint);
BEGIN
    HorizGroupS; CheckBox(gadid); Space; EndGroup;
END;

PROCEDURE CheckBoxCLEFT(gadid : longint);
BEGIN
    HorizGroupS; CheckBoxC(gadid); Space; EndGroup;
END;

{ String gadget }
PROCEDURE StringGadget(def : ShortString;gadid : longint);
BEGIN
    StringGadget(pas2c(def),gadid);
END;

PROCEDURE StringGadget(def : PAnsiChar;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_String;
    tritontags[tindex].ti_Data := longint(def);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE StringGadgetNR(def : ShortString ;gadid : longint);
BEGIN
    StringGadgetNR(pas2c(def),gadid);
END;

PROCEDURE StringGadgetNR(def : PAnsiChar ;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_String;
    tritontags[tindex].ti_Data := longint(def);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRST_NORETURNBROADCAST;
    Inc(tindex);
END;

PROCEDURE PasswordGadget(def : ShortString ;gadid : longint);
BEGIN
    PassWordGadget(pas2c(def),gadid);
END;

PROCEDURE PasswordGadget(def : PAnsiChar ;gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_String;
    tritontags[tindex].ti_Data := longint(def);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRST_INVISIBLE;
    Inc(tindex);
END;

{ Cycle gadget }
PROCEDURE CycleGadget(ent : Pointer ; val,gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Cycle;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(val);
    Inc(tindex);
END;

PROCEDURE MXGadget(ent : Pointer ; val,gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Cycle;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(val);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRCY_MX;
    Inc(tindex);
END;

PROCEDURE MXGadgetR(ent : Pointer; val,gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Cycle;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(val);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRCY_MX OR TRCY_RIGHTLABELS);
    Inc(tindex);
END;

{ Slider gadget }
PROCEDURE SliderGadget(mini,maxi,val,gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Slider;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRSL_Min;
    tritontags[tindex].ti_Data := longint(mini);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRSL_Max;
    tritontags[tindex].ti_Data := longint(maxi);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(val);
    Inc(tindex);
END;

PROCEDURE SliderGadgetV(mini,maxi,val,gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Slider;
    tritontags[tindex].ti_Data := TROF_VERT;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRSL_Min;
    tritontags[tindex].ti_Data := longint(mini);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRSL_Max;
    tritontags[tindex].ti_Data := longint(maxi);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(val);
    Inc(tindex);
END;

{ Scroller gadget }
PROCEDURE ScrollerGadget(total,visible,val,id : longint);
begin
    tritontags[tindex].ti_Tag := TROB_Scroller;
    tritontags[tindex].ti_Data := TROF_HORIZ;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRSC_Total;
    tritontags[tindex].ti_Data := longint(total);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRSC_Visible;
    tritontags[tindex].ti_Data := longint(visible);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(id);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(val);
    Inc(tindex);
end;

PROCEDURE ScrollerGadgetV(total,visible,val,id : longint);
begin
    tritontags[tindex].ti_Tag := TROB_Scroller;
    tritontags[tindex].ti_Data := TROF_VERT;
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRSC_Total;
    tritontags[tindex].ti_Data := longint(total);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRSC_Visible;
    tritontags[tindex].ti_Data := longint(visible);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(id);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(val);
    Inc(tindex);
end;

{ Palette gadget }
PROCEDURE PaletteGadget(val,gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Palette;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(val);
    Inc(tindex);
END;

{ Listview gadget }
PROCEDURE ListRO(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_READONLY);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListSel(ent : Pointer ;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_SELECT);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListSS(e : Pointer ;gadid,top,v : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(e);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_SHOWSELECTED);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(v);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListSSM(e : Pointer ;gadid,top,v,min : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(e);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_SHOWSELECTED);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(v);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_MinWidth;
    tritontags[tindex].ti_Data := longint(min);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListROC(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_READONLY OR TRLV_NOCURSORKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListSelC(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_SELECT OR TRLV_NOCURSORKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListSSC(e : Pointer;gadid,top,v : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(e);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_SHOWSELECTED OR
TRLV_NOCURSORKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(v);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListRON(ent : Pointer ;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_READONLY OR TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListSelN(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_SELECT OR TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListSSN(e : Pointer;gadid,top,v : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(e);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_SHOWSELECTED OR
TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(v);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListROCN(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_READONLY OR TRLV_NOCURSORKEYS OR
TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListSelCN(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_SELECT OR TRLV_NOCURSORKEYS OR
TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE ListSSCN(e : Pointer;gadid,top,v : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(e);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_SHOWSELECTED OR
TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(v);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListRO(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_READONLY);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListSel(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SELECT);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListSS(e : Pointer;gadid,top,v : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(e);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SHOWSELECTED);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(v);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListROC(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_READONLY OR
TRLV_NOCURSORKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListSelC(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SELECT OR
TRLV_NOCURSORKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListSSC(e : Pointer;gadid,top,v : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(e);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SHOWSELECTED OR
TRLV_NOCURSORKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(v);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListRON(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_READONLY OR
TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListSelN(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SELECT OR
TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListSSN(e : Pointer;gadid,top,v : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(e);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SHOWSELECTED OR
TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(v);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListROCN(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_READONLY OR
TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListSelCN(ent : Pointer;gadid,top : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(ent);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SELECT OR
TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(0);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

PROCEDURE FWListSSCN(e : Pointer;gadid,top,v : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Listview;
    tritontags[tindex].ti_Data := longint(e);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := (TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SHOWSELECTED OR
TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(v);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRLV_Top;
    tritontags[tindex].ti_Data := longint(top);
    Inc(tindex);
END;

{ Progress indicator }
PROCEDURE Progress(maxi,value,gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Progress;
    tritontags[tindex].ti_Data := longint(maxi);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Value;
    tritontags[tindex].ti_Data := longint(value);
    Inc(tindex);
END;

{ Image }
PROCEDURE BoopsiImage(img : Pointer);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Image;
    tritontags[tindex].ti_Data := longint(img);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRIM_BOOPSI;
    Inc(tindex);
END;

PROCEDURE BoopsiImageD(img : Pointer;mw,mh : longint);
BEGIN
    tritontags[tindex].ti_Tag := TROB_Image;
    tritontags[tindex].ti_Data := longint(img);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_MinWidth;
    tritontags[tindex].ti_Data := longint(mw);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_MinHeight;
    tritontags[tindex].ti_Data := longint(mh);
    Inc(tindex);
    tritontags[tindex].ti_Tag := TRAT_Flags;
    tritontags[tindex].ti_Data := TRIM_BOOPSI;
    Inc(tindex);
END;

{ Attributes }
PROCEDURE ID(gadid : longint);
BEGIN
    tritontags[tindex].ti_Tag := TRAT_ID;
    tritontags[tindex].ti_Data := longint(gadid);
    Inc(tindex);
END;

PROCEDURE Disabled;
begin
    tritontags[tindex].ti_Tag := TRAT_Disabled;
    tritontags[tindex].ti_Data := longint(1);
    Inc(tindex);
END;

PROCEDURE ObjectBackfillWin;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_WINDOWBACK;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillReq;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_REQUESTERBACK;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillB;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_NONE;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillS;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHINE;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillSA;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHINE_SHADOW;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillSF;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHINE_FILL;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillSB;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHINE_BACKGROUND;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillA;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHADOW;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillAF;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHADOW_FILL;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillAB;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_SHADOW_BACKGROUND;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillF;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_FILL;
    Inc(tindex);
END;

PROCEDURE ObjectBackfillFB;
begin
    tritontags[tindex].ti_Tag := TRAT_Backfill;
    tritontags[tindex].ti_Data := TRBF_FILL_BACKGROUND;
    Inc(tindex);
END;

{ Requester support }
PROCEDURE BeginRequester(t : ShortString; p : longint);
BEGIN
    BeginRequester(pas2c(t),p);
END;

PROCEDURE BeginRequester(t : PAnsiChar; p : longint);
BEGIN
    WindowTitle(t);WindowPosition(p);WindowBackfillReq;
    WindowFlags(TRWF_NOZIPGADGET OR TRWF_NOSIZEGADGET OR TRWF_NOCLOSEGADGET OR
TRWF_NODELZIP OR TRWF_NOESCCLOSE);
    VertGroupA; Space; HorizGroupA; Space; GroupBox; ObjectBackfillB;
END;

PROCEDURE BeginRequesterGads;
BEGIN
    Space; EndGroup; Space;
END;

PROCEDURE EndRequester;
BEGIN
    Space; EndGroup; EndProject;
END;

PROCEDURE SetTRTag( thetag, thedata : longint);
begin
    tritontags[tindex].ti_Tag := thetag;
    tritontags[tindex].ti_Data := longint(thedata);
    Inc(tindex);
end;

PROCEDURE SetTRTag( thetag : longint; thedata : ShortString);
begin
    tritontags[tindex].ti_Tag := thetag;
    tritontags[tindex].ti_Data := longint(pas2c(thedata));
    Inc(tindex);
end;
PROCEDURE SetTRTag( thetag : longint; thedata : PAnsiChar);
begin
    tritontags[tindex].ti_Tag := thetag;
    tritontags[tindex].ti_Data := longint(thedata);
    Inc(tindex);
end;
PROCEDURE SetTRTag( thetag : longint; thedata : boolean);
begin
    tritontags[tindex].ti_Tag := thetag;
    tritontags[tindex].ti_Data := longint(byte(thedata));
    Inc(tindex);
end;

PROCEDURE SetTRTag( thetag : longint; thedata : pointer);
begin
    tritontags[tindex].ti_Tag := thetag;
    tritontags[tindex].ti_Data := longint(thedata);
    Inc(tindex);
end;

end.
