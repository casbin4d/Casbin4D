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
unit Casbin.Model.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Model.Sections.Types,
  System.Generics.Collections, Casbin.Effect.Types;

type
  IModel = interface (IBaseInterface)
    ['{A1B8A09F-0562-4C15-B9F3-74537C5A9E27}']
    function section (const aSection: TSectionType;
                                        const aSlim: Boolean = true): string;
    function assertions (const aSection: TSectionType): TList<string>;
    procedure addDefinition (const aSection: TSectionType; const aTag: string;
                              const aAssertion: string); overload;
    procedure addDefinition (const aSection: TSectionType;
                              const aAssertion: string); overload;
    procedure addModel(const aModel: string);
    function assertionExists (const aAssertion: string): Boolean;
    function effectCondition: TEffectCondition;
    function toOutputString: string;
  end;

implementation

end.
