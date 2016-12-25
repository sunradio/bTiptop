unit Asft110;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, StdCtrls, ToolWin, ComCtrls, Db, DBTables,PASDM,JclStrings,
  Menus,Sysdb, ExtCtrls,pasMain;

type
  TfrmAsft110 = class(TForm)
    tbASFT110: TToolBar;
    tbRun: TToolButton;
    qry_Asft110: TQuery;
    ds_Asft110: TDataSource;
    tbExport: TToolButton;
    tbFind: TToolButton;
    tbFilter: TToolButton;
    tbRemove: TToolButton;
    qry_Asft110wono: TStringField;
    qry_Asft110partno: TStringField;
    qry_Asft110stkno: TStringField;
    qry_Asft110woqty: TFloatField;
    qry_Asft110isqty: TFloatField;
    qry_Asft110shortage: TFloatField;
    qry_Asft110ds2stk: TFloatField;
    qry_Asft110ds3a02: TFloatField;
    qry_Asft110ds3stk: TFloatField;
    qry_Asft110ds5stk: TFloatField;
    qry_Asft110ds2iqc: TFloatField;
    qry_Asft110ds3iqc: TFloatField;
    qry_Asft110actshortage: TFloatField;
    qry_Asft110ds2ob: TFloatField;
    qry_Asft110ds3ob: TFloatField;
    DBGrid: TwwDBGrid;
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
    btbwo001: TButton;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    lblMsg: TLabel;
    txtWono: TEdit;
    lblWoNo: TLabel;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    qry_Asft110parent: TStringField;
    procedure tbRunClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure txtWonoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbExportClick(Sender: TObject);
    procedure tbFindClick(Sender: TObject);
    procedure tbFilterClick(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
    procedure DBGridDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure qry_Asft110CalcFields(DataSet: TDataSet);
    procedure Aimq1021Click(Sender: TObject);
    procedure aimq404Click(Sender: TObject);
    procedure asmq2021Click(Sender: TObject);
    procedure bbmq101Click(Sender: TObject);
    procedure aimq1311Click(Sender: TObject);
    procedure bpcs002FQC1Click(Sender: TObject);
    procedure bpcs0011Click(Sender: TObject);
    procedure aimq1361Click(Sender: TObject);
    procedure aimq1381Click(Sender: TObject);
    procedure aimq1371Click(Sender: TObject);
    procedure aimq1341Click(Sender: TObject);
    procedure aimq1401Click(Sender: TObject);
    procedure abmi7201Click(Sender: TObject);
    procedure btbwo001Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAsft110: TfrmAsft110;

implementation
uses pasCodeProc,pasSysRes,bomcode;
{$R *.DFM}

procedure TfrmAsft110.tbRunClick(Sender: TObject);
var
  vQry:TQuery;
  vSql,sDbName:String;

  procedure ChkWo;
  begin
    if StrIsAlpha(StrMid(txtWono.Text,3,1)) then  begin
       lblMsg.Font.Color:=clRed;
       lblMsg.Caption:='保稅工單';
       sDbName:='DS3::';
    end else begin
       lblMsg.Font.Color:=clBlue;
       lblMsg.Caption:='非保稅工單';
       sDbName:='DS2::';
    end;
   end;
begin

  if txtWono.Text<>'' then
  begin
  vSql:=
   'SELECT SFA01 AS WONO,                    '+
   '    (SELECT SFB05 FROM %sSFB_FILE C WHERE A.SFA01=C.SFB01 ) AS parent,                     '+
   '    SFA03 AS PARTNO,                     '+
   '    SFA30 AS STKNO ,                     '+
   '    SUM(SFA05) AS WOQTY,                 '+
   '    SUM(SFA06) AS ISQTY,                 '+
   '    SUM(SFA05-SFA06) AS SHORTAGE,        '+
   '                                         '+
   '    (SELECT SUM(IMG10)                   '+
   '       FROM DS2::IMG_FILE B              '+
   '      WHERE B.IMG01=A.SFA03              '+
   '       AND B.IMG23=''Y''                   '+
   '       AND B.IMG02 IN (''01'',''02'',''0A'')) AS DS2STK,    '+
   '                                         '+
   '    (SELECT SUM(IMG10)                   '+
   '       FROM DS3::IMG_FILE C               '+
   '      WHERE C.IMG01=A.SFA03                '+
   '        AND C.IMG23=''Y''                     '+
   '        AND C.IMG02=''A02'' ) AS DS3A02,       '+
   '                                             '+
   '    (SELECT SUM(IMG10)                       '+
   '       FROM DS3::IMG_FILE C                  '+
   '      WHERE C.IMG01=A.SFA03                  '+
   '        AND C.IMG23=''Y'' AND C.IMG02 IN (''A01'',''A0A'')) AS DS3STK,      '+
   '                                                           '+
   '    (SELECT SUM(IMG10)                                     '+
   '       FROM DS2::IMG_FILE B                                '+
   '      WHERE B.IMG01=A.SFA03                                '+
   '       AND B.IMG23=''Y''                                      '+
   '       AND B.IMG02=''BVI'') AS DS2OB,                        '+
   '                                                          '+
   '    (SELECT SUM(IMG10)                                    '+
   '       FROM DS3::IMG_FILE B                               '+
   '      WHERE B.IMG01=A.SFA03                                '+
   '       AND B.IMG23=''Y''                                      '+
   '       AND B.IMG02=''BVI'') AS DS3OB,                        '+
   '    (SELECT SUM(IMG10)                                     '+
   '       FROM DS5::IMG_FILE C                                '+
   '      WHERE C.IMG01=A.SFA03                                '+
   '        AND C.IMG23=''Y''                                    '+
   '        AND C.IMG02=''05'') AS DS5STK,                       '+
   '                                                            '+
   '    (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                  '+
   '       FROM DS2::RVB_FILE, DS2::RVA_FILE, DS2::PMN_FILE     '+
   '      WHERE RVB01=RVA01                                     '+
   '        AND RVB05 =A.SFA03                                  '+
   '        AND RVB04 = PMN01                                  '+
   '        AND RVB03 = PMN02                                  '+
   '        AND RVB07 > (RVB29+RVB30)) AS DS2IQC,               '+
   '                                                            '+
   '    (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                  '+
   '       FROM DS3::RVB_FILE, DS3::RVA_FILE, DS3::PMN_FILE      '+
   '      WHERE RVB01=RVA01                                      '+
   '        AND RVB05 =A.SFA03                                   '+
   '        AND RVB04 = PMN01                                     '+
   '        AND RVB03 = PMN02                                     '+
   '        AND RVB07 > (RVB29+RVB30)) AS DS3IQC                 '+

   '   FROM %sSFA_FILE A ,%sSFB_FILE B '+
   '    WHERE A.SFA01=B.SFB01 AND B.SFB04!=''8'' AND SFA01[5,8]=''%s'''+
   '    GROUP BY SFA01,SFA03,SFA30                                        '+
   '   HAVING  (SUM(SFA05-SFA06)<>0)                                      '+
   '    ORDER BY SFA01,SFA03';
  ChkWo;
  with QRY_ASFT110 do
  begin
    vQry := TQuery.Create(Self);
    try
      vQry.DatabaseName:='DS';
      vQry.SessionName:=SessionName;
      if vQry.Active then
         vQry.Close;
      vQry.SQL.Clear;
      vQry.SQL.Add(Format('SELECT COUNT(SFB01) FROM %SSFB_FILE WHERE SFB01[5,8]=''%S''',[SDBname,txtWono.text]));
      vQry.Open;

      if vQry.Fields[0].AsInteger>= 1 then begin
        if active then
         close;
         SQL.Clear;
         SQL.Add(Format(vSql,[sdbname,sdbname,sDbName,txtWono.Text])); // ParamByName('WONO').AsString:=txtWono.Text;
         try
           Screen.Cursor:=crSQLWait;
           QRY_ASFT110.Open;
         finally
           Screen.Cursor:=crDefault;
         end;
      end
      else begin
      if vQry.Active then
         vQry.Close;
      vQry.SQL.Clear;
      vQry.SQL.Add(Format('SELECT COUNT(SFB01) FROM %SSFB_FILE WHERE SFB01[5,8]=''%S''',[sDBname,txtWono.text]));
      vQry.Open;

      if vQry.Fields[0].AsInteger>= 1 then
      begin
        if active then
         close;
         SQL.Clear;
         SQL.Add(Format(vSql,[sDbName,sDbName,txtWono.Text])); // ParamByName('WONO').AsString:=txtWono.Text;
         try
           Screen.Cursor:=crSQLWait;
           if not qry_Asft110.Prepared then begin
              qry_Asft110.Prepare;
           end;
           QRY_ASFT110.Open;
         finally
           Screen.Cursor:=crDefault;
         end;

      end else
        Application.MessageBox(PChar(Format('ASFT110 ERR: 工單 %S 不存在!',[txtWoNo.Text])),'錯誤',MB_ICONERROR+MB_OK);
      end;
    finally
      vQry.Free;
    end;
  end;
  end;
end;

procedure TfrmAsft110.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if QRY_ASFT110.Active then
     QRY_ASFT110.Close;
  Action:=caFree;
end;

procedure TfrmAsft110.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAsft110.txtWonoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    tbRunClick(Sender);
end;

procedure TfrmAsft110.tbExportClick(Sender: TObject);
begin
  ShowExportOpen(QRY_ASFT110,'ASFT110_'+txtWono.Text,'ASFT110-工單欠料查詢');
end;

procedure TfrmAsft110.tbFindClick(Sender: TObject);
begin
  ShowFindDialog(QRY_ASFT110,dbgrid.GetActiveCol-1);
end;

procedure TfrmAsft110.tbFilterClick(Sender: TObject);
begin
  try
    if ShowFilterDialog(QRY_ASFT110,dbgrid.GetActiveCol-1) then
    begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
  except
    on e:exception do
    Application.MessageBox(PChar(e.Message),PChar(gErrCaption),MB_ICONERROR+MB_OK);
  end;
end;

procedure TfrmAsft110.tbRemoveClick(Sender: TObject);
begin
  if QRY_ASFT110.Filtered then
  begin
     QRY_ASFT110.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmAsft110.DBGridDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
begin
  if qry_Asft110.fieldbyname('actShortage').asinteger > 0 then
  begin
     DBGrid.Canvas.Brush.Color:=clAqua;
     DBGrid.Canvas.Font.Color:=clNavy;
  end;
  dbgrid.DefaultDrawDataCell(rect, Field, state);

end;

procedure TfrmAsft110.qry_Asft110CalcFields(DataSet: TDataSet);
var
  iResult:Integer;
begin
  with DataSet.Fields  do
  begin
    if FieldByName('stkno').AsString='A01' then
    begin // 保稅可用所有庫存
     { iResult:=(FieldByName('woqty').AsInteger-FieldByName('isqty').AsInteger)-(
               FieldByName('ds2stk').AsInteger+FieldByName('ds3stk').AsInteger+
               FieldByName('ds3a02').AsInteger);}
      // 2003/12/13 BY RENWEI ADD 保稅與非保稅分別處理,不要參考其它庫存數據
      iResult:=(FieldByName('woqty').AsInteger-FieldByName('isqty').AsInteger)-(
               FieldByName('ds3stk').AsInteger);

      if iResult > 0 then
         FieldByName('actShortage').AsInteger:=iResult else
         FieldByName('actShortage').AsInteger:=0;
    end
    else
    begin // 非保稅可用01+A02庫存
      iResult:=(FieldByName('woqty').AsInteger-FieldByName('isqty').AsInteger)-(
                FieldByName('ds2stk').AsInteger+FieldByName('ds3a02').AsInteger);

      if iResult > 0 then
         FieldByName('actShortage').AsInteger:=iResult else
         FieldByName('actShortage').AsInteger:=0;
    end;
  end;
end;

procedure TfrmAsft110.Aimq1021Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq102') then
         GetBalQty_Aimq102(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.aimq404Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq404') then
         GetStockQty_Aimq404(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.asmq2021Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('asmq202') then
         GetTransLog_asmq202(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.bbmq101Click(Sender: TObject);
begin
 { if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
       //GetMfgPart_bbmq101(DBGrid.Fields[2].AsString);
   end;
  end; }
  if txtWono.text<>'' then GetBomCompare_wo(txtWono.Text);
end;

procedure TfrmAsft110.aimq1311Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq131') then
         GetOrderQty_Aimq131(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.bpcs002FQC1Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWaitFqcQ_Bpcs002(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.bpcs0011Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWeWipQty_Bpcs001(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.aimq1361Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq136') then
         GetWoWipQty_Aimq136(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.aimq1381Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq138') then
         GetWorksQty_Aimq138A(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.aimq1371Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq137') then
         GetWaitIqcQ_Aimq137(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.aimq1341Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq134') then
         GetPuOrdQty_Aimq134(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.aimq1401Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq140') then
         GetReqstQty_Aimq140(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.abmi7201Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetEcnQty_Abmi720(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAsft110.btbwo001Click(Sender: TObject);
begin
  GetWodata_bwoq001(txtWono.text);
end;

end.
