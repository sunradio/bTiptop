unit Bmcs002;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmBmcs002 = class(TForm)
    cmdOk: TBitBtn;
    cmdCancel: TBitBtn;
    GroupBox1: TGroupBox;
    lblPlanNo: TLabel;
    lblMoni: TLabel;
    lvlWoCfm: TLabel;
    lblWoQty: TLabel;
    txtPlanNo: TEdit;
    txtVersion: TEdit;
    txtWoCfm: TEdit;
    txtWoQty: TEdit;
    procedure SetTiaoJianInit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure OpenFrmBmcs002;




implementation
uses WhatIF;

{$R *.DFM}

procedure OpenFrmBmcs002;
var
  frmBmcs002: TfrmBmcs002;
begin
  frmBmcs002 := TfrmBmcs002.Create(Application);
  try
    frmBmcs002.ShowModal;
    if frmBmcs002.ModalResult=mrOk then begin

       SetWhatIf_Bmcs002(frmBmcs002.txtVersion.Text,
                         frmBmcs002.txtPlanNo.Text,
                         frmBmcs002.txtWoCfm.Text,
                         StrToInt(frmBmcs002.txtWoQty.Text));
    end;
  finally
    frmBmcs002.Free;
  end;
end;


procedure TfrmBmcs002.SetTiaoJianInit;
begin
  txtPlanNo.Text:=FormatDateTime('yyyymm',Date);
  txtVersion.Text:=FormatDateTime('yyyymm',Date);
end;

procedure TfrmBmcs002.FormShow(Sender: TObject);
begin
  SetTiaoJianInit;
end;

end.
