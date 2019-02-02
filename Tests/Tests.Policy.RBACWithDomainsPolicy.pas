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
unit Tests.Policy.RBACWithDomainsPolicy;

interface
uses
  DUnitX.TestFramework, Casbin.Policy.Types;

type

  [TestFixture]
  TTestPolicyRBACWithDomainsPolicy = class(TObject)
  private
    fPolicyManager: IPolicyManager;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase ('Initial.1','admin,domain1,data1,read#true', '#')]
    [TestCase ('Initial.2','admin,domain2,data2,read#true', '#')]
    procedure testInitialConditions(const aFilter: string; const aResult: boolean);

    [Test]
    procedure testFilteredPolicies;
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy, Casbin.Policy, Casbin.Core.Base.Types,
  System.SysUtils;

procedure TTestPolicyRBACWithDomainsPolicy.Setup;
begin
  fPolicyManager:=TPolicyManager.Create
                  ('..\..\..\Examples\Default\rbac_with_domains_policy.csv');
end;

procedure TTestPolicyRBACWithDomainsPolicy.TearDown;
begin
end;


procedure TTestPolicyRBACWithDomainsPolicy.testFilteredPolicies;
begin
  fPolicyManager.load(['', 'domain1']);
  Assert.IsTrue(fPolicyManager.policyExists(['admin','domain1','data1','read']),'1');
  Assert.IsFalse(fPolicyManager.policyExists(['admin','domain2','data2','read']),'2');
end;

procedure TTestPolicyRBACWithDomainsPolicy.testInitialConditions(const aFilter:
    string; const aResult: boolean);
var
  filters: TFilterArray;
begin
  filters:=TFilterArray(aFilter.Split([',']));
  Assert.AreEqual(aResult, fPolicyManager.policyExists(filters));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicyRBACWithDomainsPolicy);
end.
