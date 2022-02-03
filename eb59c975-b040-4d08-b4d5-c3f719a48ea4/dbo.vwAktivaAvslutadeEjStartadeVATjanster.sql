WITH
    SOCKNAROFINTRESSE AS (select N'Källunge' socken union select N'Vallstena' as alias
			  union select N'Hörsne' as alias2345
			  union select 'Bara' as alias2
			  union select 'Norrlanda' as alias23
			  union select 'Stenkyrka' as alias234)

   , filterOnSocken as (
    select strAnlnr from EDPFutureGotland.dbo.vwAnlaggning inner join SOCKNAROFINTRESSE on nullif(strFastbeteckningTrakt,'') LIKE SOCKNAROFINTRESSE.SOCKEN + '%')
    ,tjanst as (select intTjanstnr,strAnlnr from EDPFutureGotland.dbo.vwTjanst)
    ,tjanstIsocken as ( select intTjanstnr from
        tjanst inner join filterOnSocken on tjanst.strAnlnr = filterOnSocken.strAnlnr
)
  ,DelProdukterNotInterestedIN as (
      select N'DEPO' badDelprodukt union
      select N'CONT'union select  N'GRUNDR'union
      select  N'ÖVRTRA'union
      select  N'ÖVRTRA' union
      select  'HUSH'union
      select  N'ÅVCTR')


  ,TaxekodNotOfinterest as (select 'BUDSM' badTaxekod union select 'HYRA%')
   ,toAggregate as (
       select z.* from EDPFutureGotland.dbo.vwRenhTjanstStatistik z
        inner join tjanstIsocken on tjanstIsocken.intTjanstnr = z.intTjanstnr
       left outer join TaxekodNotOfinterest on z.strTaxekod like TaxekodNotOfinterest.badTaxekod
       left outer join DelProdukterNotInterestedIN on z.strDelprodukt = DelProdukterNotInterestedIN.badDelprodukt
    where
       badDelprodukt is null and badTaxekod is null )


,anlaggning as (select filterOnSocken.strAnlnr,strAnlaggningsKategori,strFastBeteckningHel strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat from EDPFutureGotland.dbo.vwAnlaggning
    inner join filterOnSocken on filterOnSocken.strAnlnr = 	EDPFutureGotland.dbo.vwAnlaggning.strAnlnr )

select q.*,anlaggning.strFastBeteckningHel from (select strTaxekod, strTaxebenamning, strDelprodukt, max(datStoppdatum) mst, strKundkategori,intTjanstnr
from toAggregate group by strTaxekod, strTaxebenamning, strDelprodukt, strKundkategori,intTjanstnr) q
       	left outer join tjanst
	on tjanst.intTjanstnr = q.intTjanstnr
	left outer join anlaggning
	on anlaggning.strAnlnr = tjanst.strAnlnr





  ,fastighetspunkterSlam as ( select nullif(strFastBeteckningHel,'') strFastBeteckningHelX,
				  nullif(decAnlXKoordinat,0) decAnlXKoordinat,
				  nullif(decAnlYkoordinat,0) decAnlYkoordinat
			      from anlaggning )

,TjansteNrAndTjanst as (
    select intTjanstnr,concat(strTaxekod_strDelprodukt,nullif(concat(' Avbrutet:',FORMAT (datStoppdatum, 'yyyy-MM-dd')),' Avbrutet:')) datStoppdatum from
    (select intTjanstnr,
       strAnlOrt,nullif(max(isnull(datStoppdatum, smalldatetimefromparts(1900, 01, 01, 00, 00))),smalldatetimefromparts(1900, 01, 01, 00, 00)) datStoppdatum,
       concat( strDelprodukt,'|',strTaxebenamning)              strTaxekod_strDelprodukt
    from ToAggregate
    group by intTjanstnr, strAnlOrt, strTaxekod, strDelprodukt, strTaxebenamning) q)

select TjansteNrAndTjanst.datStoppdatum slamAnteckning,anlaggning.strFastBeteckningHel,fastighetspunkterSlam.decAnlXKoordinat,fastighetspunkterSlam.decAnlYkoordinat from
    TjansteNrAndTjanst
	left outer join tjanst
	on tjanst.intTjanstnr = TjansteNrAndTjanst.intTjanstnr
	left outer join anlaggning
	on anlaggning.strAnlnr = tjanst.strAnlnr
	right outer join fastighetspunkterSlam
	ON strFastBeteckningHel = fastighetspunkterSlam.strFastBeteckningHelX
--   group by datStoppdatum, strFastBeteckningHel, fastighetspunkterSlam.decAnlXKoordinat, fastighetspunkterSlam.decAnlYkoordinat
;
declare @sockenStrang varchar(max) =N'Källunge,Vallstena,Hörsne,Bara,Norrlanda,Stenkyrka'; --STRING_SPLIT(N'Källunge,Vallstena,Hörsne,Bara,Norrlanda,Stenkyrka', ','))

SELECT TOP 501 t.* FROM dbo.vwFakturaRaderMedTaxansNuvarandePris t

SELECT TOP 501 intTjanstnr, strTaxekod, strAnlnr, intKundnr, strAdress, strAktivTjanst
--strProdukt,intRecnum,strMatarnr,
FROM dbo.vwAktivaAvslutadeEjStartadeVATjanster t