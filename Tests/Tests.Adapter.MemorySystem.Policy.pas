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
unit Tests.Adapter.MemorySystem.Policy;

interface
uses
  DUnitX.TestFramework, Casbin.Adapter.Policy.Types;

type

  [TestFixture]
  TTestPolicyMemoryAdapter = class(TObject)
  private
    fAdapter: IPolicyAdapter;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testAdd;

    [Test]
    procedure testLoad;
  end;

implementation

uses
  Casbin.Adapter.Memory.Policy;

procedure TTestPolicyMemoryAdapter.Setup;
begin
  fAdapter:=TPolicyMemoryAdapter.Create;
end;

procedure TTestPolicyMemoryAdapter.TearDown;
begin
end;


procedure TTestPolicyMemoryAdapter.testAdd;
begin
  fAdapter.add('123');
  Assert.IsTrue(fAdapter.Assertions.Count = 2, '1'); // There is a [default] line
  Assert.IsTrue(fAdapter.Assertions.Contains('123'), '2');
end;

procedure TTestPolicyMemoryAdapter.testLoad;
begin
  fAdapter.add('ABC');
  fAdapter.add('DEF');
  fAdapter.add('XYZ');
  fAdapter.load(['DEF']);
  Assert.IsTrue(fAdapter.Assertions.Count = 2, '1');
  Assert.IsTrue(fAdapter.Assertions.Contains('DEF'), '2');
  Assert.IsTrue(Length(fAdapter.Filter) = 1, '3');
  Assert.IsTrue(fAdapter.Filter[0] = 'DEF', '4');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicyMemoryAdapter);
end.
