unit apmr503a;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TfrmApmr503a = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label5: TLabel;
    DateEnd: TDateTimePicker;
    Label8: TLabel;
    cmbIRNo: TComboBox;
    procedure SetBuyerInit;
    procedure SetDateInit;
    procedure FormShow(Sender: TObject);
    procedure cmbIRNoDropDown(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure OpenfrmApmr503;


implementation
uses pasCodeProc,pasSysQryResultEx,mrpcode;
{$R *.DFM}

procedure TfrmApmr503a.SetDateInit;
begin
  dateEnd.Date:=Date;
end;


procedure TfrmApmr503a.SetBuyerInit;
begin
  GetRecToComboBox(cmbIRNo.Items,
                   'SELECT TRIM(GEN01)||''-''||GEN02'+
                   '  FROM GEN_FILE                 '+
                   ' WHERE GEN03=''2324''           '+
                   ' ORDER BY 1');
end;


procedure OpenfrmApmr503;
var
  frmApmr503a: TfrmApmr503a;
  VEnd,VIRNo:String;
begin
  frmApmr503a := TfrmApmr503a.Create(Application);
  try
    frmApmr503a.ShowModal;
    if frmApmr503a.ModalResult=mrOk then begin
       VEnd:=FormatDateTime('yyyymmdd',frmApmr503a.dateEnd.Date);
       VIRNo:=GetFindStr(frmApmr503a.cmbIRNo.Text,'-');
       // RUN SQL
       GetPoDelay_apmr503(VEnd,VIRNo);
    end;
  finally
    frmApmr503a.Free;
  end;
end;

procedure TfrmApmr503a.FormShow(Sender: TObject);
begin
  SetDateInit;   //開始以及結束日期初始化
end;

procedure TfrmApmr503a.cmbIRNoDropDown(Sender: TObject);
begin
 if cmbIRNo.Items.Count <=0 then
  SetBuyerInit;  //採購人員資料獲取
end;

end.
