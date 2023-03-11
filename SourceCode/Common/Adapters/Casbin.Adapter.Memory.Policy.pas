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
unit Casbin.Adapter.Memory.Policy;

interface

uses
  Casbin.Adapter.Filesystem, Casbin.Adapter.Policy.Types,
  Casbin.Core.Base.Types, Casbin.Adapter.Base, System.Classes;

type
  TPolicyMemoryAdapter = class (TBaseAdapter, IPolicyAdapter)
  private
    procedure resetSections;
  protected
{$REGION 'IPolicyAdapter'}
    procedure add(const aTag: string);
    function getAutoSave: Boolean;
    function getCached: Boolean;

    procedure setAutoSave(const aValue: Boolean);
    procedure setCached(const aValue: Boolean);

    function getCacheSize: Integer;
    procedure setCacheSize(const aValue: Integer);
{$ENDREGION}
  public
{$REGION 'IAdapter'}
    constructor Create;
    procedure load(const aFilter: TFilterArray = []); override;
    procedure save; override;
{$ENDREGION}
{$REGION 'IPolicyAdapter'}
    procedure remove(const aPolicyDefinition: string); overload;
{$ENDREGION}
  end;
implementation

uses
  System.SysUtils;

procedure TPolicyMemoryAdapter.add(const aTag: string);
var
  tag: string;
begin
  tag:=Trim(aTag);
  if (tag <> '') and (getAssertions.IndexOf(tag) = -1) then
    getAssertions.Add(tag);
end;

constructor TPolicyMemoryAdapter.Create;
begin
  inherited;
  resetSections;
end;

function TPolicyMemoryAdapter.getAutoSave: Boolean;
begin
  Result:=True;
end;

function TPolicyMemoryAdapter.getCached: Boolean;
begin
  Result:=False;
end;

function TPolicyMemoryAdapter.getCacheSize: Integer;
begin
  Result:=0;
end;

procedure TPolicyMemoryAdapter.load(const aFilter: TFilterArray);
var
  policy: string;
  filter: string;
  i: Integer;
  found: Boolean;
begin
  inherited; // <-- This loads aFilter to fFilter and sets fFiltered

  // This implementation does not consider cached policies
  // See TFileSystemAdapter for more comments
  if Length(fFilter)<>0 then
  begin
    for i:=getAssertions.Count-1 downto 0 do
    begin
      found:=False;
      policy:=getAssertions.Items[i];
      for filter in fFilter do
        found:=found or policy.Contains(Trim(filter));
      if not found then
        getAssertions.Delete(i);
    end;
  end;
  resetSections;
end;

procedure TPolicyMemoryAdapter.remove(const aPolicyDefinition: string);
begin
  if getAssertions.IndexOf(aPolicyDefinition)>-1 then
    getAssertions.Delete(getAssertions.IndexOf(aPolicyDefinition));
end;

procedure TPolicyMemoryAdapter.resetSections;
begin
  if (getAssertions.Count=0) then
     getAssertions.Add('[default]')
  else
  if ((getAssertions.Count>=1) and
                    (uppercase(getAssertions.Items[0])<>'[DEFAULT]')) then
    getAssertions.Insert(0, '[default]');
end;

procedure TPolicyMemoryAdapter.save;
begin
  inherited;

end;

procedure TPolicyMemoryAdapter.setAutoSave(const aValue: Boolean);
begin

end;

procedure TPolicyMemoryAdapter.setCached(const aValue: Boolean);
begin

end;

procedure TPolicyMemoryAdapter.setCacheSize(const aValue: Integer);
begin

end;

end.
