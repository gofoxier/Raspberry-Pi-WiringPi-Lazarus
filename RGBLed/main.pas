unit Main;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  h2wiringpi;

type

  { TMainForm }

  TMainForm = class(TForm)
    Image1: TImage;
    Shape1: TShape;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;


    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    pins: array[0..2] of integer;
    colors: array[0..5] of string;

    WiringPin_G : integer;
    WiringPin_R : integer;
    WiringPin_B : integer;
    function map(x:longint; in_min:integer; in_max:integer;                               quivalent &
             out_min: integer; out_max:integer):integer;

    procedure SetUp;
    procedure SetLedColor(col: longint);
    procedure CleanUp;
  public                                FormCreate

  end;

var
  MainForm: TMainForm;
  wiringPiSetupDone: boolean;

implementation

{$R *.lfm}
uses
  strutils;

{ TMainForm }

function TMainForm.map(x: longint; in_min: integer; in_max: integer;
  out_min: integer; out_max: integer): integer;
begin
  result := Trunc((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min);
end;

procedure TMainForm.SetUp;
var
   i : integer;
begin
  wiringPiSetup();
  for i in pins do
      begin
        pinMode(i, SOFT_PWM_OUTPUT);
        pwmWrite(i, 0);
        //hwiringpi does not provide softPwmWrite helper method.
        //Add this helper method to hwiringpi directly
        softPwmCreate(i, 0, 100);
      end;
  wiringPiSetupDone := true;
end;

procedure TMainForm.SetLedColor(col: longint);
var
   r_val: longint;
   g_val: longint;
   b_val: longint;
begin
        // AND = Bitwise true, shr = Shift Right
  	r_val := (col AND Hex2Dec('FF0000')) shr 16; // get red value
        g_val := (col AND Hex2Dec('00FF00')) shr 8; // get green value
	b_val := (col AND Hex2Dec('0000FF')) shr 0; // get blue value

	r_val := map(r_val, 0, 255, 0, 100); // change a num(0~255) to 0~100
	g_val := map(g_val, 0, 255, 0, 100);
	b_val := map(b_val, 0, 255, 0, 100);

        //hwiringpi does not provide softPwmWrite helper method.
        //Add this helper method to hwiringpi directly

        //RGB combination
        softPwmWrite(WiringPin_R, 100 - r_val); // change duty cycle
	softPwmWrite(WiringPin_G, 100 - g_val);
	softPwmWrite(WiringPin_B, 100 - b_val);

        Shape1.Brush.Color := RGBToColor(100-r_val, 100-g_val, 100-b_val);
        Application.ProcessMessages;
end;

procedure TMainForm.CleanUp;
var
   i : integer;
begin

   for i in pins do
       begin
            pwmWrite(i, 0);
       end;

end;

procedure TMainForm.ToggleBox1Change(Sender: TObject);
begin
  if not wiringPiSetupDone then
     Setup;

  if (ToggleBox1.Checked) then
      Timer1.Enabled:= true
  else
      Timer1.Enabled:= false;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin

  //Java color code (HEX code) preceded by 0x
  //private static int colors[] = { 0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF, 0xFFFFFF, 0x9400D3 };
  //Python code (HEX code) preceded by 0x
  //colors = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0xFF00FF, 0x00FFFF]

  //Pascal does have 0x. It is a string. We use Hex2Dec(value) (Lazarus), StrToInt('$' + value) to convert it
  //into a long integer
  colors[0] := 'FF0000';
  colors[1] := '00FF00';
  colors[2] := '0000FF';
  colors[3] := 'FFFF00';
  colors[4] := 'FF00FF';
  colors[5] := '00FFFF';

  WiringPin_R := P11;
  WiringPin_G := P12;
  WiringPin_B := P13;

  pins[0] := WiringPin_R;
  pins[1] := WiringPin_G;
  pins[2] := WiringPin_B;

  if not wiringPiSetupDone then
     Setup;                                        Timer1


end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
   col: string;
begin
     for col in colors do
         begin
              SetLedColor(Hex2Dec(col));
              sleep(500);
         end;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

     CleanUp;
     CloseAction := TCloseAction.caFree;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin

  CleanUp;
  CanClose:=True;
end;

end.

