unit BomCode;

interface
  uses Windows,SysUtils,Classes,DBTables,Forms,Controls,JclStrings;



  function GetBomConfirm(Partno:String):Boolean;
  procedure GetBomCompare_bbmq102(VAR ModeList:TStrings);
  procedure GetBomCompare_bbmq1020(ModeA,ModeB:String);
  procedure GetWoMode(Partno:String);
  procedure GetWoModeEX(myno,parent,Partno:String);
  procedure GetBomCompare_wo(Wono:String);

implementation
  uses pasDm,pasSysQryResultEx,pasCodeProc,pasSysRes,pasGetDate;


procedure GetWoModeEX(myno,parent,Partno:String);
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
    lSql:='SELECT BMT05/10 AS 行號,  '+
          '       BMT01 AS 母階料號, '+
          '       BMT02 AS 序號,     '+
          '       BMT03 AS 材料料號, '+
          '       BMT06 AS 插件位置, '+
          '       BMT04 AS 生效日期, '+
          '       BMT07 AS 組成用量 '+
          '   FROM BMT_FILE WHERE BMT01=''%S'' AND BMT02=''%S'' AND BMT03=''%S''';
          
    SQL.Add(Format(lSql,[parent,myno,Partno]));
    Open;

    Screen.Cursor:=crDefault;

    if frmSysQryResultEx.Query.RecordCount>0 then
    begin
      frmSysQryResultEx.Caption:=Format('-%S-插件位置明細',[Partno]);
      frmSysQryResultEx.ShowModal;
    end
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;

procedure GetWoMode(Partno:String);
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
    lSql:='SELECT DISTINCT SFB05 AS 成品料號,IMA02 AS 成品描述,IMA133 AS 品名規格  '+
          '   FROM DS2::SFB_FILE, DS2::IMA_FILE                                    '+
          '  WHERE SFB01[1,3]=''WOD''                                                '+
          '    AND SFB01[5,8] IN (SELECT SFA01[5,8] FROM DS2::SFA_FILE WHERE SFA03=''%S'') '+
          '    AND SFB05=IMA01                                                             '+
          '                                                                                '+
          '  UNION ALL                                                                     '+
          ' SELECT DISTINCT SFB05,IMA02,IMA133                                             '+
          '   FROM DS3::SFB_FILE,DS3::IMA_FILE                                              '+
          '  WHERE SFB01[1,3]=''WOD''                                                      '+
          '    AND SFB01[5,8] IN (SELECT SFA01[5,8] FROM DS3::SFA_FILE WHERE SFA03=''%S'') '+
          '    AND SFB05=IMA01                                                             '+
          '    ORDER BY 1';
    SQL.Add(Format(lSql,[Partno,Partno]));
    Open;

    Screen.Cursor:=crDefault;

    if frmSysQryResultEx.Query.RecordCount>0 then
    begin
      frmSysQryResultEx.Caption:=Format('-%S-曾經使用過機種明細',[Partno]);
      frmSysQryResultEx.ShowModal;
    end
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
end;

function GetBomConfirm(Partno:String):Boolean;
var
  lQry:TQuery;
  lRtnNoBom,
  lRtnNoCfm:Integer;
begin
  lQry:=TQuery.Create(Application);
  try
    with  lQry do begin
      DatabaseName:='DS';
      SessionName:=dm.db.SessionName;

      if Active then Close;
      SQL.Clear;
      SQL.Add(Format(
              'SELECT COUNT(BMA01)       '+
              '  FROM BMA_FILE           '+
              ' WHERE BMA01=''%S''',[Partno]));
      Open;

      lRtnNoBom:=lQry.Fields[0].AsInteger;

      if lRtnNoBom > 0 then begin
        if Active then Close;
        SQL.Clear;
        SQL.Add(Format(
                'SELECT COUNT(BMA05)       '+
                '  FROM BMA_FILE           '+
                ' WHERE BMA01=''%S''       '+
                '   AND BMA05 IS NOT NULL',[Partno]));
        Open;

        lRtnNoCfm:=lQry.Fields[0].AsInteger;
        if lRtnNoCfm > 0 then begin
          GetBomConfirm:=True;
        end else begin
         Application.MessageBox(PChar(Format(gBomNoConfirm,[Partno])),
                                PChar(gExmCaption),
                                MB_ICONEXCLAMATION+MB_OK);
          GetBomConfirm:=False;
        end;
      end else begin
         Application.MessageBox(PChar(Format(gBomNoFound,[Partno])),
                                PChar(gExmCaption),
                                MB_ICONEXCLAMATION+MB_OK);
         GetBomConfirm:=False;
      end;
    end;
  finally
    lQry.Free;
  end;
