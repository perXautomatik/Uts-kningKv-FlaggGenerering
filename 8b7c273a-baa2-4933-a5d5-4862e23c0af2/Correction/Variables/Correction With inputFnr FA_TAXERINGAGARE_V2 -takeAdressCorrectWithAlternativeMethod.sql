:r FilterByHendelse/(header)TableType.sql
:r FilterByHendelse/CreateFnrToAdress.sql
:r FilterByHendelse/InsertIntoHandelser.sql
 --ifall att ägarbyte skett och gammla ägande inte updaterats, välj den minsta ägande

with
    inputX as  (select Händelsedatum, Namn, Gatuadress, POSTNUMMER, postOrt, personnr, diarienummer, Fnr
    			from @inputFnr)
    ,inputFnrHasName 	 as (select * from inputx x where x.harNamn = 1) -- don't need correction
    ,inputFnrDontHasName as (select * from inputx x where x.harNamn = 0) -- need correction
	--applying alternative gismethod
   ,TaxeringarInputFnr 	 as (select * from GISDATA.sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 fir
       inner join
       inputFnrDontHasName q on fir.FNR = q.fnr)
   ,mergeByAndel	 as ( select diarienummer, input.fnr, UA_UTADR2, UA_UTADR1, UA_LAND, SAL_POSTORT, SAL_POSTNR, fir.NAMN, KORTNAMN, FAL_UTADR2, FAL_POSTORT, FAL_POSTNR,
				min(ANDEL) 'andel', SAL_UTADR1, PERSORGNR
	        		from TaxeringarInputFnr group by Diarienummer, input.FNR, UA_UTADR2, UA_UTADR1, UA_LAND, SAL_POSTORT, SAL_POSTNR, fir.NAMN, KORTNAMN, FAL_UTADR2, FAL_POSTORT, FAL_POSTNR, SAL_UTADR1, PERSORGNR
              		    )
    ,AdressCatagorization as (select
    				(IIF(isnull(FAL_POSTNR, '') = '', 0, 1)) as bolFal_postnrEmpty
    				,[FAL_UTADR2], FAL_POSTORT,
    				try_cast(isNull(nullif(1, isnull(
					IIF(isnull(SAL_UTADR1, '') = isnull(SAL_POSTNR, ''), null, 1))), 3) as int)
									 as intAdressType from mergeByAndel)

    ,correctedFormated as (select [FAL_UTADR2], FAL_POSTORT, bolFal_postnrEmpty
				, IIF(isnull([FAL_UTADR2], '') = '', 0, 1) as                                                 asd
				, IIF(isnull(FAL_POSTORT, '') = '', 0, 1)  as                                                 gaf
				,
       isNull(nullif(1, isnull(nullif(IIF(isnull([FAL_UTADR2], '') = '', 0, 1), bolFal_postnrEmpty), 1)), 2)                  faUT,
       isNull(nullif(1, isnull(nullif(IIF(isnull([FAL_UTADR2], '') = '', 0, 1), bolFal_postnrEmpty), 1)), 2) faPo
    	from AdressCatagorization)

      --inputPlusFir ) combinedTidy)
select * FROM  correctedFormated
union
select * from  inputFnrHasName  -- don't need correction
Go





:r FilterByHendelse/InsertIntoTable3.sql

:r FilterByHendelse/InsertIntoTable4.sql

