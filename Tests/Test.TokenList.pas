unit Test.TokenList;

interface
uses
  DUnitX.TestFramework, Lexer.Tokens.List;

type

  [TestFixture]
  TTestTokenList = class(TObject)
  private
    fList: TTokenList;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testANDItem;

    [Test]
    procedure testOutput;
  end;

implementation

uses
  Lexer.Tokens.Types;

procedure TTestTokenList.Setup;
var
  item: PToken;
begin
  fList:=TTokenList.Create;

  //AND
  New(item);
  FillChar(item^, SizeOf(TToken), 0);
  item.&Type:=ttAND;
  item.Value:='and';
  item.StartPosition.Column:=0;
  item.StartPosition.Row:=0;
  item.EndPosition.Column:=2;
  item.EndPosition.Row:=0;
  fList.Add(item);

  //GreaterThan
  New(item);
  FillChar(item^, SizeOf(TToken), 0);
  item.&Type:=ttGreaterThan;
  item.Value:='>';
  item.StartPosition.Column:=10;
  item.StartPosition.Row:=2;
  item.EndPosition.Column:=11;
  item.EndPosition.Row:=2;
  fList.Add(item);
end;

procedure TTestTokenList.TearDown;
begin
  fList.Free;
end;

procedure TTestTokenList.testANDItem;
begin
  Assert.IsTrue(fList.Count>0);
  Assert.IsTrue(fList.Items[0]^.&Type = ttAND);
  Assert.AreEqual('and', fList.Items[0]^.Value);
end;

procedure TTestTokenList.testOutput;
begin
  Assert.AreEqual('{Token: AND; Value: and; (0,0) --> (2,0)}'+sLineBreak+
                  '{Token: GreaterThan; Value: >; (10,2) --> (11,2)}',
                                                        fList.toOutputString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTokenList);
end.
