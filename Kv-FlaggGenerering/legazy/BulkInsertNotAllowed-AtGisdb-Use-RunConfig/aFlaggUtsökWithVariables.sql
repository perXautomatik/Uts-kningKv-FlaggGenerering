/*Insert Databases names into SQL Temp Table*/
declare @statusTable table (one NVARCHAR(max), start datetime, rader integer);
declare @rebuiltStatus1 as binary = 1;
declare @rebuiltStatus2 as binary = 1;
declare @sockenStrang Nvarchar(50)
set @sockenStrang = N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma';

-- dropTabels?
TableInitiate:
IF OBJECT_ID('tempdb..#SockenYtor') IS NULL goto SockenYtor;
IF OBJECT_ID('tempdb..#ByggnadPåFastighetISocken') IS NULL goto ByggnadPåFastighetISocken;
IF OBJECT_ID('tempdb..#Socken_tillstånd') IS NULL goto Socken_tillstånd;
IF OBJECT_ID('tempdb..#egetOmhändertagande') IS NULL goto egetOmhändertagande;
IF OBJECT_ID('tempdb..#spillvaten') IS NULL goto spillvaten;
IF OBJECT_ID('tempdb..#taxekod') IS NULL goto taxekod;
IF OBJECT_ID('tempdb..#röd') IS NULL goto röd;

goto repport

if (select 1) IS NULL
    BEGIN TRY
	Drop table #SockenYtor
	Drop table #ByggnadPåFastighetISocken
	Drop table #Socken_tillstånd
	Drop table #egetOmhändertagande
	Drop table #spillvaten
	Drop table #taxekod
	Drop table #röd
	INSERT
	INTO @statusTable
	select '#Rebuilding', CURRENT_TIMESTAMP, @@ROWCOUNT
    END TRY BEGIN CATCH
	SELECT 1
    END CATCH else INSERT
		   INTO @statusTable
		   select 'preloading#DidNotDiscard'
			, CURRENT_TIMESTAMP
			, @@ROWCOUNT;

declare @folder varchar(max) = 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\7e4fb899-0567-4da7-8a60-86bca3049c5c\Kv-FlaggGenerering\ExternalQuery\utsokningSocken\';
declare @q nvarchar(MAX);

SockenYtor:
IF OBJECT_ID('tempdb..#SockenYtor') IS NULL
    Begin
	BEGIN TRY
	    DROP TABLE #SockenYtor
	END TRY BEGIN CATCH
	    select 1
	END CATCH;

	declare @scriptName varchar(max) = 'sockenYtor.sql';
	set @q = dbo.trippleExecute(@folder, @scriptname)
	execute (@q)
	INSERT INTO @statusTable select 'rebuilt#SockenYtor', CURRENT_TIMESTAMP, @@ROWCOUNT
	set @rebuiltStatus1 = 1
    end else INSERT INTO @statusTable select 'preloading#SockenYtor', CURRENT_TIMESTAMP, @@ROWCOUNT;

goto TableInitiate;
ByggnadPåFastighetISocken:

goto TableInitiate;Socken_tillstånd:

goto TableInitiate;egetOmhändertagande:

goto TableInitiate;spillvaten:

goto TableInitiate;taxekod:

goto TableInitiate;
röd:

repport:
select * from @statusTable

select * from #röd where left(fastighet, len('Björke')) = 'Björke';
select * from #röd where left(fastighet, len('Dalhem')) = 'Dalhem';
select * from #röd where left(fastighet, len('Fröjel')) = 'Fröjel';
select * from #röd where left(fastighet, len('Ganthem')) = 'Ganthem';
select * from #röd where left(fastighet, len('Halla')) = 'Halla';
select * from #röd where left(fastighet, len('Halla')) = 'Halla';
select * from #röd where left(fastighet, len('Roma')) = 'Roma';



--select *
--        ifall ansökan på ärende på fastigheten, skriv diarenummer
--        anteckning + anmärkning
--        fastighets_Anslutningar_Gemensamhetanläggningar (gemNamn)
--        from  färdigt

--select * from grön
--union all
--select * from röd