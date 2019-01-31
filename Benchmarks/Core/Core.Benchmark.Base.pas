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
unit Core.Benchmark.Base;

interface

type
  TBenchmarkOnNotify = procedure (const aMessage: string) of object;

  TBaseBenchmark = class
  private
    fName: string;
    fDescription: string;
    fOperations: Integer;
    fPercentage: double;
    fOnNotify: TBenchmarkOnNotify;

    procedure postNotification;
    procedure setPercentage(const aValue: double);
  public
    constructor Create(const aName, aDescription: string; const aOperations:
        Integer);

    procedure setUp; virtual;
    procedure runBenchmark; virtual;
    procedure setDown; virtual;

    property Description: string read fDescription;
    property Name: String read fName;
    property Operations: Integer read fOperations;
    property Percentage: double read fPercentage write setPercentage;

    property OnNotify: TBenchmarkOnNotify read fOnNotify write fOnNotify;
  end;

implementation

uses
  System.SysUtils;

constructor TBaseBenchmark.Create(const aName, aDescription: string; const
    aOperations: Integer);
begin
  inherited Create;
  fName:=trim(aName);
  fDescription:=Trim(aDescription);
  fOperations:=aOperations;
  fPercentage:=0.00;
end;

procedure TBaseBenchmark.postNotification;
begin
  if Assigned(fOnNotify) then
    fOnNotify(Name+': '+Format('%5.2f', [Percentage*100])+'% completed');
end;

procedure TBaseBenchmark.runBenchmark;
begin
  if Assigned(fOnNotify) then
    fOnNotify(sLineBreak+'Running benchmark for '+fName+'...');
end;

procedure TBaseBenchmark.setDown
;
begin
  if Assigned(fOnNotify) then
    fOnNotify(sLineBreak+'Setting things down for '+fName+'...');
end;

procedure TBaseBenchmark.setPercentage(const aValue: double);
begin
  fPercentage := aValue;
  postNotification;
end;

procedure TBaseBenchmark.setUp;
begin
  if Assigned(fOnNotify) then
    fOnNotify(sLineBreak+
    'Setting things up for '+fName+'...');
end;

end.
