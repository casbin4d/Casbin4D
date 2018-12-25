unit Casbin.AST;

interface

uses
  Casbin.Core.Base.Types, Casbin.AST.Types, Casbin.Model.Sections.Types,
  Casbin.Lexer.Tokens.List,
  Casbin.Core.Logger.Types, Casbin.Parser.Messages, System.Generics.Collections;

type
  TAST = class (TBaseInterfacedObject, IAST)
  private
    fList: THeadNode;
    fTokenList: TTokenList;
    fLogger: ILogger;
    fMessages: TObjectList<TParserMessage>;
    fSections: TObjectList<TSection>;
    fSectionsExternallyAssigned: Boolean;
{$REGION 'MyRegion'}
    procedure createAST;
    function toOutputString: string;

    function getLogger: ILogger;
    function getMessages: TObjectList<TParserMessage>;
    procedure setLogger(const aValue: ILogger);
    procedure setSections(const aValue: TObjectList<TSection>);
{$ENDREGION}
  public
    constructor Create(const aTokenList: TTokenList);
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, Casbin.Core.Logger.Default, Casbin.Lexer.Tokens.Types, System.TypInfo, System.StrUtils, Casbin.Model.Sections.Default,
  Casbin.AST.Utilities, System.Rtti;

constructor TAST.Create(const aTokenList: TTokenList);
begin
  if not Assigned(aTokenList) then
    raise Exception.Create('TokenList is nil in '+self.ClassName);
  inherited Create;
  fList:=THeadNode.Create;
  fLogger:=TDefaultLogger.Create;
  fMessages:=TObjectList<TParserMessage>.Create;
  fSections:=TObjectList<TSection>.Create;
  fSectionsExternallyAssigned:=False;
  fTokenList:=aTokenList;
end;

type
  TSectionIndeces = class
  public
    Start: integer;
    Finish: integer;
  end;

procedure TAST.createAST;
var
  token,
  newToken: PToken;
  ASTHead: TBaseNode;
  header: THeaderNode;
  insideHeader: Boolean;
  insideSection: Boolean;
  testValue: string;
  oneLiner: TTokenList;
  idx: TSectionIndeces;
  dict: TObjectDictionary<THeaderNode, TSectionIndeces>;
  currPosition: Integer;
  currentHeader: THeaderNode;
begin
  fMessages.Clear;
  fList.ChildNodes.Clear;

  dict:=TObjectDictionary<THeaderNode, TSectionIndeces>.Create([doOwnsKeys, doOwnsValues]);

  insideHeader:=False;

  currPosition:=0;
  currentHeader:=nil;
  for token in fTokenList do
  begin
    if not token^.IsDeleted then
    begin
      case token^.&Type of
        ttLSquareBracket: begin
                            insideHeader:=True;
                            insideSection:=False;
                            if Assigned(currentHeader) then
                            begin
                              idx:=dict.Items[currentHeader];
                              idx.Finish:=currPosition - 1;
                              dict.AddOrSetValue(currentHeader, idx);
                            end;
                          end;
        ttRSquareBracket: begin
                            insideHeader:=false;
                            insideSection:=true;
                            if Assigned(currentHeader) then
                            begin
                              idx:=dict.Items[currentHeader];
                              idx.Start:=currPosition + 1;
                              dict.AddOrSetValue(currentHeader, idx);
                            end;
                          end;
      else
        begin
          if (token^.&Type = ttIdentifier) and insideHeader then
          begin
            header:=THeaderNode.Create;
            header.Value:=token^.Value;

            case IndexStr(UpperCase(token^.Value),
                    [UpperCase(requestDefinition.Header),
                     UpperCase(policyDefinition.Header),
                     UpperCase(roleDefinition.Header),
                     UpperCase(policyEffectDefinition.Header),
                     UpperCase(matchersDefinition.Header)
                    ]) of
              0: header.SectionType:=stRequestDefinition;
              1: header.SectionType:=stPolicyDefinition;
              2: header.SectionType:=stRoleDefinition;
              3: header.SectionType:=stPolicyEffect;
              4: header.SectionType:=stMatchers;
            else
              header.SectionType:=stUnknown;
            end;
            dict.Add(header, TSectionIndeces.Create);
            currentHeader:=header;
          end;
        end;
      end;
    end;
    Inc(currPosition);
  end;

  dict.Free;

//
//
//
//
//
//  ASTHead:=fList;
//
//  oneLiner:=TTokenList.Create;
//  for token in fTokenList do
//  begin
//    if token^.&Type<>ttEOL then
//    begin
//      New(newToken);
//      FillChar(newToken^, SizeOf(TToken), 0);
//      newToken^.&Type:=token.&Type;
//      newToken^.Value:=token.Value;
//      newToken^.StartPosition:=token.StartPosition;
//      newToken^.EndPosition:=token.EndPosition;
//      newToken^.IsDeleted:=token.IsDeleted;
//      oneLiner.Add(newToken);
//    end
//    else
//    begin
//      addAssertion(oneLiner, ASTHead);
//      for newToken in oneLiner do
//        Dispose(newToken);
//      oneLiner.Clear;
//    end;
//  end;
//  oneLiner.Free;
end;


destructor TAST.Destroy;
begin
  fList.Free;
  fMessages.Free;
  if not fSectionsExternallyAssigned then
    fSections.Free;
  inherited;
end;

function TAST.getLogger: ILogger;
begin
  Result:=fLogger;
end;

function TAST.getMessages: TObjectList<TParserMessage>;
begin
  Result:=fMessages;
end;

procedure TAST.setLogger(const aValue: ILogger);
begin
  fLogger:=aValue;
end;

procedure TAST.setSections(const aValue: TObjectList<TSection>);
begin
  if not Assigned(aValue) then
    raise Exception.Create('Sections are nil in '+Self.ClassName);
  fSections.Free;
  fSections:=aValue;
  fSectionsExternallyAssigned:= true;
end;

function TAST.toOutputString: string;
var
  node: TBaseNode;
begin
  for node in fList.ChildNodes do
  begin
    Result:=Result+node.Value+sLineBreak;
  end;
  Result:=LeftStr(Result, Length(Result)-Length(sLineBreak));
end;

end.
