program bTiptop;


uses
  Windows,
  SysUtils,
  Forms,
  Controls,
  pasMain in 'pasMain.PAS' {frmMain},
  pasAbout in 'pasAbout.pas' {frmAbout},
  pasDm in 'pasDm.pas' {dm: TDataModule},
  pasSysLogin in 'pasSysLogin.pas' {frmSysLogin},
  pasSysRes in 'pasSysRes.pas',
  pasSysReLogin in 'pasSysReLogin.pas' {frmSysReLogin},
  pasCodeProc in 'pasCodeProc.pas',
  pasFilterData in 'pasFilterData.pas' {frmComFilter},
  pasFindData in 'pasFindData.pas' {frmComFind},
  pasSysChangDb in 'pasSysChangDb.pas' {frmChangDB},
  Apmr515 in 'Apmr515.pas' {frmApmr515},
  Asft110a in 'Asft110a.pas' {frmAsft110a},
  bbom002 in 'bbom002.pas' {frmBbom002},
  biqc001 in 'biqc001.pas' {frmbiqc001},
  Bmcs005 in 'Bmcs005.pas' {frmBmcs005},
  Bmcs002 in 'Bmcs002.pas' {frmBmcs002},
  Bmcs003 in 'Bmcs003.pas' {frmBmcs003},
  bbmq100 in 'bbmq100.pas' {frmBbmq100},
  pasSysQryResultEx in 'pasSysQryResultEx.pas' {frmSysQryResultEx},
  Sysdb in 'Sysdb.pas',
  pasGetWOSDWhereEx in 'pasGetWOSDWhereEx.pas' {frmGetWOSDWhereEX},
  Axsr504 in 'Axsr504.pas' {frmAxsr504},
  pasSysQryTool in 'pasSysQryTool.pas' {frmSysQryTool},
  Bmcs004 in 'Bmcs004.pas' {frmBmcs004},
  Bmcs001 in 'Bmcs001.pas' {frmBmcs001},
  JclBase in 'JclBase.pas',
  JclStrings in 'JclStrings.pas',
  Abmq501 in 'abmq501.pas' {frmAbmq501},
  bbmq501 in 'bbmq501.pas' {frmBbmq501},
  Abmr6910 in 'Abmr6910.pas' {frmAbmr6910},
  abmr622c in 'abmr622c.pas' {frmAbmr622c},
  Bpcs003 in 'Bpcs003.pas' {frmBpcs003},
  Comima in 'Comima.pas',
  aimr406 in 'aimr406.pas' {frmAimr406},
  Whatif in 'Whatif.pas',
  Prcode in 'Prcode.pas',
  Mrpcode in 'Mrpcode.pas',
  amrr500 in 'amrr500.pas' {frmAmrr500},
  BomCode in 'BomCode.pas',
  Abmr691 in 'Abmr691.pas' {frmAbmr691},
  pasManualDlg in 'pasManualDlg.pas' {frmManualDlg},
  ManCode in 'ManCode.pas',
  pasAsfr104 in 'pasAsfr104.pas' {frmAsfr104},
  AsfCode in 'AsfCode.pas',
  apmr503a in 'apmr503a.pas' {frmApmr503a},
  AqcCode in 'AqcCode.pas',
  abmr622a in 'abmr622a.pas' {frmAbmr622a},
  Bpcs001 in 'Bpcs001.pas' {frmBpcs001},
  pasAsfr104a in 'pasAsfr104a.pas' {frmAsfr104a},
  blti01 in 'blti01.pas' {frmBlt01},
  Asfr1061a in 'Asfr1061a.pas' {frmAsfr1061a},
  Abmr622 in 'abmr622.pas' {frmAbmr622},
  bbom001 in 'bbom001.pas' {frmBbom001},
  BqcI001 in 'BqcI001.pas' {frmBqcI001},
  abmr622b in 'abmr622b.pas' {frmAbmr622b},
  Asft110 in 'Asft110.pas' {frmAsft110},
  axmt370 in 'axmt370.pas' {frmAxmt370},
  Aimq102 in 'Aimq102.pas' {frmAimq102},
  Com002 in 'Com002.pas' {frmCom002},
  pasGetDate in 'pasGetDate.pas' {frmGetDate},
  pasGetWOSDWhere in 'pasGetWOSDWhere.pas' {frmGetWOSDWhere},
  Com001 in 'Com001.pas' {frmCom001},
  Bpcs002 in 'Bpcs002.pas' {frmBpcs002},
  pasQueryDlg in 'pasQueryDlg.pas' {frmQueryDlg},
  pasBpcs002dlg in 'pasBpcs002dlg.pas' {frmBpcs02Dlg},
  pasMatLTData in 'pasMatLTData.pas' {frmMatLTData},
  pasShipData in 'pasShipData.pas' {frmShipData},
  pasShipPrint in 'pasShipPrint.pas' {frmShipPrint};

{$R *.RES}
begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  frmMain.Hide;
  frmMain.Caption:='GWInstek bTipTop '+GetAppVer;
  lockWindowUpdate(frmMain.Handle);
  frmMain.Show;
  LockWindowUpdate(0);
  Application.Title := 'bTiptop ';
  frmSysLogin:= TfrmSysLogin.Create(Application);
  try
    frmSysLogin.ShowModal;
    if frmSysLogin.ModalResult=mrOk then
    begin
      Screen.Cursor:=crAppStart;
      Application.CreateForm(Tdm, dm);      
      dm.db.Params.Clear;
      dm.db.Params.Add(Format('USER NAME=%s',[frmSysLogin.txtUser.text]));
      dm.db.Params.Add(Format('PASSWORD=%s',[frmSysLogin.txtPassword.Text]));

      if not dm.db.Connected then  begin
      try
        dm.db.Open;
        Userid:=frmSysLogin.txtUser.Text;
        UserPassword:=frmSysLogin.txtPassword.Text;
        dm.SetDatabase;
        Application.Run;

      except
        Application.MessageBox('無效的用戶名或密碼!','錯誤',MB_ICONERROR+MB_OK);
        Application.Terminate;
      end;
    end
    else
    begin
      Application.Terminate;
    end;
    end;
  finally
    frmSysLogin.Free;
    Screen.Cursor:=crDefault;
  end;

          
end.
