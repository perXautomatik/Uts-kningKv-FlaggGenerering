declare @StrLogKom varchar = 'Autogenererat 07012022';
declare @dat date = getdate();
with    StandardValueAllmanHandling as (select top 1 strHaendelseStatusPresent,strHaendelseStatusLogTyp,strHaendelseStatusLocalizationCode,
             88 c, --recKommunID
             4 as recKontaktRollId
				from tbAehHaendelseData
					where strHaendelseStatusLocalizationCode is not null
						order by intRecnum desc)

   	,inputProperlyFormated       as (
 select distinct [personnr/Organisationnr] org, Dnr, Postadress, try_cast(POSTNR as nvarchar) POSTNR, POSTORT, Ägare, source,
        fastighet,recHaendelseID from ##fannyUtskick
 )

  ,     inputMatchingJustInserted   as (select StandardValueAllmanHandling.*, fu.*
				 from
				    StandardValueAllmanHandling,
				    inputProperlyFormated fu)

  ,     InputWithFnrFetchedFromVision as ( select *, isnull((select top 1 strFnrId from tbVisEnstakaFastighet where fastighet = strFastighetsbeteckning and strFnrID !='' AND strFnrID !=0),0) fnr from inputMatchingJustInserted)

update tbhd
set
	tbhd.strHaendelseStatusPresent          = ip.strHaendelseStatusPresent,
	tbhd.strHaendelseStatusLogTyp           = ip.strHaendelseStatusLogTyp,
	tbhd.strHaendelseStatusLocalizationCode = ip.strHaendelseStatusLocalizationCode,
	tbhd.datDatum                           = @dat,
	tbhd.strLogKommentar                    = @StrLogKom,
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

