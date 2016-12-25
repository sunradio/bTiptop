object frmBqcI001: TfrmBqcI001
  Left = 245
  Top = 195
  ActiveControl = txtRevNo
  BorderStyle = bsDialog
  Caption = 'BqcI001 - 材料待檢驗查詢'
  ClientHeight = 299
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '細明體'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 12
    Top = 8
    Width = 317
    Height = 137
    Caption = '查詢條件一'
    TabOrder = 0
    object Label1: TLabel
      Left = 36
      Top = 24
      Width = 70
      Height = 13
      Caption = '收貨單號：'
    end
    object Label2: TLabel
      Left = 36
      Top = 52
      Width = 70
      Height = 13
      Caption = '採購單號：'
    end
    object Label4: TLabel
      Left = 36
      Top = 80
      Width = 70
      Height = 13
      Caption = '起始日期：'
    end
    object Label5: TLabel
      Left = 36
      Top = 108
      Width = 70
      Height = 13
      Caption = '結束日期：'
    end
    object txtRevNo: TEdit
      Left = 108
      Top = 20
      Width = 173
      Height = 21
      TabOrder = 0
    end
    object txtPoNo: TEdit
      Left = 108
      Top = 48
      Width = 173
      Height = 21
      TabOrder = 1
    end
    object DateStart: TDateTimePicker
      Left = 108
      Top = 76
      Width = 173
      Height = 21
      CalAlignment = dtaLeft
      Date = 38242.3912019907
      Time = 38242.3912019907
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 2
    end
    object DateEnd: TDateTimePicker
      Left = 108
      Top = 104
      Width = 173
      Height = 21
      CalAlignment = dtaLeft
      Date = 38242.3912710648
      Time = 38242.3912710648
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 152
    Width = 317
    Height = 81
    Caption = '查詢條件二'
    TabOrder = 1
    object Label3: TLabel
      Left = 36
      Top = 20
      Width = 70
      Height = 13
      Caption = '供應廠商：'
    end
    object Label8: TLabel
      Left = 36
      Top = 48
      Width = 70
      Height = 13
      Caption = '採購人員：'
    end
    object cmbVendor: TComboBox
      Left = 108
      Top = 16
      Width = 173
      Height = 21
      DropDownCount = 15
      ItemHeight = 13
      TabOrder = 0
      OnDropDown = cmbVendorDropDown
    end
    object cmbIRNo: TComboBox
      Left = 108
      Top = 44
      Width = 173
      Height = 21
      DropDownCount = 15
      ItemHeight = 13
      TabOrder = 1
      OnDropDown = cmbIRNoDropDown
    end
  end
  object BitBtn1: TBitBtn
    Left = 336
    Top = 12
    Width = 75
    Height = 25
    Caption = '確認'
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 336
    Top = 40
    Width = 75
    Height = 25
    Caption = '取消'
    TabOrder = 4
    Kind = bkCancel
  end
  object GroupBox3: TGroupBox
    Left = 12
    Top = 240
    Width = 317
    Height = 49
    Caption = '查詢條件三'
    TabOrder = 2
    object Label6: TLabel
      Left = 32
      Top = 20
      Width = 70
      Height = 13
      Caption = '材料料號：'
    end
    object txtPartno: TEdit
      Left = 108
      Top = 16
      Width = 173
      Height = 21
      TabOrder = 0
    end
  end
end
