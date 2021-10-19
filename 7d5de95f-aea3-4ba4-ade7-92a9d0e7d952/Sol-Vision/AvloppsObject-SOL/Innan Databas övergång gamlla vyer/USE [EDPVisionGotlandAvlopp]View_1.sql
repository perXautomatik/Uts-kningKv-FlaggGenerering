USE [EDPVisionGotlandAvlopp]
GO

/****** Object:  View [dbo].[View_1]    Script Date: 2020-03-19 13:07:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_1]
AS
SELECT        TOP (100) PERCENT dbo.Blad1$.fliken_Ärenden AS MittÄrende, { fn CONCAT({ fn CONCAT(CAST(dbo.tbAehAerende.strDiarienummerSerie AS char(4)), { fn CONCAT('-', CAST(dbo.tbAehDiarieAarsSerie.intDiarieAar AS char(4))) }) }, 
                         { fn CONCAT('-', CAST(dbo.tbAehAerende.intDiarienummerLoepNummer AS char(4))) }) } AS VisionÄrende, dbo.Blad1$.Besöksadress_Adress, dbo.Blad1$.Besöksadress_Postnr, dbo.Blad1$.Besöksadress_Ort, 
                         dbo.Blad1$.Besöksadress_Huvudfastighet, dbo.Blad1$.FNR, dbo.Blad1$.Enhet, dbo.Blad1$.Anteckning, dbo.Blad1$.Aktuell_timavgift, dbo.Blad1$.Timdebitering, dbo.Blad1$.Objektnamn, 
                         dbo.Blad1$.flik_Avloppsänlaggni_Boendetyp, dbo.Blad1$.flik_Avloppsanläggn_Byggnadsår, dbo.Blad1$.flik_Avloppsa_Besiktningsdatum, dbo.Blad1$.flik_Avloppsanläg_Beslutsdatum, dbo.Blad1$.Vatten, dbo.Blad1$.Recipient, 
                         dbo.Blad1$.Inventering, dbo.Blad1$.Inventeringsinformation_Datum, dbo.Blad1$.Inventeringsinformation_Status, dbo.Blad1$.fliken_Fastigheter, dbo.Blad1$.fliken_FastigheterFNR, dbo.Blad1$.PunkttypAB, 
                         dbo.Blad1$.Fliken_Koordinater, dbo.Blad1$.Anläggningskategori, dbo.Blad1$.Anläggningstyp, dbo.Blad1$.Volym_m3, dbo.Blad1$.Anl_för_EftR_TöInterv_mån, dbo.Blad1$.AnlF_efR_Koordinater_X_o_Y, dbo.Blad1$.PunkttypER, 
                         dbo.Blad1$.Anläggning_för_EfterföljRText, dbo.Blad1$.Anläggningskategori_2, dbo.Blad1$.Anläggning_för_S_Anläggningstyp, dbo.Blad1$.text, dbo.Blad1$.Anläggning_för_Slamav_Volym_m3, 
                         dbo.Blad1$.Anläggningskategori_3, dbo.Blad1$.AnlförEfterR_Anläggningstyp, dbo.Blad1$.besiktningdatum_2, dbo.Blad1$.beslutsdatum_2, dbo.Blad1$.Externt_Tjänsteid2, dbo.Blad1$.Volym_m32, dbo.Blad1$.ObjektID, 
                         dbo.Blad1$.Path, dbo.Blad1$.Löpnummer AS mittLöpnr, TillsynFas.recTillsynsobjektTypID, TillsynFas.strObjektsNamn AS VisionObjektnamn, TillsynFas.strAdress AS VisionAdress, TillsynFas.strOrt AS VisionOrt, 
                         TillsynFas.strAnteckning AS VisionAnt, TillsynFas.bolTimdebitering AS VisionTimdb, TillsynFas.strPostnummer AS VisionPostnr, VisionAnläggningar.recAnlaeggningID, VisionAnläggningar.strCertifieringstyp, 
                         VisionAnläggningar.decVolym, VisionAnläggningar.strToaletttyp, VisionAnläggningar.strText, VisionAnläggningar.recTillsynsobjektID, VisionAnläggningar.strAnlaeggningstyp, VisionAnläggningar.strAnlaeggningskategori
FROM            dbo.Blad1$ LEFT OUTER JOIN
                             (SELECT        dbo.tbTrEaAnlaeggning.recAnlaeggningID, dbo.tbTrEaAnlaeggning.recAnlaeggningID AS intRecnum, dbo.tbTrEaAnlaeggning.recAvloppsanlaeggningID, dbo.tbTrEaAnlaeggning.recAnlaeggningskategoriID, 
                                                         dbo.tbTrEaAnlaeggning.recAnlaeggningstypID, dbo.tbTrEaAnlaeggning.strCertifieringstyp, dbo.tbTrEaAnlaeggning.decVolym, dbo.tbTrEaAnlaeggning.datBeslutsdatum, dbo.tbTrEaAnlaeggning.datBesiktningsdatum, 
                                                         dbo.tbTrEaAnlaeggning.intToemningsintervall, dbo.tbTrEaAnlaeggning.datToemningsdispensFrOM, dbo.tbTrEaAnlaeggning.datToemningsdispensTOM, dbo.tbTrEaAnlaeggning.intExterntTjaenstID, 
                                                         dbo.tbTrEaAnlaeggning.strToaletttyp, dbo.tbTrEaAnlaeggning.strText, dbo.tbTrEaAnlaeggning.datStatusDatum, dbo.tbTrEaAnlaeggning.strStatus, dbo.tbTrTillsynsobjekt.recTillsynsobjektID, 
                                                         dbo.tbTrEaAnlaeggningstyp.strAnlaeggningstyp, dbo.tbTrEaAnlaeggningskategori.strAnlaeggningskategori
                               FROM            dbo.tbTrEaAnlaeggning LEFT OUTER JOIN
                                                         dbo.tbTrEaAnlaeggningskategori ON dbo.tbTrEaAnlaeggning.recAnlaeggningskategoriID = dbo.tbTrEaAnlaeggningskategori.recAnlaeggningskategoriID INNER JOIN
                                                         dbo.tbTrEaAvloppsanlaeggning ON dbo.tbTrEaAnlaeggning.recAvloppsanlaeggningID = dbo.tbTrEaAvloppsanlaeggning.recAvloppsanlaeggningID INNER JOIN
                                                         dbo.tbTrTillsynsobjekt ON dbo.tbTrEaAvloppsanlaeggning.recTillsynsobjektID = dbo.tbTrTillsynsobjekt.recTillsynsobjektID LEFT OUTER JOIN
                                                         dbo.tbTrEaAnlaeggningstyp ON dbo.tbTrEaAnlaeggning.recAnlaeggningstypID = dbo.tbTrEaAnlaeggningstyp.recAnlaeggningstypID) AS VisionAnläggningar LEFT OUTER JOIN
                             (SELECT        tbTrTillsynsobjekt_1.recTillsynsobjektTypID, tbTrTillsynsobjekt_1.strOrt, tbTrTillsynsobjekt_1.strAnteckning, tbTrTillsynsobjekt_1.bolTimdebitering, tbTrTillsynsobjekt_1.strPostnummer, 
                                                         dbo.tbVisDeladFastighet.recFastighet AS intRecnum, dbo.tbVisDeladFastighet.recFastighet, dbo.tbVisDeladFastighet.strFnrID, dbo.tbVisDeladFastighet.strFastighetsbeteckning, 
                                                         dbo.tbVisDeladFastighetAdress.strAdress, dbo.tbVisDeladFastighetAdress.strPostnr, dbo.tbVisDeladFastighetAdress.strPostort, tbTrTillsynsobjekt_1.recTillsynsobjektID, tbTrTillsynsobjekt_1.strObjektsNamn, 
                                                         tbTrTillsynsobjekt_1.recVerksamhetID, dbo.tbTrTillsynsobjektsTyp.strTillsynsobjektsTypNamn
                               FROM            dbo.tbTrTillsynsobjektFastighet LEFT OUTER JOIN
                                                         dbo.tbVisDeladFastighet ON dbo.tbTrTillsynsobjektFastighet.strFnrID = dbo.tbVisDeladFastighet.strFnrID LEFT OUTER JOIN
                                                         dbo.tbVisDeladFastighetAdress ON dbo.tbVisDeladFastighetAdress.strFnrID = dbo.tbVisDeladFastighet.strFnrID LEFT OUTER JOIN
                                                         dbo.tbTrTillsynsobjekt AS tbTrTillsynsobjekt_1 ON dbo.tbTrTillsynsobjektFastighet.recTillsynsobjektID = tbTrTillsynsobjekt_1.recTillsynsobjektID LEFT OUTER JOIN
                                                         dbo.tbTrTillsynsobjektsTyp ON tbTrTillsynsobjekt_1.recTillsynsobjektTypID = dbo.tbTrTillsynsobjektsTyp.recTillsynsobjektTypID) AS TillsynFas LEFT OUTER JOIN
                         dbo.tbTrTillsynsobjektAerende LEFT OUTER JOIN
                         dbo.tbAehAerende LEFT OUTER JOIN
                         dbo.tbAehDiarieAarsSerie LEFT OUTER JOIN
                         dbo.tbAehDiarieSerie ON dbo.tbAehDiarieAarsSerie.recDiarieSerieID = dbo.tbAehDiarieSerie.recDiarieSerieID LEFT OUTER JOIN
                             (SELECT        MAX(intDiarienummerLoepNummer) AS intMaxLoepNummer, recDiarieAarsSerieID
                               FROM            dbo.tbAehAerende AS tbAehAerende_1
                               GROUP BY recDiarieAarsSerieID) AS tbl ON dbo.tbAehDiarieAarsSerie.recDiarieAarsSerieID = tbl.recDiarieAarsSerieID ON dbo.tbAehAerende.recDiarieAarsSerieID = tbl.recDiarieAarsSerieID ON 
                         dbo.tbTrTillsynsobjektAerende.recAerendeID = dbo.tbAehAerende.recAerendeID ON dbo.tbTrTillsynsobjektAerende.recTillsynsobjektAerendeID = TillsynFas.recTillsynsobjektID ON 
                         TillsynFas.recTillsynsobjektID = VisionAnläggningar.recTillsynsobjektID ON dbo.Blad1$.Objektnamn = TillsynFas.strObjektsNamn AND TillsynFas.strAnteckning = dbo.Blad1$.Anteckning
WHERE        (dbo.Blad1$.fliken_Ärenden IS NOT NULL)
ORDER BY dbo.Blad1$.ObjektID
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[47] 4[3] 2[50] 3) )"
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
         Top = -480
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Blad1$"
            Begin Extent = 
               Top = 20
               Left = 81
               Bottom = 206
               Right = 372
            End
            DisplayFlags = 280
            TopColumn = 44
         End
         Begin Table = "tbTrTillsynsobjektAerende"
            Begin Extent = 
               Top = 269
               Left = 732
               Bottom = 430
               Right = 964
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbAehAerende"
            Begin Extent = 
               Top = 330
               Left = 1236
               Bottom = 593
               Right = 1489
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "tbAehDiarieAarsSerie"
            Begin Extent = 
               Top = 509
               Left = 590
               Bottom = 706
               Right = 784
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbAehDiarieSerie"
            Begin Extent = 
               Top = 527
               Left = 263
               Bottom = 695
               Right = 483
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VisionAnläggningar"
            Begin Extent = 
               Top = 227
               Left = 122
               Bottom = 357
               Right = 358
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "TillsynFas"
            Begin Extent = 
               Top = 0
               Left = 995
               Bottom = 130
          ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     Right = 1227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl"
            Begin Extent = 
               Top = 491
               Left = 900
               Bottom = 587
               Right = 1099
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2760
         Alias = 1995
         Table = 1170
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

