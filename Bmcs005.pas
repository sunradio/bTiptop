unit Bmcs005;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin,pasDm, Db, DBTables, ExtCtrls, DBCtrls, Grids, DBGrids,
  StdCtrls, Wwdbigrd, Wwdbgrid,

  pasMain;

type
  TfrmBmcs005 = class(TForm)
    ds_bmcs005: TDataSource;
    tbDataTool: TToolBar;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    DBGrid: TwwDBGrid;
    tbl_bmcs005: TTable;
    tbl_bmcs005mce_idno: TIntegerField;
    tbl_bmcs005mce_ver: TStringField;
    tbl_bmcs005mce_time: TStringField;
    tbl_bmcs005mce_vlue: TStringField;
    tbl_bmcs005mce_recn: TIntegerField;
    tbl_bmcs005mce_user: TStringField;
    tbl_bmcs005mce_uset: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBmcs005: TfrmBmcs005;

implementation
uses pasCodeProc,
     bmcs004;
{$R *.DFM}

procedure TfrmBmcs005.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if tbl_bmcs005.Active then
     tbl_bmcs005.Close;
  Action:=caFree;
end;

procedure TfrmBmcs005.FormCreate(Sender: TObject);
begin
  if not tbl_bmcs005.Active then
     tbl_bmcs005.Open;
end;

procedure TfrmBmcs005.ToolButton9Click(Sender: TObject);
begin
  ShowExportOpen(tbl_bmcs005,'bmcs005','bmcs005 - 模擬版本記錄維護');
end;

procedure TfrmBmcs005.FormShow(Sender: TObject);
begin
  SetFormShow(Self);

end;

procedure TfrmBmcs005.ToolButton7Click(Sender: TObject);
var
  whatifName:String;
begin
  if  tbl_bmcs005.RecordCount>0 then begin
  whatifName:=tbl_bmcs005.Fields[1].AsString;
  if Application.MessageBox(
                PChar(Format('你確認要刪除 " %s " 模擬資料嗎?',
                [whatifName])),
                '刪除確認',MB_ICONQUESTION+MB_YESNO)=ID_YES then
      with dm.db do begin
        StartTransaction;
        try
          SetStatusMsg('刪除零時資料...');
          Execute('DELETE GWS:MCB_FILE');   // CLEAR STOCK QTY

          SetStatusMsg('刪除模擬資料...');
          Execute(Format
               ('DELETE GWS:MCC_FILE WHERE MCC_VERS = ''%S''',
               [whatifName]));
               
          Execute(Format
               ('DELETE GWS:MCD_FILE WHERE MCD_VER = ''%S''',
               [whatifName]));

          Execute(Format
               ('DELETE GWS:MCE_FILE WHERE MCE_VER = ''%S''',
               [whatifName]));

          Execute(Format
               ('DELETE GWS:MCG_FILE WHERE MCG_VERS = ''%S''',
               [whatifName]));


          SetStatusMsg('刪除模擬進貨資料...');
          Execute(Format
               ('DELETE GWS:WIF_FILE WHERE WHATIF = ''%S''',
               [whatifName]));

          Commit;
          tbl_bmcs005.Refresh;
          Application.MessageBox(
                     PChar(Format('模擬版本 " %S " 資料以及 LOG 已刪除.',
                     [whatifName])),'信息',
                     MB_ICONINFORMATION+MB_OK);


        except
          Application.MessageBox(
                     PChar(Format('刪除模擬版本 " %S " 資料以及 LOG 失敗.',
                     [whatifName])),'信息',
                     MB_ICONEXCLAMATION+MB_OK);
          Rollback;
          raise;
        end;
      end;
      end;

end;

end.
