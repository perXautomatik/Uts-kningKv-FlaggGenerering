--handles even incomplete searchterms as long as socken is complete
declare @searchstring nvarchar(50); set @searchstring = 'FARDHEM GARDARVE 1:8'

declare @fastighetsBlock nvarchar(50);
declare @withoutSocken nvarchar(50);
declare @searchSocken nvarchar(50);
declare @searchFastighetsNr nvarchar(50);
declare @halfWithoutSocken nvarchar(50);

set @searchSocken = left(@searchstring,charindex(' ',@searchstring,0))
set @withoutSocken = RIGHT(@searchstring,LEN(@searchstring)-LEN(@searchSocken)-1)
set @fastighetsBlock = left(@withoutSocken,charindex(' ',@searchstring,len(@searchSocken)))
-- Statement : is always on second half of string
set @halfWithoutSocken = right(@withoutSocken,len(@withoutSocken)/2)
set @searchFastighetsNr = RIGHT(@halfWithoutSocken,LEN(@halfWithoutSocken)-charindex(' ',@halfWithoutSocken))


;
with enskiltUnion as (
    select OBJECTID, Diarienummer, Fastighet_tillstand, Typ_byggnad, Antal_hushall_tillstand, Fastighet_rening, Typ_slamavskiljare, Storlek_m3, Typ_rening, Storlek_m2, Typ_sluten_tank, Storlek_m, Beslut_datum, Utford_datum, Avgift, Tillstand_giltigt_tom, Anteckning
	    from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_NORRA_P union
    select OBJECTID, Diarienummer, Fastighet_tilstand, Typ_byggnad, Antal_hushall_tillstand, Fastighet_rening, Typ_slamavskiljare, Storlek_m3, Typ_rening, Storlek_m2, Typ_sluten_tank, Storlek_m, Beslut_datum, Utford_datum, Avgift, Tillstand_giltigt_tom, Anteckning
    	    from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_mellersta_P union
    select OBJECTID, Diarienummer, Fastighet_tillstand, Typ_byggnad, Antal_hushall_tillstand, Fastighet_rening, Typ_slamavskiljare, Storlek_m3, Typ_rening, Storlek_m2, Typ_sluten_tank, Storlek_m, Beslut_datum, Utford_datum, Avgift, Tillstand_giltigt_tom, Anteckning
    	    from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_SODRA_P)


,    reningarUNion      as (
	select OBJECTID, Fastighet_rening, Antal_hushall_rening, reningstyp, Storlek_m2, Beslut_datum, Utford_datum, Kommentarer, Anslutna_fastigheter_1, Anslutna_fastigheter_2, Anslutna_fastigheter_3, Anslutna_fastigheter_4, Anslutna_fastigheter_5, Anslutna_fastigheter_6, Anslutna_fastigheter_7, Anslutna_fastigheter_8, Anslutna_fastigheter_9, Anslutna_fastigheter_10
		from sde_miljo_halsoskydd.gng.RENING_MELLERSTA_P union
	select OBJECTID, Fastighet_rening, Antal_hushall_rening, reningstyp, Storlek_m2, Beslut_datum, Utford_datum, Kommentarer, Anslutna_fastigheter_1, Anslutna_fastigheter_2, Anslutna_fastigheter_3, Anslutna_fastigheter_4, Anslutna_fastigheter_5, Anslutna_fastigheter_6, Anslutna_fastigheter_7, Anslutna_fastigheter_8, Anslutna_fastigheter_9, Anslutna_fastigheter_10
		from sde_miljo_halsoskydd.gng.RENING_NORRA_P union
	select OBJECTID, Fastighet_rening, Antal_hushall_rening, reningstyp, Storlek_m2, Beslut_datum, Utford_datum, Kommentarer, Anslutna_fastigheter_1, Anslutna_fastigheter_2, Anslutna_fastigheter_3, Anslutna_fastigheter_4, Anslutna_fastigheter_5, Anslutna_fastigheter_6, Anslutna_fastigheter_7, Anslutna_fastigheter_8, Anslutna_fastigheter_9, Anslutna_fastigheter_10
		from sde_miljo_halsoskydd.gng.RENING_SODRA_P)

,    enskiltSokterm     as (select *, concat(Fastighet_rening,Fastighet_tillstand,Anteckning) q from enskiltUnion)
,    reningSokterm	as (select *,concat(Fastighet_rening, Anslutna_fastigheter_1, Anslutna_fastigheter_2, Anslutna_fastigheter_3,
    				Anslutna_fastigheter_4, Anslutna_fastigheter_5, Anslutna_fastigheter_6, Anslutna_fastigheter_7, Anslutna_fastigheter_8,
    				Anslutna_fastigheter_9, Anslutna_fastigheter_10) q from reningarUNion)
