unit Casbin.AST;

interface

uses
  Casbin.Core.Base.Types, Casbin.AST.Types, Casbin.Model.Sections.Types,
  Casbin.Lexer.Tokens.List,
  Casbin.Core.Logger.Types, Casbin.Parser.Messages, System.Generics.Collections;

type
  TAST = class (TBaseInterfacedObject, IAST)
  private
    fList: TList<TBaseNode>;
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
  System.SysUtils, Casbin.Core.Logger.Default, Casbin.Lexer.Tokens.Types, System.TypInfo, System.StrUtils, Casbin.Model.Sections.Default;

constructor TAST.Create(const aTokenList: TTokenList);
begin
  if not Assigned(aTokenList) then
    raise Exception.Create('TokenList is nil in '+self.ClassName);
  inherited Create;
  fList:=TList<TBaseNode>.Create;
  fLogger:=TDefaultLogger.Create;
  fMessages:=TObjectList<TParserMessage>.Create;
  fSections:=TObjectList<TSection>.Create;
  fSectionsExternallyAssigned:=False;
  fTokenList:=aTokenList;
end;

procedure TAST.createAST;
var
  token: PToken;
  head: THeadNode;
  header: THeaderNode;
  insideSquared: Boolean;
  testValue: string;
begin
  fMessages.Clear;
  fList.Clear;

  insideSquared:=False;

  head:=THeadNode.Create;
  head.NodeType:=ntHead;

  fList.Add(head);

  for token in fTokenList do
  begin
    if not token^.IsDeleted then
    begin
      case token^.&Type of
        ttIdentifier: begin
                        if insideSquared then
                        begin
                          header:=THeaderNode.Create;
                          header.NodeType:=ntHeader;
                          header.Value:=token^.Value;

                          testValue:= UpperCase(token^.Value);
                          case IndexStr(testValue,
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
                          fList.Add(header);
                        end;
                      end;
        ttLSquareBracket: insideSquared:=True;
        ttRSquareBracket: insideSquared:=False;
        ttAssignment: ;
        ttComma: ;
        ttLParenthesis: ;
        ttRParenthesis: ;
        ttUnderscore: ;
        ttDot: ;
        ttColon: ;
        ttEquality: ;
        ttDoubleSlash: ;
        ttBackslash: ;
        //Operations
        ttAND: ;
        ttOR: ;
        ttNOT: ;
        ttAdd: ;
        ttMinus: ;
        ttMultiply: ;
        ttDivide: ;
        ttModulo: ;
        ttGreaterThan: ;
        ttGreaterEqualThan: ;
        ttLowerThan: ;
        ttLowerEqualThan: ;
      end;
    end;
  end;
end;

destructor TAST.Destroy;
var
  obj: TObject;
begin
  for obj in fList do
    obj.Free;
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
  for node in fList do
  begin
    if not (node is THeadNode) then
      Result:=Result+node.Value+sLineBreak;
  end;
  Result:=LeftStr(Result, Length(Result)-Length(sLineBreak));
end;

end.
