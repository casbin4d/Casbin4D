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
unit Tests.Casbin.Main.Threaded;

interface
uses
  DUnitX.TestFramework, Tests.Casbin.Main,
  System.Generics.Collections, Casbin.Types;

type

  [TestFixture]
  TTestCasbinThreaded = class(TObject)
  private
    fMain: TTestCasbin;
    fTests: TObjectDictionary<string, TObjectList<TList<string>>>;
    fCasbins: array of ICasbin;
    fExpected: integer;
    fPassed: integer;
  public
    [SetupFixture]
    procedure setupFix;

    [TearDownFixture]
    procedure tearDown;

    [Test]
    procedure testThreaded;
  end;

implementation

uses
  Casbin.Model.Types, Casbin.Policy.Types, Casbin.Model, Casbin.Policy,
  Casbin, SysUtils, Casbin.Model.Sections.Types, Casbin.Adapter.Types, Casbin.Adapter.Filesystem, Casbin.Adapter.Policy.Types,
  Casbin.Adapter.Filesystem.Policy, Casbin.Core.Base.Types, System.Rtti, DUnitX.Attributes, System.Threading;


{ TTestCasbinThreaded }

procedure TTestCasbinThreaded.setupFix;
var
  rc: TRttiContext;
  attr: TCustomAttribute;
  testC: TestCaseAttribute;
  value: TValue;
  params: TList<string>;
  tests: TObjectList<TList<string>>;
  method: TRttiMethod;
  testName: string;
  casbinIndex: integer;
begin
  fExpected:=0;
  SetLength(fCasbins, 0);
  fMain:=TTestCasbin.Create;
  // Stores the following
  // TestCase name : TList < Test Parameters>
  // .... where Test Parameters stores is a TList
  // .... of the parameters to pass to enforce
  fTests:=TObjectDictionary<string, TObjectList<TList<string>>>.Create([doOwnsValues]);

  rc:=TRttiContext.Create;

  for method in rc.GetType(fMain.ClassInfo).GetMethods do
  begin
    if not (method.Name.ToUpper = 'testEnforce'.ToUpper) then
      Continue;
    for attr in method.GetAttributes do
    begin
      if (attr is TestCaseAttribute) then
      begin
        testC:=attr as TestCaseAttribute;
        if testC.Name.IndexOf('.') = -1  then
          testName:=testC.Name
        else
          testName:=testC.Name.Substring(
              0, testC.Name.LastIndexOf('.'));

//        if not (testName.ToUpper = 'Basic Model'.ToUpper) then
//          Continue;

        if not fTests.ContainsKey(testName) then
          fTests.Add(testName, TObjectList<TList<string>>.Create);
        tests:=fTests[testName];
        tests.Add(TList<string>.Create);
        for value in testC.Values do
          tests[tests.Count - 1].Add(value.AsString);
        if tests[tests.Count - 1].Count > 0 then
        begin
          SetLength(fCasbins, Length(fCasbins) + 1);
          casbinIndex:=Length(fCasbins) - 1;
          fCasbins[casbinIndex]:=TCasbin.Create(tests[tests.Count - 1][0], tests[tests.Count - 1][1]);
          fCasbins[casbinIndex].Policy.Adapter.AutoSave:=False;
        end;
        Inc(fExpected);
      end;
    end;
  end;
end;

procedure TTestCasbinThreaded.tearDown;
begin
  fTests.Free;
  fMain.Free;
end;

procedure TTestCasbinThreaded.testThreaded;
var
  tasks: array of ITask;
  testName: string;
  list: TObjectList<TList<string>>;
  mini: TList<string>;
  casbin: ICasbin;
  casbinIndex: integer;
begin
  casbinIndex:=-1;
  for testName in fTests.Keys do
  begin
    Inc(casbinIndex);
    if not (testName = 'Basic Model') then
      Continue;
    list:=fTests[testName];
    if (list.Count > 0) and (list[0].Count >= 4) then
    begin
      for mini in list do
      begin
        SetLength(tasks, Length(tasks) + 1);
        tasks[Length(tasks) - 1]:=TTask.Run(procedure
                                            var
                                              res: boolean;
                                              resS: string;
                                              params: TFilterArray;
                                              localIndex: integer;
                                            begin
                casbinIndex:=AtomicExchange(localIndex, casbinIndex);
                casbin:=fCasbins[localIndex];
                params:=TFilterArray(mini[2].Split([',']));
                res:=casbin.enforce(params);
                if BoolToStr(res, true).ToUpper = mini[3].ToUpper then
                  AtomicIncrement(fPassed);
                                            end);
      end;
    end;
  end;
  TTask.WaitForAll(tasks);
  Assert.AreEqual(fExpected, fPassed);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCasbinThreaded);
end.
