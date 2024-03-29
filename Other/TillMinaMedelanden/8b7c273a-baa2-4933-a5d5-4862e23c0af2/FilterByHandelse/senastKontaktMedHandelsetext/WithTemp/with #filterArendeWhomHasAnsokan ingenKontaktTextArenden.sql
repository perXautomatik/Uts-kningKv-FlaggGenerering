/****** Script for SelectTopNRows command from SSMS  ******/

:r FilterByHendelse/TempfilterArendeWhomHasAnsokan.sql


:r FilterByHendelse/InsertIntoFilterArendeWhomHasAnsokan.sql

with
    senastKontaktMedHandelsetext as (select dianr,
                                             (select top 1 HandelseText
                                              from #filterArendeWhomHasAnsokan as Tinner
                                              where HandelseText is not null
                                                AND (left(rub,len('Kontakt i ärende')) = ('Kontakt i ärende') OR left(rub,len('Information om')) = ('Information om'))
                                                and Tinner.dianr = Touter.dianr
                                              order by dat) as senastKontakt
                                      from #filterArendeWhomHasAnsokan as Touter)
   , senasteHandelseIfallIntoKontakt as (select * from senastKontaktMedHandelsetext where senastKontakt is null )

   , ingenKontaktTextArenden as (select #filterArendeWhomHasAnsokan.dianr,rub,dat from #filterArendeWhomHasAnsokan right join senasteHandelseIfallIntoKontakt on #filterArendeWhomHasAnsokan.dianr = senasteHandelseIfallIntoKontakt.dianr)

   , senasteHendelseOmInteText as (select dianr,(select top 1 rub from ingenKontaktTextArenden as Tinner where Tinner.dianr = Touter.dianr order by dat) as senastRub from #filterArendeWhomHasAnsokan as Touter )

    ,harBeslut as (select distinct dianr , 'beslut' as hasBes from #filterArendeWhomHasAnsokan where rub like '%beslut%' AND rikt = 'Utgående' group by dianr)
    ,harForbud as (select distinct dianr , 'förbud' as hasForb from #filterArendeWhomHasAnsokan where rub = 'Beslut om förbud avlopp' AND rikt = 'Utgående' group by dianr)

   ,SenastInkommande as (select dianr, max(rub) "rub", max(dat) "maxDat", status, has from #filterArendeWhomHasAnsokan where rikt = 'inkommande' group by dianr, status, has)

    select distinct * from ingenKontaktTextArenden

    --where senastKontaktMedHandelsetext.senastKontakt is not null
 order by dianr

