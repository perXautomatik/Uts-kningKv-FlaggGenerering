
select
    z.strFileName,
    case when CHARINDEX('-',
        right(z.strFileName,8)) = 4 then right(z.strFileName,4) else left(right(z.strFileName,8),4) end loepnummer,
    v.recHaendelseFileObjectID,
    v.recFileObjectID
from
     EDPVisionRegionGotland.dbo.vwAehAerende arende
         full outer join
         EDPVisionRegionGotland.dbo.vwAehHaendelse handelse
            on arende.recAerendeID = handelse.recAerendeID
                    left outer join EDPVisionRegionGotland.dbo.vwAehHaendelseKoppladeHaendelserMailAttachment x
            on x.recHaendelseID = handelse.recHaendelseID
                    left outer join EDPVisionRegionGotland.dbo.vwEDPFileObject z
            on x.recFileObjectID = z.recFileObjectID
                    left outer join EDPVisionRegionGotland.dbo.tbAehHaendelseFileObject v
            on v.recFileObjectID = z.recFileObjectID

where handelse.intRecnum = 440048
