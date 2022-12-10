unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, FileCtrl, BackgroundWorker;

type
  TForm1 = class(TForm)
    DriveComboBox1: TDriveComboBox;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    Worker1: TBackgroundWorker;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure Worker1Work(Worker: TBackgroundWorker);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    virs: tstringlist;
  end;

var
  Form1: TForm1;
  fnum: integer;

implementation

{$R *.dfm}

uses MD5, Unit2;

///functions to separate strings in database (virus name, hash and size);
function Ist(Txt: String; d: Pchar; Num: Integer): Integer;
var pp   : integer;
begin
Pp:=0;
while(Num <= Length(txt)) do
begin
if(txt[Num] <> d)then
 inc(Num)
else begin
if Num = Length(txt) then
if(txt[Num] = ':') then
break;
pp:=Num;
break
end;
end;
Ist:=pp;
end;
//extract separated strings
function Ext(Str: String; d: PChar; Num: Integer):String;
var
 t,
 PS ,
 PE : Integer;
begin
PS:= 1;
for t := 2 To Num do
 PS := Ist(Str, d,PS) + 1;
 PE := Ist(Str, d,PS) - 1;
if PE <= 0 then PE := Length(Str);
 Ext:=Copy(Str,PS, PE - PS + 1);
end;
//////////////////////////////////

procedure CheckFile(sfile: string; ssize: int64);
var hash: string;
    i: integer;
begin
Form1.Label3.Caption:=sfile;
fnum:=fnum+1;
Form1.Label2.Caption:='Scanned files: '+inttostr(fnum);
try
//get scanned file hash
hash:=MD5DigestToStr(MD5File(sfile));
 for i:=0 to Form1.virs.Count-1 do
  //check hash from database and filesize
  if ( ext(Form1.virs.Strings[0],'#',2) = hash ) and
     ( ext(Form1.virs.Strings[0],'#',3) = IntToStr(ssize) ) then
      //if match then show infected .. virus name
      Form1.Memo1.Lines.Add('Infected: '+sfile+' = '+ext(Form1.virs.Strings[0],'#',1));
except exit; end;
end;

//simple recursive file search procedure
procedure ScanDir(const Dir: string);
var
  SR: TSearchRec;
begin
  if FindFirst(IncludeTrailingBackslash(Dir) + '*.*', faAnyFile or faDirectory, SR) = 0 then
    try
      repeat

         
        if (SR.Attr and faDirectory = 0) and
           (ExtractFileExt(SR.Name) = '.exe') and //scan only this extension
            (SR.Size < 26214400) then //max file size 25 mb
        //found file, check extension
         //check md5 hash
          CheckFile(Dir+'\'+SR.Name, SR.Size)
        else if (SR.Name <> '.') and (SR.Name <> '..') then
          ScanDir(IncludeTrailingBackslash(Dir) + SR.Name);
      until FindNext(Sr) <> 0;
    finally
      FindClose(SR);
    end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
fnum:=0;
virs:=tstringlist.Create;
Memo1.Lines.Clear;
//check if database file exists
 if fileexists('database.txt') then begin
  Memo1.Lines.Add('Simple Antivirus Scanner by Antonov Alin Iulian (RO) started !');
  //load database in stringlist
  virs.LoadFromFile('database.txt');
  Form1.BitBtn1.Enabled:=false;
  Worker1.Execute; //start scan thread
   end else begin
    Memo1.Lines.Add('Database file not found !');
     end;
end;

procedure TForm1.Worker1Work(Worker: TBackgroundWorker);
begin
while not worker.CancellationPending do
 ScanDir(DriveComboBox1.Drive+':');

        while Form1.worker1.CancellationPending do begin
         Form1.worker1.AcceptCancellation;
         Form1.BitBtn1.Enabled:=true;
         Form1.Label3.Caption:='Cancelled !';
         end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
Form2.ShowModal;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Worker1.Cancel;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
//stop flickering
Form1.DoubleBuffered:=true;
end;

end.
