--Så funktionen bör kunna:
--Utifrån en tidsperiod (alltid en månad)
--Få ut alla beslut om enskild avloppsanläggning (via händelse rubrik)
--Skilja på vilka av dessa som är nya och förbättringar (via ärendemening)
-- är det inte altid förra månaden när man gör utsökningen?
-- antal va ansökningar
-- tanke, borde verkligen ärenden skapas som endast existerar för att avslutas, så som till kännedom etc, borde det inte vara en hndelse till ett objekt eller liknande?
-- ärendenmeningar borde saneras, de borde inte kunna fyllas i med fritext eller.. återigen, är det nödvändigt att meningen är unik.
-- tex anmälan om skadad räv, är det något som behöver sökas ut eller borde det snarare vara, anmälan om skadat djur?
-- med beskrvning = räv

select count(datInkomDatum) nr, EDPVisionRegionGotland.dbo.vwAehAerende.strAerendemening
from EDPVisionRegionGotland.dbo.vwAehAerende
where year(datInkomDatum) = 2020 and month(datInkomDatum) = 3
group by year(datInkomDatum), month(datInkomDatum), EDPVisionRegionGotland.dbo.vwAehAerende.strAerendemening
order by year(datInkomDatum) desc, month(datInkomDatum) desc, nr desc