begin try drop table #statusTable end try begin catch end catch create table #statusTable (one NVARCHAR(max), start datetime, rader integer);

TableInitiate:
-- dropTabels?

declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#FastighetsYtor') IS not NULL set @f = (select count(*) from #FastighetsYtor)end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values('#FastighetsYtor', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#ByggnadPåFastighetISocken') IS not NULL set @f = (select count(*) from #ByggnadPåFastighetISocken)end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(	'#ByggnadP', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#Socken_tillstånd 	') IS not NULL set @f = (select count(*) from #Socken_tillstånd )end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(		'#Socken_tillstån', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#egetOmhändertagande ') IS not NULL set @f = (select count(*) from #egetOmhändertagande)end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(		'#egetOmhändertagand', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#spillvatten') IS not NULL set @f = (select count(*) from #spillvatten )end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(				'#spillvatten', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#taxekod') IS not NULL set @f = (select count(*) from #taxekod )end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(					'#taxekod', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#röd') IS not NULL set @f = (select count(*) from #röd )end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(						'#röd', sysdatetime(),@f ) go

select * from #statustable
go
