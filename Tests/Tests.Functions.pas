unit Tests.Functions;

interface
uses
  DUnitX.TestFramework, Casbin.Functions.Types;

type

  [TestFixture]
  TTestFunctions = class(TObject)
  private
    fFunctions: IFunctions;
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
    procedure testKeyMatch(const aKey1, aKey2: string; const aResult: boolean);

    [Test]
    [TestCase('KeyMatch2-1', '/foo,/foo,true')]
    [TestCase('KeyMatch2-2', '/foo,/foo*,true')]
    [TestCase('KeyMatch2-3', '/foo,/foo/*,false')]
    [TestCase('KeyMatch2-4', '/foo/bar,/foo,true')] // different with KeyMatch.
    [TestCase('KeyMatch2-5', '/foo/bar,/foo*,true')]
    [TestCase('KeyMatch2-6', '/foo/bar,/foo/*,true')]
    [TestCase('KeyMatch2-7', '/foobar,/foo,true')] // different with KeyMatch.
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
    procedure testKeyMatch2(const aKey1, aKey2: string; const aResult: boolean);

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
  end;

implementation

uses
  Casbin.Functions, System.SysUtils,
  System.RegularExpressions;

// Built-in functions
// In this section, built-in functions are imported
{$I ..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch.pas}
{$I ..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch2.pas}
{$I ..\SourceCode\Common\Functions\Casbin.Functions.RegExMatch.pas}

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
        begin
          fFunctions.registerFunction('', nil);
        end;
  Assert.WillRaise(proc);
end;

procedure TTestFunctions.testAddNull;
var
  proc: TProc;
begin
  proc:=procedure
        begin
          fFunctions.registerFunction('Null', nil);
        end;
  Assert.WillRaise(proc);
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

procedure TTestFunctions.testLoadBuiltInFunctions(const aName: string);
begin
  Assert.IsTrue(Assigned(fFunctions.retrieveFunction(aName)));
end;

procedure TTestFunctions.testRegExMatch(const aKey1, aKey2: string;
  const aResult: boolean);
begin
  Assert.AreEqual(aResult, RegExMatch([aKey1, aKey2]));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestFunctions);
end.
