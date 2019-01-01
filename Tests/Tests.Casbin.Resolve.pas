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
  end;

implementation

uses
  Casbin.Types, Casbin, System.Generics.Collections, Casbin.Resolve.Types,
  Casbin.Model.Sections.Types, Casbin.Resolve;

procedure TTestCasbinResolve.Setup;
begin
end;

procedure TTestCasbinResolve.TearDown;
begin
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
