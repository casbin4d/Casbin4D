unit Tests.Adapter.FileSystem;

interface
uses
  DUnitX.TestFramework, Casbin.Adapter.Types;

type

  [TestFixture]
  TTestAdapterFilesystem = class(TObject)
  private
    fFilesystem: IAdapter;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testLoad;
    [Test]
    procedure testSave;
    [Test]
    procedure testOutputString;
  end;

implementation

uses
  Casbin.Adapter.Filesystem, System.SysUtils;

procedure TTestAdapterFilesystem.Setup;
begin
  fFilesystem:=TFileAdapter.Create('..\..\..\Examples\Default\basic_model.conf');
end;

procedure TTestAdapterFilesystem.TearDown;
begin
end;

procedure TTestAdapterFilesystem.testLoad;
begin
  fFilesystem.load;
  Assert.AreEqual(11, fFilesystem.Assertions.Count);
end;

procedure TTestAdapterFilesystem.testOutputString;
var
  output: string;
begin
  fFilesystem.load;
  output:=
  '[request_definition]'+sLineBreak+
  'r = sub, obj, act'+sLineBreak+
  sLineBreak+
  '[policy_definition]'+sLineBreak+
  'p = sub, obj, act'+sLineBreak+
  sLineBreak+
  '[policy_effect]'+sLineBreak+
  'e = some(where (p.eft == allow))'+sLineBreak+
  sLineBreak+
  '[matchers]'+sLineBreak+
  'm = r.sub == p.sub && r.obj == p.obj && r.act == p.act';

  Assert.AreEqual(trim(output), Trim(fFilesystem.toOutputString));
end;

procedure TTestAdapterFilesystem.testSave;
begin
  Assert.IsTrue(true);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestAdapterFilesystem);
end.
