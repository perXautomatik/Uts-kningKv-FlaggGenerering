with top5000 as (
    SELECT top (6000) [Track_name]                               as c1
                    , [Artist_name]                              as c2
                    , ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rownum
    FROM [FirstDb].[dbo].[top 5000 2019-05-24])


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Artist_name] + ' - ' + [Track_name]
FROM [FirstDb].[dbo].[loved2019] as LoveTrack
         left join top5000 on LoveTrack.Artist_name = top5000.c2 and LoveTrack.Track_name = top5000.c1
where top5000.c2 is null
order by LoveRow desc