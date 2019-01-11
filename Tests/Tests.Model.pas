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
unit Tests.Model;

interface
uses
  DUnitX.TestFramework, Casbin.Model.Types, Casbin.Model.Sections.Types;

type
  [TestFixture]
  TTestModel = class(TObject)
  private
    fModel: IModel;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase ('Request', 'stRequestDefinition')]
    [TestCase ('Policy_Definition', 'stPolicyDefinition')]
    [TestCase ('Effect', 'stPolicyEffect')]
    [TestCase ('Matcher', 'stMatchers')]
    procedure testSections (const aSection: TSectionType);

    [Test]
    [TestCase ('Request', 'stRequestDefinition')]
    [TestCase ('Policy_Definition', 'stPolicyDefinition')]
    [TestCase ('Effect', 'stPolicyEffect')]
    [TestCase ('Matcher', 'stMatchers')]
    procedure testAssertions (const aSection: TSectionType);

    [Test]
    procedure testEffect;

    [Test]
    [TestCase ('Request','r=sub,obj,act#true', '#')]
    [TestCase ('Policy','p=sub,obj,act#true', '#')]
    [TestCase ('Effect','e = some(where (p.eft == allow))', '#')]
    [TestCase ('Matchers','m = r.sub == p.sub && r.obj == p.obj && r.act == p.act#true', '#')]
    procedure testAssertionExists(const aAssertion: string; const aResult: boolean);

    [Test]
    [TestCase ('Request','stRequestDefinition#r#a,b,c', '#')]
    procedure testAddDefinitionFull(const aSection: TSectionType; const aTag:
        string; const aAssertion: string);

    [Test]
    [TestCase ('Request','stRequestDefinition#r=a,b,c', '#')]
    procedure testAddDefinitionCompact(const aSection: TSectionType;
                                                const aAssertion: string);

    [Test]
    procedure testAddWrongAssertionType;

    [Test]
    procedure testAddEmptyAssertion;

    [Test]
    procedure testAddAssertionString;

    [Test]
    procedure testToOutputString;

  end;

implementation

uses
  Casbin.Adapter.Filesystem, Casbin.Model, System.SysUtils,
  System.Generics.Collections, System.Classes, Casbin.Effect.Types;

procedure TTestModel.testAddAssertionString;
begin
  fModel.addDefinition(stRoleDefinition,'g','_,_');
  Assert.AreEqual('[request_definition]'+sLineBreak+
                  'r=sub,obj,act'+sLineBreak+sLineBreak+

                  '[policy_definition]'+sLineBreak+
                  'p=sub,obj,act'+sLineBreak+sLineBreak+

                  '[role_definition]'+sLineBreak+
                  'g=_,_'+sLineBreak+sLineBreak+
                  '[policy_effect]'+sLineBreak+
                  'e=some(where(p.eft==allow))'+sLineBreak+sLineBreak+

                  '[matchers]'+sLineBreak+
            'm = r.sub == p.sub && r.obj == p.obj && r.act == p.act',
                                      Trim(fModel.toOutputString));
end;

procedure TTestModel.testAddDefinitionCompact(const aSection: TSectionType;
  const aAssertion: string);
begin
  fModel.addDefinition(aSection, aAssertion);
  Assert.IsTrue(fModel.assertionExists(Trim(aAssertion)));
end;

procedure TTestModel.testAddDefinitionFull(const aSection: TSectionType; const
    aTag: string; const aAssertion: string);
begin
  fModel.addDefinition(aSection, aTag, aAssertion);
  Assert.IsTrue(fModel.assertionExists(Trim(aTag)+'='+Trim(aAssertion)));
end;

procedure TTestModel.testAddEmptyAssertion;
var
  proc: TProc;
begin
  proc:=procedure
        begin
          fModel.addDefinition(stRequestDefinition, '');
        end;
  Assert.WillRaise(proc);
end;

procedure TTestModel.testAddWrongAssertionType;
var
  proc: TProc;
begin
  proc:=procedure
        begin
          fModel.addDefinition(stUnknown, '');
        end;
  Assert.WillRaise(proc);
end;

procedure TTestModel.Setup;
begin
  fModel:=TModel.Create('..\..\..\Examples\Default\basic_model.conf');
end;

procedure TTestModel.TearDown;
begin
end;


procedure TTestModel.testAssertionExists(const aAssertion: string;
  const aResult: boolean);
begin
  Assert.AreEqual(aResult, fModel.assertionExists(aAssertion));
end;

procedure TTestModel.testAssertions(const aSection: TSectionType);
var
  list: TList<string>;
begin
  list:=fModel.assertions(aSection);
  case aSection of
    stRequestDefinition: begin
                           Assert.AreEqual(3, list.Count);
                           Assert.AreEqual('r.sub', Trim(list.Items[0]));
                           Assert.AreEqual('r.obj', Trim(list.Items[1]));
                           Assert.AreEqual('r.act', Trim(list.Items[2]));
                         end;
    stPolicyDefinition: begin
                           Assert.AreEqual(3, list.Count);
                           Assert.AreEqual('p.sub', Trim(list.Items[0]));
                           Assert.AreEqual('p.obj', Trim(list.Items[1]));
                           Assert.AreEqual('p.act', Trim(list.Items[2]));
                         end;
    stPolicyEffect: begin
                      Assert.AreEqual(1, list.Count);
                      Assert.AreEqual('some(where(p.eft==allow))', Trim(list.Items[0]));
                    end;
    stMatchers: begin
                  Assert.AreEqual(1, list.Count);
      Assert.AreEqual('r.sub == p.sub && r.obj == p.obj && r.act == p.act',
                                      Trim(list.Items[0]));
    end;
  end;
end;

procedure TTestModel.testEffect;
begin
  Assert.AreEqual(ecSomeAllow, fModel.effectCondition);
end;

procedure TTestModel.testSections(const aSection: TSectionType);
var
  expected: string;
begin
  case aSection of
    stRequestDefinition: expected:= 'r=sub,obj,act';
    stPolicyDefinition: expected:= 'p=sub,obj,act';
    stPolicyEffect: expected:= 'e=some(where(p.eft==allow))';
    stMatchers: expected:=
                'm = r.sub == p.sub && r.obj == p.obj && r.act == p.act';
  end;
  Assert.AreEqual(trim(expected), Trim(fModel.Section(aSection)));
end;

procedure TTestModel.testToOutputString;
begin
  Assert.AreEqual('[request_definition]'+sLineBreak+
                  'r=sub,obj,act'+sLineBreak+sLineBreak+

                  '[policy_definition]'+sLineBreak+
                  'p=sub,obj,act'+sLineBreak+sLineBreak+

                  '[policy_effect]'+sLineBreak+
                  'e=some(where(p.eft==allow))'+sLineBreak+sLineBreak+

                  '[matchers]'+sLineBreak+
            'm = r.sub == p.sub && r.obj == p.obj && r.act == p.act',
                                      Trim(fModel.toOutputString));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestModel);
end.
