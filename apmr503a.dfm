object frmApmr503a: TfrmApmr503a
  Left = 336
  Top = 243
  BorderStyle = bsDialog
  Caption = 'apmr503a - ���ʸ�ʪ�d�߱���'
  ClientHeight = 187
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '�ө���'
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
    Height = 73
    Caption = '�d�߱���@'
    TabOrder = 0
    object Label5: TLabel
      Left = 36
      Top = 28
      Width = 70
      Height = 13
      Caption = '��������G'
    end
    object DateEnd: TDateTimePicker
      Left = 116
      Top = 24
      Width = 173
      Height = 21
      CalAlignment = dtaLeft
      Date = 38242.3912710648
      Time = 38242.3912710648
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 92
    Width = 317
    Height = 81
    Caption = '�d�߱���G'
    TabOrder = 1
    object Label8: TLabel
      Left = 36
      Top = 36
      Width = 70
      Height = 13
      Caption = '���ʤH���G'
    end
    object cmbIRNo: TComboBox
      Left = 116
      Top = 32
      Width = 173
      Height = 21
      Style = csDropDownList
      DropDownCount = 15
      ItemHeight = 13
      TabOrder = 0
      OnDropDown = cmbIRNoDropDown
    end
  end
  object BitBtn1: TBitBtn
    Left = 336
    Top = 12
    Width = 75
    Height = 25
    Caption = '�T�{'
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 336
    Top = 40
    Width = 75
    Height = 25
    Caption = '����'
    TabOrder = 3
    Kind = bkCancel
  end
end
