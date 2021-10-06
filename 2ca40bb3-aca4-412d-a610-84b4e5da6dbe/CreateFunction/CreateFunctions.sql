

USE [tempExcel]
GO

DROP FUNCTION [dbo].usp_xFilterByHasArende
GO

DROP FUNCTION [dbo].sp_xCheckThatItsNotBadHadelseNa
GO

DROP FUNCTION [dbo].sp_xKirToFnr
GO


DROP FUNCTION [dbo].sp_xFilterSenasteMedKon
GO



begin try
IF OBJECT_ID (N'dbo.checkThatItsNotBadHadelseNamn', N'FN') IS NOT NULL DROP FUNCTION sp_xCheckThatItsNotBadHadelseNa;
 END TRY BEGIN CATCH PRINT 'Error Number: ' + str(error_number()) ; PRINT 'Line Number: ' + str(error_line()); PRINT error_message(); ROLLBACK TRANSACTION; END CATCH; 
GO

/****** Object:  UserDefinedFunction [dbo].[FnrToAdress]    Script Date: 2020-02-27 13:08:15 ******/
DROP FUNCTION [dbo].sp_xKonUpgToAdr
GO

/* has to drop tableType last*/
DROP TYPE [dbo].[HandelseTableType]
GO

CREATE TYPE HandelseTableType
   AS TABLE
      (
    Diarienummer              varchar(20)  not null,
    huvudfastighet            varchar(50),
    Ärendemening              varchar(100),
    Text                      varchar(max),
    Rubrik                    varchar(100) not null,
    Riktning                  varchar(20),
    Datum                     dateTime  not null,
    ArendeKommentar           varchar(200),
    id                        int identity not null
     )
go

DROP TYPE tempExcel.dbo.HandelseTableType
GO

CREATE TYPE HandelseTableTypeFnr
   AS TABLE
      (
    Diarienummer              varchar(20)  not null,
    huvudfastighet            nvarchar(50),
    Ärendemening              nvarchar(100),
    Text                      nvarchar(max),
    Rubrik                    nvarchar(100) not null,
    Riktning                  nvarchar(20),
    Datum                     dateTime  not null,
    ArendeKommentar           nvarchar(200),
	Fnr						  int,
    id                        int identity not null
     )
go

DROP TYPE [dbo].[KontaktUpgTableType]
GO

CREATE TYPE KontaktUpgTableType
AS TABLE
    (
    Diarienummer              varchar(20)  not null,
    Fnr						  int not null,
	Händelsedatum			  datetime,
	Namn					  nvarchar(255),
	Postnummer				  nvarchar(255),
	Postort					  nvarchar(255),
	Gatuadress				  nvarchar(255),
	personnr				  varchar (40)
	)
GO



/*AK förväntas ha alla fastigheter i frågan
KontaktUpgTableType är också den returnerade typen
det är viktig att denna också inkluderar personnr
då vision inte ger ifrån sig personnr kan det vara nödvändigt attinkludera secundär kontakt.
då en fastighet kan ha många kontakter är det skäligt att ge var ny kontkat en ny rad om facktiskt ny.
ak's rows is expected to be unique
*/
--Create Function dbo.LatestKontaktMethodElseFir(@AK KontaktUpgTableType READONLY,@HK KontaktUpgTableType READONLY) Returns Table as select * from @ak go

CREATE Function dbo.usp_FilterByHasArende(@TVP HandelseTableType READONLY)
RETURNS table AS
      return select tv.* from @tvp tv left outer join (select Diarienummer from @TVP 
	  where  (Riktning = 'Inkommande' OR Riktning = 'Utgående') 
	  AND (Rubrik like N'Ansökan%' 
	  OR Rubrik like N'ansökan%' 
	  OR Rubrik like N'Anmälan%' 
	  OR Rubrik like N'anmälan%' 
	  OR Rubrik like N'%Utförandeintyg' 
	  OR Rubrik like N'%utförandeintyg' 
	  OR Rubrik like 'beslut%' )) 
	  has on has.Diarienummer = tv.Diarienummer where has.Diarienummer is null
GO


CREATE FUNCTION dbo.checkThatItsNotBadHadelseNamn(@TVP HandelseTableType READONLY) 
RETURNS Table AS
	return
	select tv.* from @tvp tv where  Not (rubrik like 'Bekräftelse%')
	
	AND not( rubrik like 'Besiktning%')
	
	AND not( rubrik like 'Påminnelse om åtgärd%')
	
	AND not( rubrik like '%Makulerad%') AND not (Rubrik  in
   ('Mottagningskvitto', 'Uppföljning 2 år från klart vatten utskick'))

