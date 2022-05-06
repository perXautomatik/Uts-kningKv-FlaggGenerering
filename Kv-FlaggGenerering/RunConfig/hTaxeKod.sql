IF OBJECT_ID(N'tempdb..#Taxekod')  is null and (select null) is not null
    begin BEGIN TRY DROP TABLE #Taxekod END TRY BEGIN CATCH select 1 END CATCH;
select '' status into #taxekod
end
    go;
