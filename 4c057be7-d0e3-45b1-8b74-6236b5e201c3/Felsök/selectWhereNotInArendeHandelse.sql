select * from tbAehHaendelse left outer join tbAehAerendeHaendelse on tbAehHaendelse.recHaendelseID = tbAehAerendeHaendelse.recHaendelseID
where tbAehAerendeHaendelse.recHaendelseID is null