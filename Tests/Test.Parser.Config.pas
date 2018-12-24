unit Test.Parser.Config;

interface
uses
  DUnitX.TestFramework, Casbin.Parser.Config.Types;

type

  [TestFixture]
  TTestParserConfig = class(TObject)
  private
    fConfig: IParserConfig;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testDefaultValues;
  end;

implementation

uses
  Casbin.Parser.Config;

procedure TTestParserConfig.Setup;
begin
  fConfig:=TParserConfig.Create;
end;

procedure TTestParserConfig.TearDown;
begin
end;

procedure TTestParserConfig.testDefaultValues;
begin
  Assert.AreEqual('=', fConfig.AssignmentChar);
  Assert.AreEqual(true, fConfig.AutoAssignSections);
  Assert.AreEqual(False, fConfig.RespectSpacesInValues);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestParserConfig);
end.
