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
unit Tests.Casbin.Resolve;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestCasbinResolve = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testResolveRequest;
    [Test]
    procedure testResolvePolicy;
    [Test]
    procedure testResolveMatcherBasicModel;
    [Test]
    procedure testResolveFunctionIPMatch;
  end;

implementation

uses
  Casbin.Types, Casbin, System.Generics.Collections, Casbin.Resolve.Types,
  Casbin.Model.Sections.Types, Casbin.Resolve, System.Rtti,
  Casbin.Effect.Types, Casbin.Functions.Types, Casbin.Functions;

procedure TTestCasbinResolve.Setup;
begin
end;

procedure TTestCasbinResolve.TearDown;
begin
end;


procedure TTestCasbinResolve.testResolveFunctionIPMatch;
var
  casbin: ICasbin;
  func: IFunctions;
  policy: TList<string>;
  request: TList<string>;
  listRequest: TList<string>;
  listPolicy: TList<string>;
  listMatcher: TList<string>;
  requestDict: TDictionary<string, string>;
  policyDict: TDictionary<string, string>;
  matcherResult: TEffectResult;
begin
  func:=TFunctions.Create;
  request:=TList<string>.Create;
  request.Add('10.0.0.0/16');
  request.Add('data2');
  request.Add('write');

  policy:=TList<string>.Create;
  policy.Add('10.0.0.0/16');
  policy.Add('data2');
  policy.Add('write');

  casbin:=TCasbin.Create('..\..\..\Examples\Default\ipmatch_model.conf',
              '..\..\..\Examples\Default\ipmatch_policy.csv');
  listRequest:=casbin.Model.assertions(stRequestDefinition);
  requestDict:=resolve(request, rtRequest, listRequest);
  listPolicy:=casbin.Model.assertions(stPolicyDefinition);
  policyDict:=resolve(policy, rtPolicy, listPolicy);

  listMatcher:=casbin.Model.assertions(stMatchers);
  if listMatcher.Count>0 then
    matcherResult:=resolve(requestDict, policyDict, func, listMatcher.Items[0])
  else
    matcherResult:=erIndeterminate;

  Assert.AreEqual(erAllow, matcherResult);

  requestDict.Free;
  policyDict.Free;
  policy.Free;
  request.Free;

end;

procedure TTestCasbinResolve.testResolveMatcherBasicModel;
var
  policy: TList<string>;
  request: TList<string>;
  casbin: ICasbin;
  listRequest: TList<string>;
  listPolicy: TList<string>;
  listMatcher: TList<string>;
  requestDict: TDictionary<string, string>;
  policyDict: TDictionary<string, string>;
  matcherResult: TEffectResult;
  func: IFunctions;
begin
  func:=TFunctions.Create;
  request:=TList<string>.Create;
  request.Add('alice');
  request.Add('data1');
  request.Add('read');

  policy:=TList<string>.Create;
  policy.Add('alice');
  policy.Add('data1');
  policy.Add('read');

  casbin:=TCasbin.Create('..\..\..\Examples\Default\basic_model.conf',
              '..\..\..\Examples\Default\basic_policy.csv');
  listRequest:=casbin.Model.assertions(stRequestDefinition);
  requestDict:=resolve(request, rtRequest, listRequest);
  listPolicy:=casbin.Model.assertions(stPolicyDefinition);
  policyDict:=resolve(policy, rtPolicy, listPolicy);

  listMatcher:=casbin.Model.assertions(stMatchers);
  if listMatcher.Count>0 then
    matcherResult:=resolve(requestDict, policyDict, func, listMatcher.Items[0])
  else
    matcherResult:=erIndeterminate;

  Assert.AreEqual(erAllow, matcherResult);

  requestDict.Free;
  policyDict.Free;
  policy.Free;
  request.Free;
end;

procedure TTestCasbinResolve.testResolvePolicy;
var
  casbin: ICasbin;
  dict: TDictionary<string, string>;
  policy: TList<string>;
  list: TList<string>;
begin
  casbin:=TCasbin.Create('..\..\..\Examples\Default\keymatch2_model.conf',
              '..\..\..\Examples\Default\keymatch2_policy.csv');
  list:=casbin.Model.assertions(stPolicyDefinition);
  policy:=TList<string>.Create;
  policy.Add('alice');
  policy.Add('/alice_data/:resource');
  policy.Add('GET');
  dict:=resolve(policy, rtPolicy, list);
  Assert.AreEqual(3, dict.Count);
  Assert.IsTrue(dict.ContainsKey('P.SUB'));
  Assert.AreEqual('ALICE', dict.Items['P.SUB']);

  Assert.IsTrue(dict.ContainsKey('P.OBJ'));
  Assert.AreEqual('/ALICE_DATA/:RESOURCE', dict.Items['P.OBJ']);

  Assert.IsTrue(dict.ContainsKey('P.ACT'));
  Assert.AreEqual('GET', dict.Items['P.ACT']);

  policy.Free;
  dict.Free;
end;

procedure TTestCasbinResolve.testResolveRequest;
var
  casbin: ICasbin;
  dict: TDictionary<string, string>;
  request: TList<string>;
  list: TList<string>;
begin
  casbin:=TCasbin.Create('..\..\..\Examples\Default\basic_model.conf',
              '..\..\..\Examples\Default\basic_policy.csv');
  list:=casbin.Model.assertions(stRequestDefinition);
  request:=TList<string>.Create;
  request.Add('ALICE');
  request.Add('DATA1');
  request.Add('READ');
  dict:=resolve(request, rtRequest, list);
  Assert.AreEqual(3, dict.Count);
  Assert.IsTrue(dict.ContainsKey('R.SUB'));
  Assert.AreEqual('ALICE', dict.Items['R.SUB']);

  Assert.IsTrue(dict.ContainsKey('R.OBJ'));
  Assert.AreEqual('DATA1', dict.Items['R.OBJ']);

  Assert.IsTrue(dict.ContainsKey('R.ACT'));
  Assert.AreEqual('READ', dict.Items['R.ACT']);

  request.Free;
  dict.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCasbinResolve);
end.
