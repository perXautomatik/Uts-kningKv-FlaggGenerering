DECLARE @table3 AS dbo.KontaktUpgTableType
INSERT INTO @table3 (Diarienummer, Fnr)
select Diarienummer, Fnr
from dbo.kirToFnr(@Table2)
group by Diarienummer, Fnr

select diarienummer, fnr
from @table3