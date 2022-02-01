select * from EDPVisionRegionGotlandTest2.dbo.tbAehHaendelseData
where isnull(strLogKommentar,'') != 'Autogenererat 2022-01-31'

order by recHaendelseID desc
;
select * from tbAehHaendelseData where datDatum is null
