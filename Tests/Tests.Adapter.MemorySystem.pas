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
unit Tests.Adapter.MemorySystem;

interface
uses
  DUnitX.TestFramework, Casbin.Adapter.Types;

type

  [TestFixture]
  TTestAdapterMemory = class(TObject)
  private
    fAdapter: IAdapter;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

uses
  Casbin.Adapter.Memory;

procedure TTestAdapterMemory.Setup;
begin
  fAdapter:=TMemoryAdapter.Create;
end;

procedure TTestAdapterMemory.TearDown;
begin
end;


initialization
  TDUnitX.RegisterTestFixture(TTestAdapterMemory);
end.
