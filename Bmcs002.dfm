object frmBmcs002: TfrmBmcs002
  Left = 288
  Top = 208
  ActiveControl = txtPlanNo
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'bmcs002 - 模擬缺料產生作業'
  ClientHeight = 245
  ClientWidth = 348
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
  object cmdOk: TBitBtn
    Left = 268
    Top = 12
    Width = 75
    Height = 24
    Caption = '確認'
    TabOrder = 0
    Kind = bkOK
  end
  object cmdCancel: TBitBtn
    Left = 268
    Top = 38
    Width = 75
    Height = 24
    Caption = '取消'
    TabOrder = 1
    Kind = bkCancel
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 249
    Height = 225
    TabOrder = 2
    object lblPlanNo: TLabel
      Left = 12
      Top = 20
      Width = 56
      Height = 13
      Caption = '排程年月'
    end
    object lblMoni: TLabel
      Left = 12
      Top = 72
      Width = 56
      Height = 13
      Caption = '模擬版本'
    end
    object lvlWoCfm: TLabel
      Left = 12
      Top = 124
      Width = 147
      Height = 13
      Caption = '包含開工缺料工單(Y/N)'
    end
    object lblWoQty: TLabel
      Left = 12
      Top = 172
      Width = 112
      Height = 13
      Caption = 'PCB 工單提前天數'
    end
    object txtPlanNo: TEdit
      Left = 12
      Top = 36
      Width = 217
      Height = 21
      CharCase = ecUpperCase
      ImeName = '智能陳橋輸入平台  5.4'
      TabOrder = 0
    end
    object txtVersion: TEdit
      Left = 12
      Top = 92
      Width = 217
      Height = 21
      CharCase = ecUpperCase
      ImeName = '智能陳橋輸入平台  5.4'
      TabOrder = 1
    end
    object txtWoCfm: TEdit
      Left = 12
      Top = 140
      Width = 217
      Height = 21
      CharCase = ecUpperCase
      ImeName = '智能陳橋輸入平台  5.4'
      TabOrder = 2
      Text = 'Y'
    end
    object txtWoQty: TEdit
      Left = 12
      Top = 188
      Width = 217
      Height = 21
      ImeName = 'Chinese (Simplified) - Microsoft Pinyin'
      TabOrder = 3
      Text = '15'
    end
  end
end
