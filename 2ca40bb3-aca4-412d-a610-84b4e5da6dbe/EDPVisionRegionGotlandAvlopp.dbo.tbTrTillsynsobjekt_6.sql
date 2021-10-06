select * from (select
       (case when strPunkttyp = '' then Anläggningskategori else case when strPunkttyp = 'Extra inventeringsin' then 'inventeringsinfo' else strPunkttyp end end) Anläggningskategori,
       Anteckning,
       Status,
       Bedömning,
       Recipient,
       Tömningsintervall,
       Volym,
       Anläggningstyp,
       Besiktningsdatum,
       Beslutsdatum,
       Inventering,
       Certifieringstyp,Datum,ToemningsdispensFrOM,
       Id,
       recTillsynsobjektID,
       [geometry]::Point(decY, decX, 3015) AS Shape
       from (select * from (SELECT K.strPunkttyp, '' Anläggningskategori,
       cast( A.strVatten as varchar(max)) AS Anläggningstyp,
       T.strAnteckning AS Anteckning, A.strBedoemning AS Bedömning, A.datBesiktningsdatum As Besiktningsdatum, A.datBeslutsdatum AS Beslutsdatum,
        '' Certifieringstyp,
         '' Datum,
          K.decY, K.decX, K.recKoordinatID AS Id, cast(A.strInventering as varchar(max) ) Inventering, cast(A.strEfterfoeljandereningRecipient as varchar(max) ) Recipient, T.recTillsynsobjektID AS recTillsynsobjektID, A.strStatus AS Status,
          '' ToemningsdispensFrOM,
           '' Tömningsintervall, '' Volym
            FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS A
        INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
        INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
        INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
            WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL AND (K.strPunkttyp in('Ansluten byggnad','Inventeringsinfo','Efterföljande re'))
        ) a UNION all
            select * from (SELECT K.strPunkttyp, cast(AKI.strAnlaeggningskategori as varchar(max) ) Anläggningskategori,
           cast( AT.strAnlaeggningstyp as varchar(max)) AS Anläggningstyp
            , A.strText AS Anteckning, cast(A.intExterntTjaenstID as varchar(max)  ) bedömning, A.datBesiktningsdatum as Besiktningsdatum, A.datBeslutsdatum AS Beslutsdatum,
             cast(A.strCertifieringstyp as varchar(max) ) Certifieringstyp,
              cast(A.datStatusDatum as varchar(max) ) Datum,
               K.decY, K.decX, K.recKoordinatID AS Id, '' Inventering, '' Recipient, T.recTillsynsobjektID AS recTillsynsobjektID, A.strStatus as Status,
               cast(A.datToemningsdispensFrOM as varchar(max) ) ToemningsdispensFrOM,
                cast(A.intToemningsintervall as varchar(max) ) Tömningsintervall, cast(A.decVolym as varchar(max) ) Volym
            FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggning AS A
        INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
        INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
        LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
        LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
        INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
        INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
            WHERE K.strPunkttyp in('Efterföljande rening','Ansluten byggnad','Extra inventeringsin','Tank')
        ) b ) c
--, nullif(Tömningsintervall,''), nullif(Volym,'')
where coalesce(nullif(Certifieringstyp,''), nullif(datum,''), nullif(ToemningsdispensFrOM,'')) is not null
    --Status is not null

--where Anläggningstyp <> 1 AND Anläggningstyp is not null

           ) z
--group by Anläggningskategori
--where Anläggningskategori =