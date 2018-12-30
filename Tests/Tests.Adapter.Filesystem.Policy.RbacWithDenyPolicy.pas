unit Tests.Adapter.Filesystem.Policy.RbacWithDenyPolicy;

interface
uses
  DUnitX.TestFramework, Casbin.Adapter.Types, Casbin.Adapter.Policy.Types;

type

  [TestFixture]
  TTestPolicyFileAdapterRBACWithDenyPolicy = class(TObject)
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
    [Test]
    procedure testFiltered;

    [Test]
    [TestCase ('Without Filter', ' #p, alice, data1, read, allow'+sLineBreak+
                                 'p, bob, data2, write, allow'+sLineBreak+
                                 'p, data2_admin, data2, read, allow'+sLineBreak+
                                 'p, data2_admin, data2, write, allow'+sLineBreak+
                                 'p, alice, data2, write, deny'+sLineBreak+
                                 sLineBreak+
                                 'g, alice, data2_admin','#')]
    [TestCase ('First Param', 'alice#p, alice, data1, read, allow'+sLineBreak+
                                    'p, alice, data2, write, deny'+sLineBreak+
                                     sLineBreak+
                                    'g, alice, data2_admin','#')]
    [TestCase ('Two Consecutive Param', 'alice, data1#'+
                                     'p, alice, data1, read, allow'+sLineBreak+
                                     sLineBreak+
                                     'g, alice, data2_admin','#')]
    [TestCase ('Second Param', ' , data1#p, alice, data1, read, allow'+sLineBreak+
                                         sLineBreak+
                                         'g, alice, data2_admin','#')]
    [TestCase ('Third Param', ' , , write#'+
                                 'p, bob, data2, write, allow'+sLineBreak+
                                 'p, data2_admin, data2, write, allow'+sLineBreak+
                                 'p, alice, data2, write, deny'+sLineBreak+
                                 sLineBreak+
                                 'g, alice, data2_admin','#')]
    procedure testload(const aFilter, aExpected: string);
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy, System.SysUtils, System.Classes, System.Types;

procedure TTestPolicyFileAdapterRBACWithDenyPolicy.Setup;
begin
  fFilesystem:=TPolicyFileAdapter.Create('..\..\..\Examples\Default\rbac_with_deny_policy.csv');
end;

procedure TTestPolicyFileAdapterRBACWithDenyPolicy.TearDown;
begin
end;


procedure TTestPolicyFileAdapterRBACWithDenyPolicy.testAutoSave;
begin
  Assert.AreEqual(true, fFilesystem.AutoSave, 'default');
  fFilesystem.AutoSave:=not fFilesystem.AutoSave;
  Assert.AreEqual(false, fFilesystem.AutoSave, 'changed');
end;

procedure TTestPolicyFileAdapterRBACWithDenyPolicy.testCached;
begin
  Assert.AreEqual(False, fFilesystem.Cached, 'default');
  fFilesystem.Cached:=not fFilesystem.Cached;
  Assert.AreEqual(true, fFilesystem.Cached, 'changed');
end;

procedure TTestPolicyFileAdapterRBACWithDenyPolicy.testCachSize;
begin
  Assert.AreEqual(15, fFilesystem.CacheSize, 'default');
  fFilesystem.CacheSize:=100;
  Assert.AreEqual(100, fFilesystem.CacheSize, 'changed');
end;

procedure TTestPolicyFileAdapterRBACWithDenyPolicy.testFiltered;
begin
  Assert.IsFalse(fFilesystem.Filtered, 'Default');
  fFilesystem.load(['alice']);
  Assert.IsTrue(fFilesystem.Filtered, 'Filtered');
  fFilesystem.load;
  Assert.IsFalse(fFilesystem.Filtered, 'Back to Default');
end;

procedure TTestPolicyFileAdapterRBACWithDenyPolicy.testload(const aFilter, aExpected: string);
var
  strArray: TStringDynArray;
  strList: TStringList;
  i: integer;
begin
  strList:=TStringList.Create;
  strList.Delimiter:=',';
  strList.DelimitedText:=Trim(aFilter);
  SetLength(strArray, strList.Count);
  for i:=0 to strList.Count-1 do
    strArray[i]:=strList.Strings[i];
  fFilesystem.load(strArray);
  Assert.AreEqual(Trim(aExpected), Trim(fFilesystem.toOutputString));
  strList.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicyFileAdapterRBACWithDenyPolicy);
end.
