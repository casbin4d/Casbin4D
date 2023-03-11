unit LogWindow;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox;

type
  TFormLog = class(TForm)
    lbLog: TListBox;
  private

  end;

implementation

{$R *.fmx}

end.
