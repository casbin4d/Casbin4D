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
unit Casbin.Core.Logger.Types;

interface

uses
  System.Generics.Collections;

type
  ILogger = interface
    ['{A2FB7DFB-BB81-421C-B2DF-5E76AB6FCB4D}']
{$REGION 'Getters/Setters'}
    function getEnableConsole: boolean;
    function getEnabled: Boolean;
    function getLastLoggedMessage: String;
    procedure setEnableConsole(const Value: boolean);
    procedure setEnabled(const aValue: Boolean);
{$ENDREGION}

    {$REGION 'Logs a message'}
    /// <summary>
    ///   Logs a message
    /// </summary>
    {$ENDREGION}
    procedure log(const aMessage: string);


    {$REGION 'Enables and Disables the logger'}
    /// <summary>
    ///   Enables and Disables the logger
    /// </summary>
    {$ENDREGION}
    property Enabled: Boolean read getEnabled write setEnabled;
    {$REGION 'If enabled it shows the log message in the console'}
    /// <summary>
    ///   If enabled it shows the log message in the console
    /// </summary>
    {$ENDREGION}
    property EnableConsole: boolean read getEnableConsole write setEnableConsole;
    {$REGION 'Retrieves the logged message. Used for debugging purposes'}
    /// <summary>
    ///   <para>
    ///     Retrieves the logged message.
    ///   </para>
    ///   <para>
    ///     Used for debugging purposes
    ///   </para>
    /// </summary>
    {$ENDREGION}
    property LastLoggedMessage: String read getLastLoggedMessage;
  end;

  ILoggerPool = interface
    ['{BBA7D2FA-DA89-4118-923E-2B8BE3E70AF5}']
    function GetLoggers: TList<ILogger>;
    procedure SetLoggers(const Value: TList<ILogger>);

    procedure log(const aMessage: string);

    property Loggers: TList<ILogger> read GetLoggers write SetLoggers;
  end;

implementation

end.
