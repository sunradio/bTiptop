object frmAbmr691: TfrmAbmr691
  Left = 397
  Top = 250
  BorderStyle = bsDialog
  Caption = 'abmr691 - BOM 比較查詢作業'
  ClientHeight = 204
  ClientWidth = 358
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
    Width = 257
    Height = 117
    Caption = '1.需比較產品品號'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '細明體'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object txtPart: TEdit
      Left = 12
      Top = 20
      Width = 153
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ImeName = 'Chinese (Simplified) - Microsoft Pinyin IME 3.0'
      MaxLength = 12
      ParentFont = False
      TabOrder = 0
      OnKeyDown = txtPartKeyDown
    end
    object lbPart: TListBox
      Left = 12
      Top = 40
      Width = 153
      Height = 65
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ImeName = 'Chinese (Simplified) - Microsoft Pinyin IME 3.0'
      ItemHeight = 13
      ParentFont = False
      TabOrder = 1
    end
    object btAdd: TBitBtn
      Left = 172
      Top = 20
      Width = 75
      Height = 25
      Caption = '插入'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btAddClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333FF33333333FF333993333333300033377F3333333777333993333333
        300033F77FFF3333377739999993333333333777777F3333333F399999933333
        33003777777333333377333993333333330033377F3333333377333993333333
        3333333773333333333F333333333333330033333333F33333773333333C3333
        330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
        993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
        333333333337733333FF3333333C333330003333333733333777333333333333
        3000333333333333377733333333333333333333333333333333}
      NumGlyphs = 2
    end
    object btRemove: TBitBtn
      Left = 172
      Top = 44
      Width = 75
      Height = 25
      Caption = '移除'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = '細明體'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btRemoveClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333FF33333333333330003333333333333777333333333333
        300033FFFFFF3333377739999993333333333777777F3333333F399999933333
        3300377777733333337733333333333333003333333333333377333333333333
        3333333333333333333F333333333333330033333F33333333773333C3333333
        330033337F3333333377333CC3333333333333F77FFFFFFF3FF33CCCCCCCCCC3
        993337777777777F77F33CCCCCCCCCC399333777777777737733333CC3333333
        333333377F33333333FF3333C333333330003333733333333777333333333333
        3000333333333333377733333333333333333333333333333333}
      NumGlyphs = 2
    end
  end
  object BitBtn3: TBitBtn
    Left = 276
    Top = 12
    Width = 75
    Height = 25
    Caption = '確認'
    ModalResult = 1
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object BitBtn4: TBitBtn
    Left = 276
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
