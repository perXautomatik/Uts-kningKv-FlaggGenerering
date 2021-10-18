Use [admsql04].EDPVisionRegionGotland;

IF OBJECT_ID('tempdb..#filterArendeWhomHasAnsokan') IS NOT NULL DROP TABLE #filterArendeWhomHasAnsokan
create table dbo.#filterArendeWhomHasAnsokan
(
    dianr              nvarchar(max),
    kir                nvarchar(max),
    Handl�ggarsignatur nvarchar(max),
    Huvudkontakt       nvarchar(max),
    S�kbegrepp         nvarchar(max),
    ArendeText         nvarchar(max),
    status             nvarchar(max),
    Beslutsdatum       nvarchar(max),
    Kommentar          nvarchar(max),
    L�pnummer          int,
    dat                datetime2,
    H�ndelsekategori   nvarchar(max),
    rikt               nvarchar(max),
    rub                nvarchar(max),
    HandelseText       nvarchar(max),
    has                nvarchar(max)
);
--insert into #filterArendeWhomHasAnsokan
with
   utanOn�digaHandlingar as (select * from (
		    select datHaendelseDatum, strRubrik rub, strText HandelseText, strRiktning, strKommunikationssaett, recHaendelseKategoriID, recLastHaendelseStatusLogID, recHaendelseID, intRecnum, recDiarieAarsSerieID, intLoepnummer, intAntalFiler, recRemissutskickID, recFoervaltningID, strPublicering, recEnhetID, recAvdelningID, bolKaensligaPersonuppgifter, strEnhetNamn, strEnhetKod, strAvdelningNamn, strAvdelningKod, strFoervaltningKod, strHaendelseIdentifiering, strOrgannamn, strBeslutsNummer, datBeslutsDatum, recOrganID, recHaendelseBeslutID, strBeslutsutfall, recDelegationskodID, strDelegationskod, strDelegationsNamn, strHaendelseKategori, strHaendelseKategoriKod, bolEjAktuell, bolBeslut, strHaendelseKategoriKommentar, strFastighetsbeteckning, strFnrID, recFastighetID, intLoepnummerHaendelse, recAerendeID, bolMainHuvudBeslut, strSekretess, strBegraensa, strSekretessMyndighet, datSekretessDatum, recEnstakaKontaktID, strGatuadress, strPostnummer, strPostort, strVisasSom, strRoll, recKontaktRollID, recHaendelseEnstakaKontaktID, strSignature, intUserID, strHandlaeggarNamn, datDatum, strLogKommentar, strHaendelseStatusPresent, strHaendelseStatusLogTyp, strHaendelseStatusLocalizationCode,
			   strDiarienummer dianr, strAerendeTyp, recAerendetypID, strAerendeFastighet, strAerendeStatusPresent, strAerendeLocalizationCode, strSoekbegrepp, recDiarieSerieID, strDiarieserieAerende, intDiarieAar, intDiarienummerLoepNummer, intSerieStartVaerde, recDiarieSeriePostlista, strDiarieseriePostlista, intDiarieAarPostlista, strTillhoerPostlista, strAerendemening, strAerendetypKod, recKommunID, strKommunNamn, strFoervaltningNamn, intArbetsdagar, strSummaTidposter, strPoITkategori, recDelprocessID, strDelprocesskod, strDelprocess, datGallrad, datArkiverad
		 from dbo.vwAehHaendelse) z
			where not (rub in ('Mottagningskvitto', N'Uppf�ljning 2 �r fr�n klart vatten utskick'))
			      And left(rub,len(N'Bekr�ftelse')) <> (N'Bekr�ftelse') And left(rub,len('Besiktning')) <> ('Besiktning')
			      And left(rub,len('Klart Vatten')) <> ('Klart Vatten') And
			      left(rub,len(N'P�minnelse om �tg�rd')) <> (N'P�minnelse om �tg�rd') AND
			      not(HandelseText is null AND left(rub,len(N'Kontakt i �rende')) = (N'Kontakt i �rende')) AND
			      not rub like '%Makulerad%' AND dianr <> '--- Makulerad ---'
       ),

    arendenNHandlingar as (select * from (SELECT q.strDiarienummer                                                        dianr
		    , q.strFastighetsbeteckning                                                kir
		    , coalesce(q.strSignature, strUserVisasSom)                             as [Handl�ggarsignatur]
		    , q.strVisasSom                                                         as [Huvudkontakt]
		    , coalesce(q.strSoekbegrepp, q.strFastighetsbeteckning)                 as [S�kbegrepp]
		    , q.strAerendemening                                                    as [ArendeText]
		    , iif(q.strAerendeStatusPresent is null, '', q.strAerendeStatusPresent) as status
		    , coalesce(q.datBeslutsDatum, t.datBeslutsDatum)                           [Beslutsdatum]
		    , nullif(strAerendeKommentar, '')                                       as [Kommentar]
		    , coalesce(t.intLoepnummer, t.intLoepnummerHaendelse, t.intRecnum)      as [L�pnummer]
		    , datHaendelseDatum                                                     as dat
		    , recHaendelseKategoriID                                                as [H�ndelsekategori]
		    , strRiktning                                                           as rikt
		    , rub
		    , [HandelseText]
	       FROM dbo.vwAehAerende q
		   left outer join utanOn�digaHandlingar t on t.recAerendeID = q.recAerendeID
    ) p
     where status != 'Avslutat' AND status !='Makulerat'
	and ArendeText like '%atten%'
         )
   INSERT INTO #filterArendeWhomHasAnsokan(dianr, kir, Handl�ggarsignatur, Huvudkontakt, S�kbegrepp, ArendeText, status, Beslutsdatum, Kommentar, L�pnummer, dat, H�ndelsekategori, rikt, rub, HandelseText, has)
   Select dianr, kir, Handl�ggarsignatur, Huvudkontakt, S�kbegrepp, ArendeText, status, Beslutsdatum, Kommentar, L�pnummer, dat, H�ndelsekategori, rikt, rub, HandelseText, '-' from arendenNHandlingar

