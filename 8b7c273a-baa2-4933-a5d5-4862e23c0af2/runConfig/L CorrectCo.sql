begin try
    drop Table FromInputx
end try
begin catch
end catch
;
with
    standardiseNull as (SELECT FNR, nullif(org, '')     org, nullif(ANDEL, '')   ANDEL,
           nullif(namn, '')    namn, nullif(co, '')      co, nullif(adress, '')  adress1,
           nullif(ad2, '')     ad2, nullif(POSTORT, '') POSTORT, nullif(POSTNR, '')  POSTNR,
           src from FromTaxeringarNlagfartBeforeBadness)

   ,input as (select
     nullif(ltrim(
         replace(
             replace(
                 replace(
                     ltrim(
			 CONCAT(
			   IIF(postnr IS NULL,
				   co,
				   nullif(
				       'c/o ' + co + ', '
				       , 'c/o , '
				       )
			       ),
			   adress1,
			     ' ',
			     ad2,
			     ', ',
			     POSTNR,
			     ' ',
			     POSTORT
			     )
         		), '  ', ' ') --replace duplicate spaces
                 ,' , ', ', ') --replace unessesary spacing round commas
             ,(', ' + POSTNR + ' ' + POSTORT) --replace occurence of postnr and postort
         , '')
         ),'') ADRESS1
,
nullif(ltrim(concat(nullif(co + ',', ','), nullif(adress1, ''), nullif(',' + ad2, ','))), '') Adress2

             , POSTORT, POSTNR, src,FNR, org, ANDEL, namn from standardiseNull)

select * into FromInputx from input
    ;

begin try drop table fromLcorrectCo
end try
begin catch

end catch

;

 with

     mergeAdress as (select FNR, org, ANDEL, namn, coalesce(adress1, ADRESS2) adress, POSTORT, POSTNR, src from FromInputx)

   ,COLUMNPROCESSBADNESSSCORE AS ( select *
    , ((IIF(namn IS NULL, 1, 0)) + (IIF(postnr IS NULL, 1, 0)) + (IIF(postort IS NULL, 1, 0)) + (IIF(adress IS NULL, 1, 0)) + (IIF(org is NULL, 1, 0))) BADNESS
	FROM mergeAdress)

select * into fromLcorrectCo from COLUMNPROCESSBADNESSSCORE
