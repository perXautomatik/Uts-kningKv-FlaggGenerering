select 1 'a' into #tempz

   SELECT
    DB_NAME(dbid) as DBName,
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName
FROM
    sys.sysprocesses
WHERE
    dbid > 0
GROUP BY
    dbid, loginame
;
SELECT * FROM tempdb..sysobjects where name like '#%'
select * from tempdb.INFORMATION_SCHEMA.TABLES