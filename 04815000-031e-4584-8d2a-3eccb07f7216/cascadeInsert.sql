declare @insertTable table (recHaendelseID integer, inputId integer identity (1,1),
                            strRoll nvarchar(max), bolHuvudkontakt bit, strFoernamn nvarchar(max),
                            strEfternamn nvarchar(max), strFoeretag nvarchar(max),
                            strOrginisationPersonnummer nvarchar(max), strTitel nvarchar(max),
                            strKontaktTyp nvarchar(max), strGatuadress nvarchar(max),
                            strCoadress nvarchar(max), strPostnummer nvarchar(max),
                            strPostort nvarchar(max), strLand nvarchar(max), strVisasSom nvarchar(max),
                            strSammanslagenAdress nvarchar(max), strKommunikationsaettTyp nvarchar(max),
                            strVaerde nvarchar(max), strBeskrivning nvarchar(max))

DECLARE @recHaendelseEnstakaKontaktID TABLE (i INT,inputIdx int)

DECLARE @recEnstakaKontaktID TABLE (i INT,inputIdx int)

DECLARE @recEnstakaKontaktKommunikationssaettID  TABLE (i INT,inputIdx int)

DECLARE @recKommunikationssaettID TABLE (i INT,inputIdx int)

insert
    into tbVisEnstakaKontakt (
    --recEnstakaKontaktID autoincrement,
    strFoernamn, strEfternamn, strFoeretag, strOrginisationPersonnummer,
    strTitel, strKontaktTyp, strGatuadress, strCoadress, strPostnummer,
    strPostort, strLand, strVisasSom, strSammanslagenAdress
    )
    OUTPUT INSERTED.recEnstakaKontaktID,inputId INTO @recEnstakaKontaktID
    SELECT
	strFoernamn, strEfternamn, strFoeretag, strOrginisationPersonnummer,
	strTitel, strKontaktTyp, strGatuadress, strCoadress, strPostnummer,
        strPostort, strLand, strVisasSom, strSammanslagenAdress
    FROM
	@insertTable

insert
    into tbVisKommunikationssaett (
	--recKommunikationssaettID  autoincrement,,
	strKommunikationsaettTyp, strVaerde, strBeskrivning
    )
    OUTPUT INSERTED.recKommunikationssaettID,inputId  INTO @recKommunikationssaettID
    SELECT
	strKommunikationsaettTyp, strVaerde, strBeskrivning
    FROM
	@insertTable

insert
    into tbAehHaendelseEnstakaKontakt (
	--recHaendelseEnstakaKontaktID,
	recHaendelseID, recEnstakaKontaktID, strRoll, bolHuvudkontakt
    )
    OUTPUT INSERTED.recHaendelseEnstakaKontaktID,inputId INTO @recHaendelseEnstakaKontaktID
    SELECT
	recHaendelseID,(select top 1 i from @recEnstakaKontaktID where inputIdx = inputId), strRoll, bolHuvudkontakt
    FROM
	@insertTable

insert
    into tbVisEnstakaKontaktKommunikationssaett (
	--recEnstakaKontaktKommunikationssaettID  autoincrement,,
	recEnstakaKontaktID, recKommunikationssaettID
    )
    OUTPUT INSERTED.recEnstakaKontaktKommunikationssaettID,inputId  INTO @recEnstakaKontaktKommunikationssaettID
    SELECT
	(select top 1 i from @recEnstakaKontaktID where inputIdx = inputId),(select top 1 i from @recKommunikationssaettID)
    FROM
	@insertTable
