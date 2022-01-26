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

select FNR, org, ANDEL, namn, co, coalesce(adress1, ad2) adress, POSTORT, POSTNR, src
into InsideStandardTable from standardiseNull;

alter table InsideStandardTable
    ADD
    HasPost as (case when POSTNR is null OR POSTORT is null then 'false' else 'true' end)
   ,countCommas as (LEN(adress) - LEN( REPLACE( adress, ',', '' )))
   ,PostInAdr as (case when charindex(adress,POSTNR)+charindex(adress,POSTORT) > 0 then 'true' else false end)
;

if count commas = 0
    then adress
else
    countcommas = 1 AND if hasPost = true & PostInAdr = true
		then adress = left(adress(commaPos))

	countCommas => 2

	    countcommas = 2 & if hasPost = true & PostInAdr = true
		    then replace(adress,postort), replace(postnr)
		    trim(adress)
		    then if right 2 = ',,' or right 3 = ', ,'
		    adress = trim left len()
		        -2 Or left len()-3

	    if hasPost is false
		postnr = right(adress, last comma pos)





	else
	    UseArchicMethod



if HasPost = 0 and checkIfPostnrPostOrtInAdress then postnrAdr in adress
    count commas = 1



	if InsideStandardTable adress has comma, but does not have checkIfPostnrPostOrtInAdress then co in adress OR foriegn









with

   input as (select
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

begin try drop table fromTaxeringagareNLagfart
end try
begin catch

end catch

;

 with

     mergeAdress as (select FNR, org, ANDEL, namn, coalesce(adress1, ADRESS2) adress, POSTORT, POSTNR, src from FromInputx)

   ,COLUMNPROCESSBADNESSSCORE AS ( select *
    , ((IIF(namn IS NULL, 1, 0)) + (IIF(postnr IS NULL, 1, 0)) + (IIF(postort IS NULL, 1, 0)) + (IIF(adress IS NULL, 1, 0)) + (IIF(org is NULL, 1, 0))) BADNESS
	FROM mergeAdress)

select * into fromTaxeringagareNLagfart from COLUMNPROCESSBADNESSSCORE
