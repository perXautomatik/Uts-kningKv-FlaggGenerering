with
    Organizer as (SELECT
       *
FROM tempExcel.dbo.Organizer t ),


baraFasObj as ( select * from tempExcel.dbo.baraFasObj)

, baraAnläggningar as (Select * from tempExcel.dbo.baraAnläggningar),

    doublets as (select * from tempExcel.dbo.doublets),

    doesThatHasDoubles as (select ignorex, Anlggningskategori,Verksamhetsnamn, ObjektID from baraFasObj inner join doublets on ObjektID)

   ,platts_ignx_ObjID_Kat as (select ignorex, Anlggningskategori, rest.ObjektID, Verksamhetsnamn from (select ignorex, Anlggningskategori, ObjektID
                                                                                                       from doesThatHasDoubles where ignorex <> 0) rest inner join (select distinct Verksamhetsnamn, ObjektID from doesThatHasDoubles where Verksamhetsnamn <> '') verknamn on verknamn.ObjektID = rest.ObjektID)


,toFilter  as (select
       platts_ignx_ObjID_Kat.ObjektID,
       Verksamhetsnamn,
                      påFastighet,
       baraAnläggningar.ignorex,
       baraAnläggningar.Anlggningskategori,
       Anlggningstyp,
       text,
       Anlggning_fr_S_Anlggningstyp,
       Anlggning_fr_EfterfljRText,
       Externt_Tjnsteid,
       Volym_m3,
       Anlggning_fr_Slamav_Volym_m3,
       Anl_fr_EftR_TInterv_mn,
       AnlfrEfterR_Anlggningstyp,
       besiktningdatum,
       beslutsdatum,
       Fliken_Koordinater,
       fliken_renden,
       fliken_Fastigheter,
       fliken_FastigheterFNR

from baraAnläggningar left join platts_ignx_ObjID_Kat  on baraAnläggningar.ignorex = platts_ignx_ObjID_Kat.ignorex AND baraAnläggningar.Anlggningskategori = platts_ignx_ObjID_Kat.Anlggningskategori AND baraAnläggningar.ObjektID = platts_ignx_ObjID_Kat.ObjektID)


select *
from doesThatHasDoubles
where ObjektID is not null

