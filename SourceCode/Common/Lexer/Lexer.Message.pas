unit Lexer.Message;

interface

uses
  Lexer.Tokens.Types;

type
  TLexerMessageType = (lmtHint, lmtWarning, lmtError);
  TLexerMessage = class
  private
    fMessage: String;
    fPosition: TPosition;
    fType: TLexerMessageType;
  public
    constructor Create(const aType: TLexerMessageType;
                       const aMessage: string; const aPosition: TPosition);
    property &Type: TLexerMessageType read fType;
    property &Message: String read fMessage;
    property Position: TPosition read fPosition;
  end;

implementation


{ TLexerMessage }

constructor TLexerMessage.Create(const aType: TLexerMessageType;
  const aMessage: string; const aPosition: TPosition);
begin
  inherited Create;
  fType:=aType;
  fMessage:=aMessage;
  aPosition:=aPosition;
end;

end.
