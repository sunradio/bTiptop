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
  strRemark:=UserName +','+ DateTostr(Date)+ ' �ɤJ';

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
          lsql:='SELECT PML01 AS ���ʳ渹,   '+
          '       PML02 AS ����,       '+
          '       PML04 AS �Ƹ�,       '+
          '       PML041 AS �~�W�W��,  '+
          '       PML41 AS �ӷ�,       '+
          '       PML07 AS ���,       '+
          '       PML18 AS MRP�ݨD��,  '+
          '       PML33 AS ��f��,     '+
          '       PML20 AS  ���ʶq,    '+
          '       PML21 AS �w��q��,   '+
          '       PML06 AS �Ƶ�        '+
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
      Application.MessageBox(Pchar((Format('%s , %S ���ʳ�樭�w����ơA�L�k�ɤJ�I',[Username,PrNumber]))),'����',MB_ICONINFORMATION+MB_OK);
   end;
  end else begin
     Application.MessageBox(Pchar((Format('%s , %S ���ʳ椣�s�b�A�Ш�TIPTOP�s�W�@���I',[Username,PrNumber]))),'����',MB_ICONINFORMATION+MB_OK);
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
    lsql:='  SELECT ''DS2'' AS �t�O,                            '+
          '         COUNT(RVB05) AS ����                        '+
          '    FROM DS2::RVA_FILE,DS2::RVB_FILE,DS2::PMM_FILE   '+
          '   WHERE RVA01=RVB01                                 '+
          '     AND RVACONF=''Y''                               '+
          '     AND RVA06 BETWEEN  ''%S'' AND ''%S''            '+
          '     AND RVB04=PMM01                                 '+
          '     AND RVA05=''XATWXGU0''                          '+
   
          '  UNION ALL                                          '+

          '  SELECT ''DS3'' AS �t�O,                            '+
          '         COUNT(RVB05) AS ����                        '+
          '    FROM DS3::RVA_FILE,DS3::RVB_FILE,DS3::PMM_FILE   '+
          '   WHERE RVA01=RVB01                                 '+
          '     AND RVACONF=''Y''                               '+
          '     AND RVA06 BETWEEN  ''%S'' AND ''%S''            '+
          '     AND RVB04=PMM01                                 '+
          '     AND RVA05=''XATWXGU0''';                         

    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s - %S �����q�x�W�i�Ƶ���',[Startdate,EndDate]);
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
    lsql:='SELECT CCC01 AS �Ƹ�,                            '+
          '       IMA02 AS �~�W�y�z,                        '+
          '       (SELECT A.IMA54                           '+
          '          FROM DS2::IMA_FILE A                   '+
          '         WHERE A.IMA01=CCC01 ) AS �t��,          '+
          '       ROUND(CCC23,3) AS DS3��ڦ���,            '+
          '       IMA531 AS �{�ʻ���,                       '+
          '       IMB111 AS �зǻ���,                       '+
          '       ROUND(CCC23-IMB111,3) AS �t��             '+
          ' FROM DS3::CCC_FILE,DS3::IMA_FILE,DS2::IMB_FILE  '+
          ' WHERE CCC02||CCC03=''%s''                       '+
          '   AND IMA01=CCC01                               '+
          '   AND IMA08=''P'' AND IMA103=''0''              '+
          '   AND LENGTH(CCC01)>=''13''                     '+
          '   AND IMB01=IMA01 AND (CCC23-IMB111)>0.25';

    SQL.Add(Format(lsql,[YearMonth]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s  DS3 �w�s�������b�e�ˬd���i((���-�з�)>0.25)',[YearMonth]);
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
          '       IMA01  AS �Ƹ�,                        '+
          '       IMA02  AS �y�z,                        '+
          '       IMB118 AS ����,                        '+
          '       IMA54  AS �t��,                        '+
          '       SUM(IMG10) AS �ƶq,                    '+
          '       ROUND(SUM(IMG10*IMB118),2) AS ���B     '+
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
    frmSysQryResultEx.Caption:=format('%s  �w�sTOP 100 ���i',[stkno]);
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
    lsql:='SELECT MSS01  AS ���ƮƸ�,                '+
          ' IMA02  AS �~�W�W��,                      '+
          ' IMB118 AS STDPRICE,                      '+
          ' IMA54  AS �����t��,                      '+
          ' SUM(MSS041) AS ���q�ƶq,                 '+
          ' SUM(MSS043) AS �p�����,                 '+
          ' SUM(MSS044) AS �u����,                 '+
          ' SUM(MSS051) AS �w�s�ƶq,                 '+
          ' SUM(MSS052) AS �b��ƶq,                 '+
          ' SUM(MSS053) AS ���N�ƶq,                 '+
          ' SUM(MSS061) AS ���ʼƶq,                 '+
          ' SUM(MSS062) AS �b�ļƶq,                 '+
          ' SUM(MSS063) AS �b�~�ƶq,                 '+
          ' SUM(MSS064) AS �b�s�ƶq,                 '+
          ' SUM(MSS065) AS �p�����q,                 '+
          ' SUM((MSS041+MSS043+MSS044+ima27)) AS �ݨD�ƶq, '+
          ' SUM((MSS051+MSS052+MSS053+MSS061+MSS062+MSS063+MSS064+MSS065)) AS  �ѳf�ƶq, '+
          ' SUM((MSS051+MSS052+MSS053+MSS061+MSS062+MSS063+MSS064+MSS065)-(MSS041+MSS043+MSS044+IMA27)) AS �ѻݮt��   '+
          '  FROM MSS_FILE A ,IMA_FILE B,IMB_fILE                        '+
          ' WHERE MSS_V =''%s''   --�o����JMRP��������                  '+
          ' AND A.MSS01=B.IMA01 AND IMA01=IMB01                          '+
          ' AND IMA08=''%s''     --�o����J�n�ݮƥ�O(M OR P)            '+
          ' AND LENGTH(MSS01)<=12                                        '+
          ' GROUP BY MSS01,IMA02,IMB118,IMA54       '+
          ' HAVING SUM((MSS051+MSS052+MSS053+MSS061+MSS062+MSS063+MSS064+MSS065)-(MSS041+MSS043+MSS044+IMA27))!=0';

    SQL.Add(Format(lsql,[mrpver,source]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s - %S NORoHS �Ʈw�s�H�ιw�p�w�s���i',[mrpver,source]);
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
    lsql:=' SELECT DISTINCT ''DS2'' AS ���~�P,SFE01 AS �o�Ƥu��         '+
          '   FROM DS2::SFE_FILE                      '+
          '  WHERE SFE04 BETWEEN ''%s'' AND ''%s''    '+
          '    AND SFE02[1,3]=''IM1''                 '+
          '    AND SFE01[1,3] IN(''ASY'',''PCB'')     '+
          ' UNION ALL                                 '+
          ' SELECT DISTINCT ''DS3'' AS ���~�P,SFE01 AS �o�Ƥu��         '+
          '   FROM DS3::SFE_FILE                      '+
          '  WHERE SFE04 BETWEEN ''%s'' AND ''%s''    '+
          '    AND SFE02[1,3]=''IMA''                 '+
          '    AND SFE01[1,3] IN(''ASY'',''PCB'')     ';

    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s - %S �u��o�Ƨ��',[Startdate,EndDate]);
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
    lsql:=' SELECT ''DS2 ���X(�U)'',ROUND(SUM(CCC42+CCC44)/10000,2) AS �����o��      '+
          '   FROM DS2::CCC_FILE,DS2::IMA_FILE                        '+
          '  WHERE CCC02||CCC03=''%s''                               '+
          '    AND IMA08=''P''                                          '+
          '    AND CCC01=IMA01                                        '+
          '    AND CCC32!=0                                           '+
          '    AND CCC01[1,2] >''09''       '+

          ' UNION ALL                                                '+

          ' SELECT ''DS3 ���X(�U)'',ROUND(SUM(CCC42+CCC44)/10000,2) AS �����o��      '+
          '   FROM DS3::CCC_FILE,DS3::IMA_FILE                        '+
          '  WHERE CCC02||CCC03=''%s''                               '+
          '    AND IMA08=''P''                                          '+
          '    AND CCC01=IMA01                                        '+
          '    AND CCC32!=0                                           '+
          '    AND CCC01[1,2]>''09'' ';

    SQL.Add(Format(lsql,[YearMonth,YearMonth]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s �������ƥX�w���B�]�뵲��ڡ^',[YearMonth]);
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
    lsql:=' SELECT ''DS2 ���B(�U)'',ROUND(SUM(CCC32)/10000,2) AS �u��o��      '+
          '   FROM DS2::CCC_FILE,DS2::IMA_FILE                        '+
          '  WHERE CCC02||CCC03=''%s''                               '+
          '    AND IMA08=''P''                                          '+
          '    AND CCC01=IMA01                                        '+
          '    AND CCC32!=0                                           '+
          '    AND CCC01[1,2] NOT IN (''12'',''HC'',''D1'',''D2'',''D8'')       '+

          ' UNION ALL                                                '+

          ' SELECT ''DS3 ���B(�U)'',ROUND(SUM(CCC32)/10000,2) AS �u��o��      '+
          '   FROM DS3::CCC_FILE,DS3::IMA_FILE                        '+
          '  WHERE CCC02||CCC03=''%s''                               '+
          '    AND IMA08=''P''                                          '+
          '    AND CCC01=IMA01                                        '+
          '    AND CCC32!=0                                           '+
          '    AND CCC01[1,2] NOT IN (''12'',''HC'',''D1'',''D2'',''D8'')';

    SQL.Add(Format(lsql,[YearMonth,YearMonth]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s ���ƥX�w���B�]�뵲��ڡ^',[YearMonth]);
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
    lsql:=' SELECT ''�X�ƨ�x�W'' AS ���e,ROUND(SUM(OGB14*OGA24 )/10000,2)   AS ���B  '+
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
    frmSysQryResultEx.Caption:=format('%s - %s ���ƥXGWT���B',[Startdate,EndDate]);
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
    lsql:=' SELECT ''DS2 ���B(�U)'' AS �o��,ROUND(SUM(SFE16*IMB111)/10000,2)  AS ���B              '+
          '   FROM DS2::SFE_FILE,DS2::IMB_FILE,DS2::IMA_FILE         '+
          '  WHERE SFE07=IMB01 AND IMA01=IMB01 AND IMA08=''P''         '+
          '    AND SFE08=''01'' AND SFE02[1,2]=''IM''                '+
          '    AND SFE04 BETWEEN ''%s'' AND ''%s''                  '+
          '    AND SFE07 NOT IN (''12'',''HC'',''D1'',''D2'',''D8'') '+
          ' UNION ALL                                                '+

          ' SELECT ''DS3 ���B(�U)'', ROUND(SUM(SFE16*IMB111)/10000,2)             '+
          '   FROM DS3::SFE_FILE,DS3::IMB_FILE,DS3::IMA_FILE         '+
          '  WHERE SFE07=IMB01 AND IMA01=IMB01 AND IMA08=''P''         '+
          '    AND SFE02[1,2]=''IM''                                 '+
          '    AND SFE04 BETWEEN ''%s'' AND ''%s''                  '+
          '    AND SFE07 NOT IN (''12'',''HC'',''D1'',''D2'',''D8'')';

    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate,Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:=format('%s - %s �ܮw���ƥX�w���B',[Startdate,EndDate]);
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
   lsql:=' SELECT ''DS2 �P��'' AS �t�O,                      '+
         '       OGB914 AS �Ȥ�,                             '+
         '       OGB04 AS ���~�~��,                          '+
         '       OGB12 AS �P��ƶq,                          '+
         '       OGB911 AS �Ƶ�,                             '+
         '       IMB118 AS �зǦ���                          '+
         '  FROM DS2::OGB_FILE,DS2::OGA_FILE,DS2::IMB_FILE   '+
         ' WHERE OGA01=OGB01                                 '+
         '   AND OGA02 BETWEEN ''%S'' AND ''%S''             '+
         '   AND OGACONF=''Y''                               '+
         '   AND OGAPOST=''Y''                               '+
         '   AND OGB04=IMB01                                 '+
         '   AND OGB01[1,3]!=''DO6''                         '+
         '   AND OGB04[1,2]=''01'' AND OGB04[12,12]=''R''    '+

         ' UNION ALL                                         '+

         ' SELECT ''DS7 �P��'' AS �t�O,                      '+
         '       OGB914 AS �Ȥ�,                             '+
         '       OGB04 AS ���~�~��,                          '+
         '       OGB12 AS �P��ƶq,                          '+
         '       OGB911 AS �Ƶ�,                             '+
         '       IMB118 AS �зǦ���                          '+
         '  FROM DS7::OGB_FILE,DS7::OGA_FILE,DS7::IMB_FILE   '+
         ' WHERE OGA01=OGB01                                 '+
         '   AND OGA02 BETWEEN ''%S'' AND ''%S''             '+
         '   AND OGACONF=''Y''                               '+
         '   AND OGAPOST=''Y''                               '+
         '   AND OGB04=IMB01                                 '+
         '   AND OGB01[1,3]!=''DO6''                         '+
         '   AND OGB04[1,2]=''01'' AND OGB04[12,12]=''R''    '+

         ' UNION ALL                                         '+

         ' SELECT ''DS3 �P��'' AS �t�O,                      '+
         '       CASE WHEN OGB914 IS NULL THEN ''GWT'' ELSE OGB914 END AS �Ȥ�,  '+
         '       OGB04 AS ���~�~��,                          '+
         '       OGB12 AS �P��ƶq,                          '+
         '       OGB911 AS �Ƶ�,                             '+
         '       IMB118 AS �зǦ���                          '+
         '  FROM DS3::OGB_FILE,DS3::OGA_FILE,DS3::IMB_FILE   '+
         ' WHERE OGA01=OGB01                                 '+
         '   AND OGA02 BETWEEN ''%S'' AND ''%S''             '+
         '   AND OGACONF=''Y''                               '+
         '   AND OGAPOST=''Y''                               '+
         '   AND OGB04=IMB01                                 '+

         ' UNION ALL                                         '+

         ' SELECT ''DS2 �@��T��'' AS �t�O,                  '+
         '       OGB914 AS �Ȥ�,                             '+
         '       OGB04 AS ���~�~��,                          '+
         '       OGB12 AS �P��ƶq,                          '+
         '       OGB911 AS �Ƶ�,                             '+
         '       IMB118 AS �зǦ���                          '+
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
    frmSysQryResultEx.Caption:=format('%S - %S �P�����',[Startdate,EndDate]);;
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
    lSql:=' SELECT ''DS2'' AS ���~�P,                                                             '+
          '        TLF01 AS ���ƮƸ�,                                                             '+
          '        TLF026 AS ��ڽs��,                                                            '+
          '        TLF026[5,6] AS ���,                                                           '+
          '        TLF036[5,8] AS ���u�渹,                                                       '+
          '        TLF036 AS �u�渹�X,                                                            '+
          '        (SELECT CASE WHEN SFB02=''1'' THEN ''�ۻs''                                    '+
          '                     WHEN SFB02=''7'' THEN ''�~�]'' END                                '+
          '            FROM DS2::SFB_FILE WHERE TLF036=SFB01) AS �~�],                             '+
          '         CASE WHEN TLF907=1 THEN -TLF10                                                '+
          '              WHEN TLF907=-1 THEN TLF10                                                '+
          '              WHEN TLF907=0 THEN TLF10 END AS �ƶq,                                    '+
          '        (SELECT IMA531 FROM DS2::IMA_FILE WHERE IMA01=TLF01) AS ���,                  '+
          '        TLF07 AS ���ͤ��,                                                             '+
          '        CASE WHEN TLF907=1 THEN - (TLF221+TLF222+TLF2231+TLF2232+TLF224)               '+
          '             WHEN TLF907=-1 THEN  (TLF221+TLF222+TLF2231+TLF2232+TLF224)               '+
          '             WHEN TLF907=0 THEN  (TLF221+TLF222+TLF2231+TLF2232+TLF224) END AS ���B    '+
          '   FROM DS2::TLF_FILE                                                                  '+
          '  WHERE TLF13 IN(''asfi512'',''asfi527'')                                              '+
          '    AND TLF07 BETWEEN ''%S'' AND ''%S'' AND TLF17=''MO3''                              '+

          ' UNION ALL                                                                             '+

          ' SELECT ''DS3'' AS ���~�P,                                                             '+
          '        TLF01 AS ���ƮƸ�,                                                             '+
          '        TLF026 AS ��ڽs��,                                                            '+
          '        TLF026[5,6] AS ���,                                                           '+
          '        TLF036[5,8] AS ���u�渹,                                                       '+
          '        TLF036 AS �u�渹�X,                                                            '+
          '        (SELECT CASE WHEN SFB02=''1'' THEN ''�ۻs''                                    '+
          '                     WHEN SFB02=''7'' THEN ''�~�]'' END                                '+
          '            FROM DS3::SFB_FILE WHERE TLF036=SFB01) AS �~�],                            '+
          '         CASE WHEN TLF907=1 THEN -TLF10                                                '+
          '              WHEN TLF907=-1 THEN TLF10                                                '+
          '              WHEN TLF907=0 THEN TLF10 END AS �ƶq,                                    '+
          '        (SELECT IMA531 FROM DS3::IMA_FILE WHERE IMA01=TLF01) AS ���,                  '+
          '        TLF07 AS ���ͤ��,                                                             '+
          '        CASE WHEN TLF907=1 THEN - (TLF221+TLF222+TLF2231+TLF2232+TLF224)               '+
          '             WHEN TLF907=-1 THEN  (TLF221+TLF222+TLF2231+TLF2232+TLF224)               '+
          '             WHEN TLF907=0 THEN  (TLF221+TLF222+TLF2231+TLF2232+TLF224) END AS ���B    '+
          '   FROM DS3::TLF_FILE                                                                  '+
          '  WHERE TLF13 IN(''asfi512'',''asfi527'')                                              '+
          '    AND TLF07 BETWEEN ''%S'' AND ''%S'' AND TLF17=''MO3''                              ';

    SQL.Add(Format(lsql,[Startdate,EndDate,Startdate,EndDate]));
    Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='�~�]�u��W��Ʃ���';
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
          '       INA04 AS ����,                           '+
          '       INB04 AS �Ƹ�,                           '+
          '       INB09 AS �ƶq,                           '+
          '       IMA02 AS ���ƴy�z,                       '+
          '       IMA531 AS ���,                          '+
          '       INB15 AS ��],                           '+
          '       (SELECT AZF03                            '+
          '          FROM DS2::AZF_FILE                    '+
          '         WHERE AZF02=''2''                      '+
          '           AND AZF01=INB15) AS ��]�y�z         '+
          '  FROM DS2::INA_FILE,DS2::INB_FILE,DS2::IMA_FILE'+
          ' WHERE INA01=INB01 AND IMA01=INB04              '+
          '   AND  INA02 BETWEEN ''%S'' AND ''%S''         '+
          '   AND INB15=''MO3''                             ';


    SQL.Add(Format(lsql,[Startdate,EndDate]));
    Open;
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='�~�]������Ʃ���';
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
   //�Ыؤ@���{�ɪ�
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
         '     SELECT ''�O�|'',  '+
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
         '        ''0.�u��'',                             '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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


     //A01 �ݭn���ɤJ�O�|�t�Ϊ��ݨD��K�έpA02
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
         '     SELECT ''�D�O'',  '+
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
         '        ''0.�u��'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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
         '     SELECT ''�D�O'',                                      '+
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
         '        ''0.�u��'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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
         '     SELECT ''�D�O'',                                                 '+
         '            ''01'',                                                   '+
         '            SFA03,                                                    '+
         '            B.SFB25,                                                  '+
         '            ''0.����'',                                               '+
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
         '  SELECT ''�D�O'',''01'',OEB04,OEB15,''1.���q'',OEA01,-SUM((OEB12-OEB24)*OEB05_FAC) '+
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

   //�T�{�n������Ƹ�
   lSql:='INSERT INTO TempPart(PARTNO,STKNO) '+
         ' SELECT DISTINCT PARTNO,STKNO  '+
         '   FROM TempMATSD';

   ExecSQLA(lSql);


   // 01 OH
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�D�O'',                                   '+
         '            ''01'',                                     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.�w�s'',                                   '+
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
         '     SELECT ''�O�|'',                                                 '+
         '            CASE WHEN IMG02=''B01'' THEN ''A01'' ELSE IMG02 END ,     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.�w�s'',                                   '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''A01''             '+
         '        AND IMG02 IN(''A01'',''B01'')                   '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5 ,6                                ';

   ExecSQLA(lSql);

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�D�O'',                                    '+
         '            ''01'',                                      '+
         '            IMG01,                                       '+
         '            ''%s'',                                      '+
         '            ''4.�b�~'',                                    '+
         '            (SELECT TRIM(IMD02) FROM DS2::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS2::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO   AND STKNO=''01''             '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds2Eta]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�O�|'',                                   '+
         '            ''A01'',                                    '+
         '            IMG01,                                      '+
         '            ''%s'',                                     '+
         '            ''4.�b�~'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''A01''             '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds3Eta]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''�D�O'',                                                      '+
         '       ''01'',                                                        '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.�b�~'',                               '+
         '       PMN01||''-''||PMN02,                      '+
         '       SUM(PMN20-PMN50+PMN55)                    '+
         '  FROM DS2::PMM_FILE,DS2::PMN_FILE ,TempPart     '+
         ' WHERE pmm01 = PMN01 AND  PMN04=PARTNO           '+
         '   AND PMM18!=''X''  AND STKNO=''01''            '+
         '   AND PMN20 > (PMN50+PMN55) AND PMN16<=''2''     '+
         '    GROUP BY 1,2,3,4,5,6';

   ExecSQLA(lSql);

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''�O�|'',                                                      '+
         '       ''A01'',                                                       '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.�b�~'',                               '+
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
            '     SELECT ''�D�O'',                                              '+
            '            ''01'',                                                '+
            '            RVB05  ,                                               '+
            '            RVA06+7  ,                                             '+
            '            ''3.����'',                                            '+
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



 //���`����
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
    Screen.Cursor:=crSQLWait;
    if frmSysQryResultEx.Query.Active then frmSysQryResultEx.Query.Close;
    frmSysQryResultEx.Query.SQL.Clear;

    lSql:='SELECT A.PLANT AS �t�O,                                                                                              '+
          '       A.STKNO AS �w�O,                                                                                              '+
          '       A.SDTYPE AS ���O,                                                                                             '+
          '       A.SDDATE AS �ѻݤ��,                                                                                         '+
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
          '       END AS ��,                                                                                                    '+
          '       A.PARTNO AS �Ƹ�,                                                                                             '+
          '       (SELECT COUNT(B.PARTNO) FROM TempMATSDEX B WHERE B.PLANT=A.PLANT AND B.STKNO=A.STKNO AND B.PARTNO=A.PARTNO AND'+
          '                                                  B.SDDATE||B.SDINFO[4,10]<=A.SDDATE||A.SDINFO[4,10]) AS ����,       '+
          '       CASE WHEN A.SDQTY>=0 THEN ''��'' ELSE ''��'' END AS �ѻ�,                                                     '+
          '       A.SDQTY AS �ƶq,                                                                                              '+
          '       A.SDBAL AS ���s,                                                                                              '+
          '       A.SDINFO AS �Ѧ�,                                                                                             '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '         A.SDINFO[5,8] END AS ���u��,                                                                                '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '            CASE WHEN A.SDINFO[7,7] IN(''0'',''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'') THEN             '+
          '              (SELECT SFB05 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8])                '+
          '            ELSE (SELECT SFB05 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8])             '+
          '            END                                                                                                      '+
          '       END AS ����,                                                                                                  '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT PMC03 FROM DS2::PMM_FILE,DS2::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '            (SELECT PMC03 FROM DS3::PMM_FILE,DS3::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10])               '+
          '        END) AS �t��,                                                                                                '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT GEN02 FROM DS2::PMM_FILE,DS2::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '           (SELECT GEN02 FROM DS3::PMM_FILE,DS3::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10])                '+
          '        END ) AS ����                                                                                                '+
          '  FROM TempMATSDEX A                                                                                                 '+
          ' ORDER BY A.PLANT,A.STKNO,A.PARTNO,A.SDDATE||A.SDINFO[4,10] ';

    frmSysQryResultEx.Query.Sql.Add(lSql);
    frmSysQryResultEx.Query.Open;

    Screen.Cursor:=crDefault;

    if frmSysQryResultEx.Query.RecordCount>0 then begin
      frmSysQryResultEx.Caption:=Format('%S-%S �����u����ƨѻݬd��',[StartDate,endDate]);
      frmSysQryResultEx.ShowModal;
    end else begin
      Application.MessageBox(Pchar((Format('%s , %S - %s �����Ѯƥ��`�I',[Username,StartDate,endDate]))),'����',MB_ICONINFORMATION+MB_OK);
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
   //�Ыؤ@���{�ɪ�
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
         '     SELECT ''�O�|'',  '+
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
         '        ''0.�u��'',                             '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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
         '     SELECT ''�D�O'',  '+
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
         '        ''0.�u��'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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
         '     SELECT ''�D�O'',                                      '+
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
         '        ''0.�u��'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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
         '     SELECT ''�D�O'',                                                 '+
         '            ''01'',                                                   '+
         '            SFA03,                                                    '+
         '            B.SFB25,                                                  '+
         '            ''0.����'',                                               '+
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
         '  SELECT ''�D�O'',''01'',OEB04,OEB15,''1.���q'',OEA01,-SUM((OEB12-OEB24)*OEB05_FAC) '+
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
         ' SELECT ''�D�O'',''01'',PML04,PML33,''6.����'',PML01||''-''||PML02,SUM(PML20-PML21)'+
         '   FROM DS2::PMK_FILE,DS2::PML_FILE                                                '+
         '  WHERE PMK01=PML01  AND PML04=''%S''                                              '+
         '    AND PML16 BETWEEN 0 AND 1   GROUP BY 1,2,3,4,5,6';
      ExecSQLA(Format(lSql,[Partno]));

   //DS2 PR
   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)               '+
         ' SELECT ''�O�|'',''01'',PML04,PML33,''6.����'',PML01||''-''||PML02,SUM(PML20-PML21)'+
         '   FROM DS3::PMK_FILE,DS3::PML_FILE                                                '+
         '  WHERE PMK01=PML01  AND PML04=''%S''                                              '+
         '    AND PML16 BETWEEN 0 AND 1  GROUP BY 1,2,3,4,5,6';
      ExecSQLA(Format(lSql,[Partno]));

   // 01 OH
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�D�O'',                                   '+
         '            ''01'',                                     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.�w�s'',                                 '+
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
         '     SELECT ''�O�|'',                                                 '+
         '            CASE WHEN IMG02=''B01'' THEN ''A01'' ELSE IMG02 END ,     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.�w�s'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE                               '+
         '      WHERE IMG01=''%s''                                '+
         '        AND IMG02 IN(''A01'',''B01'')                   '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5 ,6                                ';
   ExecSQLA(Format(lSql,[Partno]));

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�D�O'',                                    '+
         '            ''01'',                                      '+
         '            IMG01,                                       '+
         '            ''%s'',                                      '+
         '            ''4.�b�~'',                                  '+
         '            (SELECT TRIM(IMD02) FROM DS2::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS2::IMG_FILE                               '+
         '      WHERE IMG01=''%s''                                '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds3Eta,Partno]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�O�|'',                                   '+
         '            ''A01'',                                    '+
         '            IMG01,                                      '+
         '            ''%s'',                                     '+
         '            ''4.�b�~'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE                               '+
         '      WHERE IMG01=''%S''                                '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds3Eta,Partno]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''�D�O'',                                                      '+
         '       ''01'',                                                        '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.�b�~'',                               '+
         '       PMN01||''-''||PMN02,                      '+
         '       SUM(PMN20-PMN50+PMN55)                    '+
         '  FROM DS2::PMM_FILE,DS2::PMN_FILE               '+
         ' WHERE pmm01 = PMN01 AND  PMN04=''%S''           '+
         '   AND PMM18!=''X''                              '+
         '   AND PMN20 > (PMN50+PMN55) AND PMN16<=''2''     '+
         '    GROUP BY 1,2,3,4,5,6';
   ExecSQLA(Format(lSql,[Partno]));

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''�O�|'',                                                      '+
         '       ''A01'',                                                       '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.�b�~'',                               '+
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
            '     SELECT ''�D�O'',                                              '+
            '            ''01'',                                                '+
            '            RVB05  ,                                               '+
            '            RVA06+7  ,                                             '+
            '            ''3.����'',                                            '+
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



 //���`����
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
    Screen.Cursor:=crSQLWait;
    if frmSysQryResultEx.Query.Active then frmSysQryResultEx.Query.Close;
    frmSysQryResultEx.Query.SQL.Clear;

    lSql:='SELECT A.PLANT AS ���~,                                                                                              '+
          '       A.STKNO AS �w�O,                                                                                              '+
          '       A.SDTYPE AS ���O,                                                                                             '+
          '       A.SDDATE AS �ѻݤ��,                                                                                         '+
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
          '       END AS ��,                                                                                                    '+
          '       A.PARTNO AS �Ƹ�,                                                                                             '+
          '       (SELECT COUNT(B.PARTNO) FROM TempMATSDEX B WHERE B.PLANT=A.PLANT AND B.STKNO=A.STKNO AND B.PARTNO=A.PARTNO AND'+
          '                                                  B.SDDATE||B.SDINFO[4,10]<=A.SDDATE||A.SDINFO[4,10]) AS ����,       '+
          '       CASE WHEN A.SDQTY>=0 THEN ''��'' ELSE ''��'' END AS �ѻ�,                                                     '+
          '       A.SDQTY AS �ƶq,                                                                                              '+
          '       A.SDBAL AS ���s,                                                                                              '+
          '       A.SDINFO AS �Ѧ�,                                                                                              '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '         A.SDINFO[5,8] END AS ���u��,                                                                                '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '            CASE WHEN A.SDINFO[7,7] IN(''0'',''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'') THEN             '+
          '              (SELECT SFB05 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8] AND SFB05[1,2]=''01'')                '+
          '            ELSE (SELECT SFB05 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8] AND SFB05[1,2]=''01'')             '+
          '            END                                                                                                      '+
          '       END AS ����,                                                                                                  '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT PMC03 FROM DS2::PMM_FILE,DS2::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '            (SELECT PMC03 FROM DS3::PMM_FILE,DS3::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10])               '+
          '        END) AS �t��,                                                                                                '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT GEN02 FROM DS2::PMM_FILE,DS2::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '           (SELECT GEN02 FROM DS3::PMM_FILE,DS3::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10])                '+
          '        END ) AS ����                                                                                                '+
          '  FROM TempMATSDEX A                                                                                                 '+
          ' ORDER BY A.PLANT,A.STKNO,A.PARTNO,A.SDDATE||A.SDINFO[4,10] ';

    frmSysQryResultEx.Query.Sql.Add(lSql);
    frmSysQryResultEx.Query.Open;

    Screen.Cursor:=crDefault;

    if frmSysQryResultEx.Query.RecordCount>0 then begin
      frmSysQryResultEx.Caption:=Format('%S-%S-%S ���ƨѻݬd��',[StartDate,endDate,Partno]);
      frmSysQryResultEx.ShowModal;
    end else begin
      Application.MessageBox(Pchar((Format('%s , %S - %s �����L %S �ѮƫH���I',[Username,StartDate,endDate,Partno]))),'����',MB_ICONINFORMATION+MB_OK);
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
   //�Ыؤ@���{�ɪ�
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
         ExecSQLA('UPDATE TempWoDate SET SFB25=TODAY WHERE  SFB01[1,3]=''PTM''');   //PTM �u����ƻݨD�קאּ���

         if not Sel then begin
           woDate:=GetRecordValue(Format('SELECT SFB25 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=''%S''',[WorkOrderNo]));
         end else begin
           woDate:=NewStartDate;
           lSql:='UPDATE TempWoDate SET SFB25=''%S'' WHERE SFB01[5,8]=''%S''';
           ExecSQLA(Format(lSql,[woDate,WorkOrderNo]));
         end;
         
   // WO DATA DS3 A02
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�D�O'',  '+
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
         '        ''0.�u��'',                                 '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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
         '     SELECT ''�D�O'',                                      '+
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
         '        ''0.�u��'',                                 '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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
         '     SELECT ''�D�O'',                                                 '+
         '            ''01'',                                                   '+
         '            SFA03,                                                    '+
         '            B.SFB25,                                                  '+
         '            ''0.����'',                                               '+
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
         '  SELECT ''�D�O'',''01'',OEB04,OEB15,''1.���q'',OEA01,-SUM((OEB12-OEB24)*OEB05_FAC) '+
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
      Application.MessageBox(Pchar((Format('%s,%S �u��L�ʮơI',[Username,WorkOrderNo]))),'����',MB_ICONINFORMATION+MB_OK);
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
         ExecSQLA('UPDATE TempWoDate SET SFB25=TODAY WHERE  SFB01[1,3]=''PTM''');   //PTM �u����ƻݨD�קאּ���

      if Not Sel then begin
         woDate:=GetRecordValue(Format('SELECT SFB25 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=''%S''',[WorkOrderNo]));
      end else begin
        woDate:=NewStartDate;
        lSql:='UPDATE TempWoDate SET SFB25=''%S'' WHERE SFB01[5,8]=''%S''';
        ExecSQLA(Format(lSql,[woDate,WorkOrderNo]));
      end;

   // WO DATA DS3 A01
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)                 '+
         '     SELECT ''�O�|'',                                                                 '+
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
         '        ''0.�u��'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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


     //A01 �ݭn���ɤJ�O�|�t�Ϊ��ݨD��K�έpA02
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
         '     SELECT ''�D�O'',  '+
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
         '        ''0.�u��'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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
         '     SELECT ''�D�O'',                                      '+
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
         '        ''0.�u��'',                               '+
         '        SFA01||''-''||CASE WHEN A.SFB04=''1'' THEN ''�}��'''+
         '                           WHEN A.SFB04=''2'' THEN ''���L'''+
         '                           WHEN A.SFB04=''3'' THEN ''�w�L'''+
         '                           WHEN A.SFB04=''4'' THEN ''�ݸ�'''+
         '                           WHEN A.SFB04=''5'' THEN ''�b�s'''+
         '                           WHEN A.SFB04=''6'' THEN ''����'''+
         '                           WHEN A.SFB04=''7'' THEN ''�J�w'''+
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
         '     SELECT ''�D�O'',                                                 '+
         '            ''01'',                                                   '+
         '            SFA03,                                                    '+
         '            B.SFB25,                                                  '+
         '            ''0.����'',                                               '+
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
         '  SELECT ''�D�O'',''01'',OEB04,OEB15,''1.���q'',OEA01,-SUM((OEB12-OEB24)*OEB05_FAC) '+
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
      Application.MessageBox(Pchar((Format('%s,%S �u��L�ʮơI',[Username,WorkOrderNo]))),'����',MB_ICONINFORMATION+MB_OK); 
    end;
   end;





   //�T�{�n������Ƹ�
   lSql:='INSERT INTO TempPart(PARTNO,STKNO) '+
         ' SELECT DISTINCT PARTNO,STKNO  '+
         '   FROM TempMATSD';

   ExecSQLA(lSql);


   // 01 OH
   lSql:='INSERT INTO TempMATSD(PLANT, STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�D�O'',                                   '+
         '            ''01'',                                     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.�w�s'',                                 '+
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
         '     SELECT ''�O�|'',                                                 '+
         '            CASE WHEN IMG02=''B01'' THEN ''A01'' ELSE IMG02 END ,     '+
         '            IMG01,                                      '+
         '            ''00/00/01'',                               '+
         '            ''2.�w�s'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''A01''             '+
         '        AND IMG02 IN(''A01'',''B01'')                   '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5 ,6                                ';

   ExecSQLA(lSql);

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�D�O'',                                    '+
         '            ''01'',                                      '+
         '            IMG01,                                       '+
         '            ''%s'',                                      '+
         '            ''4.�b�~'',                                  '+
         '            (SELECT TRIM(IMD02) FROM DS2::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS2::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO   AND STKNO=''01''             '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds2Eta]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         '     SELECT ''�O�|'',                                   '+
         '            ''A01'',                                    '+
         '            IMG01,                                      '+
         '            ''%s'',                                     '+
         '            ''4.�b�~'',                                 '+
         '            (SELECT TRIM(IMD02) FROM DS3::IMD_FILE WHERE IMG02=IMD01)||''-''||TRIM(IMG03),  '+
         '            SUM(IMG10)                                  '+
         '       FROM DS3::IMG_FILE,TempPart                      '+
         '      WHERE IMG01=PARTNO  AND STKNO=''A01''             '+
         '        AND IMG02=''BVI''                               '+
         '        AND IMG10!=0                                    '+
         '   GROUP BY 1,2,3,4,5,6                                 ';
   ExecSQLA(Format(lSql,[ds3Eta]));


   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''�D�O'',                                                      '+
         '       ''01'',                                                        '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.�b�~'',                               '+
         '       PMN01||''-''||PMN02,                      '+
         '       SUM(PMN20-PMN50+PMN55)                    '+
         '  FROM DS2::PMM_FILE,DS2::PMN_FILE ,TempPart     '+
         ' WHERE pmm01 = PMN01 AND  PMN04=PARTNO           '+
         '   AND PMM18!=''X''  AND STKNO=''01''            '+
         '   AND PMN20 > (PMN50+PMN55) AND PMN16<=''2''     '+
         '    GROUP BY 1,2,3,4,5,6';

   ExecSQLA(lSql);

   lSql:='INSERT INTO TempMATSD(PLANT,STKNO,PARTNO,SDDATE,SDTYPE,SDINFO,SDQTY)  '+
         'SELECT ''�O�|'',                                                      '+
         '       ''A01'',                                                       '+
         '       PMN04,                                    '+
         '       PMN33,                                    '+
         '       ''5.�b�~'',                               '+
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
            '     SELECT ''�D�O'',                                              '+
            '            ''01'',                                                '+
            '            RVB05  ,                                               '+
            '            RVA06+7  ,                                             '+
            '            ''3.����'',                                            '+
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



  
  //���`����
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
    Screen.Cursor:=crSQLWait;
    if frmSysQryResultEx.Query.Active then frmSysQryResultEx.Query.Close;
    frmSysQryResultEx.Query.SQL.Clear;

    lSql:='SELECT A.PLANT AS ���~,                                                                                              '+
          '       A.STKNO AS �w�O,                                                                                              '+
          '       A.SDTYPE AS ���O,                                                                                             '+
          '       A.SDDATE AS �ѻݤ��,                                                                                         '+
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
          '       END AS ��,                                                                                                    '+
          '       A.PARTNO AS �Ƹ�,                                                                                             '+
          '       (SELECT COUNT(B.PARTNO) FROM TempMATSDEX B WHERE B.PLANT=A.PLANT AND B.STKNO=A.STKNO AND B.PARTNO=A.PARTNO AND'+
          '                                                  B.SDDATE||B.SDINFO[4,10]<=A.SDDATE||A.SDINFO[4,10]) AS ����,       '+
          '       CASE WHEN A.SDQTY>=0 THEN ''��'' ELSE ''��'' END AS �ѻ�,                                                     '+
          '       A.SDQTY AS �ƶq,                                                                                              '+
          '       A.SDBAL AS ���s,                                                                                              '+
          '       A.SDINFO AS �Ѧ�,                                                                                             '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '         A.SDINFO[5,8] END AS ���u��,                                                                                '+
          '       CASE WHEN A.SDINFO[1,3] IN (''WOD'',''RWK'',''SKD'',''ASY'',''PCB'',''SMD'',''AIV'',''AIH'') THEN             '+
          '            CASE WHEN A.SDINFO[7,7] IN(''0'',''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'') THEN             '+
          '              (SELECT SFB05 FROM DS2::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8])                '+
          '            ELSE (SELECT SFB05 FROM DS3::SFB_FILE WHERE SFB01[1,3]=''WOD'' AND SFB01[5,8]=A.SDINFO[5,8])             '+
          '            END                                                                                                      '+
          '       END AS ����,                                                                                                  '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT PMC03 FROM DS2::PMM_FILE,DS2::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '            (SELECT PMC03 FROM DS3::PMM_FILE,DS3::PMC_FILE WHERE PMM09=PMC01 AND PMM01=A.SDINFO[1,10])               '+
          '        END) AS �t��,                                                                                                '+
          '       (CASE WHEN A.STKNO=''01'' THEN                                                                                '+
          '            CASE WHEN A.SDINFO[1,2] IN(''PO'',''PT'') THEN                                                           '+
          '                (SELECT GEN02 FROM DS2::PMM_FILE,DS2::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10]) END       '+
          '        ELSE                                                                                                         '+
          '           (SELECT GEN02 FROM DS3::PMM_FILE,DS3::GEN_FILE WHERE PMM12=GEN01 AND PMM01=A.SDINFO[1,10])                '+
          '        END ) AS ����                                                                                                '+
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
      frmSysQryResultEx.Caption:=Format('asft110 - %S �u����ƨѻݬd��',[WorkOrderNo]);
      frmSysQryResultEx.ShowModal;
    end;{ else begin
      Application.MessageBox(Pchar((Format('%s,%S �Ѯƥ��`�I',[Username,WorkOrderNo]))),'����',MB_ICONINFORMATION+MB_OK);
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

    lSql:=  ' SELECT SFA03 AS ���ƮƸ�, '+
            '        SFB25 AS �W�u��,          '+
            '        SFA01 AS �u��,      '+
            '        IMA02 AS �~�W�y�z,      '+
            '        SFA30 AS �w�O,          '+
            '        SFA05 AS �u��ƶq,                                                                '+
            '        SFA06 AS �o�Ƽƶq,                                                                '+
            '        SFA05-SFA06 AS ���o�ƶq,                                                          '+
            '        (SELECT SUM(IMG10) FROM DS2::IMG_FILE WHERE IMG01=SFA03 AND IMG02=SFA30) AS �w�s�ƶq,  '+
            '(SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                                                '+
            '   FROM DS2::RVB_FILE,DS2::RVA_FILE, DS2::PMN_FILE                                    '+
            '  WHERE RVB01 =RVA01                                                                  '+
            '    AND RVB05 = SFA03                                                                 '+
            '    AND RVB04 = PMN01                                                                 '+
            '    AND RVB03 = PMN02                                                                 '+
            '    AND RVB07 > (RVB29+RVB30)                                                         '+
            '    AND RVACONF!=''X'') AS ���˼ƶq                                                   '+
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

            ' SELECT SFA03 AS ���ƮƸ�, '+
            '        SFB25 AS �W�u��,          '+
            '        SFA01 AS �u��,      '+
            '        IMA02 AS �~�W�y�z,                                                            '+
            '        SFA30 AS �w�O,          '+
            '        SFA05 AS �u��ƶq,                                                                    '+
            '        SFA06 AS �o�Ƽƶq,                                                                    '+
            '        SFA05-SFA06 AS ���o�ƶq,                                                              '+
            // ���p�u��w�O�OA02 �N��01�ܮw�s�A�Y�OA01 ��A01�ܮw�s�A�䥦��01�ܱo�w�s
            '        CASE WHEN SFA30=''A02'' THEN (SELECT SUM(IMG10) FROM DS2::IMG_FILE WHERE IMG01=SFA03 AND IMG02=''01'')  '+
            '             WHEN SFA30=''A01'' THEN (SELECT SUM(IMG10) FROM DS3::IMG_FILE WHERE IMG01=SFA03 AND IMG02=SFA30)   '+
            '             ELSE  (SELECT SUM(IMG10) FROM DS2::IMG_FILE WHERE IMG01=SFA03 AND IMG02=''01'') END  AS �w�s�ƶq, '+
            '        (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                                                '+
            '           FROM DS2::RVB_FILE,DS2::RVA_FILE, DS2::PMN_FILE                                    '+
            '          WHERE RVB01 =RVA01                                                                  '+
            '            AND RVB05 = SFA03                                                                 '+
            '            AND RVB04 = PMN01                                                                 '+
            '            AND RVB03 = PMN02                                                                 '+
            '            AND RVB07 > (RVB29+RVB30)                                                         '+
            '            AND RVACONF!=''X'') AS ���˼ƶq                                                   '+
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
    frmSysQryResultEx.Caption:='asft110 - �u��W�u�ʮƬd��';
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
            ' SELECT CCC01 AS ���ƮƸ�,    '+
            '        CAST(CCC02||(CASE WHEN CCC03<10 THEN ''0''||CAST(CCC03 AS CHAR(1)) ELSE CAST(CCC03 AS CHAR(2)) END) AS CHAR(6)) AS �o�Ʀ~��, '+
            '        CCC31 AS �o�Ƽƶq '+
            '   FROM CCC_FILE          '+
            '  WHERE CCC01[1,2] IN(''%S) '+
            '    AND CCC31!=0          '+
            '    AND CCC02 BETWEEN ''%S'' AND ''%S'''+
            '    AND CCC03 BETWEEN ''%S'' AND ''%S''',[strItem,strSBegin,strSEnd,strMBegin,strMEnd]));
   Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='Asfr104a - �u���o���Ƭd��(By Item)';
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
            '   SELECT SFE01 �u��s��,SFE02 ��ڽs��,SFE04 ���ʤ��,SFE07 �ƥ�s��, '+
            '          SFE16 ���ʼƶq,SFE09 �x��,PMM09 �����t��,ROUND(IMA91,4) �������      '+
            '     FROM SFE_FILE LEFT OUTER JOIN PMM_FILE ON SFE01=PMM01             '+
            '                        INNER JOIN IMA_FILE ON SFE07=IMA01             '+
            '    WHERE SFE06=''%S''                                                 '+
            '      AND SFE01[1,3]=''%S''                                            '+
            '      AND SFE04 BETWEEN ''%S'' AND ''%S''',[IsType,WoType,StartDate,EndDate]));
   Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='Asfr104 - �u���o���Ƭd��';
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
    SQL.Add(Format('SELECT SFA01[1,3] AS �u��O ,       '+
                   '       SFB01[5,6] AS �~��,          '+
                   '       SFB01[5,8] AS ���u��,        '+
                   '       SFA03 AS �Ƹ�,               '+
                   '       SFA05 AS �ݨD��,             '+
                   '       IMA531 AS ����,              '+
                   '       SFA05*IMA531 AS ���B,        '+
                   '       IMA54 AS �ѳf��,             '+
                   '       SFB25 AS ��ڶ}�u                                                       '+
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
    frmSysQryResultEx.Caption:=Format('Asfr000 - ''%s''�u��p���P�Ƶ{�W�u��d��',[woym]);
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
    SQL.Add('SELECT ''DS2'' AS �t�O,                                  '+
            '        SFB01 AS ���u�渹,                               '+
            '        SFB05 AS ���~�~��,                               '+
            '        IMA02 AS ���~�y�z,                               '+
            '        SFB08 AS �Ͳ��ƶq,                               '+
            '        SFB09 AS �w�g�J�w,                               '+
            '           SFB08-SFB09 AS �b��ƶq,                      '+
            '           IMB111  AS �зǦ���,                          '+
            '           IMB211 AS �{�ɧ���,                           '+
            '           (SELECT MIN(CCJ01) FROM DS2::CCJ_FILE WHERE CCJ04[5,8]=SFB01[5,8] AND CCJ04[1,3]=''ASY'' ) AS �_�l�Ͳ�                            '+
            '      FROM DS2::SFB_FILE INNER JOIN DS2::IMA_FILE  ON  SFB05=IMA01   '+
            '                LEFT OUTER JOIN DS2::IMB_FILE ON  SFB05=IMB01        '+
            '     WHERE SFB04 BETWEEN ''1'' AND ''7''                 '+
            '       AND (SFB08-SFB09)>0                               '+
            '       AND SFB01[1,3] IN (''ASY'',''WOD'',''SKD'')       '+
            '  UNION ALL                                              '+
            ' SELECT ''DS2'' AS �t�O,                                 '+
            '        SFB01 AS ���u�渹,                               '+
            '        SFB05 AS ���~�~��,                               '+
            '        IMA02 AS ���~�y�z,                               '+
            '        SFB08 AS �Ͳ��ƶq,                               '+
            '        SFB09 AS �w�g�J�w,                               '+
            '           SFB08-SFB09 AS �b��ƶq,                      '+
            '           IMB111  AS �зǦ���,                          '+
            '           IMB211 AS �{�ɧ���,                           '+
            '           (SELECT MIN(CCJ01) FROM DS2::CCJ_FILE WHERE CCJ04[1,8]=SFB01[1,8]) AS �_�l�Ͳ�                            '+
            '      FROM DS2::SFB_FILE INNER JOIN DS2::IMA_FILE  ON  SFB05=IMA01   '+
            '                LEFT OUTER JOIN DS2::IMB_FILE ON  SFB05=IMB01        '+
            '     WHERE SFB04 BETWEEN ''1'' AND ''7''                 '+
            '       AND (SFB08-SFB09)>0                               '+
            '       AND SFB01[1,3] =''RWK''                           '+
            '                                                         '+
            '    UNION ALL                                            '+
            '                                                         '+
            '    SELECT ''DS3'' AS PLANT,                             '+
            '          SFB01 AS ���u�渹,                             '+
            '           SFB05 AS ���~�~��,                            '+
            '           IMA02 AS ���~�y�z,                            '+
            '          SFB08 AS �Ͳ��ƶq,                             '+
            '           SFB09 AS �w�g�J�w,                            '+
            '           SFB08-SFB09 AS �b��ƶq,                      '+
            '           IMB111  AS �зǦ���,                          '+
            '           IMB211 AS �{�ɧ���,                           '+
            '           (SELECT MIN(CCJ01) FROM DS3::CCJ_FILE WHERE CCJ04[1,8]=SFB01[1,8]  ) AS �_�l�Ͳ�                            '+
            '      FROM DS3::SFB_FILE INNER JOIN DS3::IMA_FILE  ON  SFB05=IMA01   '+
            '                LEFT OUTER JOIN DS3::IMB_FILE ON  SFB05=IMB01        '+
            '     WHERE SFB04 BETWEEN ''1'' AND ''7''                 '+
            '       AND (SFB08-SFB09)>0                               '+
            '       AND SFB01[1,3]=''RWK''                            '+
            '    UNION ALL                                            '+
            '    SELECT ''DS3'' AS PLANT,                             '+
            '          SFB01 AS ���u�渹,                             '+
            '           SFB05 AS ���~�~��,                            '+
            '           IMA02 AS ���~�y�z,                            '+
            '          SFB08 AS �Ͳ��ƶq,                             '+
            '           SFB09 AS �w�g�J�w,                            '+
            '           SFB08-SFB09 AS �b��ƶq,                      '+
            '           IMB111  AS �зǦ���,                          '+
            '           IMB211 AS �{�ɧ���,                           '+            
            '           (SELECT MIN(CCJ01) FROM DS3::CCJ_FILE WHERE CCJ04[5,8]=SFB01[5,8] AND CCJ04[1,3]=''ASY'') AS �_�l�Ͳ�                            '+
            '      FROM DS3::SFB_FILE INNER JOIN DS3::IMA_FILE  ON  SFB05=IMA01   '+
            '                LEFT OUTER JOIN DS3::IMB_FILE ON  SFB05=IMB01        '+
            '     WHERE SFB04 BETWEEN ''1'' AND ''7''                 '+
            '       AND (SFB08-SFB09)>0                               '+
            '       AND SFB01[1,3] IN (''ASY'',''WOD'',''SKD'')') ;
   Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='Asfr1061 - �����u����Ӭd��';
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
    lSql:= ('SELECT ''DS2'' AS ���~�P,   '+
            '   SFB01 AS ���u�渹,       '+
            '   SFB05 AS ���~�~��,       '+
            '   IMA02 AS ���~�y�z,       '+
            '   SFB08 AS �Ͳ��ƶq,       '+
            '   SFB09 AS �w�g�J�w,       '+
            '   SFB08-SFB09 AS �b��ƶq, '+
            '   SFB15 AS �w�J�w��,        '+
            ' CASE WHEN SFB15<TODAY THEN TODAY-SFB15 END AS �O��'+
        '  FROM DS2::SFB_FILE,DS2::IMA_FILE               '+
        ' WHERE SFB05=IMA01                               '+
        '   AND SFB04 BETWEEN ''4'' AND ''7''             '+
        '   AND (SFB08-SFB09)>0  AND SFB01[5,6]<=''%S''   '+
        '   AND SFB01[1,3] IN (''RWK'',''WOD'')           '+
        '                                                 '+
        '  UNION ALL                                      '+
        '                                                 '+
        ' SELECT ''DS3'' AS PLANT,                        '+
        '        SFB01 AS ���u�渹,                       '+
        '       SFB05 AS ���~�~��,                        '+
        '       IMA02 AS ���~�y�z,                        '+
        '       SFB08 AS �Ͳ��ƶq,                        '+
        '       SFB09 AS �w�g�J�w,                        '+
        '       SFB08-SFB09 AS �b��ƶq,  '+
            '   SFB15 AS �w�J�w��,        '+
            ' CASE WHEN SFB15<TODAY THEN TODAY-SFB15 END AS �O��'+
        '  FROM DS3::SFB_FILE,DS3::IMA_FILE               '+
        ' WHERE SFB05=IMA01                               '+
        '   AND SFB04 BETWEEN ''4'' AND ''7''             '+
        '   AND (SFB08-SFB09)>0 AND SFB01[5,6]<=''%S''    '+
        '   AND SFB01[1,3] IN(''RWK'',''WOD'')') ;
        SQL.Add(Format(lSql,[WorkOrder,WorkOrder]));
        Open;

    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Caption:='Asfr1061 - �u��b����Ӭd��';
    frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;

end;


end.
