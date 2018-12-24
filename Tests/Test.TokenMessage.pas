unit Test.TokenMessage;

interface
uses
  DUnitX.TestFramework, Casbin.Lexer.Tokens.Messages;

type
  [TestFixture]
  TTestTokenMessage = class(TObject)
  private
    fTokenMessage: TTokenMessage;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testTokenMessage;
  end;

implementation

uses
  Casbin.Lexer.Tokens.Types;

procedure TTestTokenMessage.Setup;
var
  position: TPosition;
begin
  position.Row:=200;
  position.Column:=100;
  fTokenMessage:=TTokenMessage.Create(tmtError, 'Test Error', position);
  fTokenMessage.ErrorType:=tmeSyntaxError;
end;

procedure TTestTokenMessage.TearDown;
begin
  fTokenMessage.Free;
end;


procedure TTestTokenMessage.testTokenMessage;
begin
  Assert.AreEqual(tmtError, fTokenMessage.&Type);
  Assert.AreEqual('Test Error', fTokenMessage.Message);
  Assert.AreEqual(tmeSyntaxError, fTokenMessage.ErrorType);
  Assert.AreEqual(200, fTokenMessage.Position.Row);
  Assert.AreEqual(100, fTokenMessage.Position.Column);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTokenMessage);
end.
