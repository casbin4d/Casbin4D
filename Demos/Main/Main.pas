unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ExtCtrls, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FMX.Edit;

type
  TForm1 = class(TForm)
    popupModel: TPopupBox;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    popupPolicies: TPopupBox;
    Memo2: TMemo;
    Layout1: TLayout;
    buttonValidateModel: TButton;
    labelValidateModel: TLabel;
    rectangleModel: TRectangle;
    buttonValidatePolicies: TButton;
    Layout2: TLayout;
    rectanglePolicies: TRectangle;
    labelValidatePolicies: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Layout3: TLayout;
    rectangleEnforced: TRectangle;
    labelEnforced: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure buttonValidateModelClick(Sender: TObject);
    procedure buttonValidatePoliciesClick(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure popupModelChange(Sender: TObject);
    procedure popupPoliciesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.IOUtils, Casbin.Parser.Types, Casbin.Parser;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Random(100) mod 3 = 0 then
  begin
    rectangleEnforced.Fill.Color:=TAlphaColorRec.Red;
    labelEnforced.Text:='DENY';
  end
  else
  begin
    rectangleEnforced.Fill.Color:=TAlphaColorRec.Green;
    labelEnforced.Text:='ALLOW';
  end;
  labelEnforced.FontColor:=TAlphaColorRec.White;
end;

procedure TForm1.buttonValidateModelClick(Sender: TObject);
var
  parser: IParser;
begin
  parser:=TParser.Create(Memo1.Text, ptModel);
  parser.parse;
  if parser.Status=psError then
  begin
    labelValidateModel.Text:=parser.ErrorMessage;
    rectangleModel.Fill.Color:=TAlphaColorRec.Red;
  end
  else
  begin
    labelValidateModel.Text:='No Errors';
    rectangleModel.Fill.Color:=TAlphaColorRec.Green;
  end;
  labelValidateModel.FontColor:=TAlphaColorRec.White;
end;

procedure TForm1.buttonValidatePoliciesClick(Sender: TObject);
var
  parser: IParser;
begin
  parser:=TParser.Create(Memo1.Text, ptPolicy);
  parser.parse;
  if parser.Status=psError then
  begin
    labelValidatePolicies.Text:=parser.ErrorMessage;
    rectanglePolicies.Fill.Color:=TAlphaColorRec.Red;
  end
  else
  begin
    labelValidatePolicies.Text:='No Errors';
    rectanglePolicies.Fill.Color:=TAlphaColorRec.Green;
  end;
  labelValidatePolicies.FontColor:=TAlphaColorRec.White;
end;

procedure TForm1.Edit1ChangeTracking(Sender: TObject);
begin
  labelEnforced.Text:='Not Enforced Yet';
  labelEnforced.FontColor:=TAlphaColorRec.Black;
  rectangleEnforced.Fill.Color:=TAlphaColorRec.Null;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  SRec: TSearchRec;
  Res: Integer;
begin
  Res := FindFirst('..\..\..\..\Examples\Default\*.conf', faAnyfile, SRec );
  if Res = 0 then
  try
    while res = 0 do
    begin
      if (SRec.Attr and faDirectory <> faDirectory) then
        // If you want filename only, remove "StartDir +"
        // from next line
        popupModel.Items.Add(SRec.Name);
      Res := FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
  if popupModel.Items.Count>0 then
    popupModel.ItemIndex:=0;

  //Policies
  Res := FindFirst('..\..\..\..\Examples\Default\*.csv', faAnyfile, SRec );
  if Res = 0 then
  try
    while res = 0 do
    begin
      if (SRec.Attr and faDirectory <> faDirectory) then
        // If you want filename only, remove "StartDir +"
        // from next line
        popupPolicies.Items.Add(SRec.Name);
      Res := FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
  if popupPolicies.Items.Count>0 then
    popupPolicies.ItemIndex:=0;
end;

procedure TForm1.popupModelChange(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo1.Lines.AddStrings(
    TFile.ReadAllLines('..\..\..\..\Examples\Default\'+
                                    popupModel.Items[popupModel.ItemIndex]));
  labelValidateModel.Text:='Not Validated Yet';
  labelValidateModel.FontColor:=TAlphaColorRec.Black;
  rectangleModel.Fill.Color:=TAlphaColorRec.Null;

end;

procedure TForm1.popupPoliciesChange(Sender: TObject);
begin
  Memo2.Lines.Clear;
  Memo2.Lines.AddStrings(
    TFile.ReadAllLines('..\..\..\..\Examples\Default\'+
                                    popupPolicies.Items[popupPolicies.ItemIndex]));
  labelValidatePolicies.FontColor:=TAlphaColorRec.Black;
  rectanglePolicies.Fill.Color:=TAlphaColorRec.Null;
end;

end.

