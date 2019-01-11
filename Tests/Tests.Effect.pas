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
unit Tests.Effect;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestEffect = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testSomeAllow;
    [Test]
    procedure testNotSomeDeny;
    [Test]
    procedure testSomeAllowANDNotDeny;
    [Test]
    procedure testPriorityORDeny;
    [Test]
    procedure testUnknown;
    [Test]
    procedure testEmptyEffects;
  end;

implementation

uses
  Casbin.Effect.Types, Casbin.Effect, System.SysUtils;

procedure TTestEffect.Setup;
begin
end;

procedure TTestEffect.TearDown;
begin
end;

procedure TTestEffect.testEmptyEffects;
begin
  Assert.AreEqual(true, mergeEffects(ecNotSomeDeny, []));
end;

procedure TTestEffect.testNotSomeDeny;
var
  effects: TEffectArray;
begin
  SetLength(effects, 3);

  //Not Some Deny
  effects[0]:=erAllow;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(True, mergeEffects(ecNotSomeDeny, effects), '1');

  effects[0]:=erDeny;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(False, mergeEffects(ecNotSomeDeny, effects), '2');

end;

procedure TTestEffect.testPriorityORDeny;
var
  effects: TEffectArray;
begin
  SetLength(effects, 3);

  effects[0]:=erAllow;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(true, mergeEffects(ecPriorityORDeny, effects), '1');

  effects[0]:=erIndeterminate;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(True, mergeEffects(ecPriorityORDeny, effects), '2');

  effects[0]:=erIndeterminate;
  effects[1]:=erAllow;
  effects[2]:=erDeny;
  Assert.AreEqual(True, mergeEffects(ecPriorityORDeny, effects), '3');

  effects[0]:=erIndeterminate;
  effects[1]:=erDeny;
  effects[2]:=erAllow;
  Assert.AreEqual(False, mergeEffects(ecPriorityORDeny, effects), '4');

  effects[0]:=erAllow;
  effects[1]:=erDeny;
  effects[2]:=erAllow;
  Assert.AreEqual(true, mergeEffects(ecPriorityORDeny, effects), '5');

  effects[0]:=erDeny;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(false, mergeEffects(ecPriorityORDeny, effects), '6');
end;

procedure TTestEffect.testSomeAllow;
var
  effects: TEffectArray;
begin
  SetLength(effects, 3);

  effects[0]:=erAllow;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(True, mergeEffects(ecSomeAllow, effects), '1');

  effects[0]:=erDeny;
  effects[1]:=erDeny;
  effects[2]:=erDeny;
  Assert.AreEqual(False, mergeEffects(ecSomeAllow, effects), '2');

  effects[0]:=erAllow;
  effects[1]:=erDeny;
  effects[2]:=erDeny;
  Assert.AreEqual(True, mergeEffects(ecSomeAllow, effects), '3');

  effects[0]:=erIndeterminate;
  effects[1]:=erDeny;
  effects[2]:=erDeny;
  Assert.AreEqual(false, mergeEffects(ecSomeAllow, effects), '4');

  end;

procedure TTestEffect.testSomeAllowANDNotDeny;
var
  effects: TEffectArray;
begin
  SetLength(effects, 3);

  effects[0]:=erIndeterminate;
  effects[1]:=erIndeterminate;
  effects[2]:=erIndeterminate;
  Assert.AreEqual(False, mergeEffects(ecSomeAllowANDNotDeny, effects), '1');

  effects[0]:=erAllow;
  effects[1]:=erIndeterminate;
  effects[2]:=erIndeterminate;
  Assert.AreEqual(true, mergeEffects(ecSomeAllowANDNotDeny, effects), '2');

  effects[0]:=erAllow;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(true, mergeEffects(ecSomeAllowANDNotDeny, effects), '3');

  effects[0]:=erDeny;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(False, mergeEffects(ecSomeAllowANDNotDeny, effects), '4');

end;

procedure TTestEffect.testUnknown;
var
  proc: TProc;
begin
  proc:=procedure
        begin
          mergeEffects(ecUnknown, []);
        end;
  Assert.WillRaise(proc);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestEffect);
end.
