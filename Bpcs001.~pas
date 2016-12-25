unit Bpcs001;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, Grids, Wwdbigrd, Wwdbgrid, Db, DBTables,pasMain,
  StdCtrls, ExtCtrls;

type
  TfrmBpcs001 = class(TForm)
    DBGrid: TwwDBGrid;
    ToolBar1: TToolBar;
    tbRun: TToolButton;
    ToolButton1: TToolButton;
    tbExport: TToolButton;
    tbFind: TToolButton;
    tbFilter: TToolButton;
    tbRemove: TToolButton;
    qry_bpcs001: TQuery;
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
    procedure tbRunClick(Sender: TObject);
    procedure tbExportClick(Sender: TObject);
    procedure tbFindClick(Sender: TObject);
    procedure tbFilterClick(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBpcs001: TfrmBpcs001;

implementation
Uses pasDm,pasSysRes,pasCodeProc,pasBpcs002Dlg;
{$R *.DFM}

procedure TfrmBpcs001.tbRunClick(Sender: TObject);
var
  strX4,strX3,strX2,strX1,strYM:String;

begin
 if SetWoYMWhere(strX4,strX3,strX2,strX1,strYM) then begin
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


  ExecSqlA('SELECT IMA01 FROM DS2::IMA_FILE WHERE IMA01[1,2]=''01'' AND IMA01[12,12]=''R'' INTO TEMP TMPART');

  //GWS SO
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT OEB04,''0.GWS 殘訂'',SUM((OEB12-OEB24)*OEB05_FAC) '+
           '  FROM DS2::OEB_FILE , DS2::OEA_FILE , TMPART     '+
           ' WHERE OEB01 = OEA01  AND OEB04=IMA01              '+
           '   AND OEA00<>''0''                                '+
           '   AND OEB70 = ''N''                               '+
           '   AND OEB12 > OEB24                               '+
           '   AND OEA25 NOT IN (''CX3'',''CX4'',''CX5'')      '+
           'GROUP BY 1,2');

  //GWH SO
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT OEB04,''0.GWH 殘訂'',SUM((OEB12-OEB24)*OEB05_FAC) '+
           '  FROM DS7::OEB_FILE , DS7::OEA_FILE , TMPART     '+
           ' WHERE OEB01 = OEA01  AND OEB04=IMA01              '+
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
           '  FROM DS2::OQU_FILE , DS2::OQT_FILE ,TMPART   '+
           ' WHERE OQT01=OQU01 AND OQU14=''N''             '+
           '   AND OQTCONF!=''X'' AND OQU03=IMA01          '+
           ' GROUP BY 1 ,2');

  //GWH INQ
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT OQU03  ,        '+
           '       ''1.GWH 詢問'',  '+
           '       SUM(OQU06)      '+
           '  FROM DS7::OQU_FILE , DS7::OQT_FILE ,TMPART   '+
           ' WHERE OQT01=OQU01 AND OQU14=''N''             '+
           '   AND OQTCONF!=''X'' AND OQU03=IMA01          '+
           ' GROUP BY 1 ,2');


  //GWS OH
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT IMG01,          '+
           '       ''2.GWS 庫存'',   '+
           '       SUM(IMG10)      '+
           '  FROM DS2::IMG_FILE , TMPART   '+
           ' WHERE IMG10!=0  AND IMG01=IMA01       '+
           '   AND IMG02 BETWEEN ''30'' AND ''36'''+
           ' GROUP BY 1,2');

  //GWS OH-OUT
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT IMG01,          '+
           '       ''3.GWS 樣借'',   '+
           '       SUM(IMG10)      '+
           '  FROM DS2::IMG_FILE ,TMPART  '+
           ' WHERE IMG10!=0  AND IMG01=IMA01      '+
           '   AND IMG02 BETWEEN ''37'' AND ''ZZ'''+
           ' GROUP BY 1,2');


  //GWH OH
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT IMG01,          '+
           '       ''2.GWH 庫存'',   '+
           '       SUM(IMG10)      '+
           '  FROM DS7::IMG_FILE , TMPART   '+
           ' WHERE IMG10!=0  AND IMG01=IMA01       '+
           '   AND IMG02 BETWEEN ''30'' AND ''35'''+
           ' GROUP BY 1,2');

  //GWH OH-OUT
  ExecSqlA('INSERT INTO TMPPC_FILE '+
           'SELECT IMG01,          '+
           '       ''3.GWH 樣借'',   '+
           '       SUM(IMG10)      '+
           '  FROM DS7::IMG_FILE ,TMPART  '+
           ' WHERE IMG10!=0  AND IMG01=IMA01      '+
           '   AND IMG02 BETWEEN ''36'' AND ''ZZ'''+
           ' GROUP BY 1,2');

  //GWS WO X4
  ExecSqlA(Format('INSERT INTO TMPPC_FILE            '+
           'SELECT SFB05 AS MODE,             '+
           '       ''4.工單''||''-''||''%s'', '+
           '       SUM(SFB08-SFB09)           '+
           '  FROM DS2::SFB_FILE ,TMPART     '+
           ' WHERE SFB01[1,3] IN(''WOD'',''SKD'',''RWK'' )'+
           '   AND (SFB08-SFB09)>0  AND SFB05=IMA01 '+
           '   AND SFB04 <''8''                     '+
           '   AND SFB01[5,6]=''%S''                '+
           'GROUP BY 1,2',[strX4,strX4]));


  //GWS WO X3
  ExecSqlA(Format('INSERT INTO TMPPC_FILE            '+
           'SELECT SFB05 AS MODE,             '+
           '       ''4.工單''||''-''||''%s'', '+
           '       SUM(SFB08-SFB09)           '+
           '  FROM DS2::SFB_FILE ,TMPART     '+
           ' WHERE SFB01[1,3] IN(''WOD'',''SKD'',''RWK'' )'+
           '   AND (SFB08-SFB09)>0  AND SFB05=IMA01 '+
           '   AND SFB04 <''8''                     '+
           '   AND SFB01[5,6]=''%S''                '+
           'GROUP BY 1,2',[strX3,strX3]));

  //GWS WO X2
  ExecSqlA(Format('INSERT INTO TMPPC_FILE            '+
           'SELECT SFB05 AS MODE,             '+
           '       ''4.工單''||''-''||''%s'', '+
           '       SUM(SFB08-SFB09)           '+
           '  FROM DS2::SFB_FILE ,TMPART     '+
           ' WHERE SFB01[1,3] IN(''WOD'',''SKD'',''RWK'' )'+
           '   AND (SFB08-SFB09)>0  AND SFB05=IMA01 '+
           '   AND SFB04 <''8''                     '+
           '   AND SFB01[5,6]=''%s''                '+
           'GROUP BY 1,2',[strX2,strX2]));

  //GWS WO X1
  ExecSqlA(Format('INSERT INTO TMPPC_FILE            '+
           'SELECT SFB05 AS MODE,             '+
           '       ''4.工單''||''<=''||''%S'',     '+
           '       SUM(SFB08-SFB09)           '+
           '  FROM DS2::SFB_FILE ,TMPART     '+
           ' WHERE SFB01[1,3] IN(''WOD'',''SKD'',''RWK'' )'+
           '   AND (SFB08-SFB09)>0  AND SFB05=IMA01 '+
           '   AND SFB04 <''8''                     '+
           '   AND SFB01[5,6]<=''%s''                '+
           'GROUP BY 1,2',[strX1,strX1]));

  //GWS X0 SO
  ExecSqlA(Format('INSERT INTO TMPPC_FILE '+
           'SELECT OEB04,''5.GWS 接單'',SUM(OEB12) '+
           '  FROM DS2::OEB_FILE , DS2::OEA_FILE , TMPART     '+
           ' WHERE OEB01 = OEA01  AND OEB04=IMA01              '+
           '   AND OEA00<>''0''                                '+
           '   AND OEB70 = ''N''                               '+
           '   AND OEB01[5,6]=''%s''                           '+
           '   AND OEA25 NOT IN (''CX3'',''CX4'',''CX5'')      '+
           'GROUP BY 1,2',[strYM]));

  //GWH X0 SO
  ExecSqlA(Format('INSERT INTO TMPPC_FILE '+
           'SELECT OEB04,''5.GWH 接單'',SUM(OEB12) '+
           '  FROM DS7::OEB_FILE , DS7::OEA_FILE , TMPART     '+
           ' WHERE OEB01 = OEA01  AND OEB04=IMA01              '+
           '   AND OEA00<>''0''                                '+
           '   AND OEB70 = ''N''                               '+
           '   AND OEB01[5,6]=''%s''                           '+
           '   AND OEA25 NOT IN (''CX3'',''CX4'',''CX5'')      '+
           'GROUP BY 1,2',[strYm]));

  //GWD X0 SO
  ExecSqlA(Format('INSERT INTO TMPPC_FILE '+
           'SELECT OEB04,''5.GWD 接單'',SUM(OEB12) '+
           '  FROM DS6::OEB_FILE , DS6::OEA_FILE , TMPART     '+
           ' WHERE OEB01 = OEA01  AND OEB04=IMA01              '+
           '   AND OEA00<>''0''                                '+
           '   AND OEB70 = ''N''                               '+
           '   AND OEB01[5,6]=''%s''                           '+
           '   AND OEA25 NOT IN (''CX3'',''CX4'',''CX5'')      '+
           'GROUP BY 1,2',[strYm]));

  //GWS OUT
  ExecSqlA(Format('INSERT INTO TMPPC_FILE                        '+
           ' SELECT OGB04,''6.GWS 銷售'',SUM(OGB12)        '+
           '   FROM DS2::OGB_FILE,DS2::OGA_FILE ,TMPART   '+
           '  WHERE OGA01=OGB01 AND OGB04=IMA01           '+
           '    AND OGA01[5,6]=''%s''                     '+
           '    AND OGACONF=''Y''                         '+
           '    AND OGAPOST=''Y''                         '+
           '    AND OGA25 NOT IN (''CX3'',''CX4'',''CX5'')'+
           '  GROUP BY 1,2',[strYm]));

  //GWD OUT
  ExecSqlA(Format('INSERT INTO TMPPC_FILE                        '+
           ' SELECT OGB04,''6.GWD 銷售'',SUM(OGB12)        '+
           '   FROM DS6::OGB_FILE,DS6::OGA_FILE ,TMPART   '+
           '  WHERE OGA01=OGB01 AND OGB04=IMA01           '+
           '    AND OGA01[5,6]=''%s''                     '+
           '    AND OGACONF=''Y''                         '+
           '    AND OGAPOST=''Y''                         '+
           '    AND OGA25 NOT IN (''CX3'',''CX4'',''CX5'')'+
           '  GROUP BY 1,2',[strYm]));

  //GWH OUT
  ExecSqlA(Format('INSERT INTO TMPPC_FILE                        '+
           ' SELECT OGB04,''6.GWH 銷售'',SUM(OGB12)        '+
           '   FROM DS7::OGB_FILE,DS7::OGA_FILE ,TMPART   '+
           '  WHERE OGA01=OGB01 AND OGB04=IMA01           '+
           '    AND OGA01[5,6]=''%s''                     '+
           '    AND OGACONF=''Y''                         '+
           '    AND OGAPOST=''Y''                         '+
           '    AND OGA25 NOT IN (''CX3'',''CX4'',''CX5'')'+
           '  GROUP BY 1,2',[strYm]));



  
  with qry_bpcs001 do begin
    if Active then close;
    SQL.Clear;
     SQL.Add('SELECT PARTNO AS 產品品號, TYPE AS 類別, QTY AS 數量 FROM  TMPPC_FILE');
   try
    Open;
   finally
      ExecSqla('DROP TABLE TMPART');
   end;
  end;
  end;

end;

procedure TfrmBpcs001.tbExportClick(Sender: TObject);
begin
   ShowExportOpen(qry_bpcs001,'bpcs001','自製品企劃供需資料');
end;

procedure TfrmBpcs001.tbFindClick(Sender: TObject);
begin
  ShowFindDialog(qry_bpcs001,dbgrid.GetActiveCol-1);
end;

procedure TfrmBpcs001.tbFilterClick(Sender: TObject);
begin
    if ShowFilterDialog(qry_bpcs001,dbgrid.GetActiveCol-1) then begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
end;

procedure TfrmBpcs001.tbRemoveClick(Sender: TObject);
begin
  if qry_bpcs001.Filtered then
  begin
     qry_bpcs001.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmBpcs001.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

end.
