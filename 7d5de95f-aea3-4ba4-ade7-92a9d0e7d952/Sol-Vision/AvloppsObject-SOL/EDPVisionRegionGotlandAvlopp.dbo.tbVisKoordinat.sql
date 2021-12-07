SELECT strPunkttyp, 
       Id, 
       recTillsynsobjektID, 
       Anläggningstyp, 
       Anläggningskategori, 
       Anteckning, 
       STATUS, 
       Bedömning, 
       Besiktningsdatum, 
       Beslutsdatum, 
       Inventering, 
       Recipient, 
       Certifieringstyp, 
       Datum, 
       ToemningsdispensFrOM, 
       Tömningsintervall, 
       Volym, 
       [geometry]::Point(decY, decX, 3015) AS Shape
FROM
(
    SELECT a.strPunkttyp, 
           a.Anläggningskategori, 
           a.Anläggningstyp, 
           a.Anteckning, 
           a.Bedömning, 
           a.Besiktningsdatum, 
           a.Beslutsdatum, 
           a.Certifieringstyp, 
           a.Datum, 
           a.decY, 
           a.decX, 
           a.Id, 
           a.Inventering, 
           a.Recipient, 
           a.recTillsynsobjektID, 
           a.STATUS, 
           a.ToemningsdispensFrOM, 
           a.Tömningsintervall, 
           a.Volym
    FROM
    (
        SELECT K.strPunkttyp, 
               '' Anläggningskategori, 
               A.strVatten AS Anläggningstyp, 
               T.strAnteckning AS Anteckning, 
               A.strBedoemning AS Bedömning, 
               A.datBesiktningsdatum AS Besiktningsdatum, 
               A.datBeslutsdatum AS Beslutsdatum, 
               '' Certifieringstyp, 
               '' Datum, 
               K.decY, 
               K.decX, 
               K.recKoordinatID AS Id, 
               CAST(A.strInventering AS VARCHAR(MAX)) Inventering, 
               CAST(A.strEfterfoeljandereningRecipient AS VARCHAR(MAX)) Recipient, 
               T.recTillsynsobjektID AS recTillsynsobjektID, 
               A.strStatus AS STATUS, 
               '' ToemningsdispensFrOM, 
               '' Tömningsintervall, 
               '' Volym
        FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS A
             INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
             INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
             INNER JOIN
        (
            SELECT recKoordinatID, 
                   decX, 
                   decY, 
                   strPunkttyp, 
                   strAnteckning
            FROM EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat
            WHERE decX IS NOT NULL
                  AND decY IS NOT NULL
                  AND strPunkttyp = 'Ansluten byggnad'
            UNION
            SELECT recKoordinatID, 
                   decX, 
                   decY, 
                   strPunkttyp, 
                   strAnteckning
            FROM EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat
            WHERE decX IS NOT NULL
                  AND decY IS NOT NULL
                  AND strPunkttyp = 'Inventeringsinfo'
            UNION
            SELECT recKoordinatID, 
                   decX, 
                   decY, 
                   strPunkttyp, 
                   strAnteckning
            FROM EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat
            WHERE decX IS NOT NULL
                  AND decY IS NOT NULL
                  AND strPunkttyp = 'Efterföljande re'
        ) K ON TK.recKoordinatID = K.recKoordinatID
    ) a
    UNION ALL
    SELECT b.strPunkttyp, 
           b.Anläggningskategori, 
           b.Anläggningstyp, 
           b.Anteckning, 
           b.bedömning, 
           b.Besiktningsdatum, 
           b.Beslutsdatum, 
           b.Certifieringstyp, 
           b.Datum, 
           b.decY, 
           b.decX, 
           b.Id, 
           b.Inventering, 
           b.Recipient, 
           b.recTillsynsobjektID, 
           b.STATUS, 
           b.ToemningsdispensFrOM, 
           b.Tömningsintervall, 
           b.Volym
    FROM
    (
        SELECT K.strPunkttyp, 
               CAST(AKI.strAnlaeggningskategori AS VARCHAR(MAX)) Anläggningskategori, 
               AT.strAnlaeggningstyp AS Anläggningstyp, 
               A.strText AS Anteckning, 
               CAST(A.intExterntTjaenstID AS VARCHAR(MAX)) bedömning, 
               A.datBesiktningsdatum AS Besiktningsdatum, 
               A.datBeslutsdatum AS Beslutsdatum, 
               CAST(A.strCertifieringstyp AS VARCHAR(MAX)) Certifieringstyp, 
               CAST(A.datStatusDatum AS VARCHAR(MAX)) Datum, 
               K.decY, 
               K.decX, 
               K.recKoordinatID AS Id, 
               '' Inventering, 
               '' Recipient, 
               T.recTillsynsobjektID AS recTillsynsobjektID, 
               A.strStatus AS STATUS, 
               CAST(A.datToemningsdispensFrOM AS VARCHAR(MAX)) ToemningsdispensFrOM, 
               CAST(A.intToemningsintervall AS VARCHAR(MAX)) Tömningsintervall, 
               CAST(A.decVolym AS VARCHAR(MAX)) Volym
        FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggning AS A
             INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
             INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
             LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
             LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
             INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
             INNER JOIN
        (
            SELECT *
            FROM EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat
            WHERE decX IS NOT NULL
                  AND decY IS NOT NULL
                  AND strPunkttyp = 'Efterföljande rening'
            UNION
            SELECT *
            FROM EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat
            WHERE decX IS NOT NULL
                  AND decY IS NOT NULL
                  AND strPunkttyp = 'Ansluten byggnad'
            UNION
            SELECT *
            FROM EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat
            WHERE decX IS NOT NULL
                  AND decY IS NOT NULL
                  AND strPunkttyp = 'Extra inventeringsin'
            UNION
            SELECT *
            FROM EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat
            WHERE decX IS NOT NULL
                  AND decY IS NOT NULL
                  AND strPunkttyp = 'Tank'
        ) AS K ON AK.recKoordinatID = K.recKoordinatID
    ) b
) c;