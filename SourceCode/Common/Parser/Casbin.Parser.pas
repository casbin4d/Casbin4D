unit Casbin.Parser;

interface

uses
  Casbin.Core.Base.Types, Casbin.Parser.Types, Casbin.Parser.Config.Types,
  Casbin.Core.Logger.Types,
  System.Generics.Collections, Casbin.Parser.Messages, Casbin.Model.Sections.Types,
  Casbin.Lexer.Tokens.List, System.Rtti;

type
  TParser = class (TBaseInterfacedObject, IParser)
  private
    fConfig: IParserConfig;
    fLogger: ILogger;
    fMessages: TObjectList<TParserMessage>;

    fSections: TObjectList<TSection>;
    fSectionsExternallyAssigned: Boolean;

    fTokenList: TTokenList;
    fStatus: TParserStatus;
    fSectionsDictionary: TDictionary<string, TSection>;
    procedure loadSections;
    procedure checkSyntaxErrors;
    procedure cleanWhiteSpace;
    procedure postError(var errString: string);
  private
{$REGION 'Interface'}
    function getConfig: IParserConfig;
    function getLogger: ILogger;
    function getMessages: TObjectList<TParserMessage>;
    function getSections: TObjectList<TSection>;
    procedure parse;
    function toOutputString: string;
    procedure setConfig(const aValue: IParserConfig);
    procedure setLogger(const aValue: ILogger);
    procedure setSections(const aValue: TObjectList<TSection>);
    function getStatus: TParserStatus;
{$ENDREGION}
  public
    constructor Create(const aTokenList: TTokenList);
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, Casbin.Parser.Config, Casbin.Core.Logger.Default,
  Casbin.Lexer.Tokens.Types;

const
  sSyntaxError = 'Syntax Error (%d,%d): Unexpected %s';

constructor TParser.Create(const aTokenList: TTokenList);
begin
  inherited Create;
  if not Assigned(aTokenList) then
    raise Exception.Create('Token List is nil in '+self.ClassName);
  fConfig:=TParserConfig.Create;
  fLogger:=TDefaultLogger.Create;
  fMessages:=TObjectList<TParserMessage>.Create;
  fSections:=TObjectList<TSection>.Create;
  fSectionsExternallyAssigned:=False;
  fTokenList:=aTokenList;
  fStatus:=psNotStarted;
  fSectionsDictionary:=TDictionary<string, TSection>.Create;
  loadSections;
end;

destructor TParser.Destroy;
begin
  fMessages.Free;
  fSectionsDictionary.Free;
  if not fSectionsExternallyAssigned then
    fSections.Free;
  inherited;
end;

procedure TParser.checkSyntaxErrors;
var
  token: PToken;
  numOpeningParenthesis: Integer;
  numClosingParenthesis: Integer;
  openedSquare: Boolean;
  errMes: TParserMessage;
  errString: string;
begin
  fLogger.log('Checking for syntax errors...');

  openedSquare:=False;
  numOpeningParenthesis:=0;
  numClosingParenthesis:=0;

  for token in fTokenList do
  begin
    if (token^.&Type=ttLSquareBracket) then
      if openedSquare then
      begin
        errString:= Format(sSyntaxError,
                              [token^.StartPosition.Column,
                                token^.StartPosition.Row, '[']);
        postError(errString);
        fLogger.log('Parsing aborted');
        Exit;
      end
      else
        openedSquare:=True;
    if (token^.&Type=ttRSquareBracket) then
      if not openedSquare then
      begin
        errString:= Format(sSyntaxError,
                              [token^.StartPosition.Column,
                                token^.StartPosition.Row, ']']);
        postError(errString);
        fLogger.log('Parsing aborted');
        Exit;
      end
      else
        openedSquare:=False;
  end;

  fLogger.log('Syntax checking finished...');
end;

procedure TParser.cleanWhiteSpace;
var
  token,
  secToken: PToken;
  numAssignments: Integer;
  insideComment: Boolean;
  multiLine: Boolean;
