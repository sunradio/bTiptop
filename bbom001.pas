unit bbom001;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxTL, dxDBCtrl, dxCntner, dxDBTL, Db, DBTables, ComCtrls, StdCtrls,
  ToolWin, Grids, Wwdbigrd, Wwdbgrid,FileCtrl, ExtCtrls,pasMain;

type
  TfrmBbom001 = class(TForm)
    qAbmr622: TQuery;
    ds_query: TDataSource;
    DBGrid: TwwDBGrid;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
    ToolBar1: TToolBar;
    ToolButton3: TToolButton;
    ToolButton12: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    tbRemove: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    txtPartno: TEdit;
    cbSle: TCheckBox;
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
  frmBbom001: TfrmBbom001;

implementation
uses pasDm,pasSysRes,pasCodeProc,bomcode;
{$R *.DFM}

procedure TfrmBbom001.tbRunClick(Sender: TObject);
var
  iEndTree,iLvl:Integer;
begin
  if txtPartno.Text<>'' then begin
  if GetBomConfirm(txtPartno.Text) then begin
  try  try
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
     //dm.db.Execute('CREATE INDEX IDX_TMP_BOM ON TMP_BOM (CHILD)');
  except
    on e:EDBEngineError do
    if e.Errors[1].NativeError=-958 then
       dm.DB.Execute('DELETE TMP_BOM');
  end;


  iEndTree:=0;
  iLvl:=1;
  // 取最高階資料
  // ((A.BMB04>TODAY) AND (A.BMB05<TODAY)) 生效日期必須小于當前日期,失效材料需小于當前日期
  //dm.DB.Execute(Format('INSERT INTO TMP_BOM (LVL,PARENT,CHILD)'+
  //               'VALUES(1,''%s'',''%s'')',[txtPartno.text,txtPartno.text]));

  // 取第1階資料
  dm.DB.Execute(Format('INSERT INTO TMP_BOM (LVL,PARENT,CHILD,USAGE,STARTDATE,UNABLEDATE,UNIT,BP)'+
                 ' SELECT 1 ,A.BMB01,A.BMB03,A.BMB06,A.BMB04,A.BMB05,A.BMB10,A.BMB19'+
                 ' FROM BMB_FILE A'+
                 ' WHERE A.BMB01=''%s'' AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL)',[txtPartno.text]));

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
          ' FROM BMB_FILE A ,TMP_BOM B '+
          ' WHERE A.BMB01=B.CHILD '+
          '   AND B.BP<>''1'''+
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

  //
  //dm.DB.Execute('DELETE FROM TMP_BOM WHERE STARTDATE>TODAY');
  //dm.DB.Execute('DELETE FROM TMP_BOM WHERE UNABLEDATE<TODAY');
  //
  dm.DB.Execute('UPDATE TMP_BOM SET ITMNO=(SELECT CTA_ITMC FROM GWS:CTA_FILE WHERE CTA_ITMN=CHILD)');
  dm.DB.Execute('UPDATE TMP_BOM SET ITMNO=CHILD[1,2] WHERE ITMNO IS NULL');
  
  with qAbmr622 do
  begin
    if Active then
       Close;
    SQL.Clear;

    SQL.Add('SELECT CHILD  AS 子階料號,							'+  //PARTNO   0
            '       IMA02  AS 品名描述,							'+  //PARTDESC 1
            '       IMA25   AS 單位,							'+  //UNIT     2
            '       SUM(USAGE*IMA63_FAC) AS 用量,					'+  //USAGE    3
            '       IMA08  AS 形態,							'+  //TYPE    4
            '       ROUND(IMA53,3) AS 最新單價,						'+  //LAST PRICE     7
            '       IMA54  AS 供應廠商,							'+  // 11
            '       IMA48  AS 採購週期, '+ 
                  '       (SELECT SUM((SFA05-SFA06)*SFA13)                      '+
                  '          FROM DS2::SFA_FILE , DS2::SFB_FILE                 '+
                  '         WHERE SFA01=SFB01                                   '+
                  '           AND SFB04!=''8''                                  '+
                  '           AND SFA03=A.CHILD                                 '+
                  '           AND ( SFA05 -SFA06) >0)  AS  DS2_RQT,            '+

                  '       (SELECT SUM((SFA05-SFA06)*SFA13)                      '+
                  '          FROM DS3::SFA_FILE , DS3::SFB_FILE                 '+
                  '         WHERE SFA01=SFB01                                   '+
                  '           AND SFB04!=''8''                                  '+
                  '           AND SFA03=A.CHILD                                 '+
                  '           AND ( SFA05 -SFA06) >0)   AS  DS3_RQT,            '+
                  

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS2::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.CHILD                            '+
                  '          AND B.IMG23=''Y'' AND B.IMG02<>''BVI'') AS DS2_01,                    '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.CHILD                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''A02'') AS DS3_A02,                  '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.CHILD                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''A01'') AS DS3_A01,                  '+

                  '       (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                '+
                  '          FROM DS2::RVB_FILE, DS2::RVA_FILE, DS2::PMN_FILE   '+
                  '         WHERE RVB01=RVA01                                   '+
                  '           AND RVB05 =A.CHILD                             '+
                  '           AND RVB04 = PMN01                                 '+
                  '           AND RVB03 = PMN02                                 '+
                  '           AND RVB07 > (RVB29+RVB30)) AS DS2_IQC,           '+

                  '       (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                '+
                  '          FROM DS3::RVB_FILE, DS3::RVA_FILE, DS3::PMN_FILE   '+
                  '         WHERE RVB01=RVA01                                   '+
                  '           AND RVB05 =A.CHILD                             '+
                  '           AND RVB04 = PMN01                                 '+
                  '           AND RVB03 = PMN02                                 '+
                  '           AND RVB07 > (RVB29+RVB30)) AS DS3_IQC,           '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS2::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.CHILD                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''BVI'') AS DS2_OB,                  '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.CHILD                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''BVI'') AS DS3_OB,                  '+
                                                      
                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS5::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.CHILD                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''05'') AS DS5_05,                   '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS2::PMN_FILE, DS2::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.CHILD                             '+
                  '           AND PMN16 <=''2''                                 '+
           // '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 < TODAY  HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS DS2_PO_D,                   '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS3::PMN_FILE, DS3::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.CHILD                             '+
                  '           AND PMN16 <=''2''                                 '+
              //              '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 < TODAY AND PMM01[1,3]!=''PTS''  HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS DS3_PO_D,                   '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS2::PMN_FILE, DS2::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.CHILD                             '+
                  '           AND PMN16 <=''2''                                 '+
               //             '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 >= TODAY  HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0 ) AS DS2_PO,                  '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS3::PMN_FILE, DS3::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.CHILD                             '+
                  '           AND PMN16 <=''2''                                 '+
             //               '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 >= TODAY AND PMM01[1,3]!=''PTS''  HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS DS3_PO,                  '+

                  '       (SELECT SUM((PML20-PML21)*PML09)                      '+
                  '              FROM DS2::PML_FILE B, DS2::PMK_FILE C          '+
                  '             WHERE PML04 = A.CHILD                        '+
                  '               AND PML01 = PMK01                             '+
                  '               AND PML20 > PML21                             '+
                  '               AND PML16 <=''2''                             '+
                  '               AND PML011 !=''SUB'') AS DS2_PR,            '+

                  '       (SELECT SUM((PML20-PML21)*PML09)                      '+
                  '              FROM DS3::PML_FILE B, DS3::PMK_FILE C          '+
                  '             WHERE PML04 = A.CHILD                        '+
                  '               AND PML01 = PMK01                             '+
                  '               AND PML20 > PML21                             '+
                  '               AND PML16 <=''2''                             '+
                  '               AND PML011 !=''SUB'') AS DS3_PR,            '+


                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS5::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.CHILD                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02<>''05'') AS DS5_STK                   '+

            ' FROM TMP_BOM A INNER JOIN IMA_FILE B ON A.CHILD=B.IMA01'+
            ' WHERE A.BP=''1'''+
            ' GROUP BY CHILD,IMA02,IMA25,IMA08,IMA53,IMA54,IMA48');
    Open;

   
  end;
  except 
    on e:EDBEngineError do
    begin
      ShowMessage(e.Errors[1].Message);             //SERVER ERROR MSG
      case e.Errors[1].NativeError of               //MY ERROR MSG
        -951:showmessage('login error');
      end;
    end;
    end;
   end; 
  end;
