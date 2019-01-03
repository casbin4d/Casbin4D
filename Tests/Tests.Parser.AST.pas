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
unit Tests.Parser.AST;

interface
uses
  DUnitX.TestFramework, Casbin.Parser.AST.Types, Casbin.Effect.Types;

type

  [TestFixture]
  TTestParserAST = class(TObject)
  private
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testRequest;

    [Test]
    procedure testPolicyDefinition;

    [Test]
    procedure testPolicyRules;

    [Test]
    procedure testRoleDefinition;

    [Test]
    procedure testMatchers;
    [Test]
    [TestCase('ecSomeAllow.Go','e=some(where(p.eft==allow))#ecSomeAllow','#')]
    [TestCase('ecSomeAllow.Delphi','e=some(where(p.eft=allow))#ecSomeAllow','#')]
    [TestCase('ecSomeAllow With Underscore.Go','e=some(where(p_eft==allow))#ecSomeAllow','#')]
    [TestCase('ecSomeAllow With Underscore.Delphi','e=some(where(p_eft=allow))#ecSomeAllow','#')]
    [TestCase('ecNotSomeDeny.Go','e=!some(where(p.eft==deny))#ecNotSomeDeny','#')]
    [TestCase('ecNotSomeDeny.Delphi','e=not(some(where(p.eft=deny)))#ecNotSomeDeny','#')]
    [TestCase('ecSomeAllowANDNotDeny.Go','e=some(where(p.eft==allow))&&!some(where(p.eft==deny))#'+
                                  'ecSomeAllowANDNotDeny','#')]
    [TestCase('ecSomeAllowANDNotDeny.Delphi','e=some(where(p.eft=allow))and(not(some(where(p.eft=deny))))#'+
                                  'ecSomeAllowANDNotDeny','#')]
    [TestCase('ecPriorityORDeny.Go','e=priority(p.eft)||deny#ecPriorityORDeny','#')]
    [TestCase('ecPriorityORDeny.Delphi','e=priority(p.eft)ordeny#ecPriorityORDeny','#')]
    [TestCase('ecUnknown','e=a new type#ecUnknown','#')]
    procedure testEffects(const aInput: string; const aResult: TEffectCondition);
  end;

implementation

uses
  Casbin.Parser.AST, Casbin.Model.Sections.Types, Winapi.Windows;

procedure TTestParserAST.Setup;
begin
end;

procedure TTestParserAST.TearDown;
begin
end;

procedure TTestParserAST.testMatchers;
var
  header: THeaderNode;
 begin
  header:=THeaderNode.Create;
  header.SectionType:=stMatchers;
  addAssertion(header, 'm=r.sub==p.sub&&r.act==p.act');
  Assert.IsTrue(header.ChildNodes.Count = 1);

  Assert.AreEqual('m', header.ChildNodes.Items[0].Key);
  Assert.AreEqual('r.sub==p.sub&&r.act==p.act', header.ChildNodes.Items[0].Value);

  header.Free;
end;


procedure TTestParserAST.testPolicyDefinition;
var
  header: THeaderNode;
begin
  header:=THeaderNode.Create;
  header.SectionType:=stPolicyDefinition;
  addAssertion(header, 'p=sub,obj,act');
  Assert.IsTrue(header.ChildNodes.Count = 1);
  Assert.IsTrue(header.ChildNodes.Items[0].AssertionList.Count=3);

  Assert.AreEqual('p', header.ChildNodes.Items[0].AssertionList.Items[0].Key);
  Assert.AreEqual('sub', header.ChildNodes.Items[0].AssertionList.Items[0].Value);

  Assert.AreEqual('p', header.ChildNodes.Items[0].AssertionList.Items[1].Key);
  Assert.AreEqual('obj', header.ChildNodes.Items[0].AssertionList.Items[1].Value);

  Assert.AreEqual('p', header.ChildNodes.Items[0].AssertionList.Items[2].Key);
  Assert.AreEqual('act', header.ChildNodes.Items[0].AssertionList.Items[2].Value);

  header.Free;
