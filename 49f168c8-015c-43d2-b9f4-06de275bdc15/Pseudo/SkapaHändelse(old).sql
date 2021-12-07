--"datHaendelseDatum"	"strRubrik"	"strText"	"strRiktning"	"strKommunikationssaett"	"recHaendelseKategoriID"	"recLastHaendelseStatusLogID"	"recHaendelseID"	"intRecnum"	"recDiarieAarsSerieID"	"intLoepnummer"	"intAntalFiler"	"recRemissutskickID"	"recFoervaltningID"	"strPublicering"	"recEnhetID"	"recAvdelningID"	"strEnhetNamn"	"strEnhetKod"	"strAvdelningNamn"	"strAvdelningKod"	"strFoervaltningKod"	"strHaendelseIdentifiering"	"strOrgannamn"	"strBeslutsNummer"	"datBeslutsDatum"	"recOrganID"	"recHaendelseBeslutID"	"strBeslutsutfall"	"strHaendelseKategori"	"strHaendelseKategoriKod"	"bolEjAktuell"	"bolBeslut"	"strHaendelseKategoriKommentar"	"strFastighetsbeteckning"	"strFnrID"	"recFastighetID"	"intLoepnummerHaendelse"	"recAerendeID"	"bolMainHuvudBeslut"	"strSekretess"	"strBegraensa"	"strSekretessMyndighet"	"datSekretessDatum"	"recEnstakaKontaktID"	"strGatuadress"	"strPostnummer"	"strPostort"	"strVisasSom"	"strRoll"	"recKontaktRollID"	"recHaendelseEnstakaKontaktID"	"strSignature"	"intUserID"	"datDatum"	"strLogKommentar"	"strHaendelseStatusPresent"	"strHaendelseStatusLogTyp"	"strHaendelseStatusLocalizationCode"	"strDiarienummer"	"strAerendeTyp"	"strAerendeFastighet"	"strAerendeStatusPresent"	"strAerendeLocalizationCode"	"strSoekbegrepp"	"recDiarieSerieID"	"strDiarieserieAerende"	"intDiarieAar"	"intDiarienummerLoepNummer"	"intSerieStartVaerde"	"recDiarieSeriePostlista"	"strDiarieseriePostlista"	"intDiarieAarPostlista"	"strTillhoerPostlista"	"strAerendemening"	"strAerendetypKod"	"recKommunID"	"strKommunNamn"	"strFoervaltningNamn"	"intArbetsdagar"	"strSummaTidposter"	"strPoITkategori"	"recDelprocessID"	"strDelprocesskod"	"strDelprocess"	"datGallrad"	"datArkiverad"

--create a new handelse such as above with an exception.

--for each ärenden
--create handelse accordingly
insert into EDPVisionRegionGotland.dbo.vwAehHaendelse() from select

datHaendelseDatum, --"2020-04-24 00:00:00.000"
       strRubrik, --"Påminnelse om åtgärd - 12 månader"	
       strText, --	
       strRiktning, --"Utgående"	
       strKommunikationssaett, --	
       recHaendelseKategoriID, --"65"	
       recLastHaendelseStatusLogID, --"907650"	
       recHaendelseID, --"Max()++"	
       intRecnum, --"xxxxx 446413"	?
       recDiarieAarsSerieID, --	
       intLoepnummer, --	
       intAntalFiler, --	
       recRemissutskickID, --	
       recFoervaltningID, --"3"	
       strPublicering, --"Visa med personskydd"	
       recEnhetID, --"1"	
       recAvdelningID, --"12"	
       strEnhetNamn, --"Team vatten"	
       strEnhetKod, --"Vatten"	
       strAvdelningNamn, --"Enhet miljö- och hälsoskydd"	
       strAvdelningKod, --"Miljö"	
       strFoervaltningKod, --"SBF"	
       strHaendelseIdentifiering, --"ArendeNr()&':'&NrHandelse()++"	
       strOrgannamn, --	
       strBeslutsNummer, --	
       datBeslutsDatum, --	
       recOrganID, --	
       recHaendelseBeslutID, --	
       strBeslutsutfall, --	
       strHaendelseKategori, --"INFORMATION"	
       strHaendelseKategoriKod, --"INFO"	
       bolEjAktuell, --"0"	
       bolBeslut, --"0"	
       strHaendelseKategoriKommentar, --	
       strFastighetsbeteckning, --"ArendeFastighet()"	
       strFnrID, --"ArendeFnr()"	
       recFastighetID, --"ArendeFastighetID()"	
       intLoepnummerHaendelse, --"NrHandelse()++"	
       recAerendeID, --"ArendeID()"	
       bolMainHuvudBeslut, --"0"	
       strSekretess, --	
       strBegraensa, --	
       strSekretessMyndighet, --	
       datSekretessDatum, --	
       recEnstakaKontaktID, --"FindKontaktID()  982896"	
       strGatuadress, --"SentTOAdress()"	
       strPostnummer, --"SentTOPostnr()"	
       strPostort, --"SentTOPostORt()"	
       strVisasSom, --"SentTOName()"	
       strRoll, --"Fastighetsägare"	
       recKontaktRollID, --"4"	
       recHaendelseEnstakaKontaktID, --"653892 ??"	
       strSignature, --"VATTEN"	
       intUserID, --"286"	
       datDatum, --"2020-08-18 13:47:43.933"	
       strLogKommentar, --""	
       strHaendelseStatusPresent, --"ALLM"	
       strHaendelseStatusLogTyp, --"Allmän handling"	
       strHaendelseStatusLocalizationCode, --"ALLM"	
       strDiarienummer, --"ArendeNr()"	
       strAerendeTyp, --"INFORMATION"	
       strAerendeFastighet, --"ArendeFastighet()"	
       strAerendeStatusPresent, --"Handläggs"	
       strAerendeLocalizationCode, --"handl"	
       strSoekbegrepp, -- AutoInfört
       recDiarieSerieID, --"4 ???"	
       strDiarieserieAerende, --"ArendeNrSerie()"	
       intDiarieAar, --"ArendeNrAr()"	
       intDiarienummerLoepNummer, --"ArendeLoepnummer()"	
       intSerieStartVaerde, --"1 ??"	
       recDiarieSeriePostlista, --	
       strDiarieseriePostlista, --	
       intDiarieAarPostlista, --	
       strTillhoerPostlista, --	
       strAerendemening, --"Klart vatten information om avlopp"	
       strAerendetypKod, --"INFORMA"	
       recKommunID, --"88"	
       strKommunNamn, --"Gotland"	
       strFoervaltningNamn, --"Samhällsbyggnadsförvaltningen"	
       intArbetsdagar, --	
       strSummaTidposter, --"0:00"	
       strPoITkategori, --	
       recDelprocessID, --	<- borde vi tolvmånaders istället för i rubriken
       strDelprocesskod, --	
       strDelprocess, --	
       datGallrad, --	
       datArkiverad --    

 from EDPVisionRegionGotland.dbo.vwAehHaendelse where handelseID = 446413