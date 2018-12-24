unit Parser.Messages;

interface

type
  TParserErrorType = (peNoError, peSyntaxError);
  TParserMessageType = (peHint, peWarning, peError);
  TParserMessage = class
  private
    fErrorType: TParserErrorType;
    fMessage: String;
    fType: TParserMessageType;
  public
    constructor Create(const aType: TParserMessageType;
                       const aMessage: string);
    property &Type: TParserMessageType read fType;
    property &Message: String read fMessage;
    property ErrorType: TParserErrorType read fErrorType write fErrorType;
  end;

implementation

{ TParserMessage }

constructor TParserMessage.Create(const aType: TParserMessageType;
  const aMessage: string);
begin
  inherited Create;
  fType:=aType;
  fMessage:=aMessage;
end;

end.
