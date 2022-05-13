

/*AK f�rv�ntas ha alla fastigheter i fr�gan
KontaktUpgTableType �r ocks� den returnerade typen
det �r viktig att denna ocks� inkluderar personnr
d� vision inte ger ifr�n sig personnr kan det vara n�dv�ndigt attinkludera secund�r kontakt.
d� en fastighet kan ha m�nga kontakter �r det sk�ligt att ge var ny kontkat en ny rad om facktiskt ny.
ak's rows is expected to be unique
*/
--Create Function dbo.LatestKontaktMethodElseFir(@AK KontaktUpgTableType READONLY,@HK KontaktUpgTableType READONLY) Returns Table as select * from @ak go

CREATE Function #usp_FilterByHasArende(@TVP HandelseTableType READONLY)
RETURNS table AS
      return select tv.* from @tvp tv left outer join (select Diarienummer from @TVP
	  where  (Riktning = 'Inkommande' OR Riktning = 'Utg�ende')
	  AND (Rubrik like N'Ans�kan%'
	  OR Rubrik like N'ans�kan%'
	  OR Rubrik like N'Anm�lan%'
	  OR Rubrik like N'anm�lan%'
	  OR Rubrik like N'%Utf�randeintyg'
	  OR Rubrik like N'%utf�randeintyg'
	  OR Rubrik like 'beslut%' ))
	  has on has.Diarienummer = tv.Diarienummer where has.Diarienummer is null
GO