{
   $Id$
}

{****************************************************************************
                                 Interface
****************************************************************************}

{$ifdef read_interface}

function  gtk_gc_get (depth:gint; colormap:PGdkColormap; values:PGdkGCValues; values_mask:TGdkGCValuesMask): PGdkGC;cdecl;external gtkdll name 'gtk_gc_get';
procedure gtk_gc_release(gc:PGdkGC);cdecl;external gtkdll name 'gtk_gc_release';

{$endif read_interface}


{****************************************************************************
                              Implementation
****************************************************************************}

{$ifdef read_implementation}
{$endif read_implementation}


{
  $Log$
  Revision 1.2  2000-07-13 11:33:21  michael
  + removed logs
 
}
