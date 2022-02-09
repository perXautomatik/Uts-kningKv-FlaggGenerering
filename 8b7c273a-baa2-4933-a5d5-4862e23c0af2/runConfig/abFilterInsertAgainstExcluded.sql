use [tempExcel]
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'withexcluded10'))
    --insert into @inputFnr (id,Diarienummer,Fnr,fastighet,HÄNDELSEDATUM ) --;if object_id(' tempdb..TRM') is null begin begin  TRANSACTION--SELECT * INTO  TRM from @INPUTFNR ;--END adressCorrecting = gisTable1 -- don't think the view of gisTable1 has 3 segments, so union is not nessessary.--    ip as (select fnr from @INPUTFNR),
--delete from tempExcel.dbo.resultatRunConf where dnr is not null;
begin try
    drop table toInsert;
end try
begin catch
    print ERROR_line()
end catch
;
With
       	--input as (select coalesce(nullif(STRFASTIGHETSBETECKNING, ''), STRSOEKBEGREPP) kir, fnr,dia,strLogKommentar from inputVision)
	input as (select fastighetsnyckel fnr, fastighet kir, personorganisationnr org,diarienummer dia,fastighet fas,
	       * from agarlista)

	,correctFnrWithKirFnr as (select *,fnr fnrx from input)
   	       --coalesce(KirFnr.Fnr,a.fnr) Fnrx FROM input a LEFT OUTER JOIN KirFnr ON a.KIR = KirFnr.BETECKNING )
   	--vision has sometimes a internal nr instad of fnr in the fnrcolumn
	,withY as (select *,isnull(coalesce(nullif(T.DIA,''), nullif(T.FAS,'')),'') y from EXCLUDED T )
   	,withX as (SELECT t.*, isnull(coalesce(nullif(T.DIA,''), nullif(T.FAS,'')),'') X
   		FROM correctFnrWithKirFnr t )
   	,filterInputByDiaFas as (select x.* from withX x LEFT OUTER JOIN withy t on x.x = t.y WHERE t.y is null)

	select fnr,dia,org,STATUSKOMMENTAR into toInsert from filterInputByDiaFas

	insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'endinsert10'));

insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end10'));
