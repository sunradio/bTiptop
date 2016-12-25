unit Abmr622;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxTL, dxDBCtrl, dxCntner, dxDBTL, Db, DBTables, ComCtrls, StdCtrls,
  ToolWin, Grids, Wwdbigrd, Wwdbgrid,FileCtrl, ExtCtrls,pasMain;

type
  TfrmAbmr622 = class(TForm)
    tbASFT110: TToolBar;
    tbRun: TToolButton;
    qAbmr622: TQuery;
    ds_query: TDataSource;
    ToolButton5: TToolButton;
    DBGrid: TwwDBGrid;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    tbRemove: TToolButton;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
    txtPartno: TEdit;
    cbSle: TCheckBox;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
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
    procedure ToolButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbSleClick(Sender: TObject);
    procedure DBGridDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbmr622: TfrmAbmr622;

implementation
uses pasDm,
     pasSysRes,
     pasCodeProc,

     BomCode;
{$R *.DFM}

procedure TfrmAbmr622.tbRunClick(Sender: TObject);
var
  iEndTree,iLvl:Integer;
begin
  if txtPartno.Text<>'' then   begin
  try
    if GetBomConfirm(txtPartno.Text) then begin
      try
        dm.DB.Execute('CREATE TEMP TABLE TMP_BOM'+
        ' (LVL   INTEGER,'+
        ' PARENT VARCHAR(15),'+
        ' CHILD  VARCHAR(15),'+
        ' Unit VARCHAR(5),'+
        ' StartDate DATE,'+
        ' UnableDate DATE,'+
        ' USAGE  DECIMAL(12,4),'+
        ' ITMNO  VARCHAR(2),'+
        ' BP     VARCHAR(1))');
        dm.db.Execute('CREATE INDEX IDX_TMP_BOM ON TMP_BOM (CHILD)');
       except
       on e:EDBEngineError do
       if e.Errors[1].NativeError=-958 then
          dm.DB.Execute('DELETE TMP_BOM');
       end;

       iEndTree:=0;
       iLvl:=1;

       // 取第1階資料
       dm.DB.Execute(Format('INSERT INTO TMP_BOM (LVL,PARENT,CHILD,USAGE,STARTDATE,UNABLEDATE,UNIT,BP)'+
                 ' SELECT 1 ,A.BMB01,A.BMB03,A.BMB06,A.BMB04,A.BMB05,A.BMB10,A.BMB19'+
                 ' FROM BMB_FILE A'+
                 ' WHERE A.BMB01=''%s'''+
                 '   AND (BMB04<=TODAY OR BMB04 IS NULL) '+
                 '   AND (BMB05>TODAY  OR BMB05 IS NULL)',[txtPartno.text]));

        while (iEndTree=0) do
        begin
          iLvl:=iLvl+1;
          // P代P的問題,加入條件選擇
         if cbSle.Checked then
           dm.DB.Execute(Format('INSERT INTO TMP_BOM(LVL,PARENT,CHILD,USAGE,STARTDATE,UNABLEDATE,UNIT,BP)'+
                                ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB04,A.BMB05,A.BMB10,A.BMB19'+
                                ' FROM BMB_FILE A ,TMP_BOM B '+
                                ' WHERE A.BMB01=B.CHILD  '+
                                '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[iLvl,iLvl-1]))
         else
           dm.DB.Execute(Format('INSERT INTO TMP_BOM(LVL,PARENT,CHILD,USAGE,STARTDATE,UNABLEDATE,UNIT,BP)'+
                                ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB04,A.BMB05,A.BMB10,A.BMB19'+
                                ' FROM BMB_FILE A ,TMP_BOM B,IMA_FILE C'+
                                ' WHERE A.BMB01=B.CHILD '+
                                '   AND B.BP<>''1'''+
                                '   AND A.BMB01=C.IMA01'+
                                '   AND C.IMA08=''M'''+
                                '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[iLvl,iLvl-1]));



         if qAbmr622.Active then
            qAbmr622.Close;

         qAbmr622.SQL.Clear;
         qAbmr622.SQL.Add(Format('SELECT LVL FROM TMP_BOM WHERE LVL =%d',[iLvl]));
         qAbmr622.Open;

         if (qAbmr622.RecordCount>1) then
           iEndTree:=0   // 假如下階還有材料,繼續展下階材料
         else
           iEndTree:=1;  // 假如下階沒有材料,停止展下階材料

       end;

     dm.DB.Execute('UPDATE TMP_BOM SET ITMNO=(SELECT CTA_ITMC FROM GWS:CTA_FILE WHERE CTA_ITMN=CHILD)');
     dm.DB.Execute('UPDATE TMP_BOM SET ITMNO=CHILD[1,2] WHERE ITMNO IS NULL');

     // 2004/03/30 MODIFY BY RENWEI: 修改內購材料不應該放關稅
     with qAbmr622 do begin
     if Active then Close;
       SQL.Clear;
       SQL.Add('SELECT CHILD  AS 子階料號,					'+  //PARTNO   0
            '       IMA02  AS 品名描述,						'+  //PARTDESC 1
            '       IMA25   AS 單位,						'+  //UNIT     2
            '       SUM(USAGE*IMA63_FAC) AS 用量,				'+  //USAGE    3
            '       IMA109  AS 類別,						'+  //TYPE    4
            '       IMB111  AS 標准單價,					'+  //GWS UNIT PRICE 6
            '       ROUND(IMA531,4) AS 采購市價,				'+  //LAST PRICE     7
            '       CASE WHEN IMA103=''1'' THEN CTA_CUST  ELSE 0 END AS 關稅,   '+
            '       IMA54  AS 供應廠商,IMA103 AS 內外購,IMA48 AS  採購週期 ,    '+
            '       IMA08 AS 來源                                           	'+  // 11
            ' FROM TMP_BOM  INNER JOIN  IMA_FILE  ON CHILD=IMA01'+
            '                LEFT OUTER JOIN  IMB_FILE C ON CHILD=IMB01'+
            '                LEFT OUTER JOIN GWS::CTA_FILE E ON ITMNO=CTA_ITMN'+
            ' WHERE BP=''1''  '+
            ' GROUP BY CHILD,IMA02,IMA25,IMA109,IMB111,IMA531,IMA103,IMA54,CTA_CUST,IMA48,IMA08 '+
            ' ORDER BY CHILD');

       Open;
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

procedure TfrmAbmr622.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qAbmr622.Active then
     qAbmr622.Close;
  Action:=caFree;
end;

procedure TfrmAbmr622.txtPartnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    tbRunClick(Sender);

end;

procedure TfrmAbmr622.ToolButton5Click(Sender: TObject);
begin
  ShowExportOpen(qAbmr622,Format('abmr622_%s',[txtPartno.text]),'abmr622 - Cost BOM');
end;

procedure TfrmAbmr622.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAbmr622.cbSleClick(Sender: TObject);
begin
  if cbSle.Checked then
  begin
     cbSle.Caption:='  允許P代P';
     cbSle.Font.Color:=clNavy;
  end
  else
  begin
    cbSle.Caption:='  不允許P代P';
    cbSle.Font.Color:=clRed;

  end;
end;

procedure TfrmAbmr622.DBGridDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
begin
  if (qAbmr622.FieldByName('gwsamt').AsCurrency = 0) or
     (qAbmr622.FieldByName('lastamt').AsCurrency = 0) then
  begin
     DBGrid.Canvas.Brush.Color:=clAqua;
     DBGrid.Canvas.Font.Color:=clNavy;
  end;

  dbgrid.DefaultDrawDataCell(rect, Field, state);
end;

procedure TfrmAbmr622.ToolButton1Click(Sender: TObject);
begin
  ShowFindDialog(qAbmr622,dbgrid.GetActiveCol-1);
end;

procedure TfrmAbmr622.ToolButton2Click(Sender: TObject);
begin
    if ShowFilterDialog(qAbmr622,dbgrid.GetActiveCol-1) then begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
end;

procedure TfrmAbmr622.tbRemoveClick(Sender: TObject);
begin
  if qAbmr622.Filtered then
  begin
     qAbmr622.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

end.
