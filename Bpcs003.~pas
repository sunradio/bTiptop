unit Bpcs003;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, Grids, Wwdbigrd, Wwdbgrid, Db, DBTables,
  StdCtrls, ExtCtrls, DBCtrls, DBGrids, Mask, wwdbedit, wwdbdatetimepicker,
  Wwdotdot, Wwdbcomb, wwdblook, wwcheckbox, Wwdbdlg, wwriched;

type
  TfrmBpcs003 = class(TForm)
    ToolBar1: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    usMaster: TUpdateSQL;
    ToolButton2: TToolButton;
    tbDel: TToolButton;
    ToolButton13: TToolButton;
    tbSave: TToolButton;
    ToolButton15: TToolButton;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    ToolButton12: TToolButton;
    ToolButton18: TToolButton;
    MasterQuery: TQuery;
    dsMaster: TDataSource;
    DetailQuery: TQuery;
    dsDetail: TDataSource;
    usDetail: TUpdateSQL;
    Label2: TLabel;
    deCat01: TwwDBEdit;
    Label3: TLabel;
    deCat02: TwwDBDateTimePicker;
    deCat03: TwwDBComboBox;
    Label4: TLabel;
    Label5: TLabel;
    deCat04: TwwDBEdit;
    deCat05: TwwDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    deCat08: TwwDBEdit;
    Label9: TLabel;
    deCat09: TwwDBEdit;
    Label10: TLabel;
    deCat10: TwwDBEdit;
    Label11: TLabel;
    deCat11: TwwDBEdit;
    Label12: TLabel;
    deCat12: TwwDBEdit;
    Label13: TLabel;
    deCat13: TwwDBComboBox;
    deCat14: TwwDBDateTimePicker;
    Label14: TLabel;
    deCat15: TwwDBDateTimePicker;
    Label15: TLabel;
    deCat16: TwwCheckBox;
    deCat17: TwwDBDateTimePicker;
    Label16: TLabel;
    Label17: TLabel;
    deCat18: TwwDBEdit;
    deCat19: TwwDBEdit;
    Label18: TLabel;
    Label19: TLabel;
    deCat20: TwwDBEdit;
    deCat21: TwwDBEdit;
    Label20: TLabel;
    deCat23: TwwCheckBox;
    deCat24: TwwCheckBox;
    deCat06: TwwDBEdit;
    deCat07: TwwDBEdit;
    DBGrid: TDBGrid;
    deCat061: TwwDBEdit;
    deCat071: TwwDBEdit;
    ToolButton1: TToolButton;
    ToolButton4: TToolButton;
    Panel1: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    TabSheet1: TTabSheet;
    deCat22: TwwDBDateTimePicker;
    Label21: TLabel;
    deCat25: TwwDBRichEdit;
    DBGridView: TDBGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MasterQueryAfterScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure DetailQueryNewRecord(DataSet: TDataSet);
    procedure tbSaveClick(Sender: TObject);
    procedure DetailQueryAfterOpen(DataSet: TDataSet);
    procedure ToolButton10Click(Sender: TObject);
    procedure MasterQueryAfterOpen(DataSet: TDataSet);
    procedure MasterQueryNewRecord(DataSet: TDataSet);
    procedure DetailQueryBeforeInsert(DataSet: TDataSet);
    procedure MasterQueryBeforeDelete(DataSet: TDataSet);
    procedure MasterQueryBeforeInsert(DataSet: TDataSet);
    procedure DBGridEditButtonClick(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure DetailQueryBeforeEdit(DataSet: TDataSet);
    procedure DetailQueryBeforePost(DataSet: TDataSet);
    procedure DetailQueryBeforeDelete(DataSet: TDataSet);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure MasterQueryBeforeEdit(DataSet: TDataSet);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure deCat04Exit(Sender: TObject);
    procedure deCat04KeyPress(Sender: TObject; var Key: Char);
    procedure CheckAgent;
    procedure CheckDept;
    procedure CheckEmp;
    procedure deCat06KeyPress(Sender: TObject; var Key: Char);
    procedure deCat07KeyPress(Sender: TObject; var Key: Char);
    procedure deCat06Exit(Sender: TObject);
    procedure deCat07Exit(Sender: TObject);
    procedure DBGridColExit(Sender: TObject);
    procedure  DelCasIsNull;
    procedure DetailQueryBeforeOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridViewDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBpcs003: TfrmBpcs003;
  function SetBpcs003(lsql:string):Boolean;

implementation
Uses pasDm,pasSysRes,pasCodeProc,pasSysQryResultEx,pasQueryDlg,pasGetDate,Com001;
{$R *.DFM}

function SetBpcs003(lsql:string):Boolean;
var
  frmBpcs003: TfrmBpcs003;
begin
  Result:=False;

  frmBpcs003 := TfrmBpcs003.Create(Application);
  try

    frmBpcs003.MasterQuery.SQL.Clear;
    frmBpcs003.MasterQuery.SQL.Add(lSql);
    frmBpcs003.MasterQuery.Open;
    frmBpcs003.Show;

      Result:=True;
  finally
    frmBpcs003.Free;
  end;
end;

procedure TfrmBpcs003.DelCasIsNull;
var
  lSql:String;
  RecordCount:Integer;
begin
  lSql:='SELECT COUNT(*) FROM GWS::CAS_FILE WHERE CAS03 IS NULL';
  RecordCount:=GetRecordCount(lSql);
  if  RecordCount> 0 then begin
    lSql:='DELETE GWS::CAS_FILE WHERE CAS03 IS NULL';
    ExecSqla(lSql);
  end;
end;

procedure TfrmBpcs003.FormClose(Sender: TObject; var Action: TCloseAction);
begin


  if MasterQuery.State IN [dsEdit,dsInsert] then
     MasterQuery.Post;

  if MasterQuery.UpdatesPending then
     MasterQuery.ApplyUpdates;

  if DetailQuery.State IN [dsEdit,dsInsert] then
      DetailQuery.Post;

  if DetailQuery.UpdatesPending then
     DetailQuery.ApplyUpdates;

  Action:=caFree;
end;

procedure TfrmBpcs003.MasterQueryAfterScroll(DataSet: TDataSet);
var
 lSql,CatNo:String;
begin
  CatNo:= DataSet.Fields[0].AsString;
  lSql:='SELECT * FROM GWS::CAS_FILE WHERE CAS01=''%S'' ORDER BY CAS02';
  if DetailQuery.Active then DetailQuery.Close;
  DetailQuery.SQL.Clear;
  DetailQuery.SQL.Add(Format(lSql,[CatNo]));
  DetailQuery.Open;
end;

procedure TfrmBpcs003.FormCreate(Sender: TObject);
begin
  MasterQuery.Open;
  deCat01.DataField:='Cat01';
  deCat02.DataField:='Cat02';
  deCat03.DataField:='Cat03';
  deCat04.DataField:='Cat04';
  deCat05.DataField:='Cat05';
  deCat06.DataField:='Cat06';
  deCat07.DataField:='Cat07';
  deCat061.DataField:='Cat061';
  deCat071.DataField:='Cat071';
  deCat08.DataField:='Cat08';
  deCat09.DataField:='Cat09';
  deCat10.DataField:='Cat10';
  deCat11.DataField:='Cat11';
  deCat12.DataField:='Cat12';
  deCat13.DataField:='Cat13';
  deCat14.DataField:='Cat14';
  deCat15.DataField:='Cat15';
  deCat16.DataField:='Cat16';
  deCat17.DataField:='Cat17';
  deCat18.DataField:='Cat18';
  deCat19.DataField:='Cat19';
  deCat20.DataField:='Cat20';
  deCat21.DataField:='Cat21';
  deCat22.DataField:='Cat22';
  deCat23.DataField:='Cat23';
  deCat24.DataField:='Cat24';
  deCat25.DataField:='Cat25';

end;

procedure TfrmBpcs003.DetailQueryNewRecord(DataSet: TDataSet);
var
  lSql,MasterCatID:String;
  CatNumber:String[10];
  OldNo,NewNo:Integer;
begin

  MasterCatID:=MasterQuery.Fields[0].AsString;
  if MasterCatID<>'' then begin
  CatNumber:=MasterQuery.FieldByName('cat01').AsString;
  lSql:='SELECT NVL(MAX(CAS02),0) FROM GWS::CAS_FILE WHERE CAS01=''%S''';
  OldNo:=GetRecordValueInt(Format(lSql,[CatNumber]));
  NewNo:=OldNo+1;

   with Dataset do
   begin
     FieldByName('cas01').AsString:= MasterCatID;
     FieldByName('cas02').AsInteger:= NewNo;
     FieldByName('cas08').AsString:= 'N';
   end;

   if DetailQuery.State IN [dsEdit,dsInsert] then begin
      DetailQuery.Post;
      if DetailQuery.UpdatesPending then
         DetailQuery.ApplyUpdates;
   end;
  end else begin
   abort;
  end; 
end;

procedure TfrmBpcs003.tbSaveClick(Sender: TObject);
begin
  if MasterQuery.State IN [dsEdit,dsInsert] then
     MasterQuery.Post;

  if MasterQuery.UpdatesPending then
     MasterQuery.ApplyUpdates;

  if DetailQuery.State IN [dsEdit,dsInsert] then
      DetailQuery.Post;

  if DetailQuery.UpdatesPending then
     DetailQuery.ApplyUpdates;
end;

procedure TfrmBpcs003.DetailQueryAfterOpen(DataSet: TDataSet);

begin
  with Dataset do
  begin
    FieldByName('cas01').Visible:=False;
    FieldByName('cas02').DisplayWidth:=6;
    FieldByName('cas02').Alignment:=taCenter;
    FieldByName('cas01').DisplayLabel:='備案號';
    FieldByName('cas02').DisplayLabel:='項次';
    FieldByName('cas03').DisplayLabel:='產品品號';
    FieldByName('cas031').DisplayLabel:='品號描述';
    FieldByName('cas04').DisplayLabel:='數量';
    FieldByName('cas05').DisplayLabel:='價格';
    FieldByName('cas06').DisplayLabel:='金額';
    FieldByName('cas07').DisplayLabel:='備註';
    FieldByName('cas08').DisplayLabel:='作廢';
  end;
  DBGrid.Columns[0].FieldName:='Cas02';
  DBGrid.Columns[1].FieldName:='Cas03';
  DBGrid.Columns[2].FieldName:='Cas031';
  DBGrid.Columns[3].FieldName:='Cas04';
  DBGrid.Columns[4].FieldName:='Cas05';
  DBGrid.Columns[5].FieldName:='Cas06';
  DBGrid.Columns[6].FieldName:='Cas07';
  DBGrid.Columns[7].FieldName:='Cas08';



end;

procedure TfrmBpcs003.ToolButton10Click(Sender: TObject);
begin
  frmBpcs003.Close;
end;

procedure TfrmBpcs003.MasterQueryAfterOpen(DataSet: TDataSet);
begin
 if DetailQuery.Active then DetailQuery.Close;
   DetailQuery.Open;
  with DataSet do
  begin
    FieldByName('cat01').DisplayLabel:='報備編號';
    FieldByName('cat02').DisplayLabel:='報備日期';
    FieldByName('cat03').DisplayLabel:='客戶類別';
    FieldByName('cat04').DisplayLabel:='經銷商號';
    FieldByName('cat05').DisplayLabel:='簡稱';
    FieldByName('cat06').DisplayLabel:='部門';
    FieldByName('cat061').DisplayLabel:='部門描述';
    FieldByName('cat07').DisplayLabel:='業務員號';
    FieldByName('cat071').DisplayLabel:='名字';
    FieldByName('cat08').DisplayLabel:='終端客戶';
    FieldByName('cat09').DisplayLabel:='使用者';
    FieldByName('cat10').DisplayLabel:='經銷電話';
    FieldByName('cat11').DisplayLabel:='業務電話';
    FieldByName('cat12').DisplayLabel:='郵件地址';
    FieldByName('cat13').DisplayLabel:='主要應用';
    FieldByName('cat14').DisplayLabel:='原報價日';
    FieldByName('cat15').DisplayLabel:='預結案日';
    FieldByName('cat16').DisplayLabel:='立案';
    FieldByName('cat17').DisplayLabel:='立案日';
    FieldByName('cat18').DisplayLabel:='競爭者';
    FieldByName('cat19').DisplayLabel:='廠牌';
    FieldByName('cat20').DisplayLabel:='同行';
    FieldByName('cat21').DisplayLabel:='自家競爭者';
    FieldByName('cat22').DisplayLabel:='追蹤日期';
    FieldByName('cat23').DisplayLabel:='接單';
    FieldByName('cat24').DisplayLabel:='結案';
    FieldByName('cat25').DisplayLabel:='說明';
    FieldByName('cat26').DisplayLabel:='輸入人員';
  end;
  with DBGridView  do
  begin
    Columns[0].FieldName:='Cat01';
    Columns[1].FieldName:='Cat05';
    Columns[2].FieldName:='Cat061';
    Columns[3].FieldName:='Cat071';
    Columns[4].FieldName:='Cat10';
    Columns[5].FieldName:='Cat11';
    Columns[6].FieldName:='Cat17';
    Columns[7].FieldName:='Cat16';
    Columns[8].FieldName:='Cat23';
    Columns[9].FieldName:='Cat24';
    Columns[10].FieldName:='Cat26';
  end;
end;

procedure TfrmBpcs003.MasterQueryNewRecord(DataSet: TDataSet);
var
  lSql:String;
  OldID,NewID:Integer;
begin
   lSql:='SELECT NVL(MAX(CAST (CAT01[8,10] AS Integer)),0) FROM GWS::CAT_FILE WHERE CAT02=''%S''';
   OldID:=GetRecordValueInt(Format(lSql,[FormatDatetime('yyyy/mm/dd',date)]));
   NewID:=OldID+1;

  with DataSet do
  begin
    FieldByName('cat01').AsString:= FormatDatetime('yymmdd',date)+'-'+IntToStr(NewID);
    FieldByName('cat02').AsString:= FormatDatetime('yyyy/mm/dd',date);
    FieldByName('cat16').AsString:= 'N';
    FieldByName('cat23').AsString:= 'N';
    FieldByName('cat24').AsString:= 'N';
    FieldByName('cat26').AsString:= UserID;
  end;

  if MasterQuery.State IN [dsEdit,dsInsert] then
     MasterQuery.Post;

  if MasterQuery.UpdatesPending then
     MasterQuery.ApplyUpdates;

end;

procedure TfrmBpcs003.DetailQueryBeforeInsert(DataSet: TDataSet);
var
  CatClose,CatOk:String;
begin
  CatClose:=MasterQuery.FieldByName('cat24').AsString;
  CatOk   :=MasterQuery.FieldByName('cat23').AsString;
  if (CatClose='Y') or (CatOk='Y') then begin
    abort;
  end else begin
    if MasterQuery.Fields[0].AsString<>'' then begin
     if DetailQuery.State IN [dsEdit,dsInsert] then begin
        DetailQuery.Post;
        if DetailQuery.UpdatesPending then
         DetailQuery.ApplyUpdates;
     end;
    end else begin
      abort;
    end;
  end;   
end;

procedure TfrmBpcs003.MasterQueryBeforeDelete(DataSet: TDataSet);
var
  lSql,CatID,CatClose,CatOk:String;
begin
  CatClose:=MasterQuery.FieldByName('cat24').AsString;
  CatOk   :=MasterQuery.FieldByName('cat23').AsString;
  if (CatClose='Y') or (CatOk='Y') then begin
    abort;
  end else begin
    if DetailQuery.State IN [dsEdit,dsInsert] then
      DetailQuery.Post;

    if DetailQuery.UpdatesPending then
     DetailQuery.ApplyUpdates;

    CatID:=DataSet.FieldbyName('cat01').asString;
    lSql:='SELECT COUNT(*) FROM GWS::CAS_FILE WHERE CAS01=''%S''';
    if GetRecordCount(Format(lSql,[CatID]))>0 then begin
      Application.MessageBox(Pchar((Format('%S, " %s " 單身有資料不能刪除！',[Username,CatID]))),'提示',MB_ICONINFORMATION+MB_OK);
      abort;
    end;
  end;
end;

procedure TfrmBpcs003.MasterQueryBeforeInsert(DataSet: TDataSet);
begin
   if MasterQuery.State IN [dsEdit,dsInsert] then begin
       MasterQuery.Post;
      if MasterQuery.UpdatesPending then
        MasterQuery.ApplyUpdates;
   end;

end;

procedure TfrmBpcs003.CheckAgent;
var
  AgentNo,AgentDesc,lSql:String;
begin
  if MasterQuery.State IN [dsEdit,dsInsert] then begin
    lSql:='SELECT OCC01 AS 編號,OCC02 AS 簡稱 FROM DS2::OCC_FILE WHERE OCC01 LIKE ''%S'' ORDER BY 1';
    GetQueryDlg('找經銷商','請輸入經銷商',deCat04.Text,lSql,AgentNo,AgentDesc);
    if AgentNo<>'' then begin
     MasterQuery.Fields.FieldByName('cat04').asString:=AgentNo;
     MasterQuery.Fields.FieldByName('cat05').asString:=AgentDesc;
    end; 
  end;
end;

procedure TfrmBpcs003.CheckDept;
var
  DeptNo,DeptDesc,lSql:String;
begin
  if MasterQuery.State IN [dsEdit,dsInsert] then begin
    lSql:='SELECT OAB01 AS 編號,OAB02 AS 簡稱 FROM DS2::OAB_FILE WHERE OAB01 LIKE ''%S'' ORDER BY 1';
    GetQueryDlg('部門','請輸入部門',deCat06.Text,lSql, DeptNo,DeptDesc);
    if DeptNo<>'' then  begin
     MasterQuery.Fields.FieldByName('cat06').asString:=DeptNo;
     MasterQuery.Fields.FieldByName('cat061').asString:=DeptDesc;
    end;
  end;
end;

procedure TfrmBpcs003.CheckEmp;
var
  EmpNo,EmpDesc,lSql:String;
begin
  if MasterQuery.State IN [dsEdit,dsInsert] then begin
    lSql:='SELECT GEN01 AS 編號,GEN02 AS 名字 FROM DS2::GEN_FILE WHERE GEN02 LIKE ''%S'' ORDER BY 1';
    GetQueryDlg('業務員','請輸入名字',deCat07.Text,lSql,EmpNo,EmpDesC);
    if EmpNo<>'' then begin
     MasterQuery.Fields.FieldByName('cat07').asString:=EmpNo;
     MasterQuery.Fields.FieldByName('cat071').asString:=EmpDesc;
    end;
  end;

end;

procedure TfrmBpcs003.DBGridEditButtonClick(Sender: TObject);
var
  Modeno,ModeDesc,lSql:String;
begin
  if DetailQuery.State IN [dsEdit,dsInsert] then begin
    DetailQuery.Post;
    lSql:='SELECT IMA01 AS 編號,IMA02 AS 描述        '+
          '  FROM DS2::IMA_FILE                      '+
          ' WHERE IMA01[1,2]   IN (''01'',''03'')    '+
          '   AND IMA08=''M''                        '+
          '   AND IMA01 LIKE ''%S'' ORDER BY 1';
    GetQueryDlg('查詢料號','請輸入品名',DBgrid.SelectedField.AsString,lSql, Modeno,ModeDesc);
    if Modeno<>'' then begin

     if DetailQuery.State  IN [dsEdit,dsInsert] then begin
       DetailQuery.Fields.FieldByName('cas03').asString:=Modeno;
       DetailQuery.Fields.FieldByName('cas031').asString:=ModeDesc;
     end else begin
       DetailQuery.Edit;
       DetailQuery.Fields.FieldByName('cas03').asString:=Modeno;
       DetailQuery.Fields.FieldByName('cas031').asString:=ModeDesc;
     end;
    end;
  end;

end;

procedure TfrmBpcs003.ToolButton4Click(Sender: TObject);
var
 lSql,BeginDate,EndDate:String;
begin
  if MasterQuery.State IN [dsEdit,dsInsert] then
     MasterQuery.Post;

  if MasterQuery.UpdatesPending then
     MasterQuery.ApplyUpdates;

  if DetailQuery.State IN [dsEdit,dsInsert] then
      DetailQuery.Post;

  if DetailQuery.UpdatesPending then
     DetailQuery.ApplyUpdates;

  if ShowGetDate('經銷商備案資料查詢', BeginDate,EndDate) then begin
    lSql:='SELECT * FROM GWS::CAT_FILE WHERE CAT02 BETWEEN ''%S'' AND ''%S'' ORDER BY CAT01 DESC';
    if MasterQuery.Active then  MasterQuery.Close;
    MasterQuery.SQL.Clear;
    MasterQuery.SQL.Add(Format(lSql,[BeginDate,EndDate]));
    MasterQuery.Open;
  end;
end;

procedure TfrmBpcs003.DetailQueryBeforeEdit(DataSet: TDataSet);
var
  CatClose,CatOk:String;
begin
  if MasterQuery.State IN [dsEdit,dsInsert] then
   MasterQuery.Post;
   
   if MasterQuery.UpdatesPending then
    MasterQuery.ApplyUpdates;

  if DetailQuery.UpdatesPending then
    DetailQuery.ApplyUpdates;

  CatClose:=MasterQuery.FieldByName('cat24').AsString;
  CatOk   :=MasterQuery.FieldByName('cat23').AsString;
  if (CatClose='Y') or (CatOk='Y') then begin
    abort;
  end;
end;

procedure TfrmBpcs003.DetailQueryBeforePost(DataSet: TDataSet);

begin
  DataSet.FieldByName('cas06').AsCurrency:=
  DataSet.FieldByName('cas04').AsCurrency *
  DataSet.FieldByName('cas05').AsCurrency;

end;

procedure TfrmBpcs003.DetailQueryBeforeDelete(DataSet: TDataSet);
var
  strCas01,strCas02,CatClose,CatOk:String;
begin
  CatClose:=MasterQuery.FieldByName('cat24').AsString;
  CatOk   :=MasterQuery.FieldByName('cat23').AsString;
  if (CatClose='Y') or (CatOk='Y') then begin
    abort;
  end else begin
    strCas01:=DataSet.Fields[0].AsString;
    strCas02:=DataSet.Fields[1].AsString;
    if Application.MessageBox(PChar(Format('%S , 你確認要刪除 "%S" , 第 "%S" 項 ?',[username,strCas01,strCas02])),'確認',MB_ICONQUESTION+MB_YESNO)=ID_NO then begin
      Abort
    end;
  end;
end;

procedure TfrmBpcs003.Button4Click(Sender: TObject);
var
  lSql,CatNo,CatYN,CatClose,CatOk:String;
begin
  CatNo:=MasterQuery.FieldByName('cat01').AsString;
  CatYN:=MasterQuery.FieldByName('cat16').AsString;
  CatOk:=MasterQuery.FieldByName('cat23').AsString;
  CatClose:=MasterQuery.FieldByName('cat24').AsString;

  if CatClose='N' then begin
    if CatOk ='N' then begin
     if CatYN='N' then begin
       if Application.MessageBox(PChar(Format('%S , "%s" 確認立案 ?',[username,CatNo])),'確認',MB_ICONQUESTION+MB_YESNO)=ID_YES then begin
        lsql:='UPDATE GWS::CAT_FILE  SET CAT16=''Y'' , CAT17=TODAY WHERE CAT16=''N'' AND CAT01=''%S''';
        ExecSqla(Format(lSql,[CatNo]));
         if MasterQuery.State in [dsEdit,dsInsert] then begin
           MasterQuery.FieldByName('cat16').AsString:='Y';
           MasterQuery.FieldByName('cat17').AsDateTime:=Date;
         end else begin
           MasterQuery.Edit;
           MasterQuery.FieldByName('cat16').AsString:='Y';
           MasterQuery.FieldByName('cat17').AsDateTime:=Date;           
         end;
       end;
    end else begin
     Application.MessageBox(PChar(Format('%S , "%S" 已經立案。',[username,CatNo])),'確認',MB_ICONINFORMATION+MB_OK);
    end;
  end;
 end;
end;

procedure TfrmBpcs003.Button5Click(Sender: TObject);
var
  lSql,CatOk,CatYn,CatNo,CatClose:String;
begin
  CatNo:=MasterQuery.FieldByName('cat01').AsString;
  CatYn:=MasterQuery.FieldByName('cat16').AsString;
  CatOk:=MasterQuery.FieldByName('cat23').AsString;
  CatClose:=MasterQuery.FieldByName('cat24').AsString;
  if CatClose = 'N' then begin
   if CatYN='Y' then begin
     if  CatOk='N' then begin
       if Application.MessageBox(PChar(Format('%S , 備案 "%s" 成功接單 ?',[username,CatNo])),'確認',MB_ICONQUESTION+MB_YESNO)=ID_YES then begin
         lsql:='UPDATE GWS::CAT_FILE  SET CAT23=''Y'' WHERE CAT23=''N'' AND CAT01=''%S''';
         ExecSqla(Format(lSql,[CatNo]));
         if MasterQuery.State in [dsEdit,dsInsert] then begin
           MasterQuery.FieldByName('cat23').AsString:='Y';
         end else begin
           MasterQuery.Edit;
           MasterQuery.FieldByName('caT23').AsString:='Y';
         end;
       end;
     end;
   end else begin
    Application.MessageBox(PChar(Format('%S , "%S" 未立案。',[username,CatNo])),'確認',MB_ICONINFORMATION+MB_OK);
   end;
  end;
end;

procedure TfrmBpcs003.Button6Click(Sender: TObject);
var
  lSql,CatOk,CatYn,CatNo,CatClose:String;
begin
  CatNo:=MasterQuery.FieldByName('cat01').AsString;
  CatYn:=MasterQuery.FieldByName('cat16').AsString;
  CatClose:=MasterQuery.FieldByName('cat24').AsString;
  CatOk:=MasterQuery.FieldByName('cat23').AsString;

  if CatClose='N' then begin
    if  CatOk='N' then begin
       if Application.MessageBox(PChar(Format('%S , 報備 "%s" 確認結案 ?',[username,CatNo])),'確認',MB_ICONQUESTION+MB_YESNO)=ID_YES then begin
         lsql:='UPDATE GWS::CAT_FILE  SET CAT24=''Y'' WHERE CAT24=''N'' AND CAT01=''%S''';
         ExecSqla(Format(lSql,[CatNo]));
         if MasterQuery.State in [dsEdit,dsInsert] then begin
           MasterQuery.FieldByName('cat24').AsString:='Y';
         end else begin
           MasterQuery.Edit;
           MasterQuery.FieldByName('caT24').AsString:='Y';
         end;
       end;
    end else begin
      Application.MessageBox(PChar(Format('%S , "%S" 已接單不能結案。',[username,CatNo])),'確認',MB_ICONINFORMATION+MB_OK);
    end;
  end else begin
   Application.MessageBox(PChar(Format('%S , "%S" 已結案。',[username,CatNo])),'確認',MB_ICONINFORMATION+MB_OK);
  end;

end;

procedure TfrmBpcs003.Button8Click(Sender: TObject);
var
  lSql,CatNo:String;
begin
  lSql:='SELECT * FROM GWS::CAT_FILE WHERE CAT01=''%S''';
  GetQueryWhere('經銷商備案資料','請輸入備案編號',CatNo,False);
  if CatNo<>'' then begin
    if MasterQuery.Active then MasterQuery.Close;
    MasterQuery.SQL.Clear;
    MasterQuery.SQL.Add(Format(lSql,[CatNo]));
    MasterQuery.Open;
  end;  
end;

procedure TfrmBpcs003.Button7Click(Sender: TObject);
var
  lSql,CatOk,CatYn,CatNo,CatClose,CasClose,CasItem:String;
begin
  CatNo:=MasterQuery.FieldByName('cat01').AsString;
  CatYn:=MasterQuery.FieldByName('cat16').AsString;
  CatClose:=MasterQuery.FieldByName('cat24').AsString;
  CatOk:=MasterQuery.FieldByName('cat23').AsString;
  CasClose:=DetailQuery.FieldByName('cas08').AsString;
  CasItem :=DetailQuery.FieldByName('cas02').AsString;

  if CatClose='N' then begin
    if  CatOk='N' then begin
     if CasClose='N' then begin
       if Application.MessageBox(PChar(Format('%S , 報備 "%s" 第 "%s" 項, 確認作廢 ?',[username,CatNo,CasItem])),'確認',MB_ICONQUESTION+MB_YESNO)=ID_YES then begin
         lsql:='UPDATE GWS::CAS_FILE  SET CAS08=''Y'' WHERE CAS01=''%S'' AND CAS02=''%S'' AND CAS08=''N''';
         ExecSqla(Format(lSql,[CatNo,CasItem]));  
         if DetailQuery.State in [dsEdit,dsInsert] then begin
           DetailQuery.FieldByName('cas08').AsString:='Y';
         end else begin
           DetailQuery.Edit;
           DetailQuery.FieldByName('cas08').AsString:='Y';
         end;
        end;
     end else begin
         Application.MessageBox(PChar(Format('%S , "%S" "%s" 已作廢。',[username,CatNo,CasItem])),'確認',MB_ICONINFORMATION+MB_OK);
     end;
    end else begin
      Application.MessageBox(PChar(Format('%S , "%S" 已接單不能作廢。',[username,CatNo])),'確認',MB_ICONINFORMATION+MB_OK);
    end;
  end else begin
   Application.MessageBox(PChar(Format('%S , "%S" 已結案。',[username,CatNo])),'確認',MB_ICONINFORMATION+MB_OK);
  end;
  
end;

procedure TfrmBpcs003.MasterQueryBeforeEdit(DataSet: TDataSet);
var
  CatClose,CatOK:String;
begin
  CatClose:=MasterQuery.FieldByName('cat24').AsString;
  CatOk   :=MasterQuery.FieldByName('cat23').AsString;
  if (CatClose='Y') or (CatOk='Y') then begin
    abort;
  end;  
end;

procedure TfrmBpcs003.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
 if Key =#15 THEN  begin   //ctrl+o
   DBGridEditButtonClick(SENDER);
 end;
end;

procedure TfrmBpcs003.deCat04Exit(Sender: TObject);
var
  lSql,ChkValue,GetValue:String;
  GetCount:Integer;
begin
  if MasterQuery.State in [dsEdit,dsInsert] then begin
  ChkValue:=deCat04.Text;
  lSql:='SELECT COUNT(*) FROM DS2::OCC_FILE WHERE OCC01=''%S''';
  GetCount:=GetRecordCount(Format(lSql,[ChkValue]));
  if GetCount<1 then begin
   // if not deCat04.Focused then deCat04.SetFocus;
    Application.MessageBox(PChar(Format('%S , "%S" 資料不存在！',[username,ChkValue])),'確認',MB_ICONINFORMATION+MB_OK);
    Abort;
  end else begin
    lSql:='SELECT OCC02 FROM DS2::OCC_FILE WHERE OCC01=''%S''';
    GetValue:=GetRecordValueStr(Format(lSql,[ChkValue]));
    MasterQuery.Fields.FieldByName('cat05').asString:=GetValue;
  end;
  end;
end;

procedure TfrmBpcs003.deCat04KeyPress(Sender: TObject; var Key: Char);
begin
 if Key =#15 THEN  begin   //ctrl+o
   CheckAgent;
 end;
end;

procedure TfrmBpcs003.deCat06KeyPress(Sender: TObject; var Key: Char);
begin
 if Key =#15 THEN  begin   //ctrl+o
   CheckDept;
 end;
end;

procedure TfrmBpcs003.deCat07KeyPress(Sender: TObject; var Key: Char);
begin
 if Key =#15 THEN  begin   //ctrl+o
   CheckEmp;
 end;
end;

procedure TfrmBpcs003.deCat06Exit(Sender: TObject);
var
  lSql,ChkValue,GetValue:String;
  GetCount:Integer;
begin
  if MasterQuery.State in [dsEdit,dsInsert] then begin
  ChkValue:=deCat06.Text;
  lSql:='SELECT COUNT(*) FROM DS2::OAB_FILE WHERE OAB01=''%S''';
  GetCount:=GetRecordCount(Format(lSql,[ChkValue]));
  if GetCount<1 then begin
    //if not deCat06.Focused then deCat06.SetFocus;
    Application.MessageBox(PChar(Format('%S , "%S" 資料不存在！',[username,ChkValue])),'確認',MB_ICONINFORMATION+MB_OK);
    Abort;
  end else begin
    lSql:='SELECT OAB02 FROM DS2::OAB_FILE WHERE OAB01=''%S''';
    GetValue:=GetRecordValueStr(Format(lSql,[ChkValue]));
    MasterQuery.Fields.FieldByName('cat061').asString:=GetValue;

  end;
  end;
end;

procedure TfrmBpcs003.deCat07Exit(Sender: TObject);
var
  lSql,ChkValue,GetValue:String;
  GetCount:Integer;
begin
  if MasterQuery.State in [dsEdit,dsInsert] then begin
  ChkValue:=deCat07.Text;
  lSql:='SELECT COUNT(*) FROM DS2::GEN_FILE WHERE GEN01=''%S''';
  GetCount:=GetRecordCount(Format(lSql,[ChkValue]));
  if GetCount<1 then begin
    //if not deCat07.Focused then deCat07.SetFocus;
    Application.MessageBox(PChar(Format('%S , "%S" 資料不存在！',[username,ChkValue])),'確認',MB_ICONINFORMATION+MB_OK);
    Abort;
  end else begin
    lSql:='SELECT GEN02 FROM DS2::GEN_FILE WHERE GEN01=''%S''';
    GetValue:=GetRecordValueStr(Format(lSql,[ChkValue]));
    MasterQuery.Fields.FieldByName('cat071').asString:=GetValue;

  end;
  end;
end;

procedure TfrmBpcs003.DBGridColExit(Sender: TObject);
var
  lSql,ChkValue,GetValue:String;
  GetCount:Integer;
begin
  if DBGrid.SelectedIndex  = 1 then  begin
  if DetailQuery.State in [dsEdit,dsInsert] then begin
  ChkValue:=DBGrid.Fields[1].AsString;
  lSql:='SELECT COUNT(*) FROM DS2::IMA_FILE WHERE IMA01=''%S''';
  GetCount:=GetRecordCount(Format(lSql,[ChkValue]));
  if (GetCount<1) or (ChkValue='') then begin
    if not DBGrid.Focused  then DBGrid.SetFocus;
    Application.MessageBox(PChar(Format('%S , "%S" 資料不存在！',[username,ChkValue])),'確認',MB_ICONINFORMATION+MB_OK);
    Abort;
  
  end else begin
    lSql:='SELECT IMA02 FROM DS2::IMA_FILE WHERE IMA01=''%S''';
    GetValue:=GetRecordValueStr(Format(lSql,[ChkValue]));
    DetailQuery.Fields.FieldByName('cas031').asString:=GetValue;

  end;
  end;
  end;
end;

procedure TfrmBpcs003.DetailQueryBeforeOpen(DataSet: TDataSet);
begin
  DelCasIsNull;
end;

procedure TfrmBpcs003.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmBpcs003.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if MasterQuery.Active  then begin
    if key = #14 then
     MasterQuery.Append;
  end;
end;

procedure TfrmBpcs003.DBGridViewDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
 { Case MasterQuery.RecNo Mod 2=0 of
    false:begin
             DBGrid.Canvas.Brush.Color:=clMenu;
           end;
  end;

  DBGrid.Canvas.Pen.Mode:=pmMask;
  DBGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State); }
end;

procedure TfrmBpcs003.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
 { Case DetailQuery.RecNo Mod 2=0 of
    false:begin
             DBGrid.Canvas.Brush.Color:=clMenu;
           end;
  end;

  DBGrid.Canvas.Pen.Mode:=pmMask;
  DBGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State); }
end;

end.
