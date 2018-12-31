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
