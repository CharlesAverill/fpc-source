{
   $Id$
}

{****************************************************************************
                                 Interface
****************************************************************************}

{$ifdef read_interface}

{********************************
   Types inserted in gtkwidget
********************************}

{$ifndef gtkwin}
function  gtk_theme_engine_get(name:Pgchar):PGtkThemeEngine;cdecl;external gtkdll name 'gtk_theme_engine_get';
procedure gtk_theme_engine_ref(engine:PGtkThemeEngine);cdecl;external gtkdll name 'gtk_theme_engine_ref';
procedure gtk_theme_engine_unref(engine:PGtkThemeEngine);cdecl;external gtkdll name 'gtk_theme_engine_unref';
{$ifndef gtkdarwin}
procedure gtk_themes_init(argc:plongint; argv:pppchar);cdecl;external gtkdll name 'gtk_themes_init';
procedure gtk_themes_exit(error_code:gint);cdecl;external gtkdll name 'gtk_themes_exit';
{$endif not gtkdarwin}
{$endif}

{$endif read_interface}


{****************************************************************************
                              Implementation
****************************************************************************}

{$ifdef read_implementation}
{$endif read_implementation}


{
  $Log$
  Revision 1.3  2004-05-02 19:14:47  jonas
    * fixed darwin incompatibilities

  Revision 1.2  2002/09/07 15:43:00  peter
    * old logs removed and tabs fixed

  Revision 1.1  2002/01/29 17:55:14  peter
    * splitted to base and extra

}
