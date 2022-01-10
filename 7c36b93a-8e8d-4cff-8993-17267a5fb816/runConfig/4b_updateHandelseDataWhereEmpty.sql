

select top 500 tbh.* from tbAehHaendelse tbh inner join tbAehHaendelseData tAAH on tbh.recHaendelseID = tAAH.recHaendelseID
order by tbh.recHaendelseID desc
;
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

update tbhd
    set
        tbhd.strHaendelseStatusPresent = qwez.strHaendelseStatusPresent,
        tbhd.strHaendelseStatusLogTyp = qwez.strHaendelseStatusLogTyp,
        tbhd.strHaendelseStatusLocalizationCode = qwez.strHaendelseStatusLocalizationCode,
	tbhd.datDatum = getdate(),
        tbhd.strLogKommentar = 'Autogenererat 07012022',
        strGatuadress = Postadress,
        strPostnummer = POSTNR,
        strPostort = POSTORT,
        strVisasSom = Ägare,
        strRoll = source,
        recKontaktRollID = qwez.recKontaktRollId,
        strFnrID = fnr,
        strFastighetsbeteckning = fastighet,
        recKommunID = c
from tbAehHaendelseData tbhd
    inner join
(select alm.*,tb.recHaendelseID,asda.* from

     (select top 1 strHaendelseStatusPresent,strHaendelseStatusLogTyp,strHaendelseStatusLocalizationCode from tbAehHaendelseData where strHaendelseStatusLocalizationCode is not null order by intRecnum desc) alm,
     ##justInserted tb inner join
(select distinct [personnr/Organisationnr] org, Dnr dnr2, Postadress, try_cast(POSTNR as nvarchar) POSTNR, POSTORT, Ägare, source, 4 recKontaktRollId,

        isnull((select top 1 strFnrId from tbVisEnstakaFastighet where fastighet = strFastighetsbeteckning and strFnrID !='' AND strFnrID !=0),0) fnr,
        fastighet,88 c from ##fannyUtskick ) asda
on concat(dnr2,' ',try_cast(format(org,'#############') as nvarchar)) = strText) qwez
on tbhd.recHaendelseID = qwez.recHaendelseID

--select * from (select strVisasSom,count(*) q,recEnstakaKontaktID from tbAehHaendelseData group by recEnstakaKontaktID,strVisasSom ) asdasd where q > 1

