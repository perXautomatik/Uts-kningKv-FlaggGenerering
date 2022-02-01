--The DELETE statement conflicted with the REFERENCE constraint "FK_tbAehAerendeHaendelse_recHaendelseID". The conflict occurred in database "EDPVisionRegionGotlandTest2", table "dbo.tbAehAerendeHaendelse", column 'recHaendelseID'



declare @toDelete table
(
 recHaendelseID integer
)
;
insert into @toDelete
select recHaendelseID from tbAehHaendelse
where strKommunikationssaett is null and recHaendelseKategoriID = 7 and recDiarieAarsSerieID = 56 and strText like 'mbnv%'

delete from tbAehHaendelseEnstakaKontakt where recHaendelseID in ( select recHaendelseID from @toDelete)
delete from tbAehHaendelseUser where recHaendelseID in ( select recHaendelseID from @toDelete)
delete from dbo.tbAehHaendelseEnstakaFastighet where recHaendelseID in ( select recHaendelseID from @toDelete)
delete
    from tbAehHaendelse
    where recHaendelseID in ( select recHaendelseID from @toDelete)

;

select * from tbAehHaendelse
order by recHaendelseID desc

            (select recHaendelseID from tbAehHaendelse where strPublicering is not null and strTillhoerPostlista = 'mbnv-2019' and strPublicering not in( 'Visa med kontaktinformation','Visa med personskydd','Visa inte') and strRubrik is null)