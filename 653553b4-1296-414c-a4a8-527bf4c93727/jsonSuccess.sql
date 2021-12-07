-- this aproach does not accept json where child - parent share same name.

select json_extract(t.json,'$.roots.bookmark_bar.children[0].children[0].children') q,* from RAWJSON t,json_each(q)    where "index" = 2

--todo: folder name, could be derived from jsonPath

delete from indexedJsonExtract where trail is not null
;

delete from toUnnest where toUnnest.processed is not null
;
    with
    rawJson                                                                    as (select Json,"index" from main.RAWJSON)
    ,toUnNest2                                                               as
    (select rawJson.Json processed, key, value, type, atom, id, '['||rawJson."index"||']' parent, fullkey, path FROM RAWjSON, json_each(processed))
    insert into toUNnest select * from toUnNest2
;

with selection                                                                     as
(
select * from JsonUnfold_toUnest
where key = 'name' OR key = 'url'
    )
insert into indexedJsonExtract select trail,parent,key,value from selection
;

with groupedByParrent   as (select group_concat(iif(key= 'name',value,null)) name, group_concat(iif(key ='url',value,null)) url, trail jsonPath from indexedJsonExtract group by trail)
select * from	 groupedByParrent

;










