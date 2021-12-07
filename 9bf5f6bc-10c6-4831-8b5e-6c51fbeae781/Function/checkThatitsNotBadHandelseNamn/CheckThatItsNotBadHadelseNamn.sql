begin try
IF OBJECT_ID (N'dbo.checkThatItsNotBadHadelseNamn', N'FN') IS NOT NULL DROP FUNCTION checkThatItsNotBadHadelseNamn; END TRY BEGIN CATCH PRINT 'Error Number: ' + str(error_number()) ; PRINT 'Line Number: ' + str(error_line()); PRINT error_message(); ROLLBACK TRANSACTION; END CATCH; GO
CREATE FUNCTION dbo.checkThatItsNotBadHadelseNamn(@rub nvarchar(100)) RETURNS binary AS
BEGIN
    DECLARE @ret binary;
    IF @rub like 'Bekr�ftelse%'
        set @ret = 0;
    ELSE
        BEGIN
            IF @rub like 'Besiktning%'
                set @ret = 0;
            ELSE
                BEGIN
                    IF @rub like 'Klart Vatten%'
                        set @ret = 0;
                    ELSE
                        BEGIN
                            IF @rub like 'P�minnelse om �tg�rd%'
                                set @ret = 0;
                            ELSE
                                BEGIN
                                    IF @rub like '%Makulerad%'
                                        set @ret = 0;
                                    ELSE
                                        BEGIN
                                            IF @rub in
                                               ('Mottagningskvitto', 'Uppf�ljning 2 �r fr�n klart vatten utskick')
                                                set @ret = 0;
                                            ELSE
                                                set @ret = 1;
                                        END
                                END
                        END
                END
        END
    RETURN @ret;
END;
Go
