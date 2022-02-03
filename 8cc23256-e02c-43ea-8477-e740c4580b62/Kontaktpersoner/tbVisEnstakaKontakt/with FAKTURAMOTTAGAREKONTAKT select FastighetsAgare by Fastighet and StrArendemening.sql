declare @f varchar(max) ='Företag';
declare @p varchar(max) ='Person';

SELECT *from va WHERE strFastighetsbeteckning = 'Follingbo Klinte 1:36' or strFastighetsbeteckning = 'Follingbo Klinte 1:54'


select distinct strDiarienummer,TBAEHAERENDE.recAerendeId,strLocalizationCode FROM TBAEHAERENDE
    LEFT OUTER JOIN DBO.TBAEHAERENDEDATA
        ON DBO.TBAEHAERENDEDATA.RECAERENDEID = DBO.TBAEHAERENDE.RECAERENDEID Where STRAERENDEMENING = 'Klart vatten - information om avlopp' AND strAerendeStatusPresent != 'Avslutat' and strAerendeStatusPresent != 'Makulerat' ORDER BY TBAEHAERENDE.recAerendeId desc

--SELECT top 100 * from TBAEHAERENDEDATA ORDER BY RECLASTAERENDESTATUSLOGID desc
