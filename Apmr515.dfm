object frmApmr515: TfrmApmr515
  Left = 232
  Top = 204
  Width = 557
  Height = 361
  Caption = 'apmr515 - �t�Ӷi�Ʃ��Ӫ�'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '�ө���'
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
    Font.Name = '�ө���'
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
      Caption = '�t�ӽs��'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = '�ө���'
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
      ImeName = '���X����'
      MaxLength = 12
      TabOrder = 0
      OnKeyDown = txtWonoKeyDown
    end
    object tbRun: TToolButton
      Left = 210
      Top = 0
      Hint = '����d��'
      ImageIndex = 2
      OnClick = tbRunClick
    end
    object tbExport: TToolButton
      Left = 233
      Top = 0
      Hint = '�d�߸�ƿ�X'
      Caption = 'tbExport'
      ImageIndex = 10
      OnClick = tbExportClick
    end
    object tbFind: TToolButton
      Left = 256
      Top = 0
      Hint = '�d����'
      Caption = 'tbFind'
      ImageIndex = 4
      OnClick = tbFindClick
    end
    object tbFilter: TToolButton
      Left = 279
      Top = 0
      Hint = '�L�o���'
      Caption = 'tbFilter'
      ImageIndex = 6
      OnClick = tbFilterClick
    end
    object tbRemove: TToolButton
      Left = 302
      Top = 0
      Hint = '�����L�o����'
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
      'partno'#9'14'#9'���ƮƸ�'#9#9
      'partdesc'#9'30'#9'���ƴy�z'#9#9
      'item'#9'6'#9'���O'#9#9
      'stkno'#9'4'#9'�w�O'#9#9
      'type'#9'2'#9'�κA'#9#9
      'ableuse'#9'5'#9'�i�ήw�s'#9#9
      'lowlevel'#9'2'#9'�C���X'#9#9
      'mrpcode'#9'1'#9'�ɳf�F��'#9#9
      'stkunit'#9'4'#9'�w�O���'#9#9
      'dzdate'#9'10'#9'�b�����'#9#9
      'cfmcode'#9'2'#9'�̻{�X'#9#9
      'crtuser'#9'8'#9'�إߤH��'#9#9
      'crtedate'#9'10'#9'�إߤ��'#9#9
      'mdfuser'#9'8'#9'�ק�H'#9#9
      'mdfdate'#9'10'#9'�ק���'#9#9)
    IniAttributes.Delimiter = ';;'
    TitleColor = clBtnFace
    FixedCols = 1
    ShowHorzScrollBar = True
    Align = alClient
    DataSource = ds_query
    Font.Charset = CHINESEBIG5_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '�ө���'
    Font.Style = []
    ImeName = '��?����'
    KeyOptions = [dgEnterToTab]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgWordWrap, dgTrailingEllipsis, dgTabExitsOnLastCol, dgFixedResizable, dgFixedEditable, dgRowResize, dgFixedProportionalResize]
    ParentFont = False
    TabOrder = 1
    TitleAlignment = taLeftJustify
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -13
    TitleFont.Name = '�ө���'
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
