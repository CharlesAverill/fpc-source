{$IfDef read_interface}


function gnome_init(app_id:PAnsiChar; app_version:PAnsiChar; argc:longint; argv:PPAnsiChar):longint;cdecl;external libgnomeuidll name 'gnome_init';

(* function gnome_init_with_popt_table(app_id:PAnsiChar; app_version:PAnsiChar; argc:longint; argv:PPAnsiChar; options:PpoptOption;
           flags:longint; return_ctx:PpoptContext):longint;cdecl;external libgnomeuidll name 'gnome_init_with_popt_table';*)

{$EndIf read_interface}

{$Ifdef read_implementation}


{$Endif read_implementation}
