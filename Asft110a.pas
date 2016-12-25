unit Asft110a;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, StdCtrls, ToolWin, ComCtrls, Db, DBTables,PASDM,JclStrings,
  Menus,Sysdb, ExtCtrls,pasMain;

type
  TfrmAsft110a = class(TForm)
    tbASFT110: TToolBar;
    tbRun: TToolButton;
    qry_Asft110: TQuery;
    ds_Asft110: TDataSource;
    tbExport: TToolButton;
    tbFind: TToolButton;
    tbFilter: TToolButton;
    tbRemove: TToolButton;
    qry_Asft110partno: TStringField;
    qry_Asft110stkno: TStringField;
    qry_Asft110woqty: TFloatField;
    qry_Asft110ds2stk: TFloatField;
    qry_Asft110ds5stk: TFloatField;
    qry_Asft110ds2iqc: TFloatField;
    qry_Asft110actshortage: TFloatField;
    qry_Asft110ds2ob: TFloatField;
    DBGrid: TwwDBGrid;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    lblMsg: TLabel;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    qry_Asft110wipqty: TFloatField;
    qry_Asft110sh06: TFloatField;
    qry_Asft110wono: TStringField;
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
    procedure bpcs0011Click(Sender: TObject);
    procedure aimq1361Click(Sender: TObject);
    procedure aimq1381Click(Sender: TObject);
    procedure aimq1371Click(Sender: TObject);
    procedure aimq1341Click(Sender: TObject);
    procedure aimq1401Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAsft110a: TfrmAsft110a;

implementation
uses pasCodeProc,pasSysRes;
{$R *.DFM}

procedure TfrmAsft110a.tbRunClick(Sender: TObject);
var
  vSql,strlike:String;

begin
  strlike:='%營技%';

  vSql:=
   'SELECT CASE WHEN SFA01=''PTM-Z90501'' THEN ''待雜領''                  '+
   '            WHEN SFA01=''PTM-Z90502'' THEN ''待轉庫'' END AS WONO,     '+

   '    SFA03 AS PARTNO,                     '+
   '    SFA30 AS STKNO ,                     '+
   '    SUM(SFA05) AS WOQTY,                 '+
   '                                         '+
   '    (SELECT SUM(IMG10)                   '+
   '       FROM DS2::IMG_FILE B              '+
   '      WHERE B.IMG01=A.SFA03              '+
   '       AND B.IMG23=''Y''                   '+
   '       AND B.IMG02 IN (''01'',''02'',''0A'')) AS DS2STK,    '+

   '                                                           '+
   '    (SELECT SUM(IMG10)                                     '+
   '       FROM DS2::IMG_FILE B                                '+
   '      WHERE B.IMG01=A.SFA03                                '+
   '       AND B.IMG23=''Y''                                      '+
   '       AND B.IMG02=''BVI'') AS DS2OB,                        '+
   '                                                          '+
   '    (SELECT SUM(IMG10)                                     '+
   '       FROM DS2::IMG_FILE B                                '+
   '      WHERE B.IMG01=A.SFA03                                '+
   '       AND B.IMG23=''Y''                                      '+
   '       AND B.IMG02=''06-SH'') AS sh06,                        '+

   '     (SELECT SUM((pmn20-pmn50+pmn55)*pmn09)'+
   '        FROM DS2::pmn_file, DS2::pmm_file ,DS2::PML_FILE       '+
   '       WHERE pmn04 = A.SFA03               '+
   '         AND PMN24 = PML01  AND PMN25=PML02     '+
   '         AND PML06 LIKE ''%s''         '+
   '         AND pmn01 = pmm01                 '+
   '         AND pmn16 <=''2''                 '+
  // '         AND PMN20 >PMN50                         '+
   '         AND pmn011 !=''SUB''   HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0 ) AS poqty,     '+

   '                                                            '+
   '    (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                  '+
   '       FROM DS2::RVB_FILE, DS2::RVA_FILE, DS2::PMN_FILE     '+
   '      WHERE RVB01=RVA01                                     '+
   '        AND RVB05 =A.SFA03                                  '+
   '        AND RVB04 = PMN01                                  '+
   '        AND RVB03 = PMN02                                  '+
   '        AND RVB07 > (RVB29+RVB30)) AS DS2IQC,               '+

   '      ( SELECT     SUM(SFB08-SFB09)                          '+
   '        FROM DS2::SFB_FILE                                        '+
   '       WHERE SFB05=A.SFA03  AND SFB01[1,7]=''PCB-099''       '+
   '         AND SFB04 < ''8''                                   '+
   '         AND SFB02 <>''7''                                   '+
   '         AND SFB08 > SFB09 ) AS wipqty                    '+

   '   FROM DS2::SFA_FILE A ,DS2::SFB_FILE B '+
   '    WHERE A.SFA01=B.SFB01 AND B.SFB04!=''8'' AND SFA01 IN (''PTM-Z90501'',''PTM-Z90502'')'+
   '    GROUP BY SFA01,SFA03,SFA30                                        '+
   '   HAVING  (SUM(SFA05-SFA06)<>0)                                      '+
   '    ORDER BY 1,2';


   if qry_Asft110.active then close;
   with qry_Asft110 do
   begin
     SQL.Clear;
     SQL.Add(Format(vSql,[strLike])); // ParamByName('WONO').AsString:=txtWono.Text;
     try
       Screen.Cursor:=crSQLWait;
       QRY_ASFT110.Open;
     finally
       Screen.Cursor:=crDefault;
     end;
   end;
