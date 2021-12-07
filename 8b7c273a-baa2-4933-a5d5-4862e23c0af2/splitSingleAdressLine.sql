
INSERT INTO dbo.#d3AdressSplitt( i,adress,C_O,Adress2,PostOrt,postnr )
	SELECT i,adress
         , C_O = (case
                      when (select max(c2.rn) from  tempdb.dbo.##splitAdressCTE c2 WHERE (c2.ADRESS = c1.ADRESS)) >= 4
                          then STUFF(
                              (SELECT '' + c2.ExtractedValuesFromNames + ' '
                               FROM  tempdb.dbo.##splitAdressCTE c2
                               WHERE (c2.ADRESS = c1.ADRESS)
                                 and c2.Rn = 1
                               group by c2.ExtractedValuesFromNames FOR XML PATH ('')), 1, 0, '')
        end)
         , Adress2 = (case
                          when (select max(c2.rn) from  tempdb.dbo.##splitAdressCTE c2 WHERE (c2.ADRESS = c1.ADRESS)) >= 4
                              then STUFF((SELECT '' + c2.ExtractedValuesFromNames + ' '
                                          FROM  tempdb.dbo.##splitAdressCTE c2
                                          WHERE (c2.ADRESS = c1.ADRESS)
                                            and c2.Rn = 2
                                          group by c2.ExtractedValuesFromNames FOR XML PATH ('')), 1, 0, '')
                          else STUFF((SELECT '' + c2.ExtractedValuesFromNames + ' '
                                      FROM  tempdb.dbo.##splitAdressCTE c2
                                      WHERE (c2.ADRESS = c1.ADRESS)
                                        and c2.Rn = 1
                                      group by c2.ExtractedValuesFromNames FOR XML PATH ('')), 1, 0, '') end)

	     ,PostOrt = (case when (select max(c2.rn)from  tempdb.dbo.##splitAdressCTE c2 WHERE (c2.ADRESS = c1.ADRESS)) >= 4 then STUFF((SELECT '' + c2.ExtractedValuesFromNames + ' ' FROM  tempdb.dbo.##splitAdressCTE c2 WHERE (c2.ADRESS = c1.ADRESS)and c2.Rn = 3 group by c2.ExtractedValuesFromNames FOR XML PATH ('')), 1, 0, '')else STUFF((SELECT '' + c2.ExtractedValuesFromNames + ' ' FROM  tempdb.dbo.##splitAdressCTE c2 WHERE (c2.ADRESS = c1.ADRESS)and c2.Rn = 2 group by c2.ExtractedValuesFromNames FOR XML PATH ('')), 1, 0, '') end)
	     ,postnr  = (case when (select max(c2.rn)from  tempdb.dbo.##splitAdressCTE c2 WHERE (c2.ADRESS = c1.ADRESS)) >= 4 then STUFF((SELECT '' + c2.ExtractedValuesFromNames + ' ' FROM  tempdb.dbo.##splitAdressCTE c2 WHERE (c2.ADRESS = c1.ADRESS)and c2.Rn >= 4 group by c2.ExtractedValuesFromNames FOR XML PATH ('')), 1, 0, '')else STUFF((SELECT '' + c2.ExtractedValuesFromNames + ' ' FROM  tempdb.dbo.##splitAdressCTE c2 WHERE (c2.ADRESS = c1.ADRESS)and c2.Rn = 3 group by c2.ExtractedValuesFromNames FOR XML PATH ('')), 1, 0, '') end)
	FROM  tempdb.dbo.##splitAdressCTE c1 group by i, adress
;
