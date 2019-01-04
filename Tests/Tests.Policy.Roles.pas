unit Tests.Policy.Roles;

interface
uses
  DUnitX.TestFramework, Casbin.Policy.Types, System.Types;

type

  [TestFixture]
  TTestPolicyRoles = class(TObject)
  private
    fPolicy: IPolicyManager;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    // From role_manager_test.go - TestRole
    [TestCase ('NormalRole.1', 'u1,g1#true', '#')]
    [TestCase ('NormalRole.2', 'u1,g2#false', '#')]
    [TestCase ('NormalRole.3', 'u1,g3#true', '#')]

    [TestCase ('NormalRole.4', 'u2,g1#true', '#')]
    [TestCase ('NormalRole.5', 'u2,g2#false', '#')]
    [TestCase ('NormalRole.6', 'u2,g3#true', '#')]

    [TestCase ('NormalRole.7', 'u3,g1#false', '#')]
    [TestCase ('NormalRole.8', 'u3,g2#true', '#')]
    [TestCase ('NormalRole.9', 'u3,g3#false', '#')]

    [TestCase ('NormalRole.10', 'u4,g1#false', '#')]
    [TestCase ('NormalRole.11', 'u4,g2#true', '#')]
    [TestCase ('NormalRole.12', 'u4,g3#true', '#')]
    procedure testRolesNormal(const aLeft, aRight: string; const aResult: boolean);

    [Test]
    // From role_manager_test.go - TestRole
    [TestCase ('NormalRole.1', 'u1,g1#true', '#')]
    [TestCase ('NormalRole.2', 'u1,g2#false', '#')]
    [TestCase ('NormalRole.3', 'u1,g3#false', '#')]

    [TestCase ('NormalRole.4', 'u2,g1#true', '#')]
    [TestCase ('NormalRole.5', 'u2,g2#false', '#')]
    [TestCase ('NormalRole.6', 'u2,g3#false', '#')]

    [TestCase ('NormalRole.7', 'u3,g1#false', '#')]
    [TestCase ('NormalRole.8', 'u3,g2#true', '#')]
    [TestCase ('NormalRole.9', 'u3,g3#false', '#')]

    [TestCase ('NormalRole.10', 'u4,g1#false', '#')]
    [TestCase ('NormalRole.11', 'u4,g2false', '#')]
    [TestCase ('NormalRole.12', 'u4,g3#true', '#')]
    procedure testRolesNormalDelete(const aLeft, aRight: string; const aResult:
        boolean);

    [Test]
    // From role_manager_test.go - TestDomainRole
    [TestCase ('DomainRole.1', 'u1,g1,domain1#true', '#')]
    [TestCase ('DomainRole.2', 'u1,g1,domain2#false', '#')]
    [TestCase ('DomainRole.3', 'u1,admin,domain1#true', '#')]
    [TestCase ('DomainRole.4', 'u1,admin,domain2#false', '#')]

    [TestCase ('DomainRole.5', 'u2,g1,domain1#true', '#')]
    [TestCase ('DomainRole.6', 'u2,g1,domain2#false', '#')]
    [TestCase ('DomainRole.7', 'u2,admin,domain1#true', '#')]
    [TestCase ('DomainRole.8', 'u2,admin,domain2#false', '#')]

    [TestCase ('DomainRole.9', 'u3,g1,domain1#false', '#')]
    [TestCase ('DomainRole.10', 'u3,g1,domain2#false', '#')]
    [TestCase ('DomainRole.11', 'u3,admin,domain1#false', '#')]
    [TestCase ('DomainRole.12', 'u3,admin,domain2#true', '#')]

    [TestCase ('DomainRole.13', 'u4,g1,domain1#false', '#')]
    [TestCase ('DomainRole.14', 'u4,g1,domain2#false', '#')]
    [TestCase ('DomainRole.15', 'u4,admin,domain1#true', '#')]
    [TestCase ('DomainRole.16', 'u4,admin,domain2#true', '#')]

    procedure testRolesDomainNormal (const aLeft: string; const aRight: string;
                                  const aDomain: string;const aResult: Boolean);

    [Test]
    // From role_manager_test.go - TestDomainRole
    [TestCase ('DomainRole.1', 'u1,g1,domain1#true', '#')]
    [TestCase ('DomainRole.2', 'u1,g1,domain2#false', '#')]
    [TestCase ('DomainRole.3', 'u1,admin,domain1#false', '#')]
    [TestCase ('DomainRole.4', 'u1,admin,domain2#false', '#')]

    [TestCase ('DomainRole.5', 'u2,g1,domain1#true', '#')]
    [TestCase ('DomainRole.6', 'u2,g1,domain2#false', '#')]
    [TestCase ('DomainRole.7', 'u2,admin,domain1#false', '#')]
    [TestCase ('DomainRole.8', 'u2,admin,domain2#false', '#')]

    [TestCase ('DomainRole.9', 'u3,g1,domain1#false', '#')]
    [TestCase ('DomainRole.10', 'u3,g1,domain2#false', '#')]
    [TestCase ('DomainRole.11', 'u3,admin,domain1#false', '#')]
    [TestCase ('DomainRole.12', 'u3,admin,domain2#true', '#')]

    [TestCase ('DomainRole.13', 'u4,g1,domain1#false', '#')]
    [TestCase ('DomainRole.14', 'u4,g1,domain2#false', '#')]
    [TestCase ('DomainRole.15', 'u4,admin,domain1#true', '#')]
    [TestCase ('DomainRole.16', 'u4,admin,domain2#false', '#')]

    procedure testRolesDomainDelete (const aLeft: string; const aRight: string;
                                  const aDomain: string;const aResult: Boolean);

    [Test]
    // From role_manager_test.go - TestClear
    [TestCase ('Clear.1', 'u1,g1#false', '#')]
    [TestCase ('Clear.2', 'u1,g2#false', '#')]
    [TestCase ('Clear.3', 'u1,g3#false', '#')]

    [TestCase ('Clear.4', 'u2,g1#false', '#')]
    [TestCase ('Clear.5', 'u2,g2#false', '#')]
    [TestCase ('Clear.6', 'u2,g3#false', '#')]

    [TestCase ('Clear.7', 'u3,g1#false', '#')]
    [TestCase ('Clear.8', 'u3,g2#false', '#')]
    [TestCase ('Clear.9', 'u3,g3#false', '#')]

    [TestCase ('Clear.10', 'u4,g1#false', '#')]
    [TestCase ('Clear.11', 'u4,g2#false', '#')]
    [TestCase ('Clear.12', 'u4,g3#false', '#')]
    procedure testClear(const aLeft, aRight: string; const aResult: boolean);

    [Test]
    [TestCase ('RolesForEntity.1', 'u1#g1', '#')]
    [TestCase ('RolesForEntity.2', 'u2#g1', '#')]
    [TestCase ('RolesForEntity.3', 'u3#g2', '#')]
    [TestCase ('RolesForEntity.4', 'u4#g2,g3', '#')]
    [TestCase ('RolesForEntity.5', 'g1#g3', '#')]
    [TestCase ('RolesForEntity.6', 'g2# ', '#')]
    [TestCase ('RolesForEntity.7', 'g3# ', '#')]
    procedure testRolesForEntityNormal(const aEntity, aExpected: string);

    [Test]
    [TestCase ('RolesForEntity.1', 'u1#g1', '#')]
    [TestCase ('RolesForEntity.2', 'u2#g1', '#')]
    [TestCase ('RolesForEntity.3', 'u3#g2', '#')]
    [TestCase ('RolesForEntity.4', 'u4#g3', '#')]
    [TestCase ('RolesForEntity.5', 'g1# ', '#')]
    [TestCase ('RolesForEntity.6', 'g2# ', '#')]
    [TestCase ('RolesForEntity.7', 'g3# ', '#')]
    procedure testRolesForEntityDeleted(const aEntity, aExpected: string);

    [Test]
    [TestCase ('EntitiesForRole.1', 'u1#', '#')]
    [TestCase ('EntitiesForRole.2', 'u2#', '#')]
    [TestCase ('EntitiesForRole.3', 'u3#', '#')]
    [TestCase ('EntitiesForRole.4', 'u4#', '#')]
    [TestCase ('EntitiesForRole.5', 'g1#u1,u2', '#')]
    [TestCase ('EntitiesForRole.6', 'g2#u3,u4', '#')]
    [TestCase ('EntitiesForRole.7', 'g3#g1,u4', '#')]
    procedure testEntitiesForRoleNormal(const aEntity, aExpected: string);
  end;

