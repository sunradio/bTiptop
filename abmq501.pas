unit Abmq501;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxTL, dxDBCtrl, dxCntner, dxDBTL, Db, DBTables, ComCtrls, StdCtrls,
  ToolWin, Grids, Wwdbigrd, Wwdbgrid,FileCtrl, ExtCtrls,pasMain;

type
  TfrmAbmq501 = class(TForm)
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
    ToolButton5: TToolButton;
    bp: TdxDBTreeListColumn;
    Panel1: TPanel;
    Image1: TImage;
    txtPartno: TEdit;
    lblWoNo: TLabel;
    cbSle: TCheckBox;
    ToolButton6: TToolButton;
    Image2: TImage;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
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
    procedure cbSleClick(Sender: TObject);
    procedure tlBomKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbmq501: TfrmAbmq501;

implementation
uses pasDm,
     pasSysRes,
     pasCodeProc,

     bomcode;
{$R *.DFM}

procedure TfrmAbmq501.tbRunClick(Sender: TObject);
var
  iEndTree,iLvl:Integer;
 
begin
  if txtPartno.Text<>'' then  begin
  try
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
  // ���̰������
  // ((A.BMB04>TODAY) AND (A.BMB05<TODAY)) �ͮĤ�������p�_��e���,���ħ��ƻݤp�_��e���
  dm.DB.Execute(Format('INSERT INTO TMP_BOMA (LVL,PARENT,CHILD)'+
                 'VALUES(1,''%s'',''%s'')',[txtPartno.text,txtPartno.text]));

  // ����1�����
  dm.DB.Execute(Format('INSERT INTO TMP_BOMA (LVL,PARENT,CHILD,USAGE,LOCTION,STARTDATE,UNABLEDATE,BP)'+
                 ' SELECT 2 ,A.BMB01,A.BMB03,A.BMB06,A.BMB13,A.BMB04,A.BMB05,A.BMB19'+
                 ' FROM BMB_FILE A'+
                 ' WHERE A.BMB01=''%s'' AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL)',[txtPartno.text]));

  while (iEndTree=0) do
  begin
    iLvl:=iLvl+1;
    // P�NP�����D,�[�J������
    if cbSle.Checked then
      dm.DB.Execute(Format('INSERT INTO TMP_BOMA(LVL,PARENT,CHILD,USAGE,LOCTION,STARTDATE,UNABLEDATE,BP)'+
          ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB13,A.BMB04,A.BMB05,A.BMB19'+
          ' FROM BMB_FILE A ,TMP_BOMA B '+
          ' WHERE A.BMB01=B.CHILD  AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[iLvl,iLvl-1]))
    else
      dm.DB.Execute(Format('INSERT INTO TMP_BOMA(LVL,PARENT,CHILD,USAGE,LOCTION,STARTDATE,UNABLEDATE,BP)'+
          ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB13,A.BMB04,A.BMB05,A.BMB19'+
          ' FROM BMB_FILE A ,TMP_BOMA B ,IMA_FILE C'+
          ' WHERE A.BMB01=B.CHILD AND A.BMB01=C.IMA01 AND C.IMA08=''M'' AND C.IMA110<>''1'''+
          '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[iLvl,iLvl-1]));


    if qabmq501.Active then
       qabmq501.Close;

    qabmq501.SQL.Clear;
    qabmq501.SQL.Add(Format('SELECT LVL FROM TMP_BOMA WHERE LVL =%d',[iLvl]));
    qabmq501.Open;
    
    if (qabmq501.Fields[0].AsInteger>1) then
       iEndTree:=0   // ���p�U���٦�����,�~��i�U������
    else
       iEndTree:=1;  // ���p�U���S������,����i�U������

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
            '       CASE IMA110 WHEN 1 THEN ''-'''+
            '                   WHEN 2 THEN ''+'''+
            '                   WHEN 3 THEN ''*'''+
            '       END AS P,'+
            '       RPAD(TRIM(REPLACE(IMA02,","," ")),50," ") AS CHILDDESC,'+
            '       IMA25 AS MYUNIT,'+
            '       USAGE,RPAD(TRIM(LOCTION),10," ") AS LOCTION,'+
            '       STARTDATE,UNABLEDATE,'+
            '       CAST(LPAD(ROUND(LVL,0),LVL,".") AS CHAR(12)) AS LVL,'+
            '       CASE BP     WHEN 1 THEN ''-'''+
            '                   WHEN 2 THEN ''+'''+
            '                   WHEN 3 THEN ''*'''+
            '       END AS BP'+
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
      Columns[11].FieldName:='bp';
    end;

    with qabmq501 do
    begin
      Fields[0].DisplayLabel:='�����Ƹ�';
      Fields[1].DisplayLabel:='�l���Ƹ�';
      Fields[2].DisplayLabel:='�ӷ��X';
      Fields[3].DisplayLabel:='�i���X';
      Fields[4].DisplayLabel:='�~�W�y�z';
      Fields[5].DisplayLabel:='���';
      Fields[6].DisplayLabel:='�ζq';
      Fields[7].DisplayLabel:='�����m';
      Fields[8].DisplayLabel:='�ͮĤ��';
      Fields[9].DisplayLabel:='���Ĥ��';
      Fields[10].DisplayLabel:='���h';
      Fields[11].DisplayLabel:='BOM �i���X';
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

procedure TfrmAbmq501.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qabmq501.Active then
     qabmq501.Close;
  Action:=caFree;
end;

procedure TfrmAbmq501.txtPartnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    tbRunClick(Sender);

end;

procedure TfrmAbmq501.tbExportClick(Sender: TObject);
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
    lSaveDialog.Title:='�O�sEBOM ���';
    lSaveDialog.Options:=[ofOverwritePrompt,ofHideReadOnly,ofEnableSizing];

    if not DirectoryExists(sFilePath) then
    begin
     if not CreateDir(sFilePath) then
         Application.MessageBox(PChar(Format('����Ыإؿ� %s !',[sFilePath])),
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

procedure TfrmAbmq501.ToolButton1Click(Sender: TObject);
begin
  tlBom.FullCollapse;
end;

procedure TfrmAbmq501.ToolButton2Click(Sender: TObject);
begin
    tlBom.FullExpand;
end;

procedure TfrmAbmq501.ToolButton5Click(Sender: TObject);
begin
    ShowExportOpen(qabmq501,Format('abmq501_%s',[txtPartno.text]),'abmq501 - �h�����ƥζq�d��');
end;

procedure TfrmAbmq501.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAbmq501.cbSleClick(Sender: TObject);
begin
  if cbSle.Checked then
  begin
     cbSle.Caption:='  ���\P�NP';
     cbSle.Font.Color:=clNavy;
  end
  else
  begin
    cbSle.Caption:='  �����\P�NP';
    cbSle.Font.Color:=clRed;

  end;
end;

procedure TfrmAbmq501.tlBomKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    if not tlBom.FocusedNode.Expanded then
       tlBom.FocusedNode.Expand(False)
    else
       tlBom.FocusedNode.Collapse(False);
end;

end.
