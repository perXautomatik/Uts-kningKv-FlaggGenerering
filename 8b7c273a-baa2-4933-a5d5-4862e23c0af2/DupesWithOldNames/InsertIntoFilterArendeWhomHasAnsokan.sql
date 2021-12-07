--:r FilterByHendelse/CreateFilterArendeWhomHasAnsokan.sql
--select * from [edpremote].[EDPVisionRegionGotland].[dbo].vwAehHaendelse

with
     tablex as (SELECT
       q.strDiarienummer dianr,
      q.strFastighetsbeteckning kir,
     coalesce(q.strSignature,strUserVisasSom) as [Handl�ggarsignatur],
      q.strVisasSom as [Huvudkontakt],
      coalesce(q.strSoekbegrepp,q.strFastighetsbeteckning) as [S�kbegrepp]
      ,q.strAerendemening as [ArendeText],
       q.strAerendeStatusPresent as status,
       coalesce(q.datBeslutsDatum,t.datBeslutsDatum) [Beslutsdatum],
       nullif(strAerendeKommentar,'')  as [Kommentar],
      coalesce(t.intLoepnummer,t.intLoepnummerHaendelse,t.intRecnum) as [L�pnummer],
       datHaendelseDatum as dat,
       recHaendelseKategoriID as [H�ndelsekategori],

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
   , utanOn�digaHandlingar as (select *
                               from tablex
                               where
                                     not (rub in ('Mottagningskvitto', N'Uppf�ljning 2 �r fr�n klart vatten utskick'))
                                        And left(rub,len(N'Bekr�ftelse')) <> (N'Bekr�ftelse')
                                        And left(rub,len('Besiktning')) <> ('Besiktning')
                                        And left(rub,len('Klart Vatten')) <> ('Klart Vatten')
                                        And left(rub,len(N'P�minnelse om �tg�rd')) <> (N'P�minnelse om �tg�rd')
                                        AND not(HandelseText is null AND 
					left(rub,len(N'Kontakt i �rende')) = (N'Kontakt i �rende'))
                                        AND not rub like '%Makulerad%'
                                        AND dianr <> '--- Makulerad ---'
                               )
    ,diarienummerMedAnsokan as (select distinct dianr , 'Ans�k' as has from utanOn�digaHandlingar where rub like '%ans�kan%' AND rikt = 'inkommande' group by dianr)
    INSERT INTO #filterArendeWhomHasAnsokan(dianr, kir, Handl�ggarsignatur, Huvudkontakt, S�kbegrepp, ArendeText, status, Beslutsdatum, Kommentar, L�pnummer, dat, H�ndelsekategori, rikt, rub, HandelseText, has)
        select utanOn�digaHandlingar.*,diarienummerMedAnsokan.has 	
	from utanOn�digaHandlingar 
	right join diarienummerMedAnsokan on diarienummerMedAnsokan.dianr = utanOn�digaHandlingar.dianr
