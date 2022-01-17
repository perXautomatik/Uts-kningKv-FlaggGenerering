select distinct
       coalesce(nullif(tab_url,''),nullif(tab_referrer_url,''),nullif(referrer,''),nullif(site_url,''))

           site_url, original_mime_type
from downloads where mime_type like 'application%'