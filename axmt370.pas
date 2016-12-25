unit axmt370;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, StdCtrls, ToolWin, ComCtrls, Db, DBTables,PASDM,
  Menus, ExtCtrls,pasMain, DBGrids, Buttons, ScktComp;

type
  TfrmAxmt370 = class(TForm)
    tbASFT110: TToolBar;
    tbRun: TToolButton;
    QueryChina: TQuery;
    dsGws: TDataSource;
    tbExport: TToolButton;
    tbFind: TToolButton;
    tbFilter: TToolButton;
    tbRemove: TToolButton;
    Panel1: TPanel;
    Button2: TButton;
    Button3: TButton;
    Button6: TButton;
    Button9: TButton;
    Panel2: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
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
    Button17: TButton;
    Startdate: TDateTimePicker;
    EndDate: TDateTimePicker;
    cbsel: TCheckBox;
    cbTrans: TCheckBox;
    Button4: TButton;
    Timer1: TTimer;
    Button5: TButton;
    Button7: TButton;
    Button8: TButton;
    PMFind: TPopupMenu;
    N1: TMenuItem;
    Button10: TButton;
    Button11: TButton;
    BitBtn1: TBitBtn;
    Copy1: TMenuItem;
    N2: TMenuItem;
    Button12: TButton;
    cbDo: TCheckBox;
    ToolButton10: TToolButton;
    PMReport: TPopupMenu;
    N3: TMenuItem;
    N11: TMenuItem;
    N3GWTGWS1: TMenuItem;
    N4GWTGWH1: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N4: TMenuItem;
    Button13: TButton;
    Button15: TButton;
    Button16: TButton;
    Button18: TButton;
    Button19: TButton;
    QueryGwt: TQuery;
    dsGwt: TDataSource;
    txtMode: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid: TwwDBGrid;
    DBGridGWt: TwwDBGrid;
    ClientSocket: TClientSocket;
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
    procedure aimq1361Click(Sender: TObject);
    procedure asmq2021Click(Sender: TObject);
    procedure Aimq1021Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbselClick(Sender: TObject);
    procedure cbTransClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure PMFindPopup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGridDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure Button12Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure cbDoClick(Sender: TObject);
    procedure QueryChinaCalcFields(DataSet: TDataSet);
    procedure DBGridCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Inqconfirm;
    procedure Button19Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    QueryChinaRec:Integer;
  end;

var
  frmAxmt370: TfrmAxmt370;
  selyn,TransYn:string;

implementation
uses pasCodeProc,pasSysRes,sysdb,Com001,Com002,JclStrings,pasGetDate,pasGetWOSDWhere,asfcode,pasSysQryResultEx,bpcs003;
{$R *.DFM}

procedure TfrmAxmt370.Inqconfirm;
var
  lSql,inqNo,dbName,dbNameS :String;
  strTime:String[5];
begin
      inqNo:= DBGrid.Fields[3].AsString;
      dbNameS:=DBGrid.Fields[0].AsString;
      if dbNameS='GWS' then dbName:='DS2::';
      if dbNameS='GWH' then dbName:='DS7::';
      if dbNameS='GWT' then dbName:='DS5::';
      if   dbNameS<>'GWT' then  begin
      if GetRecordCount(Format('SELECT COUNT(*) FROM %SOQT_FILE WHERE OQT01=''%S'' AND OQTCONF=''N''',[dbName,InqNo]))>0 then begin
        if  GetRecordCount(Format('SELECT COUNT(*) FROM %SOQU_FILE WHERE OQU01=''%S'' AND OQU14C IS NULL',[dbName,InqNo]))>0 then begin
           Application.MessageBox(Pchar((Format('%S , %S-%S 有項次未回交期！',[username,dbNameS,inqNo ]))),'提示',MB_ICONINFORMATION+MB_OK);
         end else begin
           Case Application.MessageBox(PChar(Format('%s ,你要確認 %S ?',[username,inqNo])),'確認',MB_ICONQUESTION+MB_YESNO)  of
             ID_NO:Abort;
             ID_YES:begin
               strTime:=FormatDateTime('hh:nn',now());
               lSql:='UPDATE %SOQT_FILE SET OQTCONF=''Y'',OQT26D=TODAY,OQT27=''%S'',OQTMODU=''%S'' WHERE OQT01=''%S'' AND OQTCONF=''N''';
               ExecSqlA(Format(lsql,[dbName,strTime,UserID,inqNo]));
              end;
           end;
         end;
      end else begin
           Application.MessageBox(Pchar((Format('%s ,詢問單 %s  已確認,不能修改！',[username,inqNo ]))),'提示',MB_ICONINFORMATION+MB_OK);
      end;
      end else begin
        Application.MessageBox(Pchar((Format('%s ,你不能確認 %s 詢問單 %s！',[username,dbNameS,inqNo ]))),'提示',MB_ICONINFORMATION+MB_OK);
      end;

end;


procedure TfrmAxmt370.tbRunClick(Sender: TObject);
var
  lSqlChina,lSqlGwt,startd,endd,datestr,strmode,strPer:String;
