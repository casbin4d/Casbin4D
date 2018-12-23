unit Lexer.Tokeniser;

interface

uses
  Core.Base.Types, Lexer.Tokens.Messages, Lexer.Tokens.List, Core.Logger.Types,
  System.Generics.Collections, Lexer.Tokeniser.Types, Lexer.Tokens.Types;

type
  TTokeniser = class (TBaseInterfacedObject, ITokeniser)
  private
    fInputString: string;
    fTokenList: TTokenList;
    fLogger: ILogger;
    fTokenMessages: TObjectList<TTokenMessage>;
    fStatus: TTokeniserStatus;

    procedure addToken(const currCh: Char; const currPosition: TPosition; const
        aNomicalCol: integer); overload;
    procedure addToken(const token: string; const currPosition: TPosition; const
        aNomicalCol: integer); overload;
  private
{$REGION 'Interface'}
    procedure addEOL(const currPosition: TPosition; const aNomicalCol: integer);
    procedure addIdentifier(const value: string; const currPosition: TPosition;
        const aNomicalCol: integer);
    function getLogger: ILogger;
    function getTokenList: TTokenList;
    function getTokenMessages: TObjectList<TTokenMessage>;
    procedure setLogger(const aValue: ILogger);
    procedure tokenise;
    function getStatus: TTokeniserStatus;
{$ENDREGION}
  public
    constructor Create(const aInputString: string);
    destructor Destroy; override;
  end;

implementation

uses
  Core.Logger.Default, System.SysUtils, System.StrUtils, Lexer.Utilities, System.Diagnostics;

constructor TTokeniser.Create(const aInputString: string);
begin
  inherited Create;
  fLogger:=TDefaultLogger.Create;
  fTokenList:=TTokenList.Create;
  fTokenMessages:=TObjectList<TTokenMessage>.Create(true);
  fInputString:=aInputString;
  fStatus:=tsNotStarted;
end;

destructor TTokeniser.Destroy;
begin
  fLogger:=nil;
  fTokenMessages.Free;
  fTokenList.Free;
  inherited;
end;

function TTokeniser.getLogger: ILogger;
begin
  Result:=fLogger;
end;

function TTokeniser.getStatus: TTokeniserStatus;
begin
  Result:=fStatus;
end;

function TTokeniser.getTokenList: TTokenList;
begin
  Result:=fTokenList;
end;

function TTokeniser.getTokenMessages: TObjectList<TTokenMessage>;
begin
  Result := fTokenMessages;
end;

procedure TTokeniser.setLogger(const aValue: ILogger);
begin
  fLogger:=nil;
  fLogger:=aValue;
end;

//////////////////////////
{ TCharBuffer }
type
  PCharBuffer = ^TCharBuffer;
  TCharBuffer = record
    PreviousChar: Char;
    CurrentChar: Char;
    NextChar: Char;

    function currentAndNextChar: string;
    function currentAndPreviousChar: string;
  end;

function TCharBuffer.currentAndNextChar: string;
begin
  Result:=CurrentChar+NextChar;
end;

function TCharBuffer.currentAndPreviousChar: string;
begin
  result:=PreviousChar+CurrentChar;
end;

/////////////////////////

procedure TTokeniser.addIdentifier(const value: string; const currPosition:
    TPosition; const aNomicalCol: integer);
var
  token: PToken;
begin
  New(token);
  FillChar(token^, SizeOf(TToken), 0);

  token.Value:=value;
  token.&Type:=ttIdentifier;
  if aNomicalCol-Length(value)<Low(string) then
    token.StartPosition.Column:=Low(string)
  else
    token.StartPosition.Column:=aNomicalCol-Length(value)+1;
  token.StartPosition.Row:=currPosition.Row;
  token.EndPosition.Column:=aNomicalCol;
  token.EndPosition.Row:=currPosition.Row;

  fTokenList.Add(token);
  fLogger.log('Identifier '+value+' added');
end;

procedure TTokeniser.addEOL(const currPosition: TPosition; const aNomicalCol:
    integer);
var
  token: PToken;
begin
  New(token);
  FillChar(token^, SizeOf(TToken), 0);

  token.Value:='(eol)';
  token.&Type:=ttEOL;
  token.StartPosition.Column:=aNomicalCol;
  token.StartPosition.Row:=currPosition.Row;
  token.EndPosition.Column:=aNomicalCol;
  token.EndPosition.Row:=currPosition.Row;

  fTokenList.Add(token);

  fLogger.log('EOL detected');
end;

procedure TTokeniser.addToken(const token: string;
  const currPosition: TPosition; const aNomicalCol: integer);
var
  nToken: PToken;