end;

procedure TTestParserAST.testPolicyRules;
var
  header: THeaderNode;
begin
  header:=THeaderNode.Create;
  header.SectionType:=stPolicyRules;
  addAssertion(header, 'p,alice,data1, domain, read');
  Assert.IsTrue(header.ChildNodes.Count = 1);
  Assert.IsTrue(header.ChildNodes.Items[0].AssertionList.Count=4);

  Assert.AreEqual('p', header.ChildNodes.Items[0].AssertionList.Items[0].Key);
  Assert.AreEqual('alice', header.ChildNodes.Items[0].AssertionList.Items[0].Value);

  Assert.AreEqual('p', header.ChildNodes.Items[0].AssertionList.Items[1].Key);
  Assert.AreEqual('data1', header.ChildNodes.Items[0].AssertionList.Items[1].Value);

  Assert.AreEqual('p', header.ChildNodes.Items[0].AssertionList.Items[2].Key);
  Assert.AreEqual('domain', header.ChildNodes.Items[0].AssertionList.Items[2].Value);

  Assert.AreEqual('p', header.ChildNodes.Items[0].AssertionList.Items[3].Key);
  Assert.AreEqual('read', header.ChildNodes.Items[0].AssertionList.Items[3].Value);

  header.Free;
end;

procedure TTestParserAST.testRequest;
var
  header: THeaderNode;
begin
  header:=THeaderNode.Create;
  header.SectionType:=stRequestDefinition;
  addAssertion(header, 'r=sub,obj,act');
  Assert.IsTrue(header.ChildNodes.Count = 1);
  Assert.IsTrue(header.ChildNodes.Items[0].AssertionList.Count = 3);

  Assert.AreEqual('r', header.ChildNodes.Items[0].AssertionList.Items[0].Key);
  Assert.AreEqual('sub', header.ChildNodes.Items[0].AssertionList.Items[0].Value);

  Assert.AreEqual('r', header.ChildNodes.Items[0].AssertionList.Items[1].Key);
  Assert.AreEqual('obj', header.ChildNodes.Items[0].AssertionList.Items[1].Value);

  Assert.AreEqual('r', header.ChildNodes.Items[0].AssertionList.Items[2].Key);
  Assert.AreEqual('act', header.ChildNodes.Items[0].AssertionList.Items[2].Value);

{$IFDEF DEBUG}
  OutputDebugString(PChar(header.toOutputString));
{$ENDIF}

  header.Free;

end;

procedure TTestParserAST.testRoleDefinition;
var
  header: THeaderNode;
 begin
  header:=THeaderNode.Create;
  header.SectionType:=stRoleDefinition;
  addAssertion(header, 'g=_,_');
  Assert.IsTrue(header.ChildNodes.Count = 1);

  Assert.AreEqual('g', header.ChildNodes.Items[0].Key);
  Assert.AreEqual('_,_', header.ChildNodes.Items[0].Value);

  header.Free;

  header:=THeaderNode.Create;
  header.SectionType:=stRoleDefinition;
  addAssertion(header, 'g2=_,_,_');
  Assert.IsTrue(header.ChildNodes.Count = 1);

  Assert.AreEqual('g2', header.ChildNodes.Items[0].Key);
  Assert.AreEqual('_,_,_', header.ChildNodes.Items[0].Value);

  header.Free;
end;

procedure TTestParserAST.testEffects(const aInput: string; const aResult:
    TEffectCondition);
var
  header: THeaderNode;
begin
  header:=THeaderNode.Create;
  header.SectionType:=stPolicyEffect;
  addAssertion(header, aInput);

  Assert.AreEqual(aResult,
                   (header.ChildNodes.Items[0] as TEffectNode).EffectCondition);

  header.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestParserAST);
end.