begin
 datestr:='%m-%d';
 strPer:='%';
 strmode:=txtMode.Text;
 if strmode='' then strMode:='%';

    startd:=datetostr(Startdate.Date);
    endd:= datetostr(enddate.Date);

    lSqlChina:='SELECT ''GWS'' AS 廠別,      '+
                ' OQT26D   AS 確認日,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS 逾期,          '+
                ' OQT01 AS 詢問單,      '+
                ' C.OQU02 AS 項次,      '+
                ' OCC02 AS 客戶名稱,    '+
                '(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQT07) AS 姓名,   '+
                ' C.OQU03 AS 料號,      '+
                ' C.OQU031 AS 品名,     '+

                ' C.OQU06 AS 數量,      '+
                ' C.OQU14D AS 需求,     '+
                ' C.OQU14C AS 回覆,     '+

                ' C.OQU16 AS 備註,      '+
                ' CASE WHEN C.OQU16 IS NOT NULL THEN     '+
                '    CASE WHEN C.OQU14 =''N'' THEN        '+
                '        (SELECT CASE WHEN A.OQTCONF=''Y'' THEN ''GWT INQ->Y'' '+
                '                     WHEN A.OQTCONF=''N'' THEN ''GWT INQ->N'' '+
                '                     WHEN A.OQTCONF=''X'' THEN ''GWT INQ->X'' END ||'' SO->''||B.OQU14||'' ANS->''||SUBSTR(TO_CHAR(B.OQU14C,''%S''),1,10) '+
                '           FROM DS5::OQT_FILE A ,DS5::OQU_FILE B '+
                '          WHERE A.OQT01=B.OQU01 AND A.OQT01=C.OQU16[1,10] AND C.OQU16[12,14]=B.OQU02 AND B.OQU03=C.OQU03) '+
                '    ELSE   '+
                '      CASE WHEN (SELECT COUNT(*)                         '+
                '                   FROM DS5::OEB_FILE , DS5::OEA_FILE    '+
                '                  WHERE OEB01 = OEA01  AND OEA12 =C.OQU16[1,10]        '+
                '                    AND OEA00<>''0''   AND OEB71=C.OQU16[12,14]        '+
                '                    AND OEA25=''CX1''                      '+
                '                    AND OEB04=C.OQU03)>0 THEN '+

                '        (SELECT OEA01||''/''||CASE WHEN OEA10 IS NOT NULL THEN OEA10[1,9] ELSE ''NULL'' END ||''/''|| SUBSTR(TO_CHAR(OEB15,''%s''),1,10) ||''/''||OEB70 '+

                '           FROM DS5::OEB_FILE , DS5::OEA_FILE    '+
                '          WHERE OEB01 = OEA01  AND OEA12 =C.OQU16[1,10]        '+
                '            AND OEA00<>''0''   AND OEB71=C.OQU16[12,14]        '+
                '            AND OEA25=''CX1''                      '+
                '            AND OEB04=C.OQU03) '+
                '       ELSE                    '+
                '        (SELECT CASE WHEN A.OQTCONF=''Y'' THEN ''GWT INQ->Y'' '+
                '                     WHEN A.OQTCONF=''N'' THEN ''GWT INQ->N'' '+
                '                     WHEN A.OQTCONF=''X'' THEN ''GWT INQ->X'' END ||'' 轉銷售單->''||B.OQU14 '+
                '           FROM DS5::OQT_FILE A ,DS5::OQU_FILE B '+
                '        WHERE A.OQT01=B.OQU01 AND (A.OQT01=C.OQU16[1,10] AND C.OQU16[12,14]=B.OQU02 AND B.OQU03=C.OQU03)) '+
                '       END  '+ 
                '    END  '+
                '  END AS 參考信息,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS 開單,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTMODU) AS 修改'+
                ' FROM DS2::OQT_FILE,DS2::OQU_FILE C,DS2::OCC_FILE   '+
                'WHERE OQT01=OQU01  AND OCC01=OQT04                  '+
                '  AND OQTCONF =''%S''                        '+
                //'  AND OQT07!=''H091''                        '+
                '  AND OQU14=''%S''  AND C.OQU03 LIKE ''%S%S'''+
                '  AND OQT02 BETWEEN ''%S'' AND  ''%S''       '+
                'UNION ALL                                    '+
                '                                        '+
                'SELECT ''GWH'',                         '+

                ' OQT26D   AS 失效,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS 逾期,          '+
               ' OQT01 AS 詢問單,                        '+
               ' C.OQU02 AS 項次,        '+
               ' OCC02 AS 客戶名稱,                      '+
               ' (SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQT07),   '+
               ' C.OQU03 AS 料號,                            '+
               ' C.OQU031 AS 品名,                           '+

               ' C.OQU06 AS 數量,                            '+
               ' C.OQU14D AS 需求,                           '+
               ' C.OQU14C AS 回覆,                           '+

               ' C.OQU16 AS 備註,  '+
                ' CASE WHEN C.OQU16 IS NOT NULL THEN     '+
                '    CASE WHEN C.OQU14 =''N'' THEN        '+
                '        (SELECT CASE WHEN A.OQTCONF=''Y'' THEN ''GWT INQ->Y'' '+
                '                     WHEN A.OQTCONF=''N'' THEN ''GWT INQ->N'' '+
                '                     WHEN A.OQTCONF=''X'' THEN ''GWT INQ->X'' END ||'' SO->''||B.OQU14||'' ANS->''||SUBSTR(TO_CHAR(B.OQU14C,''%S''),1,10) '+
                '           FROM DS5::OQT_FILE A ,DS5::OQU_FILE B '+
                '          WHERE A.OQT01=B.OQU01 AND A.OQT01=C.OQU16[1,10] AND C.OQU16[12,14]=B.OQU02 AND B.OQU03=C.OQU03) '+
                '    ELSE   '+
                '      CASE WHEN (SELECT COUNT(*)                         '+
                '                   FROM DS5::OEB_FILE , DS5::OEA_FILE    '+
                '                  WHERE OEB01 = OEA01  AND OEA12 =C.OQU16[1,10]        '+
                '                    AND OEA00<>''0''   AND OEB71=C.OQU16[12,14]        '+
                '                    AND OEA25=''CX1''                      '+
                '                    AND OEB04=C.OQU03)>0 THEN '+

                '        (SELECT  OEA01||''/''||CASE WHEN OEA10 IS NOT NULL THEN OEA10[1,9] ELSE ''NULL'' END ||''/''|| SUBSTR(TO_CHAR(OEB15,''%s''),1,10) ||'' ''||OEB70 '+

                '           FROM DS5::OEB_FILE , DS5::OEA_FILE    '+
                '          WHERE OEB01 = OEA01  AND OEA12 =C.OQU16[1,10]        '+
                '            AND OEA00<>''0''   AND OEB71=C.OQU16[12,14]        '+
                '            AND OEA25=''CX1''                      '+
                '            AND OEB04=C.OQU03) '+
                '       ELSE                    '+
                '        (SELECT CASE WHEN A.OQTCONF=''Y'' THEN ''GWT INQ->Y'' '+
                '                     WHEN A.OQTCONF=''N'' THEN ''GWT INQ->N'' '+
                '                     WHEN A.OQTCONF=''X'' THEN ''GWT INQ->X'' END ||'' 轉銷售單->''||B.OQU14 '+
                '           FROM DS5::OQT_FILE A ,DS5::OQU_FILE B '+
                '        WHERE A.OQT01=B.OQU01 AND (A.OQT01=C.OQU16[1,10] AND C.OQU16[12,14]=B.OQU02 AND B.OQU03=C.OQU03)) '+
                '       END  '+ 
                '    END  '+
                '  END AS 參考信息,(SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQTUSER) AS 開單,(SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQTMODU) AS 修改'+
               ' FROM DS7::OQT_FILE,DS7::OQU_FILE C,DS7::OCC_FILE   '+
               ' WHERE OQT01=OQU01  AND OCC01=OQT04                 '+
               ' AND OQTCONF =''%S''                                '+
              // ' AND OQT07!=''H091''                                '+
               '  AND OQU14=''%S''   AND C.OQU03 LIKE ''%S%S''      '+
               ' AND OQT02 BETWEEN ''%S'' AND ''%S''                '+
               ' order by 1,4 desc,5';

    lSqlGwt:= ' SELECT ''GWT'' AS 廠別,                                    '+

                ' D.OQT26D   AS 失效,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (D.OQT26D+(SELECT 7+COUNT(*) FROM DS5::SME_FILE WHERE SME01 BETWEEN D.OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (D.OQT26D+(SELECT 7+COUNT(*) FROM DS5::SME_FILE WHERE SME01 BETWEEN D.OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS 逾期,          '+
               ' D.OQT01 AS 詢問單,                                 '+
               ' C.OQU02 AS 項次,                                   '+
               ' OCC02 AS 客戶名稱,                                 '+
               ' (SELECT GEN02 FROM DS5::GEN_FILE WHERE GEN01=D.OQT07) AS 姓名, '+
               ' C.OQU03 AS 料號,                                       '+
               ' C.OQU031 AS 品名,                                      '+

               ' C.OQU06 AS 數量,                                       '+
               ' C.OQU14D AS 需求,                                      '+
               ' C.OQU14C AS 回覆,                                      '+

               ' C.OQU16 AS 備註,                     '+

               ' (CASE WHEN D.OQT23 IS NOT NULL  THEN                                                               '+
               '          ( CASE WHEN   (SELECT COUNT(*)                                                             '+
               '                 FROM DS5::OEA_FILE,DS5::OEB_FILE                                                   '+
               '                WHERE OEA01=OEB01  AND OEA12=D.OQT01  AND OEB04=C.OQU03 AND OEB71=C.OQU02) >1 THEN  '+

               '           ''DOUBLE'''+
               '           ELSE                                                                                     '+
               '                (SELECT OEA01||''->''||OEACONF||''->''||OEA10[1,9]                                 '+
               '                 FROM DS5::OEA_FILE,DS5::OEB_FILE                                                   '+
               '                WHERE OEA01=OEB01  AND OEA12=D.OQT01  AND OEB04=C.OQU03 AND OEB71=C.OQU02)          '+
               '           END)                                                                                      '+
               '   END)      AS 參考信息, '+
               '          (SELECT GEN02 FROM DS5::GEN_FILE WHERE GEN01=OQTUSER) AS 開單,(SELECT GEN02 FROM DS5::GEN_FILE WHERE GEN01=OQTMODU) AS 修改 '+

               ' FROM DS5::OQT_FILE D,DS5::OQU_FILE C,DS5::OCC_FILE      '+
               ' WHERE D.OQT01=C.OQU01  AND OCC01=D.OQT04                '+
               ' AND D.OQTCONF=''%S''                                    '+
               ' AND D.OQT04=''XATWXGU0''                                '+
               ' AND OQU14=''%S''   AND C.OQU03 LIKE ''%S%S''            '+
               ' AND D.OQT02 BETWEEN ''%S'' AND ''%S'''+
               ' order by 1,4 desc,5';

    case PageControl1.ActivePageIndex of
      0:begin
          if QueryChina.Active then QueryChina.Close;
          QueryChina.SQL.Clear;
          QueryChina.SQL.Add(format(lSqlChina,[datestr,datestr,selyn,TransYN,strMode,strPer,startd,endd,
                         datestr,datestr,selyn,TransYN,strMode,strPer,startd,endd]));
          QueryChina.Open;
          if QueryChina.Filtered then  begin
            QueryChina.Filtered:=False;
            tbRemove.Enabled:=False;
          end;
          DBGrid.Fields[2].DisplayWidth:=4;
          DBGrid.Fields[4].DisplayWidth:=4;
          DBGrid.Fields[6].DisplayWidth:=6;
          DBGrid.Fields[7].DisplayWidth:=13;
          DBGrid.Fields[8].DisplayWidth:=15;
          DBGrid.Fields[9].DisplayWidth:=4;
          DBGrid.Fields[10].DisplayWidth:=10;
          DBGrid.Fields[11].DisplayWidth:=10;
          DBGrid.Fields[12].DisplayWidth:=14;
          DBGrid.Fields[13].DisplayWidth:=28;
          DBGrid.Fields[14].DisplayWidth:=6;
        end;
     1:begin
         if QueryGwt.Active then QueryGwt.Close;
         QueryGwt.SQL.Clear;
         QueryGwt.SQL.Add(format(lSqlGWt,[selyn,TransYN,strMode,strPer,startd,endd]));
         QueryGwt.Open;
         if QueryGwt.Filtered then  begin
            QueryGwt.Filtered:=False;
            tbRemove.Enabled:=False;
          end;
          DBGridGWt.Fields[2].DisplayWidth:=4;
          DBGridGWt.Fields[4].DisplayWidth:=4;
          DBGridGWt.Fields[6].DisplayWidth:=6;
          DBGridGWt.Fields[7].DisplayWidth:=13;
          DBGridGWt.Fields[8].DisplayWidth:=15;
          DBGridGWt.Fields[9].DisplayWidth:=4;
          DBGridgwt.Fields[10].DisplayWidth:=10;
          DBGridgwt.Fields[11].DisplayWidth:=10;
          DBGridgwt.Fields[12].DisplayWidth:=14;
          DBGridgwt.Fields[13].DisplayWidth:=28;
          DBGridGWt.Fields[14].DisplayWidth:=6;
       end;
     end;
