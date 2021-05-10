unit UnitThread;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TMyThread=class(TThread)
    procedure execute; override;
    procedure Finish;
    procedure Ligne ;
  end;


  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Memo1: TMemo;
    AniIndicator1: TAniIndicator;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }

    procedure StopThread ;

  end;

var
  Form2: TForm2;

  FMyThread : TMyThread ;
  FArreterThread : boolean ;
  Fmythreadid : integer ;


implementation

{$R *.fmx}


{------------------------------------------------------------------------------}
 ////////////////////////////////////////////////////////// Gestion Thread ////
{------------------------------------------------------------------------------}

 procedure TMyThread.execute;
 var
   i, m : integer ;
 begin

  m := 0 ;
  Fmythreadid := Self.ThreadID ;

   for i:= 1 to 10000 do begin
     if FArreterThread = True then begin
       synchronize(Finish);
       Exit ;
     end;
     inc(m);
     Form2.Memo1.lines.add(inttostr(m));
     synchronize(Ligne);
   end;

   synchronize(Finish);

 end;


{------------------------------------------------------------------------------}

 procedure TMyThread.Finish;
 begin
   Form2.memo1.lines.add('Thread Finish');
   Form2.AniIndicator1.Enabled := False ;
   Form2.AniIndicator1.Visible := False ;
   Form2.Memo1.Visible := True ;
 end;


 {------------------------------------------------------------------------------}

 procedure TMyThread.Ligne;
 begin
    //
 end;




{------------------------------------------------------------------------------}
 ////////////////////////////////////////// Gestion Application principale ////
{------------------------------------------------------------------------------}

procedure TForm2.Button1Click(Sender: TObject);
var
  i: integer ;
begin
  Memo1.Lines.Clear ;
  for i:= 0 to 10000 do begin
    memo1.lines.add(inttostr(i));
  end;
end;


{------------------------------------------------------------------------------}

procedure TForm2.Button2Click(Sender: TObject);
begin
  AniIndicator1.Visible := True ;
  AniIndicator1.Enabled := True ;
  Memo1.Lines.Clear ;
  Memo1.Visible := False ;
  FArreterThread := False ;
  FMyThread := TMyThread.Create(False) ;
end;


{------------------------------------------------------------------------------}

procedure TForm2.Button3Click(Sender: TObject);
begin
  FMyThread.Synchronize(StopThread);
end;


{------------------------------------------------------------------------------}

procedure TForm2.StopThread;
begin
  FArreterThread := True ;
end;


end.
