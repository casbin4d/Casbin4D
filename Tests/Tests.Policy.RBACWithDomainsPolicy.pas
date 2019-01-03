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
    procedure testInitialConditions;
    [Test]
    procedure testFilteredPolicies;
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy, Casbin.Policy;

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
  Assert.IsTrue(fPolicyManager.policyExists(['admin','domain1','data1','read']));
  Assert.IsFalse(fPolicyManager.policyExists(['admin','domain2','data2','read']));
end;

procedure TTestPolicyRBACWithDomainsPolicy.testInitialConditions;
begin
  Assert.IsTrue(fPolicyManager.policyExists(['admin','domain1','data1','read']));
  Assert.IsTrue(fPolicyManager.policyExists(['admin','domain2','data2','read']));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicyRBACWithDomainsPolicy);
end.
