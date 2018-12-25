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
  Casbin.Core.Logger.Types in '..\SourceCode\Common\Core\Casbin.Core.Logger.Types.pas',
  Casbin.Core.Logger.Default in '..\SourceCode\Common\Core\Casbin.Core.Logger.Default.pas',
  Casbin.Core.Logger.Base in '..\SourceCode\Common\Core\Casbin.Core.Logger.Base.pas',
  Casbin.Core.Base.Types in '..\SourceCode\Common\Core\Casbin.Core.Base.Types.pas',
  Test.TokenList in 'Test.TokenList.pas',
  Casbin.Lexer.Tokens.Types in '..\SourceCode\Common\Lexer\Casbin.Lexer.Tokens.Types.pas',
  Casbin.Lexer.Tokens.Messages in '..\SourceCode\Common\Lexer\Casbin.Lexer.Tokens.Messages.pas',
  Casbin.Lexer.Tokens.List in '..\SourceCode\Common\Lexer\Casbin.Lexer.Tokens.List.pas',
  Casbin.Lexer.Tokeniser.Types in '..\SourceCode\Common\Lexer\Casbin.Lexer.Tokeniser.Types.pas',
  Casbin.Lexer.Utilities in '..\SourceCode\Common\Lexer\Casbin.Lexer.Utilities.pas',
  Test.Tokeniser in 'Test.Tokeniser.pas',
  Casbin.Lexer.Tokeniser in '..\SourceCode\Common\Lexer\Casbin.Lexer.Tokeniser.pas',
  Test.TokenMessage in 'Test.TokenMessage.pas',
  Test.Tokeniser.Tokens in 'Test.Tokeniser.Tokens.pas',
  Casbin.Parser.Types in '..\SourceCode\Common\Parser\Casbin.Parser.Types.pas',
  Casbin.Parser.Config.Types in '..\SourceCode\Common\Parser\Casbin.Parser.Config.Types.pas',
  Casbin.Model.Sections.Types in '..\SourceCode\Common\Model\Casbin.Model.Sections.Types.pas',
  Casbin.Parser.Messages in '..\SourceCode\Common\Parser\Casbin.Parser.Messages.pas',
  Test.Parser in 'Test.Parser.pas',
  Test.Parser.Config in 'Test.Parser.Config.pas',
  Casbin.Parser in '..\SourceCode\Common\Parser\Casbin.Parser.pas',
  Casbin.Parser.Config in '..\SourceCode\Common\Parser\Casbin.Parser.Config.pas',
  Casbin.Model.Sections.Default in '..\SourceCode\Common\Model\Casbin.Model.Sections.Default.pas',
  Casbin.AST.Types in '..\SourceCode\Common\Parser\Casbin.AST.Types.pas',
  Casbin.AST in '..\SourceCode\Common\Parser\Casbin.AST.pas',
  Test.AST in 'Test.AST.pas';

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