begin
  fLogger.log('Cleaning white space...');

  numAssignments:=0;
  insideComment:=False;
  multiLine:=False;
  for token in fTokenList do
  begin
    //Clean comments;
    if token^.&Type=ttComment then
      insideComment:=True;
    if insideComment then
      token^.IsDeleted:=True;

    //Spaces
    if (token^.&Type=ttAssignment) and
          (numAssignments = 0) then
      numAssignments := 1;
    if token^.&Type=ttSpace then
    begin
      token^.IsDeleted:= True;
      if fConfig.RespectSpacesInValues and (numAssignments >= 1) then
          token^.IsDeleted:= False;
    end;

    //Multi-line
    if (token^.&Type=ttBackslash) or (token^.&Type=ttDoubleSlash) then
    begin
      token^.IsDeleted:=True;
      multiLine:=True;
    end;

    //Reset counters
    if token^.&Type=ttEOL then
    begin
      if multiLine then
      begin
         token^.IsDeleted:=True;
         multiLine:=False;
      end;
      insideComment:=False;
      numAssignments:=0;
    end;
  end;

  //Remove deleted tokens
  for token in fTokenList do
    if token^.IsDeleted then
    begin
      fTokenList.Remove(token);
      Dispose(token);
    end;

  fLogger.log('Cleaning white space finished');
end;

{ TParser }

function TParser.getConfig: IParserConfig;
begin
  Result:=fConfig;
end;

function TParser.getLogger: ILogger;
begin
  Result:=fLogger;
end;

function TParser.getMessages: TObjectList<TParserMessage>;
begin
  Result:=fMessages;
end;

function TParser.getSections: TObjectList<TSection>;
begin
  Result:=fSections;
end;

function TParser.getStatus: TParserStatus;
begin
  Result:=fStatus;
end;

procedure TParser.loadSections;
var
  section: TSection;
begin
  if fConfig.AutoAssignSections then
  begin
    fSections.Clear;

    section:=TSection.Create;
    section.EnforceTag:=True;
    section.Header:='request_definition';
    section.Required:=True;
    section.Tag:='r';
    section.&Type:=stRequestDefinition;
    fSections.Add(section);

    section:=TSection.Create;
    section.EnforceTag:=True;
    section.Header:='policy_definition';
    section.Required:=True;
    section.Tag:='p';
    section.&Type:=stPolicyDefinition;
    fSections.Add(section);

    section:=TSection.Create;
    section.EnforceTag:=True;
    section.Header:='role_definition';
    section.Required:=False;
    section.Tag:='g';
    section.&Type:=stRoleDefinition;
    fSections.Add(section);

    section:=TSection.Create;
    section.EnforceTag:=True;
    section.Header:='policy_effect';
    section.Required:=True;
    section.Tag:='e';
    section.&Type:=stPolicyEffect;
    fSections.Add(section);

    section:=TSection.Create;
    section.EnforceTag:=True;
    section.Header:='matchers';
    section.Required:=True;
    section.Tag:='m';
    section.&Type:=stMatchers;
    fSections.Add(section);
  end;

  fSectionsDictionary.Clear;
  for section in fSections do
    fSectionsDictionary.Add(section.Header, section);

end;

procedure TParser.parse;
begin
  fMessages.Clear;
  fLogger.log('Parsing is starting...');
  fStatus:=psRunning;

  cleanWhiteSpace;

  checkSyntaxErrors;

  fLogger.log('Parsing finished');
  if fStatus=psRunning then
    fStatus:=psFinished;
end;

procedure TParser.postError(var errString: string);
var
  errMes: TParserMessage;
begin
  errMes:=TParserMessage.Create(peError, errString);
  errMes.ErrorType:=peSyntaxError;
  fMessages.Add(errMes);
  fStatus:=psError;
  fLogger.log(errString);
end;

procedure TParser.setConfig(const aValue: IParserConfig);
begin
  if not Assigned(aValue) then
    raise Exception.Create('Config is nil in '+self.ClassName);
  fConfig:=nil;
  fConfig:=aValue;
  loadSections;
end;

procedure TParser.setLogger(const aValue: ILogger);
begin
  if not Assigned(aValue) then
    raise Exception.Create('Logger is nil in '+self.ClassName);
  fLogger:=nil;
  fLogger:=aValue;
end;

procedure TParser.setSections(const aValue: TObjectList<TSection>);
begin
  if not Assigned(aValue) then
    raise Exception.Create('Sections list is nil in '+self.ClassName);
  fSections.Free;
  fSections:=aValue;
  fSectionsExternallyAssigned:=True;
  loadSections;
end;

function TParser.toOutputString: string;
var
  token: PToken;
begin
  for token in fTokenList do
    if not token^.IsDeleted then
      Result:=Result+token^.Value;
end;

end.
