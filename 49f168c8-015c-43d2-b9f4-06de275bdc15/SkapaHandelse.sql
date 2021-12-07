--"datHaendelseDatum"	"strRubrik"	"strText"	"strRiktning"	"strKommunikationssaett"	"recHaendelseKategoriID"	"recLastHaendelseStatusLogID"	"recHaendelseID"	"intRecnum"	"recDiarieAarsSerieID"	"intLoepnummer"	"intAntalFiler"	"recRemissutskickID"	"recFoervaltningID"	"strPublicering"	"recEnhetID"	"recAvdelningID"	"strEnhetNamn"	"strEnhetKod"	"strAvdelningNamn"	"strAvdelningKod"	"strFoervaltningKod"	"strHaendelseIdentifiering"	"strOrgannamn"	"strBeslutsNummer"	"datBeslutsDatum"	"recOrganID"	"recHaendelseBeslutID"	"strBeslutsutfall"	"strHaendelseKategori"	"strHaendelseKategoriKod"	"bolEjAktuell"	"bolBeslut"	"strHaendelseKategoriKommentar"	"strFastighetsbeteckning"	"strFnrID"	"recFastighetID"	"intLoepnummerHaendelse"	"recAerendeID"	"bolMainHuvudBeslut"	"strSekretess"	"strBegraensa"	"strSekretessMyndighet"	"datSekretessDatum"	"recEnstakaKontaktID"	"strGatuadress"	"strPostnummer"	"strPostort"	"strVisasSom"	"strRoll"	"recKontaktRollID"	"recHaendelseEnstakaKontaktID"	"strSignature"	"intUserID"	"datDatum"	"strLogKommentar"	"strHaendelseStatusPresent"	"strHaendelseStatusLogTyp"	"strHaendelseStatusLocalizationCode"	"strDiarienummer"	"strAerendeTyp"	"strAerendeFastighet"	"strAerendeStatusPresent"	"strAerendeLocalizationCode"	"strSoekbegrepp"	"recDiarieSerieID"	"strDiarieserieAerende"	"intDiarieAar"	"intDiarienummerLoepNummer"	"intSerieStartVaerde"	"recDiarieSeriePostlista"	"strDiarieseriePostlista"	"intDiarieAarPostlista"	"strTillhoerPostlista"	"strAerendemening"	"strAerendetypKod"	"recKommunID"	"strKommunNamn"	"strFoervaltningNamn"	"intArbetsdagar"	"strSummaTidposter"	"strPoITkategori"	"recDelprocessID"	"strDelprocesskod"	"strDelprocess"	"datGallrad"	"datArkiverad"
EDPVisionRegionGotland.dbo.vwAehAerende z
    select * from

insert into EDPVisionRegionGotland.dbo.vwAehHaendelse(
    datDatum, intUserID, recAvdelningID, recEnhetID, recFoervaltningID, recHaendelseKategoriID, recKommunID, recKontaktRollID, recLastHaendelseStatusLogID, strAerendeLocalizationCode, strAerendemening, strAerendeStatusPresent, strAerendeTyp, strAerendetypKod, strAvdelningKod, strAvdelningNamn, strEnhetKod, strEnhetNamn, strFoervaltningKod, strFoervaltningNamn, strHaendelseKategori, strHaendelseKategoriKod, strHaendelseStatusLocalizationCode, strHaendelseStatusLogTyp, strHaendelseStatusPresent, strKommunNamn, strPublicering, strRiktning, strRoll, strRubrik, strSignature, datHaendelseDatum,
    --copy from refObject
    , recDiarieSerieID -- år+Diarieserie
    , intSerieStartVaerde -- not used in db? always 1
    --StringDebugg
    , strSoekbegrepp,--fixWithJoin
    strAerendeFastighet, strFastighetsbeteckning, recFastighetID, strFnrID, recAerendeID, intDiarienummerLoepNummer, strDiarienummer, strDiarieserieAerende, intDiarieAar, strGatuadress, strVisasSom, strPostnummer, strPostort,--ToWriteMethodsFor
    strHaendelseIdentifiering, recEnstakaKontaktID, recHaendelseID, intLoepnummerHaendelse, intRecnum -- intRecnum=recHaendelseID
    , recHaendelseEnstakaKontaktID
    ) from
select

    datDatum,intUserID,recAvdelningID,recEnhetID,recFoervaltningID,recHaendelseKategoriID,recKommunID,recKontaktRollID,recLastHaendelseStatusLogID,strAerendeLocalizationCode,strAerendemening,strAerendeStatusPresent,strAerendeTyp,strAerendetypKod,strAvdelningKod,strAvdelningNamn,strEnhetKod,strEnhetNamn,strFoervaltningKod,strFoervaltningNamn,strHaendelseKategori,strHaendelseKategoriKod,strHaendelseStatusLocalizationCode,strHaendelseStatusLogTyp,strHaendelseStatusPresent,strKommunNamn,strPublicering,strRiktning,strRoll,strRubrik,strSignature,datHaendelseDatum,
    --copy from refObject
     recDiarieSerieID    -- år+Diarieserie
    ,intSerieStartVaerde --reusing same as method
    ,'AutoInfört'
    ,ArendeFastighet(),
    ArendeFastighet(),
    ArendeFastighetID(),
    ArendeFnr(),
    ArendeID(),
    ArendeLoepnummer(),
    ArendeNr(),
    ArendeNrSerie(),
    ArendeNrAr(),
    SentTOAdress(),
    SentTOName(),
    SentTOPostnr(),
    SentTOPostORt(),
    ArendeNr() & ':' & NrHandelse()++,
    GetNewHandelseID(),
    NrHandelse()++,
    FindKontaktID(),
    FindRecHaendelseEnstakaKontaktID(),
    GetNewHandelseID()


-- reffobject
from EDPVisionRegionGotland.dbo.vwAehHaendelse
where recHaendelseID = 446413


-- something else
select z.strFastighetsbeteckning,
       z.strFastighetsbeteckning,
       z.strFnrID,
       z.recFastighetID,
       recAerendeID,
       intDiarienummerLoepNummer,
       strDiarienummer,
       strDiarieSerieKod,
       intDiarieAar
from EDPVisionRegionGotland.dbo.vwAehAerende z
group by recAerendeID, z.strFastighetsbeteckning, z.strFnrID, z.recFastighetID, intDiarieAar, strDiarieSerieKod,
         intDiarienummerLoepNummer,
         strDiarienummer EDPVisionRegionGotland.dbo.vwAehHaendelse q left join EDPVisionRegionGotland.dbo.vwAehAerende zon q.recAerendeID = z.recAerendeID
group by z.strFastighetsbeteckning, z.strFnrID, z.recFastighetID






















