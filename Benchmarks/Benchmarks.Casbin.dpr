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
program Benchmarks.Casbin;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Core.Benchmark.Base in 'Core\Core.Benchmark.Base.pas',
  Core.BenchmarkManager in 'Core\Core.BenchmarkManager.pas',
  Benchmarks.RawEnforce in 'Benchmarks\Benchmarks.RawEnforce.pas',
  Benchmarks.BasicModel in 'Benchmarks\Benchmarks.BasicModel.pas',
  Benchmarks.RBACModel in 'Benchmarks\Benchmarks.RBACModel.pas',
  Benchmarks.RBACModelSmall in 'Benchmarks\Benchmarks.RBACModelSmall.pas',
  Benchmarks.RBACModelMedium in 'Benchmarks\Benchmarks.RBACModelMedium.pas',
  Benchmarks.RBACModelLarge in 'Benchmarks\Benchmarks.RBACModelLarge.pas',
  Benchmarks.RBACModelWithResourceRoles in 'Benchmarks\Benchmarks.RBACModelWithResourceRoles.pas',
  Benchmarks.RBACModelWithDomains in 'Benchmarks\Benchmarks.RBACModelWithDomains.pas',
  Benchmarks.ABACModel in 'Benchmarks\Benchmarks.ABACModel.pas',
  Benchmarks.KeyMatchModel in 'Benchmarks\Benchmarks.KeyMatchModel.pas',
  Benchmarks.RBACModelWithDeny in 'Benchmarks\Benchmarks.RBACModelWithDeny.pas',
  Benchmarks.PriorityModel in 'Benchmarks\Benchmarks.PriorityModel.pas';

procedure loadbenchmarks (const aManager: TBenchmarkManager);
var
  benchMark: TBaseBenchmark;
begin
  // Raw Enforce
  benchMark:=TBenchmarkRawEnforce.Create('Raw Enforce', 'Raw Enforce', 1000);
  aManager.addBenchmark(benchMark);

  // Basic Model
  benchMark:=TBenchmarkBasicModel.Create('Basic Model', 'Basic Model', 1000);
  aManager.addBenchmark(benchMark);

  // RBAC Model
  benchMark:=TBenchmarkRBACModel.Create('RBAC Model', '5 Rules (2 Users, 1 Role)', 100);
  aManager.addBenchmark(benchMark);

  // RBAC Model Small
  benchMark:=TBenchmarkRBACModelSmall.Create('RBAC Model Small',
                                    '1100 Rules (1000 Users, 100 Role)', 100);
  aManager.addBenchmark(benchMark);

  // RBAC Model Medium
  benchMark:=TBenchmarkRBACModelMedium.Create('RBAC Model Medium',
                                    '11000 Rules (10000 Users, 1000 Role)', 100);
  aManager.addBenchmark(benchMark);

  // RBAC Model Large
  benchMark:=TBenchmarkRBACModelLarge.Create('RBAC Model Large',
                                    '110000 Rules (100000 Users, 10000 Role)', 100);
  aManager.addBenchmark(benchMark);

  // RBAC Model With Resource Roles
  benchMark:=TBenchmarkRBACModelWithResourceRoles.Create
      ('RBAC Model With Resource Roles',
        '6 Rules (2 Users, 2 Role)', 1000);
  aManager.addBenchmark(benchMark);

  // RBAC Model With Domains
  benchMark:=TBenchmarkRBACModelWithResourceRoles.Create
      ('RBAC With Domains/Tenants',
        '6 Rules (2 Users, 1 Role, 2 Domains)', 1000);
  aManager.addBenchmark(benchMark);

//  // ABAC Model
//  benchMark:=TBenchmarkABACModel.Create
//      ('ABAC',
//        '0 rules 0 Users', 100);
//  aManager.addBenchmark(benchMark);

  // KeyMatch Model
  benchMark:=TBenchmarkKeyMatchModel.Create ('KeyMatch', '', 1000);
  aManager.addBenchmark(benchMark);

  // RBACModelWithDeny Model
  benchMark:=TBenchmarkRBACModelWithDeny.Create
              ('RBAC Model With Deny', '6 rules (2 users, 1 role)', 1000);
  aManager.addBenchmark(benchMark);

  // Priority Model
  benchMark:=TBenchmarkPriorityModel.Create
              ('Priority Model', '9 rules (2 users, 2 roles)', 1000);
  aManager.addBenchmark(benchMark);
end;

var
  benchmarkManager: TBenchmarkManager;
  resString: string;
  dir: string;
begin
  try
    benchmarkManager:=TBenchmarkManager.Create;
    Writeln('Loading benchmarks...');
    loadbenchmarks(benchmarkManager);

    Writeln('Benchmarks started...');

    benchmarkManager.benchmark;

    Writeln;

    for resString in benchmarkManager.Results do
      Writeln(#9+resString);
    Writeln('Benchmark finished');

    dir:=TPath.Combine(ExtractFilePath(ParamStr(0)), 'Results');
    if not DirectoryExists(dir) then
      CreateDir(dir);

    benchmarkManager.Results.SaveToFile(TPath.Combine(dir,
        'benchmark-'+FormatDateTime('ddmmyyyy-hhmm', Now)+'.txt'));
    Writeln('Results saved');

    Write('Press Enter to exit');
    readln;

    benchmarkManager.Free;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
