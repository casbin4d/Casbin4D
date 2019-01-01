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
  end;

implementation

uses
  Casbin.Types, Casbin, System.Generics.Collections, Casbin.Resolve.Types,
  Casbin.Model.Sections.Types, Casbin.Resolve, System.Rtti, Casbin.Effect.Types;

procedure TTestCasbinResolve.Setup;
begin
end;

procedure TTestCasbinResolve.TearDown;
begin
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
begin
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
    matcherResult:=resolve(requestDict, policyDict, '', listMatcher.Items[0])
  else
    matcherResult:=erIndeterminate;
  listMatcher.Free;

  Assert.AreEqual(erAllow, matcherResult);

  requestDict.Free;
  policyDict.Free;
  listPolicy.Free;
  listRequest.Free;
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
  Assert.IsTrue(dict.ContainsKey('p.sub'));
  Assert.AreEqual('alice', dict.Items['p.sub']);

  Assert.IsTrue(dict.ContainsKey('p.obj'));
  Assert.AreEqual('/alice_data/:resource', dict.Items['p.obj']);

  Assert.IsTrue(dict.ContainsKey('p.act'));
  Assert.AreEqual('GET', dict.Items['p.act']);

  policy.Free;
  list.Free;
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
  request.Add('alice');
  request.Add('data1');
  request.Add('read');
  dict:=resolve(request, rtRequest, list);
  Assert.AreEqual(3, dict.Count);
  Assert.IsTrue(dict.ContainsKey('r.sub'));
  Assert.AreEqual('alice', dict.Items['r.sub']);

  Assert.IsTrue(dict.ContainsKey('r.obj'));
  Assert.AreEqual('data1', dict.Items['r.obj']);

  Assert.IsTrue(dict.ContainsKey('r.act'));
  Assert.AreEqual('read', dict.Items['r.act']);

  request.Free;
  list.Free;
  dict.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCasbinResolve);
end.
