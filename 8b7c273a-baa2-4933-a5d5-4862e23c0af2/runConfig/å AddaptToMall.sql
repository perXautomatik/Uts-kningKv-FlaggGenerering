use [tempExcel]
begin try


drop table tempExcel.dbo.resultat
create table resultat (
    Dnr varchar(100),
    fastighet nvarchar(200),
    [Ägare] nvarchar(300),
    Postadress nvarchar(max),
    POSTNR nvarchar(max),
    POSTORT nvarchar(max),
    [personnr/Organisationnr] nvarchar(max),
    source nvarchar(max),
    STATUSKOMMENTAR nvarchar(max),
    antal nvarchar(max)
    unique clustered (dnr,fastighet,[ägare])
    with (ignore_dup_key = ON)
);

--o	Vilande – Gem. Anläggning
--o	Vilande – kommunal anslutning
--o	Väntande – uppskov
--o	Väntande – överklangande


--Excelfilen ska ha kolumnerna
          -- dia        Fastighet          Ägare                 Postadress       Postnr                Postort              Personnr          Organisationsnr statuskommentar
end try
begin catch
end catch
;
with
    joinFirAndInitial as ( SELECT
       	   ti.dia Dnr,
           kir.beteckning  fastighet,
           isnull(fa.NAMN,'') [Ägare],
           isnull(fa.ADRESS,'') Postadress,
           isnull(fa.POSTNR,'') POSTNR,
           isnull(POSTORT,'') POSTORT,
           isnull(replace(fa.org,'-',''),'') [personnr/Organisationnr],
           isnull(fa.SOURCE,'') source,
           isnull(ti.STATUSKOMMENTAR,'') STATUSKOMMENTAR
    from FromJoinWithCorrection fa

        LEFT OUTER JOIN toInsert ti on fa.FNR = ti.FNR
	INNER join KirFnr kir
	    ON coalesce(fa.FNR, ti.FNR) = kir.fnr)

    ,withAntal as (select *,concat(
				    rank() OVER (PARTITION BY dnr order by dnr)
				    ,'/',count([personnr/Organisationnr]) over (PARTITION BY dnr)
				    )  Antal

		from  joinFirAndInitial)

insert into resultat
select * from withAntal

	;