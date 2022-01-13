
with wowox as (
    select null recRemissutskickID
	 , null strOrgannamn
	 , null strBeslutsNummer
	 , null datBeslutsDatum
	 , null recOrganID
	 , null recHaendelseBeslutID
	 , null strBeslutsutfall
	 , null recDelegationskodID
	 , null strDelegationskod
	 , null strDelegationsNamn
	 , null strHaendelseKategoriKommentar
	 ,strFnrID
	 , null strSekretess
	 , null strBegraensa
	 , null strSekretessMyndighet
	 , null datSekretessDatum
	 , null strLogKommentar
	 , null strSoekbegrepp
	 , null intArbetsdagar
	 , null strPoITkategori
	 , null recDelprocessID
	 , null strDelprocesskod
	 , null strDelprocess
	 , null datGallrad
	 , null datArkiverad
         , 0 intLoepnummer
         ,
           datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseKategoriID, recLastHaendelseStatusLogID,
           recHaendelseID, intRecnum, recDiarieAarsSerieID, 0 intAntalFiler, recFoervaltningID, strPublicering, recEnhetID,
           recAvdelningID, bolKaensligaPersonuppgifter, strEnhetNamn, strEnhetKod, strAvdelningNamn, strAvdelningKod, strFoervaltningKod,
           strHaendelseIdentifiering, strHaendelseKategori, strHaendelseKategoriKod, bolEjAktuell, bolBeslut, strFastighetsbeteckning,
           recFastighetID, intLoepnummerHaendelse, recAerendeID, bolMainHuvudBeslut, recEnstakaKontaktID, strGatuadress, strPostnummer,
           strPostort, strVisasSom, strRoll, recKontaktRollID, recHaendelseEnstakaKontaktID, strSignature, intUserID, strHandlaeggarNamn,
           datDatum, strHaendelseStatusPresent, strHaendelseStatusLogTyp, strHaendelseStatusLocalizationCode, strDiarienummer, strAerendeTyp,
           recAerendetypID, strAerendeFastighet, strAerendeStatusPresent, strAerendeLocalizationCode, recDiarieSerieID, strDiarieserieAerende,
           intDiarieAar, intDiarienummerLoepNummer, 0 intSerieStartVaerde, recDiarieSeriePostlista, strDiarieseriePostlista, intDiarieAarPostlista,
           strTillhoerPostlista, strAerendemening, strAerendetypKod, recKommunID, strKommunNamn, strFoervaltningNamn, strSummaTidposter
    from
EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse)

