unit Casbin.Parser.AST;

interface

uses
  Casbin.Parser.AST.Types;

procedure addAssertion(const aHeader: THeaderNode; const aLine: string);

implementation

uses
  System.SysUtils, Casbin.Model.Sections.Types, System.Classes,
  System.StrUtils, Casbin.Effect.Types;

procedure addAssertion(const aHeader: THeaderNode; const aLine: string);
var
  child: TChildNode;
  assertion: TAssertionNode;
  effect: TEffectNode;
  index: Integer;
  sep: Char;
  key: string;
  objStr: string;
  strList: TstringList;
  value: string;
begin
  if not Assigned(aHeader) then
    raise Exception.Create('Header is nil');

  sep:='=';
  if aHeader.SectionType=stPolicyRules then
    sep:=',';

  index:=Pos(sep, aLine, Low(string));
  if index=0 then
    Exit;

  key:=Copy(aLine, Low(string), index-1);
  value:=Copy(aLine, index+1, Length(aLine));


  case aHeader.SectionType of
    stMatchers,
    stDefault,
    stUnknown: begin
                  child:=TChildNode.Create;
                  child.Key:=key;
                  child.Value:=value;
                  aHeader.ChildNodes.Add(child);
                end;

    stRequestDefinition,
    stPolicyDefinition,
    stPolicyRules: begin
                     strList:=TstringList.Create;
                     try
                       strList.Delimiter:=',';
                       strList.DelimitedText:=value;
                       strList.StrictDelimiter:=True;

                       child:=TChildNode.Create;
                       child.Key:=key;
                       child.Value:=value;
                       aHeader.ChildNodes.Add(child);
                       for objStr in strList do
                       begin
                         assertion:=TAssertionNode.Create;
                         assertion.Key:=key;
                         assertion.Value:=objStr;
                         child.AssertionList.Add(assertion);
                       end;
                     finally
                       strList.Free;
                     end;
                   end;

    stPolicyEffect: begin
                      effect:=TEffectNode.Create;
                      effect.Key:=key;
                      effect.Value:=value;

                      case IndexStr(UpperCase(value),
                                      [UpperCase(effectConditions[0]),
                                       UpperCase(effectConditions[1]),
                                       UpperCase(effectConditions[2]),
                                       UpperCase(effectConditions[3])]) of
                        0: effect.EffectCondition:=ecSomeAllow;
                        1: effect.EffectCondition:=ecNotSomeDeny;
                        2: effect.EffectCondition:=ecSomeAllowANDNotDeny;
                        3: effect.EffectCondition:=ecPriorityORDeny;
                      else
                        effect.EffectCondition:=ecUnknown;
                      end;
                      aHeader.ChildNodes.Add(effect);
                    end;
    {TODO -oOwner -cGeneral : stRoleDefinition}
    stRoleDefinition: ;

  end;
end;


end.
