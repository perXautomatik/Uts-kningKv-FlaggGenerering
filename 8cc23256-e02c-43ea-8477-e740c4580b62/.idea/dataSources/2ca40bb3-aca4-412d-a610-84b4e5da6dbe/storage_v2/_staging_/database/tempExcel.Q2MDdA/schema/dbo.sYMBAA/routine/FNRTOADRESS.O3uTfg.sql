--CAST(CASE WHEN isnull([ANDEL],'') = '' THEN '1/1' ELSE [ANDEL] END AS varchar) as Händelsedatum,
CREATE FUNCTION dbo.FnrToAdress(@inputFnr KontaktUpgTableType READONLY) RETURNS 
   table as
   return
   select * from ( select Diarienummer, Fnr, fastighet, Händelsedatum, Namn, Postnummer, Postort, Gatuadress, personnr from (
    select Diarienummer, fnr, fastighet,
        getdate()   Händelsedatum, CAST(CASE WHEN [NAMN] is null OR [NAMN] = '' THEN KORTNAMN ELSE [NAMN] END AS varchar) as      Namn,
        try_CAST(CASE salutfalup when 6*35 THEN UA_UTADR2 when 6 then SAL_POSTNR ELSE [FAL_POSTNR] END AS int) as      POSTNUMMER,
        CAST(CASE salUtfalposalPost WHEN 6*35 THEN UA_LAND when 6 then SAL_POSTORT ELSE [FAL_POSTORT] END AS varchar) as      postOrt,
        CAST(CASE salutfalup when 6*35 THEN UA_UTADR1 when 6 then SAL_UTADR1 ELSE [FAL_UTADR2] END AS varchar) as      Gatuadress,
        [PERSORGNR] personnr
            FROM (
            SELECT fastighet,
            (case when isnull([FAL_POSTORT],'') = '' then 2 else 1 end)*(case when isnull(SAL_POSTNR,'') = '' then 3 else 1 end) *salutaSalpos salUtfalposalPost,
            (case when isnull([FAL_UTADR2],'') = '' then 2 else 1 end)*(case when isnull([FAL_POSTNR],'') = '' then 3 else 1 end)*salutaSalpos salutfalup,
                diarienummer,fnr, [UA_UTADR2], [UA_UTADR1], [UA_LAND], [SAL_POSTORT], [SAL_POSTNR], [NAMN], [KORTNAMN], [FAL_UTADR2], [FAL_POSTORT], [FAL_POSTNR], [SAL_UTADR1], [PERSORGNR]
            FROM (
                     select input.fastighet,
                            (case when isnull(SAL_UTADR1, '') = '' then 5 else 1 end) *
                            (case when isnull(SAL_POSTNR, '') = '' then 7 else 1 end) salutaSalpos,
                            diarienummer,
                            input.fnr,
                            [UA_UTADR2],
                            [UA_UTADR1],
                            [UA_LAND],
                            [SAL_POSTORT],
                            [SAL_POSTNR],
                            fir.[NAMN],
                            [KORTNAMN],
                            [FAL_UTADR2],
                            [FAL_POSTORT],
                            [FAL_POSTNR],
                            [SAL_UTADR1],
                            [PERSORGNR]
                     from GISDATA.sde_geofir_gotland.gng.FA_lagfart_V2 fir
                              inner join @inputFnr input on fir.FNR = input.fnr
                     where input.harNamn = 0) asdaga) inputPlusFir
    ) pt1
    union
	select Diarienummer, fnr,fastighet, Händelsedatum, Namn, POSTNUMMER, postOrt, Gatuadress, personnr
    from ( select Diarienummer, fnr,fastighet, Händelsedatum, Namn, POSTNUMMER, postOrt, Gatuadress, personnr, harNamn from @inputFnr x where x.harNamn = 1
    ) pt2) sad
go

