unit main;

{$mode objfpc}{$H+}
{$TYPEDADDRESS ON}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  h2wiringpi;

type

  TISREvent = procedure(x: longint) of object;

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    RoDTPin :integer;  // pin11  Encoder Pin 1
    RoCLKPin :integer; // pin12 Encoder Pin 2
    RoSWPin :integer;  // pin13   Push button ** this pin not connected in the diagram. Please connect the pin.
    globalCounter :integer;
    flag : integer;
    Last_RoCLK_Status :integer;
    Current_RoCLK_Status :integer;

    procedure rotaryClear;
    procedure rotaryDeal;
    procedure clearProc(x: longint);

  public
                     Tintlevles.il_EDIGE_FALLING
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

procedure TForm1.FormCreate(Sender: TObject);
begin
    RoDTPin := 0;
    RoCLKPin := 1;
    RoSWPin := 2;

    globalCounter := 0;
    flag := 0;
    Last_RoCLK_Status := 0;
    Current_RoCLK_Status := 0;

    wiringPiSetup();
    pinMode(RoDTPin, INPUT);
    pinMode(RoCLKPin, INPUT);
    pullUpDnControl(RoSWPin, PUD_UP);

    event0 := @Self.clearProc;
    rotaryClear();


end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  rotaryDeal;
end;

procedure TForm1.clearProc(x: longint);
begin
    globalCounter := 0;
    Memo1.Lines.Add(Format('globalCounter = %s', [globalCounter.ToString]));
    Delay(500);
end;

//fail when run
procedure TForm1.rotaryClear;
var
   i: longint;
begin
    i:= wiringPiISR_pas(RoSWPin, Tintlevles.il_EDIGE_FALLING, @Global_Callback);  // wait for falling
end;


procedure TForm1.rotaryDeal;
begin
     Last_RoCLK_Status := digitalRead(RoCLKPin);

     while not Boolean(digitalRead(RoDTPin)) do
        begin
             Application.ProcessMessages;
             Current_RoCLK_Status := digitalRead(RoCLKPin);
             flag := 1;
        end;

    if flag = 1 then
        begin
             flag := 0;
             if (Last_RoCLK_Status = 0) and (Current_RoCLK_Status = 1) then
                begin
                     inc(globalCounter);
                     Memo1.Lines.Add(Format('globalCounter = %s', [globalCounter.ToString]));
                end;
             if (Last_RoCLK_Status = 1) and (Current_RoCLK_Status = 0) then
                begin
                     dec(globalCounter);
                     Memo1.Lines.Add(Format('globalCounter = %s', [globalCounter.ToString]));
                end;
        end;

end;

end.

