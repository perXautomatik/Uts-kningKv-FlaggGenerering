declare @onskadRubrik nvarchar = 'Påminnelse om åtgärd - 12 månader'

declare @tbAehHaendelse table
(
	recHaendelseID int identity primary key,
	datHaendelseDatum datetime not null,
	strRubrik nvarchar(255),
	strText nvarchar(max),
	strRiktning nvarchar(20),
	strKommunikationssaett nvarchar(30),
	recHaendelseTypID int,
	recHaendelseKategoriID int not null,
	recLastHaendelseStatusLogID int,
	recLastHaendelseSekretessLogID int,
	intAntalFiler int default 0 not null,
	recDiarieAarsSerieID int,
	intLoepnummer int,
	intDiarieSerieAar smallint,
	strTillhoerPostlista nvarchar(68),
	recKommunID int,
	recDelprocessID int,
	recAvdelningID int,
	recEnhetID int,
	recFoervaltningID int,
	strPublicering nvarchar(30) not null,
	recRemissutskickID int,
	bolKaensligaPersonuppgifter bit default 0 not null
)

declare @JustInserted table (recHaendelseId integer, strText nvarchar(256) unique (recHaendelseId,strText) with (ignore_dup_key = on))
;

alter table ##fannyUtskick add recAerendeID int
go

update Fu
    set Fu.recAerendeID = vAA.recAerendeID
from  ##fannyUtskick Fu inner join
    EDPVisionRegionGotlandTest2.dbo.vwAehAerende vAA on vaa.strDiarienummer = fu.dnr
;

with StandardHandelse as (select top 1 getdate() datHaendelseDatum, @onskadRubrik strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,  strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter
			    from EDPVisionRegionGotlandTest2.dbo.tbAehHaendelse
			    where strTillhoerPostlista like 'MBNV%'
			    order by datHaendelseDatum desc)

   --returns zero if no arende has bin created
    ,ArendenInUtskick as (select recAerendeID,dnr,[personnr/Organisationnr] org from ##fannyUtskick
        where recAerendeID is not null)

   -- this can't be right, we're creating as long nothing has bin asigned in tbAehArendeHaendelse, which could in theory be every execution.

    ,IdentifierAsigned as (select distinct concat(dnr,' ',try_cast(format(org,'#############') as nvarchar)) strTextX, ArendenInUtskick.recAerendeID,dnr, org  from
	 ArendenInUtskick)

   ,filterAlreadyInserted as ( select strTextX, recAerendeID, dnr, org from (select  strTextX, recAerendeID, dnr, org
					      from IdentifierAsigned ia left outer join tbAehHaendelse ha on ia.strTextX = isnull(ha.strText,'') where strText is null) as ih)

insert into @tbAehHaendelse (datHaendelseDatum, strRubrik, 	strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter)
select 			     datHaendelseDatum, strRubrik,  strTextX, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter


from
 StandardHandelse
   ,
 filterAlreadyInserted

insert into tbAehHaendelse
    (		datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter)
    OUTPUT INSERTED.recHaendelseId,INSERTED.strText INTO @JustInserted
	select 	datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter
    from @tbAehHaendelse

select * into ##JustInserted from @JustInserted