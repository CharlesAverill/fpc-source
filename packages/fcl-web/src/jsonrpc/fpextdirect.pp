{
    This file is part of the Free Component Library

    Ext.Direct support - http part
    Copyright (c) 2007 by Michael Van Canneyt michael@freepascal.org

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$IFNDEF FPC_DOTTEDUNITS}
unit fpextdirect;
{$ENDIF FPC_DOTTEDUNITS}

{$mode objfpc}{$H+}
{ $define extdebug}

interface

{$IFDEF FPC_DOTTEDUNITS}
uses
  System.Classes, System.SysUtils, FpJson.Data, FpWeb.JsonRpc.Base, FpWeb.JsonRpc.DispExtDirect, FpWeb.JsonRpc.Web, FpWeb.Http.Defs, Fcl.UriParser;
{$ELSE FPC_DOTTEDUNITS}
uses
  Classes, SysUtils, fpjson, fpjsonrpc, fpdispextdirect, webjsonrpc, httpdefs, uriparser;
{$ENDIF FPC_DOTTEDUNITS}

Const
  // Redefinition for backwards compatibility
  
{$IFDEF FPC_DOTTEDUNITS}  
   DefaultExtDirectOptions = FpWeb.JsonRpc.DispExtDirect.DefaultExtDirectOptions;
{$ELSE}
   DefaultExtDirectOptions = fpdispextdirect.DefaultExtDirectOptions;
{$ENDIF}

Type
  // Redefinition for backwards compatibility

  { TCustomExtDirectDispatcher }

  TCustomExtDirectDispatcher = Class({$IFDEF FPC_DOTTEDUNITS}FpWeb.JsonRpc.DispExtDirect{$ELSE}fpdispextdirect{$ENDIF}.TCustomExtDirectDispatcher)
    Procedure InitContainer(H: TCustomJsonRpcHandler;  AContext: TJsonRpcCallContext; AContainer: TComponent); override;
  end;

  { TExtDirectDispatcher }
  TExtDirectDispatcher = Class(TCustomExtDirectDispatcher)
  Published
    Property NameSpace;
    Property URL;
    Property APIType;
    Property OnStartBatch;
    Property OnDispatchRequest;
    Property OnFindHandler;
    Property OnEndBatch;
    Property Options;
  end;

  { TCustomExtDirectContentProducer }

  TCustomExtDirectContentProducer = Class(TCustomJsonRpcContentProducer)
  Protected
    Function GetIDProperty : String; override;
    Procedure DoGetContent(ARequest : TRequest; Content : TStream; Var Handled : Boolean); override;
  end;

  { TExtDirectContentProducer }

  TExtDirectContentProducer = Class(TCustomExtDirectContentProducer)
  private
    FDispatcher: TCustomExtDirectDispatcher;
    procedure SetDispatcher(const AValue: TCustomExtDirectDispatcher);
  Protected
    Function GetDispatcher : TCustomJsonRpcDispatcher; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
  Published
    Property Dispatcher :  TCustomExtDirectDispatcher Read FDispatcher Write SetDispatcher;
  end;

  { TCustomExtDirectModule }

  TCustomExtDirectModule = Class(TJsonRpcDispatchModule)
  private
    FAPIPath: String;
    FDispatcher: TCustomExtDirectDispatcher;
    FNameSpace: String;
    FOptions: TJsonRpcDispatchOptions;
    FRequest: TRequest;
    FResponse: TResponse;
    FRouterPath: String;
    procedure SetDispatcher(const AValue: TCustomExtDirectDispatcher);
  Protected
    // Create API
    procedure CreateAPI(ADispatcher: TCustomExtDirectDispatcher; ARequest: TRequest; AResponse: TResponse); virtual;
    Function CreateDispatcher : TCustomExtDirectDispatcher; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    // Set to a custom dispatcher. If not set, one is created (and kept for all subsequent requests)
    Property Dispatcher :  TCustomExtDirectDispatcher Read FDispatcher Write SetDispatcher;
    // Options to use when creating a dispatcher.
    Property DispatchOptions : TJsonRpcDispatchOptions Read FOptions Write FOptions default DefaultDispatchOptions;
    // API path/action. Append to BaseURL to get API. Default 'API'
    Property APIPath : String Read FAPIPath Write FAPIPath;
    // Router path/action. Append to baseURL to get router. Default 'router'
    Property RouterPath : String Read FRouterPath Write FRouterPath;
    // Namespace
    Property NameSpace : String Read FNameSpace Write FNameSpace;
  Public
    Constructor CreateNew(AOwner : TComponent; CreateMode : Integer); override;
    Procedure HandleRequest(ARequest : TRequest; AResponse : TResponse); override;
    // Access to request
    Property Request: TRequest Read FRequest;
    // Access to response
    Property Response: TResponse Read FResponse;
  end;

  TExtDirectModule = Class(TCustomExtDirectModule)
  Published
    Property Dispatcher;
    Property DispatchOptions;
    Property APIPath;
    Property RouterPath;
    Property CreateSession;
    Property NameSpace;
    Property BaseURL;
    Property AfterInitModule;
    Property Kind;
    Property Session;
    Property OnNewSession;
    Property OnSessionExpired;
    Property CORS;
  end;

implementation


{$IFDEF FPC_DOTTEDUNITS}
uses {$ifdef extdebug}System.Dbugintf,{$endif} FpWeb.JsonRpc.Strings;
{$ELSE FPC_DOTTEDUNITS}
uses {$ifdef extdebug}dbugintf,{$endif} fprpcstrings;
{$ENDIF FPC_DOTTEDUNITS}



