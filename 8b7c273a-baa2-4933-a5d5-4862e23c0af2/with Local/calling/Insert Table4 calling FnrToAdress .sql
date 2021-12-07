DECLARE @Table4 AS dbo.KontaktUpgTableType
begin try
    INSERT INTO @Table4 (Diarienummer, fnr) select diarienummer, fnr
    from @table3 select * from dbo.FnrToAdress(@Table4)
end try
begin catch
    print ERROR_line()
end catch