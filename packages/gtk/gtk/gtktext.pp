{
   $Id$
}

{****************************************************************************
                                 Interface
****************************************************************************}

{$ifdef read_interface}

  type
     PGtkTextFont = pointer;

     PGtkPropertyMark = ^TGtkPropertyMark;
     TGtkPropertyMark = record
          theproperty : PGList;
          theoffset : guint;
          theindex : guint;
       end;

     PGtkText = ^TGtkText;
     TGtkText = record
          editable : TGtkEditable;
          text_area : PGdkWindow;
          hadj : PGtkAdjustment;
          vadj : PGtkAdjustment;
          gc : PGdkGC;
          line_wrap_bitmap : PGdkPixmap;
          line_arrow_bitmap : PGdkPixmap;
          text : record
              case longint of
                 0 : ( wc : PGdkWChar );
                 1 : ( ch : Pguchar );
              end;
          text_len : guint;
          gap_position : guint;
          gap_size : guint;
          text_end : guint;
          line_start_cache : PGList;
          first_line_start_index : guint;
          first_cut_pixels : guint;
          first_onscreen_hor_pixel : guint;
          first_onscreen_ver_pixel : guint;
          flag0 : {$ifdef win32}longint{$else}word{$endif};
          freeze_count : guint;
          text_properties : PGList;
          text_properties_end : PGList;
          point : TGtkPropertyMark;
          scratch_buffer : record
              case longint of
                 0 : ( wc : PGdkWChar );
                 1 : ( ch : Pguchar );
              end;
          scratch_buffer_len : guint;
          last_ver_value : gint;
          cursor_pos_x : gint;
          cursor_pos_y : gint;
          cursor_mark : TGtkPropertyMark;
          cursor_char : TGdkWChar;
          cursor_char_offset : gchar;
          cursor_virtual_x : gint;
          cursor_drawn_level : gint;
          current_line : PGList;
          tab_stops : PGList;
          default_tab_width : gint;
          current_font : PGtkTextFont;
          timer : gint;
          button : guint;
          bg_gc : PGdkGC;
       end;

  const
     bm_TGtkText_line_wrap = $1;
     bp_TGtkText_line_wrap = 0;
     bm_TGtkText_word_wrap = $2;
     bp_TGtkText_word_wrap = 1;
     bm_TGtkText_use_wchar = $4;
     bp_TGtkText_use_wchar = 2;
function  line_wrap(var a : TGtkText) : guint;
procedure set_line_wrap(var a : TGtkText; __line_wrap : guint);
function  word_wrap(var a : TGtkText) : guint;
procedure set_word_wrap(var a : TGtkText; __word_wrap : guint);
function  use_wchar(var a : TGtkText) : guint;
procedure set_use_wchar(var a : TGtkText; __use_wchar : guint);

  type
     PGtkTextClass = ^TGtkTextClass;
     TGtkTextClass = record
          parent_class : TGtkEditableClass;
          set_scroll_adjustments : procedure (text:PGtkText; hadjustment:PGtkAdjustment; vadjustment:PGtkAdjustment);cdecl;
       end;

Type
  GTK_TEXT=PGtkText;
  GTK_TEXT_CLASS=PGtkTextClass;

function  GTK_TEXT_INDEX(t:PGtkText; index:longint):char;

function  GTK_TEXT_TYPE:TGtkType;cdecl;external gtkdll name 'gtk_text_get_type';
function  GTK_IS_TEXT(obj:pointer):boolean;
function  GTK_IS_TEXT_CLASS(klass:pointer):boolean;

function  gtk_text_get_type:TGtkType;cdecl;external gtkdll name 'gtk_text_get_type';
function  gtk_text_new(hadj:PGtkAdjustment; vadj:PGtkAdjustment):PGtkWidget;cdecl;external gtkdll name 'gtk_text_new';
procedure gtk_text_set_editable(text:PGtkText; editable:gboolean);cdecl;external gtkdll name 'gtk_text_set_editable';
procedure gtk_text_set_word_wrap(text:PGtkText; word_wrap:gint);cdecl;external gtkdll name 'gtk_text_set_word_wrap';
{$ifndef gtkwin}
procedure gtk_text_set_line_wrap(text:PGtkText; line_wrap:gint);cdecl;external gtkdll name 'gtk_text_set_line_wrap';
{$endif}
procedure gtk_text_set_adjustments(text:PGtkText; hadj:PGtkAdjustment; vadj:PGtkAdjustment);cdecl;external gtkdll name 'gtk_text_set_adjustments';
procedure gtk_text_set_point(text:PGtkText; index:guint);cdecl;external gtkdll name 'gtk_text_set_point';
function  gtk_text_get_point(text:PGtkText):guint;cdecl;external gtkdll name 'gtk_text_get_point';
function  gtk_text_get_length(text:PGtkText):guint;cdecl;external gtkdll name 'gtk_text_get_length';
procedure gtk_text_freeze(text:PGtkText);cdecl;external gtkdll name 'gtk_text_freeze';
procedure gtk_text_thaw(text:PGtkText);cdecl;external gtkdll name 'gtk_text_thaw';
procedure gtk_text_insert(text:PGtkText; font:PGdkFont; fore:PGdkColor; back:PGdkColor; chars:pchar; length:gint);cdecl;external gtkdll name 'gtk_text_insert';
function  gtk_text_backward_delete(text:PGtkText; nchars:guint):gint;cdecl;external gtkdll name 'gtk_text_backward_delete';
function  gtk_text_forward_delete(text:PGtkText; nchars:guint):gint;cdecl;external gtkdll name 'gtk_text_forward_delete';