end;

procedure TfrmAxmt370.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if QueryChina.Active then
     QueryChina.Close;
  if QueryChina.Prepared then
     QueryChina.UnPrepare;

  ClientSocket.Close;

  Action:=caFree;
end;

procedure TfrmAxmt370.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAxmt370.txtPartnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    tbRunClick(Sender);
end;

procedure TfrmAxmt370.tbExportClick(Sender: TObject);
begin
  case Pagecontrol1.ActivePageIndex of
    0:ShowExportOpen(QueryChina,'axmt370','axmt370 - 詢問單查詢');
    1:ShowExportOpen(QueryGWT,'axmt370','axmt370 - GWT詢問單查詢');
  end;
end;

procedure TfrmAxmt370.tbFindClick(Sender: TObject);
begin
  ShowFindDialog(QueryChina,dbgrid.GetActiveCol-1);
end;

procedure TfrmAxmt370.tbFilterClick(Sender: TObject);
begin
  try
    if ShowFilterDialog(QueryChina,dbgrid.GetActiveCol-1) then begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
  except
    on e:exception do
    Application.MessageBox(PChar(e.Message),PChar(gErrCaption),MB_ICONERROR+MB_OK);
  end;
end;

procedure TfrmAxmt370.tbRemoveClick(Sender: TObject);
begin
  if QueryChina.Filtered then
  begin
     QueryChina.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmAxmt370.aimq404Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq404') then
       case Pagecontrol1.ActivePageIndex  of
         0:GetStockQty_Aimq404(DBGrid.Fields[7].AsString);
         1:GetStockQty_Aimq404(DBGridgwt.Fields[7].AsString);
       end;
    end;
  end;
