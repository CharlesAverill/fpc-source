{ %cpu=i386 }
{ %KNOWNRUNERROR=2,i386 long double array problem }
{****************************************************************}
{  CODE GENERATOR TEST PROGRAM                                   }
{****************************************************************}
{ NODE TESTED : secondcalln()                                    }
{****************************************************************}
{ PRE-REQUISITES: secondload()                                   }
{                 secondassign()                                 }
{                 secondcalln()                                  }
{                 secondadd()                                    }
{                 secondtypeconv()                               }
{****************************************************************}
{ DEFINES:                                                       }
{****************************************************************}
{ REMARKS: This tests a subset of the secondcalln() , it         }
{          verifies the usage of external cdecl                  }
{          modules compiled with C compilers.                    }
{****************************************************************}


{$ifndef USE_PASCAL_OBJECT}
{$MODE OBJFPC}
{$STATIC ON}
{$R+}
uses strings;
{$L ctest.o}
{$endif USE_PASCAL_OBJECT}
{ Use C alignment of records }
{$PACKRECORDS C}
const
   RESULT_U8BIT = $55;
   RESULT_U16BIT = $500F;
   RESULT_U32BIT = $500F0000;
   RESULT_U64BIT = $1BCDABCD;
   RESULT_S16BIT = -12;
   RESULT_S32BIT = -120;
   RESULT_S64BIT = -12000;
   RESULT_FLOAT  = 14.54;
   RESULT_DOUBLE = 15.54;
   RESULT_LONGDOUBLE = 16.54;
   RESULT_PCHAR  = 'Hello world';

type
 _1byte_ = record
  u8 : byte;
 end;

 _3byte_ = record
  u8 : byte;
  u16 : word;
 end;

 _3byte_s = record
  u16 : word;
  w8 : byte;
 end;

 _5byte_ = record
  u8 : byte;
  u32 : cardinal;
 end;

_7byte_ = record
  u8: byte;
  s64: int64;
  u16: word;
end;
  byte_array = array [0..1] of byte;
  word_array = array [0..1] of word;
  cardinal_array = array [0..1] of cardinal;
  qword_array = array [0..1] of qword;
  smallint_array = array [0..1] of smallint;
  longint_array = array [0..1] of longint;
  int64_array = array [0..1] of int64;
  single_array = array [0..1] of single;
  double_array = array [0..1] of double;
  extended_array = array [0..1] of extended;


{ simple parameter passing }
procedure test_param_u8(x: byte); cdecl; external;
procedure test_param_u16(x : word); cdecl; external;
procedure test_param_u32(x: cardinal); cdecl; external;
procedure test_param_u64(x: qword); cdecl; external;
procedure test_param_s16(x : smallint); cdecl; external;
procedure test_param_s32(x: longint); cdecl; external;
procedure test_param_s64(x: int64); cdecl; external;
procedure test_param_float(x : single); cdecl; external;
procedure test_param_double(x: double); cdecl; external;
procedure test_param_longdouble(x: extended); cdecl; external;
procedure test_param_var_u8(var x: byte); cdecl; external;

{ array parameter passing }
procedure test_array_param_u8(x: byte_array); cdecl; external;
procedure test_array_param_u16(x : word_array); cdecl; external;
procedure test_array_param_u32(x: cardinal_array); cdecl; external;
procedure test_array_param_u64(x: qword_array); cdecl; external;
procedure test_array_param_s16(x :smallint_array); cdecl; external;
procedure test_array_param_s32(x: longint_array); cdecl; external;
procedure test_array_param_s64(x: int64_array); cdecl; external;
procedure test_array_param_float(x : single_array); cdecl; external;
procedure test_array_param_double(x: double_array); cdecl; external;
procedure test_array_param_longdouble(x: extended_array); cdecl; external;

{ mixed parameter passing }
procedure test_param_mixed_u16(z: byte; x : word; y :byte); cdecl; external;
procedure test_param_mixed_u32(z: byte; x: cardinal; y: byte); cdecl; external;
procedure test_param_mixed_s64(z: byte; x: int64; y: byte); cdecl; external;
procedure test_param_mixed_float(x: single; y: byte); cdecl; external;
procedure test_param_mixed_double(x: double; y: byte); cdecl; external;
procedure test_param_mixed_long_double(x: extended; y: byte); cdecl; external;
procedure test_param_mixed_var_u8(var x: byte;y:byte); cdecl; external;
{ structure parameter testing }
procedure test_param_struct_tiny(buffer :   _1BYTE_); cdecl; external;
procedure test_param_struct_small(buffer :  _3BYTE_); cdecl; external;
procedure test_param_struct_small_s(buffer :  _3BYTE_S); cdecl; external;
procedure test_param_struct_medium(buffer : _5BYTE_); cdecl; external;
procedure test_param_struct_large(buffer :  _7BYTE_); cdecl; external;
{ mixed with structure parameter testing }
procedure test_param_mixed_struct_tiny(buffer :   _1BYTE_; y :byte); cdecl; external;
procedure test_param_mixed_struct_small(buffer :  _3BYTE_; y :byte); cdecl; external;
procedure test_param_mixed_struct_small_s(buffer :  _3BYTE_S; y :byte); cdecl; external;
procedure test_param_mixed_struct_medium(buffer : _5BYTE_; y :byte); cdecl; external;
procedure test_param_mixed_struct_large(buffer :  _7BYTE_; y :byte); cdecl; external;
{ function result value testing }
function test_function_u8: byte; cdecl; external;
function test_function_u16: word; cdecl; external;
function test_function_u32: cardinal; cdecl; external;
function test_function_u64: qword; cdecl; external;
function test_function_s16: smallint; cdecl; external;
function test_function_s32: longint; cdecl; external;
function test_function_s64: int64; cdecl; external;
function test_function_pchar: pchar; cdecl; external;
function test_function_float : single; cdecl; external;
function test_function_double : double; cdecl; external;
function test_function_longdouble: extended; cdecl; external;
function test_function_tiny_struct : _1byte_; cdecl; external;
function test_function_small_struct : _3byte_; cdecl; external;
function test_function_small_struct_s : _3byte_s; cdecl; external;
function test_function_medium_struct : _5byte_; cdecl; external;
function test_function_struct : _7byte_; cdecl; external;






var
 global_u8bit : byte; cvar; external;
 global_u16bit : word; cvar; external;
 global_u32bit : cardinal; cvar;external;
 global_u64bit : qword; cvar; external;
 global_s16bit : smallint; cvar; external;
 global_s32bit : longint; cvar;external;
 global_s64bit : int64; cvar; external;
 global_float : single; cvar;external;
 global_double : double; cvar;external;
 global_long_double : extended; cvar; external;
 value_u8bit : byte;
 value_s16bit : smallint;
 value_s32bit : longint;
 value_s64bit : int64;
 value_u16bit : word;
 value_u32bit : cardinal;
 value_u64bit : qword;
 value_float : single;
 value_double : double;
 value_long_double : extended;
 array_u8bit : array [0..1] of byte;
 array_s16bit : array [0..1] of smallint;
 array_s32bit : array [0..1] of longint;
 array_s64bit : array [0..1] of int64;
 array_u16bit : array [0..1] of word;
 array_u32bit : array [0..1] of cardinal;
 array_u64bit : array [0..1] of qword;
 array_float : array [0..1] of single;
 array_double : array [0..1] of double;
 array_long_double : array [0..1] of extended;

 procedure clear_globals;
  begin
    global_u8bit := 0;
    global_u16bit := 0;
    global_u32bit := 0;
    global_u64bit := 0;
    global_s16bit := 0;
    global_s32bit := 0;
    global_s64bit := 0;
    global_float := 0.0;
    global_double := 0.0;
    global_long_double := 0.0;
   end;

 procedure clear_values;
  begin
    value_u8bit := 0;
    value_u16bit := 0;
    value_u32bit := 0;
    value_u64bit := 0;
    value_s16bit := 0;
    value_s32bit := 0;
    value_s64bit := 0;
    value_float := 0.0;
    value_double := 0.0;
    value_long_double := 0.0;
  end;

const
  has_errors : boolean = false;
  known_bug_about_extended_array_present : boolean = false;
  procedure fail;
   begin
     WriteLn('Failed!');
     has_errors:=true;
   end;


var failed : boolean;
    tinystruct : _1BYTE_;
    smallstruct : _3BYTE_;
    smallstruct_s : _3BYTE_S;
    mediumstruct : _5BYTE_;
    bigstruct : _7BYTE_;
    pc: pchar;
begin
  failed := false;

  clear_values;
  clear_globals;

  array_long_double[1] := RESULT_LONGDOUBLE;
  test_array_param_longdouble(array_long_double);
  if trunc(global_long_double) <> trunc(RESULT_LONGDOUBLE) then
    begin
      if sizeof(global_long_double)=10 then
        begin
          writeln('extended size is incompatible with C');
          writeln('this will lead to failures if long doubles');
          writeln('are used as arrays of members of packed structures');
          halt(2);
        end
      else
        failed := true;
    end;

  If failed then
   fail
  else
    WriteLn('Passed!');

  if has_errors then
    Halt(1);
end.

{
  $Log$
  Revision 1.1  2003-10-31 16:47:31  peter
    * move extended size check to separate test

  Revision 1.9  2002/11/18 16:48:00  pierre
   + use KNOWNRUNERROR for i386 long double problem

  Revision 1.8  2002/11/18 00:42:16  pierre
   + records with really 3 byte size tests added

  Revision 1.7  2002/11/17 21:46:17  peter
    * fixed

  Revision 1.6  2002/11/04 15:17:45  pierre
   * compatibility with C checks improved

  Revision 1.5  2002/09/07 15:40:51  peter
    * old logs removed and tabs fixed

  Revision 1.4  2002/08/25 19:28:07  peter
    * fixed long double typo that was using double instead of extended

  Revision 1.3  2002/05/04 16:56:54  carl
  + var parameter testing
  + function result testing
  + floating point testing

  Revision 1.2  2002/04/22 19:09:28  carl
  + added structure testing

  Revision 1.1  2002/04/13 21:03:43  carl
  + C module testing (unfinished)

}
