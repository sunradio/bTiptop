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
           Application.MessageBox(Pchar((Format('%S , %S-%S ���������^����I',[username,dbNameS,inqNo ]))),'����',MB_ICONINFORMATION+MB_OK);
         end else begin
           Case Application.MessageBox(PChar(Format('%s ,�A�n�T�{ %S ?',[username,inqNo])),'�T�{',MB_ICONQUESTION+MB_YESNO)  of
             ID_NO:Abort;
             ID_YES:begin
               strTime:=FormatDateTime('hh:nn',now());
               lSql:='UPDATE %SOQT_FILE SET OQTCONF=''Y'',OQT26D=TODAY,OQT27=''%S'',OQTMODU=''%S'' WHERE OQT01=''%S'' AND OQTCONF=''N''';
               ExecSqlA(Format(lsql,[dbName,strTime,UserID,inqNo]));
              end;
           end;
         end;
      end else begin
           Application.MessageBox(Pchar((Format('%s ,�߰ݳ� %s  �w�T�{,����ק�I',[username,inqNo ]))),'����',MB_ICONINFORMATION+MB_OK);
      end;
      end else begin
        Application.MessageBox(Pchar((Format('%s ,�A����T�{ %s �߰ݳ� %s�I',[username,dbNameS,inqNo ]))),'����',MB_ICONINFORMATION+MB_OK);
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

    lSqlChina:='SELECT ''GWS'' AS �t�O,      '+
                ' OQT26D   AS �T�{��,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS �O��,          '+
                ' OQT01 AS �߰ݳ�,      '+
                ' C.OQU02 AS ����,      '+
                ' OCC02 AS �Ȥ�W��,    '+
                '(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQT07) AS �m�W,   '+
                ' C.OQU03 AS �Ƹ�,      '+
                ' C.OQU031 AS �~�W,     '+

                ' C.OQU06 AS �ƶq,      '+
                ' C.OQU14D AS �ݨD,     '+
                ' C.OQU14C AS �^��,     '+

                ' C.OQU16 AS �Ƶ�,      '+
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
                '                     WHEN A.OQTCONF=''X'' THEN ''GWT INQ->X'' END ||'' ��P���->''||B.OQU14 '+
                '           FROM DS5::OQT_FILE A ,DS5::OQU_FILE B '+
                '        WHERE A.OQT01=B.OQU01 AND (A.OQT01=C.OQU16[1,10] AND C.OQU16[12,14]=B.OQU02 AND B.OQU03=C.OQU03)) '+
                '       END  '+ 
                '    END  '+
                '  END AS �ѦҫH��,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS �}��,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTMODU) AS �ק�'+
                ' FROM DS2::OQT_FILE,DS2::OQU_FILE C,DS2::OCC_FILE   '+
                'WHERE OQT01=OQU01  AND OCC01=OQT04                  '+
                '  AND OQTCONF =''%S''                        '+
                //'  AND OQT07!=''H091''                        '+
                '  AND OQU14=''%S''  AND C.OQU03 LIKE ''%S%S'''+
                '  AND OQT02 BETWEEN ''%S'' AND  ''%S''       '+
                'UNION ALL                                    '+
                '                                        '+
                'SELECT ''GWH'',                         '+

                ' OQT26D   AS ����,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS �O��,          '+
               ' OQT01 AS �߰ݳ�,                        '+
               ' C.OQU02 AS ����,        '+
               ' OCC02 AS �Ȥ�W��,                      '+
               ' (SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQT07),   '+
               ' C.OQU03 AS �Ƹ�,                            '+
               ' C.OQU031 AS �~�W,                           '+

               ' C.OQU06 AS �ƶq,                            '+
               ' C.OQU14D AS �ݨD,                           '+
               ' C.OQU14C AS �^��,                           '+

               ' C.OQU16 AS �Ƶ�,  '+
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
                '                     WHEN A.OQTCONF=''X'' THEN ''GWT INQ->X'' END ||'' ��P���->''||B.OQU14 '+
                '           FROM DS5::OQT_FILE A ,DS5::OQU_FILE B '+
                '        WHERE A.OQT01=B.OQU01 AND (A.OQT01=C.OQU16[1,10] AND C.OQU16[12,14]=B.OQU02 AND B.OQU03=C.OQU03)) '+
                '       END  '+ 
                '    END  '+
                '  END AS �ѦҫH��,(SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQTUSER) AS �}��,(SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQTMODU) AS �ק�'+
               ' FROM DS7::OQT_FILE,DS7::OQU_FILE C,DS7::OCC_FILE   '+
               ' WHERE OQT01=OQU01  AND OCC01=OQT04                 '+
               ' AND OQTCONF =''%S''                                '+
              // ' AND OQT07!=''H091''                                '+
               '  AND OQU14=''%S''   AND C.OQU03 LIKE ''%S%S''      '+
               ' AND OQT02 BETWEEN ''%S'' AND ''%S''                '+
               ' order by 1,4 desc,5';

    lSqlGwt:= ' SELECT ''GWT'' AS �t�O,                                    '+

                ' D.OQT26D   AS ����,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (D.OQT26D+(SELECT 7+COUNT(*) FROM DS5::SME_FILE WHERE SME01 BETWEEN D.OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (D.OQT26D+(SELECT 7+COUNT(*) FROM DS5::SME_FILE WHERE SME01 BETWEEN D.OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS �O��,          '+
               ' D.OQT01 AS �߰ݳ�,                                 '+
               ' C.OQU02 AS ����,                                   '+
               ' OCC02 AS �Ȥ�W��,                                 '+
               ' (SELECT GEN02 FROM DS5::GEN_FILE WHERE GEN01=D.OQT07) AS �m�W, '+
               ' C.OQU03 AS �Ƹ�,                                       '+
               ' C.OQU031 AS �~�W,                                      '+

               ' C.OQU06 AS �ƶq,                                       '+
               ' C.OQU14D AS �ݨD,                                      '+
               ' C.OQU14C AS �^��,                                      '+

               ' C.OQU16 AS �Ƶ�,                     '+

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
               '   END)      AS �ѦҫH��, '+
               '          (SELECT GEN02 FROM DS5::GEN_FILE WHERE GEN01=OQTUSER) AS �}��,(SELECT GEN02 FROM DS5::GEN_FILE WHERE GEN01=OQTMODU) AS �ק� '+

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
    0:ShowExportOpen(QueryChina,'axmt370','axmt370 - �߰ݳ�d��');
    1:ShowExportOpen(QueryGWT,'axmt370','axmt370 - GWT�߰ݳ�d��');
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
      if GetQueryWhere('�i�X�s�d��','�п�J�~���]YYYY�^',ym,true) then begin
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
    cbsel.Caption :='�w�T�{';
    selyn:='Y';
  end else begin
    cbsel.Caption:='���T�{';
    selyn:='N';
    cbTrans.Checked:=False;
  end;
