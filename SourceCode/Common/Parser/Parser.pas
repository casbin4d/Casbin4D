unit Parser;

interface

uses
  Core.Base.Types, Parser.Types, Parser.Config.Types, Core.Logger.Types,
  System.Generics.Collections, Parser.Messages, Model.Sections.Types,
  Lexer.Tokens.List;

type
  TParser = class (TBaseInterfacedObject, IParser)
  private
    fConfig: IParserConfig;
    fLogger: ILogger;
    fMessages: TObjectList<TParserMessage>;
    fSections: TObjectList<TSection>;
    fTokenList: TTokenList;
    procedure loadSections;
  private
{$REGION 'Interface'}
    function getConfig: IParserConfig;
    function getLogger: ILogger;
    function getMessages: TObjectList<TParserMessage>;
    function getSections: TObjectList<TSection>;
    procedure parse;
    procedure setConfig(const aValue: IParserConfig);
    procedure setLogger(const aValue: ILogger);
    procedure setSections(const aValue: TObjectList<TSection>);
{$ENDREGION}
  public
    constructor Create(const aTokenList: TTokenList);
  end;
implementation

uses
  System.SysUtils, Parser.Config, Core.Logger.Default;

constructor TParser.Create(const aTokenList: TTokenList);
begin
  inherited Create;
  if not Assigned(aTokenList) then
    raise Exception.Create('Token List is nil in '+self.ClassName);
  fConfig:=TParserConfig.Create;
  fLogger:=TDefaultLogger.Create;
  fMessages:=TObjectList<TParserMessage>.Create;
  loadSections;
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

procedure TParser.loadSections;
begin
  // TODO -cMM: TParser.loadSections default body inserted
end;

procedure TParser.parse;
begin

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
  fSections:=aValue;
  loadSections;
end;

end.
