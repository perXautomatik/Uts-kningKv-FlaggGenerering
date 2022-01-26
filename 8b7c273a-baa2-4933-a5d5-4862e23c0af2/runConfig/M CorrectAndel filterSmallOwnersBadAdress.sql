--SELECT * TOP 3 ANDEL unless noone owns more than 25 then add all
begin try
    drop table FromcorrecAndelCo
end try
begin catch
    print ERROR_line()
end catch

declare @convertion table (FNR         int, org         varchar(30), ANDEL       varchar(10), namn        nvarchar(200), adress      nvarchar(300), POSTORT     nvarchar(100), POSTNR      nvarchar(100), src         varchar(13) not null, badness     smallint, slashPos    smallint, nominator   varchar(3), denominator varchar(3))
;
with
    preFardig    as (select *, charindex('/', ANDEL) slashPos from correctAndelAndCo)
  , preprefardig as (select *, left(ANDEL, slashPos - 1) nominator, right(ANDEL, len(ANDEL) - slashPos) denominator
		     from preFardig)

insert
into @Convertion (FNR, org, ANDEL, namn, adress, POSTORT, POSTNR, src, badness, nominator, denominator,slashPos)

select FNR
     , org
     , ANDEL
     , namn
     , adress
     , POSTORT
     , POSTNR
     , src
     , badness
     , nominator
     , denominator,slashPos
from preprefardig;

--; select * into Convertion from @convertion;

with
    --atleast one from each, but no max amount, badness always first, and second to that, largest ägare
    --rank1 should be lowestB.HighestAndel, if there is more than 1 with same lowb and high andel, all is selected.
    FARDIG
	 AS (SELECT FNR, org
		  , format(try_cast(IIF(slashPos > 0, try_cast(nominator AS float) / try_cast(denominator AS float), 0) AS FLOAT), '0.00')                   ANDEL
		  , NAMN, ADRESS, POSTORT, POSTNR, SRC SOURCE, badness
	     FROM @Convertion)

  , checkUneeded as (select *, rank() over (partition by fnr order by badness,andel desc ) rankNum from FARDIG)
  , leCrem       as (select *, row_number() over (partition by fnr order by fnr desc ) rowNum from checkUneeded)

   --,leCremLimited as (select * from leCrem where rowNum <= Andel/1) --select no more than the number of total ägare.

   --,filterBadAdress as (select * from (select * from checkUneeded where FNR not in lecrem )Or (RowNum < 4 AND ANDEL >= 0.25 And badness < 2))

select * into Convertion from lecrem;

SELECT *
into FromcorrecAndelCo
from Convertion WHERE rankNum = 1

insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar), 'endCorrect'));

