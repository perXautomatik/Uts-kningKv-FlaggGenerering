
with A as (select recTillsynsobjektID,strEfterfoeljandereningRecipient,strStatus,strBedoemning,strInventering,strVatten,datBesiktningsdatum,datBeslutsdatum from EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning)
, T as (select recTillsynsobjektID,strAnteckning from [EDPVisionRegionGotlandAvlopp].dbo.[tbTrTillsynsobjekt]),
     TK as (select recTillsynsobjektID,recKoordinatID from [EDPVisionRegionGotlandAvlopp].dbo.[tbTrTillsynsobjektKoordinat]),
     K as (select recKoordinatID,decX,decY,strPunkttyp from [EDPVisionRegionGotlandAvlopp].dbo.[tbVisKoordinat]
     WHERE decX IS NOT NULL AND decY IS NOT NULL AND (strPunkttyp='Ansluten byggnad' or strPunkttyp='Inventeringsinfo' or strPunkttyp='Efterföljande re'))

SELECT
    K.recKoordinatID AS Id,
    T.recTillsynsobjektID AS Tillsynsobjekt,
    A.datBesiktningsdatum As Besiktningsdatum,
    A.datBeslutsdatum AS Beslutsdatum,
    A.strVatten AS Vatten,
    A.strInventering AS Inventering,
    A.strBedoemning AS Bedömning,
    A.strStatus AS Status,
    A.strEfterfoeljandereningRecipient AS Recipient,
    T.strAnteckning AS Anteckning,
[geometry]::Point(K.decY, K.decX, 3015) AS Shape
FROM A
INNER JOIN T ON A.recTillsynsobjektID = T.recTillsynsobjektID
INNER JOIN TK ON T.recTillsynsobjektID = TK.recTillsynsobjektID
INNER JOIN K ON TK.recKoordinatID = K.recKoordinatID



