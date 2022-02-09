
create table ##SettingsTemp (
	ExecutionDate as date not null primary key
	,BulkLoadFromPath as nvarchar(max)
	,loadFromInternalTable as nvarchar(max)

	,preserveInitialTable as int
	,PartialPreserve_columns as nvarchar(300)

	,hasFnr as int
	,ColumnName_Fnr as nvarchar(100)

	,hasAdress as int
	,ColumnNames_Post as nvarchar(300)

	,hasDiarienr as int
	,ColumnName_Dia as nvarchar(100)

	,ExcludedRelevant as int
	,BulkLoadExcludedFromPath as nvarchar(max)

	,KorrigerandeRelevant as int
	,BulkLoadKorrigerandeFromPath as nvarchar(max)

	,FillEmptyAdressesWithFastighetsAdress as int

	,TowardsEtjanst as int


)
