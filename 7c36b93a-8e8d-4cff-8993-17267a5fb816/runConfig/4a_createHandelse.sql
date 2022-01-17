declare @onskadRubrik nvarchar = N'Påminnelse om åtgärd - 12 månader'
declare @onskatDatum date = datefromparts(2021,12,08)
declare @JustInserted table (recHaendelseId integer, indexX integer
 unique (recHaendelseId,indexX) with (ignore_dup_key = on))

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
	,indexX int
)
;

with  StandardHandelse as (select top 1 @onskatDatum datHaendelseDatum, @onskadRubrik strRubrik
				      , strText, strRiktning, strKommunikationssaett,
             					 recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,  strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter
			   from EDPVisionRegionGotlandTest2.dbo.tbAehHaendelse
			   where strTillhoerPostlista like 'MBNV%'
			   order by datHaendelseDatum desc)
      --returns zero if no arende has bin created
    , ArendenInUtskick as (select indexX,recAerendeID,dnr,[personnr/Organisationnr] org from ##fannyUtskick
        where recAerendeID is not null)

      -- this can't be right, we're creating as long nothing has bin asigned in tbAehArendeHaendelse, which could in theory be every execution.

    , IdentifierAsigned as (select
           indexX,
           -- ,concat(dnr,' ',try_cast(format(org,'#############') as nvarchar)) strTextX,
           ArendenInUtskick.recAerendeID,dnr, org,@onskadRubrik strRubrik,@onskatDatum datDatum  from
	 ArendenInUtskick)
   ,  filterAlreadyInserted as ( select
          recAerendeID, dnr, org,indexX
   from (select  recAerendeID, dnr, org,ia.indexX
					      from IdentifierAsigned ia
left outer join tbAehHaendelse ha on ia.strRubrik = isnull(ha.strRubrik,'') AND ia.datDatum = isnull(ha.datHaendelseDatum,'')  where ha.recHaendelseID is null

       ) as ih)

insert into @tbAehHaendelse (datHaendelseDatum, strRubrik,  strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter,indexX)
select 			     datHaendelseDatum, strRubrik,  strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter,indexX
from
 StandardHandelse, filterAlreadyInserted
;


insert into tbAehHaendelse
    (		datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter)
    OUTPUT INSERTED.recHaendelseId,cast(INSERTED.strText as integer) INTO @JustInserted
	select 	datHaendelseDatum, strRubrik, cast(indexX as nvarchar), strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter
    from @tbAehHaendelse tbah

select * into ##JustInserted from @JustInserted