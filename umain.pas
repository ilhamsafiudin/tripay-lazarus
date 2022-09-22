unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, fphttpclient, opensslsockets, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnSend1: TButton;
    btnSend2: TButton;
    btnSend3: TButton;
    btnSend4: TButton;
    ePerPage1: TEdit;
    eCode1: TEdit;
    eCode2: TEdit;
    eCode3: TEdit;
    eAmount1: TEdit;
    ePage1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    mLog: TMemo;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    PageControl3: TPageControl;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    procedure btnSend1Click(Sender: TObject);
    procedure btnSend2Click(Sender: TObject);
    procedure btnSend3Click(Sender: TObject);
    procedure btnSend4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;

const   //ini hanya test, untuk production sebaiknya taruh credensial di server
  API_URL= 'https://tripay.co.id/api-sandbox';
  MERCHANT_CODE= '';
  API_KEY= '';
  PRIVATE_KEY= '';

implementation

{$R *.lfm}

{ TfrmMain }

//method post
function requestdata_post(Url: string; Params: string): string;
var
  Client: TFPHttpClient;
  Response: TStringStream;
begin
   Client := TFPHttpClient.Create(nil);
   Client.AddHeader('Authorization', 'Bearer ' + API_KEY);
   Client.RequestBody := TRawByteStringStream.Create(Params);
   Response := TStringStream.Create('');
   try
     try
       Client.Post(Url, Response);
       Result := Response.DataString;
       //Writeln('Response Code: ' + IntToStr(Client.ResponseStatusCode)); // better be 200
     except on E: Exception do
       Result := E.Message;
       //Writeln('Something bad happened: ' + E.Message);
     end;
   finally
     Client.RequestBody.Free;
     Client.Free;
     Response.Free;
   end;
end;

//method get
function requestdata_get(Url: string; Payload: string): string;
var
  Client: TFPHttpClient;
  Response: TStringStream;
begin
   Client := TFPHttpClient.Create(nil);
   Client.AddHeader('Authorization', 'Bearer ' + API_KEY);
   Response := TStringStream.Create('');
   try
     try
       Client.Get(Url + '?'+ Payload, Response);
       Result := Response.DataString;
     except on E: Exception do
       Result := E.Message;
     end;
   finally
     Client.RequestBody.Free;
     Client.Free;
     Response.Free;
   end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

end;

//endpoint: /payment/instruction
procedure TfrmMain.btnSend1Click(Sender: TObject);
var
  Data: string;
  Payload: string;
begin
   Payload := 'code=' + eCode1.Text;
   Data := requestdata_get(API_URL + '/payment/instruction', Payload);
   mLog.Lines.Add('log payment instruction: ' + Data);
end;

//endpoint: /merchant/payment-channel
procedure TfrmMain.btnSend2Click(Sender: TObject);
var
  Data: string;
  Payload: string;
begin
  Payload := 'code=' + eCode2.Text;
  Data := requestdata_get(API_URL + '/merchant/payment-channel', Payload);
  mLog.Lines.Add('log payment channel: ' + Data);
end;

//endpoint: /merchant/fee-calculator
procedure TfrmMain.btnSend3Click(Sender: TObject);
var
  Data: string;
  Payload: string;
begin
  Payload := 'code=' + eCode3.Text + '&amount=' + eAmount1.Text;
  Data := requestdata_get(API_URL + '/merchant/fee-calculator', Payload);
  mLog.Lines.Add('log fee calculator: ' + Data);
end;

//endpoint: /merchant/transactions
procedure TfrmMain.btnSend4Click(Sender: TObject);
var
  Data: string;
  Payload: string;
begin
  Payload := 'page=' + ePage1.Text + '&per_page=' + ePerPage1.Text;
  Data := requestdata_get(API_URL + '/merchant/transactions', Payload);
  mLog.Lines.Add('log transaction list: ' + Data);
end;

end.

