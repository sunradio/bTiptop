unit Bpcs002;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, Grids, Wwdbigrd, Wwdbgrid, Db, DBTables,
  StdCtrls, ExtCtrls, DBCtrls, DBGrids, Mask;

type
  TfrmBpcs002 = class(TForm)
    ToolBar1: TToolBar;
    tbRun: TToolButton;
    ToolButton1: TToolButton;
    tbExport: TToolButton;
    tbFind: TToolButton;
    tbFilter: TToolButton;
    tbRemove: TToolButton;
    ds_bpcs001: TDataSource;
    ToolButton3: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    UpdateSQL1: TUpdateSQL;
    ToolButton2: TToolButton;
    tbDel: TToolButton;
    ToolButton13: TToolButton;
    qry_bpcs001: TQuery;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet1: TTabSheet;
    txtModeno: TDBEdit;
    txtDesc: TEdit;
    txtChsDesc: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBGrid: TwwDBGrid;
    Query1: TQuery;
    ToolButton12: TToolButton;
    ToolButton4: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    procedure tbRunClick(Sender: TObject);
    procedure tbExportClick(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tbFindClick(Sender: TObject);
    procedure tbFilterClick(Sender: TObject);
    procedure qry_bpcs001AfterScroll(DataSet: TDataSet);
    procedure qry_bpcs001BeforeDelete(DataSet: TDataSet);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure qry_bpcs001BeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBpcs002: TfrmBpcs002;

implementation
Uses pasDm,pasSysRes,pasCodeProc,pasSysQryResultEx;
{$R *.DFM}

procedure TfrmBpcs002.tbRunClick(Sender: TObject);
begin
 try
    ExecSqlA('CREATE TEMP TABLE TMPPC_FILE'+
             '( PARTNO VARCHAR(15),'+
             '  TYPE   VARCHAR(20), '+
             '  QTY    DECIMAL(8,0))');
  except
    on e:EDBEngineError do
    if e.Errors[1].NativeError=-958 then
       ExecSqlA('DELETE TMPPC_FILE');
  end;


  //GWS SO
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT OEB04,''0.GWS 殘訂'',SUM((OEB12-OEB24)*OEB05_FAC) '+
           '  FROM DS2::OEB_FILE , DS2::OEA_FILE , GWS::MODE_FILE     '+
           ' WHERE OEB01 = OEA01  AND OEB04[1,11]=MODENO              '+
           '   AND OEA00<>''0''                                '+
           '   AND OEB70 = ''N''                               '+
           '   AND OEB12 > OEB24                               '+
           '   AND OEA25 NOT IN (''CX3'',''CX4'',''CX5'')      '+
           'GROUP BY 1,2');

  //GWH SO
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT OEB04,''0.GWH 殘訂'',SUM((OEB12-OEB24)*OEB05_FAC) '+
           '  FROM DS7::OEB_FILE , DS7::OEA_FILE , GWS::MODE_FILE     '+
           ' WHERE OEB01 = OEA01  AND OEB04[1,11]=MODENO              '+
           '   AND OEA00<>''0''                                '+
           '   AND OEB70 = ''N''                               '+
           '   AND OEB12 > OEB24                               '+
           '   AND OEA25 NOT IN (''CX3'',''CX4'',''CX5'')      '+
           'GROUP BY 1,2');

  //GWS INQ
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT OQU03  ,        '+
           '       ''1.GWS 詢問'',  '+
           '       SUM(OQU06)      '+
           '  FROM DS2::OQU_FILE , DS2::OQT_FILE ,GWS::MODE_FILE   '+
           ' WHERE OQT01=OQU01 AND OQU14=''N''             '+
           '   AND OQTCONF!=''X'' AND OQU03[1,11]=MODENO          '+
           ' GROUP BY 1 ,2');

  //GWH INQ
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT OQU03  ,        '+
           '       ''1.GWH 詢問'',  '+
           '       SUM(OQU06)      '+
           '  FROM DS7::OQU_FILE , DS7::OQT_FILE ,GWS::MODE_FILE   '+
           ' WHERE OQT01=OQU01 AND OQU14=''N''             '+
           '   AND OQTCONF!=''X'' AND OQU03[1,11]=MODENO          '+
           ' GROUP BY 1 ,2');


  //GWS OH
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT IMG01,          '+
           '       ''2.GWS 庫存'',   '+
           '       SUM(IMG10)      '+
           '  FROM DS2::IMG_FILE , GWS::MODE_FILE   '+
           ' WHERE IMG10!=0  AND IMG01[1,11]=MODENO       '+
           '   AND IMG02 BETWEEN ''30'' AND ''36'''+
           ' GROUP BY 1,2');

  //GWS OH-OUT
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT IMG01,          '+
           '       ''3.GWS 樣借'',   '+
           '       SUM(IMG10)      '+
           '  FROM DS2::IMG_FILE ,GWS::MODE_FILE  '+
           ' WHERE IMG10!=0  AND IMG01[1,11]=MODENO      '+
           '   AND IMG02 BETWEEN ''37'' AND ''ZZ'''+
           ' GROUP BY 1,2');


  //GWH OH
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT IMG01,          '+
           '       ''2.GWH 庫存'',   '+
           '       SUM(IMG10)      '+
           '  FROM DS7::IMG_FILE , GWS::MODE_FILE   '+
           ' WHERE IMG10!=0  AND IMG01[1,11]=MODENO       '+
           '   AND IMG02 BETWEEN ''30'' AND ''35'''+
           ' GROUP BY 1,2');

  //GWH OH-OUT
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT IMG01,          '+
           '       ''3.GWH 樣借'', '+
           '       SUM(IMG10)      '+
           '  FROM DS7::IMG_FILE ,GWS::MODE_FILE  '+
           ' WHERE IMG10!=0  AND IMG01[1,11]=MODENO      '+
           '   AND IMG02 BETWEEN ''36'' AND ''ZZ'''+
           ' GROUP BY 1,2');

  //GWS BVI
  ExecSqlA('INSERT INTO TMPPC_FILE   '+
          ' SELECT PMN04 AS 料件編號,'+
          '        ''4.GWS 在途'',   '+
          '     SUM((PMN20-PMN50+PMN55)*PMN09) AS 未交數量 '+
          '      FROM PMN_FILE, PMM_FILE                '+
          '     WHERE PMN01 = PMM01                               '+
          '       AND PMN16 <=''2''                               '+
          '       AND PMN011 !=''SUB'' AND  PMM09=''EXBV0000'''+
          '  GROUP BY 1,2'+
          '  HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0 ');

  GetQueryData('進口品企劃資料','SELECT PARTNO AS 品號, PARTNO[1,11] AS 短品號, TYPE AS 類別,QTY AS 數量 FROM  TMPPC_FILE');
