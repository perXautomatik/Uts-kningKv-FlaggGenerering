
declare @tbAehHaendelseData table
(
	recHaendelseID int not null primary key,
	datDatum datetime,
	strLogKommentar nvarchar(200),
	strHaendelseStatusPresent nvarchar(20),
	strHaendelseStatusLogTyp nvarchar(20),
	strHaendelseStatusLocalizationCode nvarchar(6),
	strSekretess nvarchar(120),
	strBegraensa nvarchar(30),
	strSekretessMyndighet nvarchar(60),
	datSekretessDatum datetime,
	intUserID int,
	strSignature varchar(6),
	recEnstakaKontaktID int,
	strGatuadress nvarchar(230),
	strPostnummer nvarchar(50),
	strPostort nvarchar(40),
	strVisasSom nvarchar(224),
	recHaendelseEnstakaKontaktID int,
	strRoll nvarchar(20),
	recKontaktRollID int,
	recFastighetID int,
	strFnrID nvarchar(20),
	strFastighetsbeteckning nvarchar(56),
	recKommunID int,
	recHaendelseData int identity,
	intRecnum as [recHaendelseID],
	guidFastighetUuid uniqueidentifier
)

--insert into @tbAehHaendelseData (datDatum, strLogKommentar, strHaendelseStatusPresent, strHaendelseStatusLogTyp, strHaendelseStatusLocalizationCode, strSekretess, strBegraensa, strSekretessMyndighet, datSekretessDatum, intUserID, strSignature, recEnstakaKontaktID, strGatuadress, strPostnummer, strPostort, strVisasSom, recHaendelseEnstakaKontaktID, strRoll, recKontaktRollID, recFastighetID, strFnrID, strFastighetsbeteckning, recKommunID, guidFastighetUuid)
/*
select top 1 datDatum, strLogKommentar, strHaendelseStatusPresent, strHaendelseStatusLogTyp, strHaendelseStatusLocalizationCode, strSekretess, strBegraensa, strSekretessMyndighet, datSekretessDatum, intUserID, strSignature, recEnstakaKontaktID, strGatuadress, strPostnummer, strPostort, strVisasSom, recHaendelseEnstakaKontaktID, strRoll, recKontaktRollID, recFastighetID, strFnrID, strFastighetsbeteckning, recKommunID, guidFastighetUuid
from tbAehHaendelseData
where datDatum is not null
order by recHaendelseID desc
;

select * from
    (select top 1
	  concat(recEnstakaKontaktID,'',recHaendelseEnstakaKontaktID) idn, strGatuadress, try_cast(strPostnummer as nvarchar) strPostnummer, strPostort, strVisasSom, strRoll, recKontaktRollID, strFnrID, strFastighetsbeteckning,recKommunID
	from tbAehHaendelseData
	where datDatum is not null and strVisasSom is not null and strRoll = 'fastighetsägare') qwes
	union
	select * from
     (select distinct Dnr dnr2, Postadress, try_cast(POSTNR as nvarchar) POSTNR, POSTORT, Ägare, source, 4 recKontaktRollId,

        isnull((select top 1 strFnrId from tbVisEnstakaFastighet where fastighet = strFastighetsbeteckning and strFnrID !='' AND strFnrID !=0),0) fnr,
        fastighet,88 c from ##fannyUtskick ) asdasda*/


--updates regardless of current state, might be destructivly overwriting manual changes.
with StandardValueAllmanHandling as (select top 1 strHaendelseStatusPresent,strHaendelseStatusLogTyp,strHaendelseStatusLocalizationCode from tbAehHaendelseData where strHaendelseStatusLocalizationCode is not null order by intRecnum desc)

  ,inputMatchingJustInserted as (select 	StandardValueAllmanHandling.*,
			tb.recHaendelseID,
       			fu.* from
		    StandardValueAllmanHandling,
		    ##justInserted tb inner join
		    ##fannyUtskick fu
		on concat(dnr,' ',try_cast(format([personnr/Organisationnr],'#############') as nvarchar)) = strText)
   ,inputProperlyFormated as (
 select distinct [personnr/Organisationnr] org, Dnr dnr2, Postadress, try_cast(POSTNR as nvarchar) POSTNR, POSTORT, Ägare, source, 4 recKontaktRollId,
        fastighet,88 c from inputMatchingJustInserted
 )
  ,InputWithFnrFetchedFromVision as ( select *, isnull((select top 1 strFnrId from tbVisEnstakaFastighet where fastighet = strFastighetsbeteckning and strFnrID !='' AND strFnrID !=0),0) fnr from inputProperlyFormated)

update tbhd
    set
	tbhd.strHaendelseStatusPresent          = ip.strHaendelseStatusPresent,
	tbhd.strHaendelseStatusLogTyp           = ip.strHaendelseStatusLogTyp,
	tbhd.strHaendelseStatusLocalizationCode = ip.strHaendelseStatusLocalizationCode,
	tbhd.datDatum                           = getdate(),
	tbhd.strLogKommentar                    = 'Autogenererat 07012022',
	strGatuadress                           = Postadress,
	strPostnummer                           = POSTNR,
	strPostort                              = POSTORT,
	strVisasSom                             = Ägare,
	strRoll                                 = source,
	recKontaktRollID                        = ip.recKontaktRollId,
	strFnrID                                = fnr,
	strFastighetsbeteckning                 = fastighet,
	recKommunID                             = c
from tbAehHaendelseData tbhd
    inner join
 InputWithFnrFetchedFromVision ip
on tbhd.recHaendelseID = ip.recHaendelseID

--select * from (select strVisasSom,count(*) q,recEnstakaKontaktID from tbAehHaendelseData group by recEnstakaKontaktID,strVisasSom ) asdasd where q > 1

