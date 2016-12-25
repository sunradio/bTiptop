object frmAimr406: TfrmAimr406
  Left = 377
  Top = 256
  Width = 282
  Height = 175
  Caption = '庫存金額查詢'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '細明體'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 177
    Height = 133
    Caption = '查詢條件'
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 76
      Width = 28
      Height = 13
      Caption = '金額'
    end
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 28
      Height = 13
      Caption = '條件'
    end
    object Edit2: TEdit
      Left = 8
      Top = 96
      Width = 145
      Height = 21
      ImeName = 'Chinese (Simplified) - Microsoft Pinyin IME 3.0'
      TabOrder = 0
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 40
      Width = 145
      Height = 21
      ImeName = 'Chinese (Simplified) - Microsoft Pinyin IME 3.0'
      ItemHeight = 13
      TabOrder = 1
      Text = '>='
      Items.Strings = (
        '='
        '>'
        '<'
        '>='
        '<='
        '<>'
        '!=')
    end
  end
  object btOk: TBitBtn
    Left = 192
    Top = 14
    Width = 75
    Height = 24
    Caption = '確認'
    TabOrder = 1
    Kind = bkOK
  end
  object btCancel: TBitBtn
    Left = 192
    Top = 40
    Width = 75
    Height = 24
    Caption = '取消'
    TabOrder = 2
    Kind = bkCancel
  end
end
