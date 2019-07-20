unit main;

{$mode objfpc}{$H+}
{$TYPEDADDRESS ON}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  h2wiringpi;

type

    TISREvent = procedure(x: longint) of object;

  { TForm1 }
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);


  private
    globalCounter :longint;
    SigPin : Integer;

    procedure DisplayStatus(Status: string);
    procedure CountProc(x:longint);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
var event0: TISREvent;
procedure Global_Callback;
begin
    //Send a message to MainThread
    Application.QueueAsyncCall(event0, 0);
end;

{ TForm1 }

procedure TForm1.CountProc(x: longint);
begin
    Inc(globalCounter);
    DisplayStatus(globalCounter.ToString);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  globalCounter := 0;
  SigPin := P11;

  wiringPiSetup();
  pinMode(SigPin, INPUT);
  pullUpDnControl(SigPin, PUD_UP);    // Set Pin's mode is input, and pull up to high level(3.3V)

  event0 := @CountProc;

end;



procedure TForm1.DisplayStatus(Status: string);
begin
   Label1.Caption := Format('global counter = %s',[Status]);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  wiringPiISR_pas(SigPin, Tintlevles.il_EDGE_RISING, @Global_Callback);  // wait for falling

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //..;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  //..;
end;


end.

