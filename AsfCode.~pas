unit AsfCode;

interface
  uses Windows,SysUtils,Classes,DBTables,Forms,Controls,JclStrings;

  procedure GetAsfWoIss_Asfr104(WoType,IsType,StartDate,EndDate:String);
  procedure GetAsfWoIss_Asfr104a(strItem,strSBegin,strSEnd,strMBegin,strMEnd:String);
  procedure GetAsfWip_Asfr1061;
  procedure GetAsfShortQrt_asft110(StartDate,endDate:String);
  procedure GetAsfWipa_Asfr1061(WorkOrder:String);
  procedure GetWoMpsdate(WoYM:String);
  procedure GetWoOverIssueEX(Startdate,EndDate:string);
  procedure GetOtherIssueEx(Startdate,EndDate:string);

  procedure GetModeSales(Startdate,EndDate:string);
  procedure GetPreIssueQty(Startdate,EndDate:string);  
  procedure GetIssueQty(YearMonth:string);
  procedure GetWOLotQty(Startdate,EndDate:string);
  procedure GetMRPNorohs(mrpver,source:string);
  procedure GetShipToGwt(Startdate,EndDate:string);
  procedure GetTop100(stkno:string);
  procedure GetCostCheck(YearMonth:string);
  procedure GetInlotQty(Startdate,EndDate:string);
  procedure GetIssueQtyEX(YearMonth:string);
  procedure GetWOSD(StartDate,endDate,DS2ETA,DS3ETA:String);
  procedure GetWOSDEX(WorkOrderNo,DS2ETA,DS3ETA,NewStartDate:String;Sel:Boolean);
  procedure SetPrData(WoYearMonth,PrNumber,PrDate:string);
  procedure GetPartSD(Partno,StartDate,endDate,DS2ETA,DS3ETA:String);

implementation
  uses pasDm,pasSysQryResultEx,pasCodeProc,pasSysRes,pasGetDate;




procedure SetPrData(WoYearMonth,PrNumber,PrDate:string);
var
 lsql,strRemark:string;

begin
  strRemark:=UserName +','+ DateTostr(Date)+ ' 導入';

  lSql:='SELECT COUNT(*) FROM DS3::PMK_FILE WHERE PMK01=''%S''';
  if GetRecordCount(Format(lSql,[PrNumber]))>0 then  begin
   lSql:='SELECT COUNT(*) FROM DS3::PML_FILE WHERE PML01=''%S''';
   if GetRecordCount(Format(lSql,[PrNumber]))<=0 then  begin
      lSql:='SELECT SFA03,IMA02,SUM(SFA04) AS QTY     '+
          '  FROM DS3::SFA_FILE,DS3::IMA_FILE,DS3::SFB_FILE '+
          ' WHERE SFB01=SFA01 AND IMA01=SFA03               '+
          '   AND SFB04<=''7''                '+
          '   AND (SFB08-SFB09)>0             '+
          '   AND IMA103=''1''                '+
          '   AND IMA08=''P''                 '+
          '   AND SFA01[5,6]=''%S''           '+
          ' GROUP BY 1,2 INTO TEMP TempWoPrData';

      ExecSqla(Format(lSql,[WoYearMonth]));

      lSql:='SELECT A.SFA03,(SELECT COUNT(SFA03)             '+
          '                  FROM TempWoPrData B             '+
          '                 WHERE B.SFA03<=A.SFA03) AS ITMNO,'+
          '         A.QTY,A.IMA02                            '+
          '  FROM TempWoPrData A                             '+
          ' ORDER BY A.SFA03 INTO TEMP TempWOPrDataEX';
       ExecSqla(lSql);

       lSql:='INSERT INTO DS3::PML_FILE(PML01,PML011,PML02,PML04,PML041,PML07,PML08,PML09,PML11,PML14,PML15,PML16,PML20,PML21,PML33,PML34,PML35,PML38,PML42,PML06) '+
             'SELECT ''%S'',''REG'',ITMNO,SFA03,IMA02,          '+
             '       ''PCS'',''PCS'',1,''N'',''Y'',''Y'',0,     '+
             '        QTY,0,''%S'',''%S'',''%S'',''Y'',0,''%S'' '+
             '  FROM  TempWOPrDataEX';
       ExecSqlA(Format(lsql,[PrNumber,PrDate,PrDate,PrDate,strRemark]));

       frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
       try
         Screen.Cursor:=crSQLWait;
         with frmSysQryResultEx.Query do begin
         if Active then Close;
         SQL.Clear;
          lsql:='SELECT PML01 AS 請購單號,   '+
          '       PML02 AS 項次,       '+
          '       PML04 AS 料號,       '+
          '       PML041 AS 品名規格,  '+
          '       PML41 AS 來源,       '+
          '       PML07 AS 單位,       '+
          '       PML18 AS MRP需求日,  '+
          '       PML33 AS 交貨日,     '+
          '       PML20 AS  請購量,    '+
          '       PML21 AS 已轉訂單,   '+
          '       PML06 AS 備註        '+
          '  FROM DS3::PML_FILE        '+
          ' WHERE PML01=''%S''';

         SQL.Add(Format(lsql,[PrNumber]));
         Open;
         Screen.Cursor:=crDefault;
         frmSysQryResultEx.Caption:=format('%s - %S ',[WoYearMonth,PrNumber]);
         frmSysQryResultEx.ShowModal;
       end;
      finally
        ExecSqla('DROP TABLE TempWoPrData');      
        ExecSqla('DROP TABLE TempWOPrDataEX');
        Screen.Cursor:=crDefault;
        frmSysQryResultEx.Free;
      end;
   end else begin
      Application.MessageBox(Pchar((Format('%s , %S 請購單單身已有資料，無法導入！',[Username,PrNumber]))),'提示',MB_ICONINFORMATION+MB_OK);
   end;
  end else begin
     Application.MessageBox(Pchar((Format('%s , %S 請購單不存在，請到TIPTOP新增一筆！',[Username,PrNumber]))),'提示',MB_ICONINFORMATION+MB_OK);
  end;



end;

