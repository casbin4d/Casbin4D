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
unit Casbin.Core.Logger.Default;

interface

uses
  Casbin.Core.Logger.Base;

type
  TDefaultLogger = class (TBaseLogger)
  public
    procedure log(const aMessage: string); override;
  end;

implementation

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF}
  Casbin.Core.Logger.Types;

{ TDefaultLogger }

procedure TDefaultLogger.log(const aMessage: string);
begin
  inherited;
  // The default logger does not log anything.
  // Any descentent classes can use aMessage
  // if Enabled then
  //  ...log the message...

  if fEnableConsole then
    {$IFDEF MSWINDOWS}
    OutputDebugString(PChar(aMessage))
    {$ELSE}
    raise Exception.Create('Not implemented yet');
    {$ENDIF}
end;

end.
