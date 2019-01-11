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
unit Tests.Adapter.Filesystem.Policy;

interface
uses
  DUnitX.TestFramework, Casbin.Adapter.Types, Casbin.Adapter.Policy.Types;

type

  [TestFixture]
  TTestPolicyFileAdapter = class(TObject)
  private
    fFilesystem: IPolicyAdapter;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testCached;
    [Test]
    procedure testAutoSave;
    [Test]
    procedure testCachSize;
    [Test]
    procedure testFiltered;

    [Test]
    [TestCase ('Without Filter', ' #p, alice, data1, read, allow'+sLineBreak+
                                 'p, bob, data2, write, allow'+sLineBreak+
                                 'p, data2_admin, data2, read, allow'+sLineBreak+
                                 'p, data2_admin, data2, write, allow'+sLineBreak+
                                 'p, alice, data2, write, deny'+sLineBreak+
                                 sLineBreak+
                                 'g, alice, data2_admin','#')]
    [TestCase ('First Param', 'alice#p, alice, data1, read, allow'+sLineBreak+
                                    'p, alice, data2, write, deny'+
                                     sLineBreak+
                                    'g, alice, data2_admin','#')]
    [TestCase ('Two Consecutive Param', 'alice, data1#'+ sLineBreak+
                                     'p, alice, data1, read, allow'+sLineBreak+
                                     'p, alice, data2, write, deny'+sLineBreak+
                                     'g, alice, data2_admin','#')]
    [TestCase ('Second Param', ' , data1#p, alice, data1, read, allow','#')]
    [TestCase ('Third Param', ' , , write#'+
                                 'p, bob, data2, write, allow'+sLineBreak+
                                 'p, data2_admin, data2, write, allow'+sLineBreak+
                                 'p, alice, data2, write, deny','#')]
    procedure testload(const aFilter, aExpected: string);

    [Test]
    [TestCase ('Add.1', 'p,a,b,c#p,a,b,c','#')]
    procedure testAdd(const aAssertion, aExpected: string);
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy, System.SysUtils, System.Classes, System.Types;

procedure TTestPolicyFileAdapter.Setup;
begin
  fFilesystem:=TPolicyFileAdapter.Create('..\..\..\Examples\Default\rbac_with_deny_policy.csv');
end;

procedure TTestPolicyFileAdapter.TearDown;
begin
end;


procedure TTestPolicyFileAdapter.testAdd(const aAssertion, aExpected: string);
begin
  fFilesystem.add(aAssertion);
  Assert.AreEqual(Trim(aExpected), trim(fFilesystem.toOutputString));
end;

procedure TTestPolicyFileAdapter.testAutoSave;
begin
  Assert.AreEqual(true, fFilesystem.AutoSave, 'default');
  fFilesystem.AutoSave:=not fFilesystem.AutoSave;
  Assert.AreEqual(false, fFilesystem.AutoSave, 'changed');
end;

procedure TTestPolicyFileAdapter.testCached;
begin
  Assert.AreEqual(False, fFilesystem.Cached, 'default');
  fFilesystem.Cached:=not fFilesystem.Cached;
  Assert.AreEqual(true, fFilesystem.Cached, 'changed');
end;

procedure TTestPolicyFileAdapter.testCachSize;
begin
  Assert.AreEqual(15, fFilesystem.CacheSize, 'default');
  fFilesystem.CacheSize:=100;
  Assert.AreEqual(100, fFilesystem.CacheSize, 'changed');
end;

procedure TTestPolicyFileAdapter.testFiltered;
begin
  Assert.IsFalse(fFilesystem.Filtered, 'Default');
  fFilesystem.load(['alice']);
  Assert.IsTrue(fFilesystem.Filtered, 'Filtered');
  fFilesystem.load;
  Assert.IsFalse(fFilesystem.Filtered, 'Back to Default');
end;

procedure TTestPolicyFileAdapter.testload(const aFilter, aExpected: string);
var
  strArray: TStringDynArray;
  strList: TStringList;
  i: integer;
begin
  strList:=TStringList.Create;
  strList.Delimiter:=',';
  strList.DelimitedText:=Trim(aFilter);
  SetLength(strArray, strList.Count);
  for i:=0 to strList.Count-1 do
    strArray[i]:=strList.Strings[i];
  fFilesystem.load(strArray);
  Assert.AreEqual(Trim(aExpected), Trim(fFilesystem.toOutputString));
  strList.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicyFileAdapter);
end.