end;


procedure GetBomCompare_bbmq102(VAR ModeList:TStrings);
var
  vQry:TQuery;
  i:Integer;
  Delimiter,
  lSql,
  FirstField,
  WhereSql:String;


  procedure DoBomExplose(Mode:String);
  var
    iEndTree,iLvl:Integer;
    FieldsName:String;
    sQry:TQuery;
  begin

   try
      dm.DB.Execute('CREATE TEMP TABLE BBMQ102'+
        ' (LVL   INTEGER,'+
        ' PARENT VARCHAR(15),'+
        ' CHILD  VARCHAR(15),'+
        ' M      VARCHAR(1),'+
        ' P      VARCHAR(1),'+
        ' MODES VARCHAR(15),'+
        ' USAGE  DECIMAL(12,4))');
      dm.DB.Execute('CREATE INDEX IDX_BBMQ102 ON BBMQ102 (CHILD)');
   except
     { on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then  }
         dm.DB.Execute('DELETE BBMQ102');
   end;

    iEndTree:=0;
    iLvl:=1;

    FieldsName:=StrReplaceChar(Mode,'-','_');
    // 取第1階資料
    dm.DB.Execute(Format('INSERT INTO BBMQ102 (MODES,LVL,PARENT,CHILD,USAGE,P)'+
                 ' SELECT ''%S'',1 ,A.BMB01,A.BMB03,A.BMB06,A.BMB19'+
                 ' FROM BMB_FILE A '+
                 ' WHERE A.BMB01=''%S'''+
                 '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL)',[FieldsName,Mode]));



    while (iEndTree=0) do
    begin
      iLvl:=iLvl+1;
             dm.DB.Execute(Format('INSERT INTO BBMQ102(MODES,LVL,PARENT,CHILD,USAGE,P)'+
            ' SELECT ''%S'',%d,A.BMB01,A.BMB03,A.BMB06,A.BMB19'+
            ' FROM BMB_FILE A ,BBMQ102 B ,IMA_FILE C '+
            ' WHERE A.BMB01=B.CHILD '+
            '   AND A.BMB01=C.IMA01'+
            '   AND C.IMA08=''M'''+
            '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[FieldsName,iLvl,iLvl-1]));

    sQry:= TQuery.Create(Application);
    try
    sQry.DatabaseName:='DS';
    sQry.SessionName:=dm.db.SessionName;
    if sQry.Active then
       sQry.Close;
    sQry.SQL.Clear;
    sQry.SQL.Add(Format('SELECT LVL FROM bbmq102 WHERE LVL =%d',[iLvl]));
    sQry.Open;

    if (sQry.Fields[0].AsInteger>1) then
       iEndTree:=0   // 假如下階還有材料,繼續展下階材料
    else
       iEndTree:=1;  // 假如下階沒有材料,停止展下階材料
    finally
      sqry.free;
    end;

    end;
    dm.db.Execute('INSERT INTO GWS:BBA_FILE(MODE,PART,QTYS) SELECT MODES,CHILD,SUM(USAGE) '+
                  ' FROM BBMQ102 GROUP BY MODES,CHILD');
  end;

begin
  Delimiter:=',';
  lSql:=EmptyStr;
  FirstField:=EmptyStr;
  WhereSql:=EmptyStr;

  vQry:= TQuery.Create(Application);
  try
    vQry.DatabaseName:='DS';
    vQry.SessionName:=dm.db.SessionName;

    ExecSqlA('DELETE GWS::BBA_FILE');

  for i:=0 to ModeList.Count-1 do begin
   // if GetBomConfirm(ModeList.Strings[i]) then
      DoBomExplose(ModeList.Strings[i]);

  end;


  if vQry.Active then
     vQry.Close;
  vQry.SQL.Clear;
  vQry.SQL.Add('SELECT DISTINCT MODE FROM GWS::BBA_FILE ORDER BY 1');
  vQry.Open;
  // 用預計需求日期來產生動態交叉表之欄位
  vQry.DisableControls;
  try
    vQry.First;
    FirstField:=vQry.Fields[0].AsString;
    while not vQry.Eof do begin
      lsql:=lSql+'SUM(CASE MODE WHEN '''+vQry.Fields[0].AsString+''' THEN QTYS END) AS P'+vQry.Fields[0].AsString+Delimiter;
      vQry.Next;
    end;
  finally
    vQry.EnableControls;
  end;
  //WhereSql:='('+FirstField+'-'+'('+StrLeft(WhereSql,StrLen(PChar(wheresql))-1)+')'+'/'+IntToStr(ModeList.Count)+')!=0';

  //Application.MessageBox(pchar(wheresql),'',mb_ok);
  frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
  try
  Screen.Cursor:=crSQLWait;
  with frmSysQryResultEx.Query do
  begin
    if Active then
      Close;
    SQL.Clear;
    lSql:=Format(
            'SELECT PART,   '+
            '       %S       '+
                  '       (SELECT SUM((SFA05-SFA06)*SFA13)                '+
                  '          FROM DS2::SFA_FILE , DS2::SFB_FILE           '+
                  '         WHERE SFA01=SFB01                             '+
                  '           AND SFB04!=''8''                            '+
                  '           AND SFA03=A.PART                            '+
                  '           AND ((SFA05 -SFA06))  AS  非保應領,         '+

                  '       (SELECT SUM((SFA05-SFA06)*SFA13)                '+
                  '          FROM DS3::SFA_FILE , DS3::SFB_FILE           '+
                  '         WHERE SFA01=SFB01                             '+
                  '           AND SFB04!=''8''                            '+
                  '           AND SFA03=A.PART                            '+
                  '           AND ((SFA05 -SFA06))  AS  保稅應領,         '+


                  '       (SELECT SUM(IMG10)                              '+
                  '          FROM DS2::IMG_FILE B                         '+
                  '         WHERE B.IMG01=A.PART                          '+
                  '          AND B.IMG23=''Y'' AND B.IMG02<>''BVI'') AS 非保庫存,                    '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''A02'') AS 保非庫存,                  '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''A01'') AS 保稅庫存,                  '+

                  '       (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                '+
                  '          FROM DS2::RVB_FILE, DS2::RVA_FILE, DS2::PMN_FILE   '+
                  '         WHERE RVB01=RVA01                                   '+
                  '           AND RVB05 =A.PART                             '+
                  '           AND RVB04 = PMN01                                 '+
                  '           AND RVB03 = PMN02                                 '+
                  '           AND RVB07 > (RVB29+RVB30)) AS 非保待檢,           '+

                  '       (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                '+
                  '          FROM DS3::RVB_FILE, DS3::RVA_FILE, DS3::PMN_FILE   '+
                  '         WHERE RVB01=RVA01                                   '+
                  '           AND RVB05 =A.PART                             '+
                  '           AND RVB04 = PMN01                                 '+
                  '           AND RVB03 = PMN02                                 '+
                  '           AND RVB07 > (RVB29+RVB30)) AS 保稅待檢,           '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS2::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''BVI'') AS 非保在途,                  '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''BVI'') AS 保稅在途,                  '+                  
                                                      
                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS5::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''05'') AS 在台庫存,                   '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS2::PMN_FILE, DS2::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.PART                             '+
                  '           AND PMN16 <=''2''                                 '+
                  '           AND PMN011 !=''SUB''                              '+
                //      '       AND PMN20 >PMN50                                '+
                  '           AND PMN33 < TODAY   HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS 非保逾訂,                   '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS3::PMN_FILE, DS3::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.PART                             '+
                  '           AND PMN16 <=''2''                                 '+
                  '           AND PMN011 !=''SUB''                              '+
                //  '       AND PMN20 >PMN50                                '+
                  '           AND PMN33 < TODAY   HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS 保稅逾訂,                   '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS2::PMN_FILE, DS2::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.PART                             '+
                  '           AND PMN16 <=''2''                                 '+
               // '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 >= TODAY   HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS 非保訂單,                  '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS3::PMN_FILE, DS3::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.PART                             '+
                  '           AND PMN16 <=''2''                                 '+
               // '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 >= TODAY  HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS 保稅訂單,                  '+

                  '       (SELECT SUM((PML20-PML21)*PML09)                      '+
                  '              FROM DS2::PML_FILE B, DS2::PMK_FILE C          '+
                  '             WHERE PML04 = A.PART                        '+
                  '               AND PML01 = PMK01                             '+
                  '               AND PML20 > PML21                             '+
                  '               AND PML16 <=''2''                             '+
                  '               AND PML011 !=''SUB'') AS 非保請購,            '+

                  '       (SELECT SUM((PML20-PML21)*PML09)                      '+
                  '              FROM DS3::PML_FILE B, DS3::PMK_FILE C          '+
                  '             WHERE PML04 = A.PART                        '+
                  '               AND PML01 = PMK01                             '+
                  '               AND PML20 > PML21                             '+
                  '               AND PML16 <=''2''                             '+
                  '               AND PML011 !=''SUB'') AS 保稅請購,            '+


                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS5::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02<>''05'') AS 台灣庫存                   '+
            ' FROM GWS::BBA_FILE A ,IMA_FILE B  '+
            ' WHERE A.PART=B.IMA01 AND B.IMA08=''P'''+
            ' GROUP BY PART           '+
            ' ORDER BY 1',[lSql]);
    SQL.Add(lSql);
    Open;

    Screen.Cursor:=crDefault;
      frmSysQryResultEx.Caption:='abmr691 - BOM 比較查詢作業';
      frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
      
   finally
     vQry.Free;
   end;
end;

procedure GetBomCompare_bbmq1020(ModeA,ModeB:String);
var
  lSql,
  vModeA,vModeB:String;

  procedure DoBomExplose(Select,Mode:String);
  var
    iEndTree,iLvl:Integer;
    //FieldsName:String;
    sQry:TQuery;
  begin

   try
      ExecSqla('CREATE TEMP TABLE BBMQ102'+
        ' (LVL   INTEGER,'+
        ' PARENT VARCHAR(15),'+
        ' CHILD  VARCHAR(15),'+
        ' M      VARCHAR(1),'+
        ' P      VARCHAR(1),'+
        ' MODES VARCHAR(15),'+
        ' USAGE  DECIMAL(12,4))');
      ExecSqla('CREATE INDEX IDX_BBMQ102 ON BBMQ102 (CHILD)');
   except
     { on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then  }
      ExecSqla('DELETE BBMQ102');
   end;

    iEndTree:=0;
    iLvl:=1;

    //FieldsName:=StrReplaceChar(Mode,'-','_');
    // 取第1階資料
    ExecSqla(Format('INSERT INTO BBMQ102 (MODES,LVL,PARENT,CHILD,USAGE,P)'+
                 ' SELECT ''%S'',1 ,A.BMB01,A.BMB03,A.BMB06,A.BMB19'+
                 ' FROM BMB_FILE A '+
                 ' WHERE A.BMB01=''%S'''+
                 '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL)',[Mode,Mode]));

    while (iEndTree=0) do
    begin
      iLvl:=iLvl+1;
            ExecSqla(Format('INSERT INTO BBMQ102(MODES,LVL,PARENT,CHILD,USAGE,P)'+
            ' SELECT ''%S'',%d,A.BMB01,A.BMB03,A.BMB06,A.BMB19'+
            ' FROM BMB_FILE A ,BBMQ102 B ,IMA_FILE C '+
            ' WHERE A.BMB01=B.CHILD '+
            '   AND A.BMB01=C.IMA01'+
            '   AND C.IMA08=''M'''+
            '   AND (BMB04<=TODAY  OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[Mode,iLvl,iLvl-1]));

    sQry:= TQuery.Create(Application);
    try
    sQry.DatabaseName:='DS';
    sQry.SessionName:=dm.db.SessionName;
    if sQry.Active then
       sQry.Close;
    sQry.SQL.Clear;
    sQry.SQL.Add(Format('SELECT LVL FROM bbmq102 WHERE LVL =%d',[iLvl]));
    sQry.Open;

    if (sQry.Fields[0].AsInteger>1) then
       iEndTree:=0   // 假如下階還有材料,繼續展下階材料
    else
       iEndTree:=1;  // 假如下階沒有材料,停止展下階材料
    finally
      sqry.free;
    end;

    end;
    ExecSqla(Format(
                  'INSERT INTO TMP_BMQ102(SELE,MODE,PART,QTYS)'+
                  '     SELECT ''%S'',MODES,CHILD,SUM(USAGE)    '+
                  '       FROM BBMQ102                          '+
                  '   GROUP BY MODES,CHILD',[SELECT]));
  end;

begin
  lSql:=EmptyStr;

     try
      ExecSqla(
        'CREATE TEMP TABLE TMP_BMQ102'+
        ' (                          '+
        ' SELE VARCHAR(15),'+
        ' MODE VARCHAR(15),'+
        ' PART VARCHAR(15),'+
        ' QTYS DECIMAL(8,0))');
     except
      {on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then  }
       ExecSqla('DELETE TMP_BMQ102');
     end;


    if GetBomConfirm(ModeA) then
       if GetBomConfirm(ModeB) then begin
         DoBomExplose('A',ModeA);
         DoBomExplose('B',ModeB);

    vModeA:=StrReplaceChar(ModeA,'-','_');
    vModeB:=StrReplaceChar(ModeB,'-','_');

    frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
    try
    Screen.Cursor:=crSQLWait;
      try
      ExecSqla(
        'CREATE TEMP TABLE TMP_BOM001   '+
        ' (                             '+
        ' PART VARCHAR(15),             '+
        ' AQTY DECIMAL(8,0),            '+
        ' BQTY DECIMAL(8,0),            '+
        ' QBAL DECIMAL(8,0),            '+
        ' DS2WO DECIMAL(10,0),          '+
        ' DS3WO DECIMAL(10,0),          '+
        ' DS201 DECIMAL(10,0),          '+
        ' DS3A02 DECIMAL(10,0),         '+
        ' DS3A01 DECIMAL(10,0),         '+
        ' DS2IQC DECIMAL(10,0),         '+
        ' DS3IQC DECIMAL(10,0),        '+
        ' DS2BVI DECIMAL(10,0),         '+
        ' DS3BVI DECIMAL(10,0),         '+
        ' DS2DPO DECIMAL(10,0),         '+
        ' DS3DPO DECIMAL(10,0),         '+
        ' DS2PO DECIMAL(10,0),          '+
        ' DS3PO DECIMAL(10,0),          '+
        ' DS2PR DECIMAL(10,0),          '+
        ' DS3PR DECIMAL(10,0))');
   except
    {  on e:EDBEngineError do
      if e.Errors[1].NativeError=-958 then }
      ExecSqla('DELETE TMP_BOM001');
   end;
       

  with frmSysQryResultEx.Query do
  begin
    if Active then
      Close;
    SQL.Clear;
    lSql:=  ' INSERT INTO  TMP_BOM001(PART,AQTY,BQTY,QBAL,DS2WO,DS3WO,DS201,DS3A02,'+
            '              DS3A01,DS2IQC,DS3IQC,DS2BVI,DS3BVI,DS2DPO,DS3DPO, '+
            '              DS2PO,DS3PO,DS2PR,DS3PR)                       '+
            ' SELECT A.PART,                                              '+
            '        SUM(CASE WHEN A.SELE =''A'' THEN A.QTYS END),        '+
            '        SUM(CASE WHEN A.SELE =''B'' THEN A.QTYS END),        '+
            '       (NVL(SUM(CASE WHEN A.SELE =''A'' THEN A.QTYS END),0))-'+
            '        NVL(SUM(CASE WHEN A.SELE =''B'' THEN A.QTYS END),0), '+
                  '       (SELECT SUM((SFA05-SFA06)*SFA13)                '+
                  '          FROM DS2::SFA_FILE , DS2::SFB_FILE           '+
                  '         WHERE SFA01=SFB01                             '+
                  '           AND SFB04!=''8''                            '+
                  '           AND SFA03=A.PART                            '+
                  '           AND (SFA05 -SFA06)>0)  AS  非保應領,           '+

                  '       (SELECT SUM((SFA05-SFA06)*SFA13)                '+
                  '          FROM DS3::SFA_FILE , DS3::SFB_FILE           '+
                  '         WHERE SFA01=SFB01                             '+
                  '           AND SFB04!=''8''                            '+
                  '           AND SFA03=A.PART                            '+
                  '           AND (SFA05 - SFA06)>0)  AS  保稅應領,         '+


                  '       (SELECT SUM(IMG10)                              '+
                  '          FROM DS2::IMG_FILE B                         '+
                  '         WHERE B.IMG01=A.PART                          '+
                  '          AND B.IMG23=''Y'' AND B.IMG02<>''BVI'') AS 非保庫存,                    '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''A02'') AS 保非庫存,                  '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''A01'') AS 保稅庫存,                  '+

                  '       (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                '+
                  '          FROM DS2::RVB_FILE, DS2::RVA_FILE, DS2::PMN_FILE   '+
                  '         WHERE RVB01=RVA01                                   '+
                  '           AND RVB05 =A.PART                             '+
                  '           AND RVB04 = PMN01                                 '+
                  '           AND RVB03 = PMN02                                 '+
                  '           AND RVB07 > (RVB29+RVB30)) AS 非保待檢,           '+

                  '       (SELECT SUM((RVB07-RVB29-RVB30)*PMN09)                '+
                  '          FROM DS3::RVB_FILE, DS3::RVA_FILE, DS3::PMN_FILE   '+
                  '         WHERE RVB01=RVA01                                   '+
                  '           AND RVB05 =A.PART                             '+
                  '           AND RVB04 = PMN01                                 '+
                  '           AND RVB03 = PMN02                                 '+
                  '           AND RVB07 > (RVB29+RVB30)) AS 保稅待檢,           '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS2::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''BVI'') AS 非保在途,                  '+

                  '       (SELECT SUM(IMG10)                                    '+
                  '          FROM DS3::IMG_FILE B                               '+
                  '         WHERE B.IMG01=A.PART                            '+
                  '          AND B.IMG23=''Y''                                  '+
                  '          AND B.IMG02=''BVI'') AS 保稅在途,                  '+                  

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS2::PMN_FILE, DS2::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.PART                             '+
                  '           AND PMN16 <=''2''                                 '+
                //  '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 < TODAY   HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0 ) AS 非保逾訂,                   '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS3::PMN_FILE, DS3::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.PART                             '+
                  '           AND PMN16 <=''2''                                 '+
                //  '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 < TODAY   HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS 保稅逾訂,                   '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS2::PMN_FILE, DS2::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.PART                             '+
                  '           AND PMN16 <=''2''                                 '+
                //  '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 >= TODAY  HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS 非保訂單,                  '+

                  '       (SELECT SUM((PMN20-PMN50+PMN55)*PMN09)                '+
                  '          FROM DS3::PMN_FILE, DS3::PMM_FILE                  '+
                  '         WHERE PMN01 = PMM01                                 '+
                  '           AND PMN04= A.PART                             '+
                  '           AND PMN16 <=''2''                                 '+
               // '       AND PMN20 >PMN50                                '+
                  '           AND PMN011 !=''SUB''                              '+
                  '           AND PMN33 >= TODAY  HAVING SUM((pmn20-pmn50+pmn55)*pmn09)>0) AS 保稅訂單,                  '+

                  '       (SELECT SUM((PML20-PML21)*PML09)                      '+
                  '              FROM DS2::PML_FILE B, DS2::PMK_FILE C          '+
                  '             WHERE PML04 = A.PART                        '+
                  '               AND PML01 = PMK01                             '+
                  '               AND PML20 > PML21                             '+
                  '               AND PML16 <=''2''                             '+
                  '               AND PML011 !=''SUB'') AS 非保請購,            '+

                  '       (SELECT SUM((PML20-PML21)*PML09)                      '+
                  '              FROM DS3::PML_FILE B, DS3::PMK_FILE C          '+
                  '             WHERE PML04 = A.PART                        '+
                  '               AND PML01 = PMK01                             '+
                  '               AND PML20 > PML21                             '+
                  '               AND PML16 <=''2''                             '+
                  '               AND PML011 !=''SUB'') AS 保稅請購             '+
            '   FROM TMP_BMQ102 A ,IMA_FILE B  '+
            ' WHERE A.PART=B.IMA01 AND B.IMA08=''P'''+
            ' GROUP BY 1                                            '+
            ' HAVING (NVL(SUM(CASE WHEN A.SELE =''A'' THEN A.QTYS END),0))-   '+
            '         NVL(SUM(CASE WHEN A.SELE =''B'' THEN A.QTYS END),0)!=0';

    SQL.Add(lSql);
    ExecSQL;
    
      if  Active then Close;
      SQL.Clear;
      SQL.Add(Format(
            'SELECT PART AS 料號,AQTY AS %S,BQTY AS %S,QBAL AS 差異,                         '+
            '         (NVL(DS201,0)+NVL(DS3A02,0)+NVL(DS2IQC,0)+NVL(DS2BVI,0)+ '+
            '          NVL(DS2DPO,0)+NVL(DS2PO,0)+NVL(DS2PR,0)) - NVL(DS2WO,0) AS 非保結存, '+
            '         (NVL(DS3A01,0)+NVL(DS3IQC,0)+NVL(DS3BVI,0)+                            '+
            '          NVL(DS3DPO,0)+NVL(DS3PO,0)+NVL(DS3PR,0)) - NVL(DS3WO,0) AS 保稅結存, '+
            '         -DS2WO AS 非保工單,-DS3WO AS 保稅工單,NVL(DS201,0)+NVL(DS3A02,0) AS 非保庫存 ,        '+
            '         DS3A01 AS 保稅庫存,NVL(DS2IQC,0)+NVL(DS3IQC,0) AS 待驗,DS2BVI AS 非保在途,'+
            '         DS3BVI AS 保稅在途,NVL(DS2DPO,0)+NVL(DS2PO,0) AS 非保在外,NVL(DS3DPO,0)+NVL(DS3PO,0) AS 保稅在外, '+
            '         DS2PR AS 非保請購,DS3PR  AS 保稅請購'+
            '    FROM TMP_BOM001  ORDER BY 1 ',['機種一'+vModea,'機種二'+vModeb]));
      Open;   
      Screen.Cursor:=crDefault;
      frmSysQryResultEx.Caption:='abmr691 - BOM 比較查詢作業';
      frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    ExecSqla('DROP TABLE TMP_BOM001');
    ExecSqla('DROP TABLE TMP_BMQ102');
    ExecSqla('DROP TABLE BBMQ102');
    frmSysQryResultEx.Free;
  end;
  end;
end;

procedure GetBomCompare_wo(Wono:String);
var
  lSql,vModeA,vModeB:String;
  lQry:TQuery;

  procedure DoBomExplose(Select,Mode:String);
  var
    iEndTree,iLvl:Integer;
    sQry:TQuery;
  begin


    iEndTree:=0;
    iLvl:=1;

    //FieldsName:=StrReplaceChar(Mode,'-','_');
    // 取第1階資料
    dm.DB.Execute(Format('INSERT INTO BBMQ102 (MODES,LVL,PARENT,CHILD,USAGE,P)'+
                 ' SELECT ''%S'',1 ,A.BMB01,A.BMB03,A.BMB06*(1+A.BMB08/100),A.BMB19'+
                 ' FROM BMB_FILE A '+
                 ' WHERE A.BMB01=''%S'''+
                 '   AND (BMB04<=TODAY OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL)',[Mode,Mode]));

    while (iEndTree=0) do
    begin
      iLvl:=iLvl+1;
             dm.DB.Execute(Format('INSERT INTO BBMQ102(MODES,LVL,PARENT,CHILD,USAGE,P)'+
            ' SELECT ''%S'',%d,A.BMB01,A.BMB03,A.BMB06*(1+A.BMB08/100),A.BMB19'+
            ' FROM BMB_FILE A ,BBMQ102 B ,IMA_FILE C '+
            ' WHERE A.BMB01=B.CHILD '+
            '   AND A.BMB01=C.IMA01'+
            '   AND C.IMA08=''M'''+
            '   AND (BMB04<=TODAY  OR BMB04 IS NULL) AND (BMB05>TODAY  OR BMB05 IS NULL) AND B.LVL=%d',[Mode,iLvl,iLvl-1]));

    sQry:= TQuery.Create(Application);
    try
    sQry.DatabaseName:='DS';
    sQry.SessionName:=dm.db.SessionName;
    if sQry.Active then
       sQry.Close;
    sQry.SQL.Clear;
    sQry.SQL.Add(Format('SELECT LVL FROM bbmq102 WHERE LVL =%d',[iLvl]));
    sQry.Open;

    if (sQry.Fields[0].AsInteger>1) then
       iEndTree:=0   // 假如下階還有材料,繼續展下階材料
    else
       iEndTree:=1;  // 假如下階沒有材料,停止展下階材料
    finally
      sqry.free;
    end;

    end;
    dm.db.Execute(Format(
                  'INSERT INTO TMP_BMQ102(SELE,MODE,PART,QTYS)'+
                  '     SELECT ''%S'',MODES,CHILD,SUM(USAGE)    '+
                  '       FROM BBMQ102                          '+
                  '   GROUP BY MODES,CHILD',[SELECT]));
  end;

begin
     lSql:=EmptyStr;

     lQry := TQuery.Create(Application);
     try
      with lQry do begin
        DatabaseName:='ds';
        SessionName:=dm.db.SessionName;
        SQL.Add(Format('SELECT SFB05 FROM SFB_FILE WHERE SFB01[5,8]=''%S'' AND SFB01[1,3]=''WOD''',[wono]));
        Open;
        vModeB:=lQry.Fields[0].AsString;

     end;
     finally
       lQry.Free;
     end;

     vModeA:=vModeB;


     
     if GetBomConfirm(Trim(vModeB)) then begin

     
     try
      dm.DB.Execute(
        'CREATE TEMP TABLE TMP_BMQ102'+
        ' (                          '+
        ' SELE VARCHAR(15),'+
        ' MODE VARCHAR(15),'+
        ' PART VARCHAR(15),'+
        ' QTYS DECIMAL(8,0))');
     except
        dm.DB.Execute('DELETE TMP_BMQ102');
     end;

     try
      dm.DB.Execute('CREATE TEMP TABLE BBMQ102'+
        ' (LVL   INTEGER,'+
        ' PARENT VARCHAR(15),'+
        ' CHILD  VARCHAR(15),'+
        ' M      VARCHAR(1),'+
        ' P      VARCHAR(1),'+
        ' MODES VARCHAR(15),'+
        ' USAGE  DECIMAL(12,4))');
        dm.DB.Execute('CREATE INDEX IDX_BBMQ102 ON BBMQ102 (CHILD)');
      except
        dm.DB.Execute('DELETE BBMQ102');
      end;


        // 插入A机种BOM
        dm.db.Execute(Format(
                  'INSERT INTO TMP_BMQ102(SELE,MODE,PART,QTYS)'+
                  ' SELECT ''A'',(SELECT DISTINCT A.SFB05 FROM SFB_FILE A WHERE SFB01[5,8]=''%S'' AND A.SFB01[5,8]=SFA01[5,8] AND SFB01[1,3]=''WOD''),'+
                  '        SFA03,SUM(SFA05/SFB08)  '+
                  '   FROM SFA_FILE,IMA_FILE,SFB_FILE         '+
                  '  WHERE SFA01[5,8]=''%S'' AND IMA01=SFA03 AND IMA08=''P'' AND SFA01=SFB01      '+
                  ' GROUP BY 1,2,3',[wono,wono]));

    // 插入B机种BOM
    DoBomExplose('B',vModeB);

    vModeA:=StrReplaceChar(vModeA,'-','_');
    vModeB:=StrReplaceChar(vModeB,'-','_');

     try
      dm.DB.Execute(
        'CREATE TEMP TABLE TMP_BOM001   '+
        ' (                             '+
        ' PART VARCHAR(15),             '+
        ' AQTY DECIMAL(8,0),            '+
        ' BQTY DECIMAL(8,0),            '+
        ' QBAL DECIMAL(8,0))');
     except
       dm.DB.Execute('DELETE TMP_BOM001');
     end;


    frmSysQryResultEx := TfrmSysQryResultEx.Create(Application);
    try
    Screen.Cursor:=crSQLWait;
    with frmSysQryResultEx.Query do
    begin
    if Active then Close;
      SQL.Clear;
     lSql:=  ' INSERT INTO  TMP_BOM001(PART,AQTY,BQTY,QBAL) '+
            ' SELECT A.PART,                                '+
            '        SUM(CASE WHEN A.SELE =''A'' THEN A.QTYS END),   '+
            '        SUM(CASE WHEN A.SELE =''B'' THEN A.QTYS END),   '+
            '       (NVL(SUM(CASE WHEN A.SELE =''A'' THEN A.QTYS END),0))-   '+
            '        NVL(SUM(CASE WHEN A.SELE =''B'' THEN A.QTYS END),0)  '+
            '   FROM TMP_BMQ102 A ,IMA_FILE B  '+
            ' WHERE A.PART=B.IMA01 AND B.IMA08=''P'''+
            ' GROUP BY 1                                            '+
            ' HAVING (NVL(SUM(CASE WHEN A.SELE =''A'' THEN A.QTYS END),0))-   '+
            '         NVL(SUM(CASE WHEN A.SELE =''B'' THEN A.QTYS END),0)!=0';

    SQL.Add(lSql);
    ExecSQL;

      if  Active then Close;
      SQL.Clear;
      SQL.Add(Format(
            'SELECT PART,AQTY AS WO%S,BQTY AS BOM%S,QBAL'+
            '  FROM TMP_BOM001 '+
            ' ORDER BY 1' ,[vModea,vModeb]));
      Open;
      Screen.Cursor:=crDefault;
      frmSysQryResultEx.Caption:='abmr691 - WO/BOM 比較查詢作業';
      frmSysQryResultEx.ShowModal;
  end;
  finally
    Screen.Cursor:=crDefault;
    frmSysQryResultEx.Free;
  end;
  end;
end;
end.
