--:r FilterByHendelse/CreateFilterArendeWhomHasAnsokan.sql
--select * from [edpremote].[EDPVisionRegionGotland].[dbo].vwAehHaendelse

with
     tablex as (SELECT
       q.strDiarienummer dianr,
      q.strFastighetsbeteckning kir,
     coalesce(q.strSignature,strUserVisasSom) as [Handläggarsignatur],
      q.strVisasSom as [Huvudkontakt],
      coalesce(q.strSoekbegrepp,q.strFastighetsbeteckning) as [Sökbegrepp]
      ,q.strAerendemening as [ArendeText],
       q.strAerendeStatusPresent as status,
       coalesce(q.datBeslutsDatum,t.datBeslutsDatum) [Beslutsdatum],
       nullif(strAerendeKommentar,'')  as [Kommentar],
      coalesce(t.intLoepnummer,t.intLoepnummerHaendelse,t.intRecnum) as [Löpnummer],
       datHaendelseDatum as dat,
       recHaendelseKategoriID as [Händelsekategori],

       strRiktning as rikt,
       strRubrik as rub,
      strText as [HandelseText]
     FROM
        EDPVisionRegionGotlandAvlopp.dbo.vwAehAerende q
         left outer join
        EDPVisionRegionGotlandAvlopp.dbo.vwAehHaendelse t
         on t.recAerendeID = q.recAerendeID
         where q.strAerendeStatusPresent != 'Avslutat'
         )
   , utanOnödigaHandlingar as (select *
                               from tablex
                               where
                                     not (rub in ('Mottagningskvitto', N'Uppföljning 2 år från klart vatten utskick'))
                                        And left(rub,len(N'Bekräftelse')) <> (N'Bekräftelse')
                                        And left(rub,len('Besiktning')) <> ('Besiktning')
                                        And left(rub,len('Klart Vatten')) <> ('Klart Vatten')
                                        And left(rub,len(N'Påminnelse om åtgärd')) <> (N'Påminnelse om åtgärd')
                                        AND not(HandelseText is null AND 
					left(rub,len(N'Kontakt i ärende')) = (N'Kontakt i ärende'))
                                        AND not rub like '%Makulerad%'
                                        AND dianr <> '--- Makulerad ---'
                               )
    ,diarienummerMedAnsokan as (select distinct dianr , 'Ansök' as has from utanOnödigaHandlingar where rub like '%ansökan%' AND rikt = 'inkommande' group by dianr)
    INSERT INTO #filterArendeWhomHasAnsokan(dianr, kir, Handläggarsignatur, Huvudkontakt, Sökbegrepp, ArendeText, status, Beslutsdatum, Kommentar, Löpnummer, dat, Händelsekategori, rikt, rub, HandelseText, has)
        select utanOnödigaHandlingar.*,diarienummerMedAnsokan.has 	
	from utanOnödigaHandlingar 
	right join diarienummerMedAnsokan on diarienummerMedAnsokan.dianr = utanOnödigaHandlingar.dianr
