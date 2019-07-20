unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  h2wiringpi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    Shape1: TShape;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;
    colors: array[0..5] of HEX;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm;
  wiringPiSetupDone: boolean;
  GPIO_pos:integer;

implementation

{$R *.lfm}

{ TForm1 }
//must run sudo authority
procedure TForm1.ToggleBox1Change(Sender: TObject);
begin
  if not wiringPiSetupDone then wiringPiSetup;

  pinMode(GPIO_pos, PWM_OUTPUT);
  pwmSetMode(PWM_MODE_BAL);
  //pwmSetRange(1024 * 10);                 colors = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0xFF00FF, 0x00FFFF]
  pwmSetClock(2000);
  pwmWrite(GPIO_pos,0);

  if (ToggleBox1.Checked) then
       Timer1.Enabled:= true
  else
    Timer1.Enabled:= false;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  GPIO_pos := P12;

  if not wiringPiSetupDone then wiringPiSetup;
      wiringPiSetupDone:= true;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  pwmWrite(GPIO_pos, 0)
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    //..
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
   i:integer;
begin

  try

     Label2.Caption := 'LED light up';
     Shape1.Brush.Color := clLime;
      Application.ProcessMessages;
      for i := 0 to (5000 div 20) do
      begin
           pwmWrite(GPIO_pos, i);
           sleep(10);
      end;

      sleep(500);

      Label2.Caption := 'LED light off';
      Shape1.Brush.Color := clGray;
      Application.ProcessMessages;
      for i := (5000 div 20) downto 0 do
        begin
             pwmWrite(GPIO_pos, i);
             sleep(10);
        end;
      sleep(500);

  except on e : Exception do
         ShowMessage(e.Message);

  end;



end;

end.