,    flaggSearchTerm    as ( select *, concat(Fastighet_tillstand,FASTIGHET) q from sde_miljo_halsoskydd.gng.FLAGGSKIKTET_P)

,    SearchFlagg        as (select OBJECTID, FASTIGHET, Fastighet_tillstand, Arendenummer, Beslut_datum, Status, Utskick_datum, Anteckning, Utforddatum, Slamhamtning, Antal_byggnader, alltidsant, Shape, GDB_GEOMATTR_DATA, skapad_datum, andrad_datum, q
			    from flaggSearchTerm where
		      q like concat(@searchSocken,'%')
			and
		      q like  concat('%',@fastighetsBlock,'%')
			and
		      q like  concat('%',@searchFastighetsNr,'%'))

,    SearchEnskilt      as (select OBJECTID, Diarienummer, Fastighet_tillstand, Typ_byggnad, Antal_hushall_tillstand, Fastighet_rening, Typ_slamavskiljare, Storlek_m3, Typ_rening, Storlek_m2, Typ_sluten_tank, Storlek_m, Beslut_datum, Utford_datum, Avgift, Tillstand_giltigt_tom, Anteckning, q
		from enskiltSokterm
		where q like concat(@searchSocken,'%')
			and
		      q like  concat('%',@fastighetsBlock,'%')
			and
		      q like  concat('%',@searchFastighetsNr,'%'))

,    searchRening as (select OBJECTID, Fastighet_rening, Antal_hushall_rening, reningstyp, Storlek_m2, Beslut_datum, Utford_datum, Kommentarer, Anslutna_fastigheter_1, Anslutna_fastigheter_2, Anslutna_fastigheter_3, Anslutna_fastigheter_4, Anslutna_fastigheter_5, Anslutna_fastigheter_6, Anslutna_fastigheter_7, Anslutna_fastigheter_8, Anslutna_fastigheter_9, Anslutna_fastigheter_10, q
		from reningSokterm
		where q like concat(@searchSocken,'%')
		      and
		      q like  concat('%',@fastighetsBlock,'%')
		      and
		      q like  concat('%',@searchFastighetsNr,'%'))

,    unionReningFLaggEnskilt as (
    select 'flagg' typ,	OBJECTID, 	     FASTIGHET, 	Fastighet_tillstand, Arendenummer, 	Status,			concat(try_cast(Utskick_datum as date),'') Utskick_datum,						'' m2M3,													Slamhamtning,						concat(try_cast(Beslut_datum as date),'') Beslut_datum,	concat(try_cast(utforddatum as date),'') utforddatum, 	concat(try_cast(Antal_byggnader as int),'')   byggnader	,concat(Anteckning, q) other
	    from SearchFlagg union
    select 'enskilt' typ,	OBJECTID,    Fastighet_rening, 	Fastighet_tillstand, Diarienummer, 	Typ_byggnad,		concat(try_cast(Tillstand_giltigt_tom as date),'')  ,							concat(try_cast(Storlek_m3 as int),nullif(concat(':t:',try_cast(Storlek_m as int)),':t:0'),':m2:',try_cast(Storlek_m2 as int))   ,	concat(Typ_slamavskiljare,Typ_sluten_tank,Typ_rening), 	concat(try_cast(Beslut_datum as date),''), 		concat(try_cast(Utford_datum as date),''), 		try_cast(Antal_hushall_tillstand as int)		,concat(Anteckning, q, Avgift)
	    from SearchEnskilt union
    select 'rening' typ,	OBJECTID,    Fastighet_rening, 	null,		     null, 	   	null,			null, 													concat(try_cast(Storlek_m2 as int),''),  									reningstyp,						concat(try_cast(Beslut_datum as date),''),		concat(try_cast(Utford_datum as date),''),		try_cast(Antal_hushall_rening as int) 			,concat(Kommentarer, q)
	    from searchRening
    )

,    allRFormat as (
    select typ, OBJECTID, FASTIGHET, Fastighet_tillstand, nullif(Arendenummer,'')  dianr, Status, try_cast(Utskick_datum as date) utskGiltigtTom , m2M3, Slamhamtning, try_cast(Beslut_datum as date)  Beslut_datum, try_cast(Utforddatum as date) utforddatum, cast(byggnader as int) byggnader, other
    from unionReningFLaggEnskilt

)


select typ, OBJECTID ,
       iif(fastighet is not null and Fastighet_tillstand is not null And (fastighet <> Fastighet_tillstand),
    concat(fastighet, ',til:',Fastighet_tillstand),
    coalesce(Fastighet_tillstand, fastighet)
    ) as fas,   concat(nullif(concat(dianr,'_'),'_'), nullif(concat(Status,'_'),'_'),utskGiltigtTom) status, m2M3, Slamhamtning, Beslut_datum, Utforddatum, byggnader, other
from allRFormat
order by Fastighet_tillstand,FASTIGHET ,dianr,Status