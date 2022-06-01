select Ärendenummer
     , Byggnadstyp
     , Fastighetsbeteckning
     , concat(Inkommande_datum, Registereringsdatum, År, Beslutsdatum, Status, Planbedömning, Beslutsnivå,
	      Ärendetyp) rest
     , GDB_GEOMATTR_DATA
     , Shape
     , OBJECTID
from sde_bygglov.gng.BYGGLOVSPUNKTER
union all
select concat(DIARIENR, ANSÖKAN)
     , ÄNDAMÅL
     , Beteckning
     , concat(DATUM, BESLUT, ANTAL, concat(URSPRUNG, id, Kod), AVSER, ANVÄNDNING)
     , GDB_GEOMATTR_DATA
     , Shape
     , OBJECTID
from sde_bygglov.gng.BYGGLOVREG_ALDRE_P
union all
select concat(DIARIENR, ANSÖKAN)
     , concat(BYGGNADSTY, ÄNDAMÅL)
     , AVSER
     , concat(DATUM, BESLUT, År, ANTAL, ANMÄRKNIN, ANM, ANSÖKAN_A)
     , GDB_GEOMATTR_DATA
     , Shape
     , OBJECTID
from sde_bygglov.gng.BYGGLOVSREG_2007_2019_P
union all
select DIARIENR
     , BYGGNADSTY
     , ANSÖKAN_AV
     , concat(ANM, BESLUT)
     , GDB_GEOMATTR_DATA
     , Shape
     , OBJECTID
from sde_bygglov.gng.BYGGLOVSREGISTRERING_CA_1999_2007_P