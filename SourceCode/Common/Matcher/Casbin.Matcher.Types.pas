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
unit Casbin.Matcher.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Effect.Types;

type
  IMatcher = interface (IBaseInterface)
    ['{7870739A-B58D-4127-8F29-F04482D5FCF3}']
    function evaluateMatcher (const aMatcherString: string): TEffectResult;
    procedure clearIdentifiers;
    procedure addIdentifier (const aTag: string);
  end;

implementation

end.
