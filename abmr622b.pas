unit abmr622b;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxTL, dxDBCtrl, dxCntner, dxDBTL, Db, DBTables, ComCtrls, StdCtrls,
  ToolWin, Grids, Wwdbigrd, Wwdbgrid,FileCtrl, ExtCtrls,pasMain;

type
  TfrmAbmr622b = class(TForm)
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
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    Edit1: TEdit;
    Label2: TLabel;
    procedure tbRunClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtPartnoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ToolButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbmr622b: TfrmAbmr622b;

implementation
uses pasDm,
     pasSysRes,
     pasCodeProc,

     BomCode;
{$R *.DFM}

procedure TfrmAbmr622b.tbRunClick(Sender: TObject);
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
                 ' FROM BMB_FILE A  '+
                 ' WHERE A.BMB01=''%s'''+
                 '   AND A.BMB19 IN(''2'',''3'') '+
                 '   AND (BMB04<=TODAY OR BMB04 IS NULL) '+
                 '   AND (BMB05>TODAY  OR BMB05 IS NULL)',[txtPartno.text]));

        while (iEndTree=0) do
        begin
          iLvl:=iLvl+1;
          // P代P的問題,加入條件選擇

           dm.DB.Execute(Format('INSERT INTO TMP_BOM(LVL,PARENT,CHILD,USAGE,STARTDATE,UNABLEDATE,UNIT,BP)'+
                                ' SELECT %d,A.BMB01,A.BMB03,A.BMB06,A.BMB04,A.BMB05,A.BMB10,A.BMB19'+
                                ' FROM BMB_FILE A ,TMP_BOM B '+
                                ' WHERE A.BMB01=B.CHILD  '+
                                '   AND A.BMB19 IN(''2'',''3'') '+
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

       try
        dm.DB.Execute('CREATE TEMP TABLE TMP_BOMA'+
        ' (PARTNO VARCHAR(15))');
        dm.DB.Execute('CREATE TEMP TABLE TMP_BOMB'+
        ' (PARTNO VARCHAR(15))');

       except
       on e:EDBEngineError do
       if e.Errors[1].NativeError=-958 then begin
          dm.DB.Execute('DELETE TMP_BOMA');
          dm.DB.Execute('DELETE TMP_BOMB');
          end;
       end;

        dm.DB.Execute('INSERT INTO TMP_BOMA SELECT DISTINCT PARENT FROM TMP_BOM');
        dm.DB.Execute('INSERT INTO TMP_BOMA SELECT DISTINCT CHILD FROM TMP_BOM ');
        dm.DB.Execute('INSERT INTO TMP_BOMB SELECT DISTINCT PARTNO FROM TMP_BOMA');
        
     with qAbmr622 do begin
     if Active then Close;
       SQL.Clear;
       SQL.Add(Format(
            'SELECT PARTNO AS 父階料號, BMT03  AS 子階料號, BMT06 AS 插件位置 ,bmt04 AS 生效日期 '+ //PARTNO   0
            ' FROM TMP_BOMB  INNER JOIN BMT_FILE ON PARTNO=BMT01 '+
            ' WHERE BMT06 IN(''%S'')  '+
            ' ORDER BY BMT03,BMT04',[Trim(edit1.text)]));

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

procedure TfrmAbmr622b.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qAbmr622.Active then
     qAbmr622.Close;
  Action:=caFree;
end;

procedure TfrmAbmr622b.txtPartnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    tbRunClick(Sender);

end;

procedure TfrmAbmr622b.ToolButton5Click(Sender: TObject);
begin
  ShowExportOpen(qAbmr622,Format('abmr622_%s',[txtPartno.text]),'abmr622 - Cost BOM');
end;

procedure TfrmAbmr622b.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAbmr622b.DBGridDrawDataCell(Sender: TObject;
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

procedure TfrmAbmr622b.ToolButton1Click(Sender: TObject);
begin
  ShowFindDialog(qAbmr622,dbgrid.GetActiveCol-1);
end;

procedure TfrmAbmr622b.ToolButton2Click(Sender: TObject);
begin
    if ShowFilterDialog(qAbmr622,dbgrid.GetActiveCol-1) then begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
end;

procedure TfrmAbmr622b.tbRemoveClick(Sender: TObject);
begin
  if qAbmr622.Filtered then
  begin
     qAbmr622.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmAbmr622b.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    tbRunClick(Sender);
end;

end.
