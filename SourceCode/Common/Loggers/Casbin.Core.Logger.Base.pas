// Copyright 2018 by John Kouraklis and Contributors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
unit Casbin.Core.Logger.Base;

interface

uses
  Casbin.Core.Base.Types, Casbin.Core.Logger.Types;

type
  {$REGION 'This is the base logger class. It does not do anything. You can expand the functionality by subclassing this one'}
  /// <summary>
  ///   <para>
  ///     This is the base logger class. It does not do anything.
  ///   </para>
  ///   <para>
  ///     You can expand the functionality by subclassing this one
  ///   </para>
  /// </summary>
  {$ENDREGION}
  TBaseLogger = class (TBaseInterfacedObject, ILogger)
  private
    fEnabled: Boolean;
{$REGION 'Interface'}
    function getEnabled: Boolean;
    function getLastLoggedMessage: string;
    procedure setEnabled(const aValue: Boolean);
{$ENDREGION}
  protected
    fLastLoggedMessage: string;   //PALOFF
  public
{$REGION 'Interface'}
    procedure log(const aMessage: string); virtual;
{$ENDREGION}
  public
    constructor Create;
  end;

implementation

uses
  System.SysUtils;

constructor TBaseLogger.Create;
begin
  inherited;
  fEnabled:=True;
end;

{ TBaseLogger }

function TBaseLogger.getEnabled: Boolean;
begin
  result:=fEnabled;
end;

function TBaseLogger.getLastLoggedMessage: string;
begin
  Result:=fLastLoggedMessage;
end;

procedure TBaseLogger.log(const aMessage: string);
begin
  if not fEnabled then
    Exit;
  fLastLoggedMessage:=trim(aMessage);
end;

procedure TBaseLogger.setEnabled(const aValue: Boolean);
begin
  fEnabled:=aValue;
  fLastLoggedMessage:='';
end;

end.
