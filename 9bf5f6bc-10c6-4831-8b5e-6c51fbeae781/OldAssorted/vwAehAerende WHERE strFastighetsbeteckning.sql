SELECT *
from vwAehAerende
WHERE
      strFastighetsbeteckning = 'Follingbo Klinte 1:36'
   or strFastighetsbeteckning = 'Follingbo Klinte 1:54'

order by recAerendeId desc