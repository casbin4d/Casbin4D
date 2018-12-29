unit Casbin.Matcher;

interface

uses
  Casbin.Core.Base.Types, Casbin.Matcher.Types, Casbin.Effect.Types, ParseExpr;

type
  TMatcher = class (TBaseInterfacedObject, IMatcher)
  private
    fMatcherString: string;
    fMathsParser: TCStyleParser;
    procedure cleanMatcher;
  private
  {$REGION 'Interface'}
    function evaluateMatcher(const aMatcherString: string): TEffectResult;
  {$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;

  end;

implementation

uses
  System.StrUtils, System.SysUtils;

constructor TMatcher.Create;
begin
  inherited;
  fMathsParser:=TCStyleParser.Create;
  TCStyleParser(fMathsParser).CStyle:=False;
end;

destructor TMatcher.Destroy;
begin
  fMathsParser.Free;
  inherited;
end;

{ TMatcher }

procedure TMatcher.cleanMatcher;
var
  index: Integer;
begin
  fMatcherString:=ReplaceStr(fMatcherString, '==', '=');
  fMatcherString:=ReplaceStr(fMatcherString, '&&', 'and');
  fMatcherString:=ReplaceStr(fMatcherString, '||', 'or');
  fMatcherString:=ReplaceStr(fMatcherString, '!', 'not');
  index:=Pos('''', fMatcherString, Low(string));
  while Index<>0 do
  begin
    Delete(fMatcherString, index, 1);
    index:=Pos('''', fMatcherString, Low(string));
  end;
end;

function TMatcher.evaluateMatcher(const aMatcherString: string): TEffectResult;
var
  eval: string;
  i: Integer;
begin
  fMatcherString:=aMatcherString;
  cleanMatcher;
  {TODO -oOwner -cGeneral : ReplaceStr(functions in expressions)}
  fMathsParser.Optimize := true;
  i := fMathsParser.AddExpression(trim(fMatcherString));
  eval:=fMathsParser.AsString[i];
  if upperCase(eval)='TRUE' then
    Result:=erAllow
  else
    result:=erDeny;
end;

end.
