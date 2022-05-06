IF OBJECT_ID('tempdb..#socknarOfInterest') IS not null OR (select top 1 RebuildStatus from #settingTable) = 1
    BEGIN TRY DROP TABLE #socknarOfInterest END TRY BEGIN CATCH select 'could not drop #socknarOfInterest' END CATCH;
go;
IF OBJECT_ID('tempdb..#socknarOfInterest') IS null
begin
create table #socknarOfInterest (Socken nvarchar (100) not null , shape geometry)
insert into #socknarOfInterest
select SOCKEN,Shape from
          STRING_SPLIT((select socknar from #settingtable), ',')
	   socknarOfIntresse
          inner join
              sde_regionstyrelsen.gng.nyko_socknar_y_evw
                  on SOCKEN = value
end
go

