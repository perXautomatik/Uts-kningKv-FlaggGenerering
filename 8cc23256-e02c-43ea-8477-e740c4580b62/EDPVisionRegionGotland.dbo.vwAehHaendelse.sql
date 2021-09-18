
--Så funktionen bör kunna:
--Utifrån en tidsperiod (alltid en månad)
--Få ut alla beslut om enskild avloppsanläggning (via händelse rubrik)
--Skilja på vilka av dessa som är nya och förbättringar (via ärendemening)
-- är det inte altid förra månaden när man gör utsökningen?
-- rubriken bör inte vara fritext
-- vi behöver väta ärendets ansökan för att beta om det är nytt eller förbättrad.
-- det är uppenbart att det inte går att förstå vilken


select
    case when w.strAerendemening = 'Klart vatten - information om avlopp' OR r.ansökan like '%örbättring%' then 'förbättring' else 'ny' end typ,
    w.strDiarienummer,replace(strRubrik,'Beslut om enskild avloppsanläggning','Beslut') typAvBeslut,replace(replace(strAerendemening,'Klart vatten - information om avlopp','KV'),'Ansökan/anmälan om enskild avloppsanläggning','ansökan') strAerendemening, replace(r.ansökan ,'Ansökan/anmälan om enskild avloppsanläggning','ansökan') ansökan
from (
select strDiarienummer,strRubrik,strAerendemening from EDPVisionRegionGotland.dbo.vwAehHaendelse
where year(datHaendelseDatum) = 2020 and month(datHaendelseDatum) = 3
and strRubrik like '%beslut%' and strRubrik like '%avl%' and strEnhetNamn = 'Team Vatten'
) w          left outer join
                    (select z.strRubrik ansökan,q.strDiarienummer from (select strDiarienummer,strRubrik from EDPVisionRegionGotland.dbo.vwAehHaendelse where year(datHaendelseDatum) = 2020 and month(datHaendelseDatum) = 3 and strRubrik like '%beslut%' and strRubrik like '%avl%' and strEnhetNamn = 'Team Vatten' ) q cross apply (select top 1 strRubrik, strDiarienummer from EDPVisionRegionGotland.dbo.vwAehHaendelse where strRubrik like '%an om%' and strDiarienummer = q.strDiarienummer order by year(datHaendelseDatum), month(datHaendelseDatum),day(datHaendelseDatum)) z where q.strDiarienummer = z.strDiarienummer) r
    on r.strDiarienummer = w.strDiarienummer
order by typ


