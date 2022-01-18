--dbo.vwAehHaendelse
--dbo.vwAehHaendelseHuvudkontakt
--dbo.vwAehHaendelseHuvudkontaktperson

--dbo.vwAehAerende
--dbo.vwAehAerendeHuvudkontaktperson
--dbo.vwAehAerendetsHuvudkontakt
--

with ARhdkon_U_hdKonperson as (select strVisasSom,strSammanslagenAdress,strOrginisationPersonnummer,recEnstakaKontaktID,intrecnum,strFoeretag,strLand,strPostort,strGatuadress,strCoadress,strPostnummer,strEfternamn,strFoernamn,0 recHaendelseID,t.recAerendeID FROM dbo.vwAehAerendeHuvudkontaktperson t union select strVisasSom,strSammanslagenAdress,x.strOrganisationsPersonnummer,recEnstakaKontaktID,x.recEnstakaKontaktID,strFoeretag,strLand,strPostort,strGatuadress,strCoadress,strPostnummer,strEfternamn,strFoernamn,0 recHaendelseID,x.recAerendeID from dbo.vwAehAerendetsHuvudkontakt x),
     Haehdkon_U_hdkonPerson as (select strVisasSom,strSammanslagenAdress,z.strOrganisationsPersonnummer,recEnstakaKontaktID,0 wsq,strFoeretag,strLand,strPostort,strGatuadress,strCoadress,strPostnummer,strEfternamn,strFoernamn,recHaendelseID,0 recAerendeID from dbo.vwAehHaendelseHuvudkontakt z union select strVisasSom,strSammanslagenAdress,d.strOrginisationPersonnummer,recEnstakaKontaktID,d.recEnstakaKontaktID,strFoeretag,strLand,strPostort,strGatuadress,strCoadress,strPostnummer,strEfternamn,strFoernamn,d.recHaendelseID,0 recAerendeID from dbo.vwAehHaendelseHuvudkontaktperson d),
     Haehdkon_U_hdkonPerson_Ij_Aerende as (select Haehdkon_U_hdkonPerson.strVisasSom,strSammanslagenAdress,Haehdkon_U_hdkonPerson.strOrganisationsPersonnummer,Haehdkon_U_hdkonPerson.recEnstakaKontaktID,strFoeretag,strLand,Haehdkon_U_hdkonPerson.strPostort,Haehdkon_U_hdkonPerson.strGatuadress,strCoadress,Haehdkon_U_hdkonPerson.strPostnummer,strEfternamn,strFoernamn,strDiarienummer,intDiarienummerLoepNummer from EDPVisionRegionGotlandTest2.dbo.vwAehAerende a inner join Haehdkon_U_hdkonPerson on a.recAerendeID = Haehdkon_U_hdkonPerson.recAerendeID),
     ARhdkon_U_hdKonperson_Ij_Hand as (select ARhdkon_U_hdKonperson.strVisasSom,ARhdkon_U_hdKonperson.strSammanslagenAdress,ARhdkon_U_hdKonperson.strOrginisationPersonnummer,ARhdkon_U_hdKonperson.recEnstakaKontaktID,ARhdkon_U_hdKonperson.strFoeretag,ARhdkon_U_hdKonperson.strLand,ARhdkon_U_hdKonperson.strPostort,ARhdkon_U_hdKonperson.strGatuadress,ARhdkon_U_hdKonperson.strCoadress,ARhdkon_U_hdKonperson.strPostnummer,ARhdkon_U_hdKonperson.strEfternamn,ARhdkon_U_hdKonperson.strFoernamn,strDiarienummer,intDiarienummerLoepNummer from ARhdkon_U_hdKonperson inner join EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse k on ARhdkon_U_hdKonperson.recHaendelseID = k.recHaendelseID), 
     arende_Ij_AehAerendeHuvudkontaktperson as (select k.strVisasSom,strSammanslagenAdress,strOrginisationPersonnummer,k.recEnstakaKontaktID,strFoeretag,strLand,k.strPostort,k.strGatuadress,strCoadress,k.strPostnummer,strEfternamn,strFoernamn,strDiarienummer,intDiarienummerLoepNummer from dbo.vwAehAerende a inner join dbo.vwAehAerendeHuvudkontaktperson k on a.recAerendeID = k.recAerendeID),
     handelse_Ij_HaendelseHuvudkontaktperson as (select h.strDiarienummer, h.recEnstakaKontaktID from EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse h inner join EDPVisionRegionGotlandTest2.dbo.vwAehHaendelseHuvudkontaktperson k on h.recHaendelseID = k.recHaendelseID)
