Use [admsql04].EDPVisionRegionGotland;

IF OBJECT_ID('tempdb..#filterArendeWhomHasAnsokan') IS NOT NULL DROP TABLE #filterArendeWhomHasAnsokan
create table dbo.#filterArendeWhomHasAnsokan
(
    dianr              nvarchar(max),
    kir                nvarchar(max),
    Handläggarsignatur nvarchar(max),
    Huvudkontakt       nvarchar(max),
    Sökbegrepp         nvarchar(max),
    ArendeText         nvarchar(max),
    status             nvarchar(max),
    Beslutsdatum       nvarchar(max),
    Kommentar          nvarchar(max),
    Löpnummer          int,
    dat                datetime2,
    Händelsekategori   nvarchar(max),
    rikt               nvarchar(max),
    rub                nvarchar(max),
    HandelseText       nvarchar(max),
    has                nvarchar(max)
);
--insert into #filterArendeWhomHasAnsokan
with
   utanOnödigaHandlingar as (select * from (
		    select datHaendelseDatum, strRubrik rub, strText HandelseText, strRiktning, strKommunikationssaett, recHaendelseKategoriID, recLastHaendelseStatusLogID, recHaendelseID, intRecnum, recDiarieAarsSerieID, intLoepnummer, intAntalFiler, recRemissutskickID, recFoervaltningID, strPublicering, recEnhetID, recAvdelningID, bolKaensligaPersonuppgifter, strEnhetNamn, strEnhetKod, strAvdelningNamn, strAvdelningKod, strFoervaltningKod, strHaendelseIdentifiering, strOrgannamn, strBeslutsNummer, datBeslutsDatum, recOrganID, recHaendelseBeslutID, strBeslutsutfall, recDelegationskodID, strDelegationskod, strDelegationsNamn, strHaendelseKategori, strHaendelseKategoriKod, bolEjAktuell, bolBeslut, strHaendelseKategoriKommentar, strFastighetsbeteckning, strFnrID, recFastighetID, intLoepnummerHaendelse, recAerendeID, bolMainHuvudBeslut, strSekretess, strBegraensa, strSekretessMyndighet, datSekretessDatum, recEnstakaKontaktID, strGatuadress, strPostnummer, strPostort, strVisasSom, strRoll, recKontaktRollID, recHaendelseEnstakaKontaktID, strSignature, intUserID, strHandlaeggarNamn, datDatum, strLogKommentar, strHaendelseStatusPresent, strHaendelseStatusLogTyp, strHaendelseStatusLocalizationCode,
			   strDiarienummer dianr, strAerendeTyp, recAerendetypID, strAerendeFastighet, strAerendeStatusPresent, strAerendeLocalizationCode, strSoekbegrepp, recDiarieSerieID, strDiarieserieAerende, intDiarieAar, intDiarienummerLoepNummer, intSerieStartVaerde, recDiarieSeriePostlista, strDiarieseriePostlista, intDiarieAarPostlista, strTillhoerPostlista, strAerendemening, strAerendetypKod, recKommunID, strKommunNamn, strFoervaltningNamn, intArbetsdagar, strSummaTidposter, strPoITkategori, recDelprocessID, strDelprocesskod, strDelprocess, datGallrad, datArkiverad
		 from dbo.vwAehHaendelse) z
			where not (rub in ('Mottagningskvitto', N'Uppföljning 2 år från klart vatten utskick'))
			      And left(rub,len(N'Bekräftelse')) <> (N'Bekräftelse') And left(rub,len('Besiktning')) <> ('Besiktning')
			      And left(rub,len('Klart Vatten')) <> ('Klart Vatten') And
			      left(rub,len(N'Påminnelse om åtgärd')) <> (N'Påminnelse om åtgärd') AND
			      not(HandelseText is null AND left(rub,len(N'Kontakt i ärende')) = (N'Kontakt i ärende')) AND
			      not rub like '%Makulerad%' AND dianr <> '--- Makulerad ---'
       ),

    arendenNHandlingar as (select * from (SELECT q.strDiarienummer                                                        dianr
		    , q.strFastighetsbeteckning                                                kir
		    , coalesce(q.strSignature, strUserVisasSom)                             as [Handläggarsignatur]
		    , q.strVisasSom                                                         as [Huvudkontakt]
		    , coalesce(q.strSoekbegrepp, q.strFastighetsbeteckning)                 as [Sökbegrepp]
		    , q.strAerendemening                                                    as [ArendeText]
		    , iif(q.strAerendeStatusPresent is null, '', q.strAerendeStatusPresent) as status
		    , coalesce(q.datBeslutsDatum, t.datBeslutsDatum)                           [Beslutsdatum]
		    , nullif(strAerendeKommentar, '')                                       as [Kommentar]
		    , coalesce(t.intLoepnummer, t.intLoepnummerHaendelse, t.intRecnum)      as [Löpnummer]
		    , datHaendelseDatum                                                     as dat
		    , recHaendelseKategoriID                                                as [Händelsekategori]
		    , strRiktning                                                           as rikt
		    , rub
		    , [HandelseText]
	       FROM dbo.vwAehAerende q
		   left outer join utanOnödigaHandlingar t on t.recAerendeID = q.recAerendeID
    ) p
     where status != 'Avslutat' AND status !='Makulerat'
	and ArendeText like '%atten%'
         )
   INSERT INTO #filterArendeWhomHasAnsokan(dianr, kir, Handläggarsignatur, Huvudkontakt, Sökbegrepp, ArendeText, status, Beslutsdatum, Kommentar, Löpnummer, dat, Händelsekategori, rikt, rub, HandelseText, has)
   Select dianr, kir, Handläggarsignatur, Huvudkontakt, Sökbegrepp, ArendeText, status, Beslutsdatum, Kommentar, Löpnummer, dat, Händelsekategori, rikt, rub, HandelseText, '-' from arendenNHandlingar

