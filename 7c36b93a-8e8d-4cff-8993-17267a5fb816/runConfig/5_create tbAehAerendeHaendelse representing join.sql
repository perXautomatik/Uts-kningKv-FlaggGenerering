
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
with
         Insertable as (select * from ##fannyUtskick where recHaendelseID is not null and recAerendeID is not null)
	 ,filterAlreadyInserted as (select insertable.* from insertable left outer join tbAehAerendeHaendelse on (recAerendeID,recHaendelseID))

;
with
   tbAehAerendeHaendelseReferens as (select tbah.*,tbAehAerendeHaendelseReferens.strRubrik from tbAehAerendeHaendelse tbah
			    inner join tbAehHaendelse qw
				on tbah.recHaendelseID = tbAehAerendeHaendelseReferens.recHaendelseID
					  where strRubrik = @onskadRubrik)

   ,filterAlreadyInserted         as (
	select distinct ArendenInUtskick.recAerendeID,recHaendelseID,dnr, org  from
	 ArendenInUtskick
		left outer join
		     tbAehAerendeHaendelseReferens

			on ArendenInUtskick.recAerendeID = tbAehAerendeHaendelseReferens.recAerendeID
 		   		where  tbAehAerendeHaendelseReferens.strRubrik is null)
