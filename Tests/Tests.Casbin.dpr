program Tests.Casbin;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EDebugExports,
  EDebugJCL,
  EFixSafeCallException,
  EMapWin32,
  EAppConsole,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Tests.Logger in 'Tests.Logger.pas',
  Casbin.Model.Sections.Types in '..\SourceCode\Common\Model\Casbin.Model.Sections.Types.pas',
  Casbin.Model.Sections.Default in '..\SourceCode\Common\Model\Casbin.Model.Sections.Default.pas',
  Casbin.Parser.Types in '..\SourceCode\Common\Parser\Casbin.Parser.Types.pas',
  Casbin.Parser.AST.Types in '..\SourceCode\Common\Parser\Casbin.Parser.AST.Types.pas',
  Casbin.Parser in '..\SourceCode\Common\Parser\Casbin.Parser.pas',
  Tests.Parser in 'Tests.Parser.pas',
  Casbin.Core.Logger.Types in '..\SourceCode\Common\Loggers\Casbin.Core.Logger.Types.pas',
  Casbin.Core.Logger.Default in '..\SourceCode\Common\Loggers\Casbin.Core.Logger.Default.pas',
  Casbin.Core.Logger.Base in '..\SourceCode\Common\Loggers\Casbin.Core.Logger.Base.pas',
  Casbin.Core.Defaults in '..\SourceCode\Common\Core\Casbin.Core.Defaults.pas',
  Casbin.Core.Base.Types in '..\SourceCode\Common\Core\Casbin.Core.Base.Types.pas',
  Casbin.Core.Strings in '..\SourceCode\Common\Core\Casbin.Core.Strings.pas',
  Casbin.Parser.AST in '..\SourceCode\Common\Parser\Casbin.Parser.AST.pas',
  Tests.Parser.AST in 'Tests.Parser.AST.pas',
  Casbin.Effect.Types in '..\SourceCode\Common\Effect\Casbin.Effect.Types.pas',
  Casbin.Effect in '..\SourceCode\Common\Effect\Casbin.Effect.pas',
  Tests.Effect in 'Tests.Effect.pas',
  Casbin.Matcher.Types in '..\SourceCode\Common\Matcher\Casbin.Matcher.Types.pas',
  Casbin.Matcher in '..\SourceCode\Common\Matcher\Casbin.Matcher.pas',
  oObjects in '..\SourceCode\Common\Third Party\TExpressionParser\oObjects.pas',
  ParseClass in '..\SourceCode\Common\Third Party\TExpressionParser\ParseClass.pas',
  ParseExpr in '..\SourceCode\Common\Third Party\TExpressionParser\ParseExpr.pas',
  Tests.Matcher in 'Tests.Matcher.pas',
  Casbin.Functions.Types in '..\SourceCode\Common\Functions\Casbin.Functions.Types.pas',
  Casbin.Functions in '..\SourceCode\Common\Functions\Casbin.Functions.pas',
  Tests.Functions in 'Tests.Functions.pas',
  Casbin.Adapter.Types in '..\SourceCode\Common\Adapters\Casbin.Adapter.Types.pas',
  Casbin.Adapter.Base in '..\SourceCode\Common\Adapters\Casbin.Adapter.Base.pas',
  Tests.Adapter.FileSystem in 'Tests.Adapter.FileSystem.pas',
  Casbin.Model.Types in '..\SourceCode\Common\Model\Casbin.Model.Types.pas',
  Casbin.Model in '..\SourceCode\Common\Model\Casbin.Model.pas',
  Casbin.Exception.Types in '..\SourceCode\Common\Core\Casbin.Exception.Types.pas',
  Tests.Model in 'Tests.Model.pas',
  Casbin.Core.Utilities in '..\SourceCode\Common\Core\Casbin.Core.Utilities.pas',
  Casbin.Adapter.Filesystem in '..\SourceCode\Common\Adapters\Casbin.Adapter.Filesystem.pas',
  Casbin.Adapter.Policy.Types in '..\SourceCode\Common\Adapters\Casbin.Adapter.Policy.Types.pas',
  Casbin.Adapter.Filesystem.Policy in '..\SourceCode\Common\Adapters\Casbin.Adapter.Filesystem.Policy.pas',
  Tests.Adapter.Filesystem.Policy in 'Tests.Adapter.Filesystem.Policy.pas',
  Casbin.Policy.Types in '..\SourceCode\Common\Policy\Casbin.Policy.Types.pas',
  Casbin.Policy in '..\SourceCode\Common\Policy\Casbin.Policy.pas',
  Tests.Policy in 'Tests.Policy.pas',
  Tests.Policy.RBACWithDomainsPolicy in 'Tests.Policy.RBACWithDomainsPolicy.pas',
  Casbin.Types in '..\SourceCode\Common\Casbin\Casbin.Types.pas',
  Casbin in '..\SourceCode\Common\Casbin\Casbin.pas',
  Tests.Casbin.Main in 'Tests.Casbin.Main.pas',
  Casbin.Resolve.Types in '..\SourceCode\Common\Casbin\Casbin.Resolve.Types.pas',
  Casbin.Resolve in '..\SourceCode\Common\Casbin\Casbin.Resolve.pas',
  Tests.Casbin.Resolve in 'Tests.Casbin.Resolve.pas',
  Casbin.Adapter.Memory in '..\SourceCode\Common\Adapters\Casbin.Adapter.Memory.pas',
  Casbin.Adapter.Memory.Policy in '..\SourceCode\Common\Adapters\Casbin.Adapter.Memory.Policy.pas',
  Tests.Adapter.MemorySystem in 'Tests.Adapter.MemorySystem.pas',
  Tests.Adapter.MemorySystem.Policy in 'Tests.Adapter.MemorySystem.Policy.pas',
  Tests.Policy.Roles in 'Tests.Policy.Roles.pas',
  ArrayHelper in '..\SourceCode\Common\Third Party\ArrayHelper\ArrayHelper.pas',
  Casbin.Watcher.Types in '..\SourceCode\Common\Watcher\Casbin.Watcher.Types.pas',
  Tests.Watcher in 'Tests.Watcher.pas',
  Casbin.Functions.IPMatch in '..\SourceCode\Common\Functions\Casbin.Functions.IPMatch.pas',
  Casbin.Functions.KeyMatch in '..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch.pas',
  Casbin.Functions.KeyMatch2 in '..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch2.pas',
  Casbin.Functions.KeyMatch3 in '..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch3.pas',
  Casbin.Functions.RegExMatch in '..\SourceCode\Common\Functions\Casbin.Functions.RegExMatch.pas',
  Tests.Adapter.Base in 'Tests.Adapter.Base.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  ReportMemoryLeaksOnShutdown:=True;
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.






