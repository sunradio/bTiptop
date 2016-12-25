object frmBmcs004: TfrmBmcs004
  Left = 366
  Top = 300
  ActiveControl = txtStartNo
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = '排程版本'
  ClientHeight = 110
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '細明體'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblStartNo: TLabel
    Left = 8
    Top = 8
    Width = 56
    Height = 13
    Caption = '起始編號'
  end
  object lblEndNo: TLabel
    Left = 8
    Top = 56
    Width = 56
    Height = 13
    Caption = '結束編號'
  end
  object cmdOk: TBitBtn
    Left = 171
    Top = 8
    Width = 75
    Height = 24
    Caption = '確認'
    TabOrder = 0
    Kind = bkOK
  end
  object cmdCancel: TBitBtn
    Left = 171
    Top = 35
    Width = 75
    Height = 24
    Caption = '取消'
    TabOrder = 1
    Kind = bkCancel
  end
  object txtStartNo: TEdit
    Left = 8
    Top = 26
    Width = 149
    Height = 21
    ImeName = '智能陳橋輸入平台  5.4'
    TabOrder = 2
  end
  object txtEndNo: TEdit
    Left = 8
    Top = 74
    Width = 149
    Height = 21
    ImeName = '智能陳橋輸入平台  5.4'
    TabOrder = 3
  end
end
