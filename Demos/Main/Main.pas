unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ExtCtrls, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FMX.Edit, System.ImageList, FMX.ImgList, FMX.Memo.Types;

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
    editParams: TEdit;
    Button1: TButton;
    Layout3: TLayout;
    rectangleEnforced: TRectangle;
    labelEnforced: TLabel;
    labelVersion: TLabel;
    Layout4: TLayout;
    Rectangle1: TRectangle;
    LabelError: TLabel;
    ImageList1: TImageList;
    Image1: TImage;
    Layout5: TLayout;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure buttonValidateModelClick(Sender: TObject);
    procedure buttonValidatePoliciesClick(Sender: TObject);
    procedure editParamsChangeTracking(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure popupModelChange(Sender: TObject);
    procedure popupPoliciesChange(Sender: TObject);
  private
    fFolder: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.IOUtils, Casbin.Parser.Types, Casbin.Parser, Casbin.Types, Casbin,
  Casbin.Core.Utilities;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  casbin: ICasbin;
  params: TStringDynArray;
begin
  if Trim(editParams.Text)='' then
  begin
    ShowMessage('The parameters are empty');
    Exit;
  end;
  params:=TStringDynArray(editParams.Text.Split([',']));
  casbin:=TCasbin.Create(fFolder+popupModel.Text, fFolder+popupPolicies.Text);
  try
    if casbin.enforce(params) then
    begin
      rectangleEnforced.Fill.Color:=TAlphaColorRec.Green;
      labelEnforced.Text:='ALLOW';
      // No Errors
      Image1.Bitmap:=ImageList1.Bitmap(TSizeF.Create(Image1.Height,Image1.Height), 1);
      LabelError.Text:='No Errors';
    end
    else
    begin
      rectangleEnforced.Fill.Color:=TAlphaColorRec.Red;
      labelEnforced.Text:='DENY';
    end;
    labelEnforced.FontColor:=TAlphaColorRec.White;
  except
    on E: Exception do
    begin
      Image1.Bitmap:=ImageList1.Bitmap(TSizeF.Create(Image1.Height,Image1.Height), 0);
      if E.Message.Contains('math') then
        LabelError.Text:='Select the correct model-policy files'
      else
        LabelError.Text:=E.Message;
    end;
  end;
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
  parser:=TParser.Create(Memo2.Text, ptPolicy);
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

procedure TForm1.editParamsChangeTracking(Sender: TObject);
begin
  labelEnforced.Text:='Nothing Enforced Yet';
  labelEnforced.FontColor:=TAlphaColorRec.Black;
  rectangleEnforced.Fill.Color:=TAlphaColorRec.Null;

  Image1.Bitmap:=ImageList1.Bitmap(TSizeF.Create(Image1.Height,Image1.Height), 1);
  LabelError.Text:='No Errors';
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  SRec: TSearchRec;
  Res: Integer;
begin
  labelVersion.Text:=version;
//  fFolder:='..\..\..\..\Examples\Default\'; //When in Platform/Config folder
  fFolder:='..\..\Examples\Default\';
  Res := FindFirst(fFolder+'*.conf', faAnyfile, SRec );
  if Res = 0 then
  try
    while res = 0 do
    begin
      if (SRec.Attr and faDirectory <> faDirectory) then
        popupModel.Items.Add(SRec.Name);
      Res := FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
  if popupModel.Items.Count>0 then
    popupModel.ItemIndex:=0;

  //Policies
  Res := FindFirst(fFolder+'*.csv', faAnyfile, SRec );
  if Res = 0 then
  try
    while res = 0 do
    begin
      if (SRec.Attr and faDirectory <> faDirectory) then
        popupPolicies.Items.Add(SRec.Name);
      Res := FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
  if popupPolicies.Items.Count>0 then
    popupPolicies.ItemIndex:=0;

  // No Errors
  Image1.Bitmap:=ImageList1.Bitmap(TSizeF.Create(Image1.Height,Image1.Height), 1);
  LabelError.Text:='No Errors';

  // Warnings
  Image2.Bitmap:=ImageList1.Bitmap(TSizeF.Create(Image2.Height,Image2.Height), 2);
end;

procedure TForm1.popupModelChange(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo1.Lines.AddStrings(TArray<string>(
    TFile.ReadAllLines('..\..\Examples\Default\'+
                                    popupModel.Items[popupModel.ItemIndex])));
  labelValidateModel.Text:='Not Validated Yet';
  labelValidateModel.FontColor:=TAlphaColorRec.Black;
  rectangleModel.Fill.Color:=TAlphaColorRec.Null;

end;

procedure TForm1.popupPoliciesChange(Sender: TObject);
begin
  Memo2.Lines.Clear;
  Memo2.Lines.AddStrings(TArray<string>(
    TFile.ReadAllLines('..\..\Examples\Default\'+
                                    popupPolicies.Items[popupPolicies.ItemIndex])));
  labelValidatePolicies.FontColor:=TAlphaColorRec.Black;
  rectanglePolicies.Fill.Color:=TAlphaColorRec.Null;
end;

end.

