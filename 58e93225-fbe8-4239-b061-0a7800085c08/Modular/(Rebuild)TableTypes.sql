USE [tempExcel]
GO

Begin try
    DROP FUNCTION [dbo].[usp_FilterByHasArende]
END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO

Begin try
    DROP FUNCTION [dbo].[usp_FilterByHasArende]
END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO

Begin try
    DROP FUNCTION [dbo].[checkThatItsNotBadHadelseNamn]
END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO

Begin try
    DROP FUNCTION [dbo].[KirToFnr]
END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO
Begin try
    DROP FUNCTION [dbo].[senastKontaktMedHandelsetext]
END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO

Begin try
    DROP FUNCTION [dbo].checkThatItsNotBadHadelseNamn;
END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO

Begin try
    DROP FUNCTION [dbo].[FnrToAdress]

END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO

Begin try
    DROP TYPE [dbo].[HandelseTableType]
END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO

Begin try
    DROP TYPE [dbo].[DiaFnrFastTableType]
END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO

Begin try
    DROP TYPE [dbo].[KontaktUpgTableType]
END TRY BEGIN CATCH
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
END CATCH;
GO

CREATE TYPE dbo.HandelseTableType
AS TABLE
(
    Diarienummer    varchar(20)  not null,
    fastighet       varchar(50),
    Ärendemening    varchar(100),
    Text            varchar(max),
    Rubrik          varchar(100) not null,
    Riktning        varchar(20),
    CC_harAnsok     as (
        case
            when Rubrik like '_eslut%' then 1
            when Rubrik like '_n%' then
                case
                    when rubrik like N'_nsökan%' then 1
                    when Rubrik like N'_nmälan%' then 1
                    else 0 end
            when Rubrik like N'%tförandeintyg' then 1
            else 0 end),
    CC_badRubrik    as (
        case
            when rubrik like '_ekräftelse%' then 1
            when rubrik like '_esiktning%' then 1
            when rubrik like '_åminnelse om åtgärd%' then 1
            when rubrik like '%akulerad%' then 1
            when rubrik in ('Mottagningskvitto', 'Uppföljning 2 år från klart vatten utskick') then 1
            else 0 END),
    Datum           varchar(30)  not null,
    ArendeKommentar varchar(200),
    id              int identity not null
        PRIMARY KEY NONCLUSTERED (id, datum, Rubrik, Diarienummer, CC_badRubrik, CC_harAnsok)
)
GO


CREATE TYPE dbo.DiaFnrFastTableType
AS TABLE
(
    Diarienummer varchar(20)  not null,
    kir          nvarchar(50) not null,
Fnr          int 
PRIMARY KEY NONCLUSTERED (Diarienummer, kir, Fnr)
)
go

CREATE TYPE dbo.KontaktUpgTableType
AS TABLE
(
    Diarienummer  varchar(20)  not null,
    Fnr           int          not null,
    fastighet     nvarchar(50),
    Händelsedatum datetime,
    Namn          nvarchar(255),
    Postnummer    nvarchar(255),
    Postort       nvarchar(255),
    Gatuadress    nvarchar(255),
    personnr      varchar(40),
    id            int identity not null,
    CC_prio       as 100 *
                     (case when isnull(Gatuadress, '') = '' then 0 else 1 end +
                      case when isnull(Postnummer, '') = '' then 0 else 1 end +
                      case when isnull(Postort, '') = '' then 0 else 1 end +
                      case when isnull(namn, '') = '' then 0 else 1 end +
                      case when isnull(personnr, '') = '' then 0 else 1 end
                         ) PERSISTED NOT NULL,
    harNamn       as cast(case when isnull(namn, '') = '' then 0 else 1 end as bit)
                      PRIMARY KEY NONCLUSTERED (id, Diarienummer, Fnr, CC_prio)
)
GO


CREATE Function dbo.usp_FilterByHasArende(@TVP HandelseTableType READONLY)
    RETURNS table AS
        return select tv.*
               from @tvp tv
                        left outer join (select Diarienummer
                                         from @TVP
                                         where CC_harAnsok = 1) has on has.Diarienummer = tv.Diarienummer
               where has.Diarienummer is null
GO


CREATE FUNCTION dbo.checkThatItsNotBadHadelseNamn(@TVP HandelseTableType READONLY)
    RETURNS Table AS return select tv.*
                            from @tvp tv
                            where CC_badrubrik = 0