end;

procedure TfrmBpcs002.tbExportClick(Sender: TObject);
begin
   ShowExportOpen(qry_bpcs001,'bpcs001','bpcs001 - 成品供需狀況明細');
end;

procedure TfrmBpcs002.tbRemoveClick(Sender: TObject);
begin
  if qry_bpcs001.Filtered then
  begin
     qry_bpcs001.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmBpcs002.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qry_bpcs001.Active then qry_bpcs001.Close;
  Action:=caFree;
end;

procedure TfrmBpcs002.FormCreate(Sender: TObject);
begin
  if not qry_bpcs001.Active then qry_bpcs001.open;
  txtModeno.DataField:='ModeNo';
  if UserID='S7G' then tbDel.Enabled:= False;
end;

procedure TfrmBpcs002.ToolButton14Click(Sender: TObject);
begin
  if qry_bpcs001.UpdatesPending then begin
     qry_bpcs001.ApplyUpdates;
  end;
end;

procedure TfrmBpcs002.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if qry_bpcs001.UpdatesPending then begin
     case Application.MessageBox('編輯資料未保存,保存后退出?','信息',MB_ICONQUESTION+MB_YESNOCANCEL) of
     IDYES:begin
             qry_bpcs001.ApplyUpdates;
             CanClose:=True;
           end;
     IDNO:CanClose:=True;
     IDCANCEL:CanClose:=False;
     end;
