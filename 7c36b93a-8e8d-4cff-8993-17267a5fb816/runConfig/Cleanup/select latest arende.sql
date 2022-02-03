--The DELETE statement conflicted with the REFERENCE constraint "FK_tbAehAerendeAerende_recAerendeID". The conflict occurred in database "EDPVisionRegionGotlandTest2", table "dbo.tbAehAerendeAerende", column 'recAerendeID'
declare @toDelete table
(
 recAerendeID integer
)
;
insert into @toDelete
select recAerendeID from tbAehAerende
where recAerendeID >= 120660
      --and strAerendemening = 'Klart vatten - information om avlopp' and datInkomDatum > datefromparts(2021,01,01)

delete from tbAehAerendeHaendelse where recAerendeID in ( select recAerendeID from @toDelete)
delete
    from tbAehAerende
    where recAerendeID in ( select recAerendeID from @toDelete)

;

select * from tbAehAerende
order by recAerendeID desc


select top 1000 * from EDPVisionRegionGotlandTest2.dbo.tbAehAerende order by recAerendeID desc
