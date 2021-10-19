USE [EDPVisionRegionGotlandAvlopp]
GO

/****** Object:  View [dbo].[View_1]    Script Date: 2020-03-19 12:54:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_1]
AS
SELECT 
TOP (100) PERCENT dbo.Blad1$.fliken_Ärenden AS Blad1_MittÄrende, Arende.Diarienummer,Arende.strAerendeKommentar ,
dbo.Blad1$.Besöksadress_Adress AS Blad1_Besöksadress, TillsynFas.strAdress AS TillsynFas_VisionAdress, dbo.Blad1$.Besöksadress_Postnr AS Blad1_Besöksadress_postnr, TillsynFas.strPostnummer AS TillsynFas_VisionPostnr, dbo.Blad1$.Besöksadress_Ort AS Blad1_Besöksadress_Ort, TillsynFas.strOrt AS TillsynFas_VisionOrt, dbo.Blad1$.Besöksadress_Huvudfastighet AS Blad1_Besöksadress_Huvudfastighet, dbo.Blad1$.FNR AS Blad1_FNR, dbo.Blad1$.Enhet AS Blad1_Enhet, dbo.Blad1$.Anteckning AS Blad1_Anteckning, dbo.Blad1$.Aktuell_timavgift AS Blad1_Aktuell_timavgift, dbo.Blad1$.Timdebitering AS Blad1_Timdebitering, dbo.Blad1$.Objektnamn AS Blad1_Objektnamn, TillsynFas.strObjektsNamn AS TillsynFas_VisionObjektnamn, dbo.Blad1$.flik_Avloppsänlaggni_Boendetyp AS Blad1_flik_Avloppsänlaggni_Boendetyp, dbo.Blad1$.flik_Avloppsanläggn_Byggnadsår AS Blad1_flik_Avloppsanläggn_Byggnadsår, dbo.Blad1$.flik_Avloppsa_Besiktningsdatum AS Blad1_flik_Avloppsa_Besiktningsdatum, dbo.Blad1$.flik_Avloppsanläg_Beslutsdatum AS Blad1_flik_Avloppsanläg_Beslutsdatum, dbo.Blad1$.Vatten AS Blad1_Vatten, dbo.Blad1$.Recipient AS Blad1_Recipient, dbo.Blad1$.Inventering AS Blad1_Inventering, dbo.Blad1$.Inventeringsinformation_Datum AS Blad1_Inventeringsinformation_Datum, dbo.Blad1$.Inventeringsinformation_Status AS Blad1_Inventeringsinformation_Status, dbo.Blad1$.fliken_Fastigheter AS Blad1_fliken_Fastigheter, dbo.Blad1$.fliken_FastigheterFNR AS Blad1_fliken_FastigheterFNR, dbo.Blad1$.PunkttypAB, dbo.Blad1$.Fliken_Koordinater AS Blad1_Fliken_Koordinater, dbo.Blad1$.Anläggningskategori AS Blad1_Anläggningskategori, VisionAnläggningar.strAnlaeggningskategori AS VisionAnläggningar_strAnlaeggningskategori, dbo.Blad1$.Anläggningstyp AS Blad1_Anläggningstyp, VisionAnläggningar.strAnlaeggningstyp AS VisionAnläggningar_strAnlaeggningstyp, dbo.Blad1$.Volym_m3 AS Blad1_Volym_m3, dbo.Blad1$.Anl_för_EftR_TöInterv_mån AS Blad1_Anl_för_EftR_TöInterv_mån, dbo.Blad1$.AnlF_efR_Koordinater_X_o_Y AS Blad1_AnlF_efR_Koordinater_X_o_Y, dbo.Blad1$.PunkttypER, dbo.Blad1$.Anläggning_för_EfterföljRText AS Blad1_Anläggning_för_EfterföljRText, dbo.Blad1$.Anläggningskategori_2 AS Blad1_Anläggningskategori_2, dbo.Blad1$.Anläggning_för_S_Anläggningstyp AS Blad1_Anläggning_för_S_Anläggningstyp, dbo.Blad1$.text AS Blad1_text, dbo.Blad1$.Anläggning_för_Slamav_Volym_m3 AS Blad1_Anläggning_för_Slamav_Volym_m3, dbo.Blad1$.Anläggningskategori_3 AS Blad1_Anläggningskategori_3, dbo.Blad1$.AnlförEfterR_Anläggningstyp AS Blad1_AnlförEfterR_Anläggningstyp, dbo.Blad1$.besiktningdatum_2 AS Blad1_besiktningdatum_2, dbo.Blad1$.beslutsdatum_2 AS Blad1_beslutsdatum_2, dbo.Blad1$.Externt_Tjänsteid2 AS Blad1_Externt_Tjänsteid2, dbo.Blad1$.Volym_m32 AS Blad1_Volym_m32, dbo.Blad1$.ObjektID AS Blad1_ObjektID, dbo.Blad1$.Path AS Blad1_Path, dbo.Blad1$.Löpnummer AS mittLöpnr, TillsynFas.strAnteckning AS TillsynFas_VisionAnt, TillsynFas.bolTimdebitering AS TillsynFas_VisionTimdb, TillsynFas.recTillsynsobjektTypID AS TillsynFas_recTillsynsobjektTypID, VisionAnläggningar.recAnlaeggningID AS VisionAnläggningar_recAnlaeggningID, VisionAnläggningar.strCertifieringstyp AS VisionAnläggningar_strCertifieringstyp, VisionAnläggningar.decVolym AS VisionAnläggningar_decVolym, VisionAnläggningar.strToaletttyp AS VisionAnläggningar_strToaletttyp, VisionAnläggningar.strText AS VisionAnläggningar_strText, VisionAnläggningar.AnlrecTillsynsobjektID AS VisionAnläggningar_recTillsynsobjektID
FROM 
  dbo.Blad1$ 
	LEFT OUTER JOIN 
		( SELECT dbo.tbTrTillsynsobjekt.recTillsynsobjektID AS AnlrecTillsynsobjektID, dbo.tbTrEaAnlaeggning.recAnlaeggningID, dbo.tbTrEaAnlaeggning.recAvloppsanlaeggningID, dbo.tbTrEaAnlaeggning.recAnlaeggningskategoriID, dbo.tbTrEaAnlaeggning.recAnlaeggningstypID, dbo.tbTrEaAnlaeggning.strCertifieringstyp, dbo.tbTrEaAnlaeggning.decVolym, dbo.tbTrEaAnlaeggning.datBeslutsdatum, dbo.tbTrEaAnlaeggning.datBesiktningsdatum, dbo.tbTrEaAnlaeggning.intToemningsintervall, dbo.tbTrEaAnlaeggning.datToemningsdispensFrOM, dbo.tbTrEaAnlaeggning.datToemningsdispensTOM, dbo.tbTrEaAnlaeggning.intExterntTjaenstID, dbo.tbTrEaAnlaeggning.strToaletttyp, dbo.tbTrEaAnlaeggning.strText, dbo.tbTrEaAnlaeggning.datStatusDatum, dbo.tbTrEaAnlaeggning.strStatus, dbo.tbTrEaAnlaeggningstyp.strAnlaeggningstyp, dbo.tbTrEaAnlaeggningskategori.strAnlaeggningskategori FROM dbo.tbTrEaAnlaeggning LEFT OUTER JOIN dbo.tbTrEaAnlaeggningskategori ON dbo.tbTrEaAnlaeggning.recAnlaeggningskategoriID = dbo.tbTrEaAnlaeggningskategori.recAnlaeggningskategoriID INNER JOIN dbo.tbTrEaAvloppsanlaeggning ON dbo.tbTrEaAnlaeggning.recAvloppsanlaeggningID = dbo.tbTrEaAvloppsanlaeggning.recAvloppsanlaeggningID INNER JOIN dbo.tbTrTillsynsobjekt ON dbo.tbTrEaAvloppsanlaeggning.recTillsynsobjektID = dbo.tbTrTillsynsobjekt.recTillsynsobjektID LEFT OUTER JOIN dbo.tbTrEaAnlaeggningstyp ON dbo.tbTrEaAnlaeggning.recAnlaeggningstypID = dbo.tbTrEaAnlaeggningstyp.recAnlaeggningstypID)
	AS VisionAnläggningar 

	LEFT OUTER JOIN 
		( SELECT tbTrTillsynsobjekt_1.recTillsynsobjektTypID, tbTrTillsynsobjekt_1.strOrt, tbTrTillsynsobjekt_1.strAnteckning, tbTrTillsynsobjekt_1.bolTimdebitering, tbTrTillsynsobjekt_1.strPostnummer, dbo.tbVisDeladFastighet.recFastighet AS intRecnum, dbo.tbVisDeladFastighet.recFastighet, dbo.tbVisDeladFastighet.strFnrID, dbo.tbVisDeladFastighet.strFastighetsbeteckning, dbo.tbVisDeladFastighetAdress.strAdress, dbo.tbVisDeladFastighetAdress.strPostnr, dbo.tbVisDeladFastighetAdress.strPostort, tbTrTillsynsobjekt_1.recTillsynsobjektID, tbTrTillsynsobjekt_1.strObjektsNamn, tbTrTillsynsobjekt_1.recVerksamhetID, dbo.tbTrTillsynsobjektsTyp.strTillsynsobjektsTypNamn FROM dbo.tbTrTillsynsobjektFastighet LEFT OUTER JOIN dbo.tbVisDeladFastighet ON dbo.tbTrTillsynsobjektFastighet.strFnrID = dbo.tbVisDeladFastighet.strFnrID LEFT OUTER JOIN dbo.tbVisDeladFastighetAdress ON dbo.tbVisDeladFastighetAdress.strFnrID = dbo.tbVisDeladFastighet.strFnrID LEFT OUTER JOIN dbo.tbTrTillsynsobjekt AS tbTrTillsynsobjekt_1 ON dbo.tbTrTillsynsobjektFastighet.recTillsynsobjektID = tbTrTillsynsobjekt_1.recTillsynsobjektID LEFT OUTER JOIN dbo.tbTrTillsynsobjektsTyp ON tbTrTillsynsobjekt_1.recTillsynsobjektTypID = dbo.tbTrTillsynsobjektsTyp.recTillsynsobjektTypID )
	AS TillsynFas 
		ON TillsynFas.recTillsynsobjektID = VisionAnläggningar.AnlrecTillsynsobjektID
		ON dbo.Blad1$.Objektnamn = TillsynFas.strObjektsNamn
 
	LEFT OUTER JOIN 
	(SELECT dbo.tbTrTillsynsobjektAerende.recTillsynsobjektID as ArecTillsynsobjektID, CAST( dbo.tbAehAerende.strDiarienummerSerie AS CHAR VARYING ) + '-' + CAST( dbo.tbAehDiarieAarsSerie.intDiarieAar AS CHAR VARYING ) + '-' + CAST( dbo.tbAehAerende.intDiarienummerLoepNummer AS CHAR VARYING ) as Diarienummer, dbo.tbAehAerende.strAerendemening, dbo.tbAehAerende.strSoekbegrepp, dbo.tbAehAerende.strAerendeKommentar, dbo.tbAehAerende.recAerendeID from dbo.tbTrTillsynsobjektAerende LEFT OUTER JOIN dbo.tbAehAerende on dbo.tbAehAerende.recAerendeID = dbo.tbTrTillsynsobjektAerende.recAerendeID Left Outer Join dbo.tbAehDiarieAarsSerie on dbo.tbAehAerende.recDiarieAarsSerieID = dbo.tbAehDiarieAarsSerie.recDiarieAarsSerieID) 
	as Arende
	ON Arende.ArecTillsynsobjektID = TillsynFas.recTillsynsobjektID 

  AND dbo.Blad1$.Anläggningskategori = VisionAnläggningar.strAnlaeggningskategori 
WHERE 
  (
    dbo.Blad1$.fliken_Ärenden IS NOT NULL
  )

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[51] 2[25] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tbAehAerende"
            Begin Extent = 
               Top = 373
               Left = 988
               Bottom = 503
               Right = 1241
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "tbTrTillsynsobjektAerende"
            Begin Extent = 
               Top = 344
               Left = 1442
               Bottom = 457
               Right = 1674
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbAehDiarieAarsSerie"
            Begin Extent = 
               Top = 387
               Left = 324
               Bottom = 517
               Right = 518
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Blad1$"
            Begin Extent = 
               Top = 137
               Left = 2221
               Bottom = 267
               Right = 2498
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "VisionAnläggningar"
            Begin Extent = 
               Top = 195
               Left = 2800
               Bottom = 325
               Right = 3036
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "tbAehDiarieSerie"
            Begin Extent = 
               Top = 406
               Left = 21
               Bottom = 570
               Right = 241
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl"
            Begin Extent = 
               Top = 384
               Left = 664
               Bottom = 477
       ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'        Right = 863
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TillsynFas"
            Begin Extent = 
               Top = 221
               Left = 1851
               Bottom = 351
               Right = 2083
            End
            DisplayFlags = 280
            TopColumn = 11
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 18
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2730
         Alias = 2880
         Table = 2880
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_1'
GO

