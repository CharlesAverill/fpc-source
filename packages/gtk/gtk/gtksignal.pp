{
   $Id$
}

{****************************************************************************
                                 Interface
****************************************************************************}

{$ifdef read_interface}

    type

       TGtkSignalMarshal = procedure(theobject:PGtkObject;data:gpointer;nparams:guint;args:PGtkArg;arg_types:PGtkType; return_type:TGtkType);cdecl;
       TGtkSignalDestroy = procedure(data:gpointer);cdecl;
       TGtkEmissionHook = function (theobject:PGtkObject; signal_id:guint; n_params:guint; params:PGtkArg; data:gpointer):gboolean;cdecl;

       PGtkSignalQuery = ^TGtkSignalQuery;
       TGtkSignalQuery = record
            object_type : TGtkType;
            signal_id : guint;
            signal_name : Pgchar;
            flag0 : word;
            signal_flags : TGtkSignalRunType;
            return_val : TGtkType;
            nparams : guint;
            params : PGtkType;
         end;
    const
       bm_TGtkSignalQuery_is_user_signal = $1;
       bp_TGtkSignalQuery_is_user_signal = 0;
function  is_user_signal(var a : TGtkSignalQuery) : guint;
procedure set_is_user_signal(var a : TGtkSignalQuery; __is_user_signal : guint);

function  gtk_signal_lookup(name:Pgchar;object_type:TGtkType):guint;cdecl;external gtkdll name 'gtk_signal_lookup';
function  gtk_signal_name(signal_id:guint):Pgchar;cdecl;external gtkdll name 'gtk_signal_name';
function  gtk_signal_n_emissions(theobject:PGtkObject; signal_id:guint):guint;cdecl;external gtkdll name 'gtk_signal_n_emissions';
function  gtk_signal_n_emissions_by_name(theobject:PGtkObject; name:Pgchar):guint;cdecl;external gtkdll name 'gtk_signal_n_emissions_by_name';
procedure gtk_signal_emit_stop(theobject:PGtkObject;signal_id:guint);cdecl;external gtkdll name 'gtk_signal_emit_stop';
procedure gtk_signal_emit_stop_by_name(theobject:PGtkObject;name:Pgchar);cdecl;external gtkdll name 'gtk_signal_emit_stop_by_name';
function  gtk_signal_connect(theobject:PGtkObject;name:Pgchar;func:TGtkSignalFunc;func_data:gpointer):guint;cdecl;external gtkdll name 'gtk_signal_connect';
function  gtk_signal_connect_after(theobject:PGtkObject;name:Pgchar;func:TGtkSignalFunc;func_data:gpointer):guint;cdecl;external gtkdll name 'gtk_signal_connect_after';
function  gtk_signal_connect_object(theobject:PGtkObject;name:Pgchar;func:TGtkSignalFunc;slot_theobject:PGtkObject):guint;cdecl;external gtkdll name 'gtk_signal_connect_object';
function  gtk_signal_connect_object_after(theobject:PGtkObject;name:Pgchar;func:TGtkSignalFunc;slot_theobject:PGtkObject):guint;cdecl;external gtkdll name 'gtk_signal_connect_object_after';
function  gtk_signal_connect_full(theobject:PGtkObject;name:Pgchar;func:TGtkSignalFunc;marshal:TGtkCallbackMarshal;data:gpointer;destroy_func:TGtkDestroyNotify;object_signal:gint;after:gint):guint;cdecl;external gtkdll name 'gtk_signal_connect_full';
procedure gtk_signal_connect_object_while_alive(theobject:PGtkObject;signal:Pgchar;func:TGtkSignalFunc;alive_theobject:PGtkObject);cdecl;external gtkdll name 'gtk_signal_connect_object_while_alive';
procedure gtk_signal_connect_while_alive(theobject:PGtkObject;signal:Pgchar;func:TGtkSignalFunc;func_data:gpointer;alive_theobject:PGtkObject);cdecl;external gtkdll name 'gtk_signal_connect_while_alive';
procedure gtk_signal_disconnect(theobject:PGtkObject;handler_id:guint);cdecl;external gtkdll name 'gtk_signal_disconnect';
procedure gtk_signal_disconnect_by_func(theobject:PGtkObject; func:TGtkSignalFunc; data:gpointer);cdecl;external gtkdll name 'gtk_signal_disconnect_by_func';
procedure gtk_signal_disconnect_by_data(theobject:PGtkObject;data:gpointer);cdecl;external gtkdll name 'gtk_signal_disconnect_by_data';
procedure gtk_signal_handler_block(theobject:PGtkObject;handler_id:guint);cdecl;external gtkdll name 'gtk_signal_handler_block';
procedure gtk_signal_handler_block_by_func(theobject:PGtkObject; func:TGtkSignalFunc; data:gpointer);cdecl;external gtkdll name 'gtk_signal_handler_block_by_func';
procedure gtk_signal_handler_block_by_data(theobject:PGtkObject;data:gpointer);cdecl;external gtkdll name 'gtk_signal_handler_block_by_data';
procedure gtk_signal_handler_unblock(theobject:PGtkObject;handler_id:guint);cdecl;external gtkdll name 'gtk_signal_handler_unblock';
procedure gtk_signal_handler_unblock_by_func(theobject:PGtkObject; func:TGtkSignalFunc; data:gpointer);cdecl;external gtkdll name 'gtk_signal_handler_unblock_by_func';
procedure gtk_signal_handler_unblock_by_data(theobject:PGtkObject;data:gpointer);cdecl;external gtkdll name 'gtk_signal_handler_unblock_by_data';
function  gtk_signal_handler_pending(theobject:PGtkObject;signal_id:guint;may_be_blocked:gboolean):guint;cdecl;external gtkdll name 'gtk_signal_handler_pending';
function  gtk_signal_handler_pending_by_func(theobject:PGtkObject; signal_id:guint; may_be_blocked:gboolean; func:TGtkSignalFunc; data:gpointer):guint;cdecl;external gtkdll name 'gtk_signal_handler_pending_by_func';
function  gtk_signal_handler_pending_by_id(theobject:PGtkObject; handler_id:guint; may_be_blocked:gboolean):gint;cdecl;external gtkdll name 'gtk_signal_handler_pending_by_id';
function  gtk_signal_add_emission_hook(signal_id:guint; hook_func:TGtkEmissionHook; data:gpointer):guint;cdecl;external gtkdll name 'gtk_signal_add_emission_hook';
function  gtk_signal_add_emission_hook_full(signal_id:guint; hook_func:TGtkEmissionHook; data:gpointer; destroy:TGDestroyNotify):guint;cdecl;external gtkdll name 'gtk_signal_add_emission_hook_full';
procedure gtk_signal_remove_emission_hook(signal_id:guint; hook_id:guint);cdecl;external gtkdll name 'gtk_signal_remove_emission_hook';
function  gtk_signal_query(signal_id:guint):PGtkSignalQuery;cdecl;external gtkdll name 'gtk_signal_query';
procedure gtk_signal_init;cdecl;external gtkdll name 'gtk_signal_init';
function  gtk_signal_new(name:Pgchar; signal_flags:TGtkSignalRunType; object_type:TGtkType; function_offset:guint; marshaller:TGtkSignalMarshaller; return_val:TGtkType; nparams:guint; args:array of const):guint;cdecl;external gtkdll name 'gtk_signal_new';
function  gtk_signal_new(name:Pgchar; signal_flags:TGtkSignalRunType; object_type:TGtkType; function_offset:guint; marshaller:TGtkSignalMarshaller; return_val:TGtkType; nparams:guint):guint;cdecl;external gtkdll name 'gtk_signal_new';
function  gtk_signal_newv(name:Pgchar; signal_flags:TGtkSignalRunType; object_type:TGtkType; function_offset:guint; marshaller:TGtkSignalMarshaller; return_val:TGtkType; nparams:guint; params:PGtkType):guint;cdecl;external gtkdll name 'gtk_signal_newv';
procedure gtk_signal_emit(theobject:PGtkObject; signal_id:guint; args:array of const);cdecl;external gtkdll name 'gtk_signal_emit';
procedure gtk_signal_emit(theobject:PGtkObject; signal_id:guint);cdecl;external gtkdll name 'gtk_signal_emit';
procedure gtk_signal_emit_by_name(theobject:PGtkObject; name:Pgchar; args:array of const);cdecl;external gtkdll name 'gtk_signal_emit_by_name';
procedure gtk_signal_emit_by_name(theobject:PGtkObject; name:Pgchar);cdecl;external gtkdll name 'gtk_signal_emit_by_name';
procedure gtk_signal_emitv(theobject:PGtkObject; signal_id:guint; params:PGtkArg);cdecl;external gtkdll name 'gtk_signal_emitv';
procedure gtk_signal_emitv_by_name(theobject:PGtkObject; name:Pgchar; params:PGtkArg);cdecl;external gtkdll name 'gtk_signal_emitv_by_name';
{$ifndef gtkwin}
procedure gtk_signal_handlers_destroy(theobject:PGtkObject);cdecl;external gtkdll name 'gtk_signal_handlers_destroy';
procedure gtk_signal_set_funcs(marshal_func:TGtkSignalMarshal;destroy_func:TGtkSignalDestroy);cdecl;external gtkdll name 'gtk_signal_set_funcs';
{$endif}

