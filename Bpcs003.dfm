object frmBpcs003: TfrmBpcs003
  Left = 192
  Top = 94
  ActiveControl = deCat01
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = '經銷商報備管理'
  ClientHeight = 544
  ClientWidth = 1002
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '細明體'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1002
    Height = 41
    ButtonHeight = 39
    ButtonWidth = 31
    Caption = 'ToolBar1'
    EdgeBorders = [ebLeft, ebTop, ebBottom]
    EdgeOuter = esNone
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
    object ToolButton4: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Caption = '查詢'
      ImageIndex = 27
      OnClick = ToolButton4Click
    end
    object ToolButton1: TToolButton
      Left = 35
      Top = 0
      Width = 13
      ImageIndex = 14
      Style = tbsSeparator
    end
    object ToolButton5: TToolButton
      Left = 48
      Top = 0
      Action = frmMain.acDFirst
      AutoSize = True
    end
    object ToolButton6: TToolButton
      Left = 83
      Top = 0
      Action = frmMain.acDPrior
      AutoSize = True
    end
    object ToolButton7: TToolButton
      Left = 118
      Top = 0
      Action = frmMain.acDNext
      AutoSize = True
    end
    object ToolButton8: TToolButton
      Left = 153
      Top = 0
      Action = frmMain.acDLast
      AutoSize = True
    end
    object ToolButton9: TToolButton
      Left = 188
      Top = 0
      Width = 10
      Caption = 'ToolButton9'
      ImageIndex = 17
      Style = tbsSeparator
    end
    object ToolButton13: TToolButton
      Left = 198
      Top = 0
      Action = frmMain.acDInsert
      AutoSize = True
    end
    object ToolButton2: TToolButton
      Left = 233
      Top = 0
      Action = frmMain.acDEdit
      AutoSize = True
    end
    object tbDel: TToolButton
      Left = 268
      Top = 0
      Action = frmMain.acDDelete
      AutoSize = True
    end
    object ToolButton12: TToolButton
      Left = 303
      Top = 0
      Action = frmMain.acDCancel
      AutoSize = True
    end
    object ToolButton18: TToolButton
      Left = 338
      Top = 0
      Action = frmMain.acDPost
      AutoSize = True
    end
    object tbSave: TToolButton
      Left = 373
      Top = 0
      Hint = '將資料保存到服務器'
      AutoSize = True
      Caption = '提交'
      ImageIndex = 7
      OnClick = tbSaveClick
    end
    object ToolButton15: TToolButton
      Left = 408
      Top = 0
      Width = 12
      Caption = 'ToolButton15'
      ImageIndex = 14
      Style = tbsSeparator
    end
    object ToolButton10: TToolButton
      Left = 420
      Top = 0
      AutoSize = True
      Caption = '關閉'
      ImageIndex = 13
      OnClick = ToolButton10Click
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 887
    Height = 503
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 1
    TabPosition = tpBottom
    object TabSheet2: TTabSheet
      Caption = '編輯'
      ImageIndex = 1
      object Label2: TLabel
        Left = 18
        Top = 13
        Width = 70
        Height = 13
        Caption = '報備編號：'
      end
      object Label3: TLabel
        Left = 450
        Top = 15
        Width = 70
        Height = 13
        Caption = '輸入日期：'
      end
      object Label4: TLabel
        Left = 224
        Top = 13
        Width = 42
        Height = 13
        Caption = '類別：'
      end
      object Label5: TLabel
        Left = 18
        Top = 39
        Width = 70
        Height = 13
        Caption = '經銷商名：'
      end
      object Label6: TLabel
        Left = 18
        Top = 64
        Width = 70
        Height = 13
        Caption = '部門編號：'
      end
      object Label7: TLabel
        Left = 18
        Top = 91
        Width = 70
        Height = 13
        Caption = '業務人員：'
      end
      object Label8: TLabel
        Left = 18
        Top = 116
        Width = 70
        Height = 13
        Caption = '終端客戶：'
      end
      object Label9: TLabel
        Left = 492
        Top = 116
        Width = 70
        Height = 13
        Caption = '終端用戶：'
      end
      object Label10: TLabel
        Left = 490
        Top = 39
        Width = 70
        Height = 13
        Caption = '經銷電話：'
      end
      object Label11: TLabel
        Left = 380
        Top = 91
        Width = 98
        Height = 13
        Caption = '公司業務電話：'
      end
      object Label12: TLabel
        Left = 18
        Top = 142
        Width = 70
        Height = 13
        Caption = '郵件地址：'
      end
      object Label13: TLabel
        Left = 488
        Top = 142
        Width = 70
        Height = 13
        Caption = '主要應用：'
      end
      object Label14: TLabel
        Left = 18
        Top = 167
        Width = 70
        Height = 13
        Caption = '原報價日：'
      end
      object Label15: TLabel
        Left = 230
        Top = 169
        Width = 70
        Height = 13
        Caption = '預計結案：'
      end
      object Label16: TLabel
        Left = 664
        Top = 17
        Width = 70
        Height = 13
        Caption = '立案日期：'
      end
      object Label17: TLabel
        Left = 32
        Top = 193
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = '競爭者：'
      end
      object Label18: TLabel
        Left = 232
        Top = 193
        Width = 42
        Height = 13
        Caption = '廠牌：'
      end
      object Label19: TLabel
        Left = 418
        Top = 193
        Width = 42
        Height = 13
        Caption = '同行：'
      end
      object Label20: TLabel
        Left = 606
        Top = 193
        Width = 70
        Height = 13
        Caption = '自家夥伴：'
      end
      object Label21: TLabel
        Left = 18
        Top = 216
        Width = 70
        Height = 13
        Caption = '追蹤日期：'
      end
      object deCat01: TwwDBEdit
        Left = 93
        Top = 11
        Width = 121
        Height = 19
        BorderStyle = bsNone
        Color = clAqua
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ReadOnly = True
        TabOrder = 0
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat02: TwwDBDateTimePicker
        Left = 526
        Top = 13
        Width = 121
        Height = 19
        TabStop = False
        BorderStyle = bsNone
        CalendarAttributes.Font.Charset = DEFAULT_CHARSET
        CalendarAttributes.Font.Color = clWindowText
        CalendarAttributes.Font.Height = -11
        CalendarAttributes.Font.Name = 'MS Sans Serif'
        CalendarAttributes.Font.Style = []
        Color = clMenu
        DataSource = dsMaster
        Epoch = 1950
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ReadOnly = True
        ShowButton = True
        TabOrder = 1
      end
      object deCat03: TwwDBComboBox
        Left = 270
        Top = 11
        Width = 163
        Height = 19
        ShowButton = True
        Style = csDropDownList
        MapList = True
        AllowClearKey = False
        BorderStyle = bsNone
        DataSource = dsMaster
        DropDownCount = 8
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ItemHeight = 0
        Items.Strings = (
          '1.高校&研究所'#9'1'
          '2.國防科研'#9'2'
          '3.內外資企業'#9'3'
          '4.台資企業'#9'4')
        Sorted = False
        TabOrder = 2
        UnboundDataType = wwDefault
      end
      object deCat04: TwwDBEdit
        Left = 93
        Top = 36
        Width = 121
        Height = 19
        BorderStyle = bsNone
        CharCase = ecUpperCase
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 3
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
        OnExit = deCat04Exit
        OnKeyPress = deCat04KeyPress
      end
      object deCat05: TwwDBEdit
        Left = 224
        Top = 37
        Width = 237
        Height = 19
        TabStop = False
        BorderStyle = bsNone
        Color = clMenu
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ReadOnly = True
        TabOrder = 4
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat08: TwwDBEdit
        Left = 93
        Top = 114
        Width = 384
        Height = 19
        BorderStyle = bsNone
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 11
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat09: TwwDBEdit
        Left = 569
        Top = 114
        Width = 123
        Height = 19
        BorderStyle = bsNone
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 12
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat10: TwwDBEdit
        Left = 568
        Top = 37
        Width = 123
        Height = 19
        BorderStyle = bsNone
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 5
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat11: TwwDBEdit
        Left = 484
        Top = 88
        Width = 123
        Height = 19
        BorderStyle = bsNone
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 10
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat12: TwwDBEdit
        Left = 93
        Top = 140
        Width = 384
        Height = 19
        BorderStyle = bsNone
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 13
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat13: TwwDBComboBox
        Left = 569
        Top = 139
        Width = 121
        Height = 19
        ShowButton = True
        Style = csDropDownList
        MapList = True
        AllowClearKey = False
        AutoDropDown = True
        BorderStyle = bsNone
        DataSource = dsMaster
        DropDownCount = 8
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ItemHeight = 0
        Items.Strings = (
          '1.教學'#9'1'
          '2.科研'#9'2'
          '3.品保'#9'3'
          '4.生產'#9'4')
        Sorted = False
        TabOrder = 14
        UnboundDataType = wwDefault
      end
      object deCat14: TwwDBDateTimePicker
        Left = 93
        Top = 165
        Width = 121
        Height = 19
        BorderStyle = bsNone
        CalendarAttributes.Font.Charset = DEFAULT_CHARSET
        CalendarAttributes.Font.Color = clWindowText
        CalendarAttributes.Font.Height = -11
        CalendarAttributes.Font.Name = 'MS Sans Serif'
        CalendarAttributes.Font.Style = []
        DataSource = dsMaster
        Epoch = 1950
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ShowButton = True
        TabOrder = 15
      end
      object deCat15: TwwDBDateTimePicker
        Left = 300
        Top = 165
        Width = 121
        Height = 19
        BorderStyle = bsNone
        CalendarAttributes.Font.Charset = DEFAULT_CHARSET
        CalendarAttributes.Font.Color = clWindowText
        CalendarAttributes.Font.Height = -11
        CalendarAttributes.Font.Name = 'MS Sans Serif'
        CalendarAttributes.Font.Style = []
        DataSource = dsMaster
        Epoch = 1950
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ShowButton = True
        TabOrder = 16
      end
      object deCat16: TwwCheckBox
        Left = 778
        Top = 46
        Width = 81
        Height = 17
        TabStop = False
        AlwaysTransparent = False
        Frame.Enabled = True
        DynamicCaption = True
        ValueChecked = 'Y'
        ValueUnchecked = 'N'
        DisplayValueChecked = '已立案'
        DisplayValueUnchecked = '未立案'
        NullAndBlankState = cbUnchecked
        Caption = '未立案'
        Color = clAqua
        DataSource = dsMaster
        ParentColor = False
        TabOrder = 18
        ReadOnly = True
      end
      object deCat17: TwwDBDateTimePicker
        Left = 737
        Top = 14
        Width = 121
        Height = 19
        TabStop = False
        BorderStyle = bsNone
        CalendarAttributes.Font.Charset = DEFAULT_CHARSET
        CalendarAttributes.Font.Color = clWindowText
        CalendarAttributes.Font.Height = -11
        CalendarAttributes.Font.Name = 'MS Sans Serif'
        CalendarAttributes.Font.Style = []
        Color = clBtnFace
        DataSource = dsMaster
        Epoch = 1950
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ReadOnly = True
        ShowButton = True
        TabOrder = 17
      end
      object deCat18: TwwDBEdit
        Left = 93
        Top = 190
        Width = 123
        Height = 19
        BorderStyle = bsNone
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 19
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat19: TwwDBEdit
        Left = 282
        Top = 190
        Width = 123
        Height = 19
        BorderStyle = bsNone
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 20
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat20: TwwDBEdit
        Left = 466
        Top = 190
        Width = 123
        Height = 19
        BorderStyle = bsNone
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 21
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat21: TwwDBEdit
        Left = 686
        Top = 190
        Width = 171
        Height = 19
        BorderStyle = bsNone
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 22
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat23: TwwCheckBox
        Left = 778
        Top = 71
        Width = 81
        Height = 14
        TabStop = False
        AlwaysTransparent = False
        Frame.Enabled = True
        DynamicCaption = True
        ValueChecked = 'Y'
        ValueUnchecked = 'N'
        DisplayValueChecked = '已接單'
        DisplayValueUnchecked = '未轉單'
        NullAndBlankState = cbUnchecked
        Caption = '未轉單'
        Color = clAqua
        DataSource = dsMaster
        ParentColor = False
        TabOrder = 23
        ReadOnly = True
      end
      object deCat24: TwwCheckBox
        Left = 778
        Top = 94
        Width = 81
        Height = 15
        TabStop = False
        AlwaysTransparent = False
        Frame.Enabled = True
        DynamicCaption = True
        ValueChecked = 'Y'
        ValueUnchecked = 'N'
        DisplayValueChecked = '已結案'
        DisplayValueUnchecked = '未結案'
        NullAndBlankState = cbUnchecked
        Caption = '未結案'
        Color = clAqua
        DataSource = dsMaster
        ParentColor = False
        TabOrder = 24
        ReadOnly = True
      end
      object deCat06: TwwDBEdit
        Left = 93
        Top = 61
        Width = 121
        Height = 19
        BorderStyle = bsNone
        CharCase = ecUpperCase
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 6
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
        OnExit = deCat06Exit
        OnKeyPress = deCat06KeyPress
      end
      object deCat07: TwwDBEdit
        Left = 93
        Top = 88
        Width = 121
        Height = 19
        BorderStyle = bsNone
        CharCase = ecUpperCase
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        TabOrder = 8
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
        OnExit = deCat07Exit
        OnKeyPress = deCat07KeyPress
      end
      object DBGrid: TDBGrid
        Left = 16
        Top = 302
        Width = 847
        Height = 161
        DataSource = dsDetail
        ImeName = '谷歌拼音?入法 2'
        Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 27
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = '細明體'
        TitleFont.Style = []
        OnColExit = DBGridColExit
        OnDrawColumnCell = DBGridDrawColumnCell
        OnEditButtonClick = DBGridEditButtonClick
        OnKeyPress = DBGridKeyPress
        Columns = <
          item
            Alignment = taCenter
            ButtonStyle = cbsNone
            Color = clMenu
            Expanded = False
            ReadOnly = True
            Width = 40
            Visible = True
          end
          item
            ButtonStyle = cbsEllipsis
            Expanded = False
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            ReadOnly = True
            Width = 180
            Visible = True
          end
          item
            Expanded = False
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            Width = 220
            Visible = True
          end
          item
            Expanded = False
            ReadOnly = True
            Visible = True
          end>
      end
      object deCat061: TwwDBEdit
        Left = 224
        Top = 62
        Width = 120
        Height = 19
        TabStop = False
        BorderStyle = bsNone
        Color = clScrollBar
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ReadOnly = True
        TabOrder = 7
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat071: TwwDBEdit
        Left = 224
        Top = 88
        Width = 121
        Height = 19
        TabStop = False
        BorderStyle = bsNone
        Color = clMenu
        DataSource = dsMaster
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ReadOnly = True
        TabOrder = 9
        UnboundDataType = wwDefault
        WantReturns = False
        WordWrap = False
      end
      object deCat22: TwwDBDateTimePicker
        Left = 93
        Top = 214
        Width = 121
        Height = 19
        BorderStyle = bsNone
        CalendarAttributes.Font.Charset = DEFAULT_CHARSET
        CalendarAttributes.Font.Color = clWindowText
        CalendarAttributes.Font.Height = -11
        CalendarAttributes.Font.Name = 'MS Sans Serif'
        CalendarAttributes.Font.Style = []
        DataSource = dsMaster
        Epoch = 1950
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ShowButton = True
        TabOrder = 25
      end
      object deCat25: TwwDBRichEdit
        Left = 93
        Top = 242
        Width = 764
        Height = 47
        TabStop = False
        ScrollBars = ssVertical
        AutoURLDetect = False
        BorderStyle = bsNone
        DataSource = dsMaster
        Font.Charset = CHINESEBIG5_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = '細明體'
        Font.Style = []
        Frame.Enabled = True
        ImeName = '谷歌拼音?入法 2'
        ParentFont = False
        PrintJobName = 'Delphi 5'
        TabOrder = 26
        WantTabs = True
        EditorCaption = 'Edit Rich Text'
        EditorPosition.Left = 0
        EditorPosition.Top = 0
        EditorPosition.Width = 0
        EditorPosition.Height = 0
        MeasurementUnits = muInches
        PrintMargins.Top = 1
        PrintMargins.Bottom = 1
        PrintMargins.Left = 1
        PrintMargins.Right = 1
        RichEditVersion = 2
        Data = {
          A80000007B5C727466315C616E73695C616E73696370673935305C6465666630
          5C6465666C616E67313033335C6465666C616E676665313032387B5C666F6E74
          74626C7B5C66305C666E696C5C6663686172736574313336205C2762325C2764
          335C2761395C2766615C2763355C2765393B7D7D0D0A5C766965776B696E6434
          5C7563315C706172645C6C616E67313032385C66305C66733230206465436174
          32355C7061720D0A7D0D0A00}
      end
    end
    object TabSheet1: TTabSheet
      Caption = '瀏覽'
      ImageIndex = 2
      object DBGridView: TDBGrid
        Left = 0
        Top = 0
        Width = 879
        Height = 475
        Align = alClient
        DataSource = dsMaster
        ImeName = '谷歌拼音?入法 2'
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = '細明體'
        TitleFont.Style = []
        OnDrawColumnCell = DBGridViewDrawColumnCell
        Columns = <
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end
          item
            Expanded = False
            Visible = True
          end>
      end
    end
  end
  object Panel1: TPanel
    Left = 887
    Top = 41
    Width = 115
    Height = 503
    Align = alRight
    TabOrder = 2
    object Button4: TButton
      Left = 12
      Top = 15
      Width = 93
      Height = 25
      Caption = '0.確認立案'
      TabOrder = 0
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 12
      Top = 39
      Width = 93
      Height = 25
      Caption = '1.成功接單'
      TabOrder = 1
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 12
      Top = 63
      Width = 93
      Height = 25
      Caption = '2.整張結案'
      TabOrder = 2
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 12
      Top = 87
      Width = 93
      Height = 25
      Caption = '3.單筆作廢'
      TabOrder = 3
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 12
      Top = 127
      Width = 93
      Height = 25
      Caption = '4.報備查詢'
      TabOrder = 4
      OnClick = Button8Click
    end
  end
  object usMaster: TUpdateSQL
    ModifySQL.Strings = (
      'UPDATE GWS::CAT_FILE'
      '   SET CAT03=:CAT03,'
      '       CAT04=:CAT04,'
      '       CAT05=:CAT05,'
      '       CAT06=:CAT06,'
      '       CAT061=:CAT061,'
      '       CAT07=:CAT07,'
      '       CAT071=:CAT071,'
      '       CAT08=:CAT08,'
      '       CAT09=:CAT09,'
      '       CAT10=:CAT10,'
      '       CAT11=:CAT11,'
      '       CAT12=:CAT12,'
      '       CAT13=:CAT13,'
      '       CAT14=:CAT14,'
      '       CAT15=:CAT15,'
      '       CAT18=:CAT18,'
      '       CAT19=:CAT19,'
      '       CAT20=:CAT20,'
      '       CAT21=:CAT21,'
      '       CAT22=:CAT22,'
      '       CAT25=:CAT25'
      ' WHERE CAT01=:OLD_CAT01'
      ' '
      ' ')
    InsertSQL.Strings = (
      
        'INSERT INTO GWS::CAT_FILE(CAT01,CAT02,CAT03,CAT04,CAT05,CAT06,CA' +
        'T061,CAT07,CAT071,'
      
        '                          CAT08,CAT09,CAT10,CAT11,CAT12,CAT13,CA' +
        'T14,'
      
        '                          CAT15,CAT16,CAT17,CAT18,CAT19,CAT20,CA' +
        'T21,'
      '                          CAT22,CAT23,CAT24,CAT25,CAT26)'
      
        'VALUES(:CAT01,:CAT02,:CAT03,:CAT04,:CAT05,:CAT06,:CAT061,:CAT07,' +
        ':CAT071,'
      '       :CAT08,:CAT09,:CAT10,:CAT11,:CAT12,:CAT13,:CAT14,'
      '       :CAT15,:CAT16,:CAT17,:CAT18,:CAT19,:CAT20,:CAT21,'
      '       :CAT22,:CAT23,:CAT24,:CAT25,:CAT26)'
      ' '
      ' '
      ' ')
    DeleteSQL.Strings = (
      'DELETE FROM GWS::CAT_FILE'
      ' WHERE CAT01=:OLD_CAT01')
    Left = 518
    Top = 60
  end
  object MasterQuery: TQuery
    CachedUpdates = True
    AfterOpen = MasterQueryAfterOpen
    BeforeInsert = MasterQueryBeforeInsert
    BeforeEdit = MasterQueryBeforeEdit
    BeforeDelete = MasterQueryBeforeDelete
    AfterScroll = MasterQueryAfterScroll
    OnNewRecord = MasterQueryNewRecord
    AutoRefresh = True
    DatabaseName = 'DS'
    SessionName = 'db_session'
    SQL.Strings = (
      'SELECT *'
      '  FROM GWS::CAT_FILE'
      'WHERE CAT02=TODAY'
      'ORDER BY CAT01 DESC')
    UpdateObject = usMaster
    Left = 488
    Top = 60
  end
  object dsMaster: TDataSource
    DataSet = MasterQuery
    Left = 546
    Top = 60
  end
  object DetailQuery: TQuery
    CachedUpdates = True
    BeforeOpen = DetailQueryBeforeOpen
    AfterOpen = DetailQueryAfterOpen
    BeforeInsert = DetailQueryBeforeInsert
    BeforeEdit = DetailQueryBeforeEdit
    BeforePost = DetailQueryBeforePost
    BeforeDelete = DetailQueryBeforeDelete
    OnNewRecord = DetailQueryNewRecord
    AutoRefresh = True
    DatabaseName = 'DS'
    SessionName = 'db_session'
    SQL.Strings = (
      'SELECT *'
      ' FROM GWS::CAS_FILE'
      'WHERE CAS01='#39'AAA'#39)
    UpdateObject = usDetail
    Left = 628
    Top = 61
  end
  object dsDetail: TDataSource
    DataSet = DetailQuery
    Left = 682
    Top = 61
  end
  object usDetail: TUpdateSQL
    ModifySQL.Strings = (
      'UPDATE GWS::CAS_FILE'
      '   SET CAS03=:CAS03,'
      '        CAS031=:CAS031,'
      '        CAS04=:CAS04,'
      '        CAS05=:CAS05,'
      '        CAS06=:CAS06,'
      '        CAS07=:CAS07'
      '  WHERE CAS01=:OLD_CAS01 AND CAS02=:OLD_CAS02      '
      ' ')
    InsertSQL.Strings = (
      
        'INSERT INTO GWS::CAS_FILE(CAS01,CAS02,CAS03,CAS031,CAS04,CAS05,C' +
        'AS06,CAS07,CAS08)'
      
        'VALUES(:CAS01,:CAS02,:CAS03,:CAS031,:CAS04,:CAS05,:CAS06,:CAS07,' +
        ':CAS08)')
    DeleteSQL.Strings = (
      'DELETE  FROM GWS::CAS_FILE'
      ' WHERE CAS01=:OLD_CAS01 AND CAS02=:OLD_CAS02')
    Left = 656
    Top = 61
  end
end
