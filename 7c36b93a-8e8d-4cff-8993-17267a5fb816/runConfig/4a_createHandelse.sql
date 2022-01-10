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
 strText nvarchar(max)
 unique (recHaendelseId,strText)
 )
insert into @tbAehHaendelse (datHaendelseDatum, strRubrik, 	strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter)

select 			     datHaendelseDatum, strRubrik, concat(dnr,' ',try_cast(format(org,'#############') as nvarchar))  strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter


from
(select top 1 getdate() datHaendelseDatum, 'Påminnelse om åtgärd - 12 månader' strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,  strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter
from EDPVisionRegionGotlandTest2.dbo.tbAehHaendelse
where strTillhoerPostlista like 'MBNV%'
order by datHaendelseDatum desc) fgh
   ,
(select distinct tbh.recAerendeID,recHaendelseID,dnr, org  from
	(select vAA.recAerendeID,fu.dnr,fu.[personnr/Organisationnr] org from ##fannyUtskick fu inner join EDPVisionRegionGotlandTest2.dbo.vwAehAerende vAA on vaa.strDiarienummer = fu.dnr) tbh
		left outer join
		(select tbah.*,qw.strRubrik from tbAehAerendeHaendelse tbah
	    		inner join tbAehHaendelse qw
			    on tbah.recHaendelseID = qw.recHaendelseID
				      where strRubrik = 'Påminnelse om åtgärd - 12 månader') qw

			on tbh.recAerendeID = qw.recAerendeID
 		   		where  qw.strRubrik is null) qwsfasdf

insert into tbAehHaendelse (datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter)
    OUTPUT INSERTED.recHaendelseId,INSERTED.strText INTO @JustInserted
	select datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter
		from @tbAehHaendelse

select * into ##JustInserted from @JustInserted

select * from ##JustInserted