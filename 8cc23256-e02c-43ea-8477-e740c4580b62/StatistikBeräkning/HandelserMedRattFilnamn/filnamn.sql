select
       top 20
    z.strFileName,
    case when CHARINDEX('-', right(z.strFileName,8)) = 4 then
        right(z.strFileName,4) else
            left(right(z.strFileName,8),4) end loepnummer,
    v.recHaendelseFileObjectID,
    v.recFileObjectID,
	handelse.datHaendelseDatum
from
     dbo.vwAehAerende arende
         full outer join
         dbo.vwAehHaendelse handelse
            on arende.recAerendeID = handelse.recAerendeID
                    left outer join
         dbo.vwAehHaendelseKoppladeHaendelserMailAttachment x
            on x.recHaendelseID = handelse.recHaendelseID
                    left outer join dbo.vwEDPFileObject z
            on x.recFileObjectID = z.recFileObjectID
                    left outer join dbo.tbAehHaendelseFileObject v
            on v.recFileObjectID = z.recFileObjectID

order by recHaendelseFileObjectID desc