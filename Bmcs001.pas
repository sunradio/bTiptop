unit Bmcs001;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin,pasDm, Db,  ExtCtrls, DBCtrls, Grids, DBGrids,
  StdCtrls,

  pasMain,
  JclStrings, Wwdbigrd, Wwdbgrid, Mask, wwdblook, DBTables;

type
  TfrmBmcs001 = class(TForm)
    ds_bmcs001_a: TDataSource;
    tbDataEdit: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    tbDataTool: TToolBar;
    ToolButton6: TToolButton;
    tbDelete: TToolButton;
    tbExport: TToolButton;
    ToolButton10: TToolButton;
    tbCommit: TToolButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    wwDBGrid1: TwwDBGrid;
    qry_bmcs001_a: TQuery;
    qry_bmcs001_b: TQuery;
    txtDb: TDBEdit;
    txtOrds: TDBEdit;
    txtStar: TDBEdit;
    qry_bmcs001_amca_ym: TStringField;
    qry_bmcs001_amca_ords: TSmallintField;
    qry_bmcs001_amca_wono: TStringField;
    qry_bmcs001_amca_star: TDateField;
    qry_bmcs001_amca_db: TStringField;
    GroupBox1: TGroupBox;
    DBText4: TDBText;
    ds_bmcs001_b: TDataSource;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText5: TDBText;
    DBText6: TDBText;
    DBText7: TDBText;
    DBText8: TDBText;
    DBText9: TDBText;
    DBText1: TDBText;
    DBText10: TDBText;
    txtPlanno: TDBEdit;
    lblDb: TLabel;
    lblOrds: TLabel;
    lblStar: TLabel;
    lblWono: TLabel;
    lblPlanno: TLabel;
    lblWonoa: TLabel;
    lblWoStatus: TLabel;
    lblPart: TLabel;
    lblWoQty: TLabel;
    lblIsQty: TLabel;
    lblInQty: TLabel;
    lblStartDate: TLabel;
    lblActDate: TLabel;
    lblClose: TLabel;
    lblStkNo: TLabel;
    tbQuery: TToolButton;
    UpdateSQL1: TUpdateSQL;
    txtWono: TDBEdit;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbExportClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbDeleteClick(Sender: TObject);
    procedure tbCommitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tbl_bmcs001CalcFields(DataSet: TDataSet);
    procedure tbQueryClick(Sender: TObject);
    procedure qry_bmcs001_aBeforeOpen(DataSet: TDataSet);
    procedure qry_bmcs001_aBeforeClose(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure qry_bmcs001_aBeforeDelete(DataSet: TDataSet);
    procedure qry_bmcs001_aNewRecord(DataSet: TDataSet);
    procedure txtWonoExit(Sender: TObject);
  private
    //TNum : array [0..9] of word;{ Private declarations }
  public
    { Public declarations }
  end;
  
function OpenBmcs004(Var StartVer,EndVer:String):Boolean;

var
  frmBmcs001: TfrmBmcs001;

implementation
uses pasCodeProc,
     bmcs004;
{$R *.DFM}

function OpenBmcs004(Var StartVer,EndVer:String):Boolean;
begin
  frmBmcs004 := TfrmBmcs004.Create(Application);
  try
    frmBmcs004.ShowModal;
    if frmBmcs004.ModalResult=mrOk then  begin
       StartVer:=frmBmcs004.txtStartNo.Text;
       EndVer:=frmBmcs004.txtEndNo.Text;
       Result:=True;
    end else begin
      Result:=False;
    end;
  finally
    frmBmcs004.Free;
  end;

end;


procedure TfrmBmcs001.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qry_bmcs001_a.Active then qry_bmcs001_a.Close;
  Action:=caFree;
end;

procedure TfrmBmcs001.tbExportClick(Sender: TObject);
begin
  ShowExportOpen(qry_bmcs001_a,'bmcs001','bmcs001 - 模擬缺料機種維護');
end;

procedure TfrmBmcs001.FormShow(Sender: TObject);
begin
  SetFormShow(self);

end;

procedure TfrmBmcs001.tbDeleteClick(Sender: TObject);
var
  strStartVer,strEndVer:String;
  vQry:TQuery;
begin
  if OpenBmcs004(strStartVer,strEndVer) then begin
      if Application.MessageBox(
                    PChar(Format('你確認要刪除排程 " %s - %s " 嗎?',
                    [strStartVer,strEndVer])),
                    '刪除確認',MB_ICONQUESTION+MB_YESNO)=ID_YES then begin
      vQry := TQuery.Create(Self);
      try with vQry do begin
        DatabaseName:='ds';
        SessionName:=dm.db.SessionName;
        if Active then Close;
        SQL.Clear;
        SQL.Add(Format
                ('DELETE GWS::MCA_FILE WHERE MCA_YM BETWEEN ''%S'' AND ''%S''',
                [strStartVer,strEndVer]));
        ExecSQL;
         end;

      finally
        vQry.Free;
      end;
      if qry_bmcs001_a.Active then begin
         qry_bmcs001_a.Close;
         qry_bmcs001_a.Open;
      end;
    end;
  end;
end;

procedure TfrmBmcs001.tbCommitClick(Sender: TObject);
begin
  // if tbl_bmcs001.UpdateStatus in [usModified, usInserted, usDeleted] then
  // dm.db.ApplyUpdates([qry_bmcs001_a,qry_bmcs001_B]);  
  if qry_bmcs001_a.UpdatesPending then begin
     qry_bmcs001_a.ApplyUpdates;
  end;
end;

procedure TfrmBmcs001.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
if qry_bmcs001_a.UpdatesPending then begin
     case Application.MessageBox('編輯資料未保存,保存后退出?','信息',MB_ICONQUESTION+MB_YESNOCANCEL) of
     IDYES:begin
             qry_bmcs001_a.ApplyUpdates;
             //dm.db.ApplyUpdates([tbl_bmcs001]);
             CanClose:=True;
           end;
     IDNO:CanClose:=True;
     IDCANCEL:CanClose:=False;
     end;
end
else
  CanClose:=True;

end;

procedure TfrmBmcs001.tbl_bmcs001CalcFields(DataSet: TDataSet);
begin
 { if StrIsAlpha(StrMid(qry_bmcs001_amca_wono.AsString,7,1)) then begin
    if qry_bmcs001_amca_db.AsString='DS2' then
       qry_bmcs001_amca_chk.AsString:='ERROR';
  end else begin

    if qry_bmcs001_amca_db.AsString='DS3' then
       qry_bmcs001_amca_chk.AsString:='ERROR';
  end; }
end;

procedure TfrmBmcs001.tbQueryClick(Sender: TObject);
var
  strStartVer,strEndVer:String;
begin
  if OpenBmcs004(strStartVer,strEndVer) then begin
  with qry_bmcs001_a do begin
    if Active then Close;
    ParamByName('BeginYm').AsString:=strStartVer;
    ParamByName('EndYm').AsString:=strEndVer;
    Open;
  end;

  end;
end;

procedure TfrmBmcs001.qry_bmcs001_aBeforeOpen(DataSet: TDataSet);
begin
  if not qry_bmcs001_b.Active then qry_bmcs001_b.Open;
end;

procedure TfrmBmcs001.qry_bmcs001_aBeforeClose(DataSet: TDataSet);
begin
  if qry_bmcs001_b.Active then qry_bmcs001_b.Close;
end;

procedure TfrmBmcs001.FormCreate(Sender: TObject);
begin
  if not qry_bmcs001_a.Active then qry_bmcs001_a.Open;
end;

procedure TfrmBmcs001.qry_bmcs001_aBeforeDelete(DataSet: TDataSet);
begin
   ConfrimDelete(qry_bmcs001_a);
end;

procedure TfrmBmcs001.qry_bmcs001_aNewRecord(DataSet: TDataSet);
begin
  qry_bmcs001_amca_ym.AsString:=txtPlanno.Text;


end;

procedure TfrmBmcs001.txtWonoExit(Sender: TObject);
begin
  if StrIsAlpha(StrMid(txtWono.Text,7,1)) then  begin
     txtDb.Text:='DS3';
  end else begin
     txtDb.Text:='DS2';
  end;
end;

end.
