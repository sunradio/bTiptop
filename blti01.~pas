unit blti01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfrmBlt01 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;
    txtYm: TEdit;
    txtVer: TEdit;
    txtLtDefine: TEdit;
    txtItemStart: TEdit;
    txtItemEnd: TEdit;
    txtIrNo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    Bevel1: TBevel;
    txtVendorA: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function ShowGetLTValue(VAR strYm,strVer,strItemStart,strItemEnd,strIrNo,strVendorA,intLtDefine:String):Boolean;

implementation

{$R *.DFM}



function ShowGetLTValue(VAR strYm,strVer,strItemStart,strItemEnd,strIrNo,strVendorA,intLtDefine:String):Boolean;
var
  frmBlt01: TfrmBlt01;
begin
  frmBlt01 := TfrmBlt01.Create(Application);
  try
    frmBlt01.ShowModal;
    if frmBlt01.ModalResult=mrOk then
    begin
      Result:=True;
      strYm :=frmBlt01.txtYm.Text;
      strVer :=frmBlt01.txtVer.Text;
      strItemStart :=frmBlt01.txtItemStart.Text;
      strItemEnd :=frmBlt01.txtItemEnd.Text;
      strIrNo :=frmBlt01.txtIrNo.Text;
      intLtDefine := frmBlt01.txtLtDefine.Text;
      strVendorA:=frmBlt01.txtVendorA.text;

    end else begin
      Result:=False;
    end;
  finally
    frmBlt01.Free;
  end;

end;

procedure TfrmBlt01.FormCreate(Sender: TObject);
begin
  txtYm.Text:=FormatDateTime('yyyymm',Now());
  txtVer.Text:=FormatDateTime('yyyymm',Now())+'A';
  txtLtDefine.Text:=IntToStr(60);
  txtIrNo.Text:='%';
  txtItemStart.Text:='11';
  txtItemEnd.Text:='ZZ';
  txtVendorA.Text:='XATWXGU0';
end;

end.
