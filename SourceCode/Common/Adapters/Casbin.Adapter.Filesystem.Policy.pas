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
    procedure remove (const aPolicyDefinition: string; const aFilter: string); overload;
{$ENDREGION}
    constructor Create(const aFilename: string); override;
  end;

implementation

uses
  System.SysUtils, Casbin.Core.Utilities, System.Classes, System.Generics.Collections;

{ TPolicyFileAdapter }

procedure TPolicyFileAdapter.add(const aTag: string);
begin
  {TODO -oOwner -cGeneral : Add PolicyFilterAdapter.Add}
  raise Exception.Create('Not Implemented Yet');
end;

constructor TPolicyFileAdapter.Create(const aFilename: string);
begin
  inherited;
  fAutosave:=True;
  fCached:=False;
  fCacheSize:=DefaultCacheSize;
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
  filter,
  test: string;
  index: Integer;
  i: Integer;
  filteredArray: TStringList;
  modifiedFilter: TList<string>;
begin
  // DO NOT CALL inherited
  // WE NEED TO MANAGE THE CACHE
  {TODO -oOwner -cGeneral : Implement Cache}
  inherited; // <-- This should be removed when Cache is implemented
             //     But the fFiltered should be managed here
             //     And the fFilter property
  fFilter:=aFilter;
  if Length(aFilter)<>0 then
  begin
    modifiedFilter:=TList<string>.Create;
    for policy in aFilter do
      if trim(policy)='' then
        modifiedFilter.add('*')
      else
        modifiedFilter.Add(Trim(policy));

    filter:='';
    for policy in modifiedFilter do
      filter:=filter+policy+',';
    if filter[findEndPos(filter)] = ',' then
      filter:=Copy(filter, findStartPos, findEndPos(filter)-1);
    filter:=Trim(filter);

    for i:=getAssertions.Count-1 downto 0 do
    begin
      policy:=getAssertions.Items[i];

      filteredArray:=TStringList.Create;
      filteredArray.Delimiter:=',';
      filteredArray.StrictDelimiter:=True;
      filteredArray.DelimitedText:=Trim(policy);

      if filteredArray.Count>=1 then
      begin
        // Here we need to get the role tags from TSectionHeaders
        if (UpperCase(filteredArray.Strings[0])<>'G') and
          (UpperCase(filteredArray.Strings[0])<>'G2') then
        begin
          filteredArray.Delete(0);
          if modifiedFilter.Count<=filteredArray.Count then
          begin
            for index:=0 to modifiedFilter.Count-1 do
            begin
              if modifiedFilter.Items[index] = '*' then
                filteredArray.Strings[index]:='*';
            end;

            test:='';
            for index:=0 to filteredArray.Count-1 do
              test:=test+Trim(filteredArray[index])+',';
            test:=Trim(test);
            if test[findEndPos(test)] = ',' then
              test:=Copy(test, findStartPos, findEndPos(test)-1);

            if Trim(UpperCase(Copy(test, findStartPos, findEndPos(filter)))) <>
                                            Trim(UpperCase(filter)) then
              getAssertions.Delete(i);
          end;
        end;
      end;
      filteredArray.Free;
    end;
    modifiedFilter.Free;
  end;
end;

procedure TPolicyFileAdapter.remove(const aPolicyDefinition, aFilter: string);
begin
  {TODO -oOwner -cGeneral : Add PolicyFilterAdapter.remove}
  raise Exception.Create('Not Implemented Yet');
end;

procedure TPolicyFileAdapter.remove(const aPolicyDefinition: string);
begin
  {TODO -oOwner -cGeneral : Add PolicyFilterAdapter.remove}
  raise Exception.Create('Not Implemented Yet');
end;

procedure TPolicyFileAdapter.save;
begin
  inherited;
   {TODO -oOwner -cGeneral : Add PolicyFilterAdapter.save}
  raise Exception.Create('Not Implemented Yet');
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
