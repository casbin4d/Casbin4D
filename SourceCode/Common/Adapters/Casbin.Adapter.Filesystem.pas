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
unit Casbin.Adapter.Filesystem;

interface

uses
  Casbin.Adapter.Base, Casbin.Core.Base.Types;

type
  TFileAdapter = class(TBaseAdapter)
  protected
    fFilename: string;
   public
    constructor Create(const aFilename: string); virtual;
    procedure load(const aFilter: TFilterArray); override;
    procedure save; override;
  end;

implementation

uses
  System.SysUtils, System.Generics.Collections, System.IOUtils, System.Types;

constructor TFileAdapter.Create(const aFilename: string);
begin
  if not fileExists(aFilename) then
    raise Exception.Create('File '+aFilename+' does not exist');
  inherited Create;
  fFilename:=aFilename;
end;

{ TFileAdapter }

procedure TFileAdapter.load(const aFilter: TFilterArray);
begin
  inherited;
  Clear;
  getAssertions.AddRange(TFile.ReadAllLines(fFilename));
end;

procedure TFileAdapter.save;
begin
  inherited;
end;

end.
