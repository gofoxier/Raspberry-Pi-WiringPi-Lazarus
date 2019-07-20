unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  h2wiringpi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    SDI   : integer;
    RCLK  : integer;
    SRCLK : integer;

    segCode : array[0..16] of string;

    procedure Setup;
    procedure hc595_shift(dat: string);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
uses
  strutils;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Setup;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
   i: integer;
begin
    for i := 0 to Pred(length(segCode)) do
    begin
         hc595_shift(segCode[i]);
	 delay(505);
    end;
end;

procedure TForm1.Setup;
begin
   SDI   := P11;
   RCLK  := P12;
   SRCLK := P13;

   //you can define them as const array as well
   segCode[0]  := '3f';
   segCode[1]  := '06';
   segCode[2]  := '5b';
   segCode[3]  := '4f';
   segCode[4]  := '66';
   segCode[5]  := '6d';
   segCode[6]  := '7d';
   segCode[7]  := '07';
   segCode[8]  := '7f';
   segCode[9]  := '6f';
   segCode[10] := '77';
   segCode[11] := '7c';
   segCode[12] := '39';
   segCode[13] := '5e';
   segCode[14] := '79';
   segCode[15] := '71';
   segCode[16] := '80';

   wiringPiSetup();
   pinMode(SDI, OUTPUT);
   pinMode(RCLK, OUTPUT);
   pinMode(SRCLK, OUTPUT);
   digitalWrite(SDI, LOW);
   digitalWrite(RCLK, LOW);
   digitalWrite(SRCLK, LOW);


end;

procedure TForm1.hc595_shift(dat: string);
var
  bit: integer;
begin
    for bit := 0 to 7 do
    begin
	digitalWrite(SDI, Hex2Dec('80') AND (Hex2Dec(dat) shl bit));
	digitalWrite(SRCLK, HIGH);
	delay(100);
	digitalWrite(SRCLK, LOW);
    end;
    digitalWrite(RCLK, HIGH);
    delay(100);
    digitalWrite(RCLK, LOW);
end;

end.

