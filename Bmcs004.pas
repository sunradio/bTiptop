unit Bmcs004;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmBmcs004 = class(TForm)
    cmdOk: TBitBtn;
    cmdCancel: TBitBtn;
    lblStartNo: TLabel;
    txtStartNo: TEdit;
    lblEndNo: TLabel;
    txtEndNo: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBmcs004: TfrmBmcs004;

implementation

{$R *.DFM}

end.
