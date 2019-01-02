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
{$REGION 'Basic Model'}
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
{$ENDREGION}
{$REGION 'TestKeyMatchModel'}
    // From enforce_test.go - TestKeyMatchModelInMemory
    [TestCase ('KeyMatch.Allow.1','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'alice,/alice_data/resource1,GET#true', '#')]
    [TestCase ('KeyMatch.Allow.2','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'alice,/alice_data/resource1,POST#true', '#')]
    [TestCase ('KeyMatch.Allow.3','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'alice,/alice_data/resource2,GET#true', '#')]
    [TestCase ('KeyMatch.Allow.4','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'alice,/alice_data/resource2,POST#false', '#')]

    [TestCase ('KeyMatch.Allow.5','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'alice,/bob_data/resource1,GET#false', '#')]
    [TestCase ('KeyMatch.Allow.6','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'alice,/bob_data/resource1,POST#false', '#')]
    [TestCase ('KeyMatch.Allow.7','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'alice,/bob_data/resource2,GET#false', '#')]
    [TestCase ('KeyMatch.Allow.8','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'alice,/bob_data/resource2,POST#false', '#')]

    [TestCase ('KeyMatch.Allow.9','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'bob,/bob_data/resource1,GET#false', '#')]
    [TestCase ('KeyMatch.Allow.10','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'bob,/bob_data/resource1,POST#true', '#')]
    [TestCase ('KeyMatch.Allow.11','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'bob,/bob_data/resource2,GET#false', '#')]
    [TestCase ('KeyMatch.Allow.12','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'bob,/bob_data/resource2,POST#true', '#')]

    [TestCase ('KeyMatch.Allow.13','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'bob,/alice_data/resource1,GET#false', '#')]
    [TestCase ('KeyMatch.Allow.14','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'bob,/alice_data/resource1,POST#false', '#')]
    [TestCase ('KeyMatch.Allow.15','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'bob,/alice_data/resource2,GET#true', '#')]
    [TestCase ('KeyMatch.Allow.16','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'bob,/alice_data/resource2,POST#false', '#')]

    [TestCase ('KeyMatch.Allow.17','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'cathy,/cathy_data,GET#true', '#')]
    [TestCase ('KeyMatch.Allow.18','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'cathy,/cathy_data,POST#true', '#')]
    [TestCase ('KeyMatch.Allow.19','..\..\..\Examples\Tests\keymatch_model_Allow.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'cathy,/cathy_data,DELETE#false', '#')]
{$ENDREGION}
{$REGION 'TestKeytMatch2Model'}
    // From enforce_test.go - TestKeyMatch2Model
    [TestCase ('KeyMatch2.1','..\..\..\Examples\Default\keymatch2_model.conf#'+
                            '..\..\..\Examples\Default\keymatch2_policy.csv#'+
                            'alice,/alice_data,GET#false', '#')]
    [TestCase ('KeyMatch2.2','..\..\..\Examples\Default\keymatch2_model.conf#'+
                            '..\..\..\Examples\Default\keymatch2_policy.csv#'+
                            'alice,/alice_data/resource1,GET#true', '#')]
    [TestCase ('KeyMatch2.3','..\..\..\Examples\Default\keymatch2_model.conf#'+
                            '..\..\..\Examples\Default\keymatch2_policy.csv#'+
                            'alice,/alice_data2/myid,GET#false', '#')]
    [TestCase ('KeyMatch2.4','..\..\..\Examples\Default\keymatch2_model.conf#'+
                            '..\..\..\Examples\Default\keymatch2_policy.csv#'+
                            'alice,/alice_data2/myid/using/res_id,GET#true', '#')]
{$ENDREGION}
{$REGION 'TestKeyMatchModelDeny'}
    // From enforce_test.go - TestKeyMatchModelInMemoryDeny
    // In the original GO test, it reports the expected value should be true
    // but it must be wrong????? This returns false
    [TestCase ('KeyMatchDeny.1','..\..\..\Examples\Tests\keymatch_model_Deny.conf#'+
                            '..\..\..\Examples\Tests\keymatch_policy.csv#'+
                            'alice,/alice_data/resource2,POST#false', '#')]
{$ENDREGION}
{$REGION 'TestBasicModelWithRoot'}
    // From model_test.go - TestBasicModelWithRoot
    [TestCase ('Basic Model.Root.1','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data1,read#true', '#')]
    [TestCase ('Basic Model.Root.2','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data1,write#false', '#')]
    [TestCase ('Basic Model.Root.3','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data2,read#false', '#')]
    [TestCase ('Basic Model.Root.4','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data2,write#false', '#')]
    [TestCase ('Basic Model.Root.5','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob, data1, read#false', '#')]
    [TestCase ('Basic Model.Root.6','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data1,write#false', '#')]
    [TestCase ('Basic Model.Root.7','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data2,read#false', '#')]
    [TestCase ('Basic Model.Root.8','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data2,write#true', '#')]
    [TestCase ('Basic Model.Root.9','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'root, data1, read#true', '#')]
    [TestCase ('Basic Model.Root.10','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'root,data1,write#true', '#')]
    [TestCase ('Basic Model.Root.11','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'root,data2,read#true', '#')]
    [TestCase ('Basic Model.Root.12','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'root,data2,write#true', '#')]
{$ENDREGION}
{$REGION 'TestBasicModelWithoutUsers'}
    // From model_test.go - TestBasicModelWithoutUsers
    [TestCase ('Basic Model.NoUsers.1','..\..\..\Examples\Default\basic_without_users_model.conf#'+
                            '..\..\..\Examples\Default\basic_without_users_policy.csv#'+
                            'data1,read#true', '#')]
    [TestCase ('Basic Model.NoUsers.2','..\..\..\Examples\Default\basic_without_users_model.conf#'+
                            '..\..\..\Examples\Default\basic_without_users_policy.csv#'+
                            'data1,write#false', '#')]
    [TestCase ('Basic Model.NoUsers.3','..\..\..\Examples\Default\basic_without_users_model.conf#'+
                            '..\..\..\Examples\Default\basic_without_users_policy.csv#'+
                            'data2,read#false', '#')]
    [TestCase ('Basic Model.NoUsers.4','..\..\..\Examples\Default\basic_without_users_model.conf#'+
                            '..\..\..\Examples\Default\basic_without_users_policy.csv#'+
                            'data2,write#true', '#')]
{$ENDREGION}
{$REGION 'TestBasicModelWithoutResources'}
    // From model_test.go - TestBasicModelWithoutResources
    [TestCase ('Basic Model.NoResources.1','..\..\..\Examples\Default\basic_without_resources_model.conf#'+
                            '..\..\..\Examples\Default\basic_without_resources_policy.csv#'+
                            'alice,read#true', '#')]
    [TestCase ('Basic Model.NoResources.2','..\..\..\Examples\Default\basic_without_resources_model.conf#'+
                            '..\..\..\Examples\Default\basic_without_resources_policy.csv#'+
                            'alice,write#false', '#')]
    [TestCase ('Basic Model.NoResources.3','..\..\..\Examples\Default\basic_without_resources_model.conf#'+
                            '..\..\..\Examples\Default\basic_without_resources_policy.csv#'+
                            'bob,read#false', '#')]
    [TestCase ('Basic Model.NoResources.4','..\..\..\Examples\Default\basic_without_resources_model.conf#'+
                            '..\..\..\Examples\Default\basic_without_resources_policy.csv#'+
                            'bob,write#true', '#')]
{$ENDREGION}
{$REGION 'TestIPMatchModel'}
    // From model_test.go - TestIPMatchModel
    [TestCase ('IPMatchModel.1','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.2.123,data1,read#true', '#')]
    [TestCase ('IPMatchModel.2','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.2.123,data1,write#false', '#')]
    [TestCase ('IPMatchModel.3','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.2.123,data2,read#false', '#')]
    [TestCase ('IPMatchModel.4','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.2.123,data2,write#false', '#')]
    [TestCase ('IPMatchModel.5','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.0.123,data1,read#false', '#')]
    [TestCase ('IPMatchModel.6','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.0.123,data1,write#false', '#')]
    [TestCase ('IPMatchModel.7','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.0.123,data2,read#false', '#')]
    [TestCase ('IPMatchModel.8','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.0.123,data2,write#false', '#')]
    [TestCase ('IPMatchModel.9','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '10.0.0.5,data1,read#false', '#')]
    [TestCase ('IPMatchModel.10','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '10.0.0.5,data1,write#false', '#')]
    [TestCase ('IPMatchModel.11','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '10.0.0.5,data2,read#false', '#')]
    [TestCase ('IPMatchModel.12','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '10.0.0.5,data2,write#true', '#')]
    [TestCase ('IPMatchModel.13','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.0.1,data1,read#false', '#')]
    [TestCase ('IPMatchModel.14','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.0.1,data1,write#false', '#')]
    [TestCase ('IPMatchModel.15','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.0.1,data2,read#false', '#')]
    [TestCase ('IPMatchModel.16','..\..\..\Examples\Default\ipmatch_model.conf#'+
                            '..\..\..\Examples\Default\ipmatch_policy.csv#'+
                            '192.168.0.1,data2,write#false', '#')]
{$ENDREGION}
{$REGION 'TestPriorityModel'}
    // From model_test.go - TestPriorityModel
    [TestCase ('PriorityModel.1','..\..\..\Examples\Default\priority_model.conf#'+
                            '..\..\..\Examples\Default\priority_policy.csv#'+
                            'alice,data1,read#true', '#')]
    [TestCase ('PriorityModel.2','..\..\..\Examples\Default\priority_model.conf#'+
                            '..\..\..\Examples\Default\priority_policy.csv#'+
                            'alice,data1,write#false', '#')]
    [TestCase ('PriorityModel.3','..\..\..\Examples\Default\priority_model.conf#'+
                            '..\..\..\Examples\Default\priority_policy.csv#'+
                            'alice,data2,read#false', '#')]
    [TestCase ('PriorityModel.4','..\..\..\Examples\Default\priority_model.conf#'+
                            '..\..\..\Examples\Default\priority_policy.csv#'+
                            'alice,data2,write#false', '#')]
    [TestCase ('PriorityModel.5','..\..\..\Examples\Default\priority_model.conf#'+
                            '..\..\..\Examples\Default\priority_policy.csv#'+
                            'bob,data1,read#false', '#')]
    [TestCase ('PriorityModel.6','..\..\..\Examples\Default\priority_model.conf#'+
                            '..\..\..\Examples\Default\priority_policy.csv#'+
                            'bob,data1,write#false', '#')]
    [TestCase ('PriorityModel.7','..\..\..\Examples\Default\priority_model.conf#'+
                            '..\..\..\Examples\Default\priority_policy.csv#'+
                            'bob,data2,read#true', '#')]
    [TestCase ('PriorityModel.8','..\..\..\Examples\Default\priority_model.conf#'+
                            '..\..\..\Examples\Default\priority_policy.csv#'+
                            'bob,data2,write#false', '#')]
{$ENDREGION}
    // From model_test.go - TestABACModel
//    [TestCase ('ABAC.1','..\..\..\Examples\Default\abac_model.conf#'+
//                            '..\..\..\Examples\Default\basic_without_resources_policy.csv#'+
//                            'alice,read#true', '#')]

    ///////////////////////////////////////////////
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
