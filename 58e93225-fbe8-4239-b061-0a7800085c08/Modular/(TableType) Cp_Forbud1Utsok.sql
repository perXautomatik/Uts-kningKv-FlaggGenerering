:r FilterByHendelse/(header)TableType.sql

:r FilterByHendelse/CreateVisionAdresser.sql
:r FilterByHendelse/CreateFnrToAdress.sql
:r FilterByHendelse/CreateTypeEndastUnikaArenden.sql

/****** Object:  StoredProcedure [dbo].[Cp_Forbud1Utsok]    Script Date: 2020-04-28 16:19:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE CP_FORBUD1UTSOK(@MASTER DBO.TT_ENDASTUNIKAARENDEN READONLY, @DIAKIR HANDELSETABLETYPE READONLY) AS
BEGIN

    declare @ARENDEKONTAKTER as KontaktUpgTableType;
    declare @tp1 as KontaktUpgTableType;
    DECLARE @table3 AS KontaktUpgTableType;
    Declare @ressult as KontaktUpgTableType;

    DECLARE @Table2 AS HandelseTableType;
    DECLARE @handelser AS HandelseTableType;
    DECLARE @Table4 AS HandelseTableType;

    Declare @genomgångna as TT_EndastUnikaArenden;

    declare @ident table (fastighet nvarchar(100), FNR       nvarchar(100), datum     nvarchar(100), andel     nvarchar(100), PERSORGNR nvarchar(100), NAMN      nvarchar(100));
    declare @adress table (PERSORGNR nvarchar(100), CO        nvarchar(100), UTADR1    nvarchar(100), UTADR2    nvarchar(100), POSTNR    nvarchar(100), POSTORT   nvarchar(100));
    declare @fir2 table (fastighet   nvarchar(100), FNR         int, date        date, andel       float, PERSORGNR   nvarchar(100), NAMN        nvarchar(100), FAL_CO      nvarchar(100), FAL_UTADR1  nvarchar(100), FAL_UTADR2  nvarchar(100), FAL_POSTNR  nvarchar(100), FAL_POSTORT nvarchar(100), SAL_CO      nvarchar(100), SAL_UTADR1  nvarchar(100), SAL_UTADR2  nvarchar(100), SAL_POSTNR  nvarchar(100), SAL_POSTORT nvarchar(100), UA_UTADR1   nvarchar(100), UA_UTADR2   nvarchar(100), UA_UTADR3   nvarchar(100), UA_UTADR4   nvarchar(100), UA_LAND     nvarchar(100));


    INSERT INTO @handelser (Diarienummer, fastighet, Ärendemening, Text, Rubrik, Riktning, Datum, ArendeKommentar)

    insert into @ARENDEKONTAKTER (Diarienummer, Fnr, Händelsedatum, Namn, Postnummer, Postort, Gatuadress) select Diarienummer, max(Löpnummer), max(Händelsedatum), ÄrendeKontakter.Huvudkontakt, Postnummer, ÄrendeKontakter.Postort, Gatuadress from ÄrendeKontakter group by Diarienummer, Postnummer, Gatuadress, ÄrendeKontakter.Huvudkontakt, ÄrendeKontakter.Postort

    insert into @tp1 (Diarienummer, Fnr, Händelsedatum, Namn, Postnummer, Postort, Gatuadress)
    select Diarienummer, max(Löpnummer), max(Händelsedatum), namn, Postnummer, Ort, Gatuadress from händelsekontakter group by Diarienummer, Namn, Postnummer, ort, Gatuadress

    insert into @genomgångna (Diarienummer) select Diarienummer from [SlutgiltigLista Förbud1 2020]


    INSERT INTO @Table4 (Diarienummer, fastighet, Ärendemening, Text, Rubrik, Riktning, Datum, ArendeKommentar)
    select distinct q.Diarienummer, q.fastighet, y.ArendeKommentar, y.Text, q.Rubrik, y.Riktning, q.Datum, y.ArendeKommentar from @Table2 y right outer join (select z.Diarienummer, q.Händelsedatum             datum, q.Rubrik, q.[Ärendets huvudfastighet] fastighet from @genomgångna z inner join HändelserFörbud12020 q on z.Diarienummer = q.Diarienummer) q on q.Diarienummer = y.Diarienummer

    INSERT INTO @table3 (Diarienummer, Fnr, fastighet, Händelsedatum, Namn, Postnummer, Postort, Gatuadress)
    select kir.Diarienummer, kir.fnr, fastighet, vision.datum, Namn, dbo.udf_GetNumeric(Postnummer), Postort, Gatuadress from (select * from dbo.kirToFnr(@Table4)) kir left outer join dbo.visionAdresser(@tp1, @ARENDEKONTAKTER) vision on vision.Diarienummer = kir.Diarienummer

    insert into @ressult (Diarienummer, Fnr, fastighet, Händelsedatum, Namn, Postnummer, Gatuadress, Postort, personnr)
    select Diarienummer, Fnr, fastighet, Händelsedatum, Namn, Postnummer, Gatuadress, Postort, personnr from dbo.FnrToAdress(@table3)

    insert into @fir2 (fastighet, FNR, date, andel, PERSORGNR, NAMN, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND)
    select distinct ress.fastighet, ress.FNR, INSKDATUM                                                          'date', cast(left(ANDEL, charindex('/', ANDEL, 1) - 1) as float) / cast(right(ANDEL, len(ANDEL) - charindex('/', ANDEL, 1)) as float) andel, PERSORGNR, fir.NAMN, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND from (select *from (select Diarienummer, Fnr, fastighet, cc_prio, avg(CC_prio) over (partition by fnr) / 500 komplett from @ressult) a where komplett < 1) ress join GISDATA.sde_geofir_gotland.gng.FA_lagfart_V2 fir on ress.Fnr = fir.Fnr

    insert into @ident select fastighet, FNR, date, andel, PERSORGNR, NAMN from @fir2
    insert into @adress
    select PERSORGNR, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from @fir2 union select PERSORGNR, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT from @fir2 union  select PERSORGNR, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND from @fir2

    select i.*, a.CO, a.UTADR1, a.UTADR2, a.POSTNR, a.POSTORT
    from (select *
          from @adress
          where not (co is null ANd UTADR1 is null and UTADR2 is null AND POSTNR is null and POSTORT is null)
          group by PERSORGNR, co, UTADR1, UTADR2, POSTNR, POSTORT) a
             join @ident i on i.PERSORGNR = a.PERSORGNR end;