:r FilterByHendelse/CreateFilterArendeWhomHasAnsokan.sql

with
     tablex as (SELECT [Diarienummer]  "dianr",
     [Fastighet]     "kir",
     [Handl�ggarsignatur],
     [Huvudkontakt],
     [S�kbegrepp],
     [ArendeText],
     [Status]        "status",
     [Beslutsdatum],
     [Kommentar],
     [L�pnummer],
     [H�ndelsedatum] "dat",
     [H�ndelsekategori],
     [Riktning]      "rikt",
     [Rubrik]        "rub",
     [HandelseText]
     FROM [tempExcel].[dbo].[4�rsp�m19-11-25])
   , utanOn�digaHandlingar as (select *
                               from tablex
                               where
                                     not (rub in ('Mottagningskvitto', 'Uppf�ljning 2 �r fr�n klart vatten utskick'))
                                        And left(rub,len('Bekr�ftelse')) <> ('Bekr�ftelse')
                                        And left(rub,len('Besiktning')) <> ('Besiktning')
                                        And left(rub,len('Klart Vatten')) <> ('Klart Vatten')
                                        And left(rub,len('P�minnelse om �tg�rd')) <> ('P�minnelse om �tg�rd')
                                        AND not(HandelseText is null AND 
					left(rub,len('Kontakt i �rende')) = ('Kontakt i �rende'))
                                        AND not rub like '%Makulerad%'
                                        AND dianr <> '--- Makulerad ---'
                               )
    ,diarienummerMedAnsokan as (select distinct dianr , 'Ans�k' as has 
    from utanOn�digaHandlingar
     where rub like '%ans�kan%'
      AND rikt = 'inkommande'
       group by dianr)


    INSERT 
    INTO #filterArendeWhomHasAnsokan(dianr, kir, Handl�ggarsignatur, Huvudkontakt, S�kbegrepp, ArendeText, status, 
    Beslutsdatum, Kommentar, L�pnummer, dat, H�ndelsekategori, rikt, rub, HandelseText, 
    has)
        select utanOn�digaHandlingar.*,diarienummerMedAnsokan.has 	
	from utanOn�digaHandlingar 
	right join diarienummerMedAnsokan on diarienummerMedAnsokan.dianr = utanOn�digaHandlingar.dianr
            where not (status = 'Avslutat');