unit abmr622c;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxTL, dxDBCtrl, dxCntner, dxDBTL, Db, DBTables, ComCtrls, StdCtrls,
  ToolWin, Grids, Wwdbigrd, Wwdbgrid,FileCtrl, ExtCtrls,pasMain, Menus;

type
  TfrmAbmr622c = class(TForm)
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
    txtInsno: TEdit;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    ToolButton13: TToolButton;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure tbRunClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtPartnoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ToolButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure tbRemoveClick(Sender: TObject);
    procedure txtInsnoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbmr622c: TfrmAbmr622c;

implementation
uses pasDm,
     pasSysRes,
     pasCodeProc,

     BomCode;
{$R *.DFM}

procedure TfrmAbmr622c.tbRunClick(Sender: TObject);
var
  partno,insno,lsql:string;
begin
   if (txtPartno.Text='') and (txtInsno.Text='') then begin
      Application.MessageBox(PCHAR('查詢條件不能都為空！'),
                PCHAR('查詢條件'),MB_ICONEXCLAMATION+MB_OK);

   end else  begin

   if txtPartno.Text='' then begin
      partno:='%'
   end else
     partno:= txtPartno.Text+'%';

   if txtInsno.Text='' then
     insno:='%'
   else
     insno:=txtInsno.Text+'%';

   if (txtPartno.Text='') and  (txtInsno.Text<>'') then begin
      lsql:='SELECT BMB02 AS 項次,  '+
            '    BMB01 AS 母階料號 , '+
            '    BMB03 AS 子階料號,  '+
            '    IMA02 AS 材料描述,  '+
            '    IMA08 AS 來源,      '+
            '    BMB13 AS 位置,      '+
            '    BMB06 AS 用量,      '+
            '    BMB09 AS 制業編號,  '+
            '    BMB04 AS 生效日期,  '+
            '    BMB05 AS 失效日期,  '+
            '    BMB24 AS  ECNNO     '+
          ' FROM BMB_FILE,IMA_FILE   '+
         ' WHERE BMB03=IMA01 AND ((BMB05 IS NULL) OR (BMB05 >TODAY)) AND BMB01||BMB02||BMB03 IN (SELECT BMT01||BMT02||BMT03 FROM BMT_FILE WHERE  BMT03 LIKE ''%s''  AND BMT06 LIKE ''%S'')';

   with qAbmr622 do begin
   if Active then Close;
       SQL.Clear;
       SQL.Add(Format(lsql,[Trim(partno),Trim(Insno)]));
       Open;
      end;


   end else begin if  (txtPartno.Text<>'') and  (txtInsno.Text<>'') then begin
      lsql:='SELECT BMB02 AS 項次,  '+
            '    BMB01 AS 母階料號 , '+
            '    BMB03 AS 子階料號,  '+
            '    IMA02 AS 材料描述,  '+
            '    IMA08 AS 來源,      '+
            '    BMB13 AS 位置,      '+
            '    BMB06 AS 用量,      '+
            '    BMB09 AS 制業編號,  '+
            '    BMB04 AS 生效日期,  '+
            '    BMB05 AS 失效日期,  '+
            '    BMB24 AS  ECNNO     '+
          ' FROM BMB_FILE,IMA_FILE   '+
         ' WHERE BMB03=IMA01 AND ((BMB05 IS NULL) OR (BMB05 >TODAY)) AND BMB01||BMB02||BMB03 IN (SELECT BMT01||BMT02||BMT03 FROM BMT_FILE WHERE  BMT03 LIKE ''%s''  AND BMT06  LIKE ''%S'')';

  with qAbmr622 do begin
   if Active then Close;
       SQL.Clear;
       SQL.Add(Format(lsql,[Trim(partno),Trim(Insno)]));
       Open;
      end;


         end else begin if (txtPartno.Text<>'') and  (txtInsno.Text='') then begin
            lsql:='SELECT  BMB02 AS 項次,  '+
            '    BMB01 AS 母階料號 , '+
            '    BMB03 AS 子階料號,  '+
            '    IMA02 AS 材料描述,  '+
            '    IMA08 AS 來源,      '+
            '    BMB13 AS 位置,      '+
            '    BMB06 AS 用量,      '+
            '    BMB09 AS 制業編號,  '+
            '    BMB04 AS 生效日期,  '+
            '    BMB05 AS 失效日期,  '+
            '    BMB24 AS  ECNNO     '+
          ' FROM BMB_FILE,IMA_FILE   '+
         ' WHERE BMB03 LIKE ''%s''      '+
         '   AND IMA01=BMB03  AND ((BMB05 IS NULL) OR (BMB05 >TODAY))        '+
         ' ORDER BY 2,1,6';

    with qAbmr622 do begin
    if Active then Close;
       SQL.Clear;
       SQL.Add(Format(lsql,[Trim(partno)]));
       Open;
      end;
 
                                 end
                  end
   end;

   end;

end;



procedure TfrmAbmr622c.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if qAbmr622.Active then
     qAbmr622.Close;
  Action:=caFree;
end;

procedure TfrmAbmr622c.txtPartnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then
    tbRunClick(Sender);

end;

procedure TfrmAbmr622c.ToolButton5Click(Sender: TObject);
begin
  ShowExportOpen(qAbmr622,Format('abmr622_%s',[txtPartno.text]),'abmr622C - 按照料號以及位置查詢母階材料');
end;

procedure TfrmAbmr622c.FormShow(Sender: TObject);
begin
  SetFormShow(self);
end;

procedure TfrmAbmr622c.ToolButton1Click(Sender: TObject);
begin
  ShowFindDialog(qAbmr622,dbgrid.GetActiveCol-1);
end;

procedure TfrmAbmr622c.ToolButton2Click(Sender: TObject);
begin
    if ShowFilterDialog(qAbmr622,0) then begin
      if tbRemove.Enabled=False then
         tbRemove.Enabled:=True;
    end;
end;

procedure TfrmAbmr622c.tbRemoveClick(Sender: TObject);
begin
  if qAbmr622.Filtered then
  begin
     qAbmr622.Filtered:=False;
     tbRemove.Enabled:=False;
  end;
end;

procedure TfrmAbmr622c.txtInsnoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    tbRunClick(Sender);
end;

procedure TfrmAbmr622c.N1Click(Sender: TObject);
begin
 if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWoMode(DBGrid.Fields[2].AsString);
    end;
  end;
end;

procedure TfrmAbmr622c.N2Click(Sender: TObject);
begin
 if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWoMode(DBGrid.Fields[1].AsString);
    end;
  end;
end;

procedure TfrmAbmr622c.N4Click(Sender: TObject);
begin
 if DBGrid.DataSource.DataSet.Active then begin
    if DBGrid.DataSource.DataSet.RecordCount>0 then begin
         GetWoModeEx(DBGrid.Fields[0].AsString,
                     DBGrid.Fields[1].AsString,
                     DBGrid.Fields[2].AsString );
    end;
  end;
end;

end.
