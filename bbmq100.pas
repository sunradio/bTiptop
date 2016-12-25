unit bbmq100;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxTL, dxDBCtrl, dxCntner, dxDBTL, Db, DBTables, ComCtrls, StdCtrls,
  ToolWin, Grids, Wwdbigrd, Wwdbgrid,FileCtrl,pasMain, ExtCtrls;

type
  TfrmBbmq100 = class(TForm)
    tbASFT110: TToolBar;
    tbRun: TToolButton;
    tbExport: TToolButton;
    qabmq501: TQuery;
    ds_query: TDataSource;
    tlBom: TdxDBTreeList;
    lvl: TdxDBTreeListColumn;
    Parent: TdxDBTreeListColumn;
    child: TdxDBTreeListColumn;
    childDesc: TdxDBTreeListColumn;
    m: TdxDBTreeListColumn;
    p: TdxDBTreeListColumn;
    myunit: TdxDBTreeListColumn;
    usage: TdxDBTreeListColumn;
    location: TdxDBTreeListColumn;
    startsdate: TdxDBTreeListColumn;
    unabledate: TdxDBTreeListColumn;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    lblMsg: TLabel;
    Label1: TLabel;
    txtPartno: TEdit;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    procedure tbRunClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtPartnoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbExportClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tlBomKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBbmq100: TfrmBbmq100;

implementation
uses pasDm,
     pasSysRes,
     pasCodeProc,

     bomcode;
{$R *.DFM}

procedure TfrmBbmq100.tbRunClick(Sender: TObject);
var
  iEndTree,iLvl:Integer;
 