begin
  // Two-char tokens are pushed here in the beginning of the token
  // by (peeking at next char)
  // whereas
  // other identifies land here after the reading of the whole token
  if Length(token) = 2 then
  begin
    nToken:=tokenForTwoCharReserved(token);
    nToken.StartPosition.Column:=aNomicalCol;
    nToken.EndPosition.Column:=aNomicalCol+Length(token)-1;
  end
  else
  begin
    nToken:=tokenForReservedWord(token);
    nToken.StartPosition.Column:=aNomicalCol-Length(token)+1;
    nToken.EndPosition.Column:=aNomicalCol;
  end;

  nToken.StartPosition.Row:=currPosition.Row;
  nToken.EndPosition.Row:=currPosition.Row;

  fTokenList.Add(nToken);

  fLogger.log('Token '+token+' added');
end;

procedure TTokeniser.addToken(const currCh: Char; const currPosition:
    TPosition; const aNomicalCol: integer);
var
  token: PToken;
begin
  token:=tokenForOneCharReserved(currCh);

  token.StartPosition.Column:=aNomicalCol;
  token.StartPosition.Row:=currPosition.Row;
  token.EndPosition.Column:=aNomicalCol;
  token.EndPosition.Row:=currPosition.Row;

  fTokenList.Add(token);
  fLogger.log('Token '+token^.Value+' added');
end;

procedure TTokeniser.tokenise;
var
  tokenMessage: TTokenMessage;
  currPosition: TPosition;
  lastPosition: TPosition;
  currCh: Char;
  value: string;
  token: PToken;
  buffer: PCharBuffer;
  nominalColumn: Integer;
  watch: TStopWatch;
begin
  watch:=TStopwatch.StartNew;
  fLogger.log('Tokenisation is starting...');
  fLogger.log('Input String: '+fInputString);

  fTokenList.Clear;
  fTokenMessages.Clear;

  // Empty parse string is passed
  if Trim(fInputString) = '' then
  begin
//    tokenMessage.Create(tmtError, 'Empty string to parse', position);
//    tokenMessage.ErrorType:=tmeSyntaxError;
//    fTokenMessages.Add(tokenMessage);
    fLogger.log('The string to parse is empty');
    fStatus:=tsFatalError;
    Exit;
  end;

  currPosition.Column:=Low(string);
  currPosition.Row:=0;
  lastPosition.Column:=currPosition.Column;
  lastPosition.Row:=currPosition.Row;

  nominalColumn:=currPosition.Column;

  fStatus:=tsRunning;

  New(buffer);
  FillChar(buffer^, SizeOf(TCharBuffer), 0);

  for currCh in fInputString do
  begin
    //Update Buffer
    buffer^.CurrentChar:=currCh;
    if currPosition.Column - 1 >= Low(string) then
      buffer^.PreviousChar:=fInputString[currPosition.Column - 1]
    else
      buffer^.PreviousChar:=#0;
    if currPosition.Column + 1 <= Length(fInputString) then
      buffer^.NextChar:= fInputString[currPosition.Column + 1]
    else
      buffer^.NextChar:=#0;

    //Check if EOL
    //Code from System unit for sLineBreak
    if {$IFDEF POSIX} currCh = sLineBreak {$ENDIF}
     {$IFDEF MSWINDOWS} buffer.currentAndNextChar = sLineBreak {$ENDIF} then
    begin
      addEOL(currPosition, nominalColumn);
      Inc(currPosition.Row);
      nominalColumn:=Low(string)-1;
    end
    else
    begin
      // Skip if an EOL has been added already
      if {$IFDEF POSIX} (buffer.PreviousChar = sLineBreak) {$ENDIF}
       {$IFDEF MSWINDOWS} (buffer.currentAndPreviousChar = sLineBreak) {$ENDIF} then
        Dec(nominalColumn)
      else
      begin
        //Check if the two-chars are reserved
        if MatchStr(buffer.currentAndNextChar, twoCharReserved) then
        begin
          addToken(buffer.currentAndNextChar, currPosition, nominalColumn);
          Value:='';
        end
        else
        begin
          //Skip if a two-chars reserved has been added already
          if not MatchStr(buffer.currentAndPreviousChar, twoCharReserved) then
          begin
            //Check if character is in reserved chars or/and whitespace
            if CharInSet(currCh, oneCharReserved + whiteSpaceChars) then
            begin
              addToken(currCh, currPosition, nominalColumn);
              value:='';
            end
            else
            begin
              //Build the 'value'
              value:=value+currCh;
              if CharInSet(buffer^.NextChar, oneCharReserved + whiteSpaceChars) or
                (buffer^.NextChar = #0) then
              begin
                if MatchStr(value, reservedWords) then
                  addToken (value, currPosition, nominalColumn)
                else
                  addIdentifier(value, currPosition, nominalColumn);
                value:='';
              end;
            end;
          end;
        end;
      end;
    end;
    //Increase the Column
    Inc(currPosition.Column);
    Inc(nominalColumn);
  end;

  fStatus:=tsFinished;
  Dispose(buffer);
  fLogger.log('Tokenisation finished...');
  watch.Stop;
  fLogger.log('Time elapsed: '+
    FormatDateTime('hh:nn:ss:zzz',watch.ElapsedMilliseconds/MSecsPerDay));
end;

end.
