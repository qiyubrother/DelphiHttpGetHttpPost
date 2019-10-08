unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btnHttpGet: TButton;
    IdHTTP: TIdHTTP;
    btnHttpPost: TButton;

    procedure btnHttpGetClick(Sender: TObject);
    procedure btnHttpPostClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{
  HttpGet
  如果Get需要添加请求参数，则直接在地址后添加，各参数间用&连接
  如：http://dict.youdao.com？param1=1&param2=2
}
procedure TForm1.btnHttpGetClick(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  Url: string; // 请求地址
  ResponseStream: TStringStream; // 返回信息
  ResponseStr: string;
begin
  // 创建IDHTTP控件
  IdHTTP := TIdHTTP.Create(nil);
  // TStringStream对象用于保存响应信息
  ResponseStream := TStringStream.Create('');
  try
    // 请求地址
    Url := 'http://dict.youdao.com/';
    try
      IdHTTP.Get(Url, ResponseStream);
    except
      on e: Exception do
      begin
        ShowMessage(e.Message);
      end;
    end;
    // 获取网页返回的信息
    ResponseStr := ResponseStream.DataString;
    // 网页中的存在中文时，需要进行UTF8解码
    ResponseStr := UTF8Decode(ResponseStr);
    ShowMessage(ResponseStr);
  finally
    IdHTTP.Free;
    ResponseStream.Free;
  end;
end;
{
   HttpPost
}
procedure TForm1.btnHttpPostClick(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  Url: string; // 请求地址
  ResponseStream: TStringStream; // 返回信息
  ResponseStr: string;

  RequestList: TStringList; // 请求信息
  RequestStream: TStringStream;
begin
  // 创建IDHTTP控件
  IdHTTP := TIdHTTP.Create(nil);
  // TStringStream对象用于保存响应信息
  ResponseStream := TStringStream.Create('');

  RequestStream := TStringStream.Create('');
  RequestList := TStringList.Create;
  try
    Url := 'http://f.youdao.com/?path=fanyi&vendor=fanyiinput';
    try
      // 以列表的方式提交参数
      RequestList.Add('text=love');
      IdHTTP.Post(Url, RequestList, ResponseStream);

      // 以流的方式提交参数
      RequestStream.WriteString('text=love');
      IdHTTP.Post(Url, RequestStream, ResponseStream);
    except
      on e: Exception do
      begin
        Application.MessageBox(PWideChar(e.Message), PWideChar('Error'));
      end;
    end;
    // 获取网页返回的信息
    ResponseStr := ResponseStream.DataString;
    // 网页中的存在中文时，需要进行UTF8解码
    ResponseStr := UTF8Decode(ResponseStr);
    showMessage(responsestr);
  finally
    IdHTTP.Free;
    RequestList.Free;
    RequestStream.Free;
    ResponseStream.Free;
  end;
end;


end.
