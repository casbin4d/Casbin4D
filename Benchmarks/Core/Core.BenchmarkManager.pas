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
//
//
// Timing code from:
//    http://delphiforfun.org/programs/Delphi_Techniques/timing.htm
//
unit Core.BenchmarkManager;

interface

uses
  System.Generics.Collections, System.Classes, Core.Benchmark.Base;

type
 TBenchmarkManager = class
  private
    fBenchmarks: TObjectList<TBaseBenchmark>;
    fResults: TStringList;

    procedure OnNotify (const aMessage: string);

  public
    constructor Create;
    procedure addBenchmark (const aBenchmark: TBaseBenchmark);
    procedure benchmark;
    destructor Destroy; override;

    property Results: TStringList read fResults;
  end;

implementation

uses
  System.SysUtils, Winapi.Windows, System.Threading;

//
// Memory usage code as suggested in:
//    https://stackoverflow.com/questions/437683/how-to-get-the-memory-used-by-a-delphi-program
//
function getUsedMemory: Int64;
var
  st: TMemoryManagerState;
  sb: TSmallBlockTypeState;
begin
  GetMemoryManagerState(st);
  Result := st.TotalAllocatedMediumBlockSize + st.TotalAllocatedLargeBlockSize;
  for sb in st.SmallBlockTypeStates do
    result := result + sb.UseableBlockSize * sb.AllocatedBlockCount;
end;

//
// Code from
//    https://stackoverflow.com/questions/1285979/
//             delphi-function-to-display-number-of-bytes-as-windows-does?
//             noredirect=1&lq=1
//
function bytesToDisplay(A:int64): string;
var
  A1, A2, A3: double;
begin
  A1 := A / 1024;
  A2 := A1 / 1024;
  A3 := A2 / 1024;
  if A1 < 1 then
    Result := floattostrf(A, ffNumber, 15, 0) + ' bytes'
  else
  if A1 < 10 then
    Result := floattostrf(A1, ffNumber, 15, 2) + ' KB'
  else
  if A1 < 100 then
    Result := floattostrf(A1, ffNumber, 15, 1) + ' KB'
  else
  if A2 < 1 then
    Result := floattostrf(A1, ffNumber, 15, 0) + ' KB'
  else
  if A2 < 10 then
    Result := floattostrf(A2, ffNumber, 15, 2) + ' MB'
  else
  if A2 < 100 then
    Result := floattostrf(A2, ffNumber, 15, 1) + ' MB'
  else
  if A3 < 1 then
    Result := floattostrf(A2, ffNumber, 15, 0) + ' MB'
  else
  if A3 < 10 then
    Result := floattostrf(A3, ffNumber, 15, 2) + ' GB'
  else
  if A3 < 100 then
    Result := floattostrf(A3, ffNumber, 15, 1) + ' GB'
  else
    Result := floattostrf(A3, ffNumber, 15, 0) + ' GB';

  Result := Result + ' (' + floattostrf(A, ffNumber, 15, 0) + ' bytes)';
end;

procedure TBenchmarkManager.addBenchmark(const aBenchmark: TBaseBenchmark);
begin
  fBenchmarks.Add(aBenchmark);
end;

procedure TBenchmarkManager.benchmark;
var
  benchmark: TBaseBenchmark;

  totalTime: Double;
  timePerOperation: Double;
  memoryUsed: Int64;

  start: Int64;
  stop: Int64;
  freq: Int64;

begin
  fResults.Clear;

{$IFDEF DEBUG}
  fResults.Add('Benchmarking is running in Debug mode');
{$ELSE}
  fResults.Add('Benchmarking is running in Release mode');
{$ENDIF}

  fResults.Add('System: '+TOSVersion.ToString);
  fResults.Add('Date/Time Stamp: '+FormatDateTime('dd/mm/yyy, hh:mm:ss', Now));
  fResults.Add('');

  for benchmark in fBenchmarks do
  begin
    benchmark.OnNotify:=OnNotify;

    benchmark.setUp;

    queryperformancecounter(start);

    memoryUsed:=getUsedMemory;

    benchmark.runBenchmark;

    memoryUsed:=getUsedMemory - memoryUsed;

    queryperformancecounter(stop);
    queryperformancefrequency(freq);

    benchmark.setDown;

    totalTime:= (stop - start) / freq;
    timePerOperation:= totalTime / benchmark.Operations;

    fResults.Add(format(
    '%s [%s]: %.0n operations in %8.6n sec (%8.6n sec/op) using '+
    ' %s of memory',
                [benchmark.Name, benchmark.Description,
                 benchmark.Operations + 0.0,
                 totalTime, timePerOperation,
                      bytesToDisplay(memoryUsed)]
                  ));
    fResults.Add('');
  end;
end;

constructor TBenchmarkManager.Create;
begin
  inherited;
  fBenchmarks:=TObjectList<TBaseBenchmark>.Create;
  fResults:=TStringList.Create;
end;

destructor TBenchmarkManager.Destroy;
begin
  fBenchmarks.Free;
  fResults.Free;
  inherited;
end;

procedure TBenchmarkManager.OnNotify(const aMessage: string);
begin
  if aMessage.Contains('%') then
    Write(#13+aMessage)
  else
    Writeln(aMessage);

end;

end.
