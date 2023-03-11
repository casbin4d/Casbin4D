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
  Casbin.Core.Logger.Base, Casbin.Core.Logger.Types,
  System.Generics.Collections;

type
  TDefaultLogger = class (TBaseLogger)
  public
    procedure log(const aMessage: string); override;
  end;

  TDefaultLoggerPool = class (TInterfacedObject, ILoggerPool)
  private
    fLoggers: TList<ILogger>;
    function GetLoggers: TList<ILogger>;
    procedure SetLoggers(const Value: TList<ILogger>);

    procedure log(const aMessage: string);

  public
    constructor Create; overload;
    constructor Create(const aLogger: ILogger); overload;

    destructor Destroy; override;
    property Loggers: TList<ILogger> read GetLoggers write SetLoggers;
  end;

implementation

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows
  {$ENDIF}
  ;

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

constructor TDefaultLoggerPool.Create;
begin
  inherited;
  fLoggers:=TList<ILogger>.Create;
  fLoggers.Add(TDefaultLogger.Create);
end;

constructor TDefaultLoggerPool.Create(const aLogger: ILogger);
begin
  self.Create; // PALOFF
  if assigned(aLogger) then
    fLoggers.Add(aLogger);
end;

destructor TDefaultLoggerPool.Destroy;
begin
  fLoggers.Free;
  inherited;
end;

function TDefaultLoggerPool.GetLoggers: TList<ILogger>;
begin
  result:=fLoggers;
end;

procedure TDefaultLoggerPool.log(const aMessage: string);
var
  logger: ILogger;
begin
  for logger in fLoggers do
    if logger.Enabled then
      logger.log(aMessage);
end;

procedure TDefaultLoggerPool.SetLoggers(const Value: TList<ILogger>);
begin
  if assigned(Value) then
    fLoggers:=Value;
end;

end.
