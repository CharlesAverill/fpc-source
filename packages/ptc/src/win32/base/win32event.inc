{
    Free Pascal port of the OpenPTC C++ library.
    Copyright (C) 2001-2003, 2006, 2009, 2010  Nikolay Nikolov (nickysn@users.sourceforge.net)
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

constructor TWin32Event.Create;
begin
  { create event handle }
  FEvent := CreateEvent(nil, True, False, nil);

  { check event handle }
  if FEvent = 0 then
    raise TPTCError.Create('could not create event');
end;

destructor TWin32Event.Destroy;
begin
  { close handle }
  CloseHandle(FEvent);

  inherited Destroy;
end;

procedure TWin32Event.SetEvent;
begin
  { set event }
  {$IFDEF FPC_DOTTEDUNITS}WinApi.{$ENDIF}Windows.SetEvent(FEvent);
end;

procedure TWin32Event.ResetEvent;
begin
  { reset event }
  {$IFDEF FPC_DOTTEDUNITS}WinApi.{$ENDIF}Windows.ResetEvent(FEvent);
end;

procedure TWin32Event.WaitForEvent;
begin
  { wait for event }
  WaitForSingleObject(FEvent, INFINITE);
end;
