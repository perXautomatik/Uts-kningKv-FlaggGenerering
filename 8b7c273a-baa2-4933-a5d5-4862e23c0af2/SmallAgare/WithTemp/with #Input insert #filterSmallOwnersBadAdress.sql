WITH
    filterBadAdress as (SELECT
           		ROW_NUMBER() OVER ( PARTITION BY q.arndenr ORDER BY q.fra desc ) RowNum
    			,qz.fra, qz.POSTORT, qz.POSTNUMMER, qz.ADRESS, qz.NAMN, qz.BETECKNING, qz.arndenr, qz.PERSORGNR from  tempdb.dbo.##input qz
        )

   ,z 		    as (select * from filterBadAdress
   		    	where postOrt <> ''
			AND POSTNUMMER <> ''
			AND Adress <> ''
			AND Namn is not null)

    ,asdasd          as (select z.* from z WHERE z.RowNum = 1)

    ,asdasdx        as (select * from z
			WHERE xz.RowNum between 1 and 4 --(1<x<4)
			  AND fra > 0.3)

   , output 	    as (select *from asdasd union select *from asdasdx)

select *
into  tempdb.dbo.##filterSmallOwnersBadAdress
from output
