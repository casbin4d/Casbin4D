unit Tests.Policy;

interface
uses
  DUnitX.TestFramework, Casbin.Policy.Types;

type

  [TestFixture]
  TTestPolicy = class(TObject)
  private
    fPolicy: IPolicy;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testPolicies;
  end;

implementation

uses
  Casbin.Policy, System.Generics.Collections;

procedure TTestPolicy.Setup;
begin
  fPolicy:=TPolicy.Create('..\..\..\Examples\Default\basic_policy.csv')
end;

procedure TTestPolicy.TearDown;
begin
end;


procedure TTestPolicy.testPolicies;
var
  list: TList<string>;
begin
  list:=fPolicy.policies;
  Assert.AreEqual(2, list.Count, 'Count');
  Assert.AreEqual('p, alice, data1, read', list.Items[0], 'Line 1');
  Assert.AreEqual('p, bob, data2, write', list.Items[1], 'Line 2');
  list.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicy);
end.
