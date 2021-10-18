

select INTDIARIENUMMERLOEPNUMMER, STRFASTIGHETSBETECKNING,STRFNRID
from EDPVisionRegionGotland.dbo.vwAehAerende
where  STRAERENDEMENING = 'Klart vatten - information om avlopp' and INTDIARIEAAR = 2020
ORDER BY STRFNRID desc
