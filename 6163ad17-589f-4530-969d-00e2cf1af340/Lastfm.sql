
delete from toUnnest where toUnnest.processed is not null

;
with
    rawJson                                                                    as (select Json,"index" from main.LastFmJson)
    ,toUnNest2                                                               as
    (select rawJson.Json processed, key, value, type, atom, id, '['||rawJson."index"||']' parent, fullkey, path FROM RAWjSON, json_each(processed))

insert into toUnnest select * from toUnNest2;

drop  table lastFmRes;
create table lastFmRes
(
	name text,
	playcount text,
	artist text
);

create index "Result 5_name_index"
	on lastFmRes (name);

insert into lastFmRes
with a as (select lower(group_concat(iif(key='name',value,null))) name, group_concat(iif(key='playcount',value,null)) playcount,  group_concat(iif(key='#text',value,null)) artist
from JsonUnfold_toUnest
where (depth = 3 and (key = 'playcount' OR key = 'name'))  or (depth=4 and key = '#text')
group by iif(rightstr(trail,7)='.artist',leftstr(trail,length(trail)-7),trail))
select * from a