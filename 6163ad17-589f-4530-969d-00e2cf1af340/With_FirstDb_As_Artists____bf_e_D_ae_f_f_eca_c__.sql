--with FirstDb as ('Artists 2019-05-24')
select * into [FirstDb]from [FirstDb@localhost].dbo.[Artists 2019-05-24]
;
with FirstDb as (select * from FirstDb)
select C1 as url, concat(C2,' ',C3,' ',C4)
    as name from FirstDb.dbo.[FirefoxHistoryList - 20190523.html]
