-- adresspunkter

select NAME namn,
       	case when nullif(left(name,len(city)),city) is not null
           then
           	concat(city,' ',name)
           	else
       	    CASE WHEN POPULARNAME is not null
       			then concat(city,' ',POPULARNAME,', ',right(name,len(name)-len(city)-1))
               else name end
               end

       	    adress,

0 PERSORGNR,realEstateKey FNR,0 ANDEL,modificationDate INSKDATUM, postCity POSTORT, postCode postnr
select * from sde_geofir_gotland.gng.READDRESS



