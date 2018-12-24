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
  Core.Logger.Types in '..\SourceCode\Common\Core\Core.Logger.Types.pas',
  Core.Logger.Default in '..\SourceCode\Common\Core\Core.Logger.Default.pas',
  Core.Logger.Base in '..\SourceCode\Common\Core\Core.Logger.Base.pas',
  Core.Base.Types in '..\SourceCode\Common\Core\Core.Base.Types.pas',
  Test.TokenList in 'Test.TokenList.pas',
  Lexer.Tokens.Types in '..\SourceCode\Common\Lexer\Lexer.Tokens.Types.pas',
  Lexer.Tokens.Messages in '..\SourceCode\Common\Lexer\Lexer.Tokens.Messages.pas',
  Lexer.Tokens.List in '..\SourceCode\Common\Lexer\Lexer.Tokens.List.pas',
  Lexer.Tokeniser.Types in '..\SourceCode\Common\Lexer\Lexer.Tokeniser.Types.pas',
  Lexer.Utilities in '..\SourceCode\Common\Lexer\Lexer.Utilities.pas',
  Test.Tokeniser in 'Test.Tokeniser.pas',
  Lexer.Tokeniser in '..\SourceCode\Common\Lexer\Lexer.Tokeniser.pas',
  Test.TokenMessage in 'Test.TokenMessage.pas',
  Test.Tokeniser.Tokens in 'Test.Tokeniser.Tokens.pas',
  Parser.Types in '..\SourceCode\Common\Parser\Parser.Types.pas',
  Parser.Config in '..\SourceCode\Common\Parser\Parser.Config.pas',
  Parser.Config.Types in '..\SourceCode\Common\Parser\Parser.Config.Types.pas',
  Model.Sections.Types in '..\SourceCode\Common\Model\Model.Sections.Types.pas',
  Parser.Messages in '..\SourceCode\Common\Parser\Parser.Messages.pas',
  Parser in '..\SourceCode\Common\Parser\Parser.pas';

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




