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
            '     SELECT RVA01 AS 收貨單號,                                     '+
            '            RVA02 AS 採購單號,                                     '+
            '            RVA05 AS 供應廠商,                                     '+
            '            RVA06 AS 收貨日期,                                     '+
            '            PMN34 AS 訂單交期,                                     '+
            '            RVB05 AS 料件編號,                                     '+
            '            TODAY-RVA06 AS 待檢天數,                               '+
            '            CASE WHEN  TODAY-RVA06 >7 THEN ''DELAY''  END AS 狀態, '+
            '            SUM((RVB07-RVB29-RVB30)*PMN09) AS 待檢數量,            '+
            '            IMA43 AS 採購員                                        '+
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
    frmSysQryResultEx.Caption:='Bqcr001 - 材料待檢查詢報告';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;

end;

end.
