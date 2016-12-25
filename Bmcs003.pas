unit Bmcs003;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, ToolWin, ComCtrls, StdCtrls, Db, DBTables,
  Menus, ExtCtrls,pasMain;

type
  TfrmBmcs003 = class(TForm)
    qry_bmcs003: TQuery;
    ds_bmcs003: TDataSource;
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
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    DBGrid: TwwDBGrid;
    tbASFT110: TToolBar;
    ToolButton5: TToolButton;
    ToolButton12: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    tbRemove: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    lblVersion: TLabel;
    txtVersion: TEdit;
    lblMPart: TLabel;
    txtMPart: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GetWhatIf_Bmcs003(WIVersion,WIMPart:String);
    procedure tbRunClick(Sender: TObject);
    procedure tbExportClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
    procedure txtMPartKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
  private
    WhatIfVer:String;
  public
    //
  end;

var
  frmBmcs003: TfrmBmcs003;

implementation
uses pasDm,pasSysRes,pasCodeProc,WhatIf,Sysdb;
{$R *.DFM}

procedure TfrmBmcs003.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qry_bmcs003.Active then
     qry_bmcs003.Close;
   Action:=caFree;
end;

procedure TfrmBmcs003.GetWhatIf_Bmcs003(WIVersion,WIMPart:String);
var
  Delimiter,lSql:String;
