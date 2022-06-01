

/*AK förväntas ha alla fastigheter i frågan
KontaktUpgTableType är också den returnerade typen
det är viktig att denna också inkluderar personnr
då vision inte ger ifrån sig personnr kan det vara nödvändigt attinkludera secundär kontakt.
då en fastighet kan ha många kontakter är det skäligt att ge var ny kontkat en ny rad om facktiskt ny.
ak's rows is expected to be unique
*/
--Create Function dbo.LatestKontaktMethodElseFir(@AK KontaktUpgTableType READONLY,@HK KontaktUpgTableType READONLY) Returns Table as select * from @ak go

CREATE Function #usp_FilterByHasArende(@TVP HandelseTableType READONLY)
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