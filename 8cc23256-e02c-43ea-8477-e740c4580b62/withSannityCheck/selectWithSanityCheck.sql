declare @f varchar = 'F�retag';
declare @p varchar = 'Person';


WITH
    FAKTURAMOTTAGAREKONTAKT AS (

SELECT dbo.tbVisFakturaUnderlag.recFakturaUnderlagID, dbo.tbVisFakturaUnderlag.recFakturaUnderlagID AS intRecnum, dbo.tbVisFakturaUnderlag.intFakturaNr, dbo.tbVisFakturaUnderlag.decNettoBelopp, dbo.tbVisFakturaUnderlag.decMomsBelopp, dbo.tbVisFakturaUnderlag.decBruttoBelopp, dbo.tbVisFakturaUnderlag.bolSkickadEkonomiSystem, dbo.tbVisFakturaUnderlag.recEnstakaFakturaMottagareID, dbo.tbVisEnstakaFakturamottagare.intIdNummer, dbo.tbVisFakturaUnderlag.datSkapadDatum, dbo.tbVisEnstakaFakturamottagare.strExterntIdNummer, dbo.tbVisEnstakaFakturamottagare.bolIntern, dbo.tbVisEnstakaFakturamottagare.strSkanningskod, dbo.tbVisEnstakaFakturamottagare.strMotpartKoncernkod, dbo.tbVisEnstakaFakturamottagare.strGLN, dbo.tbVisEnstakaFakturamottagare.strKommun, dbo.tbVisEnstakaFakturamottagare.strReferensnummer, dbo.tbVisEnstakaFakturamottagare.strIntBokfoeringsKonto, dbo.tbVisEnstakaKontakt.strOrginisationPersonnummer, dbo.tbVisEnstakaKontakt.strVisasSom, dbo.tbVisEnstakaKontakt.strGatuadress, dbo.tbVisEnstakaKontakt.strCoadress, dbo.tbVisEnstakaKontakt.strPostnummer, dbo.tbVisEnstakaKontakt.strPostort, dbo.tbVisEnstakaKontakt.strLand,
-- this looks very resourceheavy, better with join?
       CAST(iif(((SELECT COUNT(*) FROM tbVisFakturaFilFakturaUnderlag WHERE recFakturaUnderlagID = dbo.tbVisFakturaUnderlag.recFakturaUnderlagID) > 0),
         '1','0') AS bit) AS 'bolSkrivenTillFakturaFil',

       CASE
       WHEN (isPers AND ISNULL(strFoeretag, '') <> '')                THEN (dbo.tbVisEnstakaKontakt.strEfternamn + ', ' + dbo.tbVisEnstakaKontakt.strFoernamn) + ' (' + dbo.tbVisEnstakaKontakt.strFoeretag + ')'
       WHEN (isPers AND ISNULL(strFoeretag, '') = '')                 THEN (dbo.tbVisEnstakaKontakt.strEfternamn + ', ' + dbo.tbVisEnstakaKontakt.strFoernamn)
       WHEN (isForetag AND (forEft IS NOT NULL AND forEft <> '')) THEN dbo.tbVisEnstakaKontakt.strFoeretag + ' (' + dbo.tbVisEnstakaKontakt.strEfternamn + ', ' + dbo.tbVisEnstakaKontakt.strFoernamn  + ')'
       WHEN (isForetag AND (forEft IS NULL OR forEft = ''))       THEN (dbo.tbVisEnstakaKontakt.strFoeretag)
       ELSE
                       strVisasSom
       END as strVisasSomEfternamnFoerst,


       CASE
       WHEN isPers   THEN ISNULL(dbo.tbVisEnstakaKontakt.strEfternamn, '') + ISNULL(', ' + dbo.tbVisEnstakaKontakt.strFoernamn, '')
       WHEN isForetag THEN dbo.tbVisEnstakaKontakt.strFoeretag
       ELSE
         strVisasSom
       END AS strEfternamnFoernamn,

       CASE
       WHEN isPers
         THEN ISNULL(dbo.tbVisEnstakaKontakt.strFoernamn + ' ', '') + ISNULL(dbo.tbVisEnstakaKontakt.strEfternamn, '')
       WHEN isForetag
         THEN dbo.tbVisEnstakaKontakt.strFoeretag
       ELSE
         strVisasSom
       END AS strFoernamnEfternamn,
       strKontaktTyp,
       strFoernamn,
       strEfternamn,
       strFoeretag

FROM (select (strKontaktTyp = @p) isPers,(strKontaktTyp = @f) isForetag,(strFoernamn + strEfternamn) forEft,* from  dbo.tbVisFakturaUnderlag) q
LEFT OUTER JOIN dbo.tbVisEnstakaFakturamottagare
  ON dbo.tbVisEnstakaFakturamottagare.recEnstakaFakturamottagareID = dbo.tbVisFakturaUnderlag.recEnstakaFakturaMottagareID
LEFT OUTER JOIN dbo.tbVisEnstakaKontakt
  ON dbo.tbVisEnstakaKontakt.recEnstakaKontaktID = dbo.tbVisEnstakaFakturamottagare.recEnstakaKontaktID
    )
    ,
    CTE AS (
		 SELECT RECAERENDEID, INTMINUTER
		 FROM TBVISTIDPOST
		 WHERE RECAERENDEID IS NOT NULL

		 UNION ALL

		 SELECT TBVISTIDPOST.RECAERENDEID, INTMINUTER
		 FROM TBVISTIDPOST
		     INNER JOIN TBAEHAERENDEHAENDELSE
		     ON TBAEHAERENDEHAENDELSE.RECHAENDELSEID = TBVISTIDPOST.RECHAENDELSEID
		     INNER JOIN DBO.TBAEHAERENDE
		     ON TBAEHAERENDE.RECAERENDEID = TBAEHAERENDEHAENDELSE.RECAERENDEID
		 WHERE TBVISTIDPOST.RECAERENDEID IS NULL
	     ),
    vwAehAerendeTotaltid AS
	(


	 SELECT RECAERENDEID
	      , CAST(SUM(INTMINUTER) / 60 AS VARCHAR) + ':' +
		RIGHT('0' + CAST(SUM(INTMINUTER) % 60 AS VARCHAR), 2) AS STRSUMMATIDPOSTER
	 FROM CTE
	 GROUP BY RECAERENDEID
	)
   ,
    GALLRAT   AS (SELECT Max(DATDATUM) AS DATGALLRAT, RECAERENDEID
		  FROM TBAEHAERENDESTATUSLOG
		  WHERE RECAERENDESTATUSLOGTYPID IN
			(SELECT RECAERENDESTATUSLOGTYPID
			 FROM TBAEHAERENDESTATUSLOGTYP
			 WHERE STRAERENDESTATUSLOGTYP = 'Gallrat')
		  GROUP BY RECAERENDEID
    )
  , ARKIVERAT AS (SELECT Max(DATDATUM) AS DATARKIVERAT, RECAERENDEID
		  FROM TBAEHAERENDESTATUSLOG
		  WHERE RECAERENDESTATUSLOGTYPID IN
			(SELECT RECAERENDESTATUSLOGTYPID
			 FROM TBAEHAERENDESTATUSLOGTYP
			 WHERE STRAERENDESTATUSLOGTYP = 'Arkiverat')
		  GROUP BY RECAERENDEID
)
, va AS (
SELECT DBO.TBAEHAERENDE.RECAERENDEID
     , DBO.TBAEHAERENDE.STRDIARIENUMMERSERIE
     , DBO.TBAEHAERENDE.INTDIARIENUMMERLOEPNUMMER
     , DBO.TBAEHAERENDEDATA.STRDIARIENUMMER
     , DBO.TBAEHAERENDE.STRAERENDEMENING
     , DBO.TBAEHAERENDE.STRSOEKBEGREPP
     , DBO.TBAEHAERENDE.STRAERENDEKOMMENTAR
     , DBO.TBAEHAERENDE.RECFOERVALTNINGID
     , DBO.TBAEHAERENDE.RECENHETID
     , DBO.TBAEHAERENDE.RECAVDELNINGID
     , DBO.TBAEHAERENDE.RECEXTERNTID
     , DBO.TBAEHAERENDE.RECDIARIEAARSSERIEID
     , DBO.TBAEHAERENDE.STRPUBLICERING
     , DBO.TBAEHAERENDEDATA.RECLASTAERENDESTATUSLOGID
     , DBO.TBAEHAERENDE.RECAERENDEID                                       AS INTRECNUM
     , DBO.TBAEHAERENDEDATA.STRFASTIGHETSBETECKNING
     , DBO.TBAEHAERENDEDATA.STRFNRID
     , DBO.TBAEHAERENDEDATA.RECFASTIGHETID
     , DBO.TBAEHAERENDE.DATINKOMDATUM
     , DBO.TBAEHAERENDEDATA.DATDATUM
     , DBO.TBAEHAERENDEDATA.STRLOGKOMMENTAR
     , DBO.TBAEHAERENDEDATA.STRAERENDESTATUSPRESENT
     , DBO.TBAEHAERENDEDATA.STRLOCALIZATIONCODE
     , DBO.TBAEHAERENDEDATA.STRSIGNATURE
     , DBO.TBEDPUSER.STRUSERFIRSTNAME + ' ' + DBO.TBEDPUSER.STRUSERSURNAME AS STRUSERVISASSOM
     , DBO.TBAEHAERENDEDATA.INTUSERID
     , DBO.TBAEHAERENDEDATA.RECDIARIESERIEID
     , DBO.TBAEHAERENDEDATA.INTDIARIEAAR
     , DBO.TBAEHAERENDEDATA.INTSERIESTARTVAERDE
     , DBO.TBAEHAERENDEDATA.STRDIARIESERIEKOD
     , DBO.TBAEHAERENDEDATA.STRSEKRETESS
     , DBO.TBAEHAERENDEDATA.STRBEGRAENSA
     , DBO.TBAEHAERENDEDATA.STRSEKRETESSMYNDIGHET
     , DBO.TBAEHAERENDEDATA.DATSEKRETESSDATUM
     , DBO.TBAEHAERENDE.RECPROJEKTID
     , DBO.TBAEHAERENDEDATA.RECENSTAKAKONTAKTID
     , DBO.TBAEHAERENDEDATA.STRVISASSOM
     , DBO.TBAEHAERENDEDATA.STRGATUADRESS
     , DBO.TBAEHAERENDEDATA.STRPOSTNUMMER
     , DBO.TBAEHAERENDEDATA.STRPOSTORT
     , DBO.TBAEHAERENDEDATA.STRROLL
     , DBO.TBAEHAERENDEDATA.RECKONTAKTROLLID
     , DBO.TBAEHAERENDEDATA.RECAERENDEENSTAKAKONTAKTID
     , EDPVisionRegionGotland.dbo.tbAehAerendeEnstakaFakturamottagare.recEnstakaFakturamottagareID
     , DBO.TBAEHAERENDE.RECKOMMUNID
     , DBO.TBAEHPROJEKT.STRPROJEKTNAMN
     , DBO.TBAEHHAENDELSEBESLUT.DATBESLUTSDATUM
     , DBO.TBAEHHAENDELSEBESLUT.STRBESLUTSNUMMER
     , DBO.TBAEHHAENDELSEBESLUT.STRBESLUTSUTFALL
     , DBO.TBAEHHAENDELSEBESLUT.RECHAENDELSEID
     , DBO.TBAEHHAENDELSEBESLUT.RECHAENDELSEBESLUTID
     , DBO.TBAEHAERENDETYP.STRAERENDETYP
     , DBO.TBAEHAERENDETYP.STRAERENDEKATEGORI
     , DBO.TBAEHAERENDETYP.STRAERENDETYPKOD
     , DBO.TBAEHAERENDETYP.RECAERENDETYPID
     , DBO.TBAEHAERENDETYP.BOLKOMPLETTAERENDE
     , DBO.TBVISENHET.STRENHETNAMN
     , DBO.TBVISENHET.STRENHETKOD
     , DBO.TBVISFOERVALTNING.STRFOERVALTNINGNAMN
     , DBO.TBVISFOERVALTNING.STRFOERVALTNINGKOD
     , DBO.TBVISAVDELNING.STRAVDELNINGKOD
     , DBO.TBVISAVDELNING.STRAVDELNINGNAMN
     , FAKTURAMOTTAGAREKONTAKT.STRVISASSOM                                 AS STRFAKTURAMOTTAGARE
     , DBO.TBVISKOMMUN.STRKOMMUNNAMN
     , DBO.TBAEHAERENDEDATA.DATKOMPLETT
     , DATMOETESDATUM
     , DBO.TBAEHHAENDELSEBESLUT.INTARBETSDAGAR
     , VWAEHAERENDETOTALTID.STRSUMMATIDPOSTER
     , DBO.TBAEHAERENDE.RECEXTERNTJAENSTID
     , DBO.TBVISEXTERNTJAENST.STREXTERNTJAENST
     , DBO.TBVISEXTERNTJAENST.STRETJAENSTNAMN
     , TBAEHHAENDELSE.DATHAENDELSEDATUM                                AS DATBESLUTEXPEDIERAT
     , GALLRAT.DATGALLRAT
     , ARKIVERAT.DATARKIVERAT

FROM DBO.TBAEHAERENDE
    	LEFT OUTER JOIN
    DBO.TBAEHAERENDEDATA
        	ON DBO.TBAEHAERENDEDATA.RECAERENDEID = DBO.TBAEHAERENDE.RECAERENDEID
    	LEFT OUTER JOIN
    DBO.TBAEHPROJEKT
        	ON DBO.TBAEHAERENDE.RECPROJEKTID = DBO.TBAEHPROJEKT.RECPROJEKTID
    	LEFT OUTER JOIN
    DBO.TBAEHHAENDELSEBESLUT
	 	ON DBO.TBAEHAERENDE.RECLASTHAENDELSEBESLUTID = DBO.TBAEHHAENDELSEBESLUT.RECHAENDELSEBESLUTID
    	LEFT OUTER JOIN
    DBO.TBAEHAERENDETYP
        ON DBO.TBAEHAERENDE.RECAERENDETYPID = DBO.TBAEHAERENDETYP.RECAERENDETYPID
	LEFT OUTER JOIN
    VWAEHAERENDETOTALTID on tbAehAerende.RECAERENDEID = VWAEHAERENDETOTALTID.RECAERENDEID
	LEFT OUTER JOIN
    dbo.TBEDPUSER
	ON dbo.TBEDPUSER.INTUSERID = DBO.TBAEHAERENDEDATA.INTUSERID
    	LEFT OUTER JOIN
    TBVISENHET on dbo.TBAEHAERENDE.RECENHETID = TBVISENHET.RECENHETID
	LEFT OUTER JOIN DBO.TBVISFOERVALTNING
	on dbo.TBAEHAERENDE.RECFOERVALTNINGID = TBVISFOERVALTNING.RECFOERVALTNINGID
LEFT OUTER JOIN tbvisavdelning
	on TBAEHAERENDE.RECAVDELNINGID = TBVISAVDELNING.RECAVDELNINGID
LEFT OUTER JOIN EDPVisionRegionGotland.dbo.tbAehAerendeEnstakaFakturamottagare
    on TBAEHAERENDE.RECAERENDEID = TBAEHAERENDEENSTAKAFAKTURAMOTTAGARE.RECAERENDEID
LEFT OUTER JOIN FAKTURAMOTTAGAREKONTAKT
	on tbAehAerendeEnstakaFakturamottagare.recEnstakaFakturamottagareID = FAKTURAMOTTAGAREKONTAKT.RECENSTAKAFAKTURAMOTTAGAREID
LEFT OUTER JOIN dbo.TBVISKOMMUN
    ON TBVISKOMMUN.RECKOMMUNID = tbAehAerende.RECKOMMUNID
LEFT OUTER JOIN
    DBO.TBVISEXTERNTJAENST on TBVISEXTERNTJAENST.RECEXTERNTJAENSTID = tbAehAerende.RECEXTERNTJAENSTID
LEFT OUTER JOIN
    dbo.TBAEHAERENDEHAENDELSE
        on TBAEHAERENDE.RECAERENDEID = dbo.TBAEHAERENDEHAENDELSE.RECAERENDEID
LEFT outer JOIN
    (select rechaendelseid,max(dathaendelsedatum) dathaendelsedatum from  DBO.TBAEHHAENDELSE WHERE DBO.TBAEHHAENDELSE.STRRUBRIK like 'beslut%' GROUP BY rechaendelseid ) TBAEHHAENDELSE
        on dbo.TBAEHAERENDEHAENDELSE.RECAERENDEHAENDELSEID = TBAEHHAENDELSE.RECHAENDELSEID
left OUTER JOIN GALLRAT
    on GALLRAT.RECAERENDEID = TBAEHAERENDE.RECAERENDEID

   LEFT OUTER JOIN
     ARKIVERAT
	on ARKIVERAT.RECAERENDEID  = TBAEHAERENDE.RECAERENDEID

    )

SELECT *from va WHERE strFastighetsbeteckning = 'Follingbo Klinte 1:36' or strFastighetsbeteckning = 'Follingbo Klinte 1:54'


select distinct strDiarienummer,TBAEHAERENDE.recAerendeId,strLocalizationCode FROM TBAEHAERENDE
    LEFT OUTER JOIN DBO.TBAEHAERENDEDATA
        ON DBO.TBAEHAERENDEDATA.RECAERENDEID = DBO.TBAEHAERENDE.RECAERENDEID Where STRAERENDEMENING = 'Klart vatten - information om avlopp' AND strAerendeStatusPresent != 'Avslutat' and strAerendeStatusPresent != 'Makulerat' ORDER BY TBAEHAERENDE.recAerendeId desc

--SELECT top 100 * from TBAEHAERENDEDATA ORDER BY RECLASTAERENDESTATUSLOGID desc