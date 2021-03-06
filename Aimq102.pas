unit Aimq102;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, StdCtrls, ToolWin, ComCtrls, Db, DBTables,PASDM,
  Menus, ExtCtrls,pasMain;

type
  TfrmAimq102 = class(TForm)
    tbASFT110: TToolBar;
    tbRun: TToolButton;
    Query: TQuery;
    ds_query: TDataSource;
    tbExport: TToolButton;
    tbFind: TToolButton;
    tbFilter: TToolButton;
    tbRemove: TToolButton;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Panel2: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
    txtPartno: TEdit;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    Button14: TButton;
    Button15: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button16: TButton;
    DBGrid: TwwDBGrid;
    cbSel: TCheckBox;
    Button20: TButton;
    procedure tbRunClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure txtPartnoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbExportClick(Sender: TObject);
    procedure tbFindClick(Sender: TObject);
    procedure tbFilterClick(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
    procedure aimq404Click(Sender: TObject);
    procedure aimq1311Click(Sender: TObject);
    procedure aimq1381Click(Sender: TObject);
    procedure aimq1401Click(Sender: TObject);
    procedure aimq1341Click(Sender: TObject);
    procedure aimq1361Click(Sender: TObject);
    procedure bpcs0011Click(Sender: TObject);
    procedure aimq1371Click(Sender: TObject);
    procedure bpcs002FQC1Click(Sender: TObject);
    procedure asmq2021Click(Sender: TObject);
    procedure abmi7201Click(Sender: TObject);
    procedure bbmq101Click(Sender: TObject);
    procedure Aimq1021Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure DBGridCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure Button1Click(Sender: TObject);
    procedure cbSelClick(Sender: TObject);
    procedure Button20Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAimq102: TfrmAimq102;

implementation
uses pasCodeProc,pasSysRes,sysdb,Com001,pasGetWOSDWhere,asfCode,pasGetDate;
{$R *.DFM}

procedure TfrmAimq102.tbRunClick(Sender: TObject);
var
  lSql:String;
begin
  if txtPartno.Text<>'' then
  begin
  with Query do
  begin
    if active then
    begin
      close;
      if not Prepared then
         Prepare;
    end;
    SQL.Clear;
    if cbSel.Checked then begin
    lSql:='      SELECT IMA01   AS 材料料號,     '+
          '             IMA02   AS 品名描述,     '+
         // '             IMA021  AS 中文品名,     '+
          '             IMA262  AS 庫存,         '+
          '             IMA08   AS 來源,         '+
          '             IMA531  AS 采購市價,     '+
          '             CASE WHEN IMA103=''0'' THEN ''內購'' '+
          '                  WHEN IMA103=''1'' THEN ''外購'' '+
          '                  WHEN IMA103=''2'' THEN ''其它'' END AS 購料特性,     '+
          '             IMA48   AS 採購周期,     '+
          '             IMA46   AS 最小訂購,     '+
          '             IMA45   AS 最小包裝,     '+
          '             IMA27   AS 安全存量,     '+
          '             IMA43   AS 採購人員,     '+
          '             IMA54   AS 供應廠商,     '+
          '             IMA93   AS 資料處理,     '+
          ' (SELECT PMC03 FROM PMC_FILE WHERE PMC01=IMA54) AS 廠商簡稱'+

          '      FROM IMA_FILE                   '+
          '      WHERE IMA01 LIKE ''%S''';
    end else begin
     lSql:='      SELECT IMA01   AS 材料料號,     '+
          '             IMA02   AS 品名描述,     '+
         // '             IMA021  AS 中文品名,     '+
          '             IMA262  AS 庫存,         '+
          '             IMA08   AS 來源,         '+
          '             IMA531  AS 采購市價,     '+
          '             CASE WHEN IMA103=''0'' THEN ''內購'' '+
          '                  WHEN IMA103=''1'' THEN ''外購'' '+
          '                  WHEN IMA103=''2'' THEN ''其它'' END AS 購料特性,     '+
          '             IMA48   AS 採購周期,     '+
          '             IMA46   AS 最小訂購,     '+
          '             IMA45   AS 最小包裝,     '+
          '             IMA27   AS 安全存量,     '+
          '             IMA43   AS 採購人員,     '+
          '             IMA54   AS 供應廠商,     '+
          '             IMA93   AS 資料處理,     '+
          ' (SELECT PMC03 FROM PMC_FILE WHERE PMC01=IMA54) AS 廠商簡稱'+

          '      FROM IMA_FILE                   '+
          '      WHERE IMA01 LIKE ''%S'' AND IMA262>0';
    end;
    SQL.Add(Format(lSql,[txtPartno.Text+'%']));
    try
      Screen.Cursor:=crSQLWait;
      Query.Open;
      DBGrid.Fields[0].DisplayWidth:=13;
    finally
      Screen.Cursor:=crDefault;
    end;

  end;
  end;

end;

procedure TfrmAimq102.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Query.Active then
     Query.Close;
  if Query.Prepared then
     Query.UnPrepare;

  Action:=caFree;
end;

procedure TfrmAimq102.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAimq102.txtPartnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    tbRunClick(Sender);
end;

procedure TfrmAimq102.tbExportClick(Sender: TObject);
begin
  ShowExportOpen(Query,'aimq102','aimq102 - 料件基本資料查詢');
end;

procedure TfrmAimq102.tbFindClick(Sender: TObject);
begin
  ShowFindDialog(Query,dbgrid.GetActiveCol-1);
end;

procedure TfrmAimq102.tbFilterClick(Sender: TObject);
begin
  try
    if ShowFilterDialog(Query,dbgrid.GetActiveCol-1) then begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
  except
    on e:exception do
    Application.MessageBox(PChar(e.Message),PChar(gErrCaption),MB_ICONERROR+MB_OK);
  end;
end;

procedure TfrmAimq102.tbRemoveClick(Sender: TObject);
begin
  if Query.Filtered then
  begin
     Query.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmAimq102.aimq404Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq404') then
         GetStockQty_Aimq404(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.aimq1311Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq131') then
         GetOrderQty_Aimq131(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.aimq1381Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq138') then
         GetWorksQty_Aimq138A(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.aimq1401Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq140') then
         GetReqstQty_Aimq140(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.aimq1341Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq134') then
         GetPuOrdQty_Aimq134(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.aimq1361Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq136') then
         GetWoWipQty_Aimq136(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.bpcs0011Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWeWipQty_Bpcs001(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.aimq1371Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq137') then
         GetWaitIqcQ_Aimq137(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.bpcs002FQC1Click(Sender: TObject);
begin
{  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWaitFqcQ_Bpcs002(DBGrid.Fields[0].AsString);
    end;
  end;  }

if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWoPartQty_Aimq102(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.asmq2021Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('asmq202') then
         GetTransLog_asmq202(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.abmi7201Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetEcnQty_Abmi720(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.bbmq101Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq102') then
         GetPartOthIn_aimq102a(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.Aimq1021Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
       if ChkUserEx('aimq102') then
         GetBalQty_Aimq102(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAimq102.Button14Click(Sender: TObject);
var
  ym:string;
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq102') then  begin
        //ym:=FormatDatetime('yyyy',date);
        if GetQueryWhere('進出存查詢','請輸入年份（YYYY）',ym,true) then begin

         GetPartTrans_Aimq102(DBGrid.Fields[0].AsString,ym);
        end;
      // end;
    end;
  end;
end;

procedure TfrmAimq102.Button15Click(Sender: TObject);
begin
    if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq102') then
         GetWoMode_Aimq102(DBGrid.Fields[0].AsString);
    end;
  end;

end;

procedure TfrmAimq102.Button17Click(Sender: TObject);
begin
 if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
   GetModeSD(DBGrid.Fields[0].AsString);
  end;
 end;
end;

procedure TfrmAimq102.Button18Click(Sender: TObject);
begin
  If Query.Active then begin
    GetModeSDGWT(DBGrid.Fields[0].AsString);
  end;

end;

procedure TfrmAimq102.Button19Click(Sender: TObject);
begin
 if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
    GetGwtShip(DBGrid.Fields[0].AsString);
   end;
 end;
end;

procedure TfrmAimq102.QueryAfterScroll(DataSet: TDataSet);
begin
   SetRecno(Query);

end;

procedure TfrmAimq102.DBGridCalcCellColors(Sender: TObject; Field: TField;
  State: TGridDrawState; Highlight: Boolean; AFont: TFont; ABrush: TBrush);
{Var
  clOrange:TColor;  }
begin
{  clOrange:= clRed+clGreen;
    with (Sender as TwwDBGrid) do
    if CalcCellRow = GetActiveRow then begin
      ABrush.Color := clOrange;
      AFont.color:= clWhite;
    end;  }
end;

procedure TfrmAimq102.Button1Click(Sender: TObject);
 var
   begindate,enddate,ds2Eta,ds3Eta:string;
   IncDay:Integer;
begin
 if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
       if ChkUserex('aimq841') then begin
         if  DBGrid.Fields[3].AsString='P' then begin
           IncDay:=180;
           if SetWoSDWhere( begindate,enddate,ds2Eta,ds3Eta,IncDay) then begin
             GetPartSD(DBGrid.Fields[0].AsString,begindate,enddate,ds2Eta,ds3Eta);
           end;
         end else begin
           Application.MessageBox(Pchar((Format('%s , %S - %s 非採購件！',
             [Username,DBGrid.Fields[0].AsString,DBGrid.Fields[3].AsString]))),'提示',MB_ICONINFORMATION+MB_OK);
         end;
       end;
    end;
  end;
end;

procedure TfrmAimq102.cbSelClick(Sender: TObject);
begin
 if cbSel.Checked then begin
   cbSel.Caption:='全部查看';
   cbSel.Checked:=True;
 end else begin
   cbSel.Caption:='僅有庫存';
   cbSel.Checked:=false;
 end;
end;

procedure TfrmAimq102.Button20Click(Sender: TObject);
var
  BeginDate,EndDate:string;
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      if ShowGetDate('相關資料查詢', BeginDate,EndDate) then begin
          GetModeWo(DBGrid.Fields[0].AsString,BeginDate,EndDate);
      end;
    end;
  end;
end;

end.
