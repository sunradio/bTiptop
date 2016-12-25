unit Axsr504;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, ComCtrls, StdCtrls, ToolWin, Db, DBTables,pasDm,
  pasMain, ExtCtrls;

type
  TfrmAxsr504 = class(TForm)
    tbaxsr504: TToolBar;
    tbRun: TToolButton;
    tbExport: TToolButton;
    tbFind: TToolButton;
    tbFilter: TToolButton;
    tbRemove: TToolButton;
    Query: TQuery;
    dsQuery: TDataSource;
    DBGrid: TwwDBGrid;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    lblMsg: TLabel;
    Label1: TLabel;
    txtSalesYm: TEdit;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure tbRunClick(Sender: TObject);
    procedure tbExportClick(Sender: TObject);
    procedure tbFindClick(Sender: TObject);
    procedure tbFilterClick(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure txtSalesYmKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAxsr504: TfrmAxsr504;

implementation
uses pasCodeProc,pasSysRes,Com001;
{$R *.DFM}

procedure TfrmAxsr504.tbRunClick(Sender: TObject);
var
  lSql:String;
  lWhere:String;
  lLike:String[1];
  lMonth,lYear:string[2];
begin

  if txtSalesYm.Text<>'' then
  begin
  with Query do
  begin
    if active then begin
      if not Prepared then
         Prepare;
      close;
    end;
    SQL.Clear;

   lLike:='%';
   lMonth:='%m';
   lYear:='%Y';
   lSql:='     SELECT OGB04 AS 產品品號,                                                      '+
          '            IMA02 AS 品名描述,                                                      '+
          '            ROUND(SUM(OGB12*IMB111),0) AS 金額合計,                                 '+
          '            SUM(OGB12) AS 數量合計,                                                 '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''01'' THEN OGB12 END) AS 一月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''02'' THEN OGB12 END) AS 二月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''03'' THEN OGB12 END) AS 三月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''04'' THEN OGB12 END) AS 四月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''05'' THEN OGB12 END) AS 五月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''06'' THEN OGB12 END) AS 六月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''07'' THEN OGB12 END) AS 七月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''08'' THEN OGB12 END) AS 八月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''09'' THEN OGB12 END) AS 九月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''10'' THEN OGB12 END) AS 十月,   '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''11'' THEN OGB12 END) AS 十一月, '+
          '            SUM(CASE WHEN (TO_CHAR(OGA02,''%s''))=''12'' THEN OGB12 END) AS 十二月  '+
          '     FROM OGA_FILE,OGB_FILE,IMB_FILE,IMA_FILE                                       '+
          '    WHERE OGA01=OGB01 AND                                                           '+
          '          OGB04=IMB01 AND                                                           '+
          '          OGB04=IMA01 AND   OGA25[1,2] LIKE ''%S%S'' AND                            '+
          '          TO_CHAR(OGA02,''%S'') ='''+txtSalesYm.Text+''' AND                        '+
          '          OGACONF=''Y'' AND                                                         '+
          '          OGAPOST=''Y'' AND                                                         '+
          '          OGB04[1,2]<''10''                                                         '+
          ' GROUP BY OGB04,IMA02                                                               '+
          ' ORDER BY OGB04';

    try
      Screen.Cursor:=crSQLWait;
      if GetQueryWhere('按部門查詢銷售','未輸入=全部查詢',lWhere,False) then begin
        SQL.Add(Format(lSql,[lMonth,lMonth,lMonth,lMonth,lMonth,lMonth,lMonth,lMonth,lMonth,lMonth,lMonth,lMonth,lWhere,lLike,lYear]));
        Query.Open;
      end;  
    finally
      Screen.Cursor:=crDefault;
    end;

  end;
  end;


end;

procedure TfrmAxsr504.tbExportClick(Sender: TObject);
begin
ShowExportOpen(Query,'axsr504','axsr504 -  機種年度銷售統計');
end;

procedure TfrmAxsr504.tbFindClick(Sender: TObject);
begin
  ShowFindDialog(Query,dbgrid.GetActiveCol-1);
end;

procedure TfrmAxsr504.tbFilterClick(Sender: TObject);
begin
  try
    if ShowFilterDialog(Query,dbgrid.GetActiveCol-1) then
    begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
  except
    on e:exception do
    Application.MessageBox(PChar(e.Message),PChar(gErrCaption),MB_ICONERROR+MB_OK);
  end;
end;

procedure TfrmAxsr504.tbRemoveClick(Sender: TObject);
begin
  if Query.Filtered then
  begin
     Query.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmAxsr504.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Query.Active then
     Query.Close;
  if Query.Prepared then
     Query.UnPrepare;
  Action:=caFree;
end;

procedure TfrmAxsr504.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAxsr504.txtSalesYmKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    tbRunClick(Sender);
end;

end.
