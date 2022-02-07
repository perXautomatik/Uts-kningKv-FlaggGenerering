--drop table #settingTable

create Table #settingTable (
rodDatum datetime
,RebuildStatus integer
)

insert into #settingTable (rodDatum, RebuildStatus)
select DATETIME2FROMPARTS(2006, 10, 1, 1, 1, 1, 1, 1),  1
