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
