declare @HandelserFromperiod as NVARCHAR(max)
declare @rubRikerOfInterest as  NVARCHAR(max)

set @rubRikerOfInterest = char(39) + N'Klart vatten - information om avlopp' + char(39) + ',' + char(39) +
			  N'Påminnelse om åtgärd - 12 månader' +
			  char(39) + ',' + char(39) + N'Påminnelse om åtgärd-36 mån' + char(39) + ',' + char(39) +
			  N'Påminnelse om åtgärd - 24 månader' +
			  char(39) + ',' + char(39) + N'Påminnelse om åtgärd - 4 år' + char(39) + ',' + char(39) +
			  'Klart vatten information om avlopp' + char(39)

set @HandelserFromperiod = ' inner join (
            select h.recAerendeID,strRubrik,datHaendelseDatum,intAntalFiler from EDPVisionRegionGotland.dbo.vwAehHaendelse h
              inner join #Strangar st on st.namn = h.strAerendemening OR st.namn = h.strAvdelningKod OR st.namn = h.strEnhetKod OR st.namn = h.strEnhetNamn
              where datHaendelseDatum > datetimefromparts(2019,01,01,01,01,01,01)) H on h.recAerendeID = a.recAerendeID ' +
			   'and
		   strRubrik in(' + @rubRikerOfInterest + ')'


declare @query as NVARCHAR(max)
set @query = 'select distinct A.beteckning socken, h.strRubrik,h.datHaendelseDatum,h.intAntalFiler from (select a.*,'+@beteckningsColumnsDefenition+' from EDPVisionRegionGotland.dbo.vwAehAerende a
    inner join #Strangar st on st.namn = a.strAerendemening OR st.namn = a.strAvdelningKod OR st.namn = a.strEnhetKod OR st.namn = a.strEnhetNamn OR st.namn = a.strProjektNamn
	) a ' + @HandelserFromperiod