begin
  if txtPartno.Text<>'' then
  begin try
    if GetBomConfirm(txtPartno.Text) then begin
    try
      dm.DB.Execute('CREATE TEMP TABLE TMP_BOMA'+
        ' (LVL   INTEGER,'+
        ' PARENT VARCHAR(15),'+
        ' CHILD  VARCHAR(15),'+
        ' M      VARCHAR(1),'+
        ' P      VARCHAR(1),'+
        ' myUnit VARCHAR(5),'+
        ' Loction VARCHAR(10),'+
        ' StartDate DATE,'+
        ' UnableDate DATE,'+
        ' USAGE  DECIMAL(12,4),'+
        ' BP     VARCHAR(1))');
      dm.DB.Execute('CREATE INDEX IDX_TMP_BOMA ON TMP_BOMA (CHILD)');
    except
      on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then
         dm.DB.Execute('DELETE TMP_BOMA');
    end;



  iEndTree:=0;
  iLvl:=2;
  // 取最高階資料
  // ((A.BMB04>TODAY) AND (A.BMB05<TODAY)) 生效日期必須小于當前日期,失效材料需小于當前日期
  dm.DB.Execute(Format('INSERT INTO TMP_BOMA (LVL,PARENT,CHILD)'+
                 'VALUES(1,''%s'',''%s'')',[txtPartno.text,txtPartno.text]));

  // 取第1階資料
  dm.DB.Execute(Format('INSERT INTO TMP_BOMA (LVL,PARENT,CHILD,USAGE,LOCTION,STARTDATE,UNABLEDATE,BP)'+
                 ' SELECT 2 ,A.BMB01,A.BMB03,A.BMB06,A.BMB13,A.BMB04,A.BMB05,A.BMB19'+
                 ' FROM BMB_FILE A '+
                 ' WHERE A.BMB01=''%s'''+
                 '   AND A.BMB19=''2'''+                 
                 '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL)',[txtPartno.text]));

  while (iEndTree=0) do
  begin
    iLvl:=iLvl+1;
           dm.DB.Execute(Format('INSERT INTO TMP_BOMA(LVL,PARENT,CHILD,USAGE,LOCTION,STARTDATE,UNABLEDATE,BP)'+
          ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB13,A.BMB04,A.BMB05,A.BMB19'+
          ' FROM BMB_FILE A ,TMP_BOMA B ,IMA_FILE C '+
          ' WHERE A.BMB01=B.CHILD '+
          '   AND A.BMB01=C.IMA01'+
          '   AND C.IMA08=''M'''+
          '   AND A.BMB19=''2'''+
          '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[iLvl,iLvl-1]));
    if qabmq501.Active then
       qabmq501.Close;

    qabmq501.SQL.Clear;
    qabmq501.SQL.Add(Format('SELECT LVL FROM TMP_BOMA WHERE LVL =%d',[iLvl]));
    qabmq501.Open;
    
    if (qabmq501.Fields[0].AsInteger>1) then
       iEndTree:=0   // 假如下階還有材料,繼續展下階材料
    else
       iEndTree:=1;  // 假如下階沒有材料,停止展下階材料

  end;

  //dm.DB.Execute('DELETE FROM TMP_BOMA WHERE STARTDATE>TODAY');
  //dm.DB.Execute('DELETE FROM TMP_BOMA WHERE UNABLEDATE<TODAY');

  with qabmq501 do
  begin
    if Active then
       Close;
    SQL.Clear;

    SQL.Add('SELECT PARENT ,  '+
            '       CHILD  ,  '+
            '       IMA08 AS M,'+
            '       CASE BP     WHEN 1 THEN ''-'''+
            '                   WHEN 2 THEN ''+'''+
            '                   WHEN 3 THEN ''*'''+
            '       END AS P,'+
            '       RPAD(TRIM(REPLACE(IMA02,","," ")),50," ") AS CHILDDESC,'+
            '       IMA25 AS MYUNIT,'+
            '       USAGE,RPAD(TRIM(LOCTION),10," ") AS LOCTION,'+
            '       STARTDATE,UNABLEDATE,'+
            '       CAST(LPAD(ROUND(LVL,0),LVL,".") AS CHAR(12)) AS LVL'+

            ' FROM TMP_BOMA A INNER JOIN IMA_FILE B ON A.CHILD=B.IMA01');
    Open;



    with tlBom do
    begin
      KeyField:='child';
      ParentField:='parent';

      Columns[0].FieldName:='parent';
      Columns[1].FieldName:='child';
      Columns[2].FieldName:='m';
      Columns[3].FieldName:='p';
      Columns[4].FieldName:='childdesc';
      Columns[5].FieldName:='myunit';
      Columns[6].FieldName:='usage';
      Columns[7].FieldName:='loction';
      Columns[8].FieldName:='startdate';
      Columns[9].FieldName:='unabledate';
      Columns[10].FieldName:='lvl';
    end;

    with qabmq501 do
    begin
      Fields[0].DisplayLabel:='父階料號';
      Fields[1].DisplayLabel:='子階料號';
      Fields[2].DisplayLabel:='來源碼';
      Fields[3].DisplayLabel:='展階碼';
      Fields[4].DisplayLabel:='品名描述';
      Fields[5].DisplayLabel:='單位';
      Fields[6].DisplayLabel:='用量';
      Fields[7].DisplayLabel:='插件位置';
      Fields[8].DisplayLabel:='生效日期';
      Fields[9].DisplayLabel:='失效日期';
      Fields[10].DisplayLabel:='階層';
    end;
   end;
  end;
  except
    on e:EDBEngineError do
    begin
      ShowMessage(Inttostr(e.Errors[0].ErrorCode)); //BDE ERROR CODENO
      ShowMessage(e.Errors[0].Message);             //BDE ERROR MSG
      ShowMessage(e.Errors[1].Message);             //SERVER ERROR MSG
      //for
      case e.Errors[1].NativeError of               //MY ERROR MSG
        -201:showmessage('sql error');
        -951:showmessage('login error');
      end;
    end;
  end;
  end;
end;

procedure TfrmBbmq100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qabmq501.Active then
     qabmq501.Close;
  Action:=caFree;
end;

procedure TfrmBbmq100.txtPartnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    tbRunClick(Sender);

end;

procedure TfrmBbmq100.tbExportClick(Sender: TObject);
var
  lSaveDialog: TSaveDialog;
  sFilePath:String;
begin
  lSaveDialog := nil;
  try
  begin
    sFilepath:=ExtractFileDir(Application.ExeName)+'\Output\';
    lSaveDialog := TSaveDialog.Create(self);
    lSaveDialog.DefaultExt := 'txt';
    lSaveDialog.Filter := 'Excel File (*.csv)|*.csv|All File (*.*)|*.*';
    lSaveDialog.Title:='保存EBOM 文件';
    lSaveDialog.Options:=[ofOverwritePrompt,ofHideReadOnly,ofEnableSizing];

    if not DirectoryExists(sFilePath) then
    begin
     if not CreateDir(sFilePath) then
         Application.MessageBox(PChar(Format('不能創建目錄 %s !',[sFilePath])),
                                    PChar(gErrCaption),MB_ICONERROR+MB_OK)
     else
       lSaveDialog.InitialDir:=sFilePath;
    end
    else
      lSaveDialog.InitialDir:=sFilePath;
      
    if lSaveDialog.Execute then
    begin
      tlBom.SaveAllToTextFile(lSaveDialog.FileName);
    end;
  end
  finally
    lSaveDialog.free;
  end;
end;

procedure TfrmBbmq100.ToolButton1Click(Sender: TObject);
begin
  tlBom.FullCollapse;
end;

procedure TfrmBbmq100.ToolButton2Click(Sender: TObject);
begin
    tlBom.FullExpand;
end;

procedure TfrmBbmq100.ToolButton5Click(Sender: TObject);
begin
    ShowExportOpen(qabmq501,Format('bbmq100_%s',[txtPartno.text]),'bbmq100 - 多階材料用量查詢');
end;

procedure TfrmBbmq100.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmBbmq100.tlBomKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    if not tlBom.FocusedNode.Expanded then
       tlBom.FocusedNode.Expand(False)
    else
       tlBom.FocusedNode.Collapse(False);
end;

end.
