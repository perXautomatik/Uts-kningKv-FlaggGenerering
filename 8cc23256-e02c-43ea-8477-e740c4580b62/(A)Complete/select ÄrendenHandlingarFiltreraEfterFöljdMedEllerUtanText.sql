-- generell implementation av utsökningar, minmal ändring i kod skall tillåta olika ändamål men samma formatering, samma utsökning.$action exempel, förbudsutsökning ärenden, med aktiva förbud. är en ärendeutsökning tabort ärenden utan händelse av typ förbud äreneden, med aktiva avloppsäärenden, inom socknar how do we alter the search type, and maintain the structure, söktyp ärende/händelse aktiva förbud = har förbud och har inte utförandeintyg (datum u > f) vi will ha maximal mängd av joins--Så funktionen bör kunna:--Utifrån en tidsperiod (alltid en månad)--Få ut alla beslut om enskild avloppsanläggning (via händelse rubrik)--Skilja på vilka av dessa som är nya och förbättringar (via ärendemening) är det inte altid förra månaden när man gör utsökningen? rubriken bör inte vara fritext vi behöver väta ärendets ansökan för att beta om det är nytt eller förbättrad. det är uppenbart att det inte går att förstå vilken--Use [admsql04].EDPVisionRegionGotland;

-- modular aproach;
-- () enclosed text, from or not from files, but enbedded in string variables, then get inlined for the final product.
--LookingFor/ignoredIfNull
declare @handelseDatumMonth 	 integer = 3;
declare @handelseDatumYear   	 integer = 2020;
--LookingFor/ignoredIfNull
declare @enhetsKod		 Nvarchar(90) = 'Vatten';
declare @enhetsNamn 		 Nvarchar(20) = 'Team Vatten';
declare @arendeText		 Nvarchar(90) = '%atten%';
declare @arendeMening		 Nvarchar(90) = 'Klart Vatten%';
--Filtering/ignoredIfNull
declare @IarendeStatus		 Nvarchar(90) = 'Assault';
declare @IarendeStatus1		 Nvarchar(90) = 'Avslutat';
declare @IarendeStatus2		 Nvarchar(90) = 'Makulerat';



--Stringsplit
declare @stringSplitVar1 varchar(10) = '</x>'; declare @stringSplitVar2 varchar(10) = '<x>'; declare @stringSplitDelim varchar(10) = ',';

--OnskadeHandlingar
IF OBJECT_ID('tempdb..#OnskadeHandlingar') IS NOT NULL DROP TABLE #OnskadeHandlingar create table #OnskadeHandlingar ( namn varchar(max) )
declare @toSplit as table (toSplit nvarchar(max)) insert into @toSplit select
     N'Reviderad ansökan ensklit avlopp' +
    N',Reviderad ansökan' +
    N',Kompletteringsbegäran skickad' +
    N',Kompletteringsbegäran' +
    N',Komplettering-situationsplan' +
    N',Komplettering' +
    N',situationsplan' +
    N',Komplettering' +
    N',Komplett ansökan' +
    N',Beslut om enskild avloppsanläggning BDT+ WC' +
    N',Beslut om enskild avloppsanläggning BDT + Tank' +
    N',Besiktningsprotokoll - provgrop' +
    N',Avlopp - utförandeintyg' +
    N',Ansökan/anmälan om enskild avloppsanläggning' +
    N',Ansökan med underskrift'
insert into #OnskadeHandlingar SELECT distinct SplitValue FROM  (select toSplit from @toSplit) q Cross Apply ( Select Seq   = Row_Number() over (Order By (Select null)) ,SplitValue = v.value('(./text())[1]', 'varchar(max)') From  (values (convert(xml,@stringSplitVar2 + replace(toSplit,@stringSplitDelim,@stringSplitVar1+@stringSplitVar2)+@stringSplitVar1))) x(n) Cross Apply n.nodes('x') node(v) ) B delete from @toSplit where toSplit is not null



IF OBJECT_ID('tempdb..#filterArendeWhomHasAnsokan') IS NOT NULL DROP TABLE #filterArendeWhomHasAnsokan
create table dbo.#filterArendeWhomHasAnsokan (dianr              nvarchar(max), kir                nvarchar(max), Handläggarsignatur nvarchar(max), Huvudkontakt       nvarchar(max), Sökbegrepp         nvarchar(max), ArendeText         nvarchar(max), status             nvarchar(max), Beslutsdatum       nvarchar(max), Kommentar          nvarchar(max), Löpnummer          int, dat                datetime2, Händelsekategori   nvarchar(max), rikt               nvarchar(max), rub                nvarchar(max), HandelseText       nvarchar(max), has                nvarchar(max));
--insert into #filterArendeWhomHasAnsokan

