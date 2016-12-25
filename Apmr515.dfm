object frmApmr515: TfrmApmr515
  Left = 232
  Top = 204
  Width = 557
  Height = 361
  Caption = 'apmr515 - 廠商進料明細表'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '細明體'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tbASFT110: TToolBar
    Left = 0
    Top = 0
    Width = 549
    Height = 29
    ButtonHeight = 21
    Caption = 'tbASFT110'
    Flat = True
    Font.Charset = CHINESEBIG5_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '細明體'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lblWoNo: TLabel
      Left = 0
      Top = 0
      Width = 89
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = '廠商編號'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object txtWono: TEdit
      Left = 89
      Top = 0
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      ImeMode = imClose
      ImeName = '王碼拼音'
      MaxLength = 12
      TabOrder = 0
      OnKeyDown = txtWonoKeyDown
    end
    object tbRun: TToolButton
      Left = 210
      Top = 0
      Hint = '執行查詢'
      ImageIndex = 2
      OnClick = tbRunClick
    end
    object tbExport: TToolButton
      Left = 233
      Top = 0
      Hint = '查詢資料輸出'
      Caption = 'tbExport'
      ImageIndex = 10
      OnClick = tbExportClick
    end
    object tbFind: TToolButton
      Left = 256
      Top = 0
      Hint = '查找資料'
      Caption = 'tbFind'
      ImageIndex = 4
      OnClick = tbFindClick
    end
    object tbFilter: TToolButton
      Left = 279
      Top = 0
      Hint = '過濾資料'
      Caption = 'tbFilter'
      ImageIndex = 6
      OnClick = tbFilterClick
    end
    object tbRemove: TToolButton
      Left = 302
      Top = 0
      Hint = '取消過濾條件'
      Caption = 'tbRemove'
      Enabled = False
      ImageIndex = 7
      OnClick = tbRemoveClick
    end
  end
  object DBGrid: TwwDBGrid
    Left = 0
    Top = 29
    Width = 549
    Height = 305
    LineStyle = glsSingle
    Selected.Strings = (
      'partno'#9'14'#9'材料料號'#9#9
      'partdesc'#9'30'#9'材料描述'#9#9
      'item'#9'6'#9'類別'#9#9
      'stkno'#9'4'#9'庫別'#9#9
      'type'#9'2'#9'形態'#9#9
      'ableuse'#9'5'#9'可用庫存'#9#9
      'lowlevel'#9'2'#9'低階碼'#9#9
      'mrpcode'#9'1'#9'補貨政策'#9#9
      'stkunit'#9'4'#9'庫別單位'#9#9
      'dzdate'#9'10'#9'呆滯日期'#9#9
      'cfmcode'#9'2'#9'确認碼'#9#9
      'crtuser'#9'8'#9'建立人號'#9#9
      'crtedate'#9'10'#9'建立日期'#9#9
      'mdfuser'#9'8'#9'修改人'#9#9
      'mdfdate'#9'10'#9'修改日期'#9#9)
    IniAttributes.Delimiter = ';;'
    TitleColor = clBtnFace
    FixedCols = 1
    ShowHorzScrollBar = True
    Align = alClient
    DataSource = ds_query
    Font.Charset = CHINESEBIG5_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '細明體'
    Font.Style = []
    ImeName = '王?拼音'
    KeyOptions = [dgEnterToTab]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgWordWrap, dgTrailingEllipsis, dgTabExitsOnLastCol, dgFixedResizable, dgFixedEditable, dgRowResize, dgFixedProportionalResize]
    ParentFont = False
    TabOrder = 1
    TitleAlignment = taLeftJustify
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -13
    TitleFont.Name = '細明體'
    TitleFont.Style = []
    TitleLines = 2
    TitleButtons = False
    PaintOptions.AlternatingRowRegions = [arrDataColumns, arrActiveDataColumn]
    PaintOptions.AlternatingRowColor = clBtnFace
  end
  object Query: TQuery
    DatabaseName = 'DS'
    SessionName = 'db_session'
    SQL.Strings = (
      'SELECT IMA01 AS PARTNO,'
      '       IMA02 AS PARTDESC,'
      '       IMA08 AS TYPE,'
      '       IMA262 AS ABLEUSE,'
      '       IMA35 AS STKNO,'
      '       IMA25 AS STKUNIT,'
      '       IMA902 AS DZDATE,'
      '       IMA16 AS LOWLEVEL,'
      '       IMA37 AS MRPCODE,'
      '       IMA901 AS CRTEDATE,'
      '       IMA131 AS ITEM,'
      '       IMAACTI AS  CFMCODE,'
      '       IMAUSER AS CRTUSER,'
      '       IMAMODU AS MDFUSER,'
      '       IMADATE AS MDFDATE'
      'FROM IMA_FILE'
      'WHERE IMA01 LIKE :PARTNO'
      'ORDER BY IMA01'
      ' ')
    Left = 132
    Top = 60
    ParamData = <
      item
        DataType = ftString
        Name = 'PARTNO'
        ParamType = ptInput
        Value = 'FFFFFFF'
      end>
  end
  object ds_query: TDataSource
    DataSet = Query
    Left = 160
    Top = 60
  end
end
