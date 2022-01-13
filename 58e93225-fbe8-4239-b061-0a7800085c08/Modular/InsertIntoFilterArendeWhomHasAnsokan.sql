:r FilterByHendelse/CreateFilterArendeWhomHasAnsokan.sql

with
     tablex as (SELECT [Diarienummer]  "dianr",
     [Fastighet]     "kir",
     [Handläggarsignatur],
     [Huvudkontakt],
     [Sökbegrepp],
     [ArendeText],
     [Status]        "status",
     [Beslutsdatum],
     [Kommentar],
     [Löpnummer],
     [Händelsedatum] "dat",
     [Händelsekategori],
     [Riktning]      "rikt",
     [Rubrik]        "rub",
     [HandelseText]
     FROM [tempExcel].[dbo].[4årspåm19-11-25])
   , utanOnödigaHandlingar as (select *
                               from tablex
                               where
                                     not (rub in ('Mottagningskvitto', 'Uppföljning 2 år från klart vatten utskick'))
                                        And left(rub,len('Bekräftelse')) <> ('Bekräftelse')
                                        And left(rub,len('Besiktning')) <> ('Besiktning')
                                        And left(rub,len('Klart Vatten')) <> ('Klart Vatten')
                                        And left(rub,len('Påminnelse om åtgärd')) <> ('Påminnelse om åtgärd')
                                        AND not(HandelseText is null AND 
					left(rub,len('Kontakt i ärende')) = ('Kontakt i ärende'))
                                        AND not rub like '%Makulerad%'
                                        AND dianr <> '--- Makulerad ---'
                               )
    ,diarienummerMedAnsokan as (select distinct dianr , 'Ansök' as has 
    from utanOnödigaHandlingar
     where rub like '%ansökan%'
      AND rikt = 'inkommande'
       group by dianr)


    INSERT 
    INTO #filterArendeWhomHasAnsokan(dianr, kir, Handläggarsignatur, Huvudkontakt, Sökbegrepp, ArendeText, status, 
    Beslutsdatum, Kommentar, Löpnummer, dat, Händelsekategori, rikt, rub, HandelseText, 
    has)
        select utanOnödigaHandlingar.*,diarienummerMedAnsokan.has 	
	from utanOnödigaHandlingar 
	right join diarienummerMedAnsokan on diarienummerMedAnsokan.dianr = utanOnödigaHandlingar.dianr
            where not (status = 'Avslutat');