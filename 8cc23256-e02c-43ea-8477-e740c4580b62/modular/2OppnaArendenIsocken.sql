
declare @beteckningsColumnsDefenition as NVARCHAR(max)
    set @beteckningsColumnsDefenition = '(IIF(
							 strFnrID is null AND strSoekbegrepp <> strFastighetsbeteckning,
							 case when strFastighetsbeteckning is null then strSoekbegrepp
							      when strSoekbegrepp is null
												   then strFastighetsbeteckning
							      when strSoekbegrepp like concat(''%'', strFastighetsbeteckning, ''%'')
												   then strSoekbegrepp
												   else concat(strSoekbegrepp, '' // '', strFastighetsbeteckning)
							 end, strFastighetsbeteckning)) as  beteckning '


declare @arenden table
(
	socken varchar(max), recAerendeID int, strDiarienummerSerie nvarchar(6), intDiarienummerLoepNummer int, strDiarienummer nvarchar(18), strAerendemening nvarchar(255), strSoekbegrepp nvarchar(60), strAerendeKommentar nvarchar(max), recFoervaltningID int, recEnhetID int, recAvdelningID int, recExterntID int, recDiarieAarsSerieID int, strPublicering nvarchar(30), bolKaensligaPersonuppgifter bit, recLastAerendeStatusLogID int, intRecnum int, strFastighetsbeteckning nvarchar(56), strFnrID varchar(20), guidFastighetUuid uniqueidentifier, recFastighetID int, datInkomDatum datetime, datDatum datetime, strLogKommentar nvarchar(200), strAerendeStatusPresent nvarchar(20), strLocalizationCode nvarchar(6), strSignature varchar(6), strUserVisasSom nvarchar(201), intUserID int, recDiarieSerieID int, intDiarieAar smallint, intSerieStartVaerde int, strDiarieSerieKod nvarchar(6), strSekretess nvarchar(120), strBegraensa nvarchar(30), strSekretessMyndighet nvarchar(60), datSekretessDatum datetime, recProjektID int, recEnstakaKontaktID int, strVisasSom nvarchar(224), strGatuadress nvarchar(230), strPostnummer nvarchar(50), strPostort nvarchar(40), strRoll nvarchar(20), recKontaktRollID int, recAerendeEnstakaKontaktID int, recEnstakaFakturamottagareID int, recKommunID int, strProjektNamn nvarchar(50), datBeslutsDatum datetime, strBeslutsNummer nvarchar(30), strBeslutsutfall nvarchar(100), recHaendelseID int, recHaendelseBeslutID int, strAerendeTyp nvarchar(50), strAerendekategori nvarchar(30), strAerendetypKod nvarchar(20), recAerendetypID int, bolKomplettAerende bit, strEnhetNamn nvarchar(50), strEnhetKod nvarchar(6), strFoervaltningNamn nvarchar(50), strFoervaltningKod nvarchar(6), strAvdelningKod nvarchar(10), strAvdelningNamn nvarchar(50), strFakturamottagare nvarchar(224), strKommunNamn nvarchar(60), datKomplett datetime, datMoetesDatum datetime, intArbetsdagar int, strSummaTidposter varchar(33), recExternTjaenstID int, strExternTjaenst nvarchar(100), strETjaenstNamn nvarchar(100), datBeslutExpedierat datetime, datGallrat datetime, datArkiverat datetime, beteckning nvarchar(120)
);
declare @query as NVARCHAR(max)
set @query = 'select distinct s.namn socken, a.* from (select a.*,'+@beteckningsColumnsDefenition+' from EDPVisionRegionGotland.dbo.vwAehAerende a
    left outer join #badStatus b on b.namn = a.strAerendeStatusPresent
    inner join #Strangar st on st.namn = a.strAerendemening OR st.namn = a.strAvdelningKod OR st.namn = a.strEnhetKod OR st.namn = a.strEnhetNamn OR st.namn = a.strProjektNamn
        where b.namn is null
        ) a
    inner join #sockNarOFIntresse s on a.beteckning like s.namn + ''%'''
insert into @arenden
	exec (@query)

