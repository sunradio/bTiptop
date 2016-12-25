object frmAmrr500: TfrmAmrr500
  Left = 316
  Top = 252
  ActiveControl = txtVersion
  BorderStyle = bsDialog
  Caption = 'MRP 匯總表'
  ClientHeight = 140
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TBitBtn
    Left = 212
    Top = 14
    Width = 75
    Height = 24
    Caption = '確認'
    TabOrder = 0
    Kind = bkOK
  end
  object btCancel: TBitBtn
    Left = 212
    Top = 40
    Width = 75
    Height = 24
    Caption = '取消'
    TabOrder = 1
    Kind = bkCancel
  end
  object gbSelect: TGroupBox
    Left = 12
    Top = 8
    Width = 185
    Height = 121
    Caption = 'MRP 條件'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = '細明體'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object lblStartDate: TLabel
      Left = 12
      Top = 20
      Width = 56
      Height = 13
      Caption = 'MRP 版本'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
    end
    object lblEndDate: TLabel
      Left = 12
      Top = 64
      Width = 56
      Height = 13
      Caption = '料件屬性'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
    end
    object txtVersion: TEdit
      Left = 12
      Top = 36
      Width = 121
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ImeName = 'Chinese (Traditional) - New Phonetic'
      MaxLength = 2
      ParentFont = False
      TabOrder = 0
    end
    object txtMp: TEdit
      Left = 12
      Top = 80
      Width = 121
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ImeName = 'Chinese (Traditional) - New Phonetic'
      MaxLength = 1
      ParentFont = False
      TabOrder = 1
      Text = 'M'
    end
  end
end
