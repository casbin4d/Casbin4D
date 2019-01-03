// Copyright 2018 The Casbin Authors. All Rights Reserved.
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
unit Casbin.Parser.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Core.Logger.Types, Casbin.Parser.AST.Types;

type
  TParseType = (ptModel, ptPolicy, ptConfig);
  TParserStatus = (psIdle, psRunning, psError);

  IParser = interface (IBaseInterface)
    function getErrorMessage: string;
    function getLogger: ILogger;
    function getNodes: TNodeCollection;
    function getParseType: TParseType;
    function getStatus: TParserStatus;
    procedure setLogger(const aValue: ILogger);

    procedure parse;
    property ErrorMessage: string read getErrorMessage;
    property Logger: ILogger read getLogger write setLogger;
    property Nodes: TNodeCollection read getNodes;
    property ParseType: TParseType read getParseType;
    property Status: TParserStatus read getStatus;
  end;

implementation

end.
