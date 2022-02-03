select top 1000 * from EDPVisionRegionGotlandTest2.dbo.tbAehAerendeData order by %%physloc%% desc,recAerendeID desc

select * from tbAehAerende left outer join tbAehAerendeData tAAD on tbAehAerende.recAerendeID = tAAD.recAerendeID
where tAAD.recLastAerendeStatusLogID is null