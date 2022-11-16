unit tgsBrowserMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Skia, Skia.FMX,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Edit,
  Generics.Collections;

type
  TForm12 = class(TForm)
    SkAnimatedImage1: TSkAnimatedImage;
    TrackBar1: TTrackBar;
    ckAnimate: TCheckBox;
    HorzScrollBox1: THorzScrollBox;
    Layout1: TLayout;
    ckLoop: TCheckBox;
    Layout2: TLayout;
    Layout3: TLayout;
    ListBox1: TListBox;
    Layout4: TLayout;
    EditPath: TEdit;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Click(Sender: TObject);
    procedure TrackBar1KeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure TrackBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ckAnimateChange(Sender: TObject);
    procedure ckLoopChange(Sender: TObject);
    procedure SkAnimatedImageClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure EditPathChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SkAnimatedImage1AnimationProcess(Sender: TObject);
  private
    { Private declarations }
    FPreviewImages: TObjectList<TSkAnimatedImage>;
    procedure LoadTgs(const LoadFirst: Boolean = True);
    procedure LoadDirectories;
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

{$R *.fmx}

uses IOUtils;

procedure TForm12.FormCreate(Sender: TObject);
begin
  FPreviewImages := TObjectList<TSkAnimatedImage>.Create(True);
  LoadDirectories;
end;

procedure TForm12.FormDestroy(Sender: TObject);
begin
  FPreviewImages.Free;
end;

procedure TForm12.ckAnimateChange(Sender: TObject);
begin
  if ckAnimate.IsChecked then
    SkAnimatedImage1.Animation.Start
  else
    SkAnimatedImage1.Animation.StopAtCurrent;
end;

procedure TForm12.ckLoopChange(Sender: TObject);
begin
  SkAnimatedImage1.Animation.Loop := ckLoop.IsChecked;
  if ckLoop.IsChecked and ckAnimate.IsChecked and not SkAnimatedImage1.Animation.Running then
    SkAnimatedImage1.Animation.Start;
end;

procedure TForm12.EditPathChange(Sender: TObject);
begin
  LoadDirectories();
end;

procedure TForm12.ListBox1Click(Sender: TObject);
begin
  LoadTgs;
end;

procedure TForm12.LoadDirectories();
begin
  ListBox1.Items.Clear;
  FPreviewImages.Clear;

  var dirs := TDirectory.GetDirectories(EditPath.Text);
  for var dir in dirs do
    ListBox1.Items.Add(TPath.GetFileName(dir));
  ListBox1.Items.Add('.');
  ListBox1.ItemIndex := 0;
  LoadTgs;
end;

procedure TForm12.LoadTgs(const LoadFirst: Boolean = True);
begin
  HorzScrollBox1.BeginUpdate;
  try
    FPreviewImages.Clear;

    if LoadFirst then
      SkAnimatedImage1.Source.Data := [];

    var jsonFiles := TDirectory.GetFiles(TPath.Combine(EditPath.Text,
                      ListBox1.Items[ListBox1.ItemIndex]),'*.json');
    var LottieFiles := TDirectory.GetFiles(TPath.Combine(EditPath.Text,
                      ListBox1.Items[ListBox1.ItemIndex]),'*.lottie');
    var tgsFiles := TDirectory.GetFiles(TPath.Combine(EditPath.Text,
                      ListBox1.Items[ListBox1.ItemIndex]),'*.tgs');

    for var tgs in jsonFiles + LottieFiles + tgsFiles do
    begin
      var sk := TSkAnimatedImage.Create(nil);
      FPreviewImages.Add(sk);
      sk.Width := 100;
      sk.Height := 100;
      sk.LoadFromFile(tgs);
      sk.Align := TAlignLayout.Left;
      sk.Parent := HorzScrollBox1;
      sk.OnClick := SkAnimatedImageClick;
      sk.HitTest := True;

      if LoadFirst and (length(SkAnimatedImage1.Source.Data) = 0) then
        SkAnimatedImage1.Source.Assign(sk.Source);

    end;
  finally
    HorzScrollBox1.EndUpdate;
  end;

end;

procedure TForm12.SkAnimatedImage1AnimationProcess(Sender: TObject);
begin
  TrackBar1.Value := SkAnimatedImage1.Animation.Progress * 100;
end;

procedure TForm12.SkAnimatedImageClick(Sender: TObject);
begin
  SkAnimatedImage1.Source.Assign(TSkAnimatedImage(Sender).Source);
  SkAnimatedImage1.Animation.Progress := 0;
end;

procedure TForm12.SpeedButton1Click(Sender: TObject);
begin
  ListBox1.ItemIndex := Random(ListBox1.Items.Count);
  LoadTgs(False);
  SkAnimatedImage1.Source.Assign(
    FPreviewImages[Random(FPreviewImages.Count)].Source);
end;

procedure TForm12.SpeedButton2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    EditPath.Text := TPath.GetDirectoryName(OpenDialog1.FileName);
//    LoadDirectories;
  end;
end;

procedure TForm12.TrackBar1Change(Sender: TObject);
begin
  if TrackBar1.Tracking then
    SkAnimatedImage1.Animation.Progress := TrackBar1.Value / 100;
end;

procedure TForm12.TrackBar1Click(Sender: TObject);
begin
  ckAnimate.IsChecked := False;
end;

procedure TForm12.TrackBar1KeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  ckAnimate.IsChecked := False;
end;

procedure TForm12.TrackBar1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ckAnimate.IsChecked := False;
end;

end.
