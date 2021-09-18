select dbo.usp_SplitReturnOcX('a-s-b-c-d',0,'-')

select
    z.strFileName,
    [dbo].usp_SplitReturnOcX(z.strFileName,5,'-') ag,

    v.recHaendelseFileObjectID,
    v.recFileObjectID
from
    [EDPRemote].[EDPVisionRegionGotland].dbo.vwAehAerende arende
         full outer join
          [admsql04].[EDPVisionRegionGotland].dbo.vwAehHaendelse handelse
            on arende.recAerendeID = handelse.recAerendeID
                    left outer join [admsql04].[EDPVisionRegionGotland].dbo.vwAehHaendelseKoppladeHaendelserMailAttachment x
            on x.recHaendelseID = handelse.recHaendelseID
                    left outer join  [admsql04].[EDPVisionRegionGotland].dbo.vwEDPFileObject z
            on x.recFileObjectID = z.recFileObjectID
                    left outer join  [admsql04].[EDPVisionRegionGotland].dbo.tbAehHaendelseFileObject v
            on v.recFileObjectID = z.recFileObjectID

where handelse.intRecnum = 440048
