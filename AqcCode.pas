unit AqcCode;

interface
  uses Windows,SysUtils,Classes,DBTables,Forms,Controls;


procedure GetWaitIqc_Bqcr001(VRevNo,VPONo,VStart,VEnd,VVendor,VIRNo,VPartno:String);

implementation
  uses pasDm,pasSysQryResultEx,pasCodeProc,pasSysRes,pasGetDate;


procedure GetWaitIqc_Bqcr001(VRevNo,VPONo,VStart,VEnd,VVendor,VIRNo,VPartno:String);
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do
  begin
    if Active then
      Close;
    SQL.Clear;
    SQL.Add(Format(
            '     SELECT RVA01 AS ���f�渹,                                     '+
            '            RVA02 AS ���ʳ渹,                                     '+
            '            RVA05 AS �����t��,                                     '+
            '            RVA06 AS ���f���,                                     '+
            '            PMN34 AS �q����,                                     '+
            '            RVB05 AS �ƥ�s��,                                     '+
            '            TODAY-RVA06 AS ���ˤѼ�,                               '+
            '            CASE WHEN  TODAY-RVA06 >7 THEN ''DELAY''  END AS ���A, '+
            '            SUM((RVB07-RVB29-RVB30)*PMN09) AS ���˼ƶq,            '+
            '            IMA43 AS ���ʭ�                                        '+
            '        FROM RVB_FILE , RVA_FILE, PMN_FILE , IMA_FILE              '+
            '       WHERE RVB01=RVA01                                           '+
            '         AND RVB04 = PMN01                                         '+
            '         AND RVB03 = PMN02                                         '+
            '         AND RVB07 > (RVB29+RVB30)                                 '+
            '         AND IMA01=RVB05                                           '+
            '         AND (RVACONF!=''X''                                        '+
            '         AND RVA01 LIKE ''%S%S''                                '+
            '         AND RVA02 LIKE ''%S%S''                                '+
            '         AND RVA06 BETWEEN ''%S''  AND ''%S''                      '+
            '         AND RVA05 LIKE ''%S%S''                                    '+
            '         AND IMA43 LIKE ''%S%S''                                    '+
            '         AND RVB05 LIKE ''%S%S'')                                    '+
            '    GROUP BY RVA01,RVA02,RVA05,RVA06,pmn34,RVB05,IMA43',[VRevNo,'%',VPONo,'%',VStart,VEnd,VVendor,'%',VIRNo,'%',VPartno,'%']));
   Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='Bqcr001 - ���ƫ��ˬd�߳��i';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;

end;

end.
