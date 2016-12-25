unit abmr622a;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxTL, dxDBCtrl, dxCntner, dxDBTL, Db, DBTables, ComCtrls, StdCtrls,
  ToolWin, Grids, Wwdbigrd, Wwdbgrid,FileCtrl, ExtCtrls,pasMain,JclStrings;

type
  TfrmAbmr622a = class(TForm)
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
  frmAbmr622a: TfrmAbmr622a;

implementation
uses pasDm,
     pasSysRes,
     pasCodeProc,
     BomCode;
{$R *.DFM}

procedure TfrmAbmr622a.tbRunClick(Sender: TObject);
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
                 ' WHERE A.BMB01=''%s'' AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL)',[txtPartno.text]));


        while (iEndTree=0) do
        begin
          iLvl:=iLvl+1;
          // P代P的問題,加入條件選擇
         if cbSle.Checked then begin
            if StrLeft(txtPartno.text,2)<>'13' then
              dm.DB.Execute(Format('INSERT INTO TMP_BOM(LVL,PARENT,CHILD,USAGE,STARTDATE,UNABLEDATE,UNIT,BP)'+
                                ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB04,A.BMB05,A.BMB10,A.BMB19'+
                                ' FROM BMB_FILE A ,TMP_BOM B '+
                                ' WHERE A.BMB01=B.CHILD  '+
                                '   AND B.CHILD[1,2]!=''13'' AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[iLvl,iLvl-1]))
              else
              dm.DB.Execute(Format('INSERT INTO TMP_BOM(LVL,PARENT,CHILD,USAGE,STARTDATE,UNABLEDATE,UNIT,BP)'+
                                ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB04,A.BMB05,A.BMB10,A.BMB19'+
                                ' FROM BMB_FILE A ,TMP_BOM B,IMA_FILE C'+
                                ' WHERE A.BMB01=B.CHILD '+
                                '   AND B.BP<>''1'''+
                                '   AND A.BMB01=C.IMA01'+
                                '   AND C.IMA08=''M'''+
                                '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[iLvl,iLvl-1]))

           end
         else  begin
           if StrLeft(txtPartno.text,2)<>'13' then
           dm.DB.Execute(Format('INSERT INTO TMP_BOM(LVL,PARENT,CHILD,USAGE,STARTDATE,UNABLEDATE,UNIT,BP)'+
                                ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB04,A.BMB05,A.BMB10,A.BMB19'+
                                ' FROM BMB_FILE A ,TMP_BOM B '+
                                ' WHERE A.BMB01=B.CHILD '+
                                '   AND B.BP<>''1'''+
                                '   AND B.CHILD[1,2]!=''13'' AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[iLvl,iLvl-1]))
           else
           dm.DB.Execute(Format('INSERT INTO TMP_BOM(LVL,PARENT,CHILD,USAGE,STARTDATE,UNABLEDATE,UNIT,BP)'+
                                ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB04,A.BMB05,A.BMB10,A.BMB19'+
                                ' FROM BMB_FILE A ,TMP_BOM B '+
                                ' WHERE A.BMB01=B.CHILD '+
                                '   AND B.BP<>''1'''+
                                '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[iLvl,iLvl-1]))

         end;



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
       SQL.Add('SELECT  '+
            '       CHILD  AS 子階料號,							'+  //PARTNO   0
            '       IMA08  AS 形態,							'+  //TYPE    4
            '       CASE WHEN BP=''1'' THEN ''-''                                       '+
            '            WHEN BP=''2'' THEN ''+''                                       '+
            '            WHEN BP=''3'' THEN ''*''                                       '+
            '            WHEN BP=''4'' THEN ''?''                                       '+
            '       END  AS P,                                                          '+
            '       IMA02  AS 品名描述,							'+  //PARTDESC 1
            '       IMA25   AS 單位,							'+  //UNIT     2
            '       SUM(USAGE*IMA63_FAC) AS 用量,					'+  //USAGE    3
            '       ROUND(D.IMB111/4.2,3) AS 台標單價,					'+  //GWT UNIT PRICE 5
            '       C.IMB111  AS 蘇標單價,						'+  //GWS UNIT PRICE 6
            '       ROUND(IMA53,3) AS 最新單價,						'+  //LAST PRICE     7
            '       ROUND(SUM(USAGE*IMA63_FAC*ROUND(D.IMB111/4.2,3)),2) AS 台標金額,	'+  // 8
            '       ROUND(SUM(USAGE*IMA63_FAC*C.IMB111),2) AS 蘇標金額,			'+  // 9
            '       ROUND(SUM(USAGE*IMA63_FAC*IMA53),2) AS 最新金額,			'+  // 10
            '       CASE WHEN IMA103=''1'' THEN E.CTA_CUST  ELSE 0 END AS 關稅,         '+
            '       (1+(CASE WHEN IMA103=''1'' THEN E.CTA_CUST  ELSE 0 END))*SUM(USAGE*IMA63_FAC*C.IMB111) AS 含稅金額,	'+
            '       IMA54  AS 供應廠商,'+
            '       CASE WHEN IMA103=''0'' THEN ''內'' '+
            '            WHEN IMA103=''1'' THEN ''外'' END AS 內外購,IMA48 AS  採購週期       	'+  // 11
            ' FROM TMP_BOM A INNER JOIN IMA_FILE B ON A.CHILD=B.IMA01'+
            '                LEFT OUTER JOIN IMB_FILE C ON A.CHILD=C.IMB01'+
            '                LEFT OUTER JOIN DS5::IMB_FILE D ON A.CHILD=D.IMB01'+
            '                LEFT OUTER JOIN GWS::CTA_FILE E ON A.ITMNO=E.CTA_ITMN'+
            ' WHERE IMA08!=''X'' AND A.BP!=''3'''+
            ' GROUP BY CHILD,IMA08,BP,IMA02,IMA25,IMA08,D.IMB111,C.IMB111,IMA53,IMA54,E.CTA_CUST,IMA103,IMA48'+
            ' ORDER BY 1');

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

procedure TfrmAbmr622a.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qAbmr622.Active then
     qAbmr622.Close;
  Action:=caFree;
end;

procedure TfrmAbmr622a.txtPartnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    tbRunClick(Sender);

end;

procedure TfrmAbmr622a.ToolButton5Click(Sender: TObject);
begin
  ShowExportOpen(qAbmr622,Format('abmr622_%s',[txtPartno.text]),'abmr622 - Cost BOM');
end;

procedure TfrmAbmr622a.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAbmr622a.cbSleClick(Sender: TObject);
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

procedure TfrmAbmr622a.DBGridDrawDataCell(Sender: TObject;
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

procedure TfrmAbmr622a.ToolButton1Click(Sender: TObject);
begin
  ShowFindDialog(qAbmr622,dbgrid.GetActiveCol-1);
end;

procedure TfrmAbmr622a.ToolButton2Click(Sender: TObject);
begin
    if ShowFilterDialog(qAbmr622,dbgrid.GetActiveCol-1) then begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
end;

procedure TfrmAbmr622a.tbRemoveClick(Sender: TObject);
begin
  if qAbmr622.Filtered then
  begin
     qAbmr622.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

end.
