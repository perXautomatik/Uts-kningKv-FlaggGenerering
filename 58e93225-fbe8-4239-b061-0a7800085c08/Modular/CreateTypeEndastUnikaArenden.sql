Begin try
    DROP TYPE [dbo].[TT_EndastUnikaArenden]
create Type TT_EndastUnikaArenden
AS TABLE
(
    Diarienummer varchar(20) not null
        primary key nonclustered (Diarienummer)
)
end TRY BEGIN CATCH end CATCH
go
