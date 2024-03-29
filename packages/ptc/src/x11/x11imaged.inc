{
    This file is part of the PTCPas framebuffer library
    Copyright (C) 2001-2011 Nikolay Nikolov (nickysn@users.sourceforge.net)
    Original C++ version by Christian Nentwich (c.nentwich@cs.ucl.ac.uk)

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

type
  TX11Image = class
  protected
    FWidth, FHeight: Integer;
    FDisplay: PDisplay;
    FImage: PXImage;
  public
    constructor Create(ADisplay: PDisplay; AScreen, AWidth, AHeight: Integer; AFormat: IPTCFormat); virtual;
    procedure Put(AWindow: TWindow; AGC: TGC; AX, AY: Integer); virtual; abstract;
    procedure Put(AWindow: TWindow; AGC: TGC; ASX, ASY, ADX, ADY,
                  AWidth, AHeight: Integer); virtual; abstract;
    function Lock: Pointer; virtual; abstract;
    function Pitch: Integer; virtual; abstract;
    function Name: AnsiString; virtual; abstract;
  end;

  TX11NormalImage = class(TX11Image)
  private
    FPixels: PUint8;
  public
    constructor Create(ADisplay: PDisplay; AScreen, AWidth, AHeight: Integer; AFormat: IPTCFormat); override;
    destructor Destroy; override;
    procedure Put(AWindow: TWindow; AGC: TGC; AX, AY: Integer); override;
    procedure Put(AWindow: TWindow; AGC: TGC; ASX, ASY, ADX, ADY,
                  AWidth, AHeight: Integer); override;
    function Lock: Pointer; override;
    function Pitch: Integer; override;
    function Name: AnsiString; override;
  end;

{$IFDEF ENABLE_X11_EXTENSION_XSHM}
  TX11ShmImage = class(TX11Image)
  private
    FShmInfo: TXShmSegmentInfo;
    FShmAttached: Boolean;
  public
    constructor Create(ADisplay: PDisplay; AScreen, AWidth, AHeight: Integer; AFormat: IPTCFormat); override;
    destructor Destroy; override;
    procedure Put(AWindow: TWindow; AGC: TGC; AX, AY: Integer); override;
    procedure Put(AWindow: TWindow; AGC: TGC; ASX, ASY, ADX, ADY,
                  AWidth, AHeight: Integer); override;
    function Lock: Pointer; override;
    function Pitch: Integer; override;
    function Name: AnsiString; override;
  end;
{$ENDIF ENABLE_X11_EXTENSION_XSHM}
