
  begin try
    drop table FromRaw
end try
begin catch
    print ERROR_line()
end catch
;

with

 standardiseNull as (SELECT FASTIGHETSNYCKEL Fnr , nullif(PERSONORGANISATIONNR,'<null>')org , null ANDEL , nullif(namn,'<null>')namn ,nullif(adress,'<null>') adress,  nullif(POSTORT ,'<null>') POSTORT ,  nullif(postnummer,'<null>') POSTNR , 'OrginalLista' src from Agarlista)

 ,COLUMNPROCESSBADNESSSCORE AS (   SELECT atbc.FNR , agx.org , agx.ANDEL , agx.namn , agx.adress , agx.POSTORT ,  agx.POSTNR , agx.src
    , ((IIF(agx.namn IS NULL, 1, 0)) + (IIF(agx.postnr IS NULL, 1, 0)) + (IIF(agx.postort IS NULL, 1, 0)) + (IIF(agx.adress IS NULL, 1, 0)) + (IIF(agx.org is NULL, 1, 0))) BADNESS
	FROM standardiseNull agx inner join addressesToBeCorrected aTBC on agx.fnr = aTBC.fnr)
select * into FromRaw from COLUMNPROCESSBADNESSSCORE
;
begin try
    drop table FromUnionedNotFiltered
end try
begin catch
    print ERROR_line()
end catch
begin try
    create table FromUnionedNotFiltered
    (
	    FNR int,
	    org varchar(30),
	    ANDEL varchar(10),
	    namn nvarchar(200),
	    adress nvarchar(300),
	    POSTORT nvarchar(100),
	    POSTNR nvarchar(100),
	    src varchar(13) not null,
	    badness int,
	    trustScore int not null
	    unique clustered (FNR,org,namn,adress,POSTORT,POSTNR)
	    with (ignore_dup_key = on)
    )
end try
begin catch
    print ERROR_line()
end catch
;
use tempExcel
go
;
with unionedTofilter as ( --the higher the less trusted

    select FNR , org , ANDEL, namn , adress ,POSTORT ,  POSTNR, src,badness, 1  trustScore from addressesToBeCorrected
    union all
    select FNR , org , ANDEL, namn , adress ,POSTORT ,  POSTNR, src,badness, 2  trustScore from fromTaxeringagareNLagfart
    union all
    select FNR , org , '1/1' andel, namn , adress ,POSTORT ,  POSTNR, src,badness, 3 trustScore from FromRaw
)
insert into FromUnionedNotFiltered
   select * from unionedTofilter

;
begin try
    drop table correctAndelAndCo;
        create table correctAndelAndCo
        (
	    FNR int,
	    org varchar(30),
	    ANDEL varchar(10),
	    namn nvarchar(200),
	    adress nvarchar(300),
	    POSTORT nvarchar(100),
	    POSTNR nvarchar(100),
	    src varchar(13) not null,
	    badness int
	    unique clustered (FNR,org)
	    with (ignore_dup_key = on)
    )
end try
begin catch
    print ERROR_line()
end catch
;
with
    withFaith as (select *,rank() over (partition by fnr,org order by badness, case when badness >= 3 then badness else trustScore end,len(isnull(namn,''))+len(isnull(adress,''))+len(isnull(postort,''))+len(isnull(postnr,'')) desc ) faith from FromUnionedNotFiltered)

    ,joinWithNoBadness as (
     select FNR , org , ANDEL, namn , adress ,POSTORT ,  POSTNR, src,BADNESS from (select * from afterFirstFormating z WHERE BADNESS <= 1) o
     union all
     select FNR , org , ANDEL, namn , adress ,POSTORT ,  POSTNR, src,BADNESS from (select * from withFaith where faith = 1) q
     )

insert into correctAndelAndCo
select FNR , org , ANDEL, namn , adress ,POSTORT ,  POSTNR, src,BADNESS  from joinWithNoBadness
order by len(concat(namn,adress ,POSTORT , POSTNR)) desc
;
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end6'));

