
declare @InsertAehAerende table
(
	recAerendeID int identity primary key,
	recDiarieAarsSerieID int,
	intDiarienummerLoepNummer int not null,
	strDiarienummerSerie nvarchar(6) not null,
	strAerendemening nvarchar(255),
	strSoekbegrepp nvarchar(60),
	strAerendeKommentar nvarchar(max),
	recFoervaltningID int,
	recEnhetID int,
	recAvdelningID int,
	recExterntID int,
	recAerendetypID int not null,
	recProjektID int
,
	strPublicering nvarchar(30) not null,
	recLastHaendelseBeslutID int,
	datInkomDatum datetime,
	recEnstakaFakturamottagareID int
,
	datMoetesDatum datetime,
	recExternTjaenstID int,
	recKommunID int,
		unique (recDiarieAarsSerieID, strDiarienummerSerie, intDiarienummerLoepNummer)
		with (ignore_dup_key = on)
)
;
with
    filterALreadyInserted as (select fu.dnr from
         ##fannyUtskick fu
         left outer join EDPVisionRegionGotlandTest2.dbo.tbAehAerende vAA
             on isnull(vaa.intDiarienummerLoepNummer,'') = cast(right(dnr,len(dnr)-len('mbnv-2020-')) as int)
    		and vaa.recDiarieAarsSerieID =58 and strDiarienummerSerie = 'mbnv'
         where vAA.recAerendeID is null and fu.dnr is not null),
    onlyDiarieLoepNr as (select distinct try_cast(right(dnr,len(dnr)-len('mbnv-2020-')) as int) intDiarienummerLoepNummer from filterALreadyInserted)

insert into @InsertAehAerende (intDiarienummerLoepNummer, recDiarieAarsSerieID, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID)
select * from onlyDiarieLoepNr,
    (select top 1 	       recDiarieAarsSerieID, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, getdate() datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID
    from tbAehAerende where strAerendemening like '%klart%vatten%'
    --      and strDiarienummerSerie = 'MBNV'
    order by recAerendeID desc) ref

;

drop table dbo.cbrRessults
select * into dbo.cbrRessults from
        ##fannyUtskick fu
         left outer join EDPVisionRegionGotlandTest2.dbo.vwAehAerende vAA
             on isnull(vaa.strDiarienummer,'') = fu.dnr
         where vAA.recAerendeID is null and fu.dnr is not null
;


insert into  tbAehAerende (	recDiarieAarsSerieID, intDiarienummerLoepNummer, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID)
select 				recDiarieAarsSerieID, intDiarienummerLoepNummer, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID
from @InsertAehAerende
;

