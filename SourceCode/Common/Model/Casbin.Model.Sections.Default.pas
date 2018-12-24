unit Casbin.Model.Sections.Default;

interface

uses
  Casbin.Model.Sections.Types, System.Generics.Collections;
                                     
function createDefaultSection(const aSection: TSectionType): TSection;

implementation

type
  TSectionDefault = record
    Header: string;
    Tag: array of string;
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
begin
  case aSection of
    stRequestDefinition: begin
                           result:=TSection.Create;
                           result.EnforceTag:=True;
                           result.Header:=requestDefinition.Header;
                           result.Required:=True;
                           result.Tag:=requestDefinition.Tag[0];
                           result.&Type:=stRequestDefinition;
                         end;
    stPolicyDefinition: begin
                          result:=TSection.Create;
                          result.EnforceTag:=True;
                          result.Header:=policyDefinition.Header;
                          result.Required:=True;
                          result.Tag:=policyDefinition.Tag[0];
                          result.&Type:=stPolicyDefinition;
                        end;
    stPolicyEffect: begin
                      result:=TSection.Create;
                      result.EnforceTag:=True;
                      result.Header:=policyEffectDefinition.Header;
                      result.Required:=True;
                      result.Tag:=policyEffectDefinition.Tag[0];
                      result.&Type:=stPolicyEffect;
                    end;
    stMatchers: begin
                  result:=TSection.Create;
                  result.EnforceTag:=True;
                  result.Header:=matchersDefinition.Header;
                  result.Required:=True;
                  result.Tag:=matchersDefinition.Tag[0];
                  result.&Type:=stMatchers;
                end;
    stRoleDefinition1: begin
                        result:=TSection.Create;
                        result.EnforceTag:=True;
                        result.Header:=roleDefinition.Header;
                        result.Required:=False;
                        result.Tag:=roleDefinition.Tag[0];
                        result.&Type:=stRoleDefinition1;    
                      end;
    stRoleDefinition2: begin
                        result:=TSection.Create;
                        result.EnforceTag:=True;
                        result.Header:=roleDefinition.Header;
                        result.Required:=False;
                        result.Tag:=roleDefinition.Tag[1];
                        result.&Type:=stRoleDefinition2;    
                      end;
  end;

end;

end.

