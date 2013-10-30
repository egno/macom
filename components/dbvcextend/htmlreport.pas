unit htmlreport;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, LCLProc, LResources, Forms, Controls, Graphics, Dialogs,
    IPHtml, Ipfilebroker, IpMsg;

type

  { TMyIpHtmlDataProvider }

  TMyIpHtmlDataProvider = class(TIpHtmlDataProvider)
  private
    function DoCanHandle(Sender: TObject; const URL: string
      ): Boolean;
    procedure DoCheckURL(Sender: TObject; const URL: string;
      var Available: Boolean; var ContentType: string);
    procedure DoGetHtml(Sender: TObject; const URL: string;
      const PostData: TIpFormDataEntity; var Stream: TStream);
    procedure DoGetImage(Sender: TIpHtmlNode; const URL: string;
      var Picture: TPicture);
    procedure DoLeave(Sender: TIpHtml);
    procedure DoReportReference(Sender: TObject; const URL: string);
  protected
    function DoGetStream(const URL: string): TStream; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

  { TMyIpHtmlPanel }

  TMyIpHtmlPanel = class(TIpHtmlPanel)
    DataProvider1: TMyIpHtmlDataProvider;
  public
    procedure ReFill();
    procedure ShowHTML(Src: string);
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TMyIpHtmlDataProvider }

function TMyIpHtmlDataProvider.DoCanHandle(Sender: TObject; const URL: string
  ): Boolean;
begin
  debugln(['TMyIpHtmlDataProviderCanHandle ',URL]);
  Result:=false;
end;

procedure TMyIpHtmlDataProvider.DoCheckURL(Sender: TObject; const URL: string;
  var Available: Boolean; var ContentType: string);
begin
  debugln(['TMyIpHtmlDataProviderCheckURL ',URL]);
  Available:=false;
  ContentType:='';
end;

procedure TMyIpHtmlDataProvider.DoGetHtml(Sender: TObject; const URL: string;
  const PostData: TIpFormDataEntity; var Stream: TStream);
begin
  debugln(['TMyIpHtmlDataProviderGetHtml ',URL]);
  Stream:=nil;
end;

procedure TMyIpHtmlDataProvider.DoGetImage(Sender: TIpHtmlNode;
  const URL: string; var Picture: TPicture);
begin
  debugln(['TMyIpHtmlDataProviderGetImage ',URL]);
  Picture:=nil;
end;

procedure TMyIpHtmlDataProvider.DoLeave(Sender: TIpHtml);
begin

end;

procedure TMyIpHtmlDataProvider.DoReportReference(Sender: TObject;
  const URL: string);
begin
  debugln(['TMyIpHtmlDataProviderReportReference ',URL]);
end;

function TMyIpHtmlDataProvider.DoGetStream(const URL: string): TStream;
var
  ms: TMemoryStream;
begin
  Result:=nil;
  debugln(['TMyIpHtmlDataProvider.DoGetStream ',URL]);

  if URL='fpdoc.css' then begin
    debugln(['TMyIpHtmlDataProvider.DoGetStream ',FileExists(URL)]);
    ms:=TMemoryStream.Create;
    try
      ms.LoadFromFile(URL);
      ms.Position:=0;
    except
      ms.Free;
    end;
    Result:=ms;
  end;
end;

constructor TMyIpHtmlDataProvider.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnCanHandle:=@DoCanHandle;
  OnGetHtml:=@DoGetHtml;
  OnGetImage:=@DoGetImage;
  OnLeave:=@DoLeave;
  OnCheckURL:=@DoCheckURL;
  OnReportReference:=@DoReportReference;
end;

destructor TMyIpHtmlDataProvider.Destroy;
begin
  inherited Destroy;
end;

{ TMyIpHtmlPanel }

procedure TMyIpHtmlPanel.ReFill;
begin

end;

procedure TMyIpHtmlPanel.ShowHTML(Src: string);
var
  ss: TStringStream;
  NewHTML: TIpHtml;
begin
  ss := TStringStream.Create(Src);
  try
    NewHTML := TIpHtml.Create; // Beware: Will be freed automatically by IpHtmlPanel1
    debugln(['ShowHTML BEFORE SETHTML']);
    SetHtml(NewHTML);
    debugln(['ShowHTML BEFORE LOADFROMSTREAM']);
    NewHTML.LoadFromStream(ss);
    //if Anchor <> '' then IpHtmlPanel1.MakeAnchorVisible(Anchor);
  finally
    ss.Free;
  end;
end;

constructor TMyIpHtmlPanel.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Parent:=(TheOwner as TWinControl);
  Align:=alClient;
  DefaultFontSize:=10;
  DataProvider1:=TMyIpHtmlDataProvider.Create(Self);
  DataProvider:=DataProvider1;

end;

destructor TMyIpHtmlPanel.Destroy;
begin
  inherited Destroy;
end;

end.

