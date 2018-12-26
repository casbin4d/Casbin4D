program Tests.Casbin;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  EDebugExports,
  EDebugJCL,
  EFixSafeCallException,
  EMapWin32,
  EAppConsole,
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
  Casbin.Core.Logger.Types in '..\SourceCode\Common\Core\Casbin.Core.Logger.Types.pas',
  Casbin.Core.Logger.Default in '..\SourceCode\Common\Core\Casbin.Core.Logger.Default.pas',
  Casbin.Core.Logger.Base in '..\SourceCode\Common\Core\Casbin.Core.Logger.Base.pas',
  Casbin.Core.Defaults in '..\SourceCode\Common\Core\Casbin.Core.Defaults.pas',
  Casbin.Core.Base.Types in '..\SourceCode\Common\Core\Casbin.Core.Base.Types.pas',
  Casbin.Core.Strings in '..\SourceCode\Common\Core\Casbin.Core.Strings.pas',
  Casbin.Parser.AST.Operators.Types in '..\SourceCode\Common\Parser\Casbin.Parser.AST.Operators.Types.pas',
  Casbin.Parser.AST in '..\SourceCode\Common\Parser\Casbin.Parser.AST.pas',
  Tests.Parser.AST in 'Tests.Parser.AST.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
//  ReportMemoryLeaksOnShutdown:=True;
{$IFDEF TESTINSIGHT}
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




