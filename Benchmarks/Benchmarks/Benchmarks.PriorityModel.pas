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
unit Benchmarks.PriorityModel;

interface

uses
  Core.Benchmark.Base, Casbin.Types;

type
  TBenchmarkPriorityModel = class(TBaseBenchmark)
  private
    fCasbin: ICasbin;
  public
    procedure runBenchmark; override;
    procedure setDown; override;
    procedure setUp; override;
  end;

implementation

uses
  Casbin;

{ TBenchmarkPriorityModel }

procedure TBenchmarkPriorityModel.runBenchmark;
var
  i: Integer;
begin
  inherited;
  for i:=0 to Operations do
  begin
    fCasbin.enforce(['alice','data1','read']);
    Percentage:=i / Operations;
  end;
end;

procedure TBenchmarkPriorityModel.setDown;
begin
  inherited;

end;

procedure TBenchmarkPriorityModel.setUp;
begin
  inherited;
  fCasbin:=TCasbin.Create('..\..\..\Examples\Default\priority_model.conf',
                          '..\..\..\Examples\Default\priority_policy.csv');
end;

end.
