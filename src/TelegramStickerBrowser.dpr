program TelegramStickerBrowser;

uses
  System.StartUpCopy,
  FMX.Forms,
  Skia.FMX,
  FMX.Types,
  tgsBrowserMain in 'tgsBrowserMain.pas' {Form12};

{$R *.res}

begin
  GlobalUseSkia := True;
  GlobalUseSkiaRasterWhenAvailable := False;
  GlobalUseMetal := True;
  //ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
