
--Så funktionen bör kunna:
--Utifrån en tidsperiod (alltid en månad)
--Få ut alla beslut om enskild avloppsanläggning (via händelse rubrik)
--Skilja på vilka av dessa som är nya och förbättringar (via ärendemening)
-- är det inte altid förra månaden när man gör utsökningen?
-- rubriken bör inte vara fritext
-- vi behöver väta ärendets ansökan för att beta om det är nytt eller förbättrad.
-- det är uppenbart att det inte går att förstå vilken

declare @handelseDatumYear integer;
declare @handelseDatumMonth integer;
declare @enhetsNamn varchar(20);
set @handelseDatumMonth = 3;
set @handelseDatumYear = 2020;
set @enhetsNamn = 'Team Vatten';

with
strRubrikLike      	 as (select '%beslut%' strRubrik union select '%avl%' strRubrik )
,handelserOfInterest 	 as (select h.*from EDPVisionRegionGotland.dbo.vwAehHaendelse h inner join strRubrikLike on h.strRubrik like strRubrikLike.strRubrik
			      where year(datHaendelseDatum) = @handelseDatumYear and month(datHaendelseDatum) = @handelseDatumMonth and strEnhetNamn = @enhetsNamn)
,AnOmHandelser            as (select strDiarienummer,strRubrik,datHaendelseDatum from EDPVisionRegionGotland.dbo.vwAehHaendelse where strRubrik like '%an om%')
,treKolumnerOfhandelser   as (select strDiarienummer,strRubrik,strAerendemening from handelserOfInterest)
,tvaKolumnerOfHandelser   as (select strDiarienummer,strRubrik from treKolumnerOfhandelser)
,latest1Handelse 	  as (select tvaKolumnerOfHandelser.strDiarienummer, z.strRubrik ansökan
	from tvaKolumnerOfHandelser cross apply (select top 1 * from AnOmHandelser where strDiarienummer = tvaKolumnerOfHandelser.strDiarienummer order by year(datHaendelseDatum), month(datHaendelseDatum),day(datHaendelseDatum)) z where tvaKolumnerOfHandelser.strDiarienummer = z.strDiarienummer)
select
       IIF(treKolumnerOfhandelser.strAerendemening = 'Klart vatten - information om avlopp' OR latest1Handelse.ansökan like N'%örbättring%', N'förbättring', 'ny') typ, treKolumnerOfhandelser.strDiarienummer,
       replace(strRubrik,N'Beslut om enskild avloppsanläggning','Beslut') 						typAvBeslut,
       replace(replace(strAerendemening,'Klart vatten - information om avlopp','KV'),N'Ansökan/anmälan om enskild avloppsanläggning',N'ansökan') strAerendemening,
       replace(latest1Handelse.ansökan ,N'Ansökan/anmälan om enskild avloppsanläggning',N'ansökan')  			ansökan
from treKolumnerOfhandelser left outer join latest1Handelse
    on latest1Handelse.strDiarienummer = treKolumnerOfhandelser.strDiarienummer
order by typ


