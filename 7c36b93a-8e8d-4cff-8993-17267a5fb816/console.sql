create table tbAehAerendeHaendelse
(
	recAerendeHaendelseID int identity
		constraint PK_tbAehAerendeHaendelse_recAerendeHaendelseID
			primary key,
	recAerendeID int not null
		constraint FK_tbAehAerendeHaendelsetbAehAerende_recAerendeID
			references tbAehAerende,
	recHaendelseID int not null
		constraint U_tbAehAerendeHaendelse_recHaendelseID
			unique
		constraint FK_tbAehAerendeHaendelse_recHaendelseID
			references tbAehHaendelse,
	intLoepnummerHaendelse int,
	bolHuvudbeslut bit constraint DF_tbAehAerendeHaendelse_bolHuvudbeslut default 0 not null
)
go

create index IX_tbAehAerendeHaendelse_recAerendeID
	on tbAehAerendeHaendelse (recAerendeID) include (recHaendelseID, intLoepnummerHaendelse, bolHuvudbeslut)
go

create index IX_tbAehAerendeHaendelse_recHaendelseID
	on tbAehAerendeHaendelse (recHaendelseID) include (recAerendeID, intLoepnummerHaendelse, bolHuvudbeslut)
go


        CREATE TRIGGER TRG_tbAehAerendeHaendelse_INSERT_UPDATE_DELETE ON tbAehAerendeHaendelse
        AFTER INSERT, UPDATE, DELETE
        AS
        BEGIN
        SET NOCOUNT ON;

        DECLARE aerende_cursor1 CURSOR FAST_FORWARD
        FOR
        SELECT recAerendeID FROM INSERTED UNION SELECT recAerendeID FROM DELETED
        OPEN aerende_cursor1
        DECLARE @recAerendeID as INT
        FETCH NEXT FROM aerende_cursor1 INTO @recAerendeID
        WHILE (@@fetch_status = 0)
        BEGIN
            EXEC CalculateHuvudbeslutOnAerende @aerendeId = @recAerendeID

            FETCH NEXT FROM aerende_cursor1 INTO @recAerendeID
        END
        CLOSE aerende_cursor1
        DEALLOCATE aerende_cursor1
        END
go


        -- =============================================
        -- Author:		David Svedberg,Dzenan Dabulhanic
        -- Create date: 2016-02-23
        -- Description:	<Description,,>
        -- =============================================
        CREATE TRIGGER TRG_tbAehAerendeHaendelse_SetMoetesDatum ON tbAehAerendeHaendelse
        AFTER INSERT,DELETE
        AS
        BEGIN
            -- SET NOCOUNT ON; added to prevent extra result sets from
            -- interfering with SELECT statements.
            SET NOCOUNT ON;
            DECLARE @recAerendeID INT
            DECLARE aerendeid_cursor CURSOR FAST_FORWARD
            FOR
            SELECT recAerendeID FROM INSERTED UNION SELECT recAerendeID FROM DELETED
            OPEN aerendeid_cursor
            FETCH NEXT FROM aerendeid_cursor INTO @recAerendeID
            WHILE (@@fetch_status = 0)
            BEGIN
                UPDATE tbAehAerende SET datMoetesDatum = dbo.FnAehAerendeMoetesDatum(@recAerendeID)
                WHERE tbAehAerende.recAerendeID = @recAerendeID
            FETCH NEXT FROM aerendeid_cursor INTO @recAerendeID
            END
            CLOSE aerendeid_cursor
            DEALLOCATE aerendeid_cursor

        END
go

