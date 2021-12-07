
SELECT json_object('ex',json(JSON) )FROM RAWjSON; --<-- add exe as a outer json property

with
	noChange as (SELECT json_extract(json(JSON),'$') z FROM RAWjSON)
    ,fetchItems as (select json_extract(z,'$.items') q from noChange)

select json_extract(z , '$.items[2].track.name') name,json_extract(z , '$.items[2].track.href') href from noChange; --< second entry


SELECT *
  FROM (SELECT json_extract(json(JSON),'$.items') z FROM RAWjSON), json_each(z); --< returns all objects inside items;


with qTret as (SELECT *
  FROM (SELECT json_extract(json(JSON),'$.items') z FROM RAWjSON), json_each(z))

select json_extract(value , '$.track.name') name,json_extract(value , '$.track.href') href from  qTret





; --<-- feteches items





