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
unit Tests.Functions;

interface
uses
  DUnitX.TestFramework, Casbin.Functions.Types;

type

  [TestFixture]
  TTestFunctions = class(TObject)
  private
    fFunctions: IFunctions;

    function testFunction(const Args: array of string): Boolean;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testAddNull;
    [Test]
    procedure testAddNameIsEmpty;

    [Test]
    [TestCase('KeyMatch', 'KeyMatch')]
    procedure testLoadBuiltInFunctions(const aName: string);

    [Test]
    [TestCase('KeyMatch-1', '/foo,/foo,true')]
    [TestCase('KeyMatch-2', '/foo,/foo*,true')]
    [TestCase('KeyMatch-3', '/foo,/foo/*,false')]
    [TestCase('KeyMatch-4', '/foo/bar,/foo,false')]
    [TestCase('KeyMatch-5', '/foo/bar,/foo*,true')]
    [TestCase('KeyMatch-6', '/foo/bar,/foo/*,true')]
    [TestCase('KeyMatch-7', '/foobar,/foo,false')]
    [TestCase('KeyMatch-8', '/foobar,/foo*,true')]
    [TestCase('KeyMatch-9', '/foobar,/foo/*,false')]
    [TestCase('KeyMatch-10', '/foo/b,/foo/*,true')]
    procedure testKeyMatch(const aKey1, aKey2: string; const aResult: boolean);

    [Test]
    [TestCase('KeyMatch2-1', '/foo,/foo,true')]
    [TestCase('KeyMatch2-2', '/foo,/foo*,true')]
    [TestCase('KeyMatch2-3', '/foo,/foo/*,false')]
    [TestCase('KeyMatch2-4', '/foo/bar,/foo,true')] // different from KeyMatch
    [TestCase('KeyMatch2-5', '/foo/bar,/foo*,true')]
    [TestCase('KeyMatch2-6', '/foo/bar,/foo/*,true')]
    [TestCase('KeyMatch2-7', '/foobar,/foo,true')] // different from KeyMatch
    [TestCase('KeyMatch2-8', '/foobar,/foo*,true')]
    [TestCase('KeyMatch2-9', '/foobar,/foo/*,false')]

    [TestCase('KeyMatch2-10', '/,/:resource,false')]
    [TestCase('KeyMatch2-11', '/resource1,/:resource,true')]
    [TestCase('KeyMatch2-12', '/myid,/:id/using/:resId,false')]
    [TestCase('KeyMatch2-13', '/myid/using/myresid,/:id/using/:resId,true')]

    [TestCase('KeyMatch2-14', '/proxy/myid,/proxy/:id/*,false')]
    [TestCase('KeyMatch2-15', '/proxy/myid/,/proxy/:id/*,true')]
    [TestCase('KeyMatch2-16', '/proxy/myid/res,/proxy/:id/*,true')]
    [TestCase('KeyMatch2-17', '/proxy/myid/res/res2,/proxy/:id/*,true')]
    [TestCase('KeyMatch2-18', '/proxy/myid/res/res2/res3,/proxy/:id/*,true')]
    [TestCase('KeyMatch2-19', '/proxy/,/proxy/:id/*,false')]

    [TestCase('KeyMatch2-20', '/alice,/:id,true')]
    [TestCase('KeyMatch2-21', '/alice/all,/:id/all,true')]
    [TestCase('KeyMatch2-22', '/alice,/:id/all,false')]
    [TestCase('KeyMatch2-23', '/alice/all,/:id,false')]
    [TestCase('KeyMatch2-24', '/foo/b,/foo/*,true')]
    procedure testKeyMatch2(const aKey1, aKey2: string; const aResult: boolean);

    [Test]
    [TestCase('KeyMatch3-1', '/foo,/foo,true')]
    [TestCase('KeyMatch3-2', '/foo,/foo*,true')]
    [TestCase('KeyMatch3-3', '/foo,/foo/*,false')]
    [TestCase('KeyMatch3-4', '/foo/bar,/foo,true')] // different from KeyMatch
    [TestCase('KeyMatch3-5', '/foo/bar,/foo*,true')]
    [TestCase('KeyMatch3-6', '/foo/bar,/foo/*,true')]
    [TestCase('KeyMatch3-7', '/foobar,/foo,true')] // different from KeyMatch
    [TestCase('KeyMatch3-8', '/foobar,/foo*,true')]
    [TestCase('KeyMatch3-9', '/foobar,/foo/*,false')]

    [TestCase('KeyMatch3-10', '/,/{resource},false')]
    [TestCase('KeyMatch3-11', '/resource1,/{resource},true')]
    [TestCase('KeyMatch3-12', '/myid,/{id}/using/{resId},false')]
    [TestCase('KeyMatch3-13', '/myid/using/myresid,/{id}/using/{resId},true')]

    [TestCase('KeyMatch3-14', '/proxy/myid,/proxy/{id}/*,false')]
    [TestCase('KeyMatch3-15', '/proxy/myid/,/proxy/{id}/*,true')]
    [TestCase('KeyMatch3-16', '/proxy/myid/res,/proxy/{id}/*,true')]
    [TestCase('KeyMatch3-17', '/proxy/myid/res/res2,/proxy/{id}/*,true')]
    [TestCase('KeyMatch3-18', '/proxy/myid/res/res2/res3,/proxy/{id}/*,true')]
    [TestCase('KeyMatch3-19', '/proxy/,/proxy/{id}/*,false')]
    procedure testKeyMatch3(const aKey1, aKey2: string; const aResult: boolean);

    [Test]
    [TestCase('RegExMatch-1', '/topic/create,/topic/create,true')]
    [TestCase('RegExMatch-2', '/topic/create/123,/topic/create,true')]
    [TestCase('RegExMatch-3', '/topic/delete,/topic/create,false')]
    [TestCase('RegExMatch-4', '/topic/edit,/topic/edit/[0-9]+,false')]
    [TestCase('RegExMatch-5', '/topic/edit/123,/topic/edit/[0-9]+,true')]
    [TestCase('RegExMatch-6', '/topic/edit/abc,/topic/edit/[0-9]+,false')]
    [TestCase('RegExMatch-7', '/foo/delete/123,/topic/delete/[0-9]+,false')]
    [TestCase('RegExMatch-8', '/topic/delete/0,/topic/delete/[0-9]+,true')]
    [TestCase('RegExMatch-9', '/topic/edit/123s,/topic/delete/[0-9]+,false')]
    procedure testRegExMatch(const aKey1, aKey2: string; const aResult: boolean);

    [Test]
    [TestCase('IPMatch-1','192.168.2.123,192.168.2.0/24,true')]
    [TestCase('IPMatch-2','192.168.2.123,192.168.3.0/24,false')]
    [TestCase('IPMatch-3','192.168.2.123,192.168.2.0/16,true')]
    [TestCase('IPMatch-4','192.168.2.123,192.168.2.123,true')]
    [TestCase('IPMatch-5','192.168.2.123,192.168.2.123/32,true')]
    [TestCase('IPMatch-6','10.0.0.11,10.0.0.0/8,true')]
    [TestCase('IPMatch-7','11.0.0.123,10.0.0.0/8,false')]
    procedure testIPMatch(const aIP1, aIP2: string; const aResult: boolean);

    [Test]
    [TestCase('InvalidIP','192.168.2.456')]
    [TestCase('InvalidIP','192.-168.2.123')]
    procedure testInvalidIP (const aIP: string);

    [Test]
    procedure testFunctionsList;

    [Test]
    procedure testObjectFunction;
  end;

