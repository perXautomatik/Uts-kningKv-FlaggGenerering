

select recTillsynsbesoekEnstakaKontaktID,
       recTillsynsbesoekID, strRoll, recEnstakaKontaktID, strFoernamn, strEfternamn, strFoeretag,
       strOrginisationPersonnummer, strTitel, strKontaktTyp, strGatuadress, strCoadress,
       strPostnummer, strPostort, strLand, strVisasSom, strSammanslagenAdress, strNamn,
       strEpost, strFax, strTelefon, strMobil
	from EDPVisionRegionGotland.dbo.vwTrTillsynsbesoekHuvudKontakt
	union
select recTillsynsObjektDeladKontaktID,
       recTillsynsobjektID, intRecnum, strRoll, recDeladKontaktID, strFoernamn, strEfternamn,
       strFoeretag, strOrginisationPersonnummer, strTitel, strKontaktTyp, strGatuadress,
       strCoadress, strPostnummer, strPostort, strLand, strVisasSom, strSammanslagenAdress,
       strNamn, strEpost, strFax, strTelefon, strMobil
    from EDPVisionRegionGotland.dbo.vwTrTillsynsobjektetsHuvudkontakt
	union
    select recTillsynsObjektDeladKontaktID,
       recTillsynsobjektID, intRecnum, strRoll, recDeladKontaktID, strFoernamn, strEfternamn,
           strFoeretag, strOrginisationPersonnummer, strTitel, strKontaktTyp, strGatuadress,
           strCoadress, strPostnummer, strPostort, strLand, strVisasSom, strSammanslagenAdress,
           strNamn, strEpost, strFax, strTelefon, strMobil
    from EDPVisionRegionGotland.dbo.vwTrTillsynsobjektetsVerksamhetsutoevare

    union select *from
         EDPVisionRegionGotland.dbo.vwTrTillsynsobjektHuvudkontaktperson
    union select *from
         EDPVisionRegionGotland.dbo.vwTrVerksamhetTillsynsobjektDeladKontakt
    union select *from
         EDPVisionRegionGotland.dbo.vwVisDeladFastighetLagfarenAegare
    union select  *from
         EDPVisionRegionGotland.dbo.vwVisDeladKontakt
    union select *from
         EDPVisionRegionGotland.dbo.vwVisDeladKontaktGrid
    union select *from
         EDPVisionRegionGotland.dbo.vwVisEnstakaKontakt
    union select *from
         EDPVisionRegionGotland.dbo.vwVisEnstakaKontaktGrid
    union select *from
         EDPVisionRegionGotland.dbo.vwVisKontakt