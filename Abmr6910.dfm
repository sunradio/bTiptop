object frmAbmr6910: TfrmAbmr6910
  Left = 258
  Top = 230
  BorderStyle = bsDialog
  Caption = 'abmr691 - BOM 比較查詢作業'
  ClientHeight = 132
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '細明體'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 113
    Caption = '1.需比較產品品號'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '細明體'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lblPartA: TLabel
      Left = 12
      Top = 20
      Width = 42
      Height = 13
      Caption = '產品一'
    end
    object lblPartB: TLabel
      Left = 12
      Top = 64
      Width = 42
      Height = 13
      Caption = '產品二'
    end
    object txtPartA: TEdit
      Left = 12
      Top = 36
      Width = 153
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ImeMode = imClose
      ImeName = 'Chinese (Simplified) - Microsoft Pinyin IME 3.0'
      MaxLength = 12
      ParentFont = False
      TabOrder = 0
    end
    object txtPartB: TEdit
      Left = 12
      Top = 80
      Width = 153
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ImeMode = imClose
      ImeName = 'Chinese (Simplified) - Microsoft Pinyin IME 3.0'
      MaxLength = 12
      ParentFont = False
      TabOrder = 1
    end
  end
  object BitBtn3: TBitBtn
    Left = 204
    Top = 12
    Width = 75
    Height = 25
    Caption = '確認'
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn4: TBitBtn
    Left = 204
    Top = 40
    Width = 75
    Height = 25
    Caption = '取消'
    TabOrder = 2
    Kind = bkCancel
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 208
    Width = 381
    Height = 125
    Caption = '2.其它查詢條件'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '細明體'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 315
      Height = 13
      Caption = '1.資料選項[1.全部資料 2.共同料 3.差异料]....:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 315
      Height = 13
      Caption = '2.半成品是否顯示............................:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 60
      Width = 315
      Height = 13
      Caption = '3.源材料是否顯示............................:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 80
      Width = 315
      Height = 13
      Caption = '4.料件品名是否顯示..........................:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 8
      Top = 100
      Width = 315
      Height = 13
      Caption = '5.材料相關信息是否顯示......................:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
    end
    object txtSelect: TEdit
      Left = 332
      Top = 16
      Width = 33
      Height = 21
      ImeName = 'Chinese (Simplified) - Microsoft Pinyin IME 3.0'
      MaxLength = 1
      TabOrder = 0
      Text = '3'
    end
    object cbPcb: TCheckBox
      Left = 332
      Top = 40
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object cbRaw: TCheckBox
      Left = 332
      Top = 60
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cbDesc: TCheckBox
      Left = 332
      Top = 80
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object cbRe: TCheckBox
      Left = 332
      Top = 100
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
end
