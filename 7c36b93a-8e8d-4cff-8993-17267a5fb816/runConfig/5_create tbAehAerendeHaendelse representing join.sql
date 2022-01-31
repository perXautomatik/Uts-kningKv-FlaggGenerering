with
    Insertable            as (select distinct recAerendeID, recHaendelseID
			      from ##fannyUtskick
			      where
			            recHaendelseID is not null and recAerendeID is not null)
  ,filterAlreadyInserted as (select i.*
			      from insertable i
				  left outer join tbAehAerendeHaendelse taah
				  on (taah.recAerendeID = i.recAerendeID AND taah.recHaendelseID = i.recAerendeID)
      				where taah.recAerendeID is null

      )

insert into tbAehAerendeHaendelse (recAerendeID, recHaendelseID, intLoepnummerHaendelse)
select recAerendeID
     , recHaendelseID
     , isnull((select top 1 intLoepnummerHaendelse
	       from tbAehAerendeHaendelse tbx
	       where recAerendeID = fai.recAerendeID), 0)
    + row_number() over (partition by fai.recAerendeID order by fai.recHaendelseID) intLoepnummerHaendelse
from filterAlreadyInserted fai

;
