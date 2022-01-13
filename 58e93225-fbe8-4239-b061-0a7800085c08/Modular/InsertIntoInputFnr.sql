DECLARE @inputFnr AS dbo.KontaktUpgTableType
INSERT
INTO @inputFnr (Diarienummer, Fnr)
select Diarienummer, Fnr
from dbo.kirToFnr(@handelser)
group by Diarienummer, Fnr;
