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
unit Benchmarks.RawEnforce;

interface

uses
  Core.Benchmark.Base;

type
  TSecondArray = array [0..2] of string;

  TBenchmarkRawEnforce = class (TBaseBenchmark)
  private
    fPolicies: array[0..1] of TSecondArray;
  protected
    function benchmarkProcess(aTest: TSecondArray): Boolean;
  public
    procedure setUp; override;
    procedure runBenchmark; override;
    procedure setDown; override;
  end;

implementation

uses
  System.SysUtils;

{ TBenchmarkRawEnforce }

function TBenchmarkRawEnforce.benchmarkProcess(aTest: TSecondArray): Boolean;
var
  i: Integer;
  j: Integer;
begin
  for i:=0 to 1 do
  begin
    Result:=False;
    for j := 0 to 2 do
      if fPolicies[i][j] = aTest[j] then
        Result:=Result and True;
  end;
end;

procedure TBenchmarkRawEnforce.runBenchmark;
var
  i: Integer;
  arr: TSecondArray;
begin
  inherited;
  arr[0]:='alice';
  arr[1]:='data1';
  arr[2]:='read';
  for i:=0 to Operations do
  begin
    benchmarkProcess(arr);
    Percentage:=i / Operations;
  end;
end;

procedure TBenchmarkRawEnforce.setDown;
begin
  inherited;

end;

procedure TBenchmarkRawEnforce.setUp;
begin
  inherited;
  fPolicies[0][0]:='alice';
  fPolicies[0][1]:='data1';
  fPolicies[0][2]:='read';

  fPolicies[1][0]:='bob';
  fPolicies[1][1]:='data2';
  fPolicies[1][2]:='write';

end;

end.
