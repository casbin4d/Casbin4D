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
unit Casbin.Adapter.Memory;

interface

uses
  Casbin.Core.Base.Types, Casbin.Adapter.Base, System.Classes;

type
  TMemoryAdapter = class(TBaseAdapter)
  private
    procedure resetSection;
  protected
    fContent: TStringList;
   public
    constructor Create; overload;
    destructor Destroy; override;
    procedure load(const aFilter: TFilterArray); override;
    procedure save; override;
  end;

implementation

constructor TMemoryAdapter.Create;
begin
  inherited;
  fContent:=TStringList.Create;
  resetSection;
end;

destructor TMemoryAdapter.Destroy;
begin
  fContent.Free;
  inherited;
end;

procedure TMemoryAdapter.load(const aFilter: TFilterArray);
begin
  inherited;
  resetSection;
  clear;
  getAssertions.AddRange(fContent.ToStringArray);
end;

procedure TMemoryAdapter.save;
begin
  inherited;
end;

procedure TMemoryAdapter.resetSection;
begin
  if fContent.Count=0 then
  begin
    fContent.Add('[request_definition]');
    fContent.Add('[policy_definition]');
    fContent.Add('[role_definition]');
    fContent.Add('[policy_effect]');
    fContent.Add('[matchers]');
  end;
end;

end.
