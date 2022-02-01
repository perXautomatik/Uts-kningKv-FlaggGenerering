declare @onskadRubrik nvarchar (max) = N'Påminnelse om åtgärd - 12 månader'
declare @onskatDatum date = datefromparts(2021,12,08)
declare @strRiktning nvarchar(20) = N'Utgående';
declare @strKommunikationssaett nvarchar(30) = 'e-medelande';
declare @strText nvarchar(max) = 'Autogenererat den '+ cast(getdate() as varchar);

-- om händelse redan skapat smed samma rubrik och datum,samt indexx skapas ingen ny handelse.
-- should only create one handelse per Ärende, so indexx is to finegrained, we need to eather make index less finegrained or using ärendeid instead of index.

declare @JustInserted table (recHaendelseId integer, recAerendeID integer
 unique (recHaendelseId,recAerendeID) with (ignore_dup_key = on))

declare @tbAehHaendelse table
(
	recHaendelseID int identity primary key,
	datHaendelseDatum date not null,--default @onskatDatum,
	strRubrik nvarchar(max) not null,--default @onskadRubrik,
	strText nvarchar(max),
	strRiktning nvarchar(20),
	strKommunikationssaett nvarchar(30),
	recHaendelseTypID int,
	recHaendelseKategoriID int not null,
	recLastHaendelseStatusLogID int,
	recLastHaendelseSekretessLogID int,
	intAntalFiler int default 0 not null,
	--recDiarieAarsSerieID int, intLoepnummer int, intDiarieSerieAar smallint,
	strTillhoerPostlista nvarchar(68),
	recKommunID int,
	recDelprocessID int,
	recAvdelningID int,
	recEnhetID int,
	recFoervaltningID int,
	strPublicering nvarchar(30) not null, --used as storage for identifier, might be detrimental in the future.
	recRemissutskickID int,
	bolKaensligaPersonuppgifter bit default 0 not null
	,recAerendeID int
)

;

with  StandardHandelse as (select top 1 @onskadRubrik strRubrik, @onskatDatum as datHaendelseDatum
				      , @strText strText
				      , @strRiktning               strRiktning
				      , @strKommunikationssaett strKommunikationssaett
				      ,
					recHaendelseTypID, recHaendelseKategoriID,
             				recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID,
             				--recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,
             				strTillhoerPostlista,
             				recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID,
             				strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter
			   from EDPVisionRegionGotlandTest2.dbo.tbAehHaendelse
			   where strTillhoerPostlista like 'MBNV%'
			    and strRubrik = @onskadRubrik -- what if it does not exsist, then need to be less exact
			   order by datHaendelseDatum desc) --Kopiera fäljande columner från senaste händelse som matchar postlista.

    , IdentifierAsigned as (select
           recAerendeID,dnr, [personnr/Organisationnr] org,@onskadRubrik strRubrik,@onskatDatum datDatum  from
	 ##fannyUtskick
        where recAerendeID is not null
        --if previousRunConfig step failed, selects the whole set.
        )

   ,  filterAlreadyInserted as ( select distinct recAerendeID, dnr --, org
			       from IdentifierAsigned ia
				left outer join tbAehHaendelse ha --to harsh, if 1 handelse match this, it gonna match that against each handelse.
			 on ia.strRubrik = isnull(ha.strRubrik,'') --@onskadRubrik
			 AND ia.datDatum = isnull(ha.datHaendelseDatum,'') --@onskatDatum
   			 and cast(ia.recAerendeID as nvarchar) = isnull(strPublicering,'') --guarantees we won't overwrite a nongenerated handelse.
   			where ha.recHaendelseID is null -- excluding select
       ) -- this is only the filter deciding handelse generation, adding files and kontakter is upcomming.

                             --recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,
insert into @tbAehHaendelse ( strRubrik,datHaendelseDatum, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter,recAerendeID)
select 			     sth.strRubrik,sth.datHaendelseDatum, sth.strText, sth.strRiktning, sth.strKommunikationssaett, sth.recHaendelseTypID,
       			     	sth.recHaendelseKategoriID, sth.recLastHaendelseStatusLogID, sth.recLastHaendelseSekretessLogID,
       				sth.strTillhoerPostlista, sth.recKommunID, sth.recDelprocessID, sth.recAvdelningID,
       			     			sth.recEnhetID, sth.recFoervaltningID, sth.strPublicering, sth.recRemissutskickID, sth.bolKaensligaPersonuppgifter,fai.recAerendeID
from
 StandardHandelse sth, filterAlreadyInserted fai
;


insert into tbAehHaendelse (
                                datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID,
       recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, strTillhoerPostlista, recKommunID, recDelprocessID,
       recAvdelningID, recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter         )
    OUTPUT
           INSERTED.recHaendelseId,cast(INSERTED.strPublicering as integer) INTO @JustInserted
select           	-- Index placed in strPublicering, might not be the best place, we only need it for the output insert, so we could populate any field
    datHaendelseDatum, strRubrik, strText, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID,
       recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler, strTillhoerPostlista, recKommunID, recDelprocessID,
       recAvdelningID, recEnhetID, recFoervaltningID, cast(recAerendeID as varchar), recRemissutskickID, bolKaensligaPersonuppgifter
from @tbAehHaendelse tbah

select * into ##JustInserted from @JustInserted