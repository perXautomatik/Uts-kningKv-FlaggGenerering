alter table ##fannyUtskick add recHaendelseID int
go

update Fu
    set Fu.recHaendelseID = tb.recHaendelseID
from  ##fannyUtskick Fu inner join
    ##justInserted tb on concat(fu.dnr,' ',try_cast(format(fu.[personnr/Organisationnr],'#############') as nvarchar)) = tb.strText
;

with StandardValueAllmanHandling as (select top 1 strHaendelseStatusPresent,strHaendelseStatusLogTyp,strHaendelseStatusLocalizationCode from tbAehHaendelseData where strHaendelseStatusLocalizationCode is not null order by intRecnum desc)

  ,inputMatchingJustInserted as (select 	StandardValueAllmanHandling.*,
       			fu.* from
		    StandardValueAllmanHandling,
		    ##fannyUtskick fu)

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