implementation

uses
  Casbin.Policy, System.SysUtils;

procedure TTestPolicyRoles.Setup;
begin
  fPolicy:=TPolicyManager.Create;
end;

procedure TTestPolicyRoles.TearDown;
begin
end;

procedure TTestPolicyRoles.testClear(const aLeft, aRight: string;
  const aResult: boolean);
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;

  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  fPolicy.clearRoles;

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aRight));
end;

procedure TTestPolicyRoles.testEntitiesForRoleNormal(const aEntity,
  aExpected: string);
var
  actString: string;
  actArray: TStringDynArray;
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  actArray:=fPolicy.EntitiesForRole(aEntity);
  actString:=string.Join(',', actArray);
  Assert.AreEqual(Trim(aExpected), Trim(actString));
end;

procedure TTestPolicyRoles.testRolesDomainDelete(const aLeft, aRight,
  aDomain: string; const aResult: Boolean);
begin
	// Current role inheritance tree:
	//       domain1:admin    domain2:admin
	//                    \          \
	//      domain1:g1     u4         u3
	//         /  \
	//       u1    u2

  fPolicy.clear;
  fPolicy.addLink('u1', 'domain1', 'g1');
  fPolicy.addLink('u2', 'domain1', 'g1');
  fPolicy.addLink('u3', 'domain2', 'admin');
  fPolicy.addLink('u4', 'domain2', 'admin');
  fPolicy.addLink('u4', 'domain1', 'admin');
  fPolicy.addLink('g1', 'domain1', 'admin');

  fPolicy.removeLink('g1', 'domain1', 'admin');
  fPolicy.removeLink('u4', 'domain2', 'admin');

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aDomain, aRight));
end;