{ TCustomExtDirectDispatcher }

Procedure TCustomExtDirectDispatcher.InitContainer(H: TCustomJsonRpcHandler;
  AContext: TJsonRpcCallContext; AContainer: TComponent);
begin
  inherited InitContainer(H, AContext, AContainer);
  If (AContext is TJsonRpcSessionContext) and (AContainer is TCustomJsonRpcModule) then
    TCustomJsonRpcModule(AContainer).Session:=TJsonRpcSessionContext(AContext).Session;
end;

{ TCustomExtDirectContentProducer }

function TCustomExtDirectContentProducer.GetIDProperty: String;
begin
  Result:='tid';
end;

procedure TCustomExtDirectContentProducer.DoGetContent(ARequest: TRequest;
  Content: TStream; var Handled: Boolean);

Var
  A,R: String;

begin
  A:=ARequest.GetNextPathInfo;
  If (A<>'router') then
    begin
    R:=TCustomExtDirectDispatcher(GetDispatcher).APIAsString;
    Content.WriteBuffer(R[1],Length(R));
    Handled:=True;
    end
  else
    inherited DoGetContent(ARequest, Content, Handled);
end;

{ TExtDirectContentProducer }

procedure TExtDirectContentProducer.SetDispatcher(
  const AValue: TCustomExtDirectDispatcher);
begin
  if FDispatcher=AValue then exit;
  If Assigned(FDispatcher) then
    FDispatcher.RemoveFreeNotification(Self);
  FDispatcher:=AValue;
  If Assigned(FDispatcher) then
    FDispatcher.FreeNotification(Self);
end;

function TExtDirectContentProducer.GetDispatcher: TCustomJsonRpcDispatcher;
begin
  Result:=FDispatcher;
end;

procedure TExtDirectContentProducer.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  If (Operation=opRemove) and (AComponent=FDispatcher) then
    FDispatcher:=Nil;
end;

{ TCustomExtDirectModule }

procedure TCustomExtDirectModule.SetDispatcher(
  const AValue: TCustomExtDirectDispatcher);
begin
  if FDispatcher=AValue then exit;
  If Assigned(FDispatcher) then
    FDispatcher.RemoveFreeNotification(Self);
  FDispatcher:=AValue;
  If Assigned(FDispatcher) then
    FDispatcher.FreeNotification(Self);
end;

function TCustomExtDirectModule.CreateDispatcher: TCustomExtDirectDispatcher;

Var
  E : TExtDirectDispatcher;

begin
  E:=TExtDirectDispatcher.Create(Self);
  E.Options:=DispatchOptions;
  E.URL:=IncludeHTTPPathDelimiter(BaseURL)+RouterPath;
  E.NameSpace:=NameSpace;
  Result:=E
end;

procedure TCustomExtDirectModule.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  If (Operation=opRemove) and (AComponent=FDispatcher) then
    FDispatcher:=Nil;
end;

constructor TCustomExtDirectModule.CreateNew(AOwner: TComponent;
  CreateMode: Integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  FOptions:=DefaultDispatchOptions+[jdoSearchRegistry];
  APIPath:='API';
  RouterPath:='router'
end;

procedure TCustomExtDirectModule.CreateAPI(ADispatcher : TCustomExtDirectDispatcher; ARequest: TRequest;   AResponse: TResponse);


begin
  AResponse.Content:=ADispatcher.APIAsString;
  AResponse.ContentLength:=Length(AResponse.Content);
end;

procedure TCustomExtDirectModule.HandleRequest(ARequest: TRequest;
  AResponse: TResponse);

Var
  Disp : TCustomExtDirectDispatcher;
  res : TJSONData;
  R : String;

begin
  Self.FRequest:=aRequest;
  Self.FResponse:=aResponse;
  try
    {$ifdef extdebug}SendDebug('Ext.Direct handlerequest: checking session');{$endif}
    CheckSession(ARequest);
    {$ifdef extdebug}SendDebug('Ext.Direct handlerequest: init session ');{$endif}
    InitSession(AResponse);
    {$ifdef extdebug}SendDebug('Ext.Direct creating dispatcher');{$endif}
    If (Dispatcher=Nil) then
      Dispatcher:=CreateDispatcher;
    {$ifdef extdebug}SendDebugFmt('Ext.Direct handlerequest: dispatcher class is "%s"',[Dispatcher.Classname]);{$endif}
    Disp:=Dispatcher as TCustomExtDirectDispatcher;
    R:=ARequest.QueryFields.Values['action'];
    If (R='') then
      R:=ARequest.GetNextPathInfo;
    {$ifdef extdebug}SendDebugFmt('Ext.Direct handlerequest: action is "%s"',[R]);{$endif}
    if not CORS.HandleRequest(aRequest,aResponse,[hcDetect,hcSend]) then
      If (CompareText(R,APIPath)=0) then
        begin
        CreateAPI(Disp,ARequest,AResponse);
        UpdateSession(AResponse);
        AResponse.SendResponse;
        end
      else if (CompareText(R,RouterPath)=0) then
        begin
        Res:=DispatchRequest(ARequest,Disp);
        try
          UpdateSession(AResponse);
          If Assigned(Res) then
            AResponse.Content:=Res.AsJSON;
          AResponse.SendResponse;
        finally
          Res.Free;
        end;
        end
      else
        JsonRpcError(SErrInvalidPath);
  finally
    Self.FRequest:=Nil;
    Self.FResponse:=Nil;
  end;
end;

end.

