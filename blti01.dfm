object frmBlt01: TfrmBlt01
  Left = 272
  Top = 217
  BorderStyle = bsDialog
  Caption = 'blti01 - 期長材料運算'
  ClientHeight = 274
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '細明體'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 8
    Top = 224
    Width = 353
    Height = 41
    AutoSize = False
    Caption = 
      '提示： 這個程序為獲得最新的用料需展BOM，會用較多的時間，請耐心等' +
      '候。'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = '細明體'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 8
    Top = 212
    Width = 361
    Height = 5
    Shape = bsTopLine
  end
  object BitBtn1: TBitBtn
    Left = 280
    Top = 13
    Width = 75
    Height = 25
    Caption = '確認'
    TabOrder = 0
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 280
    Top = 41
    Width = 75
    Height = 25
    Caption = '取消'
    TabOrder = 1
    Kind = bkCancel
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 261
    Height = 197
    Caption = '運算條件'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '細明體'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label1: TLabel
      Left = 28
      Top = 24
      Width = 63
      Height = 13
      Caption = '*企划年月'
    end
    object Label2: TLabel
      Left = 28
      Top = 52
      Width = 63
      Height = 13
      Caption = '*運算版本'
    end
    object Label3: TLabel
      Left = 28
      Top = 76
      Width = 63
      Height = 13
      Caption = '*不含廠商'
    end
    object Label4: TLabel
      Left = 28
      Top = 104
      Width = 63
      Height = 13
      Caption = '*期長定義'
    end
    object Label5: TLabel
      Left = 32
      Top = 132
      Width = 56
      Height = 13
      Caption = '材料大類'
    end
    object Label6: TLabel
      Left = 32
      Top = 160
      Width = 56
      Height = 13
      Caption = '采購人員'
    end
    object Label9: TLabel
      Left = 154
      Top = 132
      Width = 14
      Height = 13
      Caption = '至'
    end
    object txtYm: TEdit
      Left = 100
      Top = 24
      Width = 121
      Height = 21
      ImeName = '點[開始程序]或Ctrl+Alt+W啟動萬能五筆'
      TabOrder = 0
    end
    object txtVer: TEdit
      Left = 100
      Top = 52
      Width = 121
      Height = 21
      ImeName = '點[開始程序]或Ctrl+Alt+W啟動萬能五筆'
      TabOrder = 1
    end
    object txtLtDefine: TEdit
      Left = 100
      Top = 104
      Width = 121
      Height = 21
      ImeName = '點[開始程序]或Ctrl+Alt+W啟動萬能五筆'
      TabOrder = 2
    end
    object txtItemStart: TEdit
      Left = 100
      Top = 132
      Width = 49
      Height = 21
      ImeName = '點[開始程序]或Ctrl+Alt+W啟動萬能五筆'
      TabOrder = 3
    end
    object txtItemEnd: TEdit
      Left = 172
      Top = 132
      Width = 49
      Height = 21
      ImeName = '點[開始程序]或Ctrl+Alt+W啟動萬能五筆'
      TabOrder = 4
    end
    object txtIrNo: TEdit
      Left = 100
      Top = 160
      Width = 121
      Height = 21
      ImeName = '點[開始程序]或Ctrl+Alt+W啟動萬能五筆'
      TabOrder = 5
    end
    object txtVendorA: TEdit
      Left = 100
      Top = 76
      Width = 121
      Height = 21
      ImeName = '點[開始程序]或Ctrl+Alt+W啟動萬能五筆'
      TabOrder = 6
    end
  end
end
