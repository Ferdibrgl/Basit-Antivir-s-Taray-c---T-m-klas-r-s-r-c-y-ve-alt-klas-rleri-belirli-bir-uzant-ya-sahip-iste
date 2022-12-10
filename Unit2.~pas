unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses MD5;

function FileSize(fileName : String) : Int64;
var
  sr : TSearchRec;
begin
  if FindFirst(fileName, faAnyFile, sr ) = 0 then
     result := sr.Size
  else
     result := -1;
  FindClose(sr);
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
begin
if opendialog1.Execute then
 if opendialog1.FileName <> '' then
  if fileexists(opendialog1.FileName) and
     (edit1.Text <> '') then begin
   Memo1.Lines.Add( Edit1.Text+'#'+MD5DigestToStr(MD5File(opendialog1.FileName))+
   '#'+IntToStr(FileSize(opendialog1.FileName)));
    end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
       //save database
       Memo1.Lines.SaveToFile(ExtractFilePath(paramstr(0))+'database.txt');
end;

procedure TForm2.FormShow(Sender: TObject);
begin
//Load database
Memo1.Lines.LoadFromFile(ExtractFilePath(paramstr(0))+'database.txt');
end;

end.
