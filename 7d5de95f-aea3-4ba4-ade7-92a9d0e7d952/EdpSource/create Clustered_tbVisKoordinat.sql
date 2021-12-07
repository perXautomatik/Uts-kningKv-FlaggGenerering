USE [EDPVisionRegionGotlandAvlopp]
GO

/****** Object:  View [dbo].[Clusterd_tbVisKoordinat]    Script Date: 2020-03-19 12:55:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Clusterd_tbVisKoordinat]
 WITH SCHEMABINDING
AS
 SELECT recKoordinatID,
            decX,
          decY,
        strPunkttyp,
      strAnteckning
FROM [dbo].tbVisKoordinat
WHERE decX IS NOT NULL AND decY IS NOT NULL
GO

