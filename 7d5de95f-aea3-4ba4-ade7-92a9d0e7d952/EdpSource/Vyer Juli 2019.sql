
USE EDPGeodata
GO

/****** Object:  View [dbo].[vwTrEaAnlaeggningPunkter]    Script Date: 2020-01-10 12:25:10 ******/
DROP VIEW [dbo].[vwTrEaAnlaeggningPunkter]
GO

/****** Object:  View [dbo].[vwTrEaAnlaeggningPunkter]    Script Date: 2020-01-10 12:25:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTrEaAnlaeggningPunkter]
AS
SELECT
    K.recKoordinatID AS Id,
    T.recTillsynsobjektID AS Tillsynsobjekt,
    AT.strAnlaeggningstyp AS Anläggningstyp,
    AKI.strAnlaeggningskategori AS Anläggningskategori,
    A.decVolym AS Volym,
    A.datBeslutsdatum AS Beslutsdatum,
    A.datBesiktningsdatum as Besiktningsdatumk,
    A.intToemningsintervall AS Tömningsintervall,
    A.strText AS Text,
    A.strStatus as Status,
    A.datStatusDatum as Datum,
    A.intExterntTjaenstID as ExterntTjaenstID,
    A.strCertifieringstyp as Certifieringstyp,
    A.datToemningsdispensFrOM as ToemningsdispensFrOM,
[geometry]::Point(K.decY, K.decX, 3015) AS Shape
FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID

WHERE K.strPunkttyp='Efterföljande rening' OR K.strPunkttyp='Ansluten byggnad' OR K.strPunkttyp='Extra inventeringsin' OR K.strPunkttyp='Tank'

GO

/***************************************************************************************************************************************/


/****** Object:  View [dbo].[vwTrEaAvloppsanlaeggningPunkter]    Script Date: 2020-01-10 12:25:38 ******/
DROP VIEW [dbo].[vwTrEaAvloppsanlaeggningPunkter]
GO

/****** Object:  View [dbo].[vwTrEaAvloppsanlaeggningPunkter]    Script Date: 2020-01-10 12:25:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS A
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjektKoordinat AS TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K ON TK.recKoordinatID = K.recKoordinatID
WHERE K.decX IS NOT NULL AND K.decY IS NOT NULL AND (K.strPunkttyp='Ansluten byggnad' or K.strPunkttyp='Inventeringsinfo' or K.strPunkttyp='Efterföljande re' OR K.strPunkttyp='Slamavskiljare')



GO