end;

procedure TfrmAxmt370.aimq1311Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq131') then
       case Pagecontrol1.ActivePageIndex of
         0:GetOrderQty_Aimq131(DBGrid.Fields[7].AsString);
         1:GetOrderQty_Aimq131(DBGridGWT.Fields[7].AsString);
       end;
    end;
  end;
end;

procedure TfrmAxmt370.aimq1361Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq136') then
       case Pagecontrol1.ActivePageIndex of
         0:GetWoWipQty_Aimq136(DBGrid.Fields[7].AsString);
         1:GetWoWipQty_Aimq136(DBGridGWT.Fields[7].AsString);
       end;
    end;
  end;
end;

procedure TfrmAxmt370.asmq2021Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('asmq202') then
       case Pagecontrol1.ActivePageIndex of
         0:GetTransLog_asmq202(DBGrid.Fields[7].AsString);
         1:GetTransLog_asmq202(DBGridGWT.Fields[7].AsString);
       end;  

    end;
  end;
end;

procedure TfrmAxmt370.Aimq1021Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq102') then
        case Pagecontrol1.ActivePageIndex of
         0:GetBalQty_Aimq102(DBGrid.Fields[7].AsString);
         1:GetBalQty_Aimq102(DBGridGWT.Fields[7].AsString);
        end; 
    end;
  end;
end;

procedure TfrmAxmt370.Button14Click(Sender: TObject);
var
  ym:string;
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     // if ChkUserEx('aimq102') then 
     // ym:=FormatDatetime('yyyy',date);
      if GetQueryWhere('進出存查詢','請輸入年份（YYYY）',ym,true) then begin
        case Pagecontrol1.ActivePageIndex of
         0:GetPartTrans_Aimq102(DBGrid.Fields[7].AsString,ym);
         1:GetPartTrans_Aimq102(DBGridGWT.Fields[7].AsString,ym);
        end;
      end;
    end;
  end;
end;

procedure TfrmAxmt370.Button17Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
       case Pagecontrol1.ActivePageIndex  of
         0:GetModeSD(DBGrid.Fields[7].AsString);
         1:GetModeSD(DBGridGWT.Fields[7].AsString);
       end;
  end;
 end;
end;

procedure TfrmAxmt370.FormCreate(Sender: TObject);
begin

  startdate.Date:=now-5;
  enddate.Date:=now;
  selyn:='N';
  if cbTrans.Checked then
    TransYN:='Y'
  else
    TransYN:='N';

  with ClientSocket do
  begin
    Host := '172.16.131.68';
    Active := True;
  end;


end;

procedure TfrmAxmt370.cbselClick(Sender: TObject);
begin
  if cbsel.Checked then  begin
    cbsel.Caption :='已確認';
    selyn:='Y';
  end else begin
    cbsel.Caption:='未確認';
    selyn:='N';
    cbTrans.Checked:=False;
  end;
end;

procedure TfrmAxmt370.cbTransClick(Sender: TObject);
begin
   if cbTrans.Checked then begin
    cbTrans.Caption :='已轉單';
    cbsel.Checked:=True;
    TransYN:='Y';

   end else begin
    cbTrans.Caption:='未轉單';
    TransYN:='N';

   end;
end;

procedure TfrmAxmt370.Button4Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      try
        GetGwtInqueryMode(DBGrid.Fields[12].AsString,DBGrid.Fields[7].AsString);

      except
         on e:EDBEngineError do
           ErrMessage(e.Errors[1].NativeError);
      end;
    end;

  end;

end;

procedure TfrmAxmt370.Button5Click(Sender: TObject);
var
  lSql,InqNum:String;
