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
  ShowExportOpen(tbl_bmcs005,'bmcs005','bmcs005 - ���������O�����@');
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
                PChar(Format('�A�T�{�n�R�� " %s " ������ƶ�?',
                [whatifName])),
                '�R���T�{',MB_ICONQUESTION+MB_YESNO)=ID_YES then
      with dm.db do begin
        StartTransaction;
        try
          SetStatusMsg('�R���s�ɸ��...');
          Execute('DELETE GWS:MCB_FILE');   // CLEAR STOCK QTY

          SetStatusMsg('�R���������...');
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


          SetStatusMsg('�R�������i�f���...');
          Execute(Format
               ('DELETE GWS:WIF_FILE WHERE WHATIF = ''%S''',
               [whatifName]));

          Commit;
          tbl_bmcs005.Refresh;
          Application.MessageBox(
                     PChar(Format('�������� " %S " ��ƥH�� LOG �w�R��.',
                     [whatifName])),'�H��',
                     MB_ICONINFORMATION+MB_OK);


        except
          Application.MessageBox(
                     PChar(Format('�R���������� " %S " ��ƥH�� LOG ����.',
                     [whatifName])),'�H��',
                     MB_ICONEXCLAMATION+MB_OK);
          Rollback;
          raise;
        end;
      end;
      end;

end;

end.
