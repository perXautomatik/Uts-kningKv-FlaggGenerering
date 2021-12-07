USE [EDPVisionGotlandAvlopp]
GO

/****** Object:  Table [dbo].[Blad1$]    Script Date: 2020-03-19 13:06:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Blad1$](
	[Besöksadress_Adress] [nvarchar](255) NULL,
	[Besöksadress_Postnr] [nvarchar](255) NULL,
	[Besöksadress_Ort] [nvarchar](255) NULL,
	[Besöksadress_Huvudfastighet] [nvarchar](255) NULL,
	[FNR] [float] NULL,
	[Verksamhetsutövare_Namn] [nvarchar](255) NULL,
	[Verksamhetsutöv_Person_orgnr] [float] NULL,
	[Fakturamottagare_NAMN] [nvarchar](255) NULL,
	[Fakturamottagare_Faktura_ADRESS] [nvarchar](255) NULL,
	[Fakturamottagare_Faktura_POSTNR] [nvarchar](255) NULL,
	[Fakturamottagare_Faktura_POSTOR] [nvarchar](255) NULL,
	[Enhet] [nvarchar](255) NULL,
	[Anteckning] [nvarchar](255) NULL,
	[Aktuell_timavgift] [float] NULL,
	[Timdebitering] [nvarchar](255) NULL,
	[Objektnamn] [nvarchar](255) NULL,
	[flik_Avloppsänlaggni_Boendetyp] [nvarchar](255) NULL,
	[flik_Avloppsanläggn_Byggnadsår] [nvarchar](255) NULL,
	[flik_Avloppsa_Besiktningsdatum] [float] NULL,
	[flik_Avloppsanläg_Beslutsdatum] [float] NULL,
	[Vatten] [float] NULL,
	[Recipient] [nvarchar](255) NULL,
	[Inventering] [nvarchar](255) NULL,
	[Inventeringsinformation_Datum] [float] NULL,
	[Inventeringsinformation_Status] [nvarchar](255) NULL,
	[Bedömning] [nvarchar](255) NULL,
	[fliken_Fastigheter] [nvarchar](255) NULL,
	[fliken_FastigheterFNR] [float] NULL,
	[PunkttypAB] [nvarchar](255) NULL,
	[Fliken_Koordinater] [nvarchar](255) NULL,
	[fliken_Ärenden] [nvarchar](255) NULL,
	[Anläggningskategori] [nvarchar](255) NULL,
	[besiktningdatum] [nvarchar](255) NULL,
	[beslutsdatum] [nvarchar](255) NULL,
	[Anläggningstyp] [nvarchar](255) NULL,
	[Volym_m3] [float] NULL,
	[Anl_för_EftR_TöInterv_mån] [float] NULL,
	[AnlF_efR_Koordinater_X_o_Y] [nvarchar](255) NULL,
	[PunkttypER] [nvarchar](255) NULL,
	[Anläggning_för_EfterföljRText] [nvarchar](255) NULL,
	[Anläggningskategori_2] [nvarchar](255) NULL,
	[Anläggning_för_S_Anläggningstyp] [nvarchar](255) NULL,
	[Externt_Tjänsteid] [float] NULL,
	[text] [nvarchar](255) NULL,
	[Anläggning_för_Slamav_Volym_m3] [float] NULL,
	[Anläggningskategori_3] [nvarchar](255) NULL,
	[AnlförEfterR_Anläggningstyp] [nvarchar](255) NULL,
	[besiktningdatum_2] [nvarchar](255) NULL,
	[beslutsdatum_2] [nvarchar](255) NULL,
	[Externt_Tjänsteid2] [float] NULL,
	[Volym_m32] [float] NULL,
	[ObjektID] [float] NULL,
	[Path] [nvarchar](255) NULL,
	[Diarienummer] [nvarchar](255) NULL,
	[Löpnummer] [float] NULL
) ON [PRIMARY]
GO

