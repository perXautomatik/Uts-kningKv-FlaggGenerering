
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
)
insert into @InsertAehAerende (intDiarienummerLoepNummer,recDiarieAarsSerieID, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID)
;
with fu as
    (select distinct try_cast(right(dnr,len(dnr)-len('mbnv-2020-')) as int) intDiarienummerLoepNummer from ##fannyUtskick  except (select fu.* from ##fannyUtskick fu inner join EDPVisionRegionGotlandTest2.dbo.vwAehAerende vAA on vaa.strDiarienummer = fu.dnr))
select * from fu,
(select top 1 						 recDiarieAarsSerieID, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, getdate() datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID
from tbAehAerende where strAerendemening like '%klart%vatten%' and strDiarienummerSerie = 'MBNV' order by recAerendeID desc) ref

insert into  tbAehAerende (	recDiarieAarsSerieID, intDiarienummerLoepNummer, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID)
select 				recDiarieAarsSerieID, intDiarienummerLoepNummer, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID
from @InsertAehAerende

select top 1 * from tbAehAerende order by recAerendeID desc

