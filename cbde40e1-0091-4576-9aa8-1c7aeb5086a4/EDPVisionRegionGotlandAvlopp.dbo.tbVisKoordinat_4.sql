use EDPVisionRegionGotlandAvlopp
    --AA.recTillsynsobjektID               AS Tillsynsobjekt,
    --K.recKoordinatID AS Id,
    --T.recTillsynsobjektID AS Tillsynsobjekt,
    --,[geometry]::Point(K.decY, K.decX, 3015) AS Shape

SELECT
    K.recKoordinatID                    AS Id,
    AA.datBesiktningsdatum              As Besiktningsdatum,
    AA.datBeslutsdatum                  AS Beslutsdatum,
    AA.strVatten                        AS Vatten,
    AA.strInventering                   AS Inventering,
    AA.strBedoemning                    AS Bedömning,
    AA.strStatus                        AS Status,
    AA.strEfterfoeljandereningRecipient AS Recipient,
    AA.strAnteckning                     AS Anteckning,
    AA.strAnlaeggningstyp AS Anläggningstyp,
    AA.strAnlaeggningskategori AS Anläggningskategori,
    AA.decVolym AS Volym,
    AA.datBeslutsdatum AS Beslutsdatum,
    AA.datBesiktningsdatum as Besiktningsdatumk,
    AA.intToemningsintervall AS Tömningsintervall,
    AA.strText AS Text,
    AA.strStatus as Status,
    AA.datStatusDatum as Datum,
    AA.intExterntTjaenstID as ExterntTjaenstID,
    AA.strCertifieringstyp as Certifieringstyp,
    AA.datToemningsdispensFrOM as ToemningsdispensFrOM
FROM (select
             bolDebiterasEj,
             bolIndraget,
             bolSpecialpris,
             bolTimdebitering,
          Aq.datBesiktningsdatum,
          Aq.datBeslutsdatum,
             datFoeregaaendeBesoek,
             datFoeregaandeService,
             datInventeringsdatum,
             datNaastaBesoeks,
             datNaastaService,
          Aq.datStatusDatum,
          Aq.datToemningsdispensFrOM,
             decJusteradKontrolltid,
             decKontrolltid,
             decRabatt,
          Aq.decVolym,
             intAarsavgiftAttDebitera,
             intBeraeknadAarsavgift,
             intBesoeksintervall,
             intByggnadsaar,
             intEfterfoeljandereningYta,
          Aq.intExterntTjaenstID,
             intJusteradAarsavgift,
             intLoepnr,
             intTidsskuld,
          Aq.intToemningsintervall,
             intUnderhaallsintervallMaanad,
             recAvdelningID,
          Aq.recAvloppsanlaeggningID,
             recDeladFakturamottagareID,
             recEnhetID,
             recKontaktPersonID,
          tk.recKoordinatID,
             recLastLogPostID,
          AX.recTillsynsobjektID as Tillsynsobjekt,
             recTyperID,
             recVerksamhetID,
             recVerksamhetsutoevareKontaktID,
             strAdress,
          Aq.strAnlaeggningskategori,
          Aq.strAnlaeggningstyp,
             strAnteckning,
             strAvrinningsomraade,
             strBedoemning,
             strBoendetyp,
          Aq.strCertifieringstyp,
             strDebiteradFoer,
             strEfterfoeljandereningRecipient,
             strEfterfoeljandereningReningstyp,
             strEfterpoleringTyp,
             strInventering,
             strNotering,
             strObjektsNamn,
             strOrt,
             strPostnummer,
             strPrioritet,
             strProevningsplikt,
             strSoekbegrepp,
          Aq.strStatus,
          Aq.strText,
             strVatten,
             strVattenskyddsomraade
      from EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS AX
               INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T
                          ON AX.recTillsynsobjektID = T.recTillsynsobjektID
               LEFT OUTER JOIN (select * from EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjektKoordinat AS TK) tk
                               ON T.recTillsynsobjektID = TK.recTillsynsobjektID
               LEFT OUTER JOIN (select
                                       datBesiktningsdatum,
                                       datBeslutsdatum,
                                       datStatusDatum,
                                       datToemningsdispensFrOM,
                                       datToemningsdispensTOM,
                                       decVolym,
                                       intExterntTjaenstID,
                                       intToemningsintervall,
                                     A.recAnlaeggningID,
                                       recAnlaeggningKoordinatID,                                      
                                    AT.recAnlaeggningskategoriID,
                                     A.recAnlaeggningstypID,
                                       recAvloppsanlaeggningID,
                                       recKoordinatID,
                                       strAnlaeggningskategori,
                                       strAnlaeggningstyp,
                                       strCertifieringstyp,
                                       strStatus,
                                       strText,
                                       strToaletttyp
                                from (select 
                                             datBesiktningsdatum,
                                             datBeslutsdatum,
                                             datStatusDatum,
                                             datToemningsdispensFrOM,
                                             datToemningsdispensTOM,
                                             decVolym,
                                             intExterntTjaenstID,
                                             intToemningsintervall,
                                          Az.recAnlaeggningID,
                                             recAnlaeggningstypID,
                                             recAvloppsanlaeggningID,
                                           Az.recAnlaeggningskategoriID,
                                             strAnlaeggningskategori,
                                             strCertifieringstyp,
                                             strStatus,
                                             strText,
                                             strToaletttyp
                                      from EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggning AS Az 
                                        LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningskategori AS AKI 
                                        ON Az.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID) A
                                         INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningKoordinat AS AK
                                         LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningstyp AS AT
                                                         ON A.recAnlaeggningID = AK.recAnlaeggningID
                                                         ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID) Aq
                               on Aq.recAvloppsanlaeggningID = AX.recAvloppsanlaeggningID) AA

    INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K

        ON AA.recKoordinatID = K.recKoordinatID



--WHERE (K.decX IS NOT NULL AND K.decY IS NOT NULL AND (K.strPunkttyp='Ansluten byggnad' or K.strPunkttyp='Inventeringsinfo' or K.strPunkttyp='Efterföljande re' OR K.strPunkttyp='Slamavskiljare')) OR (K.strPunkttyp='Efterföljande rening' OR K.strPunkttyp='Ansluten byggnad' OR K.strPunkttyp='Extra inventeringsin' OR K.strPunkttyp='Tank')










