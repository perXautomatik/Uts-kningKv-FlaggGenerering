begin try drop table #settingTable end try begin catch select 'failed to drop setting table' end catch

create Table #settingTable (
rodDatum datetime
,RebuildStatus integer
,socknar nvarchar(300)
)

insert into #settingTable (rodDatum, RebuildStatus,socknar)
select DATETIME2FROMPARTS(2006, 10, 1, 1, 1, 1, 1, 1),
       0,
	N'Bara,Hörsne,Källunge,Norrlanda,Stenkyrka,Vallsten'
go

