
delete from main.toUnnest where toUnnest.processed is not null

;
    with
    rawJson                                                                    as (select Json, (playlist || [to]) "index" from main.SpotifyReply)
    ,toUnNest2                                                               as
    (select rawJson.Json processed, key, value, type, atom, id, '['||rawJson."index"||']' parent, fullkey, path FROM RAWjSON, json_each(processed))

insert into main.toUnnest select * from toUnNest2;

create table spotifyRes
(
	name text,
	href text,
	constraint "spotifyRes_name_href_pk"
		primary key (name, href)
);

create index "spotifyRes_name_index"
	on spotifyRes (name);



insert into spotifyRes
with a as (select lower(group_concat(iif(key='name',value,null))) name, group_concat(iif(key='href',value,null)) href
from JsonUnfold_toUnest
where depth = 4 and (key='name' OR key = 'href') and rightstr(trail,5) <> 'album'
group by leftstr(trail,length(trail)-7))
select * from a
