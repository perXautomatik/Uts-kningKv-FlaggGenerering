-- select * �ppna och st�ngda �renden
-- 	uppr�ttade inte tidagare �n x
-- 	fr�n de vanliga enhterna
-- 	med �rendetitlen kv
--
-- select h�ndelser
--
--     gruppera per socken, och h�ndelsenamn och summera antalet
--
-- d�r



/*
	,OrderedRubrix as (select
case
    when strAerendemening =
   N'Klart vatten - information om avlopp' then @a
        when strAerendemening =
   N'P�minnelse om �tg�rd - 12 m�nader'  then @b
            when strAerendemening =
   N'P�minnelse om �tg�rd - 24 m�nader' then @c
                    when strAerendemening =
                         N'P�minnelse om �tg�rd-36 m�n' then @d
                when strAerendemening =
   N'P�minnelse om �tg�rd - 4 �r' then @e
    end rubrik
     , socken,

       c,year, month
from grouped
    )







,periodized as (
   select
          concat(year,'-',
     case
	  when year = 2019 and month in (2,3) AND rubrik = @a
       then 9
            when year = 2019 and month in (4,5) AND rubrik = @a
       then 4
	  when year = 2019 and month between 8 and 12 AND rubrik = @a
       then 9
	  when year = 2020 and month in (2,4,5,6,7,8,10,12) AND rubrik = @a
       then 7
	  when year = 2020 and month in (4,12,5,9) AND rubrik = @b
       then 7
	  when year = 2020 and month in (11,10) AND rubrik = @d
       then 7
	  when year = 2021 and month in(2,3,4,5,7,6,9)  AND rubrik = @a
       then 6
          when year = 2021 and month in(10,4)  AND rubrik = @c
       then 6
	  else
           CHAR(96+month),month
       --end
              ,'-',rubrik
              )
           period
       ,
          socken,c from OrderedRubrix
)
      SELECT distinct
  period,
  STUFF((
    SELECT distinct ' ,' + q.socken
    FROM periodized q
    WHERE (period = Results.period)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS Socknar,sum(c) summa
FROM periodized Results
GROUP BY period*/