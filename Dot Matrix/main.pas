unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  h2wiringpi;

const
  code_H : array[0..19] of string = ('01','ff','80','ff','01','02','04','08','10','20','40','80','ff','ff','ff','ff','ff','ff','ff','ff');
  code_L : array[0..19] of string = ('00','7f','00','fe','00','00','00','00','00','00','00','00','fe','fd','fb','f7','ef','df','bf','7f');

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

    procedure Setup;
    procedure hc595_in(dat: string);
    procedure hc595_out;


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
  Timer1.Enabled := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Setup;
end;

procedure TForm1.Timer1Timer(Sender: TObject);

  var
  i: integer;
begin
    for i := 0 to Pred(Length(code_H)) do
    begin
	hc595_in(code_L[i]);
	hc595_in(code_H[i]);
	hc595_out();
	delay(10);
    end;

    for i := Pred(Length(code_H)) downto 0 do
    begin
	hc595_in(code_L[i]);
	hc595_in(code_H[i]);
	hc595_out();
	delay(10);
    end;

end;

procedure TForm1.Setup;

begin
     SDI   := P11;
   RCLK  := P12;
   SRCLK := P13;

   wiringPiSetup();
   pinMode(SDI, OUTPUT);
   pinMode(RCLK, OUTPUT);
   pinMode(SRCLK, OUTPUT);
   digitalWrite(SDI, LOW);
   digitalWrite(RCLK, LOW);
   digitalWrite(SRCLK, LOW);
end;

procedure TForm1.hc595_in(dat: string);
var
  bit: integer;
begin
    for bit := 0 to 7 do
    begin
	digitalWrite(SDI, Hex2Dec('80') AND (Hex2Dec(dat) shl bit));
	digitalWrite(SRCLK, HIGH);
	delay(5);
	digitalWrite(SRCLK, LOW);
    end;

end;

procedure TForm1.hc595_out;
begin
     digitalWrite(RCLK, HIGH);
     delay(5);
     digitalWrite(RCLK, LOW);
end;


end.

