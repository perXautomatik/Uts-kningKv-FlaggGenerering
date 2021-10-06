select * from (select *, row_number() over (partition by strDiarienummer order by dat desc) senaste from
(
select

       strDiarienummer, beteckning, rubrik, strText,
        case when strText is null
            then datHaendelseDatum
            else cast(datHaendelseDatum as int) +1000
            end dat

from (select a.strDiarienummer,a.beteckning,
             case
       when (strRubrik = 'Klart vatten - information om avlopp' OR strRubrik = 'Klart vatten information om avlopp') then N'först. utskick' else handelse.strRubrik end rubrik,
             replace(         handelse.strText,'\n','') strText,
             handelse.datHaendelseDatum
      from (select * from (select * from (select *,case when beteckning like '%ollingbo%' then 'Follingbo' when beteckning like '%ejdeby%' then 'Hejdeby' when beteckning like '%okrume%' then 'Lokrume' when beteckning like '%artebo%' then 'Martebo' when beteckning like N'%räkumla%' then 'Martebo' when beteckning like '%isby%' then 'Martebo' when beteckning like N'%ästerhejde%' then 'Martebo' end socken from (select recAerendeID,strDiarienummer,strAerendemening,strAerendeKommentar,case when strFnrID is null AND  strSoekbegrepp <> strFastighetsbeteckning then case when strFastighetsbeteckning is null then strSoekbegrepp when strSoekbegrepp is null then  strFastighetsbeteckning when strSoekbegrepp like concat('%',strFastighetsbeteckning,'%') then strSoekbegrepp else  concat(strSoekbegrepp,' // ',strFastighetsbeteckning) end else strFastighetsbeteckning end beteckning
        ,strFnrID,strAerendeStatusPresent,strVisasSom,strGatuadress,strPostnummer,strPostort,strProjektNamn,datBeslutsDatum,strBeslutsutfall,strAerendeTyp,strAerendekategori,strAerendetypKod,strEnhetNamn,strEnhetKod,strFoervaltningNamn,strFoervaltningKod,strAvdelningKod,strAvdelningNamn

        from (select * from EDPVisionRegionGotland.dbo.vwAehAerende where strEnhetKod = 'Vatten' and strAerendeStatusPresent <> 'Avslutat') w where strAerendemening like 'Klart Vatten%') q) z where socken is not null) arenden except

        select * from (select * from (select *,case when beteckning like '%ollingbo%' then 'Follingbo' when beteckning like '%ejdeby%' then 'Hejdeby' when beteckning like '%okrume%' then 'Lokrume' when beteckning like '%artebo%' then 'Martebo' when beteckning like N'%räkumla%' then 'Martebo' when beteckning like '%isby%' then 'Martebo' when beteckning like N'%ästerhejde%' then 'Martebo' end socken from (select recAerendeID,strDiarienummer,strAerendemening,strAerendeKommentar,case when strFnrID is null AND  strSoekbegrepp <> strFastighetsbeteckning then case when strFastighetsbeteckning is null then strSoekbegrepp when strSoekbegrepp is null then  strFastighetsbeteckning when strSoekbegrepp like concat('%',strFastighetsbeteckning,'%') then strSoekbegrepp else  concat(strSoekbegrepp,' // ',strFastighetsbeteckning) end else strFastighetsbeteckning end beteckning,strFnrID,strAerendeStatusPresent,strVisasSom,strGatuadress,strPostnummer,strPostort,strProjektNamn,datBeslutsDatum,strBeslutsutfall,strAerendeTyp,strAerendekategori,strAerendetypKod,strEnhetNamn,strEnhetKod,strFoervaltningNamn,strFoervaltningKod,strAvdelningKod,strAvdelningNamn from (select * from EDPVisionRegionGotland.dbo.vwAehAerende where strEnhetKod = 'Vatten' and strAerendeStatusPresent <> 'Avslutat' ) w where strAerendemening like 'Klart Vatten%') q) z where socken is not null) arenden

        where arenden.recAerendeID in (
        (select recAerendeID from EDPVisionRegionGotland.dbo.vwAehHaendelse
        where strRubrik
        in(N'Reviderad ansökan ensklit avlopp',N'Reviderad ansökan',N'Kompletteringsbegäran skickad',N'Kompletteringsbegäran','Komplettering-situationsplan','Komplettering, situationsplan','Komplettering',N'Komplett ansökan',N'Information om- Komplettering av ansökan begärd',N'Beslut om enskild avloppsanläggning BDT+ WC',N'Beslut om enskild avloppsanläggning BDT + Tank',N'Besiktningsprotokoll – provgrop',N'Avlopp - utförandeintyg',N'Ansökan/anmälan om enskild avloppsanläggning',N'Ansökan med underskrift')
        ))

            ) a left outer join EDPVisionRegionGotland.dbo.vwAehHaendelse handelse on a.recAerendeID = handelse.recAerendeID) q1
     --where strRubrik <> 'Klart vatten - information om avlopp' and strRubrik <> 'Klart vatten information om avlopp'
) q2) q
where senaste = 1
order by strDiarienummer,q.dat
