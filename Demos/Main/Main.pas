unit Main;

interface

uses
  System.Types, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ExtCtrls, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FMX.Edit, System.ImageList, FMX.ImgList, FMX.Memo.Types,
  FMX.TreeView, LogWindow;

type
  TForm1 = class(TForm)
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
    layoutWarning: TLayout;
    Rectangle2: TRectangle;
    lblWarning: TLabel;
    Image2: TImage;
    mainLayout: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    Splitter1: TSplitter;
    Layout9: TLayout;
    Layout10: TLayout;
    Label3: TLabel;
    tvModels: TTreeView;
    TreeViewItem1: TTreeViewItem;
    Splitter2: TSplitter;
    Layout5: TLayout;
    Rectangle3: TRectangle;
    lbTime: TLabel;
    Rectangle4: TRectangle;
    btnDebug: TSpeedButton;
    Image3: TImage;
    procedure btnDebugClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure buttonValidateModelClick(Sender: TObject);
    procedure buttonValidatePoliciesClick(Sender: TObject);
    procedure editParamsChangeTracking(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure popupPoliciesChange(Sender: TObject);
    procedure tvModelsChange(Sender: TObject);
  private
    fFolder: string;
    fDefaultFolder: string;
    fAdditionalFolder: string;
    fLogForm: TFormLog;

    procedure addDefaultModels (const aParent: TTreeViewItem);
    procedure addAdditionalModels (const aParent: TTreeViewItem);
    procedure addFolder(const aParent: TTreeViewItem; const aPath: string;
                  const aLabel: string = '%s'; const aTag: integer = 0);
    procedure resetLayout;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.IOUtils, Casbin.Parser.Types, Casbin.Parser, Casbin.Types, Casbin,
  Casbin.Core.Utilities, Casbin.Model.Types, Casbin.Policy.Types, Casbin.Model,
  Casbin.Adapter.Types, Casbin.Policy, Casbin.Adapter.Memory.Policy,
  Casbin.Adapter.Policy.Types, Casbin.Adapter.Filesystem, Casbin.Adapter.Memory,
  Casbin.Adapter.Filesystem.Policy, System.UITypes, System.SysUtils, Quick.Chrono, Logger.Debug;

{$R *.fmx}

procedure TForm1.addAdditionalModels(const aParent: TTreeViewItem);
var
  item: TTreeViewItem;
begin
  if TDirectory.Exists(fAdditionalFolder) then
  begin
    item:=TTreeViewItem.Create(aParent);
    item.Text:='Additional';
    item.TagString:='additional';
    item.TextSettings.Font.Style:=[TFontStyle.fsBold];
    item.Parent:=aParent;
    addFolder(item, fAdditionalFolder, 'Additional - %s', 1);
  end;
end;


procedure TForm1.addDefaultModels(const aParent: TTreeViewItem);
var
  item: TTreeViewItem;
begin
  if TDirectory.Exists(fDefaultFolder) then
  begin
    item:=TTreeViewItem.Create(aParent);
    item.Text:='Default';
    item.TextSettings.Font.Style:=[TFontStyle.fsBold];
    item.TagString:='default';
    item.Parent:=aParent;
    addFolder(item, fDefaultFolder, 'Default - %s', 0);
  end;
end;

procedure TForm1.addFolder(const aParent: TTreeViewItem; const aPath: string;
    const aLabel: string = '%s'; const aTag: integer = 0);
var
  res: integer;
  SRec: TSearchRec;
  name: string;
  item: TTreeViewItem;
begin
  Res := FindFirst(TPath.Combine(aPath, '*.conf'), faAnyfile, SRec );
  if Res = 0 then
  try
    while res = 0 do
    begin
      if (SRec.Attr and faDirectory <> faDirectory) then
      begin
        name:=TPath.GetFileNameWithoutExtension(SRec.Name);
        item:=TTreeViewItem.Create(aParent);
        item.Text:=name;
        item.TagString:=name;
        item.Parent:=aParent;

        if name.Contains('model') then
          name:=StringReplace(name, 'model', 'policy', [rfIgnoreCase])
        else
          name:=name+'_policy';

        if FileExists(TPath.Combine(aPath, name + '.csv')) then
          popupPolicies.Items.AddObject(format(aLabel, [name]), TObject(aTag));

      end;
      Res := FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
end;

procedure TForm1.btnDebugClick(Sender: TObject);
begin
  fLogForm.Visible:=not fLogForm.Visible;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  casbin: ICasbin;
  model: IModel;
  modelAdapter: IAdapter;
  policy: IPolicyManager;
  policyAdapter: IPolicyAdapter;
  params: TStringDynArray;
  chrono: TChronometer;
  enfRes: boolean;
begin
  if Trim(editParams.Text)='' then
  begin
    ShowMessage('The parameters are empty');
    Exit;
  end;
  params:=TStringDynArray(editParams.Text.Split([',']));

  model:=nil;
  modelAdapter:=nil;
  policy:=nil;
  policyAdapter:=nil;

  modelAdapter:=TMemoryAdapter.Create;
  modelAdapter.Assertions.AddRange(Memo1.Lines.ToStringArray);
  model:=TModel.Create(modelAdapter);

  policyAdapter:=TPolicyMemoryAdapter.Create;
  policyAdapter.Assertions.AddRange(Memo2.Lines.ToStringArray);
  policy:=TPolicyManager.Create(policyAdapter);

  chrono:=TChronometer.Create(false);
  chrono.ReportFormatPrecission:=TPrecissionFormat.pfFloat;
  casbin:=TCasbin.Create(model, policy);
  casbin.LoggerPool.Loggers.Add(TLogDebug.Create(fLogForm));
  casbin.LoggerPool.log('------------------- ENFORCER STARTED ------->');
  try
    try
      chrono.Start;
      enfRes:= casbin.enforce(params);
      chrono.Stop;
      if enfRes then
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
      lbTime.Text:=chrono.ElapsedTime;
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
  finally
    chrono.Free;
    casbin.LoggerPool.log('------------------- ENFORCER FINISHED ------->');
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
  nItem: TTreeViewItem;
begin
  fDefaultFolder:='..\..\Examples\Default\';
  fAdditionalFolder:='..\..\Examples\Additional\';

  labelVersion.Text:='Casbin4D - ' + version;

  mainLayout.Enabled:=false;
  tvModels.BeginUpdate;
  try
    with tvModels do
    begin
      Clear;
      nItem:=TTreeViewItem.Create(tvModels);
      nItem.Text:='Models';
      nItem.TextSettings.Font.Style:=[TFontStyle.fsBold];
      nItem.TagString:='models';
      nItem.Parent:=tvModels;

      addDefaultModels(nItem);
      addAdditionalModels(nItem);

      Selected:=nItem;

      ExpandAll;
    end;
  finally
    tvModels.EndUpdate;
  end;

  // No Errors
  Image1.Bitmap:=ImageList1.Bitmap(TSizeF.Create(Image1.Height,Image1.Height), 1);

  // Warnings
  Image2.Bitmap:=ImageList1.Bitmap(TSizeF.Create(Image2.Height,Image2.Height), 2);

  resetLayout;

  fLogForm:=TFormLog.Create(self);
  fLogForm.Visible:=false;
end;

procedure TForm1.popupPoliciesChange(Sender: TObject);
var
  name: string;
begin
  if popupPolicies.ItemIndex = -1 then
    Exit;

  Memo2.Lines.Clear;
  name:=popupPolicies.Text.Split(['-'])[1].Trim;
  if integer(popupPolicies.Items.Objects[popupPolicies.ItemIndex]) = 0 then
    name:=TPath.Combine(fDefaultFolder, name);
  if integer(popupPolicies.Items.Objects[popupPolicies.ItemIndex]) = 1 then
    name:=TPath.Combine(fAdditionalFolder, name);
  name:=name + '.csv';

  Memo2.Lines.AddStrings(TArray<string>(TFile.ReadAllLines(name)));

  labelValidatePolicies.FontColor:=TAlphaColorRec.Black;
  rectanglePolicies.Fill.Color:=TAlphaColorRec.Null;
end;

procedure TForm1.resetLayout;
begin
  Memo1.Lines.Clear;
  labelValidateModel.Text:='Not Validated Yet';
  labelValidateModel.FontColor:=TAlphaColorRec.Black;
  rectangleModel.Fill.Color:=TAlphaColorRec.Null;

  Memo2.Lines.Clear;
  labelValidatePolicies.FontColor:=TAlphaColorRec.Black;
  rectanglePolicies.Fill.Color:=TAlphaColorRec.Null;

  LabelError.Text:='No Errors';

  layoutWarning.Visible:=false;

  popupPolicies.ItemIndex:=-1;

  lbTime.Text:='';
end;

procedure TForm1.tvModelsChange(Sender: TObject);
var
  rootFolder: string;
  policyFile: string;
  line: string;
begin
  mainLayout.Enabled:= (tvModels.Selected.TagString <> 'models') and
        (tvModels.Selected.TagString <> 'default') and
          (tvModels.Selected.TagString <> 'additional');
  if not mainLayout.Enabled then
    Exit;
  resetLayout;

  if tvModels.Selected.ParentItem.TagString = 'default' then
    rootFolder:=fDefaultFolder;
  if tvModels.Selected.ParentItem.TagString = 'additional' then
    rootFolder:=fAdditionalFolder;

  Memo1.Lines.AddStrings(TArray<string>(TFile.ReadAllLines(
                TPath.Combine(rootFolder,
                            tvModels.Selected.TagString + '.conf'))));


  policyFile:=tvModels.Selected.TagString;
  if policyFile.Contains('model') then
    policyFile:=StringReplace(policyFile, 'model', 'policy', [rfIgnoreCase])
  else
    policyFile:=policyFile +'_policy';
  policyFile:=policyFile + '.csv';
  policyFile:=TPath.Combine(rootFolder, policyFile);
  if FileExists(policyFile) then
    Memo2.Lines.AddStrings(TArray<string>(TFile.ReadAllLines(policyFile)))
  else
  begin
    lblWarning.Text:='Policy file ' + policyFile + ' not found' + sLineBreak +
            'You can select a policy file manually';
    layoutWarning.Visible:=true;
  end;

  if (memo2.Lines.Count > 0) then
  begin
    for line in memo2.Lines do
    begin
      if (Trim(line) <> '') and (line.StartsWith('p,')) then
        editParams.Text:=line.Substring('p,'.Length + 1).Trim;
    end;
  end;

end;

end.