procedure TTestPolicyRoles.testRolesDomainNormal(const aLeft, aRight,
  aDomain: string; const aResult: Boolean);
begin
	// Current role inheritance tree:
	//       domain1:admin    domain2:admin
	//            /       \  /       \
	//      domain1:g1     u4         u3
	//         /  \
	//       u1    u2

  fPolicy.clear;
  fPolicy.addLink('u1', 'domain1', 'g1');
  fPolicy.addLink('u2', 'domain1', 'g1');
  fPolicy.addLink('u3', 'domain2', 'admin');
  fPolicy.addLink('u4', 'domain2', 'admin');
  fPolicy.addLink('u4', 'domain1', 'admin');
  fPolicy.addLink('g1', 'domain1', 'admin');

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aDomain, aRight));
end;

procedure TTestPolicyRoles.testRolesForEntityDeleted(const aEntity,
  aExpected: string);
var
  actString: string;
  actArray: TStringDynArray;
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  fPolicy.removeLink('g1','g3');
  fPolicy.removeLink('u4','g2');

  actArray:=fPolicy.rolesForEntity(aEntity);
  actString:=string.Join(',', actArray);
  Assert.AreEqual(Trim(aExpected), Trim(actString));
end;

procedure TTestPolicyRoles.testRolesForEntityNormal(const aEntity, aExpected:
    string);
var
  actString: string;
  actArray: TStringDynArray;
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  actArray:=fPolicy.rolesForEntity(aEntity);
  actString:=string.Join(',', actArray);
  Assert.AreEqual(Trim(aExpected), Trim(actString));

end;

procedure TTestPolicyRoles.testRolesNormal(const aLeft, aRight: string; const
    aResult: boolean);
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aRight));
end;


procedure TTestPolicyRoles.testRolesNormalDelete(const aLeft, aRight: string;
    const aResult: boolean);
begin
	// Current role inheritance tree:
	//             g3    g2
	//               \     \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  fPolicy.removeLink('g1', 'g3');
  fPolicy.removeLink('u4', 'g2');

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aRight));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicyRoles);
end.
