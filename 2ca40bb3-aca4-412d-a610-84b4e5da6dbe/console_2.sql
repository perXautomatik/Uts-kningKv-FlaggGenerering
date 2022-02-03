select * from tbAehHaendelse left outer join tbAehAerendeHaendelse on tbAehHaendelse.recHaendelseID = tbAehAerendeHaendelse.recHaendelseID
where tbAehAerendeHaendelse.recHaendelseID is null

select * from tbAehAerende left outer join tbAehAerendeData tAAD on tbAehAerende.recAerendeID = tAAD.recAerendeID
where tAAD.recLastAerendeStatusLogID is null