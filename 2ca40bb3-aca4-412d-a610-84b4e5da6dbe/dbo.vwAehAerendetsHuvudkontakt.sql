SELECT TOP 501 q.strVisasSom,
               strSammanslagenAdress,
               strOrginisationPersonnummer,
               q.recEnstakaKontaktID,
               strFoeretag,
               strLand,
               q.strPostort,
               q.strGatuadress,
               strCoadress,
               q.strPostnummer,
               strEfternamn,
               strFoernamn,
               u.strDiarienummer,
               f.intLoepnummer,
               f.intDiarienummerLoepNummer
from (select strVisasSom,
             strSammanslagenAdress,
             strOrginisationPersonnummer,
             recEnstakaKontaktID,
             intrecnum,

             strFoeretag,
             strLand,
             strPostort,
             strGatuadress,
             strCoadress,
             strPostnummer,
             strEfternamn,
             strFoernamn,
             0 recHaendelseID,
             t.recAerendeID
      FROM dbo.vwAehAerendeHuvudkontaktperson t

      union
      select strVisasSom,
             strSammanslagenAdress,
             x.strOrganisationsPersonnummer,
             recEnstakaKontaktID,

             x.recEnstakaKontaktID,
             strFoeretag,
             strLand,
             strPostort,
             strGatuadress,
             strCoadress,
             strPostnummer,
             strEfternamn,
             strFoernamn,
             0 recHaendelseID,
             x.recAerendeID

      from dbo.vwAehAerendetsHuvudkontakt x)

union
(select strVisasSom,
        strSammanslagenAdress,
        z.strOrganisationsPersonnummer,
        recEnstakaKontaktID,
        z.recEnstakaKontaktID,
        strFoeretag,
        strLand,
        strPostort,
        strGatuadress,
        strCoadress,
        strPostnummer,
        strEfternamn,
        strFoernamn,
        z.recHaendelseID,
        0 recAerendeID
 from EDPVisionRegionGotland.dbo.vwAehHaendelseHuvudkontakt z
 union
 select strVisasSom,
        strSammanslagenAdress,
        d.strOrginisationPersonnummer,
        recEnstakaKontaktID,
        d.recEnstakaKontaktID,
        strFoeretag,
        strLand,
        strPostort,
        strGatuadress,
        strCoadress,
        strPostnummer,
        strEfternamn,
        strFoernamn,
        d.recHaendelseID,
        0 recAerendeID
 from EDPVisionRegionGotland.dbo.vwAehHaendelseHuvudkontaktperson d)
q
         left outer join EDPVisionRegionGotland.dbo.vwAehAerende u on q.recAerendeID = u.recAerendeID

         left outer join EDPVisionRegionGotland.dbo.vwAehHaendelse f on q.recHaendelseID = f.recHaendelseID