end
else
  CanClose:=True;
end;

procedure TfrmBpcs002.tbFindClick(Sender: TObject);
begin
  ShowFindDialog(qry_bpcs001,dbgrid.GetActiveCol-1);
end;

procedure TfrmBpcs002.tbFilterClick(Sender: TObject);
begin
  if ShowFilterDialog(qry_bpcs001,dbgrid.GetActiveCol-1) then begin
    if tbRemove.Enabled=False then
       tbRemove.Enabled:=True;
    end;
end;

procedure TfrmBpcs002.qry_bpcs001AfterScroll(DataSet: TDataSet);
begin
 if pageControl1.ActivePageIndex=0 then begin
  if Query1.Active then Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add(Format('SELECT IMA02,IMA021 FROM DS2::IMA_FILE WHERE IMA01[1,11]=''%S''',[qry_bpcs001.Fields[0].AsString]));
  Query1.Open;
  txtDesc.Text:=Query1.Fields[0].AsString;
  txtChsDesc.Text:=Query1.Fields[1].AsString;
 end;
end;

procedure TfrmBpcs002.qry_bpcs001BeforeDelete(DataSet: TDataSet);
begin
  if Application.MessageBox(
                PChar(Format('你確認要刪除 " %s " 嗎?',
                [qry_bpcs001.Fields[0].AsString])),
                '刪除確認',MB_ICONQUESTION+MB_YESNO)=ID_NO then begin
    Abort;
  end;

end;

procedure TfrmBpcs002.ToolButton4Click(Sender: TObject);
var
 frmCaption,lSql:String;
begin
  lSql:=' SELECT OEA10 AS 採購單號,                     '+
        '        OEA01 AS 訂單號碼,                     '+
        '        OEA02 AS 下單日期,                     '+
        '        OEB04 AS 品號,                         '+
        '        OEB06 AS 品名規格,                     '+
        '        OEB13 AS 價格,                         '+
        '        OEB15 AS 回覆交期,                     '+
        '        OEA12 AS 詢問單號,                     '+
        '        SUM((OEB12-OEB24)*OEB05_FAC) AS 數量   '+
        '   FROM DS5::OEB_FILE , DS5::OEA_FILE          '+
        '  WHERE OEB01 = OEA01                          '+
        '    AND OEA00<>''0''                           '+
        '    AND OEB70 = ''N''                          '+
        '    AND OEB12 > OEB24                          '+
        '    AND OEA25=''CX1''                          '+
        ' GROUP BY 1,2,3,4,5,6,7,8                      '+
        ' ORDER BY 1 DESC,2';
  frmCaption:='在GWT未出成品訂單';
  GetQueryData(frmCaption,lSQL);


end;

procedure TfrmBpcs002.ToolButton16Click(Sender: TObject);
begin
  if qry_bpcs001.Active then qry_bpcs001.Close;
  qry_bpcs001.Open;
end;

procedure TfrmBpcs002.ToolButton17Click(Sender: TObject);
var
 frmCaption,lSql:String;
begin
  lSql:='SELECT MODENO FROM GWS::MODE_FILE WHERE NOT EXISTS (SELECT * FROM DS2::IMA_FILE WHERE IMA01[1,11]=MODENO)';
  frmCaption:='料號錯誤明細';
  GetQueryData(frmCaption,lSQL);
end;

procedure TfrmBpcs002.qry_bpcs001BeforePost(DataSet: TDataSet);
var
  lSql,ModeNo:String;
begin
  lSql:='SELECT COUNT(*) FROM DS2::IMA_FILE WHERE IMA01[1,11]=''%S''';
  ModenO:=DBGrid.GetActiveField.AsString;
  if GetRecordCount(Format(lSql,[ModenO]))<=0 then begin
    Application.MessageBox(Pchar((Format('%S, " %s " 料號系統不存在！',[Username,ModenO]))),'提示',MB_ICONINFORMATION+MB_OK);
    abort;
  end;
end;

end.
