unit Tests.Casbin.Main;

interface
uses
  DUnitX.TestFramework, Casbin.Types;

type

  [TestFixture]
  TTestCasbin = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testFileConstructor;
    [Test]
    procedure testAdapterConstructor;
    [Test]
    procedure testEnabled;
    [Test]
    [TestCase ('Basic Model.1','..\..\..\Examples\Default\basic_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data1,read#true', '#')]
    [TestCase ('Basic Model.2','..\..\..\Examples\Default\basic_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data1,write#false', '#')]
    [TestCase ('Basic Model.3','..\..\..\Examples\Default\basic_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data2,read#false', '#')]
    [TestCase ('Basic Model.4','..\..\..\Examples\Default\basic_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data2,write#false', '#')]
    [TestCase ('Basic Model.5','..\..\..\Examples\Default\basic_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data1,read#false', '#')]
    [TestCase ('Basic Model.6','..\..\..\Examples\Default\basic_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data1,write#false', '#')]
    [TestCase ('Basic Model.7','..\..\..\Examples\Default\basic_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data2,read#false', '#')]
    [TestCase ('Basic Model.8','..\..\..\Examples\Default\basic_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data2,write#true', '#')]
    procedure testEnforce(const aModelFile, aPolicyFile, aEnforceParams: string;
        const aResult: boolean);
  end;

implementation

uses
  Casbin.Model.Types, Casbin.Policy.Types, Casbin.Model, Casbin.Policy,
  Casbin, SysUtils;

procedure TTestCasbin.Setup;
begin
end;

procedure TTestCasbin.TearDown;
begin
end;


procedure TTestCasbin.testAdapterConstructor;
var
  model: IModel;
  policy: IPolicyManager;
  casbin: ICasbin;
begin
  model:=TModel.Create('..\..\..\Examples\Default\basic_model.conf');
  policy:=TPolicyManager.Create('..\..\..\Examples\Default\basic_policy.csv');
  casbin:=TCasbin.Create(model, policy);
  Assert.IsNotNull(casbin.Logger);
  Assert.IsNotNull(casbin.Model);
  Assert.IsNotNull(casbin.Policy);
  Assert.IsTrue(casbin.Enabled);
end;

procedure TTestCasbin.testEnabled;
var
  casbin: ICasbin;
begin
  casbin:=TCasbin.Create('..\..\..\Examples\Default\basic_model.conf',
              '..\..\..\Examples\Default\basic_policy.csv');
  Assert.IsTrue(casbin.Enabled);
  casbin.Enabled:=False;
  Assert.IsFalse(casbin.Enabled);
end;

procedure TTestCasbin.testEnforce(const aModelFile, aPolicyFile,
    aEnforceParams: string; const aResult: boolean);
var
  params: TEnforceParameters;
  casbin: ICasbin;
begin
  casbin:=TCasbin.Create(aModelFile, aPolicyFile);
  params:=aEnforceParams.Split([',']);
  Assert.AreEqual(aResult, casbin.enforce(params));
end;

procedure TTestCasbin.testFileConstructor;
var
  casbin: ICasbin;
begin
  casbin:=TCasbin.Create('..\..\..\Examples\Default\basic_model.conf',
              '..\..\..\Examples\Default\basic_policy.csv');
  Assert.IsNotNull(casbin.Logger);
  Assert.IsNotNull(casbin.Model);
  Assert.IsNotNull(casbin.Policy);
  Assert.IsTrue(casbin.Enabled);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCasbin);
end.
