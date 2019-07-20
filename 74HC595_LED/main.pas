unit main;

{$mode objfpc}{$H+}
// ================================================
//
//	This program is for SunFounder SuperKit for Rpi.
//
//      Extend use of 8 LED with 74HC595.
//
//	Change the	WhichLeds and sleeptime value under
//	loop() function to change LED mode and speed.
//
// =================================================

// ===============   LED Mode Defne ================
//	You can define yourself, in binay, and convert it to Hex
//	8 bits a group, 0 means off, 1 means on
//	like : 0101 0101, means LED1, 3, 5, 7 are on.(from left to right)
//	and convert to 0x55.

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  h2wiringpi;

type

  { TForm1 }

  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    Image1: TImage;
    Label1: TLabel;
    Timer1: TTimer;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    SDI : integer;
    RCLK : integer;
    SRCLK : integer;

    LED: array[0..3, 0..7] of string;
    WhichLeds: array[0..7] of string;

    procedure Setup;
    procedure SetComboBox;
    procedure hc595_in(dat:string);
    procedure hc595_out;
  public

  end;

var
  Form1: TForm1;
                                                                 FormCreate
implementation

{$R *.lfm}
uses
  strutils;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
     SDI := P11;
     RCLK := P12;
     SRCLK := P13;

     //you can define them as const as well
     LED[0,0] := '01';
     LED[0,1] := '02';
     LED[0,2] := '04';
     LED[0,3] := '08';
     LED[0,4] := '10';
     LED[0,5] := '20';
     LED[0,6] := '40';
     LED[0,7] := '80';
     LED[1,0] := '01';
     LED[1,1] := '03';
     LED[1,2] := '07';
     LED[1,3] := '0f';
     LED[1,4] := '1f';
     LED[1,5] := '3f';
     LED[1,6] := '7f';
     LED[1,7] := 'ff';
     LED[2,0] := '01';
     LED[2,1] := '05';
     LED[2,2] := '15';
     LED[2,3] := '55';
     LED[2,4] := 'b5';
     LED[2,5] := 'f5';
     LED[2,6] := 'fb';
     LED[2,7] := 'ff';
     LED[3,0] := '02';
     LED[3,1] := '03';
     LED[3,2] := '0b';
     LED[3,3] := '0f';
     LED[3,4] := '2f';
     LED[3,5] := '3f';
     LED[3,6] := 'bf';
     LED[3,7] := 'ff';                                            FormCreate
     ComboBox1.ItemIndex:= 0;
     SetComboBox;
     Setup;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);

begin

    SetComboBox;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i : integer;
  sleeptime : integer;
begin
    sleeptime := 100; // Change speed, lower value, faster speed
    for i := 0 to Pred(length(WhichLeds)) do
         begin
              Application.ProcessMessages;                          FormCreate
	      hc595_in(WhichLeds[i]);
	      hc595_out();
	      Delay(sleeptime);
         end;

    for i := Pred(length(WhichLeds)) downto 0 do
         begin
              Application.ProcessMessages;
              hc595_in(WhichLeds[i]);
	      hc595_out();
	      Delay(sleeptime);
         end;
    Application.ProcessMessages;

end;

procedure TForm1.Setup;
begin
     wiringPiSetup();
     pinMode(SDI, OUTPUT);
     pinMode(RCLK, OUTPUT);
     pinMode(SRCLK, OUTPUT);
     digitalWrite(SDI, LOW);
     digitalWrite(RCLK, LOW);
     digitalWrite(SRCLK, LOW);
end;

procedure TForm1.SetComboBox;
var
  i : integer;
begin
     for i := 0 to 7 do
        WhichLeds[i] := LED[ComboBox1.ItemIndex,i];

end;


procedure TForm1.hc595_in(dat: string);
var
  i: integer;
begin
    for i := 0 to 7 do
    begin
         digitalWrite(SDI, Hex2Dec('80') AND (Hex2Dec(dat) shl i));
	 digitalWrite(SRCLK, HIGH) ;
	 delay(10) ;
	 digitalWrite(SRCLK, LOW) ;
    end;

end;

procedure TForm1.hc595_out;
begin
    digitalWrite(RCLK, HIGH) ;
    Delay(10);
    digitalWrite(RCLK, LOW);

end;

end.

