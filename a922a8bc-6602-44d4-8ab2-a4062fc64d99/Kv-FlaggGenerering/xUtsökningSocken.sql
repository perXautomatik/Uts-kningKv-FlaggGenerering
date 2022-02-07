/*Insert Databases names into SQL Temp Table*/

declare @rebuiltStatus1 as binary = 0;
declare @rebuiltStatus2 as binary = 0;





declare @socknar table (socken nvarchar(70))


select * from #statustable
;


TableInitiate:
IF OBJECT_ID('tempdb..#FastighetsYtor') IS NULL goto FastighetsYtor else
 INSERT INTO #statusTable
        select 'preloading#FastighetsYtor'
             ,CURRENT_TIMESTAMP,(select count(*) from #FastighetsYtor)
;
IF OBJECT_ID('tempdb..#ByggnadPåFastighetISocken') IS NULL goto ByggnadPåFastighetISocken else
 INSERT INTO #statusTable
        select 'preloading#ByggnadPåFastighetISocken'
             ,CURRENT_TIMESTAMP,(select count(*) from #ByggnadPåFastighetISocken)
;
IF OBJECT_ID('tempdb..#Socken_tillstånd') IS NULL goto Socken_tillstånd else
 INSERT INTO #statusTable
        select 'preloading#Socken_tillstånd'
             ,CURRENT_TIMESTAMP,(select count(*) from #Socken_tillstånd)
;
IF OBJECT_ID('tempdb..#egetOmhändertagande') IS NULL goto egetOmhändertagande else
 INSERT INTO #statusTable
        select 'preloading#egetOmhändertagande'
             ,CURRENT_TIMESTAMP,(select count(*) from #egetOmhändertagande)
;
IF OBJECT_ID('tempdb..#spillvatten') IS NULL goto spillvatten else
 INSERT INTO #statusTable
        select 'preloading#spillvatten'
             ,CURRENT_TIMESTAMP,(select count(*) from #spillvatten)
;
IF OBJECT_ID('tempdb..#taxekod') IS NULL goto taxekod else
 INSERT INTO #statusTable
        select 'preloading#taxekod'
             ,CURRENT_TIMESTAMP,(select count(*) from #taxekod)
;
IF OBJECT_ID('tempdb..#röd') IS NULL goto röd;
 else
 INSERT INTO #statusTable
        select 'preloading#röd'
             ,CURRENT_TIMESTAMP,(select count(*) from #röd)
;

 FastighetsYtor:

ByggnadPåFastighetISocken:


;Socken_tillstånd:

;egetOmhändertagande:

;spillvatten:

;taxekod:

röd:
repport:
select * from #statusTable

select * from #röd
--select * from #röd where left(fastighet, len('Björke')) = 'Björke';
--select * from #röd where left(fastighet, len('Dalhem')) = 'Dalhem';
--select * from #röd where left(fastighet, len('Fröjel')) = 'Fröjel';
--select * from #röd where left(fastighet, len('Ganthem')) = 'Ganthem';
--select * from #röd where left(fastighet, len('Halla')) = 'Halla';
--select * from #röd where left(fastighet, len('Halla')) = 'Halla';
--select * from #röd where left(fastighet, len('Roma')) = 'Roma';


              --select *
--        ifall ansökan på ärende på fastigheten, skriv diarenummer
--        anteckning + anmärkning
--        fastighets_Anslutningar_Gemensamhetanläggningar (gemNamn)
--        from  färdigt

--select * from grön
--union all
--select * from röd



