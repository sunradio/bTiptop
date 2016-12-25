unit Abmr6910;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmAbmr6910 = class(TForm)
    GroupBox1: TGroupBox;
    txtPartA: TEdit;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    txtSelect: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbPcb: TCheckBox;
    cbRaw: TCheckBox;
    cbDesc: TCheckBox;
    Label5: TLabel;
    cbRe: TCheckBox;
    txtPartB: TEdit;
    lblPartA: TLabel;
    lblPartB: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbmr6910: TfrmAbmr6910;

implementation

{$R *.DFM}

end.
