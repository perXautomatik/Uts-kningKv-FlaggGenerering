

select Objektid,
       Verksamhetsnamn,
       Justerad_kontrolltid,
       Riskklass,
       Typ,
       Adress,
       Postnummer,
       Ort,
       Person__Orgnr_,
       Huvudfastighet, fnr

from [tempExcel].dbo.[Tillsynsobjekt inför fördelning] as q left outer join
    [GISDATA].sde_geofir_gotland.gng.FA_FASTIGHET on
        q.huvudfastighet = beteckning