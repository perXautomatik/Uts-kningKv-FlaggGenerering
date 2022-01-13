update resultat set
    dnr= strDiarienummer
from resultat res
inner join
    (select strFastighetsbeteckning,strDiarienummer from [admsql04].[EDPVisionRegionGotland].[dbo].[vwAehAerende]
        where strAerendemening = 'Klart vatten - information om avlopp'
        ) arende
        on arende.strFastighetsbeteckning = res.fastighet