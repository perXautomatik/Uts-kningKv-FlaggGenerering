select       Besiktningsdatum
     Beslutsdatum,
     Datum,
     ToemningsdispensFrOM,
     Volym,
     ExterntTjaenstID,
     Tömningsintervall,
     Id,
     Tillsynsobjekt,
     Anläggningskategori,
     Anläggningstyp,
     Anteckning,
     Bedömning,
     Certifieringstyp,
     Recipient,
     Inventering,
     Status,
     Text,
     Vatten,kdecy, kdecX,
    [geometry]::Point(kdecy, kdecX, 3015) AS Shape
from
(SELECT
    A.datBesiktningsdatum As Besiktningsdatum,
    A.datBeslutsdatum AS Beslutsdatum,
    A.datStatusDatum as Datum,
    A.datToemningsdispensFrOM as ToemningsdispensFrOM,
    A.decVolym AS Volym,
    A.intExterntTjaenstID as ExterntTjaenstID,
    A.intToemningsintervall AS Tömningsintervall,
    K.recKoordinatID AS Id,
    T.recTillsynsobjektID AS Tillsynsobjekt,
    AKI.strAnlaeggningskategori AS Anläggningskategori,
    AT.strAnlaeggningstyp AS Anläggningstyp,
    T.strAnteckning AS Anteckning,
    '' Bedömning,
    A.strCertifieringstyp as Certifieringstyp,
    '' AS Recipient,
    '' Inventering,
    A.strStatus as Status,
    A.strText AS Text,
    '' AS Vatten,
        K.decY as kdecy,
        K.decX as kdecX,
        K.strPunkttyp
FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
union
SELECT
    A.datBesiktningsdatum As Besiktningsdatum,
    A.datBeslutsdatum AS Beslutsdatum,
     0 as Datum,
     0 as ToemningsdispensFrOM,
    0 AS Volym,
     0 ExterntTjaenstID,
     0 Tömningsintervall,
    K.recKoordinatID AS Id,
    T.recTillsynsobjektID AS Tillsynsobjekt,
     '' Anläggningskategori,
    '' Anläggningstyp,
    T.strAnteckning AS Anteckning,
    A.strBedoemning AS Bedömning,
     '' Certifieringstyp,
    A.strEfterfoeljandereningRecipient AS Recipient,
    A.strInventering AS Inventering,
    A.strStatus as Status,
     '' Text,
    A.strVatten AS Vatten,
        K.decY as kdecy,
        K.decX as kdecX,
       K.strPunkttyp
FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL ) as AATAAAKATTK
where strPunkttyp ='Ansluten byggnad'  OR strPunkttyp='Slamavskiljare'
