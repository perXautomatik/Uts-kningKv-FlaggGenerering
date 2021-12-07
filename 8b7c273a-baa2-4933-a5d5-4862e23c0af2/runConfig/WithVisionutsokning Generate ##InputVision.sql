use [tempExcel]
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'visionUtsökning12'))
--joinX as (select * from [admsql04].[EDPVisionRegionGotland].DBO.VWAEHAERENDE INNER join FastighetsLista ON coalesce(nullif([admsql04].[EDPVisionRegionGotland].DBO.VWAEHAERENDE.strFastighetsbeteckning,''),strSoekbegrepp) = FastighetsLista.FASTIGHET),
/*,isnull(h.STRRUBRIK,1) strUbrik,
	       nullif(a.STRAERENDEMENING,@ARMENING) mening,
	    	nullif(a.strAerendeStatusPresent,@STATUSFILTER1) status1,
	          nullif(a.strAerendeStatusPresent,@STATUSFILTER2) status2*/     
begin try
declare @inputFnr dbo.KontaktUpgTableType;
declare @arMening as VARCHAR(200) set @arMening = 'Klart vatten - information om avlopp';
declare @diareAr as int set @diareAr = null;
declare @lopNrLargerOrEq as int set @lopNrLargerOrEq = null;
DECLARE @handRubrik1 as NVARCHAR(200)
DECLARE @handRubrik2 as NVARCHAR(200)
set @handRubrik1 = N'%utförandeintyg'
set @handRubrik2 = N'Ansökan/anmälan om enskild cavloppsanläggning%';
DECLARE	@HandKat as VARCHAR(50) set @HandKat = N'ANSÖKAN';
declare @statusFilter1 as varchar(50) set @STATUSFILTER1 = 'Makulerat';
declare @statusFilter2 as varchar(50) set @STATUSFILTER2 = 'Avslutat';


if object_id('tempdb..inputVision') is null begin
begin TRANSACTION;
with
    arendenNotOStatusAndWithMening as (select STRDIARIENUMMER,STRFASTIGHETSBETECKNING,STRSOEKBEGREPP,STRFNRID,strLogKommentar,strAerendeStatusPresent,STRAERENDEMENING,RECAERENDEID from  [admsql04].[EDPVisionRegionGotland].DBO.VWAEHAERENDE
	             Where
	                not( strAerendeStatusPresent =@STATUSFILTER1 or strAerendeStatusPresent= @STATUSFILTER2) and STRAERENDEMENING = @ARMENING
	             )
    ,h as (select RECAERENDEID, (IIF(strRubrik is null, @HandKat, strRubrik)) strRubrikx, DatDatum
    		from [admsql04].[EDPVisionRegionGotland].DBO.vwAehHaendelse q
	        WHERE  q.strHaendelseKategori = @HandKat or --ansokan
	              strRubrik like @HANDRUBRIK1 Or --utfarandeintyg
	              strRubrik like @HANDRUBRIK2 ) --ansökananmalan

   ,selectArendenFilterBySockenAndHandelse as (
    SELECT arendenNotOStatusAndWithMening.STRDIARIENUMMER Dia,STRFASTIGHETSBETECKNING,STRSOEKBEGREPP
           ,STRFNRID fnr, arendenNotOStatusAndWithMening.strLogKommentar,strAerendeStatusPresent
    	   ,coalesce(DatDatum, GETDATE()) inskdatum
		
	    FROM arendenNotOStatusAndWithMening
	    INNER JOIN SOCKENLISTA ON LEFT(coalesce(nullif(arendenNotOStatusAndWithMening.STRFASTIGHETSBETECKNING, ''), arendenNotOStatusAndWithMening.STRSOEKBEGREPP), len(SOCKEN)) = SOCKEN

	    LEFT OUTER JOIN H ON arendenNotOStatusAndWithMening.RECAERENDEID = h.RECAERENDEID
	    Where h.strRubrikx IS NULL
	)
    ,inputVision as (SELECT Dia, STRFASTIGHETSBETECKNING,STRSOEKBEGREPP, fnr,coalesce(strLogKommentar,strAerendeStatusPresent) as strLogKommentar from selectArendenFilterBySockenAndHandelse)

    select * into inputVision from inputVision;
end
end try
begin catch
    insert into tempExcel.dbo.resultatRunConf(dnr,antal) values ('genINput',ERROR_line())
end catch
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end12'));