end;

procedure TfrmAsft110a.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if QRY_ASFT110.Active then
     QRY_ASFT110.Close;
  Action:=caFree;
end;

procedure TfrmAsft110a.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAsft110a.txtWonoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    tbRunClick(Sender);
end;

procedure TfrmAsft110a.tbExportClick(Sender: TObject);
begin
  ShowExportOpen(QRY_ASFT110,'ASFT110','ASFT110-維修領料未發明細');
end;

procedure TfrmAsft110a.tbFindClick(Sender: TObject);
begin
  ShowFindDialog(QRY_ASFT110,dbgrid.GetActiveCol-1);
end;

procedure TfrmAsft110a.tbFilterClick(Sender: TObject);
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

procedure TfrmAsft110a.tbRemoveClick(Sender: TObject);
begin
  if QRY_ASFT110.Filtered then
  begin
     QRY_ASFT110.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmAsft110a.DBGridDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
begin
  if qry_Asft110.fieldbyname('actShortage').asinteger >=0 then
  begin
     DBGrid.Canvas.Brush.Color:=clAqua;
     DBGrid.Canvas.Font.Color:=clNavy;
  end;
  dbgrid.DefaultDrawDataCell(rect, Field, state);

end;

procedure TfrmAsft110a.qry_Asft110CalcFields(DataSet: TDataSet);
begin
  with DataSet.Fields  do
  begin
     FieldByName('actShortage').AsInteger:=(FieldByName('ds2stk').AsInteger) -
               (FieldByName('woqty').AsInteger);
  end;
end;

procedure TfrmAsft110a.Aimq1021Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq102') then
         GetBalQty_Aimq102(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAsft110a.aimq404Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq404') then
         GetStockQty_Aimq404(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAsft110a.asmq2021Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('asmq202') then
         GetTransLog_asmq202(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAsft110a.bpcs0011Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWeWipQty_Bpcs001(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAsft110a.aimq1361Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq136') then
         GetWoWipQty_Aimq136(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAsft110a.aimq1381Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq138') then
         GetWorksQty_Aimq138A(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAsft110a.aimq1371Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq137') then
         GetWaitIqcQ_Aimq137(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAsft110a.aimq1341Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
      // if ChkUserEx('aimq134') then
         GetPuOrdQty_Aimq134a(DBGrid.Fields[0].AsString);
    end;
  end;
end;

procedure TfrmAsft110a.aimq1401Click(Sender: TObject);
begin
  if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
     //  if ChkUserEx('aimq140') then
         GetReqstQty_Aimq140(DBGrid.Fields[0].AsString);
    end;
  end;
end;

end.