end;

procedure TfrmAxmt370.cbTransClick(Sender: TObject);
begin
   if cbTrans.Checked then begin
    cbTrans.Caption :='�w���';
    cbsel.Checked:=True;
    TransYN:='Y';

   end else begin
    cbTrans.Caption:='�����';
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
  if GetQueryWhere('�߰ݳ�d��','�п�J�߰ݳ�',InqNum,false) then begin
  if InqNum<>'' then begin
     if QueryChina.active then QueryChina.close;
       QueryChina.sQL.Clear;


    lSql:='SELECT ''GWS'' AS �t�O,              '+
                ' OQT26D   AS �T�{��,           '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS �O��,         '+
                ' OQT01 AS �߰ݳ�,              '+
                ' C.OQU02 AS ����,              '+
                ' OCC02 AS �Ȥ�W��,            '+
                ' (SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQT07) AS �m�W,   '+
                ' C.OQU03 AS �Ƹ�,              '+
                ' C.OQU031 AS �~�W,             '+
                ' C.OQU06 AS �ƶq,              '+
                ' C.OQU14D AS �ݨD,             '+
                ' C.OQU14C AS �^��,             '+
                ' C.OQU16 AS �Ƶ�,''���: ''||OQU14||'' ����: ''||OQTCONF AS ���A,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS �}��     '+
          ' FROM DS2::OQT_FILE,DS2::OQU_FILE C,DS2::OCC_FILE   '+
          'WHERE OQT01=C.OQU01  AND OCC01=OQT04 '+
          '  AND OQT07!=''H091''                '+
          '  AND OQT01=''%S''                   '+

          'UNION ALL                            '+
          '                                     '+
         'SELECT ''GWH'',                       '+

                ' OQT26D   AS �T�{��,           '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS �O��,         '+
                ' OQT01 AS �߰ݳ�,              '+
                ' C.OQU02 AS ����,              '+
                ' OCC02 AS �Ȥ�W��,            '+
                ' (SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQT07) AS �m�W,   '+
                ' C.OQU03 AS �Ƹ�,              '+
                ' C.OQU031 AS �~�W,             '+
                ' C.OQU06 AS �ƶq,              '+
                ' C.OQU14D AS �ݨD,             '+
                ' C.OQU14C AS �^��,             '+
                ' C.OQU16 AS �Ƶ� ,''���: ''||OQU14||'' ����: ''||OQTCONF AS ���A  ,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS �}��         '+
               ' FROM DS7::OQT_FILE,DS7::OQU_FILE C,DS7::OCC_FILE   '+
               ' WHERE OQT01=C.OQU01  AND OCC01=OQT04               '+
               ' AND OQT07!=''H091''                                '+
               ' AND OQT01 =''%S''                                  '+
               '                                                    '+
               '                                                    '+
               ' UNION ALL                                          '+
               '                                                    '+
               ' SELECT ''GWT'',                                    '+
                ' OQT26D   AS �T�{��,          '+
                ' CASE WHEN OQU14!=''Y'' THEN  '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS5::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS5::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS �O��,        '+
                ' OQT01 AS �߰ݳ�,             '+
                ' OQU02 AS ����,               '+
                ' OCC02 AS �Ȥ�W��,           '+
                ' (SELECT GEN02 FROM DS5::GEN_FILE WHERE GEN01=OQT07) AS �m�W,   '+
                ' OQU03 AS �Ƹ�,               '+

                ' OQU031 AS �~�W,              '+
                ' OQU06 AS �ƶq,               '+
                ' OQU14D AS �ݨD,              '+
                ' OQU14C AS �^��,              '+
                ' OQU16 AS �Ƶ� ,''���: ''||OQU14||'' ����: ''||OQTCONF AS ���A   ,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS �}��       '+
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
             Application.MessageBox(Pchar((Format('%s , ���H�b�ק�߰ݳ�A�𮧷|��A�^�ӡI',[Username]))),'����',MB_ICONINFORMATION+MB_OK);
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
       if GetQueryWhere(Format('%s :�ɵn %s �߰ݳ� %s  ����GWT �߰ݳ�',[username,DBGrid.Fields[0].AsString,DBGrid.Fields[3].AsString]) ,'�п�JGWT �߰ݳ渹',Iqno,false) then begin
       Iqnoa:= strLeft(Iqno,10);
       itmNo:= strRight(Iqno,StrLength(Iqno)-11);
       modeno:=DBGrid.Fields[7].AsString;
         if Iqno<>'' then begin
           lSql:='SELECT COUNT(*) FROM DS5::OQT_FILE,DS5::OQU_FILE  WHERE OQT01=OQU01 AND OQT04=''XATWXGU0'' AND OQT01=''%S'' AND OQU02=''%S'' AND OQU03=''%S''';
           if GetRecordCount(Format(lsql,[Iqnoa,itmNo,ModeNo])) >0 then begin
             lSql:='UPDATE %SOQU_FILE SET OQU16=''%S'' WHERE OQU01=''%S'' AND OQU02=''%S''';
             ExecSqlA(Format(lsql,[dbName,Iqno,DBGrid.Fields[3].AsString,DBGrid.Fields[4].AsString]));

           end else begin
             Application.MessageBox(Pchar((Format('%s , GWT�߰ݳ� %s ���s�b',[username,Iqno]))),'����',MB_ICONINFORMATION+MB_OK);
           end;
          end;
        end;
      end else begin
          Application.MessageBox(Pchar((Format('%S , %S �߰ݳ�Ƶ���ƽЪ����bTIPTOP�ק�I',[Username,dbNameS]))),'����',MB_ICONINFORMATION+MB_OK);
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

  PMFind.Items[0].Caption:='�L�o [ '+dbgrid.GetFieldValue(dbgrid.GetActiveCol-1)+' ]';
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
         if GetQueryWhereDate(Format('%s �߰ݳ� %s - %S ����^��',[dbNameS,inqNo,ModeNo]) ,'��ܤ��',AnswerDate) then begin
           if AnswerDate<>'' then begin
             if AnswerDate >= FormatDatetime('yyyymmdd',now) then begin
               lSql:='UPDATE %SOQU_FILE SET OQU14C=''%S'' WHERE OQU01=''%S'' AND OQU02=''%S'' ';
               try
                 ExecSQLA(Format(lsql,[dbName,AnswerDate,inqNo,itemsNo]));
               except
                 on e:EDBEngineError do
                 if e.Errors[1].NativeError=-1218 then  begin
                   Application.MessageBox(Pchar((Format('%s ,�A�^�Ъ���� %S �榡���~�A�аѷ� YYYYMMDD �榡.',[Username,AnswerDate]))),'����',MB_ICONINFORMATION+MB_OK);
                 end else begin
                   Application.MessageBox(Pchar(e.Message),'���~',MB_ICONINFORMATION+MB_OK);
                 end;
               end;
             end else begin
               Application.MessageBox(Pchar((Format('%s ,��� %S �p�� %s ,�Ц^�Фj�󵥩󤵤骺����I',[Username,AnswerDate,FormatDatetime('yyyymmdd',now)]))),'����',MB_ICONINFORMATION+MB_OK);
             end;
           end;
         end
      end else begin
        Application.MessageBox(Pchar((Format('%S ,�߰ݳ� %s ->  %S  -> %S �w�T�{�A�L�k�ק����I',[Username,inqNo,itemsNo ,ModeNo ]))),'����',MB_ICONINFORMATION+MB_OK);
      end;
      end else begin
        Application.MessageBox(Pchar((Format('%S , %S �߰ݳ� %s ���� %S �H���^�СI',[Username,dbNameS,inqNo,dbNameS ]))),'����',MB_ICONINFORMATION+MB_OK);
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
     Case Application.MessageBox(PChar(Format('%s ,�o�{���g�P�ӳ���,�h�ݬݡH',[username])),'�T�{',MB_ICONQUESTION+MB_YESNO)  of
      ID_NO:InqConfirm;
      ID_YES:begin
              lSql:=' SELECT CAT01 AS �Ʈ׽s��,    '+
              '              CAT15 AS �w���פ�,    '+
              '              CAT05 AS �g�P��,      '+
              '              CAT061 AS ����,       '+
              '              CAT071 AS �~�ȭ�,     '+
              '              CAS02 AS ����,        '+
              '              CAS03 AS �Ƹ�,        '+
              '              CAS04 AS �Ʈ׼�,        '+
              '              ''%d'' AS �߰ݼ�,     '+
              '              ''%s'' AS �߰ݳ渹,   '+
              '              CAT02 AS �Ʈפ��,    '+
              '              CAT17 AS �߮פ�,      '+
              '              CAT12 AS �q�l�l��     '+
              '   FROM GWS::CAT_FILE,GWS::CAS_FILE '+
              '  WHERE CAT01=CAS01                 '+
              '    AND CAT16=''Y''                 '+
              '    AND CAT23=''N''                 '+
              '    AND CAT24=''N''                 '+
              '    AND CAS08=''N''                 '+
              '    AND CAS03 IN ( SELECT OQU03 FROM %SOQU_FILE,%SOQT_FILE WHERE OQU01=OQT01 AND OQTCONF=''N'' AND OQT01=''%S'')              '+
              '    AND CAT15>=TODAY                ';
               GetQueryData('�g�P�Ӯץ���Ƹ��',Format(lSql,[InqQty,InqNo,dbName,dbName,InqNo])); {
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
        Case Application.MessageBox(PChar(Format('%S :�A�T�{�n�R�� %S -> %S -> %S -%S ?',[username,dbNameS,InqNo,itemsNo,ModeNo])),'�T�{',MB_ICONQUESTION+MB_YESNO)  of
            ID_NO:Abort;
            ID_YES:begin
               lSql:='DELETE  %SOQU_FILE WHERE OQU01=''%S'' AND OQU02=''%S'' AND OQU03=''%S''';
               ExecSqlA(Format(lsql,[dbName,inqNo,itemsNo,ModeNo]));

           end;
         end;  
      end else begin
           Application.MessageBox(Pchar((Format('%s :�߰ݳ� %s  �w�T�{�A����R���I',[username,inqNo ]))),'����',MB_ICONINFORMATION+MB_OK);
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
    cbDo.Caption :='�۰ʬd��-�j��';
  end else begin
     cbDo.Caption:='��ʬd��-�j��';
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
  if GetQueryWhere('�߰ݳ�d��','�п�J�P��渹',InqNum,false) then begin
  if InqNum<>'' then begin
     if QueryChina.active then QueryChina.close;
       QueryChina.sQL.Clear;


    lSql:='SELECT ''GWS'' AS �t�O,   '+

                ' OQT26D   AS �T�{��,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS2::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS �O��,          '+
                ' OQT01 AS �߰ݳ�,    '+
                ' C.OQU02 AS ����,  '+
                ' OCC02 AS �Ȥ�W��,    '+
                ' (SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQT07) AS �m�W,   '+
                ' C.OQU03 AS �Ƹ�,        '+

                ' C.OQU031 AS �~�W,       '+
                ' C.OQU06 AS �ƶq,         '+
                ' C.OQU14D AS �ݨD,        '+
                ' C.OQU14C AS �^��,         '+
                ' C.OQU16 AS �Ƶ� ,C.OQU14 ��檬�A  ,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS �}��         '+
          ' FROM DS2::OQT_FILE ,DS2::OQU_FILE C,DS2::OCC_FILE   '+
          'WHERE OQT01=C.OQU01  AND OCC01=OQT04         '+
          '  AND OQT07!=''H091''                        '+
          '  AND OQT23=''%S''                         '+

          'UNION ALL                                   '+
          '                                           '+
         'SELECT ''GWH'',                              '+

                ' OQT26D   AS �T�{��,    '+
                ' CASE WHEN C.OQU14!=''Y'' THEN '+
                '   CASE WHEN  TODAY > (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) THEN '+
                '        TODAY- (OQT26D+(SELECT 7+COUNT(*) FROM DS7::SME_FILE WHERE SME01 BETWEEN OQT26D AND TODAY AND SME02=''N'')) ELSE 0 END  '+
                ' ELSE  0  END AS �O��,          '+
                ' OQT01 AS �߰ݳ�,    '+
                ' C.OQU02 AS ����,  '+
                ' OCC02 AS �Ȥ�W��,    '+
                ' (SELECT GEN02 FROM DS7::GEN_FILE WHERE GEN01=OQT07) AS �m�W,   '+
                ' C.OQU03 AS �Ƹ�,        '+

                ' C.OQU031 AS �~�W,       '+
                ' C.OQU06 AS �ƶq,         '+
                ' C.OQU14D AS �ݨD,        '+
                ' C.OQU14C AS �^��,         '+
                ' C.OQU16 AS �Ƶ� ,C.OQU14 ��檬�A  ,(SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=OQTUSER) AS �}��        '+
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
      if ShowGetDate('������Ƭd��', BeginDate,EndDate) then begin
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
                      Pchar((Format('%S , %S-%S �߰ݳ榳��P���A�L�k�����T�{�I',[username,dbNameS,inqNo ]))),
                      '����',MB_ICONINFORMATION+MB_OK);
         end else begin
           Case Application.MessageBox(PChar(Format('%s ,�A�n���� %S �T�{?',[username,inqNo])),'�T�{',MB_ICONQUESTION+MB_YESNO)  of
             ID_NO:Abort;
             ID_YES:begin
               lSql:='UPDATE %SOQT_FILE SET OQTCONF=''N'' WHERE OQT01=''%S'' AND OQTCONF=''Y''';
               ExecSqlA(Format(lsql,[dbName,inqNo]));
             end;
           end;
         end;
        end else begin
           Application.MessageBox(
                      Pchar((Format('%S , %S-%S �߰ݳ楼�T�{�A�L�ݭק�I',[username,dbNameS,inqNo ]))),
                      '����',MB_ICONINFORMATION+MB_OK);
        end;
      end else begin
        Application.MessageBox(Pchar((Format('%s ,�A����ק� %s �߰ݳ� %s�I',[username,dbNameS,inqNo ]))),'����',MB_ICONINFORMATION+MB_OK);
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
           Case Application.MessageBox(PChar(Format('%s ,�A�T�{�n�@�o %S ?',[username,inqNo])),'�T�{',MB_ICONQUESTION+MB_YESNO)  of
             ID_NO:Abort;
             ID_YES:begin
               lSql:='UPDATE %SOQT_FILE SET OQTCONF=''X'',OQTDATE=TODAY WHERE OQT01=''%S'' AND OQTCONF=''N''';
               ExecSqlA(Format(lsql,[dbName,inqNo]));
             end;
           end;
      end else begin
           Application.MessageBox(Pchar((Format('%s ,�߰ݳ� %s  �w�T�{�A����ק�I',[username,inqNo ]))),'����',MB_ICONINFORMATION+MB_OK);
      end;
      end else begin
        Application.MessageBox(Pchar((Format('%s ,�A����T�{ %s �߰ݳ� %s�I',[username,dbNameS,inqNo ]))),'����',MB_ICONINFORMATION+MB_OK);
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

      lSql:='SELECT  OEB01 AS �P��渹,                               '+
            '        OEACONF AS ���A,                                 '+
            '        OEA10 AS �Ȥ�q��,                               '+
            '        (SELECT GEN02                                    '+
            '           FROM %S::GEN_FILE                             '+
            '          WHERE OEAUSER=GEN01) AS �}��,                  '+
            '        OEB04 AS �Ƹ�,                                   '+
            '        OEB06 AS �y�z,                                   '+
            '        OEB09 AS �w�O,                                   '+
            '        OEB12 AS �ƶq,                                   '+
            '        OEB24 AS �w�X,                                   '+
            '        OEB25 AS �P�h,                                   '+
            '        OEB26 AS ���׼�,                                 '+
            '        OEB70 AS ���ק_,                                 '+
            '        OEB70D AS ���פ�                                 '+
            '   FROM %S::OEB_FILE,%S::OEA_FILE                        '+
            '  WHERE OEB01=OEA01                                      '+
            '    AND OEA12=''%S''                                     '+
            '    AND OEB71=''%S''                                     '+
            '    AND OEB04=''%S''                                     '+
            '    AND OEA00!=''0''';

      GetQueryData('�P��q��',Format(lSql,[dbName,dbName,dbName,inqNo,itemsNo,ModeNo]));
    end;
   end;
  end;
end;

end.



