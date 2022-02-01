declare @strLogKommentar varchar = 'Autogenererade070122';
declare @AerendeData table
(
	recAerendeID int not null
		primary key,
	intDiarieAar smallint,
	intSerieStartVaerde int,
	recDiarieSerieID int,
	strDiarieSerieKod nvarchar(6),
	strDiarienummer nvarchar(18),
	recLastAerendeStatusLogID int,
	datDatum datetime,
	strLocalizationCode nvarchar(6),
	strAerendeStatusPresent nvarchar(20),
	strLogKommentar nvarchar(200),
	datKomplett datetime,
	recLastAerendeSekretessLogID int,
	strSekretess nvarchar(120),
	strBegraensa nvarchar(30),
	strSekretessMyndighet nvarchar(60),
	datSekretessDatum datetime,
	intUserID int,
	strSignature varchar(6),
	recFastighetID int,
	strFnrID varchar(20),
	strFastighetsbeteckning nvarchar(56),
	recAerendeEnstakaKontaktID int,
	strRoll nvarchar(20),
	recEnstakaKontaktID int,
	strVisasSom nvarchar(224),
	strGatuadress nvarchar(230),
	strPostnummer nvarchar(50),
	strPostort nvarchar(40),
	recKontaktRollID int,
	intRecnum as [recAerendeID],
	guidFastighetUuid uniqueidentifier
)
;
with
    refArende as (select top 1 intDiarieAar, intSerieStartVaerde, recDiarieSerieID, strDiarieSerieKod, strDiarienummer, recLastAerendeStatusLogID, getdate() datDatum, strLocalizationCode, strAerendeStatusPresent, strLogKommentar, datKomplett, recLastAerendeSekretessLogID, strSekretess, strBegraensa, strSekretessMyndighet, datSekretessDatum, intUserID, strSignature, recFastighetID, strFnrID, strFastighetsbeteckning, recAerendeEnstakaKontaktID, strRoll, recEnstakaKontaktID, strVisasSom, strGatuadress, strPostnummer, strPostort, recKontaktRollID, guidFastighetUuid
	    from tbAehAerendeData where recLastAerendeStatusLogID is not null and intUserID is null order by recAerendeID desc)
    ,alreadyINserted as (select distinct vAA.recAerendeID,recLastAerendeStatusLogID from ##fannyUtskick fu
	    left outer join EDPVisionRegionGotlandTest2.dbo.vwAehAerende vAA on vaa.strDiarienummer = fu.dnr)
    ,filteredArendeId as (select recAerendeId from alreadyINserted where recLastAerendeStatusLogID is null and recAerendeID is not null)

insert into @AerendeData (recAerendeID, intDiarieAar, intSerieStartVaerde, recDiarieSerieID, strDiarieSerieKod, strDiarienummer, recLastAerendeStatusLogID, datDatum, strLocalizationCode, strAerendeStatusPresent, strLogKommentar, datKomplett, recLastAerendeSekretessLogID, strSekretess, strBegraensa, strSekretessMyndighet, datSekretessDatum, intUserID, strSignature, recFastighetID, strFnrID, strFastighetsbeteckning, recAerendeEnstakaKontaktID, strRoll, recEnstakaKontaktID, strVisasSom, strGatuadress, strPostnummer, strPostort, recKontaktRollID, guidFastighetUuid)
		    select filteredArendeId.recAerendeID, intDiarieAar, intSerieStartVaerde, recDiarieSerieID, strDiarieSerieKod, strDiarienummer, recLastAerendeStatusLogID, datDatum, strLocalizationCode, strAerendeStatusPresent, strLogKommentar, datKomplett, recLastAerendeSekretessLogID, strSekretess, strBegraensa, strSekretessMyndighet, datSekretessDatum, intUserID, strSignature, recFastighetID, strFnrID, strFastighetsbeteckning, recAerendeEnstakaKontaktID, strRoll, recEnstakaKontaktID, strVisasSom, strGatuadress, strPostnummer, strPostort, recKontaktRollID, guidFastighetUuid
    from refArende, filteredArendeId


UPDATE tbhAd
SET
    tbhAd.recLastAerendeStatusLogID = addr.recLastAerendeStatusLogID,
    tbhAd.datDatum = addr.datDatum,
    tbhAd.strLocalizationCode = addr.strLocalizationCode,
    tbhAd.strAerendeStatusPresent = addr.strAerendeStatusPresent,
    tbhAd.strLogKommentar = @strLogKommentar
FROM tbAehAerendeData tbhAd
INNER JOIN
(select recAerendeID, recLastAerendeStatusLogID, datDatum, strLocalizationCode, strAerendeStatusPresent from @AerendeData) Addr
ON Addr.recAerendeID = tbhAd.recAerendeID


drop table dbo.cbrRessults
select recAerendeID into dbo.cbrRessults from ##fannyUtskick fu