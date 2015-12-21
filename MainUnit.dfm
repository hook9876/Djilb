object Djilb: TDjilb
  Left = 810
  Top = 233
  BorderStyle = bsDialog
  Caption = #1052#1077#1090#1088#1086#1083#1086#1075#1080#1103
  ClientHeight = 474
  ClientWidth = 686
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelResult: TLabel
    Left = 24
    Top = 432
    Width = 3
    Height = 13
  end
  object MemoCode: TMemo
    Left = 8
    Top = 16
    Width = 505
    Height = 337
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ButtonLoadFrom: TButton
    Left = 8
    Top = 392
    Width = 505
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076
    TabOrder = 1
    OnClick = ButtonLoadFromClick
  end
  object ButtonMakeGood: TButton
    Left = 8
    Top = 368
    Width = 505
    Height = 25
    Caption = #1040#1085#1072#1083#1080#1079#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 2
    OnClick = ButtonMakeGoodClick
  end
  object OpenDialogFileCode: TOpenDialog
    Left = 256
    Top = 24
  end
end
