unit Casbin.Model.Sections.Default;

interface

uses
  Casbin.Model.Sections.Types, System.Generics.Collections, System.Types;

type
  TSectionDefault = record
    Header: string;
    Tag: TStringDynArray;
  end;

const
  requestDefinition: TSectionDefault = (Header: 'request_definition';
                                         Tag: ['r']);
  policyDefinition: TSectionDefault = (Header: 'policy_definition';
                                         Tag: ['p']);
  roleDefinition: TSectionDefault = (Header: 'role_definition';
                                         Tag: ['g', 'g2']);
  policyEffectDefinition: TSectionDefault = (Header: 'policy_effect';
                                         Tag: ['e']);
  matchersDefinition: TSectionDefault = (Header: 'matchers';
                                         Tag: ['m']);

function createDefaultSection(const aSection: TSectionType): TSection;

implementation


function createDefaultSection(const aSection: TSectionType): TSection;
begin
  case aSection of
    stRequestDefinition: begin
                           result:=TSection.Create;
                           result.EnforceTag:=True;
                           result.Header:=requestDefinition.Header;
                           result.Required:=True;
                           result.Tag:=requestDefinition.Tag;
                           result.&Type:=stRequestDefinition;
                         end;
    stPolicyDefinition: begin
                          result:=TSection.Create;
                          result.EnforceTag:=True;
                          result.Header:=policyDefinition.Header;
                          result.Required:=True;
                          result.Tag:=policyDefinition.Tag;
                          result.&Type:=stPolicyDefinition;
                        end;
    stPolicyEffect: begin
                      result:=TSection.Create;
                      result.EnforceTag:=True;
                      result.Header:=policyEffectDefinition.Header;
                      result.Required:=True;
                      result.Tag:=policyEffectDefinition.Tag;
                      result.&Type:=stPolicyEffect;
                    end;
    stMatchers: begin
                  result:=TSection.Create;
                  result.EnforceTag:=True;
                  result.Header:=matchersDefinition.Header;
                  result.Required:=True;
                  result.Tag:=matchersDefinition.Tag;
                  result.&Type:=stMatchers;
                end;
    stRoleDefinition: begin
                        result:=TSection.Create;
                        result.EnforceTag:=True;
                        result.Header:=roleDefinition.Header;
                        result.Required:=False;
                        result.Tag:=roleDefinition.Tag;
                        result.&Type:=stRoleDefinition;
                      end;
  end;

end;

end.

