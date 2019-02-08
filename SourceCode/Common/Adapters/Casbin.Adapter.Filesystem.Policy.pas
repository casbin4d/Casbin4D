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
unit Casbin.Adapter.Filesystem.Policy;

interface

uses
  Casbin.Adapter.Filesystem, Casbin.Adapter.Policy.Types, Casbin.Core.Base.Types;

type
  TPolicyFileAdapter = class (TFileAdapter, IPolicyAdapter)
  private
    fCached: Boolean;
    fAutosave: Boolean;
    fCacheSize: Integer;
    fSaved: Boolean;
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
    procedure load(const aFilter: TFilterArray = []); override;
    procedure save; override;
{$ENDREGION}
{$REGION 'IPolicyAdapter'}
    procedure remove(const aPolicyDefinition: string); overload;
{$ENDREGION}
    constructor Create(const aFilename: string); override;
  end;

implementation

uses
  System.SysUtils, Casbin.Core.Utilities, System.Classes, System.Generics.Collections, System.IOUtils, System.Types;

{ TPolicyFileAdapter }

procedure TPolicyFileAdapter.add(const aTag: string);
begin
  if Trim(aTag)<>'' then
  begin
    getAssertions.Add(Trim(aTag));
    fSaved:=False;
  end;
end;

constructor TPolicyFileAdapter.Create(const aFilename: string);
begin
  inherited;
  fAutosave:=True;
  fCached:=False;      //PALOFF
  fCacheSize:=DefaultCacheSize;
  fSaved:=False;
end;

function TPolicyFileAdapter.getAutoSave: Boolean;
begin
  Result:=fAutosave;
end;

function TPolicyFileAdapter.getCached: Boolean;
begin
  Result:=fCached;
end;

function TPolicyFileAdapter.getCacheSize: Integer;
begin
  Result:=fCacheSize;
end;

procedure TPolicyFileAdapter.load(const aFilter: TFilterArray);
var
  policy: string;
  filter: string;
  i: Integer;
  found: Boolean;
begin
  // DO NOT CALL inherited when CACHE is implemented
  // WE NEED TO MANAGE THE CACHE
  {TODO -oOwner -cGeneral : Implement Cache}
  inherited; // <-- This should be removed when Cache is implemented
             //     But the fFiltered should be managed here
             //     And the fFilter property
  fFilter:=aFilter;
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
end;

procedure TPolicyFileAdapter.remove(const aPolicyDefinition: string);
var
  assertion: string;
begin
  if Trim(aPolicyDefinition)='' then
    Exit;
  for assertion in getAssertions do
    if SameText(UpperCase(Trim(aPolicyDefinition)), UpperCase(trim(assertion))) then
    begin
      getAssertions.Remove(assertion);
      Break;
    end;
  fSaved:=False;
  if fAutosave then
    save;

  // We need to remove and role-based policies

end;

procedure TPolicyFileAdapter.save;
begin
  inherited;
  if not fSaved then
  begin
    TFile.WriteAllLines(fFilename, TStringDynArray(getAssertions.ToArray));
    fSaved:=True;
  end;
end;

procedure TPolicyFileAdapter.setAutoSave(const aValue: Boolean);
begin
  fAutosave:=aValue;
end;

procedure TPolicyFileAdapter.setCached(const aValue: Boolean);
begin
  fCached:=aValue;
end;

procedure TPolicyFileAdapter.setCacheSize(const aValue: Integer);
begin
  fCacheSize:=aValue;
end;

end.