{$endif read_interface}


{****************************************************************************
                              Implementation
****************************************************************************}

{$ifdef read_implementation}

function  is_user_signal(var a : TGtkSignalQuery) : guint;
      begin
         is_user_signal:=(a.flag0 and bm_TGtkSignalQuery_is_user_signal) shr bp_TGtkSignalQuery_is_user_signal;
      end;

procedure set_is_user_signal(var a : TGtkSignalQuery; __is_user_signal : guint);
      begin
         a.flag0:=a.flag0 or ((__is_user_signal shl bp_TGtkSignalQuery_is_user_signal) and bm_TGtkSignalQuery_is_user_signal);
      end;

{$endif read_implementation}


{
  $Log$
  Revision 1.1  1999-11-24 23:36:36  peter
    * moved to packages dir

  Revision 1.15  1999/10/06 17:42:50  peter
    * external is now only in the interface
    * removed gtk 1.0 support

  Revision 1.14  1999/07/23 16:13:07  peter
    * use packrecords C

  Revision 1.13  1999/06/10 20:00:20  peter
    * fixed tictactoe

  Revision 1.12  1999/05/11 00:39:24  peter
    * win32 fixes

  Revision 1.11  1999/05/10 19:18:32  peter
    * more fixes for the examples to work

  Revision 1.10  1999/05/10 15:20:23  peter
    * cdecl fixes

  Revision 1.9  1999/05/10 09:03:55  peter
    * gtk 1.2 port working

  Revision 1.8  1999/05/07 15:10:13  peter
    * more fixes

  Revision 1.7  1999/02/01 09:58:48  michael
  + Patch from Frank Loemker

  Revision 1.6  1999/01/28 19:40:38  peter
    * gtk compiles again and now uses only one makefile

  Revision 1.5  1999/01/26 12:42:24  michael
  *** empty log message ***

  Revision 1.4  1998/11/12 11:35:53  peter
    + array of const

  Revision 1.3  1998/10/21 20:23:12  peter
    * cdecl, packrecord fixes(from the gtk.tar.gz)
    * win32 support
    * gtk.pp,gdk.pp for an all in one unit

}

