unit main;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, h2wiringpi;

{ TForm1 }

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label2: TLabel;
    Shape1: TShape;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  wiringPiSetupDone: boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  if not wiringPiSetupDone then wiringPiSetup;
  wiringPiSetupDone:= true;

  // reset lights
  for i := 1 to 8 do
      begin
          pinMode(i, OUTPUT);
          digitalWrite(i, HIGH);

      end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  iPin: integer;
begin
  if not wiringPiSetupDone then wiringPiSetup;

  Randomize;
  iPin := Random(7);
  pinMode(iPin, OUTPUT);

  digitalWrite(iPin, LOW);
  Shape1.Brush.Color := clLime;
  Label2.Caption := 'LED GPIO' + iPin.ToString + ' ON';

  Application.ProcessMessages;
  delay(500);

  digitalWrite(iPin, HIGH);
  Shape1.Brush.Color := clGray;
  Label2.Caption := 'LED GPIO' + iPin.ToString + ' OFF';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Button1.Enabled := false;
  Timer1.Enabled := true;
end;

end.

