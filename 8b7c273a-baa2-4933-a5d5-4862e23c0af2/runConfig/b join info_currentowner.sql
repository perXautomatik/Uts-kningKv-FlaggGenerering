use [tempExcel]
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar), 'addadress2'))
--;if object_id(' tempdb..FulaAdresser') is null begin CREATE table FulaAdresser (adress NVARCHAR NOT NULL PRIMARY KEY ) INSERT INTO FulaAdresser VALUES('DALHEM HALLVIDE 119, HALFVEDE, 62256 DALHEM'), ('c/o LILIAN PETTERSSON, SANDA STENHUSE 310'), ('DALHEM GRANSKOGS 966'), ('GRANSKOGS DALHEM 966'), (N'GAMLA NORRBYVÄGEN 15, ÖSTRA TÄCKERÅKER, 13674 NORRBY'), (N'ÖSTRA TÄCKERÅKER GAMLA NORRBYVÄGEN 15'), (N'ALVA GUDINGS 328 VÅN 2, GAMLA SKOLAN, 62346 HEMSE'), ('DALHEM KAUNGS 538, DUNBODI, 62256 DALHEM'), ('HERTZBERGSGATE 3 A0360 OSLO NORGE'), ('DALHEM HALLVIDE 119, HALFVEDE'), ('OLAV M. TROVIKS VEI 500864 OSLO NORGE'), ('LORNSENSTR. 30DE-24105 KIEL TYSKLAND'), (N'FRÜLINGSSTRASSE 3882110 GERMENING TYSKLAND'), (N'c/o FÖRENINGEN GOTLANDSTÅGET HÄSSELBY 166'), ('c/o TRYGGVE PETTERSSON KAUNGS 524'), (N'c/o L. ANDERSSON DJURSTRÖMS VÄG 11'), (N'PRÄSTBACKEN 8'), ('HALLA BROE 105'), (N'GAMLA SKOLAN ALVA GUDINGS 328 VÅN 2')
--end;      
begin try

with
    	x as (select dia,fnr,org from toInsert)
	,inputJoinedByFnrInfo_current_owner               as (
				      SELECT *
				      from [gisdata].SDE_GEOFIR_GOTLAND.GNG.INFO_CURRENTOWNER q
					  INNER JOIN  x on x.FNR = q.REALESTATEKEY
	  )

select * into rawFir from inputJoinedByFnrInfo_current_owner



end try
begin catch
    print ERROR_line()
end catch
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end2'));

select * from rawFir