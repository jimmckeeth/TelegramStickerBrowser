program TelegramStickerBrowser;

uses
  System.StartUpCopy,
  FMX.Forms,
  Skia.FMX,
  tgsBrowserMain in 'tgsBrowserMain.pas' {Form12};

{$R *.res}

begin
  GlobalUseSkia := True;
  //ReportMemoryLeaksOnShutdown := True;
  GlobalUseSkiaRasterWhenAvailable := False;
  Application.Initialize;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
