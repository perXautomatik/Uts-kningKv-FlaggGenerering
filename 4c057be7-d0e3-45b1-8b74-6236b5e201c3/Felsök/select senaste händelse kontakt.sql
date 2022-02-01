select top 10  (select top 1 strDiarienummer from vwAehHaendelse where vwAehHaendelseHuvudkontakt.recHaendelseID = vwAehHaendelse.recHaendelseID) dia,* from EDPVisionRegionGotlandTest2.dbo.vwAehHaendelseHuvudkontakt order by recHaendelseID desc

/*TABLE_NAME
tbAehHaendelseEnstakaKontakt
tbVisEnstakaKontakt
tbVisEnstakaKontaktKommunikationssaett
tbVisKommunikationssaett
vwVisEnstakaKontaktGrid/*
*/
 */

--when delete; View or function 'dbo.vwAehHaendelseHuvudkontakt' is not updatable because the modification affects multiple base tables.

select top 10 * from EDPVisionRegionGotlandTest2.dbo.vwAehHaendelseHuvudkontakt order by recHaendelseID desc

select top 500 tbh.recHaendelseID, strRubrik, strText, strRiktning, taah.*
from tbAehHaendelse tbh inner join tbAehHaendelseData tAAH on tbh.recHaendelseID = tAAH.recHaendelseID
order by tbh.recHaendelseID desc
;