{$endif read_interface}


{****************************************************************************
                              Implementation
****************************************************************************}

{$ifdef read_implementation}

function  line_wrap(var a : TGtkText) : guint;
    begin
       line_wrap:=(a.flag0 and bm_TGtkText_line_wrap) shr bp_TGtkText_line_wrap;
    end;

procedure set_line_wrap(var a : TGtkText; __line_wrap : guint);
    begin
       a.flag0:=a.flag0 or ((__line_wrap shl bp_TGtkText_line_wrap) and bm_TGtkText_line_wrap);
    end;

function  word_wrap(var a : TGtkText) : guint;
    begin
       word_wrap:=(a.flag0 and bm_TGtkText_word_wrap) shr bp_TGtkText_word_wrap;
    end;

procedure set_word_wrap(var a : TGtkText; __word_wrap : guint);
    begin
       a.flag0:=a.flag0 or ((__word_wrap shl bp_TGtkText_word_wrap) and bm_TGtkText_word_wrap);
    end;

function  use_wchar(var a : TGtkText) : guint;
    begin
       use_wchar:=(a.flag0 and bm_TGtkText_use_wchar) shr bp_TGtkText_use_wchar;
    end;

procedure set_use_wchar(var a : TGtkText; __use_wchar : guint);
    begin
       a.flag0:=a.flag0 or ((__use_wchar shl bp_TGtkText_use_wchar) and bm_TGtkText_use_wchar);
    end;

function  GTK_TEXT_INDEX(t:PGtkText; index:longint):char;
begin
  if use_wchar(t^)<>0 then
   begin
     if index<t^.gap_position then
      GTK_TEXT_INDEX:=char(TGdkWchar(t^.text.wc[index]))
     else
      GTK_TEXT_INDEX:=char(TGdkWchar(t^.text.wc[index+t^.gap_position]));
   end
  else
   begin
     if index<t^.gap_position then
      GTK_TEXT_INDEX:=t^.text.ch[index]
     else
      GTK_TEXT_INDEX:=t^.text.ch[index+t^.gap_position];
   end;
end;

function  GTK_IS_TEXT(obj:pointer):boolean;
begin
  GTK_IS_TEXT:=(obj<>nil) and GTK_IS_TEXT_CLASS(PGtkTypeObject(obj)^.klass);
end;

function  GTK_IS_TEXT_CLASS(klass:pointer):boolean;
begin
  GTK_IS_TEXT_CLASS:=(klass<>nil) and (PGtkTypeClass(klass)^.thetype=GTK_TEXT_TYPE);
end;

{$endif read_implementation}


{
  $Log$
  Revision 1.1.2.1  2000-09-09 18:42:53  peter
    * gtk win32 fixes

  Revision 1.1  2000/07/13 06:34:06  michael
  + Initial import

  Revision 1.1  1999/11/24 23:36:36  peter
    * moved to packages dir

  Revision 1.10  1999/10/06 17:42:50  peter
    * external is now only in the interface
    * removed gtk 1.0 support

  Revision 1.9  1999/07/23 16:13:14  peter
    * use packrecords C

  Revision 1.8  1999/05/11 00:39:32  peter
    * win32 fixes

  Revision 1.7  1999/05/10 15:20:31  peter
    * cdecl fixes

  Revision 1.6  1999/05/10 09:04:04  peter
    * gtk 1.2 port working

  Revision 1.5  1998/11/09 10:10:35  peter
    + C type casts are now correctly handled

  Revision 1.4  1998/10/21 22:25:19  peter
    * fixed some wrong cdecls

  Revision 1.3  1998/10/21 20:23:17  peter
    * cdecl, packrecord fixes (from the gtk.tar.gz)
    * win32 support
    * gtk.pp,gdk.pp for an all in one unit

}

