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
  defaultSection: TSectionDefault = (Header: 'default'; Tag: []);

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
    stDefault: begin
                 result:=TSection.Create;
                 result.EnforceTag:=True;
                 result.Header:=defaultSection.Header;
                 result.Required:=True;
                 result.Tag:=defaultSection.Tag;
                 result.&Type:=stDefault;
               end;
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

