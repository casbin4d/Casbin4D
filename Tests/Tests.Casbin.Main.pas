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
    procedure testMemoryConstructor;
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
{$REGION 'Indeterminate'}
    [TestCase ('Indeterminate.1','..\..\..\Examples\Default\priority_model.conf#'+
                            '..\..\..\Examples\Default\priority_indeterminate_policy.csv#'+
                            'alice,data1,read#false', '#')]
{$ENDREGION}
{$REGION 'TestBasicModelNoPolicy'}
    // From model_test.go - TestBasicModelNoPolicy
    [TestCase ('TestBasicModelNoPolicy.1','..\..\..\Examples\Default\basic_model.conf#'+
                            '#'+
                            'alice,data1,read#false', '#')]
    [TestCase ('TestBasicModelNoPolicy.2','..\..\..\Examples\Default\basic_model.conf#'+
                            '#'+
                            'alice,data1,write#false', '#')]
    [TestCase ('TestBasicModelNoPolicy.3','..\..\..\Examples\Default\basic_model.conf#'+
                            '#'+
                            'alice,data2,read#false', '#')]
    [TestCase ('TestBasicModelNoPolicy.4','..\..\..\Examples\Default\basic_model.conf#'+
                            '#'+
                            'alice,data2,write#false', '#')]
    [TestCase ('TestBasicModelNoPolicy.5','..\..\..\Examples\Default\basic_model.conf#'+
                            '#'+
                            'bob,data1,read#false', '#')]
    [TestCase ('TestBasicModelNoPolicy.6','..\..\..\Examples\Default\basic_model.conf#'+
                            '#'+
                            'bob,data1,write#false', '#')]
    [TestCase ('TestBasicModelNoPolicy.7','..\..\..\Examples\Default\basic_model.conf#'+
                            '#'+
                            'bob,data2,read#false', '#')]
    [TestCase ('TestBasicModelNoPolicy.8','..\..\..\Examples\Default\basic_model.conf#'+
                            '#'+
                            'bob,data2,write#false', '#')]
{$ENDREGION}
{$REGION 'TestBasicModelWithRootNoPolicy'}
    // From model_test.go - TestBasicModelWithRootNoPolicy
    [TestCase ('TestBasicModelWithRootNoPolicy.1','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'alice,data1,read#false', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.2','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'alice,data1,write#false', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.3','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'alice,data2,read#false', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.4','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'alice,data2,write#false', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.5','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'bob,data1,read#false', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.6','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'bob,data1,write#false', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.7','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'bob,data2,read#false', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.8','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'bob,data2,write#false', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.9','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'root,data1,read#true', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.10','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'root,data1,write#true', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.11','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'root,data2,read#true', '#')]
    [TestCase ('TestBasicModelWithRootNoPolicy.12','..\..\..\Examples\Default\basic_with_root_model.conf#'+
                            '#'+
                            'root,data2,write#true', '#')]
{$ENDREGION}
{$REGION 'TestRBACModel'}
    // From model_test.go - TestRBACModel
    [TestCase ('TestRBACModel.1','..\..\..\Examples\Default\rbac_model.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'alice,data1,read#true', '#')]
    [TestCase ('TestRBACModel.2','..\..\..\Examples\Default\rbac_model.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'alice,data1,write#false', '#')]
    [TestCase ('TestRBACModel.3','..\..\..\Examples\Default\rbac_model.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'alice,data2,read#true', '#')]
    [TestCase ('TestRBACModel.4','..\..\..\Examples\Default\rbac_model.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'alice,data2,write#true', '#')]
    [TestCase ('TestRBACModel.5','..\..\..\Examples\Default\rbac_model.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'bob,data1,read#false', '#')]
    [TestCase ('TestRBACModel.6','..\..\..\Examples\Default\rbac_model.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'bob,data1,write#false', '#')]
    [TestCase ('TestRBACModel.7','..\..\..\Examples\Default\rbac_model.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'bob,data2,read#false', '#')]
    [TestCase ('TestRBACModel.8','..\..\..\Examples\Default\rbac_model.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'bob,data2,write#true', '#')]
{$ENDREGION}
{$REGION 'TestRBACModelWithResourcesRoles'}
    // From model_test.go - TestRBACModelWithResourcesRoles
    [TestCase ('TestRBACModelWithResourcesRoles.1','..\..\..\Examples\Default\rbac_with_resource_roles_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_resource_roles_policy.csv#'+
                            'alice,data1,read#true', '#')]
    [TestCase ('TestRBACModelWithResourcesRoles.2','..\..\..\Examples\Default\rbac_with_resource_roles_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_resource_roles_policy.csv#'+
                            'alice,data1,write#true', '#')]
    [TestCase ('TestRBACModelWithResourcesRoles.3','..\..\..\Examples\Default\rbac_with_resource_roles_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_resource_roles_policy.csv#'+
                            'alice,data2,read#false', '#')]
    [TestCase ('TestRBACModelWithResourcesRoles.4','..\..\..\Examples\Default\rbac_with_resource_roles_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_resource_roles_policy.csv#'+
                            'alice,data2,write#true', '#')]
    [TestCase ('TestRBACModelWithResourcesRoles.5','..\..\..\Examples\Default\rbac_with_resource_roles_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_resource_roles_policy.csv#'+
                            'bob,data1,read#false', '#')]
    [TestCase ('TestRBACModelWithResourcesRoles.6','..\..\..\Examples\Default\rbac_with_resource_roles_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_resource_roles_policy.csv#'+
                            'bob,data1,write#false', '#')]
    [TestCase ('TestRBACModelWithResourcesRoles.7','..\..\..\Examples\Default\rbac_with_resource_roles_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_resource_roles_policy.csv#'+
                            'bob,data2,read#false', '#')]
    [TestCase ('TestRBACModelWithResourcesRoles.8','..\..\..\Examples\Default\rbac_with_resource_roles_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_resource_roles_policy.csv#'+
                            'bob,data2,write#true', '#')]
{$ENDREGION}
{$REGION 'RBACModelWithOnlyDeny'}
    // From model_test.go - RBACModelWithOnlyDeny
    [TestCase ('TestRBACModelWithOnlyDeny.1','..\..\..\Examples\Default\rbac_with_not_deny_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_deny_policy.csv#'+
                            'alice,data2,write#false', '#')]
{$ENDREGION}
//{$REGION 'TestRBACModelWithPatern'}
//    // From model_test.go - TestRBACModelWithPatern
//    [TestCase ('TestRBACModelWithPatern.1','..\..\..\Examples\Default\rbac_with_pattern_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_pattern_policy.csv#'+
//                            'alice,/book/1,GET#true', '#')]
//    [TestCase ('TestRBACModelWithPatern.2','..\..\..\Examples\Default\rbac_with_pattern_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_pattern_policy.csv#'+
//                            'alice,/book/2,GET#true', '#')]
//    [TestCase ('TestRBACModelWithPatern.3','..\..\..\Examples\Default\rbac_with_pattern_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_pattern_policy.csv#'+
//                            'alice,/pen/1,GET#true', '#')]
//    [TestCase ('TestRBACModelWithPatern.4','..\..\..\Examples\Default\rbac_with_pattern_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_pattern_policy.csv#'+
//                            'alice,/pen/2,GET#false', '#')]
//    [TestCase ('TestRBACModelWithPatern.5','..\..\..\Examples\Default\rbac_with_pattern_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_pattern_policy.csv#'+
//                            'bob,/book/1,GET#false', '#')]
//    [TestCase ('TestRBACModelWithPatern.6','..\..\..\Examples\Default\rbac_with_pattern_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_pattern_policy.csv#'+
//                            'bob,/book/2,GET#false', '#')]
//    [TestCase ('TestRBACModelWithPatern.7','..\..\..\Examples\Default\rbac_with_pattern_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_pattern_policy.csv#'+
//                            'bob,/pen/1,GET#true', '#')]
//    [TestCase ('TestRBACModelWithPatern.8','..\..\..\Examples\Default\rbac_with_pattern_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_pattern_policy.csv#'+
//                            'bob,/pen/2,GET#true', '#')]
//{$ENDREGION}
{$REGION 'TestRBACModelWithDomains'}
    // From model_test.go - TestRBACModelWithDomains
    [TestCase ('TestRBACModelWithDomains.1','..\..\..\Examples\Default\rbac_with_domains_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_domains_policy.csv#'+
                            'alice,domain1,data1,read#true', '#')]
    [TestCase ('TestRBACModelWithDomains.2','..\..\..\Examples\Default\rbac_with_domains_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_domains_policy.csv#'+
                            'alice,domain1,data1,write#true', '#')]
    [TestCase ('TestRBACModelWithDomains.3','..\..\..\Examples\Default\rbac_with_domains_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_domains_policy.csv#'+
                            'alice,domain1,data2,read#false', '#')]
    [TestCase ('TestRBACModelWithDomains.4','..\..\..\Examples\Default\rbac_with_domains_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_domains_policy.csv#'+
                            'alice,domain2,data2,write#false', '#')]
    [TestCase ('TestRBACModelWithDomains.5','..\..\..\Examples\Default\rbac_with_domains_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_domains_policy.csv#'+
                            'bob,domain2,data1,read#false', '#')]
    [TestCase ('TestRBACModelWithDomains.6','..\..\..\Examples\Default\rbac_with_domains_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_domains_policy.csv#'+
                            'bob,domain2,data1,write#false', '#')]
    [TestCase ('TestRBACModelWithDomains.7','..\..\..\Examples\Default\rbac_with_domains_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_domains_policy.csv#'+
                            'bob,domain2,data2,read#true', '#')]
    [TestCase ('TestRBACModelWithDomains.8','..\..\..\Examples\Default\rbac_with_domains_model.conf#'+
                            '..\..\..\Examples\Default\rbac_with_domains_policy.csv#'+
                            'bob,domain2,data2,write#true', '#')]
{$ENDREGION}
//{$REGION 'TestRBACModelWithDeny'}
//    // From model_test.go - TestRBACModelWithDeny
//    [TestCase ('TestRBACModelWithDeny.1','..\..\..\Examples\Default\rbac_with_deny_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_deny_policy.csv#'+
//                            'alice,data1,read#true', '#')]
//    [TestCase ('TestRBACModelWithDeny.2','..\..\..\Examples\Default\rbac_with_deny_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_deny_policy.csv#'+
//                            'alice,data1,write#false', '#')]
//    [TestCase ('TestRBACModelWithDeny.3','..\..\..\Examples\Default\rbac_with_deny_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_deny_policy.csv#'+
//                            'alice,data2,read#true', '#')]
//    [TestCase ('TestRBACModelWithDeny.4','..\..\..\Examples\Default\rbac_with_deny_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_deny_policy.csv#'+
//                            'alice,data2,write#false', '#')]
//    [TestCase ('TestRBACModelWithDeny.5','..\..\..\Examples\Default\rbac_with_deny_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_deny_policy.csv#'+
//                            'bob,data1,read#false', '#')]
//    [TestCase ('TestRBACModelWithDeny.6','..\..\..\Examples\Default\rbac_with_deny_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_deny_policy.csv#'+
//                            'bob,data1,write#false', '#')]
//    [TestCase ('TestRBACModelWithDeny.7','..\..\..\Examples\Default\rbac_with_deny_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_deny_policy.csv#'+
//                            'bob,data2,read#false', '#')]
//    [TestCase ('TestRBACModelWithDeny.8','..\..\..\Examples\Default\rbac_with_deny_model.conf#'+
//                            '..\..\..\Examples\Default\rbac_with_deny_policy.csv#'+
//                            'bob,data2,write#true', '#')]
//{$ENDREGION}
{$REGION 'TestRBACModelInMultiLines'}
    // From model_test.go - TestRBACModelInMultiLines
    [TestCase ('TestRBACModelInMultiLines.1','..\..\..\Examples\Default\rbac_model_in_multi_line.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'alice,data1,read#true', '#')]
    [TestCase ('TestRBACModelInMultiLines.2','..\..\..\Examples\Default\rbac_model_in_multi_line.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'alice,data1,write#false', '#')]
    [TestCase ('TestRBACModelInMultiLines.3','..\..\..\Examples\Default\rbac_model_in_multi_line.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'alice,data2,read#true', '#')]
    [TestCase ('TestRBACModelInMultiLines.4','..\..\..\Examples\Default\rbac_model_in_multi_line.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'alice,data2,write#true', '#')]
    [TestCase ('TestRBACModelInMultiLines.5','..\..\..\Examples\Default\rbac_model_in_multi_line.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'bob,data1,read#false', '#')]
    [TestCase ('TestRBACModelInMultiLines.6','..\..\..\Examples\Default\rbac_model_in_multi_line.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'bob,data1,write#false', '#')]
    [TestCase ('TestRBACModelInMultiLines.7','..\..\..\Examples\Default\rbac_model_in_multi_line.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'bob,data2,read#false', '#')]
    [TestCase ('TestRBACModelInMultiLines.8','..\..\..\Examples\Default\rbac_model_in_multi_line.conf#'+
                            '..\..\..\Examples\Default\rbac_policy.csv#'+
                            'bob,data2,write#true', '#')]
{$ENDREGION}
    ///////////////////////////////////////////////
    procedure testEnforce(const aModelFile, aPolicyFile, aEnforceParams: string;
        const aResult: boolean);

    [Test]
{$REGION 'TestABACModel'}
    // From model_test.go - TestABACModel
    [TestCase ('ABAC.1','..\..\..\Examples\Default\abac_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data1,read#alice#true', '#')]
    [TestCase ('ABAC.2','..\..\..\Examples\Default\abac_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data1,write#alice#true', '#')]
    [TestCase ('ABAC.3','..\..\..\Examples\Default\abac_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data2,read#bob#false', '#')]
    [TestCase ('ABAC.4','..\..\..\Examples\Default\abac_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'alice,data2,write#bob#false', '#')]
    [TestCase ('ABAC.5','..\..\..\Examples\Default\abac_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data1,read#alice#false', '#')]
    [TestCase ('ABAC.6','..\..\..\Examples\Default\abac_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data1,write#alice#false', '#')]
    [TestCase ('ABAC.7','..\..\..\Examples\Default\abac_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data2,read#bob#true', '#')]
    [TestCase ('ABAC.8','..\..\..\Examples\Default\abac_model.conf#'+
                            '..\..\..\Examples\Default\basic_policy.csv#'+
                            'bob,data2,write#bob#true', '#')]
{$ENDREGION}
    ///////////////////////////////////////////////
    procedure testEnforceABAC(const aModelFile, aPolicyFile, aEnforceParams: string;
        const aOwner: string; const aResult: boolean);

    [Test]
    ///////////////////////////////////////////////
    procedure testEnforceRBACInMemoryIndeterminate;

    [Test]
{$REGION 'RBACModelInMemory'}
    // From enforcer_test.go - TestRBACModelInMemory
    [TestCase ('RBACInMemory.1', 'alice,data1,read#true', '#')]
    [TestCase ('RBACInMemory.2', 'alice,data1,write#false', '#')]
    [TestCase ('RBACInMemory.3', 'alice,data2,read#true', '#')]
    [TestCase ('RBACInMemory.4', 'alice,data2,write#true', '#')]
    [TestCase ('RBACInMemory.5', 'bob,data1,read#false', '#')]
    [TestCase ('RBACInMemory.6', 'bob,data1,write#false', '#')]
    [TestCase ('RBACInMemory.7', 'bob,data2,read#false', '#')]
    [TestCase ('RBACInMemory.8', 'bob,data2,write#true', '#')]
{$ENDREGION}
    ///////////////////////////////////////////////
    procedure testEnforceRBACModelInMemory (const aEnforceParams: string;
                              const aResult: Boolean);
{$REGION 'RBACModelInMemory2'}
    // From enforcer_test.go - TestRBACModelInMemory2
    [TestCase ('RBACInMemory2.1', 'alice,data1,read#true', '#')]
    [TestCase ('RBACInMemory2.2', 'alice,data1,write#false', '#')]
    [TestCase ('RBACInMemory2.3', 'alice,data2,read#true', '#')]
    [TestCase ('RBACInMemory2.4', 'alice,data2,write#true', '#')]
    [TestCase ('RBACInMemory2.5', 'bob,data1,read#false', '#')]
    [TestCase ('RBACInMemory2.6', 'bob,data1,write#false', '#')]
    [TestCase ('RBACInMemory2.7', 'bob,data2,read#false', '#')]
    [TestCase ('RBACInMemory2.8', 'bob,data2,write#true', '#')]
{$ENDREGION}
    ///////////////////////////////////////////////
    procedure testEnforceRBACModelInMemory2 (const aEnforceParams: string;
                              const aResult: Boolean);
{$REGION 'NotUsedRBACModelInMemory'}
    // From enforcer_test.go - TestNotUsedRBACModelInMemory
    [TestCase ('NotUsedRBACModelInMemory.1', 'alice,data1,read#true', '#')]
    [TestCase ('NotUsedRBACModelInMemory.2', 'alice,data1,write#false', '#')]
    [TestCase ('NotUsedRBACModelInMemory.3', 'alice,data2,read#false', '#')]
    [TestCase ('NotUsedRBACModelInMemory.4', 'alice,data2,write#false', '#')]
    [TestCase ('NotUsedRBACModelInMemory.5', 'bob,data1,read#false', '#')]
    [TestCase ('NotUsedRBACModelInMemory.6', 'bob,data1,write#false', '#')]
    [TestCase ('NotUsedRBACModelInMemory.7', 'bob,data2,read#false', '#')]
    [TestCase ('NotUsedRBACModelInMemory.8', 'bob,data2,write#true', '#')]
{$ENDREGION}
    ///////////////////////////////////////////////
    procedure testEnforceNotUsedRBACModelInMemory (const aEnforceParams: string;
                              const aResult: Boolean);

    [Test]
    // From model_test.go - TestRBACModelWithDomainsAtRuntime
    ///////////////////////////////////////////////
    procedure testEnforceRBACModelWithDomainsAtRuntime (const aEnforceParams: string;
                              const aResult: Boolean);


    [Test]
    // From enforcer_test.go - TestEnableEnforce
    ///////////////////////////////////////////////
    procedure testEnableEnforce;

    [Test]
    // From enforcer_test.go - TestGetAndSetModel
    ///////////////////////////////////////////////
    procedure testGetAndSetModel;

    [Test]
    // From enforcer_test.go - TestGetAndSetAdapterInMem
    ///////////////////////////////////////////////
    procedure testGetAndSetAdapterInMem;

    [Test]
    // From enforcer_test.go - TestSetAdapterFromFile
    ///////////////////////////////////////////////
    procedure testGetAndSetAAdapterFromFile;

    [Test]
    // From enforcer_test.go - TestInitEmpty
    ///////////////////////////////////////////////
    procedure testInitEmpty;
  end;

implementation

uses
  Casbin.Model.Types, Casbin.Policy.Types, Casbin.Model, Casbin.Policy,
  Casbin, SysUtils, Casbin.Model.Sections.Types, Casbin.Adapter.Types, Casbin.Adapter.Filesystem, Casbin.Adapter.Policy.Types,
  Casbin.Adapter.Filesystem.Policy, Casbin.Core.Base.Types;

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
  casbin:=nil;
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
  casbin:=nil;
end;

procedure TTestCasbin.testEnableEnforce;
var
  casbin: ICasbin;
begin
  casbin:=TCasbin.Create('..\..\..\Examples\Default\basic_model.conf',
              '..\..\..\Examples\Default\basic_policy.csv');
  casbin.Enabled:=False;

  Assert.IsTrue(casbin.enforce(['alice','data1','read']));
  Assert.IsTrue(casbin.enforce(['alice','data1','write']));
  Assert.IsTrue(casbin.enforce(['alice','data2','read']));
  Assert.IsTrue(casbin.enforce(['alice','data2','write']));
  Assert.IsTrue(casbin.enforce(['bob','data1','read']));
  Assert.IsTrue(casbin.enforce(['bob','data1','write']));
  Assert.IsTrue(casbin.enforce(['bob','data2','read']));
  Assert.IsTrue(casbin.enforce(['bob','data2','write']));

  casbin.Enabled:=True;

  Assert.IsTrue(casbin.enforce(['alice','data1','read']));
  Assert.IsFalse(casbin.enforce(['alice','data1','write']));
  Assert.IsFalse(casbin.enforce(['alice','data2','read']));
  Assert.IsFalse(casbin.enforce(['alice','data2','write']));
  Assert.IsFalse(casbin.enforce(['bob','data1','read']));
  Assert.IsFalse(casbin.enforce(['bob','data1','write']));
  Assert.IsFalse(casbin.enforce(['bob','data2','read']));
  Assert.IsTrue(casbin.enforce(['bob','data2','write']));

  casbin:=nil;
end;

procedure TTestCasbin.testEnforce(const aModelFile, aPolicyFile,
    aEnforceParams: string; const aResult: boolean);
var
  params: TEnforceParameters;
  casbin: ICasbin;
begin
  casbin:=TCasbin.Create(aModelFile, aPolicyFile);
  params:=TFilterArray(aEnforceParams.Split([',']));
  Assert.AreEqual(aResult, casbin.enforce(params));
  casbin:=nil;
end;

procedure TTestCasbin.testEnforceABAC(const aModelFile, aPolicyFile,
  aEnforceParams, aOwner: string; const aResult: boolean);
var
  params: TEnforceParameters;
  casbin: ICasbin;
begin
  casbin:=TCasbin.Create(aModelFile, aPolicyFile);
  params:=TFilterArray(aEnforceParams.Split([',']));
  Assert.AreEqual(aResult, casbin.enforce(params, aOwner));
  casbin:=nil;
end;

procedure TTestCasbin.testEnforceNotUsedRBACModelInMemory(
  const aEnforceParams: string; const aResult: Boolean);
var
  model: IModel;
  casbin: ICasbin;
begin
  model:=TModel.Create;
  model.addDefinition(stRequestDefinition, 'r=sub,obj, act');
  model.addDefinition(stPolicyDefinition, 'p', 'sub,obj,act');
  model.addDefinition(stRoleDefinition,'g', '_,_');
  model.addDefinition(stPolicyEffect, 'e','some(where (p.eft == allow))');
  model.addDefinition(stMatchers,'m',
                      'g(r.sub, p.sub) && r.obj==p.obj && r.act==p.act');

  casbin:=TCasbin.Create(model, '');
  casbin.Policy.addPolicy(stPolicyRules,'p','alice,data1,read');
  casbin.Policy.addPolicy(stPolicyRules,'p','bob,data2, write');

  Assert.AreEqual(aResult, casbin.enforce(TFilterArray(aEnforceParams.Split([',']))));
end;

procedure TTestCasbin.testEnforceRBACInMemoryIndeterminate;
var
  model: IModel;
  casbin: ICasbin;
begin
  model:=TModel.Create;
  model.addDefinition(stRequestDefinition, 'r=sub,obj, act');
  model.addDefinition(stPolicyDefinition, 'p', 'sub,obj,act');
  model.addDefinition(stRoleDefinition,'g', '_,_');
  model.addDefinition(stPolicyEffect, 'e','some(where (p.eft == allow))');
  model.addDefinition(stMatchers,'m',
                      'g(r.sub, p.sub) && r.obj==p.obj && r.act==p.act');
  casbin:=TCasbin.Create(model, '');
  casbin.Policy.addPolicy(stPolicyRules,'p','alice,data1,invalid');

  Assert.IsFalse(casbin.enforce(['alice','data1','read']));
end;

procedure TTestCasbin.testEnforceRBACModelInMemory(const aEnforceParams: string;
  const aResult: Boolean);
var
  model: IModel;
  casbin: ICasbin;
begin
  model:=TModel.Create;
  model.addDefinition(stRequestDefinition, 'r=sub,obj, act');
  model.addDefinition(stPolicyDefinition, 'p', 'sub,obj,act');
  model.addDefinition(stRoleDefinition,'g', '_,_');
  model.addDefinition(stPolicyEffect, 'e','some(where (p.eft == allow))');
  model.addDefinition(stMatchers,'m',
                      'g(r.sub, p.sub) && r.obj==p.obj && r.act==p.act');

  casbin:=TCasbin.Create(model, '');
  casbin.Policy.addPolicy(stPolicyRules,'p','alice,data1,read');
  casbin.Policy.addPolicy(stPolicyRules,'p','bob,data2, write');
  casbin.Policy.addPolicy(stPolicyRules,'p','data2_admin,data2,read');
  casbin.Policy.addPolicy(stPolicyRules,'p','data2_admin,data2,write');

  casbin.Policy.addPolicy(stRoleRules,'g','alice, data2_admin');
  // You may be tempted to write this:
  // casbin.Policy.addLink('alice', 'data2_admin');
  // **** BUT YOU SHOULDN'T ****
  // Always, add roles using AddPolicy as in the example

  Assert.AreEqual(aResult, casbin.enforce(TFilterArray(aEnforceParams.Split([',']))));
end;

procedure TTestCasbin.testEnforceRBACModelInMemory2(
  const aEnforceParams: string; const aResult: Boolean);
var
  model: IModel;
  casbin: ICasbin;
begin
  model:=TModel.Create;
  model.addModel('[request_definition]'+sLineBreak+
                 'r = sub, obj, act'+sLineBreak+

                 '[policy_definition]'+sLineBreak+
                 'p = sub, obj, act'+sLineBreak+

                 '[role_definition]'+sLineBreak+
                 'g = _, _'+sLineBreak+

                 '[policy_effect]'+sLineBreak+
                 'e = some(where (p.eft == allow))'+sLineBreak+

                 '[matchers]'+sLineBreak+
     ' m = g(r.sub, p.sub) && r.obj == p.obj && r.act == p.act');

  casbin:=TCasbin.Create(model, '');
  casbin.Policy.addPolicy(stPolicyRules,'p','alice,data1,read');
  casbin.Policy.addPolicy(stPolicyRules,'p','bob,data2, write');
  casbin.Policy.addPolicy(stPolicyRules,'p','data2_admin,data2,read');
  casbin.Policy.addPolicy(stPolicyRules,'p','data2_admin,data2,write');

  casbin.Policy.addPolicy(stRoleRules,'g','alice, data2_admin');
  // You may be tempted to write this:
  // casbin.Policy.addLink('alice', 'data2_admin');
  // **** BUT YOU SHOULDN'T ****
  // Always, add roles using AddPolicy as in the example

  Assert.AreEqual(aResult, casbin.enforce(TFilterArray(aEnforceParams.Split([',']))));
end;

procedure TTestCasbin.testEnforceRBACModelWithDomainsAtRuntime(
  const aEnforceParams: string; const aResult: Boolean);
var
  casbin: ICasbin;
begin
  casbin:=TCasbin.Create('..\..\..\Examples\Default\rbac_with_domains_model.conf','');
  casbin.Policy.addPolicy(stPolicyRules, 'p,admin,domain1,data1,read');
  casbin.Policy.addPolicy(stPolicyRules, 'p,admin,domain1,data1,write');
  casbin.Policy.addPolicy(stPolicyRules, 'p,admin,domain2,data2,read');
  casbin.Policy.addPolicy(stPolicyRules, 'p,admin,domain2,data2,write');

  casbin.Policy.addPolicy(stRoleRules, 'g,alice,admin,domain1');
  casbin.Policy.addPolicy(stRoleRules, 'g,bob,admin,domain2');

  Assert.IsTrue(casbin.enforce(['alice','domain1','data1','read']), '1');
  Assert.IsTrue(casbin.enforce(['alice','domain1','data1','write']), '2');
  Assert.IsFalse(casbin.enforce(['alice','domain1','data2','read']), '3');
  Assert.IsFalse(casbin.enforce(['alice','domain1','data2','write']), '4');
  Assert.IsFalse(casbin.enforce(['bob','domain2','data1','read']), '5');
  Assert.IsFalse(casbin.enforce(['bob','domain2','data1','write']), '6');
  Assert.IsTrue(casbin.enforce(['bob','domain2','data2','read']), '7');
  Assert.IsTrue(casbin.enforce(['bob','domain2','data2','write']), '8');

  casbin.Policy.removePolicy(['*','domain1','data1']);

  Assert.IsFalse(casbin.enforce(['alice','domain1','data1','read']), '9');
//  Assert.IsFalse(casbin.enforce(['alice','domain1','data1','write']), '10');
  Assert.IsFalse(casbin.enforce(['alice','domain1','data2','read']), '11');
  Assert.IsFalse(casbin.enforce(['alice','domain1','data2','write']), '12');
  Assert.IsFalse(casbin.enforce(['bob','domain2','data1','read']), '13');
  Assert.IsFalse(casbin.enforce(['bob','domain2','data1','write']), '14');
  Assert.IsTrue(casbin.enforce(['bob','domain2','data2','read']), '15');
  Assert.IsTrue(casbin.enforce(['bob','domain2','data2','write']), '16');

  casbin.Policy.removePolicy(['admin','domain2','data2','read']);

  Assert.IsFalse(casbin.enforce(['alice','domain1','data1','read']), '17');
//  Assert.IsFalse(casbin.enforce(['alice','domain1','data1','write']), '18');
  Assert.IsFalse(casbin.enforce(['alice','domain1','data2','read']), '19');
  Assert.IsFalse(casbin.enforce(['alice','domain1','data2','write']), '20');
  Assert.IsFalse(casbin.enforce(['bob','domain2','data1','read']), '21');
  Assert.IsFalse(casbin.enforce(['bob','domain2','data1','write']), '22');
  Assert.IsFalse(casbin.enforce(['bob','domain2','data2','read']), '23');
  Assert.IsTrue(casbin.enforce(['bob','domain2','data2','write']), '24');

  casbin:=nil;
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
  casbin:=nil;
end;

procedure TTestCasbin.testGetAndSetAAdapterFromFile;
var
  casbin: ICasbin;
  adapter: IPolicyAdapter;
  policy: IPolicyManager;
begin
  casbin:=TCasbin.Create('..\..\..\Examples\Default\basic_model.conf', '');

  Assert.IsFalse(casbin.enforce(['alice','data1','read']), '1');

  adapter:=TPolicyFileAdapter.Create('..\..\..\Examples\Default\basic_policy.csv');
  policy:=TPolicyManager.Create(adapter);

  casbin.Policy:=policy;

  Assert.IsTrue(casbin.enforce(['alice','data1','read']), '2');

  casbin:=nil;
end;

procedure TTestCasbin.testGetAndSetAdapterInMem;
var
  casbin1: ICasbin;
  casbin2: ICasbin;
begin
  casbin1:=TCasbin.Create('..\..\..\Examples\Default\basic_model.conf',
              '..\..\..\Examples\Default\basic_policy.csv');
  Assert.IsTrue(casbin1.enforce(['alice','data1','read']), '1');
  Assert.IsFalse(casbin1.enforce(['alice','data1','write'], '2'));

  casbin2:=TCasbin.Create('..\..\..\Examples\Default\basic_model.conf',
              '..\..\..\Examples\Default\basic_inverse_policy.csv');

  casbin1.Policy:=casbin2.Policy;

  Assert.IsFalse(casbin1.enforce(['alice','data1','read']), '3');
  Assert.IsTrue(casbin1.enforce(['alice','data1','write'], '4'));

  casbin1:=nil;
  casbin2:=nil;
end;

procedure TTestCasbin.testGetAndSetModel;
var
  model1: IModel;
  model2: IModel;
  casbin: ICasbin;
begin
  model1:=TModel.Create('..\..\..\Examples\Default\basic_model.conf');
  model2:=TModel.Create('..\..\..\Examples\Default\basic_with_root_model.conf');

  casbin:=TCasbin.Create(model1, '');
  Assert.IsFalse(casbin.enforce(['root','data1','read']), 'Model1');

  casbin.Model:=model2;
  Assert.IsTrue(casbin.enforce(['root','data1','read']), 'Model2');

end;

procedure TTestCasbin.testInitEmpty;
var
  model: IModel;
  adapter: IPolicyAdapter;
  casbin: ICasbin;
begin
  model:=TModel.Create;
  model.addDefinition(stRequestDefinition, 'r=sub,obj, act');
  model.addDefinition(stPolicyDefinition, 'p', 'sub,obj,act');
  model.addDefinition(stPolicyEffect, 'e','some(where (p.eft == allow))');
  model.addDefinition(stMatchers,'m',
        'r.sub == p.sub && keyMatch(r.obj, p.obj) && regexMatch(r.act, p.act)');

  adapter:=TPolicyFileAdapter.Create
              ('..\..\..\Examples\Default\keymatch_policy.csv');

  casbin:=TCasbin.Create(model, TPolicyManager.Create(adapter));

  Assert.IsTrue(casbin.enforce(['alice', '/alice_data/resource1', 'GET']));
end;

procedure TTestCasbin.testMemoryConstructor;
var
  casbin: ICasbin;
begin
  casbin:=TCasbin.Create;
  Assert.IsNotNull(casbin.Logger);
  Assert.IsNotNull(casbin.Model);
  Assert.IsNotNull(casbin.Policy);
  Assert.IsTrue(casbin.Enabled);
  casbin:=nil;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCasbin);
end.
