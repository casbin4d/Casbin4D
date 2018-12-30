unit Tests.Adapter.Filesystem.Policy;

interface
uses
  DUnitX.TestFramework, Casbin.Adapter.Types, Casbin.Adapter.Policy.Types;

type

  [TestFixture]
  TTestPolicyFileAdapter = class(TObject)
  private
    fFilesystem: IPolicyAdapter;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testCached;
    [Test]
    procedure testAutoSave;
    [Test]
    procedure testCachSize;
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy;

procedure TTestPolicyFileAdapter.Setup;
begin
  fFilesystem:=TPolicyFileAdapter.Create('..\..\..\Examples\Default\rbac_with_deny_policy.csv');
end;

procedure TTestPolicyFileAdapter.TearDown;
begin
end;


procedure TTestPolicyFileAdapter.testAutoSave;
begin
  Assert.AreEqual(true, fFilesystem.AutoSave, 'default');
  fFilesystem.AutoSave:=not fFilesystem.AutoSave;
  Assert.AreEqual(false, fFilesystem.AutoSave, 'changed');
end;

procedure TTestPolicyFileAdapter.testCached;
begin
  Assert.AreEqual(False, fFilesystem.Cached, 'default');
  fFilesystem.Cached:=not fFilesystem.Cached;
  Assert.AreEqual(true, fFilesystem.Cached, 'changed');
end;

procedure TTestPolicyFileAdapter.testCachSize;
begin
  Assert.AreEqual(15, fFilesystem.CacheSize, 'default');
  fFilesystem.CacheSize:=100;
  Assert.AreEqual(100, fFilesystem.CacheSize, 'changed');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicyFileAdapter);
end.
