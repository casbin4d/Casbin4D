// Copyright 2018 by John Kouraklis and Contributors. All Rights Reserved.
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
unit Casbin.Adapter.Memory;

interface

uses
  Casbin.Core.Base.Types, Casbin.Adapter.Base, System.Classes;

type
  TMemoryAdapter = class(TBaseAdapter)
  private
    procedure resetSections;
   public
    constructor Create; overload;
    procedure load(const aFilter: TFilterArray); override;
    procedure save; override;
  end;

implementation

constructor TMemoryAdapter.Create;
begin
  inherited;
//  resetSections;
end;

procedure TMemoryAdapter.load(const aFilter: TFilterArray);
begin
  inherited;
  resetSections;
end;

procedure TMemoryAdapter.save;
begin
  inherited;
end;

procedure TMemoryAdapter.resetSections;
begin
  if getAssertions.Count=0 then
  begin
    getAssertions.Add('[request_definition]');
    getAssertions.Add('[policy_definition]');
    getAssertions.Add('[role_definition]');
    getAssertions.Add('[policy_effect]');
    getAssertions.Add('[matchers]');
  end;
end;

end.
