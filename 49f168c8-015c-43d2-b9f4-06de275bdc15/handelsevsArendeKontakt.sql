select *
from (select handelse.strVisasSom,
             handelse.strSammanslagenAdress,
             handelse.strOrginisationPersonnummer,
             arende.recEnstakaKontaktID,
             handelse.strFoeretag,
             handelse.strLand,
             handelse.strPostort,
             handelse.strGatuadress,
             handelse.strCoadress,
             handelse.strPostnummer,
             handelse.strEfternamn,
             handelse.strFoernamn,
             arende.strDiarienummer,
             handelse.intDiarienummerLoepNummer
      from (select h.strVisasSom,
                   h.strSammanslagenAdress,
                   h.strOrginisationPersonnummer,
                   h.recEnstakaKontaktID,
                   h.strFoeretag,
                   h.strLand,
                   h.strPostort,
                   h.strGatuadress,
                   h.strCoadress,
                   h.strPostnummer,
                   h.strEfternamn,
                   h.strFoernamn,
                   strDiarienummer,
                   intDiarienummerLoepNummer
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
                  from dbo.vwAehAerendetsHuvudkontakt x) h
                     inner join EDPVisionRegionGotland.dbo.vwAehHaendelse k
                                on h.recHaendelseID = k.recHaendelseID) handelse
               left outer join (select k.strVisasSom,
                                       strSammanslagenAdress,
                                       k.strOrganisationsPersonnummer,
                                       k.recEnstakaKontaktID,
                                       strFoeretag,
                                       strLand,
                                       k.strPostort,
                                       k.strGatuadress,
                                       strCoadress,
                                       k.strPostnummer,
                                       strEfternamn,
                                       strFoernamn,
                                       strDiarienummer,
                                       intDiarienummerLoepNummer
                                from EDPVisionRegionGotland.dbo.vwAehAerende a
                                         inner join
                                     (select strVisasSom,
                                             strSammanslagenAdress,
                                             z.strOrganisationsPersonnummer,
                                             recEnstakaKontaktID,
                                             0 wsq,
                                             strFoeretag,
                                             strLand,
                                             strPostort,
                                             strGatuadress,
                                             strCoadress,
                                             strPostnummer,
                                             strEfternamn,
                                             strFoernamn,
                                             recHaendelseID,
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
                                      from EDPVisionRegionGotland.dbo.vwAehHaendelseHuvudkontaktperson d) k
                                     on a.recAerendeID = k.recAerendeID) arende
                               on handelse.strDiarienummer = arende.strDiarienummer and
                                  handelse.recEnstakaKontaktID = arende.recEnstakaKontaktID) qa
union

select *
from (
         select k.strVisasSom,
                strSammanslagenAdress,
                strOrginisationPersonnummer,
                k.recEnstakaKontaktID,
                strFoeretag,
                strLand,
                k.strPostort,
                k.strGatuadress,
                strCoadress,
                k.strPostnummer,
                strEfternamn,
                strFoernamn,
                strDiarienummer,
                intDiarienummerLoepNummer
         from EDPVisionRegionGotland.dbo.vwAehAerende a
                  inner join dbo.vwAehAerendeHuvudkontaktperson k on a.recAerendeID = k.recAerendeId
             except
         select strVisasSom,
                strSammanslagenAdress,
                strOrginisationPersonnummer,
                recEnstakaKontaktID,
                strFoeretag,
                strLand,
                strPostort,
                strGatuadress,
                strCoadress,
                strPostnummer,
                strEfternamn,
                strFoernamn,
                strDiarienummer,
                intDiarienummerLoepNummer
         from (select strVisasSom,
                      strSammanslagenAdress,
                      strOrginisationPersonnummer,
                      arende.recEnstakaKontaktID,
                      strFoeretag,
                      strLand,
                      strPostort,
                      strGatuadress,
                      strCoadress,
                      strPostnummer,
                      strEfternamn,
                      strFoernamn,
                      arende.strDiarienummer,
                      intDiarienummerLoepNummer
               from (select h.strDiarienummer, h.recEnstakaKontaktID
                     from EDPVisionRegionGotland.dbo.vwAehHaendelse h
                              inner join EDPVisionRegionGotland.dbo.vwAehHaendelseHuvudkontaktperson k
                                         on h.recHaendelseID = k.recHaendelseID) handelse
                        left outer join
                    (select k.strVisasSom,
                            strSammanslagenAdress,
                            strOrginisationPersonnummer,
                            k.recEnstakaKontaktID,
                            strFoeretag,
                            strLand,
                            k.strPostort,
                            k.strGatuadress,
                            strCoadress,
                            k.strPostnummer,
                            strEfternamn,
                            strFoernamn,
                            strDiarienummer,
                            intDiarienummerLoepNummer
                     from EDPVisionRegionGotland.dbo.vwAehAerende a
                              inner join dbo.vwAehAerendeHuvudkontaktperson k on a.recAerendeID = k.recAerendeID) arende
                    on handelse.strDiarienummer = arende.strDiarienummer and
                       handelse.recEnstakaKontaktID = arende.recEnstakaKontaktID) arendes
     ) arende
