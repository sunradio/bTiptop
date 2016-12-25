unit biqc001;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, StdCtrls, ToolWin, ComCtrls, Db, DBTables,PASDM,
  Menus, ExtCtrls,pasMain;

type
  Tfrmbiqc001 = class(TForm)
    tbASFT110: TToolBar;
    tbRun: TToolButton;
    Query: TQuery;
    ds_query: TDataSource;
    tbExport: TToolButton;
    DBGrid: TwwDBGrid;
    Panel2: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
    txtStart: TEdit;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    txtEnd: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    txtVendor: TEdit;
    cbLocal: TCheckBox;
    procedure tbRunClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure txtStartKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbExportClick(Sender: TObject);
    procedure cbLocalClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmbiqc001: Tfrmbiqc001;

implementation
uses pasCodeProc,pasSysRes,sysdb;
{$R *.DFM}

procedure Tfrmbiqc001.tbRunClick(Sender: TObject);
var
  lSql,sDbName:String;
  procedure ChkWo;
  begin
    if cbLocal.Checked then  begin
       sDbName:='DS2::';
    end else begin
       sDbName:='DS5::';
    end;
   end;
begin
  ChkWo;

  with Query do
  begin
    if active then  close;

    SQL.Clear;
    lSql:='SELECT SFE04 AS 發料日期,SFE01[5,8] AS 工單,SFE07 AS 料號,PMC01 AS 廠商,PMC03 AS 簡稱,SUM(SFE16) AS 數量'+
          '  FROM DS2::SFE_FILE, DS2::PMC_FILE, DS2::IMA_FILE '+
          ' WHERE  SFE07=IMA01 AND IMA54=PMC01 AND  SFE04  BETWEEN ''%S'' AND ''%S'' AND  SFE07 IN (SELECT IMA01 FROM %SIMA_FILE WHERE IMA54 IN (SELECT PMC01 FROM %SPMC_FILE WHERE PMC03 LIKE ''%S''))  '+
          ' GROUP BY 1,2,3,4,5                                                                                                                                                                                            '+
          ' UNION ALL                                                                                                                                                                                                    '+
          '                                                                                                                                                                                                               '+
          'SELECT SFE04 AS 發料日期,SFE01[5,8] AS 工單,SFE07 AS 料號,PMC01 AS 廠商,PMC03 AS 簡稱,SUM(SFE16) AS 數量                                                                                                      '+
          '  FROM DS3::SFE_FILE, DS3::PMC_FILE, DS3::IMA_FILE                                                                                                                                                            '+
          ' WHERE  SFE07=IMA01 AND IMA54=PMC01 AND  SFE04  BETWEEN ''%S'' AND ''%S'' AND  SFE07 IN (SELECT IMA01 FROM %SIMA_FILE WHERE IMA54 IN (SELECT PMC01 FROM %SPMC_FILE WHERE PMC03 LIKE ''%S''))  '+
          ' GROUP BY 1,2,3,4,5';
    SQL.Add(Format(lSql,[txtStart.Text,txtEnd.text,sDbName,sDbName,'%'+txtVendor.text+'%',txtStart.Text,txtEnd.text,sDbName,sDbName,'%'+txtVendor.text+'%']));
    try
      Screen.Cursor:=crSQLWait;
      Query.Open;
    finally
      Screen.Cursor:=crDefault;
    end;

  end;

end;

procedure Tfrmbiqc001.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Query.Active then
     Query.Close;
  if Query.Prepared then
     Query.UnPrepare;

  Action:=caFree;
end;

procedure Tfrmbiqc001.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure Tfrmbiqc001.txtStartKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    tbRunClick(Sender);
end;

procedure Tfrmbiqc001.tbExportClick(Sender: TObject);
begin
  ShowExportOpen(Query,'bIqc001','bIqc001 - 按廠商指定時間查入料');
end;

procedure Tfrmbiqc001.cbLocalClick(Sender: TObject);
begin
  if cblocal.Checked then
    cblocal.Caption :='內購廠商'
  else
    cblocal.Caption :='外購廠商';
end;

end.
