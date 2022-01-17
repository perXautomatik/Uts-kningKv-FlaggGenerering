
with qw as
    (select z.recHaendelseID,recHaendelseEnstakaKontaktID,recEnstakaKontaktID from tbAehHaendelseEnstakaKontakt inner join
    (select ahd.recHaendelseID
from EDPVisionRegionGotlandTest2.dbo.tbAehHaendelseData ahd
    inner join (select tbah.*
		from EDPVisionRegionGotlandTest2.dbo.tbAehAerendeHaendelse tbah
		    inner join (select recAerendeId
				from EDPVisionRegionGotlandTest2.dbo.vwAehAerende
				where strDiarienummer = 'M-1900-0') q on q.recAerendeId = tbah.recAerendeId) u
    on ahd.recHaendelseID = u.recHaendelseID) z on tbAehHaendelseEnstakaKontakt.recHaendelseID = z.recHaendelseID
    )
select qw.*, tb.recEnstakaKontaktID, strFoernamn, strEfternamn, strFoeretag, strOrginisationPersonnummer, strTitel, strKontaktTyp, strGatuadress, strCoadress, strPostnummer, strPostort, strLand, strVisasSom, strSammanslagenAdress
from tbVisEnstakaKontakt tb inner join

qw

on qw.recEnstakaKontaktID = tb.recEnstakaKontaktID

