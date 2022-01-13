select fastighet
     , Diarienummer
     , [Utskick har gått till:]
     , till
     , [Lagfaren ägare]
     , adress
     , z.strFastighetsbeteckning
     , z.strFastighetsbeteckning
     , z.strFnrID
     , z.recFastighetID
     , recAerendeID
     , intDiarienummerLoepNummer
     , strDiarienummer
     , strDiarieSerieKod
     , intDiarieAar

from tempExcel.dbo.TestBatchHandelseSkapande
    inner join EDPRemote.EDPVisionRegionGotland.dbo.vwAehAerende z
    on Diarienummer = strDiarienummer

group by recAerendeID, z.strFastighetsbeteckning, z.strFnrID, z.recFastighetID, intDiarieAar, strDiarieSerieKod
       , intDiarienummerLoepNummer, strDiarienummer
