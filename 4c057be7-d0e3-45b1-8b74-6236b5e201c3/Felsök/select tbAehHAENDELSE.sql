select top 1000 ah.*,taa.strAerendemening,tah.strKommunikationssaett from EDPVisionRegionGotlandTest2.dbo.tbAehAerendeHaendelse ah
left outer join tbAehAerende tAA on tAA.recAerendeID = ah.recAerendeID
left outer join tbAehHaendelse tAH on tAH.recHaendelseID = ah.recHaendelseID



order by ah.recHaendelseID desc



select * from tbAehAerendeHaendelse ah
left outer join tbAehHaendelse tAH on tAH.recHaendelseID = ah.recHaendelseID
 where recAerendeHaendelseID = 410965

