USE [EDPVisionRegionGotlandAvlopp]
GO

/****** Object:  StoredProcedure [dbo].[CalculateHuvudbeslutOnAerende]    Script Date: 2020-03-19 12:57:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


            CREATE PROCEDURE [dbo].[CalculateHuvudbeslutOnAerende]
	            -- Add the parameters for the stored procedure here
	            @aerendeId int = 0
            AS
            BEGIN
	            -- SET NOCOUNT ON added to prevent extra result sets from
	            -- interfering with SELECT statements.
	            SET NOCOUNT ON;

                -- Insert statements for procedure here
	            UPDATE tbAehAerende SET recLastHaendelseBeslutID =
	            (
		            SELECT TOP(1) recHaendelseBeslutID
		            FROM tbAehHaendelseBeslut
		            WHERE  recHaendelseID =
		            (
			            SELECT TOP(1) tbAehAerendeHaendelse.recHaendelseID
			            FROM tbAehAerendeHaendelse
			            LEFT JOIN tbAehHaendelse
				            ON tbAehAerendeHaendelse.recHaendelseID = tbAehHaendelse.recHaendelseID
			            LEFT JOIN tbAehHaendelseStatusLog
				            ON tbAehHaendelse.recLastHaendelseStatusLogID = recHaendelseStatusLogID
			            LEFT JOIN tbAehHaendelseStatusLogTyp
				            ON tbAehHaendelseStatusLog.recHaendelseStatusLogTypID = tbAehHaendelseStatusLogTyp.recHaendelseStatusLogTypID

			            WHERE tbAehAerendeHaendelse.recAerendeID = @aerendeId AND
			            bolHuvudbeslut = 1 AND
			            tbAehHaendelseStatusLogTyp.strLocalizationCode = 'ALLM'
		            )
	            )
	            WHERE tbAehAerende.recAerendeID = @aerendeId
            END
GO

