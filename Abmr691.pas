unit Abmr691;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmAbmr691 = class(TForm)
    GroupBox1: TGroupBox;
    txtPart: TEdit;
    lbPart: TListBox;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    btAdd: TBitBtn;
    btRemove: TBitBtn;
    txtSelect: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbPcb: TCheckBox;
    cbRaw: TCheckBox;
    cbDesc: TCheckBox;
    Label5: TLabel;
    cbRe: TCheckBox;
    procedure btAddClick(Sender: TObject);
    procedure btRemoveClick(Sender: TObject);
    procedure txtPartKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbmr691: TfrmAbmr691;

implementation

{$R *.DFM}

procedure TfrmAbmr691.btAddClick(Sender: TObject);
begin
  if txtPart.Text<>'' then begin
    lbPart.Items.Add(txtPart.Text);
    txtPart.Clear;
  end;
end;

procedure TfrmAbmr691.btRemoveClick(Sender: TObject);
begin
  lbPart.Items.Delete(lbPart.ItemIndex);

end;

procedure TfrmAbmr691.txtPartKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key= 13 then
    btAddClick(Sender);
end;

end.
