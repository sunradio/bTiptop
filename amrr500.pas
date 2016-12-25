unit amrr500;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmAmrr500 = class(TForm)
    btOk: TBitBtn;
    btCancel: TBitBtn;
    gbSelect: TGroupBox;
    lblStartDate: TLabel;
    lblEndDate: TLabel;
    txtVersion: TEdit;
    txtMp: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function GetMrpReportValue(Var MrpVersion,MPart:String):Boolean;


implementation

{$R *.DFM}

function GetMrpReportValue(Var MrpVersion,MPart:String):Boolean;
var
  frmAmrr500: TfrmAmrr500;
begin
  frmAmrr500 := TfrmAmrr500.Create(Application);
  try
    frmAmrr500.ShowModal;
    if frmAmrr500.ModalResult=mrOk then begin
      Result:=True;
      MrpVersion:=frmAmrr500.txtVersion.text;
      MPart:=frmAmrr500.txtMP.text;
    end else begin
      Result:=False;
    end;
  finally
    frmAmrr500.Free;
  end;

end;

end.
