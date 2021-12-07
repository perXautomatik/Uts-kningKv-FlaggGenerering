:r FilterByHendelse/(header)TableType.sql
:r FilterByHendelse/CreateFnrToAdress.sql
:r FilterByHendelse/InsertIntoHandelser.sql


select [FAL_UTADR2],
       FAL_POSTORT,
       q,
       case when isnull([FAL_UTADR2], '') = '' then 0 else 1 end,
       case when isnull(FAL_POSTORT, '') = '' then 0 else 1 end,
       isNull(nullif(1, isnull(nullif(case when isnull([FAL_UTADR2], '') = '' then 0 else 1 end, q), 1)), 2) faUT,
       isNull(nullif(1, isnull(nullif(case when isnull([FAL_UTADR2], '') = '' then 0 else 1 end, q), 1)), 2) faPo
FROM (
         select try_cast(isNull(nullif(1,
                                       isnull(case
                                                  when
                                                          isnull(SAL_UTADR1, '') =
                                                          isnull(SAL_POSTNR, '')
                                                      then null
                                                  else 1 end)
                                    ), 3) as int)                       y,
                case when isnull(FAL_POSTNR, '') = '' then 0 else 1 end q
                 ,
                *
         from ( --ifall att ägarbyte skett och gammla ägande inte updaterats, välj den minsta ägande

                  select diarienummer,
                         input.fnr,
                         UA_UTADR2,
                         UA_UTADR1,
                         UA_LAND,
                         SAL_POSTORT,
                         SAL_POSTNR,
                         fir.NAMN,
                         KORTNAMN,
                         FAL_UTADR2,
                         FAL_POSTORT,
                         FAL_POSTNR,
                         min(ANDEL) 'andel',
                         SAL_UTADR1,
                         PERSORGNR
                  from GISDATA.sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 fir
                           inner join @inputFnr input
                                      on fir.FNR = input.fnr
                  where input.harNamn = 0
                  group by Diarienummer, input.FNR, UA_UTADR2, UA_UTADR1, UA_LAND, SAL_POSTORT, SAL_POSTNR, fir.NAMN,
                           KORTNAMN, FAL_UTADR2, FAL_POSTORT, FAL_POSTNR, SAL_UTADR1, PERSORGNR
              ) asdaga
     ) inputPlusFir ) combinedTidy) asdg
union
select *
from (select Händelsedatum,
             Namn,
             Gatuadress,
             POSTNUMMER,
             postOrt,
             personnr,
             diarienummer,
             Fnr
      from @inputFnr x
      where x.harNamn = 1) xyz
Go





:r FilterByHendelse/InsertIntoTable3.sql

:r FilterByHendelse/InsertIntoTable4.sql

