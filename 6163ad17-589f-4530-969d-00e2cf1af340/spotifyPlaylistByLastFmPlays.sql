with 


spotifyRes2 as (select iif(instr(name,' - ') > 0,replace(name,' - ',' (') || ')',name ) name, href
		from spotifyRes)
,lastFmRes2 as (select iif(instr(name,' - ') > 0,replace(name,' - ',' (') || ')',name ) name, playcount, artist
		from lastFmRes)


,Ressult as (select replace(href,'https://api.spotify.com/v1/tracks/','https://open.spotify.com/track/')href,name,sum(playcount)c,group_concat(artist) artist
 from    (select href, name, playcount, artist
	  from spotifyRes2 left join lastFmRes2 using (name)
union
     select href, name, playcount, artist
	  from lastFmRes2 left join spotifyRes2 using (name)
)
		group by name,href order by iif(href is not null AND c is not null, c, href))

select group_concat(name) names, sum(c) c, artist
from Ressult where href is null group by artist order by c desc