;

with
    AnsUtg2                         as (select dianr,L�pnummer,rub,rikt,kir from #filterArendeWhomHasAnsokan)

  , harForbud                       as (select dianr, max(L�pnummer) hasForb,max(kir) kir
  					from AnsUtg2
					where rub like N'Beslut om f�rbud%'
					group by dianr)
  , harAns�kan                      as (select dianr, max(L�pnummer) as hasAns
					from AnsUtg2
					where rub like '%ns�kan%' AND rikt = 'inkommande'
					group by dianr )
, harUtf 				as (
					select dianr, max(L�pnummer) as hasUtf
					from AnsUtg2
					where rub like '%tf�randeintyg%' AND rikt = 'inkommande'
					group by dianr
				    ),
harHandelseText as (select handelsetext,N'Kontakt i �rende' ka,'Information om' io,rub,dianr,dat from #filterArendeWhomHasAnsokan where HandelseText is not null)

,harForbANsUtf as (select x.dianr,kir, hasForb,coalesce(q.hasAns,t.hasUtf,0) qt,(select top 1 HandelseText from
	 harHandelseText
	where (left(rub, len(ka)) = ka OR left(rub, len(io)) = io)
	and harHandelseText.dianr = x.dianr
	order by dat) as senastKontakt from harForbud x
	    left outer join harAns�kan q on x.dianr = q.dianr
	    left outer join harUtf t on x.dianr = t.dianr)
--select dianr, kir, senastKontakt from harForbANsUtf where hasForb > qt

	, OnlyDiarenummerMedAns�kan       as (
				select q.dianr, kir, Handl�ggarsignatur, Huvudkontakt, S�kbegrepp, ArendeText, status,
				       Beslutsdatum, Kommentar, L�pnummer, dat, H�ndelsekategori, rikt, rub, HandelseText, harAns�kan.has
				from harAns�kan	inner join #filterArendeWhomHasAnsokan q on harAns�kan.dianr = q.dianr)

  , senastKontaktMedHandelsetext    as (select dianr,
	(select top 1 HandelseText from harHandelseText where HandelseText is not null AND (left(rub, len(ka)) = ka OR left(rub, len(io)) = io) and harHandelseText.dianr = Touter.dianr order by dat) as senastKontakt
					from OnlyDiarenummerMedAns�kan as Touter)

  , senasteHandelseIfallIntoKontakt as 	(select * from senastKontaktMedHandelsetext where senastKontakt is null)
  , ingenKontaktTextArenden         as 		(select q.dianr, rub, dat from OnlyDiarenummerMedAns�kan q
    						right join senasteHandelseIfallIntoKontakt t
						on q.dianr = harAns�kan.dianr)

  , senasteHendelseOmInteText       as (select dianr,
				  	(select top 1 rub from ingenKontaktTextArenden as Tinner where harHandelseText.dianr = Touter.dianr order by dat) as senastRub
					from OnlyDiarenummerMedAns�kan as Touter)

  , AnsUtg                          as (select dianr,rub fromdiarienummerMedAnsokan where rikt = N'Utg�ende')
  , harBeslut                       as (select distinct dianr, 'beslut' as hasBes from AnsUtg where rub like '%eslut%' group by dianr)


  , SenastInkommande                as (select dianr, max(rub) rub, max(dat) maxDat, status, has
                          from OnlyDiarenummerMedAns�kan where rikt = 'inkommande'
   			group by dianr, status, has)

  , deMedBeslutsHandelser           as (select distinct harAns�kan.* from OnlyDiarenummerMedAns�kan t
                                        inner join (select harforbud.dianr from harforbud) q on q.dianr = harAns�kan.dianr)

  , utanForbud                      as (select harAns�kan.dianr, kir from OnlyDiarenummerMedAns�kan t
                    left outer join (select harforbud.dianr from harforbud) q
                        on harAns�kan.dianr = q.dianr where q.dianr is null)

--   , gis as (select fnr,beteckning from [GISDATA].[sde_geofir_gotland].gng.FA_FASTIGHET)

--select distinct dianr, kir, gis.fnr from utanForbud left outer join gis on kir = gis.BETECKNING


--where senastKontaktMedHandelsetext.senastKontakt is not null
-- order by dianr