select *
from (                                          select ARhdkon_U_hdKonperson_Ij_Hand.strVisasSom,ARhdkon_U_hdKonperson_Ij_Hand.strSammanslagenAdress,ARhdkon_U_hdKonperson_Ij_Hand.strOrginisationPersonnummer,Haehdkon_U_hdkonPerson_Ij_Aerende.recEnstakaKontaktID,ARhdkon_U_hdKonperson_Ij_Hand.strFoeretag,ARhdkon_U_hdKonperson_Ij_Hand.strLand,ARhdkon_U_hdKonperson_Ij_Hand.strPostort,ARhdkon_U_hdKonperson_Ij_Hand.strGatuadress,ARhdkon_U_hdKonperson_Ij_Hand.strCoadress,ARhdkon_U_hdKonperson_Ij_Hand.strPostnummer,ARhdkon_U_hdKonperson_Ij_Hand.strEfternamn,ARhdkon_U_hdKonperson_Ij_Hand.strFoernamn,Haehdkon_U_hdkonPerson_Ij_Aerende.strDiarienummer,ARhdkon_U_hdKonperson_Ij_Hand.intDiarienummerLoepNummer from
           ARhdkon_U_hdKonperson_Ij_Hand
               left outer join
           Haehdkon_U_hdkonPerson_Ij_Aerende
                                              on ARhdkon_U_hdKonperson_Ij_Hand.strDiarienummer = Haehdkon_U_hdkonPerson_Ij_Aerende.strDiarienummer and ARhdkon_U_hdKonperson_Ij_Hand.recEnstakaKontaktID = Haehdkon_U_hdkonPerson_Ij_Aerende.recEnstakaKontaktID)
    ARhdkon_U_hdKonperson_Ij_Hand_Lj_Haehdkon_U_hdkonPerson_Ij_Aerende
union                                         select *from (select *from (select k.strVisasSom,strSammanslagenAdress,strOrginisationPersonnummer,k.recEnstakaKontaktID,strFoeretag,strLand,k.strPostort,k.strGatuadress,strCoadress,k.strPostnummer,strEfternamn,strFoernamn,strDiarienummer,intDiarienummerLoepNummer
          from
                EDPVisionRegionGotlandTest2.dbo.vwAehAerende a
                   inner join
                dbo.vwAehAerendeHuvudkontaktperson k
                                            on a.recAerendeID = k.recAerendeId) as Arenden_Ij_ArenHuvudKontaktperson
             except
         select *
         from (select strVisasSom,strSammanslagenAdress,strOrginisationPersonnummer,arende_Ij_AehAerendeHuvudkontaktperson.recEnstakaKontaktID,strFoeretag,strLand,strPostort,strGatuadress,strCoadress,strPostnummer,strEfternamn,strFoernamn,arende_Ij_AehAerendeHuvudkontaktperson.strDiarienummer,intDiarienummerLoepNummer
                  from handelse_Ij_HaendelseHuvudkontaktperson
                           left outer join
                       arende_Ij_AehAerendeHuvudkontaktperson on handelse_Ij_HaendelseHuvudkontaktperson.strDiarienummer = arende_Ij_AehAerendeHuvudkontaktperson.strDiarienummer and handelse_Ij_HaendelseHuvudkontaktperson.recEnstakaKontaktID = arende_Ij_AehAerendeHuvudkontaktperson.recEnstakaKontaktID
              ) handelse_Ij_HaendelseHuvudkontaktperson_LoJ_arende_Ij_AehAerendeHuvudkontaktperson
     )
    Arenden_Ij_hdKonperson_Ex_handelse_Ij_HaendelseHuvudkontaktperson_LoJ_arende_Ij_AehAerendeHuvudkontaktperson



--vwAehHaendelse H
--vwAehHaendelseHuvudkontakt HH
--vwAehHaendelseHuvudkontaktperson HHP

--vwAehAerende A
--vwAehAerendetsHuvudkontakt AH
--vwAehAerendeHuvudkontaktperson AHP