begin
  Delimiter:=',';
  lSql:=EmptyStr;
  
      // 檢查 WHAT'IF 是否存在?
    if  GetRecordCount(Format(
              'SELECT COUNT(MCE_VER)             '+
              '  FROM GWS::MCE_FILE              '+
              ' WHERE MCE_VER = ''%S''',[WIVersion])) > 0 then begin

        if qry_bmcs003.Active then
           qry_bmcs003.Close;
        qry_bmcs003.SQL.Clear;
        qry_bmcs003.SQL.Add('SELECT DISTINCT MCG_DATE FROM GWS::MCG_FILE ORDER BY MCG_DATE');
        qry_bmcs003.Open;
        // 用預計需求日期來產生動態交叉表之欄位
        qry_bmcs003.DisableControls;
        try
          qry_bmcs003.First;
          while not qry_bmcs003.Eof do begin
            lsql:=lSql+'SUM(CASE MCG_DATE WHEN '''+qry_bmcs003.Fields[0].AsString+''' THEN MCG_BALQ*B.IMA63_FAC END) AS D'+qry_bmcs003.Fields[0].AsString+Delimiter;
            qry_bmcs003.Next;
          end;
        finally
          qry_bmcs003.EnableControls;
        end;

        // 產生排程之預計缺料分析報告
          if qry_bmcs003.Active then
             qry_bmcs003.Close;
          qry_bmcs003.SQL.Clear;
          qry_bmcs003.SQL.Add(Format(
                  'SELECT A.MCG_PART AS 材料料號,                               '+
                  '       B.IMA02 AS 品名描述,                                  '+
                  '       B.IMA43 AS 採購員,                                    '+
                  '       B.IMA54 AS 預定廠商,                                  '+ 
                  '       A.MCG_STKN AS 庫別,                                   '+
                  '       %S                                                    '+
                  '       SUM(A.MCG_BALQ*B.IMA63_FAC) AS 缺料合計,              '+


                  '       NVL((SELECT SUM(IMG10)                                    '+
                  '          FROM DS2::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.MCG_PART  AND A.MCG_STKN=''A01''    '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''01''),0)+                               '+
                  '       NVL((SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.MCG_PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''A02''),0)+                              '+

                  '       NVL((SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.MCG_PART                            '+
                  '          AND B.IMG23=''Y''  AND A.MCG_STKN=''01''           '+
                  '          AND B.IMG02 =''A01''),0) AS 庫存,                     '+

                  '       NVL((SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                '+
                  '          FROM DS2::RVB_FILE, DS2::RVA_FILE, DS2::PMN_FILE   '+
                  '         WHERE RVB01=RVA01                                   '+
                  '           AND A.MCG_PART=''A01''                            '+
                  '           AND RVB04 = PMN01                                 '+
                  '           AND RVB03 = PMN02                                 '+
                  '           AND RVB07 > (RVB29+RVB30)),0)+                       '+

                  '       NVL((SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                '+
                  '          FROM DS3::RVB_FILE, DS3::RVA_FILE, DS3::PMN_FILE   '+
                  '         WHERE RVB01=RVA01                                   '+
                  '           AND A.MCG_PART=''01''                             '+
                  '           AND RVB04 = PMN01                                 '+
                  '           AND RVB03 = PMN02                                 '+
                  '           AND RVB07 > (RVB29+RVB30)),0) AS 待檢,               '+
                  
                  '       NVL((SELECT SUM(IMG10)                                    '+
                  '          FROM DS2::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.MCG_PART                            '+
                  '          AND B.IMG23=''Y'' AND A.MCG_STKN=''A01''           '+
                  '          AND B.IMG02=''BVI''),0) +                             '+

                  '       NVL((SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.MCG_PART  AND A.MCG_STKN=''01''     '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''BVI''),0) AS 在途                       '+

                  '  FROM GWS::MCG_FILE A , IMA_FILE B                               '+
                  ' WHERE A.MCG_PART=B.IMA01  AND A.MCG_VERS=''%S''             '+
                  '   AND B.IMA08=''%S''                                        '+
                  ' GROUP BY A.MCG_PART,B.IMA08,A.MCG_STKN,B.IMA02,B.IMA54,B.IMA43  '+
                  ' ORDER BY A.MCG_PART,A.MCG_STKN',[lSql,WIVersion,WIMPart]));


          qry_bmcs003.Open;
          //ds_bmcs003.DataSet:=qry_bmcs003;
          WhatIfVer:=txtVersion.Text;
      end else begin
        Application.MessageBox(PChar(Format('What''if  版本 %S 不存在.',[WIVersion])),PChar(gIfmCaption),MB_ICONEXCLAMATION+MB_OK);
      end;
end;

procedure TfrmBmcs003.tbRunClick(Sender: TObject);
begin
  if qry_bmcs003.Active then
     qry_bmcs003.Close;
   GetWhatIf_Bmcs003(txtVersion.Text,txtMPart.Text);
end;

procedure TfrmBmcs003.tbExportClick(Sender: TObject);
begin
  ShowExportOpen(qry_bmcs003,'bmcs003_'+txtVersion.Text,'bmcs003 - 模擬缺料查詢作業');
end;

procedure TfrmBmcs003.FormShow(Sender: TObject);
begin
  SetFormShow(Self);
  txtVersion.Text:=FormatDateTime('yyyymm',Date);
end;

procedure TfrmBmcs003.ToolButton2Click(Sender: TObject);
begin
    if ShowFilterDialog(qry_bmcs003,dbgrid.GetActiveCol-1) then begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
end;

procedure TfrmBmcs003.tbRemoveClick(Sender: TObject);
begin
  if qry_bmcs003.Filtered then
  begin
     qry_bmcs003.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmBmcs003.txtMPartKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
     tbRunClick(Sender);
end;

procedure TfrmBmcs003.FormResize(Sender: TObject);
begin
  DBGrid.RedrawGrid;
end;

procedure TfrmBmcs003.Button1Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq102') then
         GetBalQty_Aimq102(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button2Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq404') then
         GetStockQty_Aimq404(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button3Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
    //   if ChkUserEx('asmq202') then
         GetTransLog_asmq202(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button4Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
       GetMfgPart_bbmq101(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button5Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetEcnQty_Abmi720(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button6Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq131') then
         GetOrderQty_Aimq131(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button7Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWaitFqcQ_Bpcs002(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button8Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWeWipQty_Bpcs001(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button9Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq136') then
         GetWoWipQty_Aimq136(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button10Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
    //   if ChkUserEx('aimq138') then
         GetWorksQty_Aimq138A(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button11Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq137') then
         GetWaitIqcQ_Aimq137(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button12Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
    //   if ChkUserEx('aimq134') then
         GetPuOrdQty_Aimq134(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmBmcs003.Button13Click(Sender: TObject);
begin
  GetWhatIf_Bmcs010(WhatIfVer,
                    DBGrid.Fields[0].asString,
                    DBGrid.Fields[4].asString);
end;

procedure TfrmBmcs003.Button15Click(Sender: TObject);
begin
  GetWhatIf_Bmcs011(WhatIfVer,
                    DBGrid.Fields[0].asString,
                    DBGrid.Fields[4].asString);
end;

procedure TfrmBmcs003.Button16Click(Sender: TObject);
begin
  GetWhatIf_Bmcs012(WhatIfVer,
                    DBGrid.Fields[0].asString,
                    DBGrid.Fields[4].asString);
end;

procedure TfrmBmcs003.ToolButton4Click(Sender: TObject);
begin
  ShowFindDialog(qry_bmcs003,dbgrid.GetActiveCol-1);
end;

end.
