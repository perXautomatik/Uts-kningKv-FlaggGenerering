
SELECT A.RECAERENDEID, STRDIARIENUMMERSERIE, A.INTDIARIENUMMERLOEPNUMMER, A.STRDIARIENUMMER, A.STRAERENDEMENING, A.STRSOEKBEGREPP, STRAERENDEKOMMENTAR, A.RECFOERVALTNINGID, A.RECENHETID, A.RECAVDELNINGID, RECEXTERNTID, A.RECDIARIEAARSSERIEID, A.STRPUBLICERING, A.BOLKAENSLIGAPERSONUPPGIFTER, RECLASTAERENDESTATUSLOGID, A.INTRECNUM, A.STRFASTIGHETSBETECKNING, A.STRFNRID, GUIDFASTIGHETUUID, A.RECFASTIGHETID, DATINKOMDATUM, A.DATDATUM, A.STRLOGKOMMENTAR, A.STRAERENDESTATUSPRESENT, STRLOCALIZATIONCODE, A.STRSIGNATURE, STRUSERVISASSOM, A.INTUSERID, A.RECDIARIESERIEID, A.INTDIARIEAAR, A.INTSERIESTARTVAERDE, STRDIARIESERIEKOD, A.STRSEKRETESS, A.STRBEGRAENSA, A.STRSEKRETESSMYNDIGHET, A.DATSEKRETESSDATUM, RECPROJEKTID, A.RECENSTAKAKONTAKTID, A.STRVISASSOM, A.STRGATUADRESS, A.STRPOSTNUMMER, A.STRPOSTORT, A.STRROLL, A.RECKONTAKTROLLID, RECAERENDEENSTAKAKONTAKTID, RECENSTAKAFAKTURAMOTTAGAREID, A.RECKOMMUNID, STRPROJEKTNAMN, A.DATBESLUTSDATUM, A.STRBESLUTSNUMMER, A.STRBESLUTSUTFALL, A.RECHAENDELSEID, A.RECHAENDELSEBESLUTID, A.STRAERENDETYP, STRAERENDEKATEGORI, A.STRAERENDETYPKOD, A.RECAERENDETYPID, BOLKOMPLETTAERENDE, A.STRENHETNAMN, A.STRENHETKOD, A.STRFOERVALTNINGNAMN, A.STRFOERVALTNINGKOD, A.STRAVDELNINGKOD, A.STRAVDELNINGNAMN, STRFAKTURAMOTTAGARE, A.STRKOMMUNNAMN, DATKOMPLETT, DATMOETESDATUM, A.INTARBETSDAGAR, A.STRSUMMATIDPOSTER, RECEXTERNTJAENSTID, STREXTERNTJAENST, STRETJAENSTNAMN, DATBESLUTEXPEDIERAT, DATGALLRAT, DATARKIVERAT
     , DATHAENDELSEDATUM, STRRUBRIK, STRTEXT, STRRIKTNING, STRKOMMUNIKATIONSSAETT, RECHAENDELSEKATEGORIID, RECLASTHAENDELSESTATUSLOGID, H.RECHAENDELSEID, H.INTRECNUM, H.RECDIARIEAARSSERIEID, INTLOEPNUMMER, INTANTALFILER, RECREMISSUTSKICKID, H.RECFOERVALTNINGID, H.STRPUBLICERING, H.RECENHETID, H.RECAVDELNINGID, H.BOLKAENSLIGAPERSONUPPGIFTER, H.STRENHETNAMN, H.STRENHETKOD, H.STRAVDELNINGNAMN, H.STRAVDELNINGKOD, H.STRFOERVALTNINGKOD, STRHAENDELSEIDENTIFIERING, STRORGANNAMN, H.STRBESLUTSNUMMER, H.DATBESLUTSDATUM, RECORGANID, H.RECHAENDELSEBESLUTID, H.STRBESLUTSUTFALL, RECDELEGATIONSKODID, STRDELEGATIONSKOD, STRDELEGATIONSNAMN, STRHAENDELSEKATEGORI, STRHAENDELSEKATEGORIKOD, BOLEJAKTUELL, BOLBESLUT, STRHAENDELSEKATEGORIKOMMENTAR, H.STRFASTIGHETSBETECKNING, H.STRFNRID, H.RECFASTIGHETID, INTLOEPNUMMERHAENDELSE, H.RECAERENDEID, BOLMAINHUVUDBESLUT, H.STRSEKRETESS, H.STRBEGRAENSA, H.STRSEKRETESSMYNDIGHET, H.DATSEKRETESSDATUM, H.RECENSTAKAKONTAKTID, H.STRGATUADRESS, H.STRPOSTNUMMER, H.STRPOSTORT, H.STRVISASSOM, H.STRROLL, H.RECKONTAKTROLLID, RECHAENDELSEENSTAKAKONTAKTID, H.STRSIGNATURE, H.INTUSERID, STRHANDLAEGGARNAMN, H.DATDATUM, H.STRLOGKOMMENTAR, STRHAENDELSESTATUSPRESENT, STRHAENDELSESTATUSLOGTYP, STRHAENDELSESTATUSLOCALIZATIONCODE, H.STRDIARIENUMMER, H.STRAERENDETYP, H.RECAERENDETYPID, STRAERENDEFASTIGHET, H.STRAERENDESTATUSPRESENT, STRAERENDELOCALIZATIONCODE, H.STRSOEKBEGREPP, H.RECDIARIESERIEID, STRDIARIESERIEAERENDE, H.INTDIARIEAAR, H.INTDIARIENUMMERLOEPNUMMER, H.INTSERIESTARTVAERDE, RECDIARIESERIEPOSTLISTA, STRDIARIESERIEPOSTLISTA, INTDIARIEAARPOSTLISTA, STRTILLHOERPOSTLISTA, H.STRAERENDEMENING, H.STRAERENDETYPKOD, H.RECKOMMUNID, H.STRKOMMUNNAMN, H.STRFOERVALTNINGNAMN, H.INTARBETSDAGAR, H.STRSUMMATIDPOSTER, STRPOITKATEGORI, RECDELPROCESSID, STRDELPROCESSKOD, STRDELPROCESS, DATGALLRAD, DATARKIVERAD
from [EDPVisionRegionGotland].DBO.vwAehHaendelse h INNER JOIN [EDPVisionRegionGotland].DBO.VWAEHAERENDE a on h.recAerendeID = a.recAerendeID where h.strRubrik = @HANDRUBRIK