Go

Create Function dbo.KirToFnr(@TVP HandelseTableType READONLY)
    Returns Table as
        return
        select z.*, x.fnr
        from @TVP z
                 join
             [gisdata].[sde_geofir_gotland].[gng].Fa_Fastighet x on z.fastighet = x.beteckning
go

-- insert tabbles from händelser and ärenden, in that order, 
-- we are given äendenr. is not null
-- we return a table with eather null or or adress joined
-- better not return null values, rathre a smaller table.
-- the returntype should be of adress table type
--insert, tb1, tb2
-- if tbl 1 has adress, then ignore tvbl2 else table 2.
-- the tables should both contain same ärendenrs.
-- so in theory we could just 
--diarienummer as (select ärendenr from tbl1 union select ärende from table 2 )
-- then we select from tbl1 where.. could we use isnull? basicly isnull(table1,table2) we can't of 
--course becase isnull takes columns, but we could use a id and join on that.
-- give them a computed column, replacing there ärendenr, then give them order so we can do rownr =1
-- computeed column, gotta be, null or not, table1 or table 2.
-- we also only want the latest non null adress from händelse tabellen.
/*AK förväntas ha alla fastigheter i frågan
KontaktUpgTableType är också den returnerade typen
det är viktig att denna också inkluderar personnr
då vision inte ger ifrån sig personnr kan det vara nödvändigt attinkludera secundär kontakt.
då en fastighet kan ha många kontakter är det skäligt att ge var ny kontkat en ny rad om facktiskt ny.
ak's rows is expected to be unique
*/
--Create Function dbo.LatestKontaktMethodElseFir(@AK KontaktUpgTableType READONLY,@HK KontaktUpgTableType READONLY) Returns Table as select * from @ak go
--(select *, row_number() over (partiotion by diarienummer sort by diarienummer)*
--100*(isnull(adr)+isnull(postnr)+isnull(postort)+isnull(name)) prio from table1) ressult

-- becasue we want the least faulty, and latest.
-- we pick the highest number by 
--select top 1 from ressult order by prio desc where diarienummer.diarienummer = ressult.diarienummer
-- we do a 
--ressultJOin as select * from diarienummer cross join 
-- then we make a 
--tbl2 left iouter join on ressultjoin where adress is null, and tbl2 adress is not null on ressultjoin.diarienummer = tbl2.diarienummer 

-- then union both ressults.
-- due to the complexity of the method, it cant be inline.

-- the nwe insert it in the  ressult table.
--declare @ab as adresstableType
--insert into @ab select * from 

-- then we make another fuction reciving this table
-- function (tbl1 as adresstabletype) return as table
-- the table insert table has diarienummer not null but null on every personnr.
-- might have some adresses, does that doesn't have adresses, fetch from my fir method
-- fetch personnr for does that have adress but not personnr by reverse lookup.

-- select col1,col2,col3 from x join y using c? <- if youre writing the columns you want?
-- inupt left outer join where input adress is null using fnr
-- we have to make sure our fnrToFir return the correct tabletype, does it work 



DECLARE @Table2 AS dbo.HandelseTableType

    INSERT INTO @Table2 (Diarienummer, fastighet, Ärendemening, Text, Rubrik, Riktning, Datum, ArendeKommentar)
    select z.Diarienummer,
           z.fastighet,
           z.Ärendemening,
           z.Text,
           z.Rubrik,
           z.Riktning,
           z.Datum,
           z.ArendeKommentar
    from [tempExcel].[dbo].[checkThatItsNotBadHadelseNamn](@handelser) z
             inner join usp_FilterByHasArende(@handelser) q on q.id = z.id
             inner join dbo.senastKontaktMedHandelsetext(@handelser) y on z.id = y.id

CREATE FUNCTION dbo.senastKontaktMedHandelsetext(@input HandelseTableType READONLY)
    RETURNS table AS
        return
        select *
        from (SELECT *,
                     row_number() over (partition by diarienummer order by cast(cast(datum as datetime) as int) *
                                                                           (CASE WHEN tz.TEXT IS NOT NULL THEN 1000 ELSE 1 END) desc) CC_priorit
              from @input tz) q
        where CC_priorit = 1
go

--CAST(CASE WHEN isnull([ANDEL],'') = '' THEN '1/1' ELSE [ANDEL] END AS varchar) as Händelsedatum,