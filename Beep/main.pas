unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, h2wiringpi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;
    TrackBar1: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  wiringPiSetupDone: boolean;
  GPIO_pos: integer;   //use wiringPI Pin location

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  GPIO_pos := P11;
   if not wiringPiSetupDone then wiringPiSetup;
   begin
     wiringPiSetupDone:= true;
     pinMode(GPIO_pos, OUTPUT);
   end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin


  digitalWrite(GPIO_pos, LOW);
  delay(TrackBar1.Position);
  digitalWrite(GPIO_pos, HIGH);
  delay(TrackBar1.Position);

  Application.ProcessMessages;
end;

procedure TForm1.ToggleBox1Change(Sender: TObject);
begin


  if (ToggleBox1.Checked) then
      Timer1.Enabled:= true
  else
      Timer1.Enabled:= false;
end;

end.

