create view AnslutnaByUtinv as

select
       strPunkttyp,
       Besiktningsdatum
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
     Vatten,
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL ) as AATAAAKATTK
where strPunkttyp ='Ansluten byggnad'  OR strPunkttyp='Slamavskiljare'
go

create view EfterfRening as


select
       strPunkttyp,
       Besiktningsdatum
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
     Vatten,
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL ) as AATAAAKATTK
where strPunkttyp='Efterföljande re' OR strPunkttyp='Efterföljande rening'
go

Create view Inventeringsinformation as

select
       strPunkttyp,
       Besiktningsdatum
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
     Vatten,
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL ) as AATAAAKATTK
where strPunkttyp ='Inventeringsinfo' or strPunkttyp='Extra inventeringsin'
go

Create view Minireningsverk as

select
       strPunkttyp,
       Besiktningsdatum
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
     Vatten,
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL ) as AATAAAKATTK
where strPunkttyp ='Efterföljande re' OR strPunkttyp='Slamavskiljare' OR strPunkttyp='Efterföljande rening'
go

Create view SlamavskiljareBDT as

select
       strPunkttyp,
       Besiktningsdatum
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
     Vatten,
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL ) as AATAAAKATTK
where strPunkttyp='Slamavskiljare' OR strPunkttyp='Ansluten byggnad'
go

Create view SlamavskiljareWCBDT as

select
       strPunkttyp,
       Besiktningsdatum
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
     Vatten,
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL ) as AATAAAKATTK
where strPunkttyp='Slamavskiljare' OR strPunkttyp='Ansluten byggnad'
go

Create view Tank as

select
       strPunkttyp,
       Besiktningsdatum
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
     Vatten,
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
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
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL ) as AATAAAKATTK
where strPunkttyp='Ansluten byggnad' or strPunkttyp='Inventeringsinfo' or strPunkttyp='Efterföljande re' OR strPunkttyp='Slamavskiljare' OR strPunkttyp='Efterföljande rening' OR strPunkttyp='Ansluten byggnad' OR strPunkttyp='Extra inventeringsin' OR strPunkttyp='Tank'
go



CREATE VIEW [dbo].[vwTrEaAnlaeggningPunkter]
AS

SELECT
    K.recKoordinatID AS Id,
    T.recTillsynsobjektID AS Tillsynsobjekt,
    AT.strAnlaeggningstyp AS Anläggningstyp,
    AKI.strAnlaeggningskategori AS Anläggningskategori,
    A.decVolym AS Volym,
    A.datBeslutsdatum AS Beslutsdatum,
    A.datBesiktningsdatum as Besiktningsdatum,
    A.intToemningsintervall AS Tömningsintervall,
    A.strText AS Text,
    A.strStatus as Status,
    A.datStatusDatum as Datum,
    A.intExterntTjaenstID as ExterntTjaenstID,
    A.strCertifieringstyp as Certifieringstyp,
    A.datToemningsdispensFrOM as ToemningsdispensFrOM,
    A.strToaletttyp as ToalettTyp,
[geometry]::Point(K.decY, K.decX, 3015) AS Shape
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
WHERE K.strPunkttyp='Efterföljande rening' OR K.strPunkttyp='Ansluten byggnad' OR K.strPunkttyp='Extra inventeringsin' OR K.strPunkttyp='Tank'

go





CREATE VIEW [dbo].[vwTrEaAvloppsanlaeggningPunkter]
AS 
SELECT
    K.recKoordinatID AS Id,
    T.recTillsynsobjektID AS Tillsynsobjekt,
    A.datBesiktningsdatum As Besiktningsdatum,
    A.datBeslutsdatum AS Beslutsdatum,
    A.strVatten AS Vatten,
    A.strInventering AS Inventering,
    A.strBedoemning AS Bedömning,
    A.strStatus AS Status,
    A.strEfterfoeljandereningRecipient AS Recipient,
    T.strAnteckning AS Anteckning,
[geometry]::Point(K.decY, K.decX, 3015) AS Shape
FROM EDPVisionRegionGotlandTest.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandTest.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL AND (K.strPunkttyp='Ansluten byggnad' or K.strPunkttyp='Inventeringsinfo' or K.strPunkttyp='Efterföljande re' OR K.strPunkttyp='Slamavskiljare')


go

