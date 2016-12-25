object frmBmcs001: TfrmBmcs001
  Left = 255
  Top = 178
  ActiveControl = txtPlanno
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'bmcs001 - 模擬缺料機種維護'
  ClientHeight = 313
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '細明體'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tbDataEdit: TToolBar
    Left = 454
    Top = 44
    Width = 35
    Height = 269
    Align = alRight
    AutoSize = True
    ButtonHeight = 39
    ButtonWidth = 31
    Caption = 'tbDataEdit'
    Color = clBtnFace
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Images = frmMain.Image
    ParentColor = False
    ParentFont = False
    ShowCaptions = True
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Action = frmMain.acDInsert
      AutoSize = True
      Wrap = True
    end
    object ToolButton2: TToolButton
      Left = 0
      Top = 39
      Action = frmMain.acDDelete
      AutoSize = True
      Wrap = True
    end
    object ToolButton3: TToolButton
      Left = 0
      Top = 78
      Action = frmMain.acDEdit
      AutoSize = True
      Wrap = True
    end
    object ToolButton4: TToolButton
      Left = 0
      Top = 117
      Action = frmMain.acDPost
      AutoSize = True
      Wrap = True
    end
    object ToolButton5: TToolButton
      Left = 0
      Top = 156
      Action = frmMain.acDCancel
      AutoSize = True
      Wrap = True
    end
    object ToolButton6: TToolButton
      Left = 0
      Top = 195
      Action = frmMain.DataSetRefresh1
      AutoSize = True
    end
  end
  object tbDataTool: TToolBar
    Left = 0
    Top = 0
    Width = 489
    Height = 44
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
    TabOrder = 1
    object tbQuery: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Caption = '查詢'
      ImageIndex = 27
      OnClick = tbQueryClick
    end
    object ToolButton15: TToolButton
      Left = 35
      Top = 0
      Width = 10
      Caption = 'ToolButton15'
      ImageIndex = 14
      Style = tbsSeparator
    end
    object tbDelete: TToolButton
      Left = 45
      Top = 0
      Hint = '刪除指定排程'
      AutoSize = True
      Caption = '批刪'
      ImageIndex = 5
      OnClick = tbDeleteClick
    end
    object tbCommit: TToolButton
      Left = 80
      Top = 0
      AutoSize = True
      Caption = '提交'
      ImageIndex = 7
      OnClick = tbCommitClick
    end
    object ToolButton10: TToolButton
      Left = 115
      Top = 0
      Width = 10
      Caption = 'ToolButton10'
      ImageIndex = 11
      Style = tbsSeparator
    end
    object tbExport: TToolButton
      Left = 125
      Top = 0
      AutoSize = True
      Caption = '導出'
      ImageIndex = 28
      OnClick = tbExportClick
    end
    object ToolButton12: TToolButton
      Left = 160
      Top = 0
      Width = 10
      Caption = 'ToolButton12'
      ImageIndex = 17
      Style = tbsSeparator
    end
    object ToolButton7: TToolButton
      Left = 170
      Top = 0
      Action = frmMain.acDFirst
      AutoSize = True
    end
    object ToolButton8: TToolButton
      Left = 205
      Top = 0
      Action = frmMain.acDPrior
      AutoSize = True
    end
    object ToolButton9: TToolButton
      Left = 240
      Top = 0
      Action = frmMain.acDNext
      AutoSize = True
    end
    object ToolButton11: TToolButton
      Left = 275
      Top = 0
      Action = frmMain.acDLast
      AutoSize = True
    end
    object ToolButton13: TToolButton
      Left = 310
      Top = 0
      Width = 10
      Caption = 'ToolButton13'
      ImageIndex = 17
      Style = tbsSeparator
    end
    object ToolButton14: TToolButton
      Left = 320
      Top = 0
      Action = frmMain.WindowClose1
      AutoSize = True
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 44
    Width = 454
    Height = 269
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Edit'
      object lblDb: TLabel
        Left = 268
        Top = 56
        Width = 56
        Height = 13
        Caption = '資料來源'
      end
      object lblOrds: TLabel
        Left = 12
        Top = 56
        Width = 56
        Height = 13
        Caption = '優先順序'
      end
      object lblStar: TLabel
        Left = 140
        Top = 56
        Width = 56
        Height = 13
        Caption = '預計開工'
      end
      object lblWono: TLabel
        Left = 140
        Top = 12
        Width = 56
        Height = 13
        Caption = '工單號碼'
      end
      object lblPlanno: TLabel
        Left = 12
        Top = 12
        Width = 56
        Height = 13
        Caption = '排程版本'
      end
      object txtDb: TDBEdit
        Left = 268
        Top = 72
        Width = 121
        Height = 21
        DataField = 'mca_db'
        DataSource = ds_bmcs001_a
        Enabled = False
        ImeName = '王碼拼音'
        ReadOnly = True
        TabOrder = 4
      end
      object txtOrds: TDBEdit
        Left = 12
        Top = 72
        Width = 121
        Height = 21
        DataField = 'mca_ords'
        DataSource = ds_bmcs001_a
        ImeName = '王碼拼音'
        TabOrder = 2
      end
      object txtStar: TDBEdit
        Left = 140
        Top = 72
        Width = 121
        Height = 21
        DataField = 'mca_star'
        DataSource = ds_bmcs001_a
        ImeName = '王碼拼音'
        TabOrder = 3
      end
      object GroupBox1: TGroupBox
        Left = 12
        Top = 100
        Width = 405
        Height = 129
        Caption = '工單相關資訊'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = '細明體'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 5
        object DBText4: TDBText
          Left = 92
          Top = 20
          Width = 97
          Height = 17
          Color = clCaptionText
          DataField = 'sfb01'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DBText2: TDBText
          Left = 308
          Top = 20
          Width = 77
          Height = 17
          Color = clCaptionText
          DataField = 'sfb04'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DBText3: TDBText
          Left = 92
          Top = 40
          Width = 97
          Height = 17
          Color = clCaptionText
          DataField = 'sfb05'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DBText5: TDBText
          Left = 92
          Top = 60
          Width = 77
          Height = 17
          Alignment = taRightJustify
          Color = clCaptionText
          DataField = 'sfb08'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DBText6: TDBText
          Left = 92
          Top = 80
          Width = 77
          Height = 17
          Alignment = taRightJustify
          Color = clCaptionText
          DataField = 'sfb081'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DBText7: TDBText
          Left = 92
          Top = 100
          Width = 77
          Height = 17
          Alignment = taRightJustify
          Color = clCaptionText
          DataField = 'sfb09'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DBText8: TDBText
          Left = 308
          Top = 40
          Width = 77
          Height = 17
          Alignment = taRightJustify
          Color = clCaptionText
          DataField = 'sfb13'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DBText9: TDBText
          Left = 308
          Top = 60
          Width = 77
          Height = 17
          Alignment = taRightJustify
          Color = clCaptionText
          DataField = 'sfb25'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DBText1: TDBText
          Left = 308
          Top = 80
          Width = 77
          Height = 17
          Alignment = taRightJustify
          Color = clCaptionText
          DataField = 'sfb28'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object DBText10: TDBText
          Left = 308
          Top = 100
          Width = 77
          Height = 17
          Alignment = taRightJustify
          Color = clCaptionText
          DataField = 'sfb30'
          DataSource = ds_bmcs001_b
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = '細明體'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object lblWonoa: TLabel
          Left = 30
          Top = 20
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = '工單號碼'
        end
        object lblWoStatus: TLabel
          Left = 246
          Top = 20
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = '工單狀態'
        end
        object lblPart: TLabel
          Left = 30
          Top = 40
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = '料件編號'
        end
        object lblWoQty: TLabel
          Left = 30
          Top = 60
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = '生產數量'
        end
        object lblIsQty: TLabel
          Left = 16
          Top = 80
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = '已發料套數'
        end
        object lblInQty: TLabel
          Left = 16
          Top = 100
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = '完工入庫數'
        end
        object lblStartDate: TLabel
          Left = 218
          Top = 40
          Width = 84
          Height = 13
          Alignment = taRightJustify
          Caption = '預計生產日期'
        end
        object lblActDate: TLabel
          Left = 232
          Top = 60
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = '實際開工日'
        end
        object lblClose: TLabel
          Left = 218
          Top = 80
          Width = 84
          Height = 13
          Alignment = taRightJustify
          Caption = '工單結案狀態'
        end
        object lblStkNo: TLabel
          Left = 204
          Top = 100
          Width = 98
          Height = 13
          Alignment = taRightJustify
          Caption = '預計完工入庫別'
        end
      end
      object txtPlanno: TDBEdit
        Left = 12
        Top = 28
        Width = 121
        Height = 21
        DataField = 'mca_ym'
        DataSource = ds_bmcs001_a
        ImeName = '王碼拼音'
        TabOrder = 0
      end
      object txtWono: TDBEdit
        Left = 140
        Top = 28
        Width = 121
        Height = 21
        DataField = 'mca_wono'
        DataSource = ds_bmcs001_a
        ImeName = '王碼拼音'
        TabOrder = 1
        OnExit = txtWonoExit
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'View'
      ImageIndex = 1
      object wwDBGrid1: TwwDBGrid
        Left = 0
        Top = 0
        Width = 446
        Height = 241
        Selected.Strings = (
          'mca_ym'#9'8'#9'排程版本'
          'mca_ords'#9'8'#9'優先順序'
          'mca_wono'#9'10'#9'工單號碼'
          'mca_part'#9'12'#9'產品品號'
          'mca_star'#9'10'#9'預計開工'
          'mca_db'#9'8'#9'資料來源')
        IniAttributes.Delimiter = ';;'
        TitleColor = clBtnFace
        FixedCols = 0
        ShowHorzScrollBar = True
        Align = alClient
        DataSource = ds_bmcs001_a
        ImeName = '王碼拼音'
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgWordWrap]
        ReadOnly = True
        TabOrder = 0
        TitleAlignment = taLeftJustify
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = '細明體'
        TitleFont.Style = []
        TitleLines = 1
        TitleButtons = False
      end
    end
  end
  object ds_bmcs001_a: TDataSource
    DataSet = qry_bmcs001_a
    Left = 356
    Top = 4
  end
  object qry_bmcs001_a: TQuery
    CachedUpdates = True
    BeforeOpen = qry_bmcs001_aBeforeOpen
    BeforeClose = qry_bmcs001_aBeforeClose
    BeforeDelete = qry_bmcs001_aBeforeDelete
    OnNewRecord = qry_bmcs001_aNewRecord
    DatabaseName = 'DS'
    SessionName = 'db_session'
    SQL.Strings = (
      'SELECT MCA_YM,'
      '       MCA_ORDS,'
      '       MCA_WONO,'
      '       MCA_STAR,'
      '       MCA_DB'
      '  FROM GWS::MCA_FILE'
      ' WHERE MCA_YM BETWEEN :BEGINYM AND :ENDYM'
      ' ')
    UpdateObject = UpdateSQL1
    Left = 204
    Top = 58
    ParamData = <
      item
        DataType = ftString
        Name = 'BEGINYM'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'ENDYM'
        ParamType = ptInput
      end>
    object qry_bmcs001_amca_ym: TStringField
      DisplayLabel = '排程版本'
      DisplayWidth = 8
      FieldName = 'mca_ym'
      KeyFields = 'mca_ym'
      Required = True
      Size = 8
    end
    object qry_bmcs001_amca_ords: TSmallintField
      DisplayLabel = '優先順序'
      DisplayWidth = 8
      FieldName = 'mca_ords'
      KeyFields = 'mca_ords'
      Required = True
    end
    object qry_bmcs001_amca_wono: TStringField
      DisplayLabel = '工單號碼'
      DisplayWidth = 10
      FieldName = 'mca_wono'
      Required = True
      Size = 10
    end
    object qry_bmcs001_amca_star: TDateField
      DisplayLabel = '預計開工'
      DisplayWidth = 10
      FieldName = 'mca_star'
      Required = True
      EditMask = '!9999/99/00;1;_'
    end
    object qry_bmcs001_amca_db: TStringField
      DisplayLabel = '資料來源'
      DisplayWidth = 8
      FieldName = 'mca_db'
      Required = True
      Size = 5
    end
  end
  object qry_bmcs001_b: TQuery
    DatabaseName = 'DS'
    SessionName = 'db_session'
    DataSource = ds_bmcs001_a
    SQL.Strings = (
      'SELECT SFB01,'
      '       CASE WHEN SFB04='#39'1'#39'  THEN '#39'確認生產'#39'        '
      '            WHEN SFB04='#39'2'#39'  THEN '#39'已發放未印'#39
      '            WHEN SFB04='#39'3'#39'  THEN '#39'已發放已印'#39
      '            WHEN SFB04='#39'4'#39'  THEN '#39'工單已發料'#39
      '            WHEN SFB04='#39'5'#39'  THEN '#39'在製過程中'#39
      '            WHEN SFB04='#39'6'#39'  THEN '#39'進入F.Q.C'#39
      '            WHEN SFB04='#39'7'#39'  THEN '#39'完工入庫'#39
      '            WHEN SFB04='#39'8'#39'  THEN '#39'結案'#39
      '       END   AS SFB04,'
      '       SFB05,'
      '       SFB08,'
      '       SFB081,'
      '       SFB09,'
      '       SFB13,'
      '       SFB25,'
      '       SFB28,'
      '       SFB30'
      '  FROM DS2::SFB_FILE'
      ' WHERE (SFB08-SFB09)>0 AND SFB01 =:MCA_WONO'
      ''
      'UNION ALL'
      ''
      'SELECT SFB01,'
      '       CASE WHEN SFB04='#39'1'#39'  THEN '#39'確認生產'#39'        '
      '            WHEN SFB04='#39'2'#39'  THEN '#39'已發放未印'#39
      '            WHEN SFB04='#39'3'#39'  THEN '#39'已發放已印'#39
      '            WHEN SFB04='#39'4'#39'  THEN '#39'工單已發料'#39
      '            WHEN SFB04='#39'5'#39'  THEN '#39'在製過程中'#39
      '            WHEN SFB04='#39'6'#39'  THEN '#39'進入F.Q.C'#39
      '            WHEN SFB04='#39'7'#39'  THEN '#39'完工入庫'#39
      '            WHEN SFB04='#39'8'#39'  THEN '#39'結案'#39
      '       END   AS SFB04,'
      '       SFB05,'
      '       SFB08,'
      '       SFB081,'
      '       SFB09,'
      '       SFB13,'
      '       SFB25,'
      '       SFB28,'
      '       SFB30'
      '  FROM DS3::SFB_FILE'
      ' WHERE (SFB08-SFB09)>0  AND SFB01 =:MCA_WONO'
      ' '
      ' '
      ' ')
    Left = 236
    Top = 58
    ParamData = <
      item
        DataType = ftString
        Name = 'mca_wono'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'MCA_WONO'
        ParamType = ptInput
      end>
  end
  object ds_bmcs001_b: TDataSource
    DataSet = qry_bmcs001_b
    Left = 388
    Top = 6
  end
  object UpdateSQL1: TUpdateSQL
    ModifySQL.Strings = (
      'update GWS::MCA_FILE'
      'set'
      '  mca_ym = :mca_ym,'
      '  mca_ords = :mca_ords,'
      '  mca_wono = :mca_wono,'
      '  mca_star = :mca_star,'
      '  mca_db = :mca_db'
      'where'
      '  mca_ym = :OLD_mca_ym and'
      '  mca_ords = :OLD_mca_ords ')
    InsertSQL.Strings = (
      'insert into GWS::MCA_FILE'
      '  (mca_ym, mca_ords, mca_wono, mca_star, mca_db)'
      'values'
      '  (:mca_ym, :mca_ords, :mca_wono, :mca_star, :mca_db)')
    DeleteSQL.Strings = (
      'delete from GWS::MCA_FILE'
      'where'
      '  mca_ym = :OLD_mca_ym and'
      '  mca_ords = :OLD_mca_ords '
      '')
    Left = 236
    Top = 102
  end
end
