with
     TjansteNrAndTjanst as (
         select intTjanstnr,concat(strTaxekod_strDelprodukt,nullif(concat(' Avbrutet:',FORMAT (datStoppdatum, 'yyyy-MM-dd')),' Avbrutet:')) datStoppdatum from (select intTjanstnr,
                                 strAnlOrt,nullif(max(isnull(datStoppdatum, smalldatetimefromparts(1900, 01, 01, 00, 00))),smalldatetimefromparts(1900, 01, 01, 00, 00)) datStoppdatum,
                                 concat( strDelprodukt,'|',strTaxebenamning)              strTaxekod_strDelprodukt
                          from EDPFutureGotland.dbo.vwRenhTjanstStatistik
                          where
                            strTaxekod != 'BUDSM' AND strDelprodukt != N'DEPO' AND    strDelprodukt != N'CONT' AND strDelprodukt != N'GRUNDR' AND strDelprodukt != N'ÖVRTRA' AND strDelprodukt != N'ÖVRTRA' AND strDelprodukt != 'HUSH' AND strDelprodukt != N'ÅVCTR' AND not(strTaxekod like 'HYRA%')
                          group by intTjanstnr, strAnlOrt, strTaxekod, strDelprodukt, strTaxebenamning) q),
     anlaggning as (select strAnlnr,strAnlaggningsKategori,strFastBeteckningHel strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat from EDPFutureGotland.dbo.vwAnlaggning)
     ,tjanst as (select intTjanstnr,strAnlnr from EDPFutureGotland.dbo.vwTjanst)

,fastighetspunkterSlam as ( select nullif(strFastBeteckningHel,'') strFastBeteckningHelX,
           nullif(decAnlXKoordinat,0) decAnlXKoordinat,
           nullif(decAnlYkoordinat,0) decAnlYkoordinat
           from anlaggning
    )

select TjansteNrAndTjanst.datStoppdatum slamAnteckning,anlaggning.strFastBeteckningHel,fastighetspunkterSlam.decAnlXKoordinat,fastighetspunkterSlam.decAnlYkoordinat from
    TjansteNrAndTjanst
    left outer join tjanst
        on tjanst.intTjanstnr = TjansteNrAndTjanst.intTjanstnr
    left outer join anlaggning
        on anlaggning.strAnlnr = tjanst.strAnlnr
    right outer join fastighetspunkterSlam
        ON strFastBeteckningHelX = fastighetspunkterSlam.strFastBeteckningHelX
 --   group by datStoppdatum, strFastBeteckningHel, fastighetspunkterSlam.decAnlXKoordinat, fastighetspunkterSlam.decAnlYkoordinat
;

SELECT TOP 501 t.*
FROM dbo.vwFakturaRaderMedTaxansNuvarandePris t

SELECT TOP 501 intTjanstnr,
               strTaxekod,
               --strMatarnr,
               strAnlnr,
               --intRecnum,
               intKundnr,
               strAdress,
--               strProdukt,
               strAktivTjanst
FROM dbo.vwAktivaAvslutadeEjStartadeVATjanster t
