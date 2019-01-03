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
unit Casbin.Core.Base.Types;

interface

uses
  System.Types;

type
  IBaseInterface = interface (IInterface)
    ['{54CC7AC8-E892-49A1-9E8D-FF95A2EE6D64}']
  end;

  TBaseInterfacedObject = class (TInterfacedObject, IBaseInterface)

  end;

  TBaseObject = class (TObject)

  end;

  TFilterArray = TStringDynArray;

implementation

end.
