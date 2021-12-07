

--select distinct strDiarienummer,TBAEHAERENDE.recAerendeId,strLocalizationCode FROM TBAEHAERENDELEFT OUTER JOIN DBO.TBAEHAERENDEDATAON DBO.TBAEHAERENDEDATA.RECAERENDEID = DBO.TBAEHAERENDE.RECAERENDEID Where STRAERENDEMENING = 'Klart vatten - information om avlopp' AND strAerendeStatusPresent != 'Avslutat' and strAerendeStatusPresent != 'Makulerat' ORDER BY TBAEHAERENDE.recAerendeId desc

SELECT top 100 * from TBAEHAERENDEDATA ORDER BY RECLASTAERENDESTATUSLOGID desc

SELECT * from TBAEHAERENDE
WHERE
STRDIARIENUMMERSERIE = 'MBNV' and
(INTDIARIENUMMERLOEPNUMMER = 1282 or
INTDIARIENUMMERLOEPNUMMER = 1294)

WHERE strFastighetsbeteckning = 'Follingbo Klinte 1:36' or strFastighetsbeteckning = 'Follingbo Klinte 1:54'