begin
  if GetQueryWhere('詢問單查詢','請輸入詢問單',InqNum,false) then begin
  if InqNum<>'' then begin
     if QueryChina.active then QueryChina.close;
       QueryChina.sQL.Clear;


    lSql:='SELECT ''GWS'' AS 廠別,              '+
                ' OQT26D   AS 確認日,           '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS 逾期,         '+
                ' OQT01 AS 詢問單,              '+
                ' C.OQU02 AS 項次,              '+
                ' OCC02 AS 客戶名稱,            '+
                ' (SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQT07) AS 姓名,   '+
                ' C.OQU03 AS 料號,              '+
                ' C.OQU031 AS 品名,             '+
                ' C.OQU06 AS 數量,              '+
                ' C.OQU14D AS 需求,             '+
                ' C.OQU14C AS 回覆,             '+
                ' C.OQU16 AS 備註,''轉單: ''||OQU14||'' 此單: ''||OQTCONF AS 狀態,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS 開單     '+
          ' FROM DS2::OQT_FILE,DS2::OQU_FILE C,DS2::OCC_FILE   '+
          'WHERE OQT01=C.OQU01  AND OCC01=OQT04 '+
          '  AND OQT07!=''H091''                '+
          '  AND OQT01=''%S''                   '+

          'UNION ALL                            '+
          '                                     '+
         'SELECT ''GWH'',                       '+

                ' OQT26D   AS 確認日,           '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS 逾期,         '+
                ' OQT01 AS 詢問單,              '+
                ' C.OQU02 AS 項次,              '+
                ' OCC02 AS 客戶名稱,            '+
                ' (SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQT07) AS 姓名,   '+
                ' C.OQU03 AS 料號,              '+
                ' C.OQU031 AS 品名,             '+
                ' C.OQU06 AS 數量,              '+
                ' C.OQU14D AS 需求,             '+
                ' C.OQU14C AS 回覆,             '+
                ' C.OQU16 AS 備註 ,''轉單: ''||OQU14||'' 此單: ''||OQTCONF AS 狀態  ,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS 開單         '+
               ' FROM DS7::OQT_FILE,DS7::OQU_FILE C,DS7::OCC_FILE   '+
               ' WHERE OQT01=C.OQU01  AND OCC01=OQT04               '+
               ' AND OQT07!=''H091''                                '+
               ' AND OQT01 =''%S''                                  '+
               '                                                    '+
               '                                                    '+
               ' UNION ALL                                          '+
               '                                                    '+
               ' SELECT ''GWT'',                                    '+
                ' OQT26D   AS 確認日,          '+
                ' CASE WHEN OQU14!=''Y'' THEN  '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS5::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS5::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS 逾期,        '+
                ' OQT01 AS 詢問單,             '+
                ' OQU02 AS 項次,               '+
                ' OCC02 AS 客戶名稱,           '+
                ' (SELECT GEN02 FROM DS5::GEN_FILE WHERE GEN01=OQT07) AS 姓名,   '+
                ' OQU03 AS 料號,               '+

                ' OQU031 AS 品名,              '+
                ' OQU06 AS 數量,               '+
                ' OQU14D AS 需求,              '+
                ' OQU14C AS 回覆,              '+
                ' OQU16 AS 備註 ,''轉單: ''||OQU14||'' 此單: ''||OQTCONF AS 狀態   ,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS 開單       '+
               ' FROM DS5::OQT_FILE,DS5::OQU_FILE ,DS5::OCC_FILE      '+
               ' WHERE OQT01=OQU01  AND OCC01=OQT04                   '+
               ' AND OQT04=''XATWXGU0''                               '+
               ' AND OQT01=''%S''                                     '+
               ' ORDER BY  1,2,OQT01,OQU02';



      QueryChina.SQL.Add(format(lSql,[InqNum,InqNum,InqNum]));
      try
        QueryChina.Open;
        DBGrid.Fields[2].DisplayWidth:=4;
        DBGrid.Fields[4].DisplayWidth:=4;
        DBGrid.Fields[7].DisplayWidth:=14;
        DBGrid.Fields[9].DisplayWidth:=4;
        if QueryChina.Filtered then  begin
          QueryChina.Filtered:=False;
          tbRemove.Enabled:=False;
        end;

      except
         on e:EDBEngineError do
         if e.Errors[1].NativeError=-244 then
             Application.MessageBox(Pchar((Format('%s , 有人在修改詢問單，休息會兒再回來！',[Username]))),'提示',MB_ICONINFORMATION+MB_OK);
      end;
    end;
  end;
end;


procedure TfrmAxmt370.Button7Click(Sender: TObject);
var
  lSql,Iqno,dbName,dbNameS,Iqnoa,itmNo,modeno:String;
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     dbNameS:=DBGrid.Fields[0].AsString;
     if dbNameS='GWS' then dbName:='DS2::';
     if dbNameS='GWH' then dbName:='DS7::';
     if dbNameS='GWT' then dbName:='DS5::';
     if dbNameS<>'GWT' then begin
       if GetQueryWhere(Format('%s :補登 %s 詢問單 %s  對應GWT 詢問單',[username,DBGrid.Fields[0].AsString,DBGrid.Fields[3].AsString]) ,'請輸入GWT 詢問單號',Iqno,false) then begin
       Iqnoa:= strLeft(Iqno,10);
       itmNo:= strRight(Iqno,StrLength(Iqno)-11);
       modeno:=DBGrid.Fields[7].AsString;
         if Iqno<>'' then begin
           lSql:='SELECT COUNT(*) FROM DS5::OQT_FILE,DS5::OQU_FILE  WHERE OQT01=OQU01 AND OQT04=''XATWXGU0'' AND OQT01=''%S'' AND OQU02=''%S'' AND OQU03=''%S''';
           if GetRecordCount(Format(lsql,[Iqnoa,itmNo,ModeNo])) >0 then begin
             lSql:='UPDATE %SOQU_FILE SET OQU16=''%S'' WHERE OQU01=''%S'' AND OQU02=''%S''';
             ExecSqlA(Format(lsql,[dbName,Iqno,DBGrid.Fields[3].AsString,DBGrid.Fields[4].AsString]));

           end else begin
             Application.MessageBox(Pchar((Format('%s , GWT詢問單 %s 不存在',[username,Iqno]))),'提示',MB_ICONINFORMATION+MB_OK);
           end;
          end;
        end;
      end else begin
          Application.MessageBox(Pchar((Format('%S , %S 詢問單備註資料請直接在TIPTOP修改！',[Username,dbNameS]))),'提示',MB_ICONINFORMATION+MB_OK);
      end; 
   end;
 end;
end;

procedure TfrmAxmt370.Button8Click(Sender: TObject);
begin
  if QueryChina.Active then begin
    if QueryChina.RecordCount>0 then begin

      GetModeSDGWT(DBGrid.Fields[7].AsString);
   end;
  end;
end;

procedure TfrmAxmt370.PMFindPopup(Sender: TObject);
begin

  PMFind.Items[0].Caption:='過濾 [ '+dbgrid.GetFieldValue(dbgrid.GetActiveCol-1)+' ]';
end;

procedure TfrmAxmt370.N1Click(Sender: TObject);
var
  FilterValue:string;
begin
  if tbRemove.Enabled=False then tbRemove.Enabled:=True;
  FilterValue:='['+dbgrid.GetActiveField.FieldName+']='+''''+dbgrid.GetActiveField.AsString+'''';
  QueryChina.Filter:= FilterValue;
  QueryChina.Filtered:=True;
end;

