SELECT
K.recKoordinatID AS Id,
T.recTillsynsobjektID AS Tillsynsobjekt,
AT.strAnlaeggningstyp AS Anläggningstyp,
AKI.strAnlaeggningskategori AS Anläggningskategori,
A.decVolym AS Volym,
A.datBeslutsdatum AS Beslutsdatum,
A.intToemningsintervall AS Tömningsintervall,
A.strText AS Text,
[geometry]::Point(K.decY, K.decX, 3015) AS Shape
FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggning AS A
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS AA ON A.recAvloppsanlaeggningID = AA.recAvloppsanlaeggningID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T ON AA.recTillsynsobjektID = T.recTillsynsobjektID
LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningstyp AS AT ON A.recAnlaeggningstypID = AT.recAnlaeggningstypID
LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningskategori AS AKI ON A.recAnlaeggningskategoriID = AKI.recAnlaeggningskategoriID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningKoordinat AS AK ON A.recAnlaeggningID = AK.recAnlaeggningID
INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K ON AK.recKoordinatID = K.recKoordinatID
WHERE K.strPunkttyp='Ansluten byggnad' OR K.strPunkttyp='Efterföljande rening' OR K.strPunkttyp='Extra inventeringsin' OR K.strPunkttyp='Tank'
