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
unit Tests.Policy;

interface
uses
  DUnitX.TestFramework, Casbin.Policy.Types, Casbin.Model.Sections.Types;

type

  [TestFixture]
  TTestPolicyManager = class(TObject)
  private
    fPolicy: IPolicyManager;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testPolicies;

    [Test]
    procedure testRoles;

    [Test]
    procedure testSection;

    [Test]
    procedure testPolicyExists;

    [Test]
    procedure testRolesExist;

    [Test]
    [TestCase ('Alice', 'p, alice, data1#read', '#')]
    [TestCase ('Bob', 'p, BOB, data2#write', '#')]
    [TestCase ('Non-existant', 'p, 123, aaaa#undefined', '#')]
    procedure testPolicy(const aFilter: string; const aExpected: string);

    [Test]
    [TestCase ('Policy.1','stPolicyRules#p#a,b,c', '#')]
    [TestCase ('Policy.2','stRoleRules#g#a,b,c', '#')]
    [TestCase ('Policy.3','stPolicyRules#p#a,b,c,d', '#')]
    procedure testAddPolicyFull(const aSection: TSectionType; const aTag:
        string; const aAssertion: string);

    [Test]
    [TestCase ('Policy.1','stPolicyRules#p,a,b,c', '#')]
    [TestCase ('Policy.2','stRoleRules#g,a,b,c', '#')]
    [TestCase ('Policy.3','stRoleRules#g2,a,b,c', '#')]
    procedure testAddPolicyCompact(const aSection: TSectionType;
                                                const aAssertion: string);
    [Test]
    [TestCase ('TestDomains.1','..\..\..\Examples\Default\rbac_policy.csv#','#')]
    [TestCase ('TestDomains.2',
        '..\..\..\Examples\Default\rbac_with_domains_policy.csv#'+
          'domain1,domain2','#')]
    procedure testDomains(const aPolicyFile, aDomains: string);

    [Test]
    procedure testRemovePolicy;
  end;

implementation

uses
  Casbin.Policy, System.Generics.Collections, System.SysUtils,
  Casbin.Core.Base.Types;

procedure TTestPolicyManager.Setup;
begin
  fPolicy:=TPolicyManager.Create('..\..\..\Examples\Default\basic_policy.csv')
end;

procedure TTestPolicyManager.TearDown;
begin
end;


procedure TTestPolicyManager.testAddPolicyCompact(const aSection: TSectionType;
  const aAssertion: string);
begin
  fPolicy.addPolicy(aSection, aAssertion);
  Assert.IsTrue(fPolicy.policyExists(TFilterArray(Trim(aAssertion).Split([',']))));
end;

procedure TTestPolicyManager.testAddPolicyFull(const aSection: TSectionType;
  const aTag, aAssertion: string);
begin
  fPolicy.addPolicy(aSection, aTag, aAssertion);
  Assert.IsTrue(fPolicy.policyExists(TFilterArray(Trim(aAssertion).Split([',']))));
end;

procedure TTestPolicyManager.testDomains(const aPolicyFile, aDomains: string);
var
  manager: IPolicyManager;
  arr: TArray<string>;
begin
  manager:=TPolicyManager.Create(aPolicyFile);
  arr:=manager.domains.ToArray;
  Assert.IsTrue(Trim(string.Join(',', manager.domains.ToArray))=Trim(aDomains));
end;

procedure TTestPolicyManager.testPolicies;
var
  list: TList<string>;
begin
  list:=fPolicy.policies;
  Assert.AreEqual(2, list.Count, 'Count');
  Assert.AreEqual('p, alice, data1, read', list.Items[0], 'Line 1');
  Assert.AreEqual('p, bob, data2, write', list.Items[1], 'Line 2');
end;

procedure TTestPolicyManager.testPolicy(const aFilter, aExpected: string);
begin
  Assert.AreEqual(aExpected, fPolicy.policy(TFilterArray(aFilter.Split([',']))));
end;

procedure TTestPolicyManager.testPolicyExists;
begin
  Assert.AreEqual(True, fPolicy.policyExists(['p','bob','DATA2','write']));
  Assert.AreEqual(false, fPolicy.policyExists(['p','bob','DATA100','write']));
  Assert.AreEqual(false, fPolicy.policyExists(['bob','DATA100','write']));

  fPolicy.addPolicy(stRoleRules, 'g', '_,_');
  Assert.AreEqual(True, fPolicy.policyExists(['g','_','_']));
end;

procedure TTestPolicyManager.testRemovePolicy;
var
  policyManager: IPolicyManager;
begin
  policyManager:=TPolicyManager.Create
                  ('..\..\..\Examples\Default\rbac_with_domains_policy.csv');
  policyManager.removePolicy(['admin','domain1','data1','read']);
  Assert.IsFalse(policyManager.policyExists(['admin','domain1','data1','read']), '1');

  policyManager.removePolicy(['*','domain2']);
  Assert.IsFalse(policyManager.policyExists(['admin','domain2','data2','read']), '2');

  policyManager.removePolicy(['*','domain1','data1']);
  Assert.IsFalse(policyManager.policyExists(['admin','domain1','data1','read']), '3');

  policyManager.addPolicy(stPolicyRules,'p','admin,data1,read');
  Assert.IsTrue(policyManager.policyExists(['admin','domain1','data1','read']), '4');

  policyManager.removePolicy(['*','data1','domain1']);
  Assert.IsFalse(policyManager.policyExists(['admin','domain1','data1','read']), '5');
end;

procedure TTestPolicyManager.testRoles;
var
  policyManager: IPolicyManager;
  list: TList<string>;
begin
  policyManager:=TPolicyManager.Create
                  ('..\..\..\Examples\Default\rbac_with_domains_policy.csv');
  list:=policyManager.roles;
  Assert.AreEqual(2, list.Count, 'Count');
  Assert.AreEqual('g, alice, admin, domain1', list.Items[0], 'Line 1');
  Assert.AreEqual('g, bob, admin, domain2', list.Items[1], 'Line 2');
end;

procedure TTestPolicyManager.testRolesExist;
begin
  fPolicy.addPolicy(stRoleRules, 'g', '_,_');
  Assert.AreEqual(True, fPolicy.roleExists(['g','_','_']));
end;

procedure TTestPolicyManager.testSection;
var
  expected: string;
begin
  expected:='p, alice, data1, read'+sLineBreak+'p, bob, data2, write';
  Assert.AreEqual(expected, trim(fPolicy.section));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicyManager);
end.