procedure TfrmAxmt370.Button10Click(Sender: TObject);
var
  lSql,inqNo,AnswerDate,dbName,dbNameS,itemsNo,ModeNo:String;
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin

      ModeNo:= DBGrid.Fields[7].AsString;
      inqNo:= DBGrid.Fields[3].AsString;
      itemsNo:=  DBGrid.Fields[4].AsString;
      dbNameS:=DBGrid.Fields[0].AsString;
      if dbNameS='GWS' then dbName:='DS2::';
      if dbNameS='GWH' then dbName:='DS7::';
      if dbNameS='GWT' then dbName:='DS5::';
      if dbNameS<>'GWT' then begin
      if GetRecordCount(Format('SELECT COUNT(*) FROM %SOQT_FILE,%SOQU_FILE WHERE OQT01=OQU01 AND OQT01=''%S'' AND OQU02=''%S'' AND OQTCONF=''N''',[dbName,dbName,inqNo,itemsNo]))>0 then begin
         if GetQueryWhereDate(Format('%s 詢問單 %s - %S 交期回覆',[dbNameS,inqNo,ModeNo]) ,'選擇日期',AnswerDate) then begin
           if AnswerDate<>'' then begin
             if AnswerDate >= FormatDatetime('yyyymmdd',now) then begin
               lSql:='UPDATE %SOQU_FILE SET OQU14C=''%S'' WHERE OQU01=''%S'' AND OQU02=''%S'' ';
               try
                 ExecSQLA(Format(lsql,[dbName,AnswerDate,inqNo,itemsNo]));
               except
                 on e:EDBEngineError do
                 if e.Errors[1].NativeError=-1218 then  begin
                   Application.MessageBox(Pchar((Format('%s ,你回覆的日期 %S 格式錯誤，請參照 YYYYMMDD 格式.',[Username,AnswerDate]))),'提示',MB_ICONINFORMATION+MB_OK);
                 end else begin
                   Application.MessageBox(Pchar(e.Message),'錯誤',MB_ICONINFORMATION+MB_OK);
                 end;
               end;
             end else begin
               Application.MessageBox(Pchar((Format('%s ,日期 %S 小於 %s ,請回覆大於等於今日的日期！',[Username,AnswerDate,FormatDatetime('yyyymmdd',now)]))),'提示',MB_ICONINFORMATION+MB_OK);
             end;
           end;
         end
      end else begin
        Application.MessageBox(Pchar((Format('%S ,詢問單 %s ->  %S  -> %S 已確認，無法修改日期！',[Username,inqNo,itemsNo ,ModeNo ]))),'提示',MB_ICONINFORMATION+MB_OK);
      end;
      end else begin
        Application.MessageBox(Pchar((Format('%S , %S 詢問單 %s 應由 %S 人員回覆！',[Username,dbNameS,inqNo,dbNameS ]))),'提示',MB_ICONINFORMATION+MB_OK);
      end;
   end;
  end;
end;

procedure TfrmAxmt370.Button11Click(Sender: TObject);
var
  lSql,InqNo,dbNameS,dbName:String;
  InqQty:Integer;
begin
  if ChkUserEx('axmt370') then begin
   if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin

    InqNo:=  DBGrid.Fields[3].AsString;
    InqQty:= DBGrid.Fields[9].AsInteger;
    dbNameS:=DBGrid.Fields[0].AsString;
    if dbNameS='GWS' then dbName:='DS2::';
    if dbNameS='GWH' then dbName:='DS7::';
    if dbNameS='GWT' then dbName:='DS5::';

    lSql:='SELECT COUNT(*)                   '+
         '  FROM GWS::CAT_FILE,GWS::CAS_FILE '+
         ' WHERE CAT01=CAS01                 '+
         '   AND CAT16=''Y''                 '+
         '   AND CAT23=''N''                 '+
         '   AND CAT24=''N''                 '+
         '   AND CAS03 IN ( SELECT OQU03 FROM %SOQU_FILE,%SOQT_FILE WHERE OQU01=OQT01 AND OQTCONF=''N'' AND OQT01=''%S'')               '+
         '   AND CAS08=''N''                 '+
         '   AND CAT15>=TODAY                ';

   if GetRecordCount(Format(lSql,[dbName,dbName,InqNo]))<=0 then begin
       InqConfirm;
   end else begin
     Case Application.MessageBox(PChar(Format('%s ,發現有經銷商報備,去看看？',[username])),'確認',MB_ICONQUESTION+MB_YESNO)  of
      ID_NO:InqConfirm;
      ID_YES:begin
              lSql:=' SELECT CAT01 AS 備案編號,    '+
              '              CAT15 AS 預結案日,    '+
              '              CAT05 AS 經銷商,      '+
              '              CAT061 AS 部門,       '+
              '              CAT071 AS 業務員,     '+
              '              CAS02 AS 項次,        '+
              '              CAS03 AS 料號,        '+
              '              CAS04 AS 備案數,        '+
              '              ''%d'' AS 詢問數,     '+
              '              ''%s'' AS 詢問單號,   '+
              '              CAT02 AS 備案日期,    '+
              '              CAT17 AS 立案日,      '+
              '              CAT12 AS 電子郵件     '+
              '   FROM GWS::CAT_FILE,GWS::CAS_FILE '+
              '  WHERE CAT01=CAS01                 '+
              '    AND CAT16=''Y''                 '+
              '    AND CAT23=''N''                 '+
              '    AND CAT24=''N''                 '+
              '    AND CAS08=''N''                 '+
              '    AND CAS03 IN ( SELECT OQU03 FROM %SOQU_FILE,%SOQT_FILE WHERE OQU01=OQT01 AND OQTCONF=''N'' AND OQT01=''%S'')              '+
              '    AND CAT15>=TODAY                ';
               GetQueryData('經銷商案件報備資料',Format(lSql,[InqQty,InqNo,dbName,dbName,InqNo])); {
               lSql:='SELECT * FROM GWS::CAT_FILE                         '+
                     ' WHERE CAT01 IN (SELECT CAS01                       '+
                     '                   FROM GWS::CAS_FILE,GWS::CAT_FILE '+
                     '  WHERE CAT01=CAS01                 '+
                     '    AND CAT16=''Y''                 '+
                     '    AND CAT23=''N''                 '+
                     '    AND CAT24=''N''                 '+
                     '    AND CAS08=''N''                 '+
                     '    AND CAS03=''%S'')';
               SetBpcs003(Format(lSql,[PartNo])); }
             end;
     end;



   end;
  end;
 end;
 end; 
end;

procedure TfrmAxmt370.BitBtn1Click(Sender: TObject);
var
  lSql,inqNo,dbName,dbNameS,Modeno,itemsNo:String;
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin

     case PageControl1.ActivePageIndex  of
       0: begin
        ModeNo:= DBGrid.Fields[7].AsString;
        inqNo:= DBGrid.Fields[3].AsString;
        itemsNo:=  DBGrid.Fields[4].AsString;
        dbNameS:=DBGrid.Fields[0].AsString;
       end;
       1: begin
        ModeNo:= DBGridGWT.Fields[7].AsString;
        inqNo:= DBGridGWT.Fields[3].AsString;
        itemsNo:=  DBGridGWT.Fields[4].AsString;
        dbNameS:=DBGridGWT.Fields[0].AsString;
       end;
     end;

      if dbNameS='GWS' then dbName:='DS2::';
      if dbNameS='GWH' then dbName:='DS7::';
      if dbNameS='GWT' then dbName:='DS5::';
      if GetRecordCount(Format('SELECT COUNT(*) FROM %SOQT_FILE WHERE OQT01=''%S'' AND OQTCONF=''N''',[dbName,InqNo]))>0 then begin
        Case Application.MessageBox(PChar(Format('%S :你確認要刪除 %S -> %S -> %S -%S ?',[username,dbNameS,InqNo,itemsNo,ModeNo])),'確認',MB_ICONQUESTION+MB_YESNO)  of
            ID_NO:Abort;
            ID_YES:begin
               lSql:='DELETE  %SOQU_FILE WHERE OQU01=''%S'' AND OQU02=''%S'' AND OQU03=''%S''';
               ExecSqlA(Format(lsql,[dbName,inqNo,itemsNo,ModeNo]));

           end;
         end;  
      end else begin
           Application.MessageBox(Pchar((Format('%s :詢問單 %s  已確認，不能刪除！',[username,inqNo ]))),'提示',MB_ICONINFORMATION+MB_OK);
     end;
   end;
  end;