end;

procedure TfrmBbom001.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qAbmr622.Active then
     qAbmr622.Close;
  Action:=caFree;
end;

procedure TfrmBbom001.txtPartnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    tbRunClick(Sender);

end;

procedure TfrmBbom001.ToolButton5Click(Sender: TObject);
begin
  ShowExportOpen(qAbmr622,Format('Bbom001_%s',[txtPartno.text]),'bbom001 - 機種所需材料模擬');
end;

procedure TfrmBbom001.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmBbom001.cbSleClick(Sender: TObject);
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

procedure TfrmBbom001.DBGridDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
begin
 { if (qAbmr622.FieldByName('gwsamt').AsCurrency = 0) or
     (qAbmr622.FieldByName('lastamt').AsCurrency = 0) then
  begin
     DBGrid.Canvas.Brush.Color:=clAqua;
     DBGrid.Canvas.Font.Color:=clNavy;
  end;

  dbgrid.DefaultDrawDataCell(rect, Field, state);  }
end;

procedure TfrmBbom001.ToolButton1Click(Sender: TObject);
begin
  ShowFindDialog(qAbmr622,dbgrid.GetActiveCol-1);
end;

procedure TfrmBbom001.ToolButton2Click(Sender: TObject);
begin
    if ShowFilterDialog(qAbmr622,dbgrid.GetActiveCol-1) then begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
end;

procedure TfrmBbom001.tbRemoveClick(Sender: TObject);
begin
  if qAbmr622.Filtered then
  begin
     qAbmr622.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

end.
