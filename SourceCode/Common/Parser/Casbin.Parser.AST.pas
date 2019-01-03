// Copyright 2018 The Casbin Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
  child: TChildNode;     //PALOFF
  assertion: TAssertionNode;  //PALOFF
  effect: TEffectNode;       //PALOFF
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
                  child:=TChildNode.Create;     //PALOFF
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

                       child:=TChildNode.Create;    //PALOFF
                       child.Key:=key;
                       child.Value:=value;
                       aHeader.ChildNodes.Add(child);
                       for objStr in strList do
                       begin
                         assertion:=TAssertionNode.Create;  //PALOFF
                         assertion.Key:=key;
                         assertion.Value:=objStr;
                         child.AssertionList.Add(assertion);
                       end;
                     finally
                       strList.Free;
                     end;
                   end;

    stPolicyEffect: begin
                      effect:=TEffectNode.Create;  //PALOFF
                      effect.Key:=key;
                      effect.Value:=value;

                      value:=ReplaceStr(value, '_', '.');
                      case IndexStr(UpperCase(value),
                                      [UpperCase(effectConditions[0]),
                                       UpperCase(effectConditions[1]),
                                       UpperCase(effectConditions[2]),
                                       UpperCase(effectConditions[3]),
                                       UpperCase(effectConditions[4]),
                                       UpperCase(effectConditions[5]),
                                       UpperCase(effectConditions[6]),
                                       UpperCase(effectConditions[7])]) of
                        0, 1: effect.EffectCondition:=ecSomeAllow;
                        2, 3: effect.EffectCondition:=ecNotSomeDeny;
                        4, 5: effect.EffectCondition:=ecSomeAllowANDNotDeny;
                        6, 7: effect.EffectCondition:=ecPriorityORDeny;
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