end;

procedure TfrmAxmt370.DBGridDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);

begin
{  Sono:= Query.Fields[12].AsString;
  if  Sono='' then begin
  case Query.Fields[2].AsInteger of
    0..7:abort ;
    8..500:begin
     DBGrid.Canvas.Brush.Color:=clBlue;
     DBGrid.Canvas.Font.Color:=clWhite;
     dbgrid.DefaultDrawDataCell(rect, Field, state);
    end;

  end;
  end; }

end;

procedure TfrmAxmt370.Button12Click(Sender: TObject);
var
  plant:string;
begin
  if DBGridGWT.DataSource.DataSet.Active then begin
    if DBGridGWT.DataSource.DataSet.RecordCount>0 then begin
      plant:=DBGridGWT.Fields[0].AsString;
      if plant='GWT' then
        GetGWSHInqueryMode(DBGridGWT.Fields[3].AsString,DBGridGWT.Fields[4].AsString);
    end;

  end;


end;

procedure TfrmAxmt370.Timer1Timer(Sender: TObject);
var
  mydate:string;
begin
 if cbDO.Checked then begin
    if  cbSel.Checked then cbSel.Checked:=False;
    if  cbTrans.Checked then cbTrans.Checked:=False;
    tbRunClick(Sender);
    mydate:=formatdatetime('hh:mm:ss',now);
    {if QueryChina.RecordCount > 0 then begin
      if QueryChina.RecordCount=1 then begin
        ClientSocket.Socket.SendText(Format('%s : %d Record unconfirm!',[mydate,QueryChina.RecordCount]));
      end else begin
        ClientSocket.Socket.SendText(Format('%s : %d Records unconfirm!',[mydate,QueryChina.RecordCount]));
      end;
    end; } 
 end;
end;

procedure TfrmAxmt370.cbDoClick(Sender: TObject);
begin
  if cbDo.Checked then  begin
    cbDo.Caption :='自動查詢-大陸';
  end else begin
     cbDo.Caption:='手動查詢-大陸';
  end;
end;

procedure TfrmAxmt370.QueryChinaCalcFields(DataSet: TDataSet);
var
  CfmDate:TDate;
begin
  CfmDate:=DataSet.Fields[1].AsDateTime;
  DataSet.Fields[2].AsDateTime:=InqAbleDate(CfmDate);

end;

procedure TfrmAxmt370.DBGridCalcCellColors(Sender: TObject; Field: TField;
  State: TGridDrawState; Highlight: Boolean; AFont: TFont; ABrush: TBrush);
{Var
  clOrange:TColor; }
begin
{  clOrange:= clRed+clGreen;
  with (Sender as TwwDBGrid) do
  if CalcCellRow = GetActiveRow then begin
     ABrush.Color := clOrange;
     AFont.color:= clWhite;
  end; }
end;

procedure TfrmAxmt370.Button13Click(Sender: TObject);
var
  lSql,InqNum:String;
begin
  if GetQueryWhere('詢問單查詢','請輸入銷售單號',InqNum,false) then begin
  if InqNum<>'' then begin
     if QueryChina.active then QueryChina.close;
       QueryChina.sQL.Clear;


    lSql:='SELECT ''GWS'' AS 廠別,   '+

                ' OQT26D   AS 確認日,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS 逾期,          '+
                ' OQT01 AS 詢問單,    '+
                ' C.OQU02 AS 項次,  '+
                ' OCC02 AS 客戶名稱,    '+
                ' (SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQT07) AS 姓名,   '+
                ' C.OQU03 AS 料號,        '+

                ' C.OQU031 AS 品名,       '+
                ' C.OQU06 AS 數量,         '+
                ' C.OQU14D AS 需求,        '+
                ' C.OQU14C AS 回覆,         '+
                ' C.OQU16 AS 備註 ,C.OQU14 轉單狀態  ,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS 開單         '+
          ' FROM DS2::OQT_FILE ,DS2::OQU_FILE C,DS2::OCC_FILE   '+
          'WHERE OQT01=C.OQU01  AND OCC01=OQT04         '+
          '  AND OQT07!=''H091''                        '+
          '  AND OQT23=''%S''                         '+

          'UNION ALL                                   '+
          '                                           '+
         'SELECT ''GWH'',                              '+

                ' OQT26D   AS 確認日,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS 逾期,          '+
                ' OQT01 AS 詢問單,    '+
                ' C.OQU02 AS 項次,  '+
                ' OCC02 AS 客戶名稱,    '+
                ' (SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQT07) AS 姓名,   '+
                ' C.OQU03 AS 料號,        '+

                ' C.OQU031 AS 品名,       '+
                ' C.OQU06 AS 數量,         '+
                ' C.OQU14D AS 需求,        '+
                ' C.OQU14C AS 回覆,         '+
                ' C.OQU16 AS 備註 ,C.OQU14 轉單狀態  ,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS 開單        '+
               ' FROM DS7::OQT_FILE ,DS7::OQU_FILE C,DS7::OCC_FILE   '+
               ' WHERE OQT01=C.OQU01  AND OCC01=OQT04             '+
               ' AND OQT07!=''H091''                             '+
               ' AND OQT23 =''%S''   '+
               ' ORDER BY 3,4';



      QueryChina.SQL.Add(format(lSql,[InqNum,InqNum,InqNum]));
      QueryChina.Open;
      DBGrid.Fields[2].DisplayWidth:=4;
      DBGrid.Fields[4].DisplayWidth:=4;
      DBGrid.Fields[7].DisplayWidth:=14;
      DBGrid.Fields[9].DisplayWidth:=4;
      if QueryChina.Filtered then  begin
        QueryChina.Filtered:=False;
        tbRemove.Enabled:=False;
      end;
    end;
  end;

