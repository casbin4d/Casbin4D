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
unit Casbin.Types;

interface

uses
  Casbin.Model.Types, Casbin.Policy.Types,
  Casbin.Core.Logger.Types, System.Types, System.TypInfo, Casbin.Core.Base.Types;

type
  TEnforceParameters = TStringDynArray;

  ICasbin = interface (IBaseInterface)
    ['{7DC6F205-0000-40EF-BA8A-BF18018E5674}']
    function getEnabled: Boolean;
    function GetLoggerPool: ILoggerPool;
    function getModel: IModel;
    function getPolicy: IPolicyManager;
    procedure setEnabled(const aValue: Boolean);
    procedure SetLoggerPool(const aValue: ILoggerPool);
    procedure setModel(const aValue: IModel);
    procedure setPolicy(const aValue: IPolicyManager);

    function enforce (const aParams: TEnforceParameters): boolean; overload;
    function enforce (const aParams: TEnforceParameters;
                      const aPointer: PTypeInfo;
                      const aRec): boolean; overload;

    property Enabled: Boolean read getEnabled write setEnabled;
    property LoggerPool: ILoggerPool read GetLoggerPool write SetLoggerPool;
    property Model: IModel read getModel write setModel;
    property Policy: IPolicyManager read getPolicy write setPolicy;
  end;

implementation

end.