with
    socknarOFinterest as ( select namn socken from #sockNarOFIntresse)

   , filterArendeByParams as (select h.*
				  from EDPVisionRegionGotland.dbo.vwAehAerende h
				    where
				    (
				    h.strAerendeStatusPresent != @IarendeStatus1
				    AND
				    h.strAerendeStatusPresent != @IarendeStatus2
				    and
				    strAerendeStatusPresent != @IarendeStatus
				    )
				    and
				    (
				    h.strAerendemening like @arendeText
				    OR
				    strAerendemening like @arendeMening
				    )
				    and
				    (
				    strEnhetNamn = @enhetsNamn
				    OR
				    strEnhetKod = @enhetsKod
				    )
       )
   ,vwAehAerende as (select strDiarienummer, recAerendeID, strFnrID, strSoekbegrepp, strFastighetsbeteckning, (IIF(strFnrID is null AND strSoekbegrepp <> strFastighetsbeteckning, case when strFastighetsbeteckning is null then strSoekbegrepp when strSoekbegrepp is null then strFastighetsbeteckning when strSoekbegrepp like concat('%', strFastighetsbeteckning, '%') then strSoekbegrepp else concat(strSoekbegrepp, ' // ', strFastighetsbeteckning)end, strFastighetsbeteckning)) beteckning from filterArendeByParams)
    ,filterHandelserByParams as (select h.*from EDPVisionRegionGotland.dbo.vwAehHaendelse h where year(datHaendelseDatum) = @handelseDatumYear and month(datHaendelseDatum) = @handelseDatumMonth)

   ,filterHandelseByRubrik as (select h.* from filterHandelserByParams h left outer join #OanskadeHandlingar o on o.namn = h.strRubrik where o.namn is null)
   ,GenarateHandelseWithRubrik as (select h.* from filterHandelserByParams h inner join #OnskadeHandlingar o on o.namn = h.strRubrik)

    ,filterHandleseByMakuleradAndEmptyKontakt as (select * from filterHandelserByParams where not(filterHandelserByParams.strText is null AND left(strRubrik,len(N'Kontakt i ärende')) = (N'Kontakt i ärende')) AND not strRubrik like '%Makulerad%' AND filterHandelserByParams.strDiarienummer <> '--- Makulerad ---')

    ,filterArendeByHandelse    as (select vwAehAerende.*from filterArendeBySocken vwAehAerende left outer join filterHandleseByMakuleradAndEmptyKontakt on vwAehAerende.recAerendeID = filterHandelseByRubrik.recAerendeID where filterHandelseByRubrik.recAerendeID is null)

    ,joinArendeByHandelse as (SELECT 		a.strDiarienummer                                                        dianr
					      , a.beteckning                                                kir
					      , coalesce(h.strSignature, a.strUserVisasSom)                             as [Handläggarsignatur]
					      , h.strVisasSom                                                         	as [Huvudkontakt]
					      , coalesce(h.strSoekbegrepp, h.strFastighetsbeteckning)                 	as [Sökbegrepp]
					      , h.strAerendemening                                                    	as [ArendeText]
					      , iif(h.strAerendeStatusPresent is null, '', h.strAerendeStatusPresent) 	as status
					      , coalesce(h.datBeslutsDatum, a.datBeslutsDatum)                          as [Beslutsdatum]
					      , nullif(a.strAerendeKommentar, '')                                       as [Kommentar]
					      , coalesce(a.intLoepnummer, a.intLoepnummerHaendelse, a.intRecnum)      	as [Löpnummer]
					      , datHaendelseDatum                                                     	as dat
					      , recHaendelseKategoriID                                                	as [Händelsekategori]
					      , strRiktning                                                           	as rikt
					      , a.rub
					      , h.[HandelseText]
					 FROM  GenarateHandelseWithRubrik h
					     left outer join filterArendeByHandelse a on a.recAerendeID = h.recAerendeID
)
INSERT INTO #filterArendeWhomHasAnsokan(dianr, kir, Handläggarsignatur, Huvudkontakt, Sökbegrepp, ArendeText, status, Beslutsdatum, Kommentar, Löpnummer, dat, Händelsekategori, rikt, rub, HandelseText, has)
Select



       dianr, kir, Handläggarsignatur, Huvudkontakt, Sökbegrepp, ArendeText, status, Beslutsdatum, Kommentar, Löpnummer, dat, Händelsekategori, rikt, rub, HandelseText, '-' from joinArendeByHandelse



;
--ToAggregate
with

  AnsUtg2                         as (select dianr,Löpnummer,rub,rikt,kir from #filterArendeWhomHasAnsokan)

, groupByDiarharForbud             as (select dianr, max(Löpnummer) hasForb,max(kir) kir
  					from AnsUtg2
					where rub like N'Beslut om förbud%'
					group by dianr)
  , groupByDiarHarAnsökan                      as (select dianr, max(Löpnummer) as hasAns
					from AnsUtg2
					where rub like '%nsökan%' AND rikt = 'inkommande'
					group by dianr )
, groupByHarUtf 				as (
					select dianr, max(Löpnummer) as hasUtf
					from AnsUtg2
					where rub like '%tförandeintyg%' AND rikt = 'inkommande'
					group by dianr
				    ),
whereHarHandelseText 		as (select handelsetext,N'Kontakt i ärende' ka,'Information om' io,rub,dianr,dat from #filterArendeWhomHasAnsokan where HandelseText is not null)

,harForbANsUtf 				as (select x.dianr,kir, hasForb,coalesce(q.hasAns,t.hasUtf,0) qt,(select top 1 HandelseText from
					     whereHarHandelseText
					    where (left(rub, len(ka)) = ka OR left(rub, len(io)) = io)
					    and whereHarHandelseText.dianr = x.dianr
					    order by dat) as senastKontakt from groupByDiarharForbud x
						left outer join groupByDiarHarAnsökan q on x.dianr = q.dianr
						left outer join groupByHarUtf t on x.dianr = t.dianr)

, whereHarAnsokan       as (
					select q.dianr, kir, Handläggarsignatur, Huvudkontakt, Sökbegrepp, ArendeText, status,
					       Beslutsdatum, Kommentar, Löpnummer, dat, Händelsekategori, rikt, rub, HandelseText, groupByDiarHarAnsökan.has
					from groupByDiarHarAnsökan	inner join #filterArendeWhomHasAnsokan q on groupByDiarHarAnsökan.dianr = q.dianr)

, senastKontaktMedHandelsetext    as (select dianr,
					(select top 1 HandelseText from whereHarHandelseText where HandelseText is not null AND (left(rub, len(ka)) = ka OR left(rub, len(io)) = io) and whereHarHandelseText.dianr = Touter.dianr order by dat) as senastKontakt
					from whereHarAnsokan as Touter)

, senasteHandelseIfallIntoKontakt as 	(select * from senastKontaktMedHandelsetext where senastKontakt is null)
, ingenKontaktTextArenden         as 		(select q.dianr, rub, dat from whereHarAnsokan q
    						right join senasteHandelseIfallIntoKontakt t
						on q.dianr = groupByDiarHarAnsökan.dianr)

, senasteHendelseOmInteText       as (select dianr,
				  	(select top 1 rub from ingenKontaktTextArenden as Tinner where whereHarHandelseText.dianr = Touter.dianr order by dat) as senastRub
					from whereHarAnsokan as Touter)

 , whereRiktningUtgaende                          as (select dianr,rub fromdiarienummerMedAnsokan where rikt = N'Utgående')

, GroupByDiarnrharBeslut                       as (select distinct dianr, 'beslut' as hasBes from whereRiktningUtgaende where rub like '%eslut%' group by dianr)


  , GroupByDiarnrSenastInkommande                as (select dianr, max(rub) rub, max(dat) maxDat, status, has
					  from whereHarAnsokan where rikt = 'inkommande'
					group by dianr, status, has)

  , deMedBeslutsHandelser           as (select distinct groupByDiarHarAnsökan.* from whereHarAnsokan t
                                        inner join (select groupByDiarharForbud.dianr from groupByDiarharForbud) q on q.dianr = groupByDiarHarAnsökan.dianr)

  , utanForbud                      as (select groupByDiarHarAnsökan.dianr, kir from whereHarAnsokan t
					left outer join (select groupByDiarharForbud.dianr from groupByDiarharForbud) q
					    on groupByDiarHarAnsökan.dianr = q.dianr where q.dianr is null)
, arendeWhomDoesNotHaveHandling as (
					select filterBySocken.strDiarienummer, filterBySocken.beteckning, strRubrik, handelse.strRubrik hrubrik
					,handelse.strText htext ,strText, datHaendelseDatum
					,IIF(strText is null, datHaendelseDatum, cast(datHaendelseDatum as int) + 1000) datx
					from filterBySocken left outer join EDPVisionRegionGotland.dbo.vwAehHaendelse handelse on filterBySocken.recAerendeID = handelse.recAerendeID
					)

   select * into #ToPressent from arendeWhomDoesNotHaveHandling
;
--Pressentation


   with handelseBydateAndArende as 	(select strDiarienummer
				    , beteckning
				    , (IIF(
				    (strRubrik = 'Klart vatten - information om avlopp' OR strRubrik = 'Klart vatten information om avlopp'),
				    N'först. utskick', hRubrik))	strRubrik
				    , (replace(hText, '\n', ''))        HandelseText
				    , row_number() over (partition by strDiarienummer order by datx desc) senaste
				    from #ToPressent)

,treKolumnerOfhandelser  	as (select strDiarienummer,strRubrik,strAerendemening from handelserOfInterest)
,tvaKolumnerOfHandelser   	as (select strDiarienummer,strRubrik from treKolumnerOfhandelser)
,latest1Handelse 	  	as (select tvaKolumnerOfHandelser.strDiarienummer, z.strRubrik ansökan
					from tvaKolumnerOfHandelser cross apply (select top 1 * from AnOmHandelser where strDiarienummer = tvaKolumnerOfHandelser.strDiarienummer order by year(datHaendelseDatum), month(datHaendelseDatum),day(datHaendelseDatum)) z where tvaKolumnerOfHandelser.strDiarienummer = z.strDiarienummer)
select
       IIF(treKolumnerOfhandelser.strAerendemening = 'Klart vatten - information om avlopp' OR latest1Handelse.ansökan like N'%örbättring%', N'förbättring', 'ny') typ, treKolumnerOfhandelser.strDiarienummer,
       replace(strRubrik,N'Beslut om enskild avloppsanläggning','Beslut') 						typAvBeslut,
       replace(replace(strAerendemening,'Klart vatten - information om avlopp','KV'),N'Ansökan/anmälan om enskild avloppsanläggning',N'ansökan') strAerendemening,
       replace(latest1Handelse.ansökan ,N'Ansökan/anmälan om enskild avloppsanläggning',N'ansökan')  			ansökan
from treKolumnerOfhandelser left outer join latest1Handelse
    on latest1Handelse.strDiarienummer = treKolumnerOfhandelser.strDiarienummer
order by typ

select *from  handelseBydateAndArende where senaste = 1 order by strDiarienummer, senaste


--   , gis as (select fnr,beteckning from [GISDATA].[sde_geofir_gotland].gng.FA_FASTIGHET)
--select dianr, kir, senastKontakt from harForbANsUtf where hasForb > qt
--select distinct dianr, kir, gis.fnr from utanForbud left outer join gis on kir = gis.BETECKNING

--where senastKontaktMedHandelsetext.senastKontakt is not null
-- order by dianr

select datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseKategoriID, recLastHaendelseStatusLogID, recHaendelseID, intRecnum, recDiarieAarsSerieID, intLoepnummer, intAntalFiler, recRemissutskickID, recFoervaltningID, strPublicering, recEnhetID, recAvdelningID, bolKaensligaPersonuppgifter, strEnhetNamn, strEnhetKod, strAvdelningNamn, strAvdelningKod, strFoervaltningKod, strHaendelseIdentifiering, strOrgannamn, strBeslutsNummer, datBeslutsDatum, recOrganID, recHaendelseBeslutID, strBeslutsutfall, recDelegationskodID, strDelegationskod, strDelegationsNamn, strHaendelseKategori, strHaendelseKategoriKod, bolEjAktuell, bolBeslut, strHaendelseKategoriKommentar, strFastighetsbeteckning, strFnrID, recFastighetID, intLoepnummerHaendelse, recAerendeID, bolMainHuvudBeslut, strSekretess, strBegraensa, strSekretessMyndighet, datSekretessDatum, recEnstakaKontaktID, strGatuadress, strPostnummer, strPostort, strVisasSom, strRoll, recKontaktRollID, recHaendelseEnstakaKontaktID, strSignature, intUserID, strHandlaeggarNamn, datDatum, strLogKommentar, strHaendelseStatusPresent, strHaendelseStatusLogTyp, strHaendelseStatusLocalizationCode, strDiarienummer, strAerendeTyp, recAerendetypID, strAerendeFastighet, strAerendeStatusPresent, strAerendeLocalizationCode, strSoekbegrepp, recDiarieSerieID, strDiarieserieAerende, intDiarieAar, intDiarienummerLoepNummer, intSerieStartVaerde, recDiarieSeriePostlista, strDiarieseriePostlista, intDiarieAarPostlista, strTillhoerPostlista, strAerendemening, strAerendetypKod, recKommunID, strKommunNamn, strFoervaltningNamn, intArbetsdagar, strSummaTidposter, strPoITkategori, recDelprocessID, strDelprocesskod, strDelprocess, datGallrad, datArkiverad
from EDPVisionRegionGotland.dbo.vwAehHaendelse where datHaendelseDatum > datetimefromparts(2019,01,01,01,01,01,01)