end;

procedure TfrmAxmt370.Button15Click(Sender: TObject);
var
  BeginDate,EndDate:string;
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      if ShowGetDate('相關資料查詢', BeginDate,EndDate) then begin
          GetInqOrdShipQty(DBGrid.Fields[7].AsString,BeginDate,EndDate);
      end;
    end;
  end;
end;

procedure TfrmAxmt370.Button16Click(Sender: TObject);
var
  lSql,inqNo,dbName,dbNameS:String;
begin
  if ChkUserEx('axmt370') then begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin

      inqNo:= DBGrid.Fields[3].AsString;
      dbNameS:=DBGrid.Fields[0].AsString;
      if dbNameS='GWS' then dbName:='DS2::';
      if dbNameS='GWH' then dbName:='DS7::';
      if dbNameS='GWT' then dbName:='DS5::';
      if   dbNameS<>'GWT' then  begin
       if GetRecordCount(Format('SELECT COUNT(*) FROM %SOQT_FILE WHERE  OQT01=''%S'' AND OQTCONF=''Y''',[dbName,InqNo]))>0 then begin
        if GetRecordCount(Format('SELECT COUNT(*) FROM %SOEA_FILE WHERE  OEA12=''%S'' ',[dbName,InqNo]))>0 then begin
           Application.MessageBox(
                      Pchar((Format('%S , %S-%S 詢問單有轉銷售單，無法取消確認！',[username,dbNameS,inqNo ]))),
                      '提示',MB_ICONINFORMATION+MB_OK);
         end else begin
           Case Application.MessageBox(PChar(Format('%s ,你要取消 %S 確認?',[username,inqNo])),'確認',MB_ICONQUESTION+MB_YESNO)  of
             ID_NO:Abort;
             ID_YES:begin
               lSql:='UPDATE %SOQT_FILE SET OQTCONF=''N'' WHERE OQT01=''%S'' AND OQTCONF=''Y''';
               ExecSqlA(Format(lsql,[dbName,inqNo]));
             end;
           end;
         end;
        end else begin
           Application.MessageBox(
                      Pchar((Format('%S , %S-%S 詢問單未確認，無需修改！',[username,dbNameS,inqNo ]))),
                      '提示',MB_ICONINFORMATION+MB_OK);
        end;
      end else begin
        Application.MessageBox(Pchar((Format('%s ,你不能修改 %s 詢問單 %s！',[username,dbNameS,inqNo ]))),'提示',MB_ICONINFORMATION+MB_OK);
     end;
   end;
  end;
 end;
end;

procedure TfrmAxmt370.Button18Click(Sender: TObject);
var
  lSql,inqNo,dbName,dbNameS:String;
begin
  if ChkUserEx('axmt370') then begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin

      inqNo:= DBGrid.Fields[3].AsString;
      dbNameS:=DBGrid.Fields[0].AsString;
      if dbNameS='GWS' then dbName:='DS2::';
      if dbNameS='GWH' then dbName:='DS7::';
      if dbNameS='GWT' then dbName:='DS5::';
      if   dbNameS<>'GWT' then  begin
      if GetRecordCount(Format('SELECT COUNT(*) FROM %SOQT_FILE WHERE OQT01=''%S'' AND OQTCONF=''N''',[dbName,InqNo]))>0 then begin
           Case Application.MessageBox(PChar(Format('%s ,你確認要作廢 %S ?',[username,inqNo])),'確認',MB_ICONQUESTION+MB_YESNO)  of
             ID_NO:Abort;
             ID_YES:begin
               lSql:='UPDATE %SOQT_FILE SET OQTCONF=''X'',OQTDATE=TODAY WHERE OQT01=''%S'' AND OQTCONF=''N''';
               ExecSqlA(Format(lsql,[dbName,inqNo]));
             end;
           end;
      end else begin
           Application.MessageBox(Pchar((Format('%s ,詢問單 %s  已確認，不能修改！',[username,inqNo ]))),'提示',MB_ICONINFORMATION+MB_OK);
      end;
      end else begin
        Application.MessageBox(Pchar((Format('%s ,你不能確認 %s 詢問單 %s！',[username,dbNameS,inqNo ]))),'提示',MB_ICONINFORMATION+MB_OK);
     end;
   end;
  end;
 end;
end;

procedure TfrmAxmt370.Button19Click(Sender: TObject);
var
  lSql,inqNo,itemsNo,Modeno,dbName,dbNameS:String;
begin

  if DBGrid.DataSource.DataSet.Active then begin
   if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     SetRecno(QueryChina);   
     if TransYn='Y' then begin
      ModeNo:= DBGrid.Fields[7].AsString;
      inqNo:= DBGrid.Fields[3].AsString;
      itemsNo:=  DBGrid.Fields[4].AsString;
      dbNameS:=DBGrid.Fields[0].AsString;

      if dbNameS='GWS' then dbName:='DS2';
      if dbNameS='GWH' then dbName:='DS7';
      if dbNameS='GWT' then dbName:='DS5';

      lSql:='SELECT  OEB01 AS 銷售單號,                               '+
            '        OEACONF AS 狀態,                                 '+
            '        OEA10 AS 客戶訂單,                               '+
            '        (SELECT GEN02                                    '+
            '           FROM %S::GEN_FILE                             '+
            '          WHERE OEAUSER=GEN01) AS 開單,                  '+
            '        OEB04 AS 料號,                                   '+
            '        OEB06 AS 描述,                                   '+
            '        OEB09 AS 庫別,                                   '+
            '        OEB12 AS 數量,                                   '+
            '        OEB24 AS 已出,                                   '+
            '        OEB25 AS 銷退,                                   '+
            '        OEB26 AS 結案數,                                 '+
            '        OEB70 AS 結案否,                                 '+
            '        OEB70D AS 結案日                                 '+
            '   FROM %S::OEB_FILE,%S::OEA_FILE                        '+
            '  WHERE OEB01=OEA01                                      '+
            '    AND OEA12=''%S''                                     '+
            '    AND OEB71=''%S''                                     '+
            '    AND OEB04=''%S''                                     '+
            '    AND OEA00!=''0''';

      GetQueryData('銷售訂單',Format(lSql,[dbName,dbName,dbName,inqNo,itemsNo,ModeNo]));
    end;
   end;
  end;
end;

end.



