program MainDemo;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  Casbin.Watcher.Types in '..\..\SourceCode\Common\Watcher\Casbin.Watcher.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
