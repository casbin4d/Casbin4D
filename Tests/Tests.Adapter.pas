unit Tests.Adapter;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestAdapter = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TTestAdapter.Setup;
begin
end;

procedure TTestAdapter.TearDown;
begin
end;

procedure TTestAdapter.Test1;
begin
end;

procedure TTestAdapter.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestAdapter);
end.
