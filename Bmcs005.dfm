object frmBmcs005: TfrmBmcs005
  Left = 264
  Top = 215
  Width = 498
  Height = 346
  Caption = 'bmcs005 - ���������O�����@'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '�ө���'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tbDataTool: TToolBar
    Left = 0
    Top = 0
    Width = 490
    Height = 41
    AutoSize = True
    ButtonHeight = 39
    ButtonWidth = 31
    Caption = 'tbDataTool'
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Images = frmMain.Image
    ParentFont = False
    ShowCaptions = True
    TabOrder = 0
    object ToolButton7: TToolButton
      Left = 0
      Top = 0
      Hint = '�R���������'
      AutoSize = True
      Caption = '�R��'
      ImageIndex = 5
      OnClick = ToolButton7Click
    end
    object ToolButton10: TToolButton
      Left = 35
      Top = 0
      Width = 10
      Caption = 'ToolButton10'
      ImageIndex = 11
      Style = tbsSeparator
    end
    object ToolButton9: TToolButton
      Left = 45
      Top = 0
      AutoSize = True
      Caption = '�ɥX'
      ImageIndex = 28
      OnClick = ToolButton9Click
    end
  end
  object DBGrid: TwwDBGrid
    Left = 0
    Top = 41
    Width = 490
    Height = 278
    Selected.Strings = (
      'mce_idno'#9'10'#9'�s��'
      'mce_ver'#9'8'#9'����'
      'mce_time'#9'15'#9'�������'#9'F'
      'mce_uset'#9'50'#9'�����ή�'
      'mce_vlue'#9'65'#9'��������'
      'mce_recn'#9'10'#9'���͵���'
      'mce_user'#9'10'#9'�����H')
    IniAttributes.Delimiter = ';;'
    TitleColor = clBtnFace
    FixedCols = 0
    ShowHorzScrollBar = True
    Align = alClient
    DataSource = ds_bmcs005
    ImeName = '���X����'
    ReadOnly = True
    TabOrder = 1
    TitleAlignment = taLeftJustify
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = '�ө���'
    TitleFont.Style = []
    TitleLines = 1
    TitleButtons = False
    PaintOptions.AlternatingRowRegions = [arrDataColumns, arrActiveDataColumn]
    PaintOptions.AlternatingRowColor = clBtnFace
  end
  object ds_bmcs005: TDataSource
    DataSet = tbl_bmcs005
    Left = 320
    Top = 8
  end
  object tbl_bmcs005: TTable
    DatabaseName = 'DS'
    SessionName = 'db_session'
    IndexFieldNames = 'mce_idno'
    ReadOnly = True
    TableName = 'GWS:MCE_FILE'
    Left = 284
    Top = 10
    object tbl_bmcs005mce_idno: TIntegerField
      DisplayLabel = '�s��'
      DisplayWidth = 10
      FieldName = 'mce_idno'
    end
    object tbl_bmcs005mce_ver: TStringField
      DisplayLabel = '����'
      DisplayWidth = 8
      FieldName = 'mce_ver'
      Size = 8
    end
    object tbl_bmcs005mce_time: TStringField
      DisplayLabel = '�������'
      DisplayWidth = 15
      FieldName = 'mce_time'
      Size = 25
    end
    object tbl_bmcs005mce_uset: TStringField
      DisplayLabel = '�����ή�'
      DisplayWidth = 50
      FieldName = 'mce_uset'
      Size = 50
    end
    object tbl_bmcs005mce_vlue: TStringField
      DisplayLabel = '��������'
      DisplayWidth = 65
      FieldName = 'mce_vlue'
      Size = 65
    end
    object tbl_bmcs005mce_recn: TIntegerField
      DisplayLabel = '���͵���'
      DisplayWidth = 10
      FieldName = 'mce_recn'
    end
    object tbl_bmcs005mce_user: TStringField
      DisplayLabel = '�����H'
      DisplayWidth = 10
      FieldName = 'mce_user'
      Size = 10
    end
  end
end
