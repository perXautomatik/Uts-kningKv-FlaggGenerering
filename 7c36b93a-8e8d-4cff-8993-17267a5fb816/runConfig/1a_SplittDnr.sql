
    alter table ##fannyUtskick
	add intDiarienummerLoepNummer as cast(right(dnr,len(dnr)-len('mbnv-2020-')) as int) ,
             intDiarieAar as cast(substring(dnr,charindex('-',dnr)+1, 4) as integer)
              , strDiarienummerSerie as left(dnr,charindex('-',dnr)-1)