Go


Create Function dbo.KirToFnr(@TVP HandelseTableType READONLY)
Returns Table as
	return
		select z.*,x.fnr from @TVP z join
			sde_geofir_gotland.gng.FA_FASTIGHET x on z.huvudfastighet = x.beteckning
go


CREATE FUNCTION dbo.FnrToAdress(@inputFnr HandelseTableTypeFnr READONLY) RETURNS table AS
return
    select q.*,
           CAST(CASE WHEN [ANDEL] is null OR [ANDEL] = '' THEN '1/1' ELSE [ANDEL] END AS varchar) as andel,
               CAST(CASE WHEN [NAMN] is null OR [NAMN] = '' THEN KORTNAMN ELSE [NAMN] END AS varchar) as Namn,
               CAST(CASE
                        WHEN ([FAL_UTADR2] is null OR [FAL_UTADR2] = '') AND ([FAL_POSTNR] is null OR [FAL_POSTNR] = '')
                            then CASE
                                     WHEN (SAL_UTADR1 is null OR SAL_UTADR1 = '') AND
                                          (SAL_POSTNR is null OR SAL_POSTNR = '') THEN UA_UTADR1
                                     ELSE SAL_UTADR1 END
                        ELSE FAL_UTADR2 END AS varchar)                                               as Adress,
               CAST(CASE
                        WHEN ([FAL_UTADR2] is null OR [FAL_UTADR2] = '') AND ([FAL_POSTNR] is null OR [FAL_POSTNR] = '')
                            then CASE
                                     WHEN (SAL_UTADR1 is null OR SAL_UTADR1 = '') AND
                                          (SAL_POSTNR is null OR SAL_POSTNR = '') THEN UA_UTADR2
                                     ELSE SAL_POSTNR END
                        ELSE [FAL_POSTNR] END AS varchar)                                             as POSTNUMMER,
               CAST(CASE
                        WHEN ([FAL_POSTORT] is null OR [FAL_POSTORT] = '') AND
                             ([FAL_POSTNR] is null OR [FAL_POSTNR] = '') then CASE
                                                                                  WHEN (SAL_UTADR1 is null OR SAL_UTADR1 = '') AND
                                                                                       (SAL_POSTNR is null OR SAL_POSTNR = '')
                                                                                      THEN UA_LAND
                                                                                  ELSE SAL_POSTORT END
                        ELSE [FAL_POSTORT] END AS varchar)                                            as postOrt,
               [PERSORGNR]
        FROM (SELECT fnr, [UA_UTADR2], [UA_UTADR1], [UA_LAND], [SAL_POSTORT], [SAL_POSTNR], [NAMN], [KORTNAMN], [FAL_UTADR2], [FAL_POSTORT], [FAL_POSTNR], [ANDEL], [SAL_UTADR1], [PERSORGNR]
                     --,[UA_UTADR4],--[UA_UTADR3],--[TNMARK],--[SAL_UTADR2],--[SAL_CO],--[NAMN_OMV],--[MNAMN],--[KORTNAMN_OMV],--[FNAMN],--[FAL_UTADR1],--[FAL_CO],--[ENAMN]
              FROM (
                       select FNR, [UA_UTADR2], [UA_UTADR1], [UA_LAND], [SAL_POSTORT], [SAL_POSTNR], [NAMN], [KORTNAMN], [FAL_UTADR2], [FAL_POSTORT], [FAL_POSTNR], min(ANDEL) 'andel', [SAL_UTADR1], [PERSORGNR] --ifall att ägarbyte skett och gammla ägande inte updaterats, välj den minsta ägande
                       from [GISDATA].sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2
                       group by FNR, [UA_UTADR2], [UA_UTADR1], [UA_LAND], [SAL_POSTORT],
                                [SAL_POSTNR], [NAMN], [KORTNAMN], [FAL_UTADR2], [FAL_POSTORT],
                                [FAL_POSTNR], [SAL_UTADR1], [PERSORGNR]
                   ) as tax
				
            ) t inner join @inputFNR q on q.fnr = t.FNR

Go

CREATE FUNCTION dbo.senastKontaktMedHandelsetext(@input HandelseTableType READONLY) RETURNS table AS

return 
	--select * from @input
	select * from (SELECT *,row_number() over (partition by diarienummer order by cast(datum as int)*(CASE WHEN tz.TEXT IS NOT NULL THEN 1000 ELSE 1 END)  desc) priorit from @input tz ) q where priorit = 1
go

