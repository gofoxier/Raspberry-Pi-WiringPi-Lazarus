unit main;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  h2wiringpi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    MotorPin1   : integer;    // pin11
    MotorPin2   : integer;    // pin12
    MotorEnable : integer;    // pin13

    procedure Setup;
    procedure Cleanup;
  public

  end;

var
  Form1: TForm1;
  wiringPiSetupDone: boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ToggleBox1Change(Sender: TObject);
begin
  if NOT wiringPiSetupDone then Setup;

    if (ToggleBox1.Checked) then
      Timer1.Enabled:= true
  else
      Timer1.Enabled:= false;
end;

procedure TForm1.Setup;
begin
  MotorPin1   := P11;    // pin11
  MotorPin2   := P12;    // pin12
  MotorEnable := P13;    // pin13

    wiringPiSetup();
    pinMode(MotorPin1, OUTPUT);
    digitalWrite(MotorPin1, LOW);
    pinMode(MotorPin2, OUTPUT);
    digitalWrite(MotorPin2, LOW);
    pinMode(MotorEnable, OUTPUT);
    digitalWrite(MotorEnable, LOW);

    wiringPiSetupDone := True;

end;

procedure TForm1.Cleanup;
begin
    digitalWrite(MotorEnable, LOW);
    digitalWrite(MotorPin1, LOW);
    digitalWrite(MotorPin2, LOW);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Setup;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
     CleanUp;
     CloseAction := TCloseAction.caFree;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
   CleanUp;
  CanClose:=True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
        Label1.Caption:='Motor clockwise...';
        Application.ProcessMessages;
        digitalWrite(MotorEnable, HIGH);   // motor driver enable
        digitalWrite(MotorPin1, HIGH);     // clockwise
        digitalWrite(MotorPin2, LOW);
        Delay(2000);

        Label1.Caption:='Motor stop...';
        Application.ProcessMessages;
        digitalWrite(MotorEnable, LOW);    // motor stop
        Delay(2000);

        Label1.Caption:='Motor anticlockwise...';
        Application.ProcessMessages;
        digitalWrite(MotorEnable, HIGH);   // motor driver enable
        digitalWrite(MotorPin1, LOW);      // anticlockwise
        digitalWrite(MotorPin2, HIGH);
        Delay(2000);

        Label1.Caption:='Motor stop...';
        Application.ProcessMessages;
        digitalWrite(MotorEnable, LOW);   // motor stop
        Delay(2000);

end;

end.

