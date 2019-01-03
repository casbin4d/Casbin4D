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
unit Casbin.Adapter.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Core.Logger.Types, System.Generics.Collections;

type

  IAdapter = interface (IBaseInterface)
    ['{474D7E69-1015-4DB8-92CF-AA19A448A4B6}']
    function getAssertions: TList<string>;
    function getLogger: ILogger;
    procedure setLogger(const aValue: ILogger);
    procedure load (const aFilter: TFilterArray = []);
    procedure save;
    procedure setAssertions(const aValue: TList<string>);

    function toOutputString: string;
    procedure clear;
    function getFilter: TFilterArray;
    function getFiltered: boolean;

    property Assertions: TList<string> read getAssertions write setAssertions;
    property Filter: TFilterArray read getFilter;
    property Filtered: boolean read getFiltered;
    property Logger: ILogger read getLogger write setLogger;
  end;

implementation

end.
