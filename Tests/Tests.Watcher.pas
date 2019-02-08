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
unit Tests.Watcher;

interface
uses
  DUnitX.TestFramework, Casbin.Model.Types, Casbin.Policy.Types, Casbin.Watcher.Types;

type
  TTestWatcherElement = class (TInterfacedObject, IWatcher)
  private
    fMessage: string;
    fInitialMessage: string;
  public
    constructor Create(const aMessage: string);
    procedure update;
    property &Message: string read fMessage;
  end;

  [TestFixture]
  TTestWatcher = class(TObject)
  private
    fModel: IModel;
    fPolicyManager: IPolicyManager;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure testModelWatcher;

    [Test]
    procedure testPolicyWatcher;
  end;

implementation

uses
  Casbin.Model, Casbin.Policy, Casbin.Model.Sections.Types;

procedure TTestWatcher.SetupFixture;
begin
  fModel:=TModel.Create;
  fPolicyManager:=TPolicyManager.Create;
end;

procedure TTestWatcher.TearDownFixture;
begin
end;


procedure TTestWatcher.testModelWatcher;
var
  watcher: TTestWatcherElement;
begin
  watcher:=TTestWatcherElement.Create('Model Test');
  fModel.registerWatcher(watcher);
  fModel.addDefinition(stRequestDefinition, 'r=1,2,3');
  Assert.AreEqual('Model Test', watcher.&Message);
  fModel.unregisterWatcher(watcher);
//  watcher.Free;
end;

procedure TTestWatcher.testPolicyWatcher;
var
  watcher: TTestWatcherElement;
begin
  watcher:=TTestWatcherElement.Create('Policy Test 1');
  fPolicyManager.registerWatcher(watcher);
  fPolicyManager.addPolicy(stPolicyRules, 'p,1,2,3');
  Assert.AreEqual('Policy Test 1', watcher.&Message, 'Watcher.1');
  fModel.unregisterWatcher(watcher);
//  watcher.Free;

  watcher:=TTestWatcherElement.Create('Policy Test 2');
  fPolicyManager.registerWatcher(watcher);
  fPolicyManager.removePolicy(['p','1','2','3']);
  Assert.AreEqual('Policy Test 2', watcher.&Message, 'Watcher.2');
  fModel.unregisterWatcher(watcher);
//  watcher.Free;
end;

constructor TTestWatcherElement.Create(const aMessage: string);
begin
  inherited Create;
  fInitialMessage:=aMessage;
end;

{ TTestWatcherElement }

procedure TTestWatcherElement.update;
begin
  fMessage:=fInitialMessage;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestWatcher);
end.
