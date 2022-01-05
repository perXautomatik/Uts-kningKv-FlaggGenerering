select
      bolBeslut, bolEjAktuell, bolMainHuvudBeslut
     , intDiarieAarPostlista, intLoepnummerHaendelse
     , recDiarieSeriePostlista, recHaendelseEnstakaKontaktID,
       strAerendeFastighet, strAerendeLocalizationCode
     , strHaendelseIdentifiering, strHaendelseKategori,
       strHaendelseKategoriKod, strHaendelseStatusLocalizationCode,
       strHaendelseStatusLogTyp, strHaendelseStatusPresent, strHandlaeggarNamn
     , strDiarieserieAerende, strDiarieseriePostlista
from EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse;
;
--select from arende, fealds we don't need to provide
with referenSArende as (select top 1 recAerendeID, recAerendetypID, recAvdelningID,
        recDiarieAarsSerieID, recEnhetID, recFoervaltningID, recKommunID,
       strAerendemening     , strPublicering     , intDiarienummerLoepNummer     ,
       bolKaensligaPersonuppgifter, datDatum, intDiarieAar, intRecnum, intSerieStartVaerde,
       intUserID, recDiarieSerieID, recEnstakaKontaktID, recFastighetID, recHaendelseID,
       recKontaktRollID, strAerendeStatusPresent, strAerendeTyp, strAerendetypKod,
       strAvdelningKod, strAvdelningNamn, strDiarienummer, strEnhetKod, strEnhetNamn,
       strFastighetsbeteckning, strFnrID, strFoervaltningKod, strFoervaltningNamn, strGatuadress,
       strKommunNamn, strPostnummer, strPostort, strRoll, strSignature, strSummaTidposter,
       strVisasSom from EDPVisionRegionGotlandTest2.dbo.vwAehAerende
    )
,ToInserttbAehHaendelse as (
select
       getdate() datHaendelseDatum,
       0 intAntalFiler,
       intLoepnummer -- can be null but aint dificult to calculate
     , recHaendelseKategoriID
     , recLastHaendelseStatusLogID
     , strKommunikationssaett -- can be null but might be worth filling in anyway
     , 'utgående' strRiktning
     , strRubrik
     , strText, --can be null.
       strTillhoerPostlista --it's a string, silly, maybe take first value from other handelser.
   from inputX
    )

insert into tbAehHaendelse ( recHaendelseKategoriID, recLastHaendelseStatusLogID, datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, intAntalFiler, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, strPublicering, bolKaensligaPersonuppgifter)
select
       		     recHaendelseKategoriID, recLastHaendelseStatusLogID,
                     datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett,
                     intAntalFiler, intLoepnummer,
                     intDiarieAar,
                     strTillhoerPostlista,
                     strPublicering,
                     bolKaensligaPersonuppgifter
from referenSArende, ToInserttbAehHaendelse