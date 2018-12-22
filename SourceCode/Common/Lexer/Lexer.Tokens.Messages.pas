unit Lexer.Tokens.Messages;

interface

uses
  Lexer.Tokens.Types;

type
  TTokenMessageErrorType = (tmeNoError, tmeSyntaxError);
  TTokenMessageType = (tmtHint, tmtWarning, tmtError);
  TTokenMessage = class
  private
    fErrorType: TTokenMessageErrorType;
    fMessage: String;
    fPosition: TPosition;
    fType: TTokenMessageType;
  public
    constructor Create(const aType: TTokenMessageType;
                       const aMessage: string; const aPosition: TPosition);
    property &Type: TTokenMessageType read fType;
    property &Message: String read fMessage;
    property ErrorType: TTokenMessageErrorType read fErrorType write fErrorType;
    property Position: TPosition read fPosition;
  end;

implementation


{ TTokenMessage }

constructor TTokenMessage.Create(const aType: TTokenMessageType;
  const aMessage: string; const aPosition: TPosition);
begin
  inherited Create;
  fType:=aType;
  fMessage:=aMessage;
  fPosition:=aPosition;
  fErrorType:=tmeNoError;
end;

end.
