with qTret as (SELECT *
  FROM (SELECT json_extract(json(JSON),'$.items') z FROM RAWjSON), json_each(z)),
ress as (select json_extract(value , '$.track.name') title,json_extract(value , '$.track.href') href from  qTret)
,overridingArtistGenre as (select '' artist,'' genre )
,joinedWithsource as (select href, Sel, Title, artist, iif("top genre"='','-',"top genre") genre, year, added, bpm, nrgy, dnce, db, live, val, dur, acous, spch, pop, src
		      from ress inner join OrganizeYourMusic2 using (title))

,artistsWithGenre as (select group_concat(distinct genre) genre,artist,count(*) c from joinedWithsource group by artist)

,genresWithartists as (select genre,group_concat(artist) artist, sum(c) c from artistsWithGenre group by genre order by c desc)
, atmoGenre as (
    select "atmospheric black metal" as q
    union
    select "depressive black metal"
    union
    select "german black metal"
    union
    select "blackgaze"
    union
    select "alternative metal"
    union select "doom metal"
    )


, atmoGenreBlob as (
select * from joinedWithsource
 where joinedWithsource.genre in
atmoGenre)


--select * from genresWithartists where genre not in atmoGenre
,averageSounds as ( select * from (select genre
					, sum(pop)   spop
					, avg(bpm)   abpm
					, avg(nrgy)  anrgy
					, avg(dnce)  adance
					, avg(db)    adb
					, avg(live)  alive
					, avg(val)   aval
					, avg(dur)   adur
					, avg(acous) acous
					, avg(spch)  aspch

     from genresWithartists inner join joinedWithsource using (genre) group by genre)
inner join genresWithartists using (genre))

,pop as ( select * from averageSounds order by spop desc limit 1)

select
      az.genre, round((az.abpm/pop.abpm) * 100) pBpm,
       round((az.acous/pop.acous) * 100) pacous,
       round((az.adance/pop.adance) * 100) pdance,
       round((az.adb/pop.adb) * 100) pDb
       ,round((az.alive/pop.alive) * 100) plive
       ,round((az.anrgy/pop.anrgy) * 100) pnrgy
	,round((az.aspch/pop.aspch) * 100) pSpch
	,round((az.adur/pop.adur) * 100) pDur
	,round((az.aval/pop.aval) * 100) pVal
	from averageSounds az cross join pop


