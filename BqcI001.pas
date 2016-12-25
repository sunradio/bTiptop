unit BqcI001;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TfrmBqcI001 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    txtRevNo: TEdit;
    txtPoNo: TEdit;
    cmbVendor: TComboBox;
    GroupBox3: TGroupBox;
    txtPartno: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    DateStart: TDateTimePicker;
    Label5: TLabel;
    DateEnd: TDateTimePicker;
    Label8: TLabel;
    cmbIRNo: TComboBox;
    procedure SetVendorInit;
    procedure SetBuyerInit;
    procedure SetDateInit;
    procedure FormShow(Sender: TObject);
    procedure cmbVendorDropDown(Sender: TObject);
    procedure cmbIRNoDropDown(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure OpenfrmBqcI001;


implementation
uses pasCodeProc,pasSysQryResultEx,AqcCode;
{$R *.DFM}

procedure TfrmBqcI001.SetDateInit;
begin
  dateStart.Date:=Date-31;
  dateEnd.Date:=Date;
end;


procedure TfrmBqcI001.SetVendorInit;
begin
  GetRecToComboBox(cmbVendor.Items,
                   'SELECT TRIM(PMC01)||''-''||PMC03  '+
                   '  FROM PMC_FILE                   '+
                   ' WHERE PMC05=''0'' AND PMC14=''1'''+
                   ' ORDER BY 1');
end;

procedure TfrmBqcI001.SetBuyerInit;
begin
  GetRecToComboBox(cmbIRNo.Items,
                   'SELECT TRIM(GEN01)||''-''||GEN02'+
                   '  FROM GEN_FILE                 '+
                  // ' WHERE GEN03=''2324''           '+ 
                   ' ORDER BY 1');
end;


procedure OpenfrmBqcI001;
var
  frmBqcI001: TfrmBqcI001;
  VRevNo,VPONo,VStart,VEnd,VVendor,VIRNo,VPartno:String;
begin
  frmBqcI001 := TfrmBqcI001.Create(Application);
  try
    frmBqcI001.ShowModal;
    if frmBqcI001.ModalResult=mrOk then begin
       VRevNo:=frmBqcI001.txtRevNo.Text;
       VPONo:=frmBqcI001.txtPoNo.Text;
       VStart:=FormatDateTime('yyyymmdd',frmBqcI001.dateStart.Date);
       VEnd:=FormatDateTime('yyyymmdd',frmBqcI001.dateEnd.Date);
       VVendor:=GetFindStr(frmBqcI001.cmbVendor.text,'-');
       VIRNo:=GetFindStr(frmBqcI001.cmbIRNo.Text,'-');
       VPartno:=frmBqcI001.txtPartno.Text;
       // RUN SQL
       GetWaitIqc_Bqcr001(VRevNo,VPONo,VStart,VEnd,VVendor,VIRNo,VPartno);
    end;
  finally
    frmBqcI001.Free;
  end;
end;

procedure TfrmBqcI001.FormShow(Sender: TObject);
begin
  SetDateInit;   //開始以及結束日期初始化
end;

procedure TfrmBqcI001.cmbVendorDropDown(Sender: TObject);
begin
  if cmbVendor.Items.Count <= 0 then
    SetVendorInit; //廠商代號資料獲取
end;

procedure TfrmBqcI001.cmbIRNoDropDown(Sender: TObject);
begin
 if cmbIRNo.Items.Count <=0 then
  SetBuyerInit;  //採購人員資料獲取
end;

end.
