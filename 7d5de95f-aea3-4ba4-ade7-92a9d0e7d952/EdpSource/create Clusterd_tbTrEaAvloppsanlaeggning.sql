USE [EDPVisionRegionGotlandAvlopp]
GO

/****** Object:  View [dbo].[Clusterd_tbTrEaAvloppsanlaeggning]    Script Date: 2020-03-19 12:56:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Clusterd_tbTrEaAvloppsanlaeggning]
WITH SCHEMABINDING
AS
SELECT recAvloppsanlaeggningID,
       recTillsynsobjektID,
       strBoendetyp,
       strVatten,
       bolIndraget,
       strAnlaeggningstyp,
       strStatus,
       intByggnadsaar,
       datBeslutsdatum,
       datBesiktningsdatum,
       strNotering,
       strEfterfoeljandereningReningstyp,
       intEfterfoeljandereningYta,
       strEfterfoeljandereningRecipient,
       strBedoemning,
       strInventering,
       datInventeringsdatum,
       intLoepnr,
       strVattenskyddsomraade,
       strPrioritet,
       strEfterpoleringTyp,
       intUnderhaallsintervallMaanad,
       datNaastaService,
       datFoeregaandeService,
       strAvrinningsomraade
from [dbo].tbTrEaAvloppsanlaeggning
GO

