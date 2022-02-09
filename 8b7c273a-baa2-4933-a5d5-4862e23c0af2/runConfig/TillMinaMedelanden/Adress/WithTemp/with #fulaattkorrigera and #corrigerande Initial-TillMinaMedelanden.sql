:r "C:\Users\crbk01\.DataGrip2019.3\config\projects\Kv-Utsökning\TillMinaMedelanden\synonyms.sql";

--SELECT * TOP 3 ANDEL unless noone owns more than 25 then add all
--drop table  tempdb.dbo.##fulaAttKorrigera
--drop table  tempdb.dbo.##Corrigerande
--DROP INDEX KorrigeringsIndex on  tempdb.dbo.##Corrigerande
:r DropTemps.sql
:r header.sql
:r dropTemps2.sql
:r declareVars.sql
:r initiateRefTable.sql
:r initiateExcludeTable.sql
:r initiateSockenLista.sql
:r CreateToInsert.sql
:r initiateFulaAdresser.sql
:r initiateKalla.sql
:r initiateFardiga.sql
:r initiateKorrigerande.sql

--o	Vilande – Gem. Anläggning
--o	Vilande – kommunal anslutning
--o	Väntande – uppskov
--o	Väntande – överklangande

--Excelfilen ska ha kolumnerna
          -- dia        Fastighet          Ägare                 Postadress       Postnr                Postort              Personnr          Organisationsnr statuskommentar
with
     KORRIGERANDE AS (SELECT  tempdb.dbo.##FULAATTKORRIGERA.ÄGARE
			   ,  tempdb.dbo.##FULAATTKORRIGERA.POSTADRESS
			   ,  tempdb.dbo.##FULAATTKORRIGERA.POSTNR
			   ,  tempdb.dbo.##FULAATTKORRIGERA.POSTORT
			   ,  tempdb.dbo.##FULAATTKORRIGERA.[personnr/Organisationnr]
			   ,  tempdb.dbo.##FULAATTKORRIGERA.SOURCE
			   ,  tempdb.dbo.##CORRIGERANDE.ÄGARE                     CÄGARE
			   ,  tempdb.dbo.##CORRIGERANDE.POSTADRESS                CPOSTADRESS
			   ,  tempdb.dbo.##CORRIGERANDE.POSTNR                    CPOSTNR
			   ,  tempdb.dbo.##CORRIGERANDE.POSTORT                   CPOSTORT
			   ,  tempdb.dbo.##CORRIGERANDE.[personnr/Organisationnr] CPERSONNRORGAN
			   ,  tempdb.dbo.##CORRIGERANDE.SOURCE                    CSOURCE
			   ,  tempdb.dbo.##CORRIGERANDE.ID
		      FROM  tempdb.dbo.##CORRIGERANDE
			  INNER JOIN  tempdb.dbo.##FULAATTKORRIGERA ON  tempdb.dbo.##CORRIGERANDE.ID =  tempdb.dbo.##FULAATTKORRIGERA.ID)
    ,first as (
SELECT dia Dnr, beteckning fastighet, isnull(NAMN,'') [Ägare], isnull(replace(replace(ADRESS,', '+postnr,''),postort,''),'') Postadress, isnull(POSTNR,'') POSTNR, isnull(POSTORT,'') POSTORT, isnull(replace(PERSORGNR,'-',''),'') [personnr/Organisationnr], isnull(SOURCE,'') source, isnull(STATUSKOMMENTAR,'') STATUSKOMMENTAR
from  tempdb.dbo.##fordig
    LEFT OUTER JOIN  tempdb.dbo.##TOINSERT on  tempdb.dbo.##fordig.FNR =  tempdb.dbo.##TOINSERT.FNR
    INNER join KirFnr
        ON coalesce(#FORDIG.FNR,  tempdb.dbo.##TOINSERT.FNR) = KirFnr.fnr)
select *,concat(row_number() OVER (PARTITION BY dnr ORDER BY FASTIGHET),'/',count([personnr/Organisationnr]) over (PARTITION BY dnr))  Antal from (SELECT distinct DNR, FASTIGHET,
       COALESCE(CÄGARE,FIRST.ÄGARE) ÄGARE, COALESCE(CPOSTADRESS, FIRST.POSTADRESS) POSTADRESS, COALESCE(CPOSTNR, FIRST.POSTNR) POSTNR, COALESCE(CPOSTORT,FIRST.POSTORT) POSTORT, COALESCE(CPERSONNRORGAN, FIRST.[personnr/Organisationnr])[personnr/Organisationnr], COALESCE(CSOURCE,FIRST.SOURCE)SOURCE, STATUSKOMMENTAR
from first
	LEFT OUTER JOIN  korrigerande on
	    coalesce(korrigerande.ÄGARE,			first.Ägare) = 				first.Ägare AND
   	    coalesce(korrigerande.POSTADRESS,			FIRST.POSTADRESS) = 			FIRST.POSTADRESS AND
   	    coalesce(korrigerande.POSTNR,			FIRST.POSTNR) = 			FIRST.POSTNR AND
   	    coalesce(korrigerande.POSTORT,			FIRST.POSTORT) = 			FIRST.POSTORT AND
   	    coalesce(korrigerande.[personnr/Organisationnr],	FIRST.[personnr/Organisationnr]) = 	FIRST.[personnr/Organisationnr] AND
	    coalesce(korrigerande.SOURCE,			FIRST.SOURCE) = 			FIRST.SOURCE) as c
order by STATUSKOMMENTAR,POSTNR,dnr,ÄGARE,POSTORT,POSTADRESS