implementation

uses
  Casbin.Functions, System.SysUtils, System.RegularExpressions, System.Types,
  System.StrUtils, System.Classes, Casbin.Functions.IPMatch,
  Casbin.Functions.KeyMatch, Casbin.Functions.KeyMatch2,
  Casbin.Functions.KeyMatch3, Casbin.Functions.RegExMatch;

procedure TTestFunctions.Setup;
begin
  fFunctions:=TFunctions.Create;
end;

procedure TTestFunctions.TearDown;
begin
end;

procedure TTestFunctions.testAddNameIsEmpty;
var
  proc: TProc;
begin
  proc:=procedure
        var
          func: TCasbinFunc;
        begin
          func:=nil;
          fFunctions.registerFunction('', func);
        end;
  Assert.WillRaise(proc);
end;

procedure TTestFunctions.testAddNull;
var
  proc: TProc;
begin
  proc:=procedure
        var
        func: TCasbinFunc;
        begin
          func:=nil;
          fFunctions.registerFunction('Null', func);
        end;
  Assert.WillRaise(proc);
end;

function TTestFunctions.testFunction(const Args: array of string): Boolean;
begin
  Result:=True;
end;

procedure TTestFunctions.testFunctionsList;
var
  list:TStringList;
begin
  list:=fFunctions.list;
  Assert.IsNotNull(list);
  //The list is sorted
  Assert.AreEqual('IPMatch', list.Strings[0]);
  Assert.AreEqual('KeyMatch', list.Strings[1]);
  Assert.AreEqual('KeyMatch2', list.Strings[2]);
  Assert.AreEqual('KeyMatch3', list.Strings[3]);
  Assert.AreEqual('RegExMatch', list.Strings[4]);
end;

procedure TTestFunctions.testInvalidIP(const aIP: string);
var
  proc: TProc;
begin
  proc:=procedure
        begin
          IPMatch([aIP, aIP]);
        end;
  Assert.WillRaise(proc);
end;

procedure TTestFunctions.testIPMatch(const aIP1, aIP2: string;
  const aResult: boolean);
begin
  Assert.AreEqual(aResult, IPMatch([aIP1, aIP2]));
end;

procedure TTestFunctions.testKeyMatch(const aKey1, aKey2: string; const
    aResult: boolean);
begin
  Assert.AreEqual(aResult, KeyMatch([aKey1, aKey2]));
end;

procedure TTestFunctions.testKeyMatch2(const aKey1, aKey2: string;
  const aResult: boolean);
begin
  Assert.AreEqual(aResult, KeyMatch2([aKey1, aKey2]));
end;

procedure TTestFunctions.testKeyMatch3(const aKey1, aKey2: string;
  const aResult: boolean);
begin
  Assert.AreEqual(aResult, KeyMatch3([aKey1, aKey2]));
end;

procedure TTestFunctions.testLoadBuiltInFunctions(const aName: string);
begin
  Assert.IsTrue(Assigned(fFunctions.retrieveFunction(aName)));
end;

procedure TTestFunctions.testObjectFunction;
var
  func: TCasbinObjectFunc;
begin
  fFunctions.registerFunction('Test', testFunction);
  func:=fFunctions.retrieveObjFunction('Test');
  Assert.IsNotNull(func(['']), 'Retrieval');
  Assert.IsTrue(func(['']));
end;

procedure TTestFunctions.testRegExMatch(const aKey1, aKey2: string;
  const aResult: boolean);
begin
  Assert.AreEqual(aResult, RegExMatch([aKey1, aKey2]));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestFunctions);
end.
