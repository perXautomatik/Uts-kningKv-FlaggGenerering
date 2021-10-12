-- this aproach does not accept json where child - parent share same name.

--select json_extract(t.json,'$.roots.custom_root') q,* from RAWJSON t where "index" = 1
--   ,json_each(q)
--todo: folder name, could be derived from jsonPath

delete from indexedJsonExtract where trail is not null
;

    with
    rawJson                                                                    as (select Json,"index" from main.RAWJSON)
    ,toUnNest                                                               as
    (select rawJson.Json processed, key, value, type, atom, id, '['||rawJson."index"||']' parent, fullkey, path FROM RAWjSON, json_each(processed))

, cte (processed, trail, key, value, type, atom, id, parent, fullkey, path) as (
	select processed, (coalesce(parent,iPar)) trail, key, value, type, atom, id, coalesce(parent,iPar) , fullkey, path
	from (
	    select processed, parent as iPar,
		key, value, type, atom, id, parent, fullkey, path
	    from toUnNest where atom is not null
	    union
	    select i.processed, i.parent || i.key
		 , js.*  from toUnNest i
			    , json_each(i.value) js
	    where  i.atom is null
	)
	union
	    select value, trail || '.' || key , KEY, value, type, atom, id, trail, fullkey, path from cte
		where atom is not null and not (trail like '%' || key)

		union

		select c1.value, c1.trail || '.' || c1.key ,  c2.KEY, c2.value, c2.type, c2.atom, c2.id, c1.trail, c2.fullkey, c2.path
		from cte c1, json_each(c1.value) c2
		where c1.atom is null
   )


,selection                                                                     as
(
    select *
from cte
where key = 'name' OR key = 'url'
    )
insert into indexedJsonExtract select trail,parent,key,value from selection
;

with groupedByParrent   as (select group_concat(iif(key= 'name',value,null)) name, group_concat(iif(key ='url',value,null)) url, parent jsonPath from indexedJsonExtract group by Parent)select * from	 groupedByParrent

;










