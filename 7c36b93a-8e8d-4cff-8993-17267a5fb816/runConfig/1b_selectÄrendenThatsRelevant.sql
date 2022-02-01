
declare @datInkomDatum date = getdate();
declare @strAerendeMeningLike varchar(max) = '%klart%vatten%';

declare @InsertAehAerende table
(
	recDiarieAarsSerieID int --not null
	,
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
--drop table dbo.cbrRessults select * into dbo.cbrRessults from ##fannyUtskick fu left outer join (select  recDiarieAarsSerieID,intDiarieAar from dbo.tbAehDiarieAarsSerie) diaS on cast(substring(dnr,charindex('-',dnr)+1, @arLenght) as integer) = dias.intDiarieAar
;

with
    filterALreadyInserted as (select fu.dnr,coalesce(vaa.intDiarienummerLoepNummer,fu.intDiarienummerLoepNummer) intDiarienummerLoepNummer,
           coalesce(dias.recDiarieAarsSerieID,fu.intDiarieAar) recDiarieAarsSerieID,coalesce(vaa.strDiarienummerSerie,fu.strDiarienummerSerie) strDiarienummerSerie from

        (select dnr,
               intDiarienummerLoepNummer,
               intDiarieAar
              , strDiarienummerSerie
        from
         ##fannyUtskick) fu
                left outer join (select  recDiarieAarsSerieID,intDiarieAar from dbo.tbAehDiarieAarsSerie) diaS
                    on fu.intDiarieAar = dias.intDiarieAar
         left outer join dbo.tbAehAerende vAA
             on isnull(vaa.intDiarienummerLoepNummer,'') = fu.intDiarienummerLoepNummer
    		and vaa.recDiarieAarsSerieID = dias.recDiarieAarsSerieID
                and vaa.strDiarienummerSerie = fu.strDiarienummerSerie
         where vAA.recAerendeID is null and fu.dnr is not null)
   ,
    onlyDnr as (select distinct * from filterALreadyInserted)
,   RefArende as (select top 1 	       strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, @datInkomDatum datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID
    from tbAehAerende where strAerendemening like @strAerendeMeningLike
    --      and strDiarienummerSerie = 'MBNV'
    order by recAerendeID desc)
insert into @InsertAehAerende (intDiarienummerLoepNummer, recDiarieAarsSerieID, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID)
select 				intDiarienummerLoepNummer, onlyDnr.recDiarieAarsSerieID, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID
from onlyDnr,
     RefArende

;

--drop table dbo.cbrRessult; select * into dbo.cbrRessult from @InsertAehAerende


insert into  tbAehAerende (	recDiarieAarsSerieID, intDiarienummerLoepNummer, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID)select 				recDiarieAarsSerieID, intDiarienummerLoepNummer, strDiarienummerSerie, strAerendemening, strSoekbegrepp, strAerendeKommentar, recFoervaltningID, recEnhetID, recAvdelningID, recExterntID, recAerendetypID, recProjektID, strPublicering, recLastHaendelseBeslutID, datInkomDatum, datMoetesDatum, recExternTjaenstID, recKommunID from @InsertAehAerende
;