;

with
    AnsUtg2                         as (select dianr,Löpnummer,rub,rikt,kir from #filterArendeWhomHasAnsokan)

  , harForbud                       as (select dianr, max(Löpnummer) hasForb,max(kir) kir
  					from AnsUtg2
					where rub like N'Beslut om förbud%'
					group by dianr)
  , harAnsökan                      as (select dianr, max(Löpnummer) as hasAns
					from AnsUtg2
					where rub like '%nsökan%' AND rikt = 'inkommande'
					group by dianr )
, harUtf 				as (
					select dianr, max(Löpnummer) as hasUtf
					from AnsUtg2
					where rub like '%tförandeintyg%' AND rikt = 'inkommande'
					group by dianr
				    ),
harHandelseText as (select handelsetext,N'Kontakt i ärende' ka,'Information om' io,rub,dianr,dat from #filterArendeWhomHasAnsokan where HandelseText is not null)

,harForbANsUtf as (select x.dianr,kir, hasForb,coalesce(q.hasAns,t.hasUtf,0) qt,(select top 1 HandelseText from
	 harHandelseText
	where (left(rub, len(ka)) = ka OR left(rub, len(io)) = io)
	and harHandelseText.dianr = x.dianr
	order by dat) as senastKontakt from harForbud x
	    left outer join harAnsökan q on x.dianr = q.dianr
	    left outer join harUtf t on x.dianr = t.dianr)
--select dianr, kir, senastKontakt from harForbANsUtf where hasForb > qt

	, OnlyDiarenummerMedAnsökan       as (
				select q.dianr, kir, Handläggarsignatur, Huvudkontakt, Sökbegrepp, ArendeText, status,
				       Beslutsdatum, Kommentar, Löpnummer, dat, Händelsekategori, rikt, rub, HandelseText, harAnsökan.has
				from harAnsökan	inner join #filterArendeWhomHasAnsokan q on harAnsökan.dianr = q.dianr)

  , senastKontaktMedHandelsetext    as (select dianr,
	(select top 1 HandelseText from harHandelseText where HandelseText is not null AND (left(rub, len(ka)) = ka OR left(rub, len(io)) = io) and harHandelseText.dianr = Touter.dianr order by dat) as senastKontakt
					from OnlyDiarenummerMedAnsökan as Touter)

  , senasteHandelseIfallIntoKontakt as 	(select * from senastKontaktMedHandelsetext where senastKontakt is null)
  , ingenKontaktTextArenden         as 		(select q.dianr, rub, dat from OnlyDiarenummerMedAnsökan q
    						right join senasteHandelseIfallIntoKontakt t
						on q.dianr = harAnsökan.dianr)

  , senasteHendelseOmInteText       as (select dianr,
				  	(select top 1 rub from ingenKontaktTextArenden as Tinner where harHandelseText.dianr = Touter.dianr order by dat) as senastRub
					from OnlyDiarenummerMedAnsökan as Touter)

  , AnsUtg                          as (select dianr,rub fromdiarienummerMedAnsokan where rikt = N'Utgående')
  , harBeslut                       as (select distinct dianr, 'beslut' as hasBes from AnsUtg where rub like '%eslut%' group by dianr)


  , SenastInkommande                as (select dianr, max(rub) rub, max(dat) maxDat, status, has
                          from OnlyDiarenummerMedAnsökan where rikt = 'inkommande'
   			group by dianr, status, has)

  , deMedBeslutsHandelser           as (select distinct harAnsökan.* from OnlyDiarenummerMedAnsökan t
                                        inner join (select harforbud.dianr from harforbud) q on q.dianr = harAnsökan.dianr)

  , utanForbud                      as (select harAnsökan.dianr, kir from OnlyDiarenummerMedAnsökan t
                    left outer join (select harforbud.dianr from harforbud) q
                        on harAnsökan.dianr = q.dianr where q.dianr is null)

--   , gis as (select fnr,beteckning from [GISDATA].[sde_geofir_gotland].gng.FA_FASTIGHET)

--select distinct dianr, kir, gis.fnr from utanForbud left outer join gis on kir = gis.BETECKNING


--where senastKontaktMedHandelsetext.senastKontakt is not null
-- order by dianr

