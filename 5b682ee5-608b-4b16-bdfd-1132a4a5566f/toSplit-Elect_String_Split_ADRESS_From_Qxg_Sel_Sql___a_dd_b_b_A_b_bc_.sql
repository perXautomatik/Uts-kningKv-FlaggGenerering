select string_split(ADRESS,',') from qxg
;-- -. . -..- - / . -. - .-. -.--
select (string_split(ADRESS,',')) from qxg
;-- -. . -..- - / . -. - .-. -.--
SELECT *  
FROM qxg
    CROSS APPLY (string_split(ADRESS,','))
;-- -. . -..- - / . -. - .-. -.--
SELECT ADRESS
FROM qxg
    CROSS APPLY (string_split(ADRESS,','))
;-- -. . -..- - / . -. - .-. -.--
SELECT col1,col2,col3
FROM qxg
    CROSS APPLY (string_split(ADRESS,','))
;-- -. . -..- - / . -. - .-. -.--
SELECT 1,2,3
FROM qxg
    CROSS APPLY (string_split(ADRESS,','))
;-- -. . -..- - / . -. - .-. -.--
SELECT 1,2,3
FROM qxg
    CROSS APPLY string_split(ADRESS,',')
;-- -. . -..- - / . -. - .-. -.--
SELECT col1,col2,ool3
FROM qxg
    CROSS APPLY string_split(ADRESS,',')
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM qxg
    CROSS APPLY string_split(ADRESS,', ')
;-- -. . -..- - / . -. - .-. -.--
SELECT *
FROM qxg
    CROSS APPLY string_split(ADRESS,',')
;-- -. . -..- - / . -. - .-. -.--
SELECT value as tag, COUNT(*) AS [Number of articles]
FROM qxg
    CROSS APPLY STRING_SPLIT(adress, ',')
GROUP BY value
HAVING COUNT(*) > 2
ORDER BY COUNT(*) DESC
;-- -. . -..- - / . -. - .-. -.--
SELECT value as tag, COUNT(1) AS [Number of articles]
FROM qxg
    CROSS APPLY STRING_SPLIT(adress, ',')
GROUP BY value
HAVING COUNT(*) > 2
ORDER BY COUNT(*) DESC
;-- -. . -..- - / . -. - .-. -.--
SELECT value as tag, COUNT(1) AS [Number of articles]
FROM qxg
    CROSS APPLY STRING_SPLIT(adress, ',')
GROUP BY value

ORDER BY COUNT(*) DESC
;-- -. . -..- - / . -. - .-. -.--
SELECT value as tag, COUNT(1) AS [Number of articles]
FROM qxg
    CROSS APPLY trim(STRING_SPLIT(adress, ','))
GROUP BY value
;-- -. . -..- - / . -. - .-. -.--
SELECT value as tag, COUNT(1) AS [Number of articles]
FROM qxg
    CROSS APPLY STRING_SPLIT(adress, ',')
GROUP BY value
;-- -. . -..- - / . -. - .-. -.--
with soki as (
SELECT value as tag, COUNT(1) AS [Number of articles]
FROM qxg
    CROSS APPLY STRING_SPLIT(adress, ',')
GROUP BY value)

select trim(tag), [Number of articles]
from soki
;-- -. . -..- - / . -. - .-. -.--
select trim(tag)
    from (SELECT value as tag, COUNT(1) AS [Number of articles]
          FROM qxg
                   CROSS APPLY STRING_SPLIT(adress, ',')
          GROUP BY value) soki
;-- -. . -..- - / . -. - .-. -.--
with asd as (select trim(tag)
    from (SELECT value as tag, COUNT(1) AS [Number of articles]
          FROM qxg
                   CROSS APPLY STRING_SPLIT(adress, ',')
          GROUP BY value) soki)

select * from asd
;-- -. . -..- - / . -. - .-. -.--
with asd as (select trim(tag) as tag
    from (SELECT value as tag, COUNT(1) AS [Number of articles]
          FROM qxg
                   CROSS APPLY STRING_SPLIT(adress, ',')
          GROUP BY value) soki)

select * from asd
;-- -. . -..- - / . -. - .-. -.--
with asd as (select trim(tag) as tag
    from (SELECT value as tag, COUNT(1) AS [Number of articles]
          FROM qxg
                   CROSS APPLY STRING_SPLIT(adress, ',')
          GROUP BY value) soki)

 select POSTORT, POSTNUMMER, (select tag from asd where tag <> POSTORT AND tag <> POSTNUMMER), NAMN, andel, BETECKNING, ärendenr
 from qxg
;-- -. . -..- - / . -. - .-. -.--
with asd as (select trim(tag) as tag
    from (SELECT value as tag, COUNT(1) AS [Number of articles]
          FROM qxg
                   CROSS APPLY STRING_SPLIT(adress, ',')
          GROUP BY value) soki)

 select POSTORT, POSTNUMMER, (select tag from asd where tag <> POSTORT AND try_cast(tag as integer) <> POSTNUMMER), NAMN, andel, BETECKNING, ärendenr
 from qxg
;-- -. . -..- - / . -. - .-. -.--
with asd as (select trim(tag) as tag
    from (SELECT value as tag, COUNT(1) AS [Number of articles]
          FROM qxg
                   CROSS APPLY STRING_SPLIT(adress, ',')
          GROUP BY value) soki)

 select POSTORT, POSTNUMMER, (select tag from asd where not(tag = POSTORT OR try_cast(tag as integer) = POSTNUMMER)), NAMN, andel, BETECKNING, ärendenr
 from qxg
;-- -. . -..- - / . -. - .-. -.--
with asd as (select trim(tag) as tag
    from (SELECT value as tag, COUNT(1) AS [Number of articles]
          FROM qxg
                   CROSS APPLY STRING_SPLIT(adress, ',')
          GROUP BY value) soki)

 select POSTORT, POSTNUMMER, (select tag from asd where not(tag = POSTORT OR tag = try_cast(POSTNUMMER as varchar))), NAMN, andel, BETECKNING, ärendenr
 from qxg
