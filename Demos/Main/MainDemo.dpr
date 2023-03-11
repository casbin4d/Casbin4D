program MainDemo;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  Casbin.Watcher.Types in '..\..\SourceCode\Common\Watcher\Casbin.Watcher.Types.pas',
  Casbin.Functions.IPMatch in '..\..\SourceCode\Common\Functions\Casbin.Functions.IPMatch.pas',
  Casbin.Functions.KeyMatch in '..\..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch.pas',
  Casbin.Functions.KeyMatch2 in '..\..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch2.pas',
  Casbin.Functions.KeyMatch3 in '..\..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch3.pas',
  Casbin.Functions.RegExMatch in '..\..\SourceCode\Common\Functions\Casbin.Functions.RegExMatch.pas',
  Quick.Chrono in '..\..\SourceCode\Common\Third Party\QuickLib\Quick.Chrono.pas',
  LogWindow in 'LogWindow.pas' {FormLog},
  Logger.Debug in 'Logger.Debug.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
