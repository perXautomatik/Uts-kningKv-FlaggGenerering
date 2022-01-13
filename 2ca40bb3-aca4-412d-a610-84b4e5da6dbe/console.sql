SELECT
    A.[Dnr],
    A.[fastighet],
    A.[Ägare],
    A.[Postadress],
    A.[POSTNR],
    A.[POSTORT],
    A.[personnr/Organisationnr],
    A.[source]

FROM OPENROWSET ('Microsoft.jet.OLEDB.4.0', 'Excel 8.0;database=d:\DUnsorted\fannyUtskick.xlsx', '[Sheet1$]') AS A
GO