,wux as(
select
    (iif(datArkiverad is null,1,0)+
	iif(datBeslutsDatum is null,1,0)+
	iif(datDatum is null,1,0)+
	iif(datGallrad is null,1,0)+
	iif(datHaendelseDatum is null,1,0)+
	iif(datSekretessDatum is null,1,0)+
	iif(intAntalFiler = 0,1,0)+
	iif(intArbetsdagar = 0,1,0)+
	iif(intDiarieAar = 0,1,0)+
	iif(intDiarieAarPostlista = 0,1,0)+
	iif(intDiarienummerLoepNummer = 0,1,0)+
	iif(intLoepnummer = 0,1,0)+
	iif(intLoepnummerHaendelse = 0,1,0)+
	iif(intRecnum = 0,1,0)+
	iif(intSerieStartVaerde = 0,1,0)+
	iif(intUserID is null,1,0)+
	iif(recAerendeID is null,1,0)+
	iif(recAerendetypID is null,1,0)+
	iif(recAvdelningID is null,1,0)+
	iif(recDelegationskodID is null,1,0)+
	iif(recDelprocessID is null,1,0)+
	iif(recDiarieAarsSerieID is null,1,0)+
	iif(recDiarieSerieID is null,1,0)+
	iif(recDiarieSeriePostlista is null,1,0)+
	iif(recEnhetID is null,1,0)+
	iif(recEnstakaKontaktID is null,1,0)+
	iif(recFastighetID is null,1,0)+
	iif(recFoervaltningID is null,1,0)+
	iif(recHaendelseBeslutID is null,1,0)+
	iif(recHaendelseEnstakaKontaktID is null,1,0)+
	iif(recHaendelseID is null,1,0)+
	iif(recHaendelseKategoriID is null,1,0)+
	iif(recKommunID is null,1,0)+
	iif(recKontaktRollID is null,1,0)+
	iif(recLastHaendelseStatusLogID is null,1,0)+
	iif(recOrganID is null,1,0)+
	iif(recRemissutskickID is null,1,0)+
	iif(strAerendeFastighet is null,1,0)+
	iif(strAerendeLocalizationCode is null,1,0)+
	iif(strAerendemening is null,1,0)+
	iif(strAerendeStatusPresent is null,1,0)+
	iif(strAerendeTyp is null,1,0)+
	iif(strAerendetypKod is null,1,0)+
	iif(strAvdelningKod is null,1,0)+
	iif(strAvdelningNamn is null,1,0)+
	iif(strBegraensa is null,1,0)+
	iif(strBeslutsNummer is null,1,0)+
	iif(strBeslutsutfall is null,1,0)+
	iif(strDelegationskod is null,1,0)+
	iif(strDelegationsNamn is null,1,0)+
	iif(strDelprocess is null,1,0)+
	iif(strDelprocesskod is null,1,0)+
	iif(strDiarienummer is null,1,0)+
	iif(strDiarieserieAerende is null,1,0)+
	iif(strDiarieseriePostlista is null,1,0)+
	iif(strEnhetKod is null,1,0)+
	iif(strEnhetNamn is null,1,0)+
	iif(strFastighetsbeteckning is null,1,0)+
	iif(strFnrID is null,1,0)+
	iif(strFoervaltningKod is null,1,0)+
	iif(strFoervaltningNamn is null,1,0)+
	iif(strGatuadress is null,1,0)+
	iif(strHaendelseIdentifiering is null,1,0)+
	iif(strHaendelseKategori is null,1,0)+
	iif(strHaendelseKategoriKod is null,1,0)+
	iif(strHaendelseKategoriKommentar is null,1,0)+
	iif(strHaendelseStatusLocalizationCode is null,1,0)+
	iif(strHaendelseStatusLogTyp is null,1,0)+
	iif(strHaendelseStatusPresent is null,1,0)+
	iif(strHandlaeggarNamn is null,1,0)+
	iif(strKommunikationssaett is null,1,0)+
	iif(strKommunNamn is null,1,0)+
	iif(strLogKommentar is null,1,0)+
	iif(strOrgannamn is null,1,0)+
	iif(strPoITkategori is null,1,0)+
	iif(strPostnummer is null,1,0)+
	iif(strPostort is null,1,0)+
	iif(strPublicering is null,1,0)+
	iif(strRiktning is null,1,0)+
	iif(strRoll is null,1,0)+
	iif(strRubrik is null,1,0)+
	iif(strSekretess is null,1,0)+
	iif(strSekretessMyndighet is null,1,0)+
	iif(strSignature is null,1,0)+
	iif(strSoekbegrepp is null,1,0)+
	iif(strSummaTidposter is null,1,0)+
	iif(strText is null,1,0)+
	iif(strTillhoerPostlista is null,1,0)+
	iif(strVisasSom is null, 1,0)) notnullables,
             strFnrID, datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseKategoriID, recLastHaendelseStatusLogID, recHaendelseID, intRecnum, recDiarieAarsSerieID, intLoepnummer, intAntalFiler, recFoervaltningID, strPublicering, recEnhetID, recAvdelningID, bolKaensligaPersonuppgifter, strEnhetNamn, strEnhetKod, strAvdelningNamn, strAvdelningKod, strFoervaltningKod, strHaendelseIdentifiering, strHaendelseKategori, strHaendelseKategoriKod, bolEjAktuell, bolBeslut, strFastighetsbeteckning, recFastighetID, intLoepnummerHaendelse, recAerendeID, bolMainHuvudBeslut, recEnstakaKontaktID, strGatuadress, strPostnummer, strPostort, strVisasSom, strRoll, recKontaktRollID, recHaendelseEnstakaKontaktID, strSignature, intUserID, strHandlaeggarNamn, datDatum, strHaendelseStatusPresent, strHaendelseStatusLogTyp, strHaendelseStatusLocalizationCode, strDiarienummer, strAerendeTyp, recAerendetypID, strAerendeFastighet, strAerendeStatusPresent, strAerendeLocalizationCode, recDiarieSerieID, strDiarieserieAerende, intDiarieAar, intDiarienummerLoepNummer, intSerieStartVaerde, recDiarieSeriePostlista, strDiarieseriePostlista, intDiarieAarPostlista, strTillhoerPostlista, strAerendemening, strAerendetypKod, recKommunID, strKommunNamn, strFoervaltningNamn, strSummaTidposter
from wowox
    )

select top 5 * from wux order by notnullables

select top 5 concat(iif(recHaendelseKategoriID IS NULL, 1, 0),
              iif(recLastHaendelseStatusLogID IS NULL, 1, 0),
              iif(recDiarieAarsSerieID IS NULL, 1, 0),
              iif(recKommunID IS NULL, 1, 0),
              iif(recDelprocessID IS NULL, 1, 0),
              iif(recAvdelningID IS NULL, 1, 0),
              iif(recEnhetID IS NULL, 1, 0),
              iif(recFoervaltningID IS NULL, 1, 0),
              iif(recRemissutskickID IS NULL, 1, 0)
    ) nullRecz,* from EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse
order by (iif(recHaendelseKategoriID IS NULL, 1, 0)+iif(recLastHaendelseStatusLogID IS NULL, 1, 0)+iif(recDiarieAarsSerieID IS NULL, 1, 0)+iif(recKommunID IS NULL, 1, 0)+iif(recDelprocessID IS NULL, 1, 0)+iif(recAvdelningID IS NULL, 1, 0)+iif(recEnhetID IS NULL, 1, 0)+iif(recFoervaltningID IS NULL, 1, 0)+iif(recRemissutskickID IS NULL, 1, 0)      ) desc
