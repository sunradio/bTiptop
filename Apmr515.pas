unit Apmr515;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, StdCtrls, ToolWin, ComCtrls, Db, DBTables,PASDM;

type
  TfrmApmr515 = class(TForm)
    tbASFT110: TToolBar;
    txtWono: TEdit;
    tbRun: TToolButton;
    Query: TQuery;
    ds_query: TDataSource;
    DBGrid: TwwDBGrid;
    lblWoNo: TLabel;
    tbExport: TToolButton;
    tbFind: TToolButton;
    tbFilter: TToolButton;
    tbRemove: TToolButton;
    procedure tbRunClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure txtWonoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbExportClick(Sender: TObject);
    procedure tbFindClick(Sender: TObject);
    procedure tbFilterClick(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmApmr515: TfrmApmr515;

implementation
uses pasCodeProc,pasSysRes;
{$R *.DFM}

procedure TfrmApmr515.tbRunClick(Sender: TObject);
begin
  if txtWono.Text<>'' then
  begin
  with Query do
  begin
    if active then
       close;
    ParamByName('PARTNO').AsString:=txtWono.Text+'%';
    try
      Screen.Cursor:=crSQLWait;
      Query.Open;
    finally
      Screen.Cursor:=crDefault;
    end;

  end;
  end;

end;

procedure TfrmApmr515.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Query.Active then
     Query.Close;
  Action:=caFree;
end;

procedure TfrmApmr515.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmApmr515.txtWonoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    tbRunClick(Sender);
end;

procedure TfrmApmr515.tbExportClick(Sender: TObject);
begin
  ShowExportOpen(Query,'AIMQ102','AIMQ102 - 料件基本資料查詢');
end;

procedure TfrmApmr515.tbFindClick(Sender: TObject);
begin
  ShowFindDialog(Query,dbgrid.GetActiveCol-1);
end;

procedure TfrmApmr515.tbFilterClick(Sender: TObject);
begin
  try
    if ShowFilterDialog(Query,0) then
    begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
  except
    on e:exception do
    Application.MessageBox(PChar(e.Message),PChar(gErrCaption),MB_ICONERROR+MB_OK);
  end;
end;

procedure TfrmApmr515.tbRemoveClick(Sender: TObject);
begin
  if Query.Filtered then
  begin
     Query.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

end.
