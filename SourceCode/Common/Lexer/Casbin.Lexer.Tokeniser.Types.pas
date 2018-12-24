unit Casbin.Lexer.Tokeniser.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Core.Logger.Types, Casbin.Lexer.Tokens.List,
  System.Generics.Collections, Casbin.Lexer.Tokens.Messages, System.SysUtils;

type
  ELexerException = class (Exception);

  TTokeniserStatus = (tsNotStarted, tsRunning, tsFatalError, tsFinished);
  ITokeniser = interface (IBaseInterface)
    ['{77DA3C9D-41ED-4E20-9A1A-9A835538BD1D}']
    function getLogger: ILogger;
    function getStatus: TTokeniserStatus;
    function getTokenList: TTokenList;
    function getTokenMessages: TObjectList<TTokenMessage>;
    procedure setLogger(const aValue: ILogger);
    procedure tokenise;

    property Logger: ILogger read getLogger write setLogger;
    property Status: TTokeniserStatus read getStatus;
    property TokenList: TTokenList read getTokenList;
    property TokenMessages: TObjectList<TTokenMessage> read getTokenMessages;
  end;

implementation

end.
