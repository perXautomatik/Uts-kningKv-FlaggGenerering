.read Last.fm.sql;


select * from FirstDb.dbo.[Artist list 2]
    full outer join FirstDb.dbo.artitsList on FirstDb.dbo.[Artist list 2].Artist = FirstDb.dbo.artitsList.Name
where FirstDb.dbo.[Artist list 2].Artist is null