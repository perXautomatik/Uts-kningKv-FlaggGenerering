if object_id(' tempdb..##kalla') is null begin
    BEGIN TRANSACTION;
    if object_id(' tempdb..##fordig') is not null begin drop table  tempdb.dbo.##FORDIG END;
with
    COLUMNPROCESSBADNESSSCORE AS (   SELECT FNR , org , ANDEL , namn , INSKDATUM , adress ,  POSTORT ,  POSTNR , 'geosecma' src
    , ((CASE WHEN namn IS NULL THEN 1 ELSE 0 END) + (CASE WHEN postnr IS NULL THEN 1 ELSE 0 END) + (CASE WHEN postort IS NULL THEN 1 ELSE 0 END)
	+ (CASE WHEN adress IS NULL THEN 1 ELSE 0 END) + (CASE WHEN org is NULL THEN 1 ELSE 0 END))    BADNESS
	FROM (SELECT namn, org, FNR, ANDEL, INSKDATUM, ADRESS
	    , nullif(CASE WHEN postnrAvskFinns THEN substring(POSTNRPOSTORT, postNrAvsk + 1, LEN(POSTNRPOSTORT)) END,'') POSTORT
	    , nullif(CASE WHEN postnrAvskFinns THEN left(POSTNRPOSTORT, postNrAvsk - 1) END,'') POSTNR
	    FROM (select *, postNrAvsk > 0 as postnrAvskFinns from (
	        select *,charindex(' ', POSTNRPOSTORT) postNrAvsk from
		 (SELECT namn , org, FNR, ANDEL, INSKDATUM
		 , nullif(CASE WHEN adressKommaFinns THEN
		     	substring(ADRESS, adressKomma + 2, LEN(ADRESS))
		    		 Else concat(POSTNR,' ',POSTORT) END ,'')
		     POSTNRPOSTORT
		 , nullif(CASE WHEN ADRESSKOMMAFINNS THEN
		     	left(ADRESS, adressKomma - 1)
		     		else ADRESS END,'')
		     ADRESS
		 FROM (select *,ADRESSKOMMA > 0 AND POSTORT IS NULL AND POSTNR IS NULL adresskommaFinns from (
		     select *,charindex(',', ADRESS) adressKomma from (
			 SELECT nullif(NAME,'') namn
			      , nullif(PERSORGNR,'') org
			      , REALESTATEKEY        FNR
			      , SHAREPART            ANDEL
			      , ACQUISITIONDATE      INSKDATUM
			      , ADDRESS              ADRESS
			      , NULL                 POSTORT
			      , NULL                 POSTNR
			 FROM [gisdata].SDE_GEOFIR_GOTLAND.GNG.INFO_CURRENTOWNER q
			    INNER JOIN  tempdb.dbo.##TOINSERT x on x.FNR = q.REALESTATEKEY
			 ) innerTemp
		     ) SRC) src)q
	        ) innerTemp2 ) SPLITADRESS) ADRESSSPLITTER)
    , rest AS (SELECT Z.FNR, null ORG, 		null ANDEL,null NAMN,  null  co, null ADRESS, null  adr2, null POSTNR, null POSTORT, null SRC from COLUMNPROCESSBADNESSSCORE z WHERE BADNESS > 1)
     --, rest as (SELECT * from ip except (SELECT fnr from SRC1LAGFARa))
    , SRC1LAGFARa AS (SELECT Z.FNR, Z.ORG, 	Z.ANDEL,Z.NAMN,  '' co, Z.ADRESS, '' adr2, Z.POSTNR, Z.POSTORT, SRC FROM COLUMNPROCESSBADNESSSCORE z WHERE BADNESS < 2)

SELECT * into  tempdb.dbo.##kalla from SRC1LAGFARa union all SELECT *from rest;
end