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

declare @JustInserted table
(
 recHaendelseId integer,
 strText nvarchar(256)
 unique (recHaendelseId,strText)
 with (ignore_dup_key = on)
 )

with StandardHandelse as (select top 1 getdate() datHaendelseDatum, 'P�minnelse om �tg�rd - 12 m�nader' strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,  strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter
			    from EDPVisionRegionGotlandTest2.dbo.tbAehHaendelse
			    where strTillhoerPostlista like 'MBNV%'
			    order by datHaendelseDatum desc)
    ,ArendenInUtskick as (select vAA.recAerendeID,fu.dnr,fu.[personnr/Organisationnr] org from ##fannyUtskick fu inner join EDPVisionRegionGotlandTest2.dbo.vwAehAerende vAA on vaa.strDiarienummer = fu.dnr)

   -- this can't be right, we're creating as long nothing has bin asigned in tbAehArendeHaendelse, which could in theory be every execution.
    ,tbAehAerendeHaendelseReferens               as (select tbah.*,tbAehAerendeHaendelseReferens.strRubrik from tbAehAerendeHaendelse tbah
			    inner join tbAehHaendelse qw
				on tbah.recHaendelseID = tbAehAerendeHaendelseReferens.recHaendelseID
					  where strRubrik = 'P�minnelse om �tg�rd - 12 m�nader')
   ,qwsfasdf         as (
	select distinct ArendenInUtskick.recAerendeID,recHaendelseID,dnr, org  from
	 ArendenInUtskick
		left outer join
		     tbAehAerendeHaendelseReferens

			on ArendenInUtskick.recAerendeID = tbAehAerendeHaendelseReferens.recAerendeID
 		   		where  tbAehAerendeHaendelseReferens.strRubrik is null)


insert into @tbAehHaendelse (datHaendelseDatum, strRubrik, 	strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter)
select 			     datHaendelseDatum, strRubrik, concat(dnr,' ',try_cast(format(org,'#############') as nvarchar))  strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter


from
 StandardHandelse
   ,
 qwsfasdf

insert into tbAehHaendelse
    (		datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter)
    OUTPUT INSERTED.recHaendelseId,INSERTED.strText INTO @JustInserted
	select 	datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter
    from @tbAehHaendelse

select * into ##JustInserted from @JustInserted