/* warning, this worked, but be warned that miljö is also hosted in same tillsynsobject table, and did not want this update,
   do ad the saftymessure to be absolutely sure we're updating only the records asked for 1000 ca in this case rather than 6k that's the total sum.*/



update tTTA
set datFoeregaaendeBesoek = datDatumM
from (select * from tbTrTillsynsobjekt where recTillsynsobjektID in (select recTillsynsobjektID from tbTrLiLivsmedel)) tTTA --WARNING runs with out this selection
inner join (select max(datDatum) datDatumM,recTillsynsobjektID from tbTrTillsynsbesoek group by recTillsynsobjektID) obj on obj.recTillsynsobjektID = tTTA.recTillsynsobjektID