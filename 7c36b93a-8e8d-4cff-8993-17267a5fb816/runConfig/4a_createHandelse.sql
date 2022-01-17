declare @onskadRubrik nvarchar = N'Påminnelse om åtgärd - 12 månader'
declare @onskatDatum date = datefromparts(2021,12,08)

-- om händelse redan skapat smed samma rubrik och datum,samt indexx skapas ingen ny handelse.
-- should only create one handelse per Ärende, so indexx is to finegrained, we need to eather make index less finegrained or using ärendeid instead of index.

declare @JustInserted table (recHaendelseId integer, indexX integer
 unique (recHaendelseId,indexX) with (ignore_dup_key = on))

declare @tbAehHaendelse table
(
	recHaendelseID int identity primary key,
	datHaendelseDatum as @onskatDatum,
	strRubrik as @onskadRubrik,
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

with  StandardHandelse as (select top 1 strRubrik
				      , strText, strRiktning, strKommunikationssaett,
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
           recAerendeID,dnr, org,@onskadRubrik strRubrik,@onskatDatum datDatum  from
	 from ##fannyUtskick
        where recAerendeID is not null
        --if previousRunConfig step failed, selects the whole set.
        )

   ,  filterAlreadyInserted as ( select
       			    recAerendeID, dnr, org
			       from IdentifierAsigned ia
				left outer join tbAehHaendelse ha --to harsh, if 1 handelse match this, it gonna match that against each handelse.
			 on ia.strRubrik = isnull(ha.strRubrik,'') --@onskadRubrik
			 AND ia.datDatum = isnull(ha.datHaendelseDatum,'') --@onskatDatum
   			 and cast(ia.recAerendeID as nvarchar) = isnull(strPublicering,'') --guarantees we won't overwrite a nongenerated handelse.
   			where ha.recHaendelseID is null -- excluding select
       ) -- this is only the filter deciding handelse generation, adding files and kontakter is upcomming.

insert into @tbAehHaendelse ( strText, strRiktning, strKommunikationssaett, recHaendelseTypID,
                             	recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID,
                             --recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,
                             strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID,
                             			recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter,recAerendeID)
select 			     strText, strRiktning, strKommunikationssaett, recHaendelseTypID,
       			     	recHaendelseKategoriID, recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID,
       				--recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,
       				strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID,
       			     			recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter,recAerendeID
from
 StandardHandelse sth, filterAlreadyInserted fai
;


insert into tbAehHaendelse
    (		datHaendelseDatum, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID,
     			recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler,
     --recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,
     				strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID,
     					recEnhetID, recFoervaltningID, strPublicering, recRemissutskickID, bolKaensligaPersonuppgifter)
    OUTPUT
           INSERTED.recHaendelseId,cast(INSERTED.strPublicering as integer) INTO @JustInserted select
           	-- Index placed in strPublicering, might not be the best place, we only need it for the output insert, so we could populate any field
                  datHaendelseDatum, strRiktning, strKommunikationssaett, recHaendelseTypID, recHaendelseKategoriID,
			recLastHaendelseStatusLogID, recLastHaendelseSekretessLogID, intAntalFiler,
                  	--recDiarieAarsSerieID, intLoepnummer, intDiarieSerieAar,
                  		strTillhoerPostlista, recKommunID, recDelprocessID, recAvdelningID,
					recEnhetID, recFoervaltningID, cast(recAerendeID as nvarchar), recRemissutskickID, bolKaensligaPersonuppgifter
    from @tbAehHaendelse tbah

select * into ##JustInserted from @JustInserted