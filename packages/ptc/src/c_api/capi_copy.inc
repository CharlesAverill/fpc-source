{
    Free Pascal port of the OpenPTC C++ library.
    Copyright (C) 2001-2010  Nikolay Nikolov (nickysn@users.sourceforge.net)
    Original C++ version by Glenn Fiedler (ptc@gaffer.org)

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version
    with the following modification:

    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent modules,and
    to copy and distribute the resulting executable under terms of your choice,
    provided that you also meet, for each linked independent module, the terms
    and conditions of the license of that module. An independent module is a
    module which is not derived from or based on this library. If you modify
    this library, you may extend this exception to your version of the library,
    but you are not obligated to do so. If you do not wish to do so, delete this
    exception statement from your version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
}

function ptc_copy_create: TPTC_COPY;
begin
  try
    ptc_copy_create := TPTC_COPY(TPTCCopy.Create);
  except
    on error: TPTCError do
    begin
      ptc_exception_handle(error);
      ptc_copy_create := nil;
    end;
  end;
end;

procedure ptc_copy_destroy(obj: TPTC_COPY);
begin
  if obj = nil then
    exit;
  try
    TPTCCopy(obj).Destroy;
  except
    on error: TPTCError do
      ptc_exception_handle(error);
  end;
end;

procedure ptc_copy_request(obj: TPTC_COPY; source, destination: TPTC_FORMAT);
begin
  try
    TPTCCopy(obj).request(TPTCFormat(source), TPTCFormat(destination));
  except
    on error: TPTCError do
      ptc_exception_handle(error);
  end;
end;

procedure ptc_copy_palette(obj: TPTC_COPY; source, destination: TPTC_PALETTE);
begin
  try
    TPTCCopy(obj).palette(TPTCPalette(source), TPTCPalette(destination));
  except
    on error: TPTCError do
      ptc_exception_handle(error);
  end;
end;

procedure ptc_copy_copy(obj: TPTC_COPY; source_pixels: Pointer; source_x, source_y, source_width, source_height, source_pitch: Integer;
                        destination_pixels: Pointer; destination_x, destination_y, destination_width, destination_height, destination_pitch: Integer);
begin
  try
    TPTCCopy(obj).copy(source_pixels, source_x, source_y, source_width, source_height, source_pitch, destination_pixels, destination_x, destination_y, destination_width, destination_height, destination_pitch);
  except
    on error: TPTCError do
      ptc_exception_handle(error);
  end;
end;

function ptc_copy_option(obj: TPTC_COPY; option: AnsiString): Boolean;
begin
  try
    TPTCCopy(obj).option(option);
  except
    on error: TPTCError do
    begin
      ptc_exception_handle(error);
      ptc_copy_option := False;
    end;
  end;
end;