procedure GetInlotQty(Startdate,EndDate:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;
    lsql:='  SELECT ''DS2'' AS 廠別,                            '+
          '         COUNT(RVB05) AS 筆數                        '+
          '    FROM DS2::RVA_FILE,DS2::RVB_FILE,DS2::PMM_FILE   '+
          '   WHERE RVA01=RVB01                                 '+
          '     AND RVACONF=''Y''                               '+
          '     AND RVA06 BETWEEN  ''%S'' AND ''%S''            '+
          '     AND RVB04=PMM01                                 '+
          '     AND RVA05=''XATWXGU0''                          '+
   
          '  UNION ALL                                          '+

          '  SELECT ''DS3'' AS 廠別,                            '+
          '         COUNT(RVB05) AS 筆數                        '+
          '    FROM DS3::RVA_FILE,DS3::RVB_FILE,DS3::PMM_FILE   '+
          '   WHERE RVA01=RVB01                                 '+
          '     AND RVACONF=''Y''                               '+
          '     AND RVA06 BETWEEN  ''%S'' AND ''%S''            '+
          '     AND RVB04=PMM01                                 '+
          '     AND RVA05=''XATWXGU0''';                         

    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s - %S 期間從台灣進料筆數',[Startdate,EndDate]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;


procedure GetCostCheck(YearMonth:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;
    lsql:='SELECT CCC01 AS 料號,                            '+
          '       IMA02 AS 品名描述,                        '+
          '       (SELECT A.IMA54                           '+
          '          FROM DS2::IMA_FILE A                   '+
          '         WHERE A.IMA01=CCC01 ) AS 廠商,          '+
          '       ROUND(CCC23,3) AS DS3實際成本,            '+
          '       IMA531 AS 現購價格,                       '+
          '       IMB111 AS 標準價格,                       '+
          '       ROUND(CCC23-IMB111,3) AS 差異             '+
          ' FROM DS3::CCC_FILE,DS3::IMA_FILE,DS2::IMB_FILE  '+
          ' WHERE CCC02||CCC03=''%s''                       '+
          '   AND IMA01=CCC01                               '+
          '   AND IMA08=''P'' AND IMA103=''0''              '+
          '   AND LENGTH(CCC01)>=''13''                     '+
          '   AND IMB01=IMA01 AND (CCC23-IMB111)>0.25';

    SQL.Add(Format(lsql,[YearMonth]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s  DS3 庫存成本結帳前檢查報告((實際-標準)>0.25)',[YearMonth]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;


procedure GetTop100(stkno:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;
    lsql:='SELECT FIRST 100                              '+
          '       IMA01  AS 料號,                        '+
          '       IMA02  AS 描述,                        '+
          '       IMB118 AS 價格,                        '+
          '       IMA54  AS 廠商,                        '+
          '       SUM(IMG10) AS 數量,                    '+
          '       ROUND(SUM(IMG10*IMB118),2) AS 金額     '+
          ' FROM IMA_FILE,IMB_FILE,IMG_FILE              '+
          'WHERE IMA01=IMB01                             '+
          '  AND IMA01=IMG01                             '+
          '  AND IMA08=''P''                             '+
          '  AND IMG02 =''%s''                           '+
          'GROUP BY 1,2,3,4                              '+
          'HAVING SUM(IMG10)!=0                          '+
          ' ORDER BY 6 DESC';

    SQL.Add(Format(lsql,[stkno]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s  庫存TOP 100 報告',[stkno]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;


procedure GetMRPNorohs(mrpver,source:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;
    lsql:='SELECT MSS01  AS 材料料號,                '+
          ' IMA02  AS 品名規格,                      '+
          ' IMB118 AS STDPRICE,                      '+
          ' IMA54  AS 供應廠商,                      '+
          ' SUM(MSS041) AS 受訂數量,                 '+
          ' SUM(MSS043) AS 計劃領料,                 '+
          ' SUM(MSS044) AS 工單領料,                 '+
          ' SUM(MSS051) AS 庫存數量,                 '+
          ' SUM(MSS052) AS 在驗數量,                 '+
          ' SUM(MSS053) AS 替代數量,                 '+
          ' SUM(MSS061) AS 請購數量,                 '+
          ' SUM(MSS062) AS 在採數量,                 '+
          ' SUM(MSS063) AS 在外數量,                 '+
          ' SUM(MSS064) AS 在製數量,                 '+
          ' SUM(MSS065) AS 計劃產量,                 '+
          ' SUM((MSS041+MSS043+MSS044+ima27)) AS 需求數量, '+
          ' SUM((MSS051+MSS052+MSS053+MSS061+MSS062+MSS063+MSS064+MSS065)) AS  供貨數量, '+
          ' SUM((MSS051+MSS052+MSS053+MSS061+MSS062+MSS063+MSS064+MSS065)-(MSS041+MSS043+MSS044+IMA27)) AS 供需差異   '+
          '  FROM MSS_FILE A ,IMA_FILE B,IMB_fILE                        '+
          ' WHERE MSS_V =''%s''   --這里輸入MRP模擬版本                  '+
          ' AND A.MSS01=B.IMA01 AND IMA01=IMB01                          '+
          ' AND IMA08=''%s''     --這里輸入要看料件是(M OR P)            '+
          ' AND LENGTH(MSS01)<=12                                        '+
          ' GROUP BY MSS01,IMA02,IMB118,IMA54       '+
          ' HAVING SUM((MSS051+MSS052+MSS053+MSS061+MSS062+MSS063+MSS064+MSS065)-(MSS041+MSS043+MSS044+IMA27))!=0';

    SQL.Add(Format(lsql,[mrpver,source]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s - %S NORoHS 料庫存以及預計庫存報告',[mrpver,source]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;





procedure GetWOLotQty(Startdate,EndDate:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;
    lsql:=' SELECT DISTINCT ''DS2'' AS 內外銷,SFE01 AS 發料工單         '+
          '   FROM DS2::SFE_FILE                      '+
          '  WHERE SFE04 BETWEEN ''%s'' AND ''%s''    '+
          '    AND SFE02[1,3]=''IM1''                 '+
          '    AND SFE01[1,3] IN(''ASY'',''PCB'')     '+
          ' UNION ALL                                 '+
          ' SELECT DISTINCT ''DS3'' AS 內外銷,SFE01 AS 發料工單         '+
          '   FROM DS3::SFE_FILE                      '+
          '  WHERE SFE04 BETWEEN ''%s'' AND ''%s''    '+
          '    AND SFE02[1,3]=''IMA''                 '+
          '    AND SFE01[1,3] IN(''ASY'',''PCB'')     ';

    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s - %S 工單發料批數',[Startdate,EndDate]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;

procedure GetIssueQtyEX(YearMonth:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;
    lsql:=' SELECT ''DS2 雜出(萬)'',ROUND(SUM(CCC42+CCC44)/10000,2) AS 雜項發料      '+
          '   FROM DS2::CCC_FILE,DS2::IMA_FILE                        '+
          '  WHERE CCC02||CCC03=''%s''                               '+
          '    AND IMA08=''P''                                          '+
          '    AND CCC01=IMA01                                        '+
          '    AND CCC32!=0                                           '+
          '    AND CCC01[1,2] >''09''       '+

          ' UNION ALL                                                '+

          ' SELECT ''DS3 雜出(萬)'',ROUND(SUM(CCC42+CCC44)/10000,2) AS 雜項發料      '+
          '   FROM DS3::CCC_FILE,DS3::IMA_FILE                        '+
          '  WHERE CCC02||CCC03=''%s''                               '+
          '    AND IMA08=''P''                                          '+
          '    AND CCC01=IMA01                                        '+
          '    AND CCC32!=0                                           '+
          '    AND CCC01[1,2]>''09'' ';

    SQL.Add(Format(lsql,[YearMonth,YearMonth]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s 雜項材料出庫金額（月結實際）',[YearMonth]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;

procedure GetIssueQty(YearMonth:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;
    lsql:=' SELECT ''DS2 金額(萬)'',ROUND(SUM(CCC32)/10000,2) AS 工單發料      '+
          '   FROM DS2::CCC_FILE,DS2::IMA_FILE                        '+
          '  WHERE CCC02||CCC03=''%s''                               '+
          '    AND IMA08=''P''                                          '+
          '    AND CCC01=IMA01                                        '+
          '    AND CCC32!=0                                           '+
          '    AND CCC01[1,2] NOT IN (''12'',''HC'',''D1'',''D2'',''D8'')       '+

          ' UNION ALL                                                '+

          ' SELECT ''DS3 金額(萬)'',ROUND(SUM(CCC32)/10000,2) AS 工單發料      '+
          '   FROM DS3::CCC_FILE,DS3::IMA_FILE                        '+
          '  WHERE CCC02||CCC03=''%s''                               '+
          '    AND IMA08=''P''                                          '+
          '    AND CCC01=IMA01                                        '+
          '    AND CCC32!=0                                           '+
          '    AND CCC01[1,2] NOT IN (''12'',''HC'',''D1'',''D2'',''D8'')';

    SQL.Add(Format(lsql,[YearMonth,YearMonth]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s 材料出庫金額（月結實際）',[YearMonth]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;

procedure GetShipToGwt(Startdate,EndDate:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;
    lsql:=' SELECT ''出料到台灣'' AS 內容,ROUND(SUM(OGB14*OGA24 )/10000,2)   AS 金額  '+
          '   FROM DS2::OGB_FILE,DS2::OGA_FILE,DS2::IMB_FILE                          '+
          '  WHERE OGA01=OGB01                                       '+
          '    AND OGA02 BETWEEN ''%s'' AND ''%s''                   '+
          '    AND OGACONF=''Y''                                     '+
          '    AND OGAPOST=''Y''                                     '+
          '    AND OGB04=IMB01                                       '+
          '    AND OGB01[1,3]=''DO6'' AND OGA25=''CX3''              '+
          '    AND OGB911 IS NULL                                    ';

    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate,Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s - %s 材料出GWT金額',[Startdate,EndDate]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;

procedure GetPreIssueQty(Startdate,EndDate:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;
    lsql:=' SELECT ''DS2 金額(萬)'' AS 發料,ROUND(SUM(SFE16*IMB111)/10000,2)  AS 金額              '+
          '   FROM DS2::SFE_FILE,DS2::IMB_FILE,DS2::IMA_FILE         '+
          '  WHERE SFE07=IMB01 AND IMA01=IMB01 AND IMA08=''P''         '+
          '    AND SFE08=''01'' AND SFE02[1,2]=''IM''                '+
          '    AND SFE04 BETWEEN ''%s'' AND ''%s''                  '+
          '    AND SFE07 NOT IN (''12'',''HC'',''D1'',''D2'',''D8'') '+
          ' UNION ALL                                                '+

          ' SELECT ''DS3 金額(萬)'', ROUND(SUM(SFE16*IMB111)/10000,2)             '+
          '   FROM DS3::SFE_FILE,DS3::IMB_FILE,DS3::IMA_FILE         '+
          '  WHERE SFE07=IMB01 AND IMA01=IMB01 AND IMA08=''P''         '+
          '    AND SFE02[1,2]=''IM''                                 '+
          '    AND SFE04 BETWEEN ''%s'' AND ''%s''                  '+
          '    AND SFE07 NOT IN (''12'',''HC'',''D1'',''D2'',''D8'')';

    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate,Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s - %s 倉庫材料出庫金額',[Startdate,EndDate]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;

procedure GetModeSales(Startdate,EndDate:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
   if Active then Close;
   SQL.Clear;
   lsql:=' SELECT ''DS2 銷售'' AS 廠別,                      '+
         '       OGB914 AS 客戶,                             '+
         '       OGB04 AS 產品品號,                          '+
         '       OGB12 AS 銷售數量,                          '+
         '       OGB911 AS 備註,                             '+
         '       IMB118 AS 標準成本                          '+
         '  FROM DS2::OGB_FILE,DS2::OGA_FILE,DS2::IMB_FILE   '+
         ' WHERE OGA01=OGB01                                 '+
         '   AND OGA02 BETWEEN ''%S'' AND ''%S''             '+
         '   AND OGACONF=''Y''                               '+
         '   AND OGAPOST=''Y''                               '+
         '   AND OGB04=IMB01                                 '+
         '   AND OGB01[1,3]!=''DO6''                         '+
         '   AND OGB04[1,2]=''01'' AND OGB04[12,12]=''R''    '+

         ' UNION ALL                                         '+

         ' SELECT ''DS7 銷售'' AS 廠別,                      '+
         '       OGB914 AS 客戶,                             '+
         '       OGB04 AS 產品品號,                          '+
         '       OGB12 AS 銷售數量,                          '+
         '       OGB911 AS 備註,                             '+
         '       IMB118 AS 標準成本                          '+
         '  FROM DS7::OGB_FILE,DS7::OGA_FILE,DS7::IMB_FILE   '+
         ' WHERE OGA01=OGB01                                 '+
         '   AND OGA02 BETWEEN ''%S'' AND ''%S''             '+
         '   AND OGACONF=''Y''                               '+
         '   AND OGAPOST=''Y''                               '+
         '   AND OGB04=IMB01                                 '+
         '   AND OGB01[1,3]!=''DO6''                         '+
         '   AND OGB04[1,2]=''01'' AND OGB04[12,12]=''R''    '+

         ' UNION ALL                                         '+

         ' SELECT ''DS3 銷售'' AS 廠別,                      '+
         '       CASE WHEN OGB914 IS NULL THEN ''GWT'' ELSE OGB914 END AS 客戶,  '+
         '       OGB04 AS 產品品號,                          '+
         '       OGB12 AS 銷售數量,                          '+
         '       OGB911 AS 備註,                             '+
         '       IMB118 AS 標準成本                          '+
         '  FROM DS3::OGB_FILE,DS3::OGA_FILE,DS3::IMB_FILE   '+
         ' WHERE OGA01=OGB01                                 '+
         '   AND OGA02 BETWEEN ''%S'' AND ''%S''             '+
         '   AND OGACONF=''Y''                               '+
         '   AND OGAPOST=''Y''                               '+
         '   AND OGB04=IMB01                                 '+

         ' UNION ALL                                         '+

         ' SELECT ''DS2 一般貿易'' AS 廠別,                  '+
         '       OGB914 AS 客戶,                             '+
         '       OGB04 AS 產品品號,                          '+
         '       OGB12 AS 銷售數量,                          '+
         '       OGB911 AS 備註,                             '+
         '       IMB118 AS 標準成本                          '+
         '  FROM DS7::OGB_FILE,DS7::OGA_FILE,DS7::IMB_FILE   '+
         ' WHERE OGA01=OGB01                                 '+
         '   AND OGA02 BETWEEN ''%S'' AND ''%S''             '+
         '   AND OGACONF=''Y''                               '+
         '   AND OGAPOST=''Y''                               '+
         '   AND OGB04=IMB01                                 '+
         '   AND OGB01[1,3]=''DO6''                          '+
         '   AND OGB04[1,2]=''01''                           ';

         
    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate,Startdate,EndDate,Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%S - %S 銷售明細',[Startdate,EndDate]);;
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;


procedure GetWoOverIssueEX(Startdate,EndDate:string);
var
  lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do
  begin
    if Active then
      Close;
    SQL.Clear;
    lSql:=' SELECT ''DS2'' AS 內外銷,                                                             '+
          '        TLF01 AS 材料料號,                                                             '+
          '        TLF026 AS 單據編號,                                                            '+
          '        TLF026[5,6] AS 月份,                                                           '+
          '        TLF036[5,8] AS 母工單號,                                                       '+
          '        TLF036 AS 工單號碼,                                                            '+
          '        (SELECT CASE WHEN SFB02=''1'' THEN ''自製''                                    '+
          '                     WHEN SFB02=''7'' THEN ''外包'' END                                '+
          '            FROM DS2::SFB_FILE WHERE TLF036=SFB01) AS 外包,                             '+
          '         CASE WHEN TLF907=1 THEN -TLF10                                                '+
          '              WHEN TLF907=-1 THEN TLF10                                                '+
          '              WHEN TLF907=0 THEN TLF10 END AS 數量,                                    '+
          '        (SELECT IMA531 FROM DS2::IMA_FILE WHERE IMA01=TLF01) AS 單價,                  '+
          '        TLF07 AS 產生日期,                                                             '+
          '        CASE WHEN TLF907=1 THEN - (TLF221+TLF222+TLF2231+TLF2232+TLF224)               '+
          '             WHEN TLF907=-1 THEN  (TLF221+TLF222+TLF2231+TLF2232+TLF224)               '+
          '             WHEN TLF907=0 THEN  (TLF221+TLF222+TLF2231+TLF2232+TLF224) END AS 金額    '+
          '   FROM DS2::TLF_FILE                                                                  '+
          '  WHERE TLF13 IN(''asfi512'',''asfi527'')                                              '+
          '    AND TLF07 BETWEEN ''%S'' AND ''%S'' AND TLF17=''MO3''                              '+

          ' UNION ALL                                                                             '+

          ' SELECT ''DS3'' AS 內外銷,                                                             '+
          '        TLF01 AS 材料料號,                                                             '+
          '        TLF026 AS 單據編號,                                                            '+
          '        TLF026[5,6] AS 月份,                                                           '+
          '        TLF036[5,8] AS 母工單號,                                                       '+
          '        TLF036 AS 工單號碼,                                                            '+
          '        (SELECT CASE WHEN SFB02=''1'' THEN ''自製''                                    '+
          '                     WHEN SFB02=''7'' THEN ''外包'' END                                '+
          '            FROM DS3::SFB_FILE WHERE TLF036=SFB01) AS 外包,                            '+
          '         CASE WHEN TLF907=1 THEN -TLF10                                                '+
          '              WHEN TLF907=-1 THEN TLF10                                                '+
          '              WHEN TLF907=0 THEN TLF10 END AS 數量,                                    '+
          '        (SELECT IMA531 FROM DS3::IMA_FILE WHERE IMA01=TLF01) AS 單價,                  '+
          '        TLF07 AS 產生日期,                                                             '+
          '        CASE WHEN TLF907=1 THEN - (TLF221+TLF222+TLF2231+TLF2232+TLF224)               '+
          '             WHEN TLF907=-1 THEN  (TLF221+TLF222+TLF2231+TLF2232+TLF224)               '+
          '             WHEN TLF907=0 THEN  (TLF221+TLF222+TLF2231+TLF2232+TLF224) END AS 金額    '+
          '   FROM DS3::TLF_FILE                                                                  '+
          '  WHERE TLF13 IN(''asfi512'',''asfi527'')                                              '+
          '    AND TLF07 BETWEEN ''%S'' AND ''%S'' AND TLF17=''MO3''                              ';

    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate]));
    Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='外包工單超領料明細';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;

procedure GetOtherIssueEx(Startdate,EndDate:string);
var
 lsql:string;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do
  begin
    if Active then
      Close;
    SQL.Clear;
    lsql:=' SELECT                                         '+
          '       INA04 AS 部門,                           '+
          '       INB04 AS 料號,                           '+
          '       INB09 AS 數量,                           '+
          '       IMA02 AS 材料描述,                       '+
          '       IMA531 AS 單價,                          '+
          '       INB15 AS 原因,                           '+
          '       (SELECT AZF03                            '+
          '          FROM DS2::AZF_FILE                    '+
          '         WHERE AZF02=''2''                      '+
          '           AND AZF01=INB15) AS 原因描述         '+
          '  FROM DS2::INA_FILE,DS2::INB_FILE,DS2::IMA_FILE'+
          ' WHERE INA01=INB01 AND IMA01=INB04              '+
          '   AND  INA02 BETWEEN ''%S'' AND ''%S''         '+
          '   AND INB15=''MO3''                             ';


    SQL.Add(Format(lsql,[Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='外包雜項領料明細';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;



procedure GetWOSD(StartDate,endDate,DS2ETA,DS3ETA:String);
var
  lSQL:String;
begin
   //創建一個臨時表
   try
     ExecSQLA('CREATE TEMP TABLE TempMATSD'+
        ' (PLANT VARCHAR(6),   '+
        '  STKNO VARCHAR(10),  '+
        '  PARTNO VARCHAR(15), '+
        '  SDDATE VARCHAR(10), '+
        '  SDTYPE VARCHAR(10), '+
        '  SDINFO VARCHAR(25), '+
        '  SDQTY DECIMAL(12,0),'+
        '  SDBAL DECIMAL(12,0))');
     // ExecSQLA('CREATE INDEX IDX_TMP_MATSD ON TempMATSD (PLANT,STKNO,PARTNO,SDDATE)');
   except
      on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then
         ExecSQLA('DELETE TempMATSD');
   end;


   try
     ExecSQLA('CREATE TEMP TABLE TempPart'+
        ' (PARTNO VARCHAR(15),STKNO VARCHAR(6))');

   except
      on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then
         ExecSQLA('DELETE TempPart');
   end;


   ExecSQLA('SELECT SFB01,SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB04 <=''7'' INTO TEMP TempWoDate');
   ExecSQLA('INSERT INTO TempWoDate SELECT SFB01,SFB25 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB04 <=''7''');
   ExecSQLA('INSERT INTO TempWoDate SELECT SFB01,SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''PTM'' AND SFB04 <=''7''');
   ExecSQLA('UPDATE TempWoDate SET SFB25=TODAY WHERE  SFB01[1,3]=''PTM''');

   
   // WO DATA DS3 A01
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''保稅'',  '+
         '            ''A01'',      ' +
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                             '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                                     '+
         '  FROM DS3::SFA_FILE,DS3::SFB_FILE A,DS3::IMA_FILE,TempWoDate B  '+
         ' WHERE A.SFB01[5,8]=B.SFB01[5,8] AND B.SFB01[1,3]=''WOD''       '+
         '   AND SFA01=A.SFB01                                            '+
         '   AND SFA03=IMA01                                              '+
         '   AND IMA08=''P''  AND SFA30=''A01''                           '+
         '   AND A.SFB04 <=''7''                                    '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             BETWEEN ''%S'' AND ''%S''                    '+
         '  AND (SFA05-SFA06)!=0';
   ExecSQLA(Format(lSql,[StartDate,endDate]));


     //A01 需要先導入保稅系統的需求方便統計A02
   lSql:= '     SELECT DISTINCT A.PARTNO                           '+
          '       FROM TempMATSD A                                 '+
          '      WHERE A.STKNO=''A01''                             '+
          '   GROUP BY A.PARTNO                                    '+
          '     HAVING (SUM(A.SDQTY)+(SELECT SUM(IMG10)            '+
          '                             FROM DS3::IMG_FILE         '+
          '                            WHERE IMG01=A.PARTNO        '+
          '                              AND IMG02 IN(''A01'',''B01'')))>=0 INTO TEMP TempPartA';
     ExecSqla(lSql);

   lSql:='DELETE TempMATSD WHERE PARTNO IN (SELECT  PARTNO FROM TempPartA ) ';
   ExecSqla(lSql);

   ExecSqlA('DROP TABLE TempPartA');
   
   // WO DATA DS3 A02 
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',  '+
         '            ''01'',      ' +
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                                     '+
         '  FROM DS3::SFA_FILE,DS3::SFB_FILE A,DS3::IMA_FILE,TempWoDate B  '+
         ' WHERE A.SFB01[5,8]=B.SFB01[5,8] AND B.SFB01[1,3]=''WOD''       '+
         '   AND SFA01=A.SFB01                                            '+
         '   AND SFA03=IMA01                                              '+
         '   AND IMA08=''P''  AND SFA30!=''A01''                          '+
         '   AND A.SFB04 <=''7''                                  '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             BETWEEN ''%S'' AND ''%S''                  '+
         '  AND (SFA05-SFA06)!=0';
   ExecSQLA(Format(lSql,[StartDate,endDate]));

   // WO DATA DS2
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                      '+
         '            ''01'',     '+
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                                     '+
         '  FROM DS2::SFA_FILE,DS2::SFB_FILE A,DS2::IMA_FILE,TempWoDate B  '+
         ' WHERE A.SFB01[5,8]=B.SFB01[5,8] AND B.SFB01[1,3]=''WOD''   '+
         '   AND SFA01=A.SFB01                                        '+
         '   AND SFA03=IMA01                                          '+
         '   AND IMA08=''P''                                          '+
         '   AND A.SFB04 <=''7''                                    '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             BETWEEN ''%S'' AND ''%S''                    '+
         '  AND (SFA05-SFA06)!=0';
    ExecSQLA(Format(lSql,[StartDate,endDate]));

   // DS2  PTM WORK ORDER
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                                 '+
         '            ''01'',                                                   '+
         '            SFA03,                                                    '+
         '            B.SFB25,                                                  '+
         '            ''0.雜領'',                                               '+
         '            SFA01||''-''||SFB91,                                      '+
         '            -(SFA05-SFA06)                                            '+
         '  FROM DS2::SFA_FILE,DS2::SFB_FILE A,DS2::IMA_FILE,TempWoDate B       '+
         ' WHERE A.SFB01[5,10]=B.SFB01[5,10] AND B.SFB01[1,3]=''PTM''           '+
         '   AND SFA01=A.SFB01                                                  '+
         '   AND SFA03=IMA01                                                    '+
         '   AND IMA08=''P''                                                    '+
         '   AND A.SFB04 <=''7''                                                '+
         '   AND B.SFB25 BETWEEN ''%S'' AND ''%S''                              '+
         '   AND (SFA05-SFA06)!=0  ';
   ExecSQLA(Format(lSql,[StartDate,endDate]));


    // WO DATA DS2 SO6
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '  SELECT ''非保'',''01'',OEB04,OEB15,''1.受訂'',OEA01,-SUM((OEB12-OEB24)*OEB05_FAC) '+
         '     FROM DS2::OEB_FILE , DS2::OEA_FILE                                          '+
         '    WHERE OEB01 = OEA01                                                          '+
         '      AND OEA00<>''0''                                                           '+
         '      AND OEB70 = ''N''                                                          '+
         '      AND OEB12 > OEB24                                                          '+
         '      AND OEA01[1,3]=''SO6''                                                     '+
         '      AND OEA25=''CX3''                                                          '+
         ' GROUP BY 1,2,3,4 ,5,6';
      ExecSQLA(lSql);




    //01
    lSql:='     SELECT DISTINCT A.PARTNO                        '+
          '       FROM TempMATSD A                              '+
          '      WHERE A.STKNO=''01''                           '+
          '   GROUP BY A.PARTNO                                 '+
          '    HAVING ((SELECT SUM(IMG10)                       '+
          '               FROM DS2::IMG_FILE                    '+
          '              WHERE IMG01=A.PARTNO                   '+
          '                AND IMG02 IN(''01'',''0A'') )+SUM(A.SDQTY))>=0 INTO TEMP TempPartB';
     ExecSqla(lSql);


    lSql:='DELETE TempMATSD  WHERE STKNO=''01'' AND PARTNO IN (SELECT PARTNO FROM TempPartB) ';
    ExecSqla(lSql);

    ExecSqlA('DROP TABLE TempPartB');

   //確認要抓取的料號
   lSql:='INSERT INTO TempPart(PARTNO,STKNO) '+
         ' SELECT DISTINCT PARTNO,STKNO  '+
         '   FROM TempMATSD';

   ExecSQLA(lSql);


   // 01 OH
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                   '+
         '            ''01'',                                     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.庫存'',                                   '+
         '            (SELECT TRIM(IMD02) FROM DS2::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03), '+
         '            SUM(IMG10)                                  '+
         '       FROM DS2::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''01''              '+
         '        AND IMG02 IN(''01'',''0A'')                     '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(lSql);

   // A01 OH
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''保稅'',                                                 '+
         '            CASE WHEN IMG02=''B01'' THEN ''A01'' ELSE IMG02 END ,     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.庫存'',                                   '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''A01''             '+
         '        AND IMG02 IN(''A01'',''B01'')                   '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5 ,6                                ';

   ExecSQLA(lSql);

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                    '+
         '            ''01'',                                      '+
         '            IMG01,                                       '+
         '            ''%s'',                                      '+
         '            ''4.在途'',                                    '+
         '            (SELECT TRIM(IMD02) FROM DS2::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS2::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO   AND STKNO=''01''             '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds2Eta]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''保稅'',                                   '+
         '            ''A01'',                                    '+
         '            IMG01,                                      '+
         '            ''%s'',                                     '+
         '            ''4.在途'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''A01''             '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds3Eta]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''非保'',                                                      '+
         '       ''01'',                                                        '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.在外'',                               '+
         '       PMN01||''-''||PMN02,                      '+
         '       SUM(PMN20-PMN50+PMN55)                    '+
         '  FROM DS2::PMM_FILE,DS2::PMN_FILE ,TempPart     '+
         ' WHERE pmm01 = PMN01 AND  PMN04=PARTNO           '+
         '   AND PMM18!=''X''  AND STKNO=''01''            '+
         '   AND PMN20 > (PMN50+PMN55) AND PMN16<=''2''     '+
         '    GROUP BY 1,2,3,4,5,6';

   ExecSQLA(lSql);

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''保稅'',                                                      '+
         '       ''A01'',                                                       '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.在外'',                               '+
         '       PMN01||''-''||PMN02,                      '+
         '       SUM(PMN20-PMN50+PMN55)                    '+
         '  FROM DS3::PMM_FILE,DS3::PMN_FILE ,TempPart     '+
         ' WHERE pmm01 = PMN01 AND  PMN04=PARTNO           '+
         '   AND PMM01[1,3]!=''PTS''  AND STKNO=''A01''    '+
         '   AND PMM18!=''X''                              '+
         '   AND PMN20 > (PMN50+PMN55) AND PMN16<=''2''     '+
         '    GROUP BY 1,2,3,4,5,6';

   ExecSQLA(lSql);


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
            '     SELECT ''非保'',                                              '+
            '            ''01'',                                                '+
            '            RVB05  ,                                               '+
            '            RVA06+7  ,                                             '+
            '            ''3.待驗'',                                            '+
            '            RVB01||''-''||RVB02 ,                                  '+
            '            SUM((RVB07-RVB29-RVB30)*PMN09)                         '+
            '        FROM DS2::RVB_FILE , DS2::RVA_FILE, DS2::PMN_FILE,TempPart '+
            '       WHERE RVB01=RVA01  AND RVB05=PARTNO                         '+
            '         AND RVB04 = PMN01  AND STKNO=''01''                       '+
            '         AND RVB03 = PMN02                                         '+
            '         AND RVB07 > (RVB29+RVB30)                                 '+            
            '         AND RVACONF!=''X''                                        '+
            '    GROUP BY 1,2,3,4,5,6';
   ExecSQLA(lSql);


   lSql:= ' SELECT A.PLANT ,       '+
          '       A.STKNO ,        '+
          '       A.PARTNO ,       '+
          '       A.SDDATE ,       '+
          '       A.SDTYPE ,       '+
          '       A.SDINFO ,       '+
          '       A.SDQTY ,        '+
          '       (SELECT SUM(B.SDQTY)      '+
          '          FROM TempMATSD B       '+
          '         WHERE A.PARTNO=B.PARTNO '+
          '           AND A.PLANT=B.PLANT   '+
          '           AND (A.SDDATE||A.SDINFO[4,18]) >= (B.SDDATE||B.SDINFO[4,18])) AS SDBAL'+
          '    FROM TempMATSD A '+
          ' ORDER BY A.PLANT,A.PARTNO,A.SDDATE,A.SDINFO[4,18] INTO TEMP TempMATSDEX';
    ExecSqla(lSql);



 //匯總報表
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
    Screen.Cursor:=crSQLWait;
    if frmSysQryResultEx.Query.Active then frmSysQryResultEx.Query.Close;
    frmSysQryResultEx.Query.SQL.Clear;

    lSql:='SELECT A.PLANT AS 廠別,                                                                                              '+
          '       A.STKNO AS 庫別,                                                                                              '+
          '       A.SDTYPE AS 類別,                                                                                             '+
          '       A.SDDATE AS 供需日期,                                                                                         '+
          '      CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'')  THEN             '+
          '        (CASE  WHEN MONTH(A.SDDATE)< MONTH(TODAY) AND A.SDBAL<0 THEN ''******''                                      '+
          '             WHEN MONTH(A.SDDATE)= MONTH(TODAY) AND A.SDDATE<= TODAY AND A.SDBAL<0 THEN ''*****''                    '+
          '             WHEN MONTH(A.SDDATE)= MONTH(TODAY) AND A.SDDATE BETWEEN TODAY+1 AND TODAY+7  AND A.SDBAL<0 THEN ''****'''+
          '             WHEN MONTH(A.SDDATE)= MONTH(TODAY) AND A.SDDATE BETWEEN TODAY+8 AND TODAY+15 AND A.SDBAL<0 THEN ''***'' '+
          '             WHEN A.SDDATE > TODAY+16 AND A.SDBAL<0 THEN ''**'' END)                                                 '+
          '       ELSE                                                                                                          '+
          '        (CASE WHEN A.SDINFO[1,2] IN (''RC'',''P0'',''PT'') THEN                                                               '+
          '             (CASE WHEN (A.SDBAL-A.SDQTY)<0 THEN ''*****''  END)                                                     '+
          '         END)                                                                                                        '+
          '       END AS 急,                                                                                                    '+
          '       A.PARTNO AS 料號,                                                                                             '+
          '       (SELECT COUNT(B.PARTNO) FROM TempMATSDEX B WHERE B.PLANT=A.PLANT AND B.STKNO=A.STKNO AND B.PARTNO=A.PARTNO AND'+
          '                                                  B.SDDATE||B.SDINFO[4,10]<=A.SDDATE||A.SDINFO[4,10]) AS 項次,       '+
          '       CASE WHEN A.SDQTY>=0 THEN ''供'' ELSE ''需'' END AS 供需,                                                     '+
          '       A.SDQTY AS 數量,                                                                                              '+
          '       A.SDBAL AS 結存,                                                                                              '+
          '       A.SDINFO AS 參考,                                                                                             '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '         A.SDINFO[5,8] END AS 母工單,                                                                                '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '            CASE WHEN A.SDINFO[7,7] IN(''0'',''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'') THEN             '+
          '              (SELECT SFB05 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8])                '+
          '            ELSE (SELECT SFB05 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8])             '+
          '            END                                                                                                      '+
          '       END AS 機種,                                                                                                  '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT PMC03 FROM DS2::PMM_FILE,DS2::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '            (SELECT PMC03 FROM DS3::PMM_FILE,DS3::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10])               '+
          '        END) AS 廠商,                                                                                                '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT GEN02 FROM DS2::PMM_FILE,DS2::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '           (SELECT GEN02 FROM DS3::PMM_FILE,DS3::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10])                '+
          '        END ) AS 採購                                                                                                '+
          '  FROM TempMATSDEX A                                                                                                 '+
          ' ORDER BY A.PLANT,A.STKNO,A.PARTNO,A.SDDATE||A.SDINFO[4,10] ';

    frmSysQryResultEx.Query.Sql.Add(lSql);
    frmSysQryResultEx.Query.Open;

    Screen.Cursor:=crDefault;

    if frmSysQryResultEx.Query.RecordCount>0 then begin
      frmSysQryResultEx.Caption:=Format('%S-%S 期間工單材料供需查詢',[StartDate,endDate]);
      frmSysQryResultEx.ShowModal;
    end else begin
      Application.MessageBox(Pchar((Format('%s , %S - %s 期間供料正常！',[Username,StartDate,endDate]))),'提示',MB_ICONINFORMATION+MB_OK);
    end;

  finally
    Screen.Cursor:=crDefault;
    ExecSqlA('DROP TABLE TempMATSD');
    ExecSqlA('DROP TABLE TempMATSDEX');
    ExecSqlA('DROP TABLE TempPart');
    ExecSqlA('DROP TABLE TempWoDate');
        
    frmSysQryResultEx.Free;
  end;
end;


procedure GetPartSD(Partno,StartDate,endDate,DS2ETA,DS3ETA:String);
var
  lSQL:String;
begin
   //創建一個臨時表
   try
     ExecSQLA('CREATE TEMP TABLE TempMATSD'+
        ' (PLANT VARCHAR(6),   '+
        '  STKNO VARCHAR(10),  '+
        '  PARTNO VARCHAR(15), '+
        '  SDDATE VARCHAR(10), '+
        '  SDTYPE VARCHAR(10), '+
        '  SDINFO VARCHAR(25), '+
        '  SDQTY DECIMAL(12,0),'+
        '  SDBAL DECIMAL(12,0))');
   except
      on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then
         ExecSQLA('DELETE TempMATSD');
   end;

   ExecSQLA('SELECT SFB01,SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB04 <=''7'' INTO TEMP TempWoDate');
   ExecSQLA('INSERT INTO TempWoDate SELECT SFB01,SFB25 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB04 <=''7''');
   ExecSQLA('INSERT INTO TempWoDate SELECT SFB01,SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''PTM'' AND SFB04 <=''7''');
   ExecSQLA('UPDATE TempWoDate SET SFB25=TODAY WHERE  SFB01[1,3]=''PTM''');

   // WO DATA DS3 A01
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''保稅'',  '+
         '            ''A01'',      ' +
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                             '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                                   '+
         '  FROM DS3::SFA_FILE,DS3::SFB_FILE A,DS3::IMA_FILE,TempWoDate B  '+
         ' WHERE A.SFB01[5,8]=B.SFB01[5,8] AND B.SFB01[1,3]=''WOD''       '+
         '   AND SFA01=A.SFB01                                            '+
         '   AND SFA03=IMA01                                              '+
         '   AND IMA08=''P''  AND SFA30=''A01''                           '+
         '   AND A.SFB04 <=''7''                                    '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             BETWEEN ''%S'' AND ''%S''                    '+
         '  AND SFA03=''%S'' AND (SFA05-SFA06)!=0';
   ExecSQLA(Format(lSql,[StartDate,endDate,Partno]));

   // WO DATA DS3 A02 
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',  '+
         '            ''01'',      ' +
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                                     '+
         '  FROM DS3::SFA_FILE,DS3::SFB_FILE A,DS3::IMA_FILE,TempWoDate B  '+
         ' WHERE A.SFB01[5,8]=B.SFB01[5,8] AND B.SFB01[1,3]=''WOD''       '+
         '   AND SFA01=A.SFB01                                            '+
         '   AND SFA03=IMA01                                              '+
         '   AND IMA08=''P''  AND SFA30!=''A01''                          '+
         '   AND A.SFB04 <=''7''                                  '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             BETWEEN ''%S'' AND ''%S''                  '+
         '  AND SFA03=''%S'' AND (SFA05-SFA06)!=0';
   ExecSQLA(Format(lSql,[StartDate,endDate,Partno]));

   // WO DATA DS2
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                      '+
         '            ''01'',     '+
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                                     '+
         '  FROM DS2::SFA_FILE,DS2::SFB_FILE A,DS2::IMA_FILE,TempWoDate B  '+
         ' WHERE A.SFB01[5,8]=B.SFB01[5,8] AND B.SFB01[1,3]=''WOD''   '+
         '   AND SFA01=A.SFB01                                        '+
         '   AND SFA03=IMA01                                          '+
         '   AND IMA08=''P''                                          '+
         '   AND A.SFB04 <=''7''                                    '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             BETWEEN ''%S'' AND ''%S''                    '+
         '  AND SFA03=''%S'' AND (SFA05-SFA06)!=0  ';
   ExecSQLA(Format(lSql,[StartDate,endDate,Partno]));


   // DS2  PTM WORK ORDER
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                                 '+
         '            ''01'',                                                   '+
         '            SFA03,                                                    '+
         '            B.SFB25,                                                  '+
         '            ''0.雜領'',                                               '+
         '            SFA01||''-''||SFB91,                                      '+
         '            -(SFA05-SFA06)                                            '+
         '  FROM DS2::SFA_FILE,DS2::SFB_FILE A,DS2::IMA_FILE,TempWoDate B       '+
         ' WHERE A.SFB01[5,10]=B.SFB01[5,10] AND B.SFB01[1,3]=''PTM''           '+
         '   AND SFA01=A.SFB01                                                  '+
         '   AND SFA03=IMA01                                                    '+
         '   AND IMA08=''P''                                                    '+
         '   AND A.SFB04 <=''7''                                                '+
         '   AND B.SFB25 BETWEEN ''%S'' AND ''%S''                              '+
         '  AND SFA03=''%S'' AND (SFA05-SFA06)!=0  ';
   ExecSQLA(Format(lSql,[StartDate,endDate,Partno]));

   

    // WO DATA DS2 SO6
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '  SELECT ''非保'',''01'',OEB04,OEB15,''1.受訂'',OEA01,-SUM((OEB12-OEB24)*OEB05_FAC) '+
         '     FROM DS2::OEB_FILE , DS2::OEA_FILE                                          '+
         '    WHERE OEB01 = OEA01                                                          '+
         '      AND OEA00<>''0''                                                           '+
         '      AND OEB70 = ''N''                                                          '+
         '      AND OEB12 > OEB24                                                          '+
         '      AND OEA01[1,3]=''SO6''                                                     '+
         '      AND OEA25=''CX3'' AND OEB04=''%S''                                         '+
         ' GROUP BY 1,2,3,4 ,5,6';
      ExecSQLA(Format(lSql,[Partno]));

   //DS2 PR
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)               '+
         ' SELECT ''非保'',''01'',PML04,PML33,''6.請購'',PML01||''-''||PML02,SUM(PML20-PML21)'+
         '   FROM DS2::PMK_FILE,DS2::PML_FILE                                                '+
         '  WHERE PMK01=PML01  AND PML04=''%S''                                              '+
         '    AND PML16 BETWEEN 0 AND 1   GROUP BY 1,2,3,4,5,6';
      ExecSQLA(Format(lSql,[Partno]));

   //DS2 PR
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)               '+
         ' SELECT ''保稅'',''01'',PML04,PML33,''6.請購'',PML01||''-''||PML02,SUM(PML20-PML21)'+
         '   FROM DS3::PMK_FILE,DS3::PML_FILE                                                '+
         '  WHERE PMK01=PML01  AND PML04=''%S''                                              '+
         '    AND PML16 BETWEEN 0 AND 1  GROUP BY 1,2,3,4,5,6';
      ExecSQLA(Format(lSql,[Partno]));

   // 01 OH
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                   '+
         '            ''01'',                                     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.庫存'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS2::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03), '+
         '            SUM(IMG10)                                  '+
         '       FROM DS2::IMG_FILE                               '+
         '      WHERE IMG01=''%s''                               '+
         '        AND IMG02 IN(''01'',''0A'')                     '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[Partno]));

   // A01 OH
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''保稅'',                                                 '+
         '            CASE WHEN IMG02=''B01'' THEN ''A01'' ELSE IMG02 END ,     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.庫存'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE                               '+
         '      WHERE IMG01=''%s''                                '+
         '        AND IMG02 IN(''A01'',''B01'')                   '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5 ,6                                ';
   ExecSQLA(Format(lSql,[Partno]));

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                    '+
         '            ''01'',                                      '+
         '            IMG01,                                       '+
         '            ''%s'',                                      '+
         '            ''4.在途'',                                  '+
         '            (SELECT TRIM(IMD02) FROM DS2::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS2::IMG_FILE                               '+
         '      WHERE IMG01=''%s''                                '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds3Eta,Partno]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''保稅'',                                   '+
         '            ''A01'',                                    '+
         '            IMG01,                                      '+
         '            ''%s'',                                     '+
         '            ''4.在途'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE                               '+
         '      WHERE IMG01=''%S''                                '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds3Eta,Partno]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''非保'',                                                      '+
         '       ''01'',                                                        '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.在外'',                               '+
         '       PMN01||''-''||PMN02,                      '+
         '       SUM(PMN20-PMN50+PMN55)                    '+
         '  FROM DS2::PMM_FILE,DS2::PMN_FILE               '+
         ' WHERE pmm01 = PMN01 AND  PMN04=''%S''           '+
         '   AND PMM18!=''X''                              '+
         '   AND PMN20 > (PMN50+PMN55) AND PMN16<=''2''     '+
         '    GROUP BY 1,2,3,4,5,6';
   ExecSQLA(Format(lSql,[Partno]));

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''保稅'',                                                      '+
         '       ''A01'',                                                       '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.在外'',                               '+
         '       PMN01||''-''||PMN02,                      '+
         '       SUM(PMN20-PMN50+PMN55)                    '+
         '  FROM DS3::PMM_FILE,DS3::PMN_FILE               '+
         ' WHERE pmm01 = PMN01 AND  PMN04=''%S''           '+
         '   AND PMM01[1,3]!=''PTS''                       '+
         '   AND PMM18!=''X''                              '+
         '   AND PMN20 > (PMN50+PMN55) AND PMN16<=''2''     '+
         '    GROUP BY 1,2,3,4,5,6';
   ExecSQLA(Format(lSql,[Partno]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
            '     SELECT ''非保'',                                              '+
            '            ''01'',                                                '+
            '            RVB05  ,                                               '+
            '            RVA06+7  ,                                             '+
            '            ''3.待驗'',                                            '+
            '            RVB01||''-''||RVB02 ,                                  '+
            '            SUM((RVB07-RVB29-RVB30)*PMN09)                         '+
            '        FROM DS2::RVB_FILE , DS2::RVA_FILE, DS2::PMN_FILE          '+
            '       WHERE RVB01=RVA01  AND RVB05=''%S''                         '+
            '         AND RVB04 = PMN01                                         '+
            '         AND RVB03 = PMN02                                         '+
            '         AND RVB07 > (RVB29+RVB30)                                 '+            
            '         AND RVACONF!=''X''                                        '+
            '    GROUP BY 1,2,3,4,5,6';
   ExecSQLA(Format(lSql,[Partno]));


   lSql:= ' SELECT A.PLANT ,       '+
          '       A.STKNO ,        '+
          '       A.PARTNO ,       '+
          '       A.SDDATE ,       '+
          '       A.SDTYPE ,       '+
          '       A.SDINFO ,       '+
          '       A.SDQTY ,        '+
          '       (SELECT SUM(B.SDQTY)      '+
          '          FROM TempMATSD B       '+
          '         WHERE A.PARTNO=B.PARTNO '+
          '           AND A.PLANT=B.PLANT   '+
          '           AND (A.SDDATE||A.SDINFO[4,18]) >= (B.SDDATE||B.SDINFO[4,18])) AS SDBAL'+
          '    FROM TempMATSD A '+
          ' ORDER BY A.PLANT,A.PARTNO,A.SDDATE,A.SDINFO[4,18] INTO TEMP TempMATSDEX';
    ExecSqla(lSql);



 //匯總報表
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
    Screen.Cursor:=crSQLWait;
    if frmSysQryResultEx.Query.Active then frmSysQryResultEx.Query.Close;
    frmSysQryResultEx.Query.SQL.Clear;

    lSql:='SELECT A.PLANT AS 內外,                                                                                              '+
          '       A.STKNO AS 庫別,                                                                                              '+
          '       A.SDTYPE AS 類別,                                                                                             '+
          '       A.SDDATE AS 供需日期,                                                                                         '+
          '      CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'')  THEN             '+
          '        (CASE  WHEN MONTH(A.SDDATE)< MONTH(TODAY) AND A.SDBAL<0 THEN ''******''                                      '+
          '             WHEN MONTH(A.SDDATE)= MONTH(TODAY) AND A.SDDATE<= TODAY AND A.SDBAL<0 THEN ''*****''                    '+
          '             WHEN MONTH(A.SDDATE)= MONTH(TODAY) AND A.SDDATE BETWEEN TODAY+1 AND TODAY+7  AND A.SDBAL<0 THEN ''****'''+
          '             WHEN MONTH(A.SDDATE)= MONTH(TODAY) AND A.SDDATE BETWEEN TODAY+8 AND TODAY+15 AND A.SDBAL<0 THEN ''***'' '+
          '             WHEN A.SDDATE > TODAY+16 AND A.SDBAL<0 THEN ''**'' END)                                                 '+
          '       ELSE                                                                                                          '+
          '        (CASE WHEN A.SDINFO[1,2] IN (''RC'',''PO'',''PT'') THEN                                                               '+
          '             (CASE WHEN (A.SDBAL-A.SDQTY)<0 THEN ''*****''  END)                                                     '+
          '         END)                                                                                                        '+
          '       END AS 急,                                                                                                    '+
          '       A.PARTNO AS 料號,                                                                                             '+
          '       (SELECT COUNT(B.PARTNO) FROM TempMATSDEX B WHERE B.PLANT=A.PLANT AND B.STKNO=A.STKNO AND B.PARTNO=A.PARTNO AND'+
          '                                                  B.SDDATE||B.SDINFO[4,10]<=A.SDDATE||A.SDINFO[4,10]) AS 項次,       '+
          '       CASE WHEN A.SDQTY>=0 THEN ''供'' ELSE ''需'' END AS 供需,                                                     '+
          '       A.SDQTY AS 數量,                                                                                              '+
          '       A.SDBAL AS 結存,                                                                                              '+
          '       A.SDINFO AS 參考,                                                                                              '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '         A.SDINFO[5,8] END AS 母工單,                                                                                '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '            CASE WHEN A.SDINFO[7,7] IN(''0'',''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'') THEN             '+
          '              (SELECT SFB05 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8] AND SFB05[1,2]=''01'')                '+
          '            ELSE (SELECT SFB05 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8] AND SFB05[1,2]=''01'')             '+
          '            END                                                                                                      '+
          '       END AS 機種,                                                                                                  '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT PMC03 FROM DS2::PMM_FILE,DS2::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '            (SELECT PMC03 FROM DS3::PMM_FILE,DS3::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10])               '+
          '        END) AS 廠商,                                                                                                '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT GEN02 FROM DS2::PMM_FILE,DS2::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '           (SELECT GEN02 FROM DS3::PMM_FILE,DS3::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10])                '+
          '        END ) AS 採購                                                                                                '+
          '  FROM TempMATSDEX A                                                                                                 '+
          ' ORDER BY A.PLANT,A.STKNO,A.PARTNO,A.SDDATE||A.SDINFO[4,10] ';

    frmSysQryResultEx.Query.Sql.Add(lSql);
    frmSysQryResultEx.Query.Open;

    Screen.Cursor:=crDefault;

    if frmSysQryResultEx.Query.RecordCount>0 then begin
      frmSysQryResultEx.Caption:=Format('%S-%S-%S 材料供需查詢',[StartDate,endDate,Partno]);
      frmSysQryResultEx.ShowModal;
    end else begin
      Application.MessageBox(Pchar((Format('%s , %S - %s 期間無 %S 供料信息！',[Username,StartDate,endDate,Partno]))),'提示',MB_ICONINFORMATION+MB_OK);
    end;

  finally
    Screen.Cursor:=crDefault;
     ExecSqlA('DROP TABLE TempMATSD');
     ExecSqlA('DROP TABLE TempMATSDEX');
     ExecSqlA('DROP TABLE TempWoDate');

    frmSysQryResultEx.Free;
  end;
end;



procedure GetWOSDEX(WorkOrderNo,DS2ETA,DS3ETA,NewStartDate:String;Sel:Boolean);
var
  lSQL:String;
  woLocal:String[1];
  woDate:String;
  DateStr:String[8];
begin

   DateStr:='%Y%m%d';
   //創建一個臨時表
   try
     ExecSQLA('CREATE TEMP TABLE TempMATSD'+
        ' (PLANT VARCHAR(6),   '+
        '  STKNO VARCHAR(10),  '+
        '  PARTNO VARCHAR(15), '+
        '  SDDATE VARCHAR(10), '+
        '  SDTYPE VARCHAR(10), '+
        '  SDINFO VARCHAR(25), '+
        '  SDQTY DECIMAL(12,0),'+
        '  SDBAL DECIMAL(12,0))');
      ExecSQLA('CREATE INDEX IDX_TMP_MATSD ON TempMATSD (PLANT,STKNO,PARTNO,SDDATE)');
   except
      on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then
         ExecSQLA('DELETE TempMATSD');
   end;


   try
     ExecSQLA('CREATE TEMP TABLE TempPart'+
        ' (PARTNO VARCHAR(15),STKNO VARCHAR(6))');

   except
      on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then
         ExecSQLA('DELETE TempPart');
   end;


   WoLocal:=StrMid(WorkOrderNo,3,1);
   if not StrIsAlpha(WoLocal) then  begin
    if GetRecordCount(FOrmat('SELECT COUNT(*) FROM DS2::SFB_FILE WHERE SFB04<=''7'' AND SFB01[5,8]=''%S''',[WorkOrderNo]))>0 then begin
         lSql:='SELECT DISTINCT SFA03 AS PARTNO             '+
         '  FROM DS2::SFA_FILE,DS2::SFB_FILE,DS2::IMA_FILE  '+
         ' WHERE SFA01=SFB01                                '+
         '   AND SFA03=IMA01                                '+
         '   AND IMA08=''P''                                '+
         '   AND SFB01[5,8]=''%S''                          '+
         '   AND (SFA05-SFA06)!=0                           '+
         '   AND SFB04 <=''7'' INTO TEMP TempWoPart';
         ExecSQLA(Format(lSql,[WorkOrderNo]));
         
         ExecSQLA('SELECT SFB01,SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB04 <=''7'' INTO TEMP TempWoDate');
         ExecSQLA('INSERT INTO TempWoDate SELECT SFB01,SFB25 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB04 <=''7''');
         ExecSQLA('INSERT INTO TempWoDate SELECT SFB01,SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''PTM'' AND SFB04 <=''7''');
         ExecSQLA('UPDATE TempWoDate SET SFB25=TODAY WHERE  SFB01[1,3]=''PTM''');   //PTM 工單材料需求修改為當日

         if not Sel then begin
           woDate:=GetRecordValue(Format('SELECT SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=''%S''',[WorkOrderNo]));
         end else begin
           woDate:=NewStartDate;
           lSql:='UPDATE TempWoDate SET SFB25=''%S'' WHERE SFB01[5,8]=''%S''';
           ExecSQLA(Format(lSql,[woDate,WorkOrderNo]));
         end;
         
   // WO DATA DS3 A02
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',  '+
         '            ''01'',      ' +
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                                 '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                            '+
         '  FROM DS3::SFA_FILE,DS3::SFB_FILE A,DS3::IMA_FILE, TempWoDate B,TempWoPart '+
         ' WHERE SFA01=A.SFB01 AND A.SFB01[5,8]= B.SFB01[5,8]                                              '+
         '   AND SFA03=IMA01                                              '+
         '   AND IMA08=''P''  AND SFA30!=''A01''                          '+
         '   AND A.SFB04 <=''7''                                          '+
         '   AND SFA03 =PARTNO                                            '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             <=''%S''                                     '+
         '  AND (SFA05-SFA06)!=0';
   ExecSQLA(Format(lSql,[woDate]));

   // WO DATA DS2
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                      '+
         '            ''01'',     '+
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                                 '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                            '+
         '  FROM DS2::SFA_FILE,DS2::SFB_FILE A,DS2::IMA_FILE,TempWoDate B,TempWoPart  '+
         ' WHERE SFA01=A.SFB01  AND A.SFB01[5,8]= B.SFB01[5,8]                                         '+
         '   AND SFA03=IMA01                                          '+
         '   AND IMA08=''P''                                          '+
         '   AND A.SFB04 <=''7''                                      '+
         '   AND SFA03= PARTNO                                        '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             <=''%S''                                       '+
         '  AND (SFA05-SFA06)!=0';
   ExecSQLA(Format(lSql,[woDate]));


   // DS2  PTM WORK ORDER
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                                 '+
         '            ''01'',                                                   '+
         '            SFA03,                                                    '+
         '            B.SFB25,                                                  '+
         '            ''0.雜領'',                                               '+
         '            SFA01||''-''||SFB91,                                      '+
         '            -(SFA05-SFA06)                                            '+
         '  FROM DS2::SFA_FILE,DS2::SFB_FILE A,DS2::IMA_FILE,TempWoDate B,TempWoPart  '+
         ' WHERE A.SFB01[5,10]=B.SFB01[5,10] AND B.SFB01[1,3]=''PTM''           '+
         '   AND SFA01=A.SFB01                                                  '+
         '   AND SFA03=IMA01  AND SFA03=PARTNO                                  '+
         '   AND IMA08=''P''                                                    '+
         '   AND A.SFB04 <=''7''                                                '+
         '   AND B.SFB25 <=''%S''                                               '+
         '   AND (SFA05-SFA06)!=0  ';
   ExecSQLA(Format(lSql,[woDate]));

    // WO DATA DS2 SO6
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '  SELECT ''非保'',''01'',OEB04,OEB15,''1.受訂'',OEA01,-SUM((OEB12-OEB24)*OEB05_FAC) '+
         '     FROM DS2::OEB_FILE , DS2::OEA_FILE ,TempWoPart                              '+
         '    WHERE OEB01 = OEA01  AND PARTNO=OEB04                                        '+
         '      AND OEA00<>''0''                                                           '+
         '      AND OEB70 = ''N''                                                          '+
         '      AND OEB12 > OEB24                                                          '+
         '      AND OEA01[1,3]=''SO6''                                                     '+
         '      AND OEA25=''CX3''                                                          '+
         ' GROUP BY 1,2,3,4 ,5,6';
      ExecSQLA(lSql);   

    //01
    lSql:='     SELECT DISTINCT A.PARTNO                        '+
          '       FROM TempMATSD A                              '+
          '      WHERE A.STKNO=''01''                           '+
          '   GROUP BY A.PARTNO                                 '+
          '    HAVING ((SELECT SUM(IMG10)                       '+
          '               FROM DS2::IMG_FILE                    '+
          '              WHERE IMG01=A.PARTNO                   '+
          '                AND IMG02 IN(''01'',''0A'') )+SUM(A.SDQTY))>=0 INTO TEMP TempPartB';
     ExecSqla(lSql);


    lSql:='DELETE TempMATSD  WHERE STKNO=''01'' AND PARTNO IN (SELECT PARTNO FROM TempPartB) ';
    ExecSqla(lSql);

    ExecSqlA('DROP TABLE TempPartB');

    end else begin
      Application.MessageBox(Pchar((Format('%s,%S 工單無缺料！',[Username,WorkOrderNo]))),'提示',MB_ICONINFORMATION+MB_OK);
    end;
   end else begin
         if GetRecordCount(FOrmat('SELECT COUNT(*) FROM DS3::SFB_FILE WHERE SFB04<=''7'' AND SFB01[5,8]=''%S''',[WorkOrderNo]))>0 then begin
         lSql:='SELECT DISTINCT SFA03 AS PARTNO             '+
         '  FROM DS3::SFA_FILE,DS3::SFB_FILE,DS3::IMA_FILE  '+
         ' WHERE SFA01=SFB01                                '+
         '   AND SFA03=IMA01                                '+
         '   AND IMA08=''P''                                '+
         '   AND SFB01[5,8]=''%S''                          '+
         '   AND (SFA05-SFA06)!=0                           '+
         '   AND SFB04 <=''7'' INTO TEMP TempWoPart ';
         ExecSQLA(Format(lSql,[WorkOrderNo]));

         ExecSQLA('SELECT SFB01,SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB04 <=''7'' INTO TEMP TempWoDate');
         ExecSQLA('INSERT INTO TempWoDate SELECT SFB01,SFB25 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB04 <=''7''');
         ExecSQLA('INSERT INTO TempWoDate SELECT SFB01,SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''PTM'' AND SFB04 <=''7''');
         ExecSQLA('UPDATE TempWoDate SET SFB25=TODAY WHERE  SFB01[1,3]=''PTM''');   //PTM 工單材料需求修改為當日

      if Not Sel then begin
         woDate:=GetRecordValue(Format('SELECT SFB25 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=''%S''',[WorkOrderNo]));
      end else begin
        woDate:=NewStartDate;
        lSql:='UPDATE TempWoDate SET SFB25=''%S'' WHERE SFB01[5,8]=''%S''';
        ExecSQLA(Format(lSql,[woDate,WorkOrderNo]));
      end;

   // WO DATA DS3 A01
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)                 '+
         '     SELECT ''保稅'',                                                                 '+
         '            ''A01'',                                                                  '+
         '            SFA03,                                                                    '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                            '+
         '  FROM DS3::SFA_FILE,DS3::SFB_FILE A,DS3::IMA_FILE,TempWoDate B,TempWoPart  '+
         ' WHERE SFA01=A.SFB01 AND A.SFB01[5,8]= B.SFB01[5,8]                           '+
         '   AND SFA03=IMA01                                        '+
         '   AND IMA08=''P''  AND SFA30=''A01''                     '+
         '   AND A.SFB04 <=''7''                                    '+
         '   AND SFA03 = PARTNO                                     '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             <=''%S''                                     '+
         '  AND (SFA05-SFA06)!=0';
   ExecSQLA(Format(lSql,[woDate]));


     //A01 需要先導入保稅系統的需求方便統計A02
   lSql:= '     SELECT DISTINCT A.PARTNO                           '+
          '       FROM TempMATSD A                                 '+
          '      WHERE A.STKNO=''A01''                             '+
          '   GROUP BY A.PARTNO                                    '+
          '     HAVING (SUM(A.SDQTY)+(SELECT SUM(IMG10)            '+
          '                             FROM DS3::IMG_FILE         '+
          '                            WHERE IMG01=A.PARTNO        '+
          '                              AND IMG02 IN(''A01'',''B01'')))>=0 INTO TEMP TempPartA';
     ExecSqla(lSql);

   lSql:='DELETE TempMATSD WHERE PARTNO IN (SELECT  PARTNO FROM TempPartA ) ';
   ExecSqla(lSql);

   ExecSqlA('DROP TABLE TempPartA');

   // WO DATA DS3 A02
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',  '+
         '            ''01'',      ' +
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                            '+
         '  FROM DS3::SFA_FILE,DS3::SFB_FILE A,DS3::IMA_FILE, TempWoDate B,TempWoPart '+
         ' WHERE SFA01=A.SFB01 AND A.SFB01[5,8]= B.SFB01[5,8]                                              '+
         '   AND SFA03=IMA01                                        '+
         '   AND IMA08=''P''  AND SFA30!=''A01''                    '+
         '   AND A.SFB04 <=''7''                                    '+
         '   AND SFA03 =PARTNO                                      '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             <=''%S''                                     '+
         '  AND (SFA05-SFA06)!=0';
   ExecSQLA(Format(lSql,[woDate]));

   // WO DATA DS2
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                      '+
         '            ''01'',     '+
         '            SFA03,                                '+
         '   (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25     '+
         '        WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7    '+
         '        WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12   '+
         '        WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14   '+
         '        WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16   '+
         '        WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20   '+
         '        WHEN SFA01[1,3]=''SKD'' THEN B.SFB25      '+
         '        WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END),'+
         '        ''0.工單'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''開立'''+
         '                           WHEN A.SFB04=''2'' THEN ''未印'''+
         '                           WHEN A.SFB04=''3'' THEN ''已印'''+
         '                           WHEN A.SFB04=''4'' THEN ''待補'''+
         '                           WHEN A.SFB04=''5'' THEN ''在製'''+
         '                           WHEN A.SFB04=''6'' THEN ''待檢'''+
         '                           WHEN A.SFB04=''7'' THEN ''入庫'''+
         '                      END,                                 '+
         '        -(SFA05-SFA06)                            '+
         '  FROM DS2::SFA_FILE,DS2::SFB_FILE A,DS2::IMA_FILE,TempWoDate B,TempWoPart  '+
         ' WHERE SFA01=A.SFB01  AND A.SFB01[5,8]= B.SFB01[5,8]      '+
         '   AND SFA03=IMA01                                        '+
         '   AND IMA08=''P''                                        '+
         '   AND A.SFB04 <=''7''                                    '+
         '   AND SFA03= PARTNO                                      '+
         '   AND (CASE WHEN SFA01[1,3]=''WOD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''ASY'' THEN B.SFB25-7       '+
         '             WHEN SFA01[1,3]=''PCB'' THEN B.SFB25-12      '+
         '             WHEN SFA01[1,3]=''AIV'' THEN B.SFB25-14      '+
         '             WHEN SFA01[1,3]=''AIH'' THEN B.SFB25-16      '+
         '             WHEN SFA01[1,3]=''SMD'' THEN B.SFB25-20      '+
         '             WHEN SFA01[1,3]=''SKD'' THEN B.SFB25         '+
         '             WHEN SFA01[1,3]=''RWK'' THEN B.SFB25 END )   '+
         '             <=''%S''                                     '+
         '  AND (SFA05-SFA06)!=0';
   ExecSQLA(Format(lSql,[woDate]));

   // DS2  PTM WORK ORDER
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                                 '+
         '            ''01'',                                                   '+
         '            SFA03,                                                    '+
         '            B.SFB25,                                                  '+
         '            ''0.雜領'',                                               '+
         '            SFA01||''-''||SFB91,                                      '+
         '            -(SFA05-SFA06)                                            '+
         '  FROM DS2::SFA_FILE,DS2::SFB_FILE A,DS2::IMA_FILE,TempWoDate B,TempWoPart '+
         ' WHERE A.SFB01[5,10]=B.SFB01[5,10] AND B.SFB01[1,3]=''PTM''           '+
         '   AND SFA01=A.SFB01                                                  '+
         '   AND SFA03=IMA01 AND SFA03=PARTNO                                   '+
         '   AND IMA08=''P''                                                    '+
         '   AND A.SFB04 <=''7''                                                '+
         '   AND B.SFB25 <=''%S''                                               '+
         '   AND (SFA05-SFA06)!=0  ';
   ExecSQLA(Format(lSql,[woDate]));

    // WO DATA DS2 SO6
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '  SELECT ''非保'',''01'',OEB04,OEB15,''1.受訂'',OEA01,-SUM((OEB12-OEB24)*OEB05_FAC) '+
         '     FROM DS2::OEB_FILE , DS2::OEA_FILE ,TempWoPart                              '+
         '    WHERE OEB01 = OEA01  AND PARTNO=OEB04                                        '+
         '      AND OEA00<>''0''                                                           '+
         '      AND OEB70 = ''N''                                                          '+
         '      AND OEB12 > OEB24                                                          '+
         '      AND OEA01[1,3]=''SO6''                                                     '+
         '      AND OEA25=''CX3''                                                          '+
         ' GROUP BY 1,2,3,4 ,5,6';
      ExecSQLA(lSql);

    //01
    lSql:='     SELECT DISTINCT A.PARTNO                        '+
          '       FROM TempMATSD A                              '+
          '      WHERE A.STKNO=''01''                           '+
          '   GROUP BY A.PARTNO                                 '+
          '    HAVING ((SELECT SUM(IMG10)                       '+
          '               FROM DS2::IMG_FILE                    '+
          '              WHERE IMG01=A.PARTNO                   '+
          '                AND IMG02 IN(''01'',''0A'') )+SUM(A.SDQTY))>=0 INTO TEMP TempPartB';
     ExecSqla(lSql);


    lSql:='DELETE TempMATSD  WHERE STKNO=''01'' AND PARTNO IN (SELECT PARTNO FROM TempPartB) ';
    ExecSqla(lSql);

     ExecSqlA('DROP TABLE TempPartB');

    end else begin
      Application.MessageBox(Pchar((Format('%s,%S 工單無缺料！',[Username,WorkOrderNo]))),'提示',MB_ICONINFORMATION+MB_OK); 
    end;
   end;





   //確認要抓取的料號
   lSql:='INSERT INTO TempPart(PARTNO,STKNO) '+
         ' SELECT DISTINCT PARTNO,STKNO  '+
         '   FROM TempMATSD';

   ExecSQLA(lSql);


   // 01 OH
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                   '+
         '            ''01'',                                     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.庫存'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS2::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03), '+
         '            SUM(IMG10)                                  '+
         '       FROM DS2::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''01''              '+
         '        AND IMG02 IN(''01'',''0A'')                     '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(lSql);

   // A01 OH
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''保稅'',                                                 '+
         '            CASE WHEN IMG02=''B01'' THEN ''A01'' ELSE IMG02 END ,     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.庫存'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''A01''             '+
         '        AND IMG02 IN(''A01'',''B01'')                   '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5 ,6                                ';

   ExecSQLA(lSql);

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''非保'',                                    '+
         '            ''01'',                                      '+
         '            IMG01,                                       '+
         '            ''%s'',                                      '+
         '            ''4.在途'',                                  '+
         '            (SELECT TRIM(IMD02) FROM DS2::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS2::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO   AND STKNO=''01''             '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds2Eta]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''保稅'',                                   '+
         '            ''A01'',                                    '+
         '            IMG01,                                      '+
         '            ''%s'',                                     '+
         '            ''4.在途'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''A01''             '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds3Eta]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''非保'',                                                      '+
         '       ''01'',                                                        '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.在外'',                               '+
         '       PMN01||''-''||PMN02,                      '+
         '       SUM(PMN20-PMN50+PMN55)                    '+
         '  FROM DS2::PMM_FILE,DS2::PMN_FILE ,TempPart     '+
         ' WHERE pmm01 = PMN01 AND  PMN04=PARTNO           '+
         '   AND PMM18!=''X''  AND STKNO=''01''            '+
         '   AND PMN20 > (PMN50+PMN55) AND PMN16<=''2''     '+
         '    GROUP BY 1,2,3,4,5,6';

   ExecSQLA(lSql);

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''保稅'',                                                      '+
         '       ''A01'',                                                       '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.在外'',                               '+
         '       PMN01||''-''||PMN02,                      '+
         '       SUM(PMN20-PMN50+PMN55)                    '+
         '  FROM DS3::PMM_FILE,DS3::PMN_FILE ,TempPart     '+
         ' WHERE pmm01 = PMN01 AND  PMN04=PARTNO           '+
         '   AND PMM01[1,3]!=''PTS''  AND STKNO=''A01''    '+
         '   AND PMM18!=''X''                              '+
         '   AND PMN20 > (PMN50+PMN55) AND PMN16<=''2''     '+
         '    GROUP BY 1,2,3,4,5,6';

   ExecSQLA(lSql);


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
            '     SELECT ''非保'',                                              '+
            '            ''01'',                                                '+
            '            RVB05  ,                                               '+
            '            RVA06+7  ,                                             '+
            '            ''3.待驗'',                                            '+
            '            RVB01||''-''||RVB02  ,                                               '+
            '            SUM((RVB07-RVB29-RVB30)*PMN09)                         '+
            '        FROM DS2::RVB_FILE , DS2::RVA_FILE, DS2::PMN_FILE,TempPart '+
            '       WHERE RVB01=RVA01  AND RVB05=PARTNO                         '+
            '         AND RVB04 = PMN01  AND STKNO=''01''                       '+
            '         AND RVB03 = PMN02                                         '+
            '         AND RVB07 > (RVB29+RVB30)                                 '+            
            '         AND RVACONF!=''X''                                        '+
            '    GROUP BY 1,2,3,4,5,6';
   ExecSQLA(lSql);


   lSql:= ' SELECT A.PLANT ,       '+
          '       A.STKNO ,        '+
          '       A.PARTNO ,       '+
          '       A.SDDATE ,       '+
          '       A.SDTYPE ,       '+
          '       A.SDINFO ,       '+
          '       A.SDQTY ,        '+
          '       (SELECT SUM(B.SDQTY)      '+
          '          FROM TempMATSD B       '+
          '         WHERE A.PARTNO=B.PARTNO '+
          '           AND A.PLANT=B.PLANT   '+
          '           AND (A.SDDATE||A.SDINFO[4,18]) >= (B.SDDATE||B.SDINFO[4,18])) AS SDBAL'+
          '    FROM TempMATSD A '+
          ' ORDER BY A.PLANT,A.PARTNO,A.SDDATE,A.SDINFO[4,18] INTO TEMP TempMATSDEX';
    ExecSqla(lSql);



  
  //匯總報表
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
    Screen.Cursor:=crSQLWait;
    if frmSysQryResultEx.Query.Active then frmSysQryResultEx.Query.Close;
    frmSysQryResultEx.Query.SQL.Clear;

    lSql:='SELECT A.PLANT AS 內外,                                                                                              '+
          '       A.STKNO AS 庫別,                                                                                              '+
          '       A.SDTYPE AS 類別,                                                                                             '+
          '       A.SDDATE AS 供需日期,                                                                                         '+
          '      CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'')  THEN             '+
          '        (CASE  WHEN MONTH(A.SDDATE)< MONTH(TODAY) AND A.SDBAL<0 THEN ''******''                                      '+
          '             WHEN MONTH(A.SDDATE)= MONTH(TODAY) AND A.SDDATE<= TODAY AND A.SDBAL<0 THEN ''*****''                    '+
          '             WHEN MONTH(A.SDDATE)= MONTH(TODAY) AND A.SDDATE BETWEEN TODAY+1 AND TODAY+7  AND A.SDBAL<0 THEN ''****'''+
          '             WHEN MONTH(A.SDDATE)= MONTH(TODAY) AND A.SDDATE BETWEEN TODAY+8 AND TODAY+15 AND A.SDBAL<0 THEN ''***'' '+
          '             WHEN A.SDDATE > TODAY+16 AND A.SDBAL<0 THEN ''**'' END)                                                 '+
          '       ELSE                                                                                                          '+
          '        (CASE WHEN A.SDINFO[1,2] IN (''RC'',''PO'',''PT'') THEN                                                               '+
          '             (CASE WHEN (A.SDBAL-A.SDQTY)<0 THEN ''*****''  END)                                                     '+
          '         END)                                                                                                        '+
          '       END AS 急,                                                                                                    '+
          '       A.PARTNO AS 料號,                                                                                             '+
          '       (SELECT COUNT(B.PARTNO) FROM TempMATSDEX B WHERE B.PLANT=A.PLANT AND B.STKNO=A.STKNO AND B.PARTNO=A.PARTNO AND'+
          '                                                  B.SDDATE||B.SDINFO[4,10]<=A.SDDATE||A.SDINFO[4,10]) AS 項次,       '+
          '       CASE WHEN A.SDQTY>=0 THEN ''供'' ELSE ''需'' END AS 供需,                                                     '+
          '       A.SDQTY AS 數量,                                                                                              '+
          '       A.SDBAL AS 結存,                                                                                              '+
          '       A.SDINFO AS 參考,                                                                                             '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '         A.SDINFO[5,8] END AS 母工單,                                                                                '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '            CASE WHEN A.SDINFO[7,7] IN(''0'',''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'') THEN             '+
          '              (SELECT SFB05 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8])                '+
          '            ELSE (SELECT SFB05 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8])             '+
          '            END                                                                                                      '+
          '       END AS 機種,                                                                                                  '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT PMC03 FROM DS2::PMM_FILE,DS2::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '            (SELECT PMC03 FROM DS3::PMM_FILE,DS3::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10])               '+
          '        END) AS 廠商,                                                                                                '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT GEN02 FROM DS2::PMM_FILE,DS2::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '           (SELECT GEN02 FROM DS3::PMM_FILE,DS3::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10])                '+
          '        END ) AS 採購                                                                                                '+
          '  FROM TempMATSDEX A                                                                                                 '+
          ' ORDER BY A.PLANT,A.STKNO,A.PARTNO,A.SDDATE||A.SDINFO[4,10] ';

    frmSysQryResultEx.Query.Sql.Add(lSql);
    try
      frmSysQryResultEx.Query.Open;
    except
      on e:EDBEngineError do
      ErrMessage(e.Errors[1].NativeError);
    end;

    Screen.Cursor:=crDefault;

    if frmSysQryResultEx.Query.RecordCount>0 then begin
      frmSysQryResultEx.Caption:=Format('asft110 - %S 工單材料供需查詢',[WorkOrderNo]);
      frmSysQryResultEx.ShowModal;
    end;{ else begin
      Application.MessageBox(Pchar((Format('%s,%S 供料正常！',[Username,WorkOrderNo]))),'提示',MB_ICONINFORMATION+MB_OK);
    end; }

  finally
    Screen.Cursor:=crDefault;
    try
     ExecSqlA('DROP TABLE TempMATSD');
     ExecSqlA('DROP TABLE TempMATSDEX');
     ExecSqlA('DROP TABLE TempPart');
     ExecSqlA('DROP TABLE TempWoPart');
     ExecSqlA('DROP TABLE TempWoDate');
    except
      on e:EDBEngineError do
      ErrMessage(e.Errors[1].NativeError);
    end;

    frmSysQryResultEx.Free;
  end;

end;

procedure GetAsfShortQrt_asft110(StartDate,endDate:String);
var
  lSQL:String;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do begin
    if Active then Close;
    SQL.Clear;

    lSql:=  ' SELECT SFA03 AS 材料料號, '+
            '        SFB25 AS 上線日,          '+
            '        SFA01 AS 工單,      '+
            '        IMA02 AS 品名描述,      '+
            '        SFA30 AS 庫別,          '+
            '        SFA05 AS 工單數量,                                                                '+
            '        SFA06 AS 發料數量,                                                                '+
            '        SFA05-SFA06 AS 未發數量,                                                          '+
            '        (SELECT SUM(IMG10) FROM DS2::IMG_FILE WHERE IMG01=SFA03 AND IMG02=SFA30) AS 庫存數量,  '+
            '(SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                                                '+
            '   FROM DS2::RVB_FILE,DS2::RVA_FILE, DS2::PMN_FILE                                    '+
            '  WHERE RVB01 =RVA01                                                                  '+
            '    AND RVB05 = SFA03                                                                 '+
            '    AND RVB04 = PMN01                                                                 '+
            '    AND RVB03 = PMN02                                                                 '+
            '    AND RVB07 > (RVB29+RVB30)                                                         '+
            '    AND RVACONF!=''X'') AS 待檢數量                                                   '+
            ' FROM DS2::SFB_FILE,DS2::SFA_FILE,DS2::IMA_FILE                                       '+
            'WHERE SFB01=SFA01                                                                     '+
            '  AND SFA03=IMA01                                                                     '+
            '  AND IMA08=''P''                                                                     '+
            '  AND SFB04 <=''7''  '+
            '  AND (CASE WHEN SFA01[1,3]=''WOD'' THEN SFB25         '+
            '              WHEN SFA01[1,3]=''ASY'' THEN SFB25-7       '+
            '              WHEN SFA01[1,3]=''PCB'' THEN SFB25-12      '+
            '              WHEN SFA01[1,3]=''AIV'' THEN SFB25-14      '+
            '              WHEN SFA01[1,3]=''AIH'' THEN SFB25-16      '+
            '              WHEN SFA01[1,3]=''SMD'' THEN SFB25-20      '+
            '              WHEN SFA01[1,3]=''SKD'' THEN SFB25         '+
            '              WHEN SFA01[1,3]=''RWK'' THEN SFB25 END )  BETWEEN ''%S'' AND ''%S''     '+
            '  AND (SFA05-SFA06)!=0                                                                '+

            ' UNION ALL                                                                            '+

            ' SELECT SFA03 AS 材料料號, '+
            '        SFB25 AS 上線日,          '+
            '        SFA01 AS 工單,      '+
            '        IMA02 AS 品名描述,                                                            '+
            '        SFA30 AS 庫別,          '+
            '        SFA05 AS 工單數量,                                                                    '+
            '        SFA06 AS 發料數量,                                                                    '+
            '        SFA05-SFA06 AS 未發數量,                                                              '+
            // 假如工單庫別是A02 就取01倉庫存，若是A01 取A01倉庫存，其它取01倉得庫存
            '        CASE WHEN SFA30=''A02'' THEN (SELECT SUM(IMG10) FROM DS2::IMG_FILE WHERE IMG01=SFA03 AND IMG02=''01'')  '+
            '             WHEN SFA30=''A01'' THEN (SELECT SUM(IMG10) FROM DS3::IMG_FILE WHERE IMG01=SFA03 AND IMG02=SFA30)   '+
            '             ELSE  (SELECT SUM(IMG10) FROM DS2::IMG_FILE WHERE IMG01=SFA03 AND IMG02=''01'') END  AS 庫存數量, '+
            '        (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                                                '+
            '           FROM DS2::RVB_FILE,DS2::RVA_FILE, DS2::PMN_FILE                                    '+
            '          WHERE RVB01 =RVA01                                                                  '+
            '            AND RVB05 = SFA03                                                                 '+
            '            AND RVB04 = PMN01                                                                 '+
            '            AND RVB03 = PMN02                                                                 '+
            '            AND RVB07 > (RVB29+RVB30)                                                         '+
            '            AND RVACONF!=''X'') AS 待檢數量                                                   '+
            '   FROM DS3::SFB_FILE,DS3::SFA_FILE,DS3::IMA_FILE                                             '+
            '  WHERE SFB01=SFA01                                                                           '+
            '    AND SFA03=IMA01                                                                           '+
            '    AND IMA08=''P''                                                                           '+
            '    AND SFB04 <=''7''  '+
            '    AND (CASE WHEN SFA01[1,3]=''WOD'' THEN SFB25         '+
            '              WHEN SFA01[1,3]=''ASY'' THEN SFB25-7       '+
            '              WHEN SFA01[1,3]=''PCB'' THEN SFB25-12      '+
            '              WHEN SFA01[1,3]=''AIV'' THEN SFB25-14      '+
            '              WHEN SFA01[1,3]=''AIH'' THEN SFB25-16      '+
            '              WHEN SFA01[1,3]=''SMD'' THEN SFB25-20      '+
            '              WHEN SFA01[1,3]=''SKD'' THEN SFB25         '+
            '              WHEN SFA01[1,3]=''RWK'' THEN SFB25 END )  BETWEEN ''%S'' AND ''%S''           '+
            '    AND (SFA05-SFA06)!=0                                                                      '+
            ' ORDER BY SFA03,SFB25,SFA01';
    SQL.Add(Format(lSql,[StartDate,endDate,StartDate,endDate]));
    Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='asft110 - 工單上線缺料查詢';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;


procedure GetAsfWoIss_Asfr104a(strItem,strSBegin,strSEnd,strMBegin,strMEnd:String);
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
            ' SELECT CCC01 AS 材料料號,    '+
            '        CAST(CCC02||(CASE WHEN CCC03<10 THEN ''0''||CAST(CCC03 AS CHAR(1)) ELSE CAST(CCC03 AS CHAR(2)) END) AS CHAR(6)) AS 發料年月, '+
            '        CCC31 AS 發料數量 '+
            '   FROM CCC_FILE          '+
            '  WHERE CCC01[1,2] IN(''%S) '+
            '    AND CCC31!=0          '+
            '    AND CCC02 BETWEEN ''%S'' AND ''%S'''+
            '    AND CCC03 BETWEEN ''%S'' AND ''%S''',[strItem,strSBegin,strSEnd,strMBegin,strMEnd]));
   Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='Asfr104a - 工單領發材料查詢(By Item)';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;

end;


procedure GetAsfWoIss_Asfr104(WoType,IsType,StartDate,EndDate:String);
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
            '   SELECT SFE01 工單編號,SFE02 單據編號,SFE04 異動日期,SFE07 料件編號, '+
            '          SFE16 異動數量,SFE09 儲位,PMM09 供應廠商,ROUND(IMA91,4) 平均單價      '+
            '     FROM SFE_FILE LEFT OUTER JOIN PMM_FILE ON SFE01=PMM01             '+
            '                        INNER JOIN IMA_FILE ON SFE07=IMA01             '+
            '    WHERE SFE06=''%S''                                                 '+
            '      AND SFE01[1,3]=''%S''                                            '+
            '      AND SFE04 BETWEEN ''%S'' AND ''%S''',[IsType,WoType,StartDate,EndDate]));
   Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='Asfr104 - 工單領發材料查詢';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;

end;

procedure GetWoMpsdate(WoYM:String);
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do
  begin
    if Active then
      Close;
    SQL.Clear;
    SQL.Add(Format('SELECT SFA01[1,3] AS 工單別 ,       '+
                   '       SFB01[5,6] AS 年月,          '+
                   '       SFB01[5,8] AS 母工單,        '+
                   '       SFA03 AS 料號,               '+
                   '       SFA05 AS 需求數,             '+
                   '       IMA531 AS 價格,              '+
                   '       SFA05*IMA531 AS 金額,        '+
                   '       IMA54 AS 供貨商,             '+
                   '       SFB25 AS 實際開工                                                       '+
                   '  FROM DS2::SFA_FILE,DS2::IMA_FILE,DS2::SFB_FILE                               '+
                   ' WHERE SFA03=IMA01  AND SFA01[5,6] =''%S''                                     '+
                   '   AND SFB04 BETWEEN ''0'' AND ''7''                                           '+
                   '   AND (SFB09-SFB08)!=0                                                        '+
                   '   AND (SFA05-SFA06)!=0                                                        '+
                   '   AND SFB01=SFA01                                                             '+
                   '   AND IMA54!=''XATWXGU0'' AND SFA01[1,3] IN (''ASY'',''WOD'',''RWK'')         '+
                   '                                                                               '+
               '  UNION ALL                                                                        '+
                   '                                                                                '+
                   'SELECT SFA01[1,3],                                                             '+
                   '       SFB01[5,6],                                                             '+
                   '       SFB01[5,8],                                                             '+
                   '       SFA03,                                                                  '+
                   '       SFA05,                                                                  '+
                   '       IMA531,                                                                 '+
                   '       SFA05*IMA531 ,                                                          '+
                   '       IMA54,                                                                  '+
                   '       SFB25 AS MRPDATE                                                        '+
                   '  FROM DS3::SFA_FILE,DS2::IMA_FILE,DS3::SFB_FILE                               '+
                   ' WHERE SFA03=IMA01 AND  SFA01[5,6] =''%S''                                     '+
                   '   AND SFB04 BETWEEN ''0'' AND ''7''                                           '+
                   '   AND (SFB09-SFB08)!=0                                                        '+
                   '   AND (SFA05-SFA06)!=0                                                        '+
                   '   AND SFB01=SFA01                                                             '+
                   '   AND IMA54!=''XATWXGU0'' AND SFA01[1,3] IN (''ASY'',''WOD'',''RWK'')',[WoYM,WoYM]));
   Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=Format('Asfr000 - ''%s''工單計劃與排程上線日查詢',[woym]);
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;

end;



procedure GetAsfWip_Asfr1061;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do
  begin
    if Active then
      Close;
    SQL.Clear;
    SQL.Add('SELECT ''DS2'' AS 廠別,                                  '+
            '        SFB01 AS 母工單號,                               '+
            '        SFB05 AS 產品品號,                               '+
            '        IMA02 AS 產品描述,                               '+
            '        SFB08 AS 生產數量,                               '+
            '        SFB09 AS 已經入庫,                               '+
            '           SFB08-SFB09 AS 在制數量,                      '+
            '           IMB111  AS 標準成本,                          '+
            '           IMB211 AS 現時材料,                           '+
            '           (SELECT MIN(CCJ01) FROM DS2::CCJ_FILE WHERE CCJ04[5,8]=SFB01[5,8] AND CCJ04[1,3]=''ASY'' ) AS 起始生產                            '+
            '      FROM DS2::SFB_FILE INNER JOIN DS2::IMA_FILE  ON  SFB05=IMA01   '+
            '                LEFT OUTER JOIN DS2::IMB_FILE ON  SFB05=IMB01        '+
            '     WHERE SFB04 BETWEEN ''1'' AND ''7''                 '+
            '       AND (SFB08-SFB09)>0                               '+
            '       AND SFB01[1,3] IN (''ASY'',''WOD'',''SKD'')       '+
            '  UNION ALL                                              '+
            ' SELECT ''DS2'' AS 廠別,                                 '+
            '        SFB01 AS 母工單號,                               '+
            '        SFB05 AS 產品品號,                               '+
            '        IMA02 AS 產品描述,                               '+
            '        SFB08 AS 生產數量,                               '+
            '        SFB09 AS 已經入庫,                               '+
            '           SFB08-SFB09 AS 在制數量,                      '+
            '           IMB111  AS 標準成本,                          '+
            '           IMB211 AS 現時材料,                           '+
            '           (SELECT MIN(CCJ01) FROM DS2::CCJ_FILE WHERE CCJ04[1,8]=SFB01[1,8]) AS 起始生產                            '+
            '      FROM DS2::SFB_FILE INNER JOIN DS2::IMA_FILE  ON  SFB05=IMA01   '+
            '                LEFT OUTER JOIN DS2::IMB_FILE ON  SFB05=IMB01        '+
            '     WHERE SFB04 BETWEEN ''1'' AND ''7''                 '+
            '       AND (SFB08-SFB09)>0                               '+
            '       AND SFB01[1,3] =''RWK''                           '+
            '                                                         '+
            '    UNION ALL                                            '+
            '                                                         '+
            '    SELECT ''DS3'' AS PLANT,                             '+
            '          SFB01 AS 母工單號,                             '+
            '           SFB05 AS 產品品號,                            '+
            '           IMA02 AS 產品描述,                            '+
            '          SFB08 AS 生產數量,                             '+
            '           SFB09 AS 已經入庫,                            '+
            '           SFB08-SFB09 AS 在制數量,                      '+
            '           IMB111  AS 標準成本,                          '+
            '           IMB211 AS 現時材料,                           '+
            '           (SELECT MIN(CCJ01) FROM DS3::CCJ_FILE WHERE CCJ04[1,8]=SFB01[1,8]  ) AS 起始生產                            '+
            '      FROM DS3::SFB_FILE INNER JOIN DS3::IMA_FILE  ON  SFB05=IMA01   '+
            '                LEFT OUTER JOIN DS3::IMB_FILE ON  SFB05=IMB01        '+
            '     WHERE SFB04 BETWEEN ''1'' AND ''7''                 '+
            '       AND (SFB08-SFB09)>0                               '+
            '       AND SFB01[1,3]=''RWK''                            '+
            '    UNION ALL                                            '+
            '    SELECT ''DS3'' AS PLANT,                             '+
            '          SFB01 AS 母工單號,                             '+
            '           SFB05 AS 產品品號,                            '+
            '           IMA02 AS 產品描述,                            '+
            '          SFB08 AS 生產數量,                             '+
            '           SFB09 AS 已經入庫,                            '+
            '           SFB08-SFB09 AS 在制數量,                      '+
            '           IMB111  AS 標準成本,                          '+
            '           IMB211 AS 現時材料,                           '+            
            '           (SELECT MIN(CCJ01) FROM DS3::CCJ_FILE WHERE CCJ04[5,8]=SFB01[5,8] AND CCJ04[1,3]=''ASY'') AS 起始生產                            '+
            '      FROM DS3::SFB_FILE INNER JOIN DS3::IMA_FILE  ON  SFB05=IMA01   '+
            '                LEFT OUTER JOIN DS3::IMB_FILE ON  SFB05=IMB01        '+
            '     WHERE SFB04 BETWEEN ''1'' AND ''7''                 '+
            '       AND (SFB08-SFB09)>0                               '+
            '       AND SFB01[1,3] IN (''ASY'',''WOD'',''SKD'')') ;
   Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='Asfr1061 - 未結工單明細查詢';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;

end;


procedure GetAsfWipa_Asfr1061(WorkOrder:String);
var
  lSql:String;
begin
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do
  begin
    if Active then
      Close;
    SQL.Clear;
    lSql:= ('SELECT ''DS2'' AS 內外銷,   '+
            '   SFB01 AS 母工單號,       '+
            '   SFB05 AS 產品品號,       '+
            '   IMA02 AS 產品描述,       '+
            '   SFB08 AS 生產數量,       '+
            '   SFB09 AS 已經入庫,       '+
            '   SFB08-SFB09 AS 在制數量, '+
            '   SFB15 AS 預入庫日,        '+
            ' CASE WHEN SFB15<TODAY THEN TODAY-SFB15 END AS 逾期'+
        '  FROM DS2::SFB_FILE,DS2::IMA_FILE               '+
        ' WHERE SFB05=IMA01                               '+
        '   AND SFB04 BETWEEN ''4'' AND ''7''             '+
        '   AND (SFB08-SFB09)>0  AND SFB01[5,6]<=''%S''   '+
        '   AND SFB01[1,3] IN (''RWK'',''WOD'')           '+
        '                                                 '+
        '  UNION ALL                                      '+
        '                                                 '+
        ' SELECT ''DS3'' AS PLANT,                        '+
        '        SFB01 AS 母工單號,                       '+
        '       SFB05 AS 產品品號,                        '+
        '       IMA02 AS 產品描述,                        '+
        '       SFB08 AS 生產數量,                        '+
        '       SFB09 AS 已經入庫,                        '+
        '       SFB08-SFB09 AS 在制數量,  '+
            '   SFB15 AS 預入庫日,        '+
            ' CASE WHEN SFB15<TODAY THEN TODAY-SFB15 END AS 逾期'+
        '  FROM DS3::SFB_FILE,DS3::IMA_FILE               '+
        ' WHERE SFB05=IMA01                               '+
        '   AND SFB04 BETWEEN ''4'' AND ''7''             '+
        '   AND (SFB08-SFB09)>0 AND SFB01[5,6]<=''%S''    '+
        '   AND SFB01[1,3] IN(''RWK'',''WOD'')') ;
        SQL.Add(Format(lSql,[WorkOrder,WorkOrder]));
        Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='Asfr1061 - 工單在制明細查詢';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;

end;


end.
