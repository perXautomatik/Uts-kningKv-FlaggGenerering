use [tempExcel]
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'begin try1'))

begin try drop table fromCActOnAdressFormating end try begin catch end catch

begin try

create table fromCActOnAdressFormating (FNR       int,
				  org       nvarchar(20),
				  ANDEL     nvarchar(41),
				  namn      nvarchar(501),
				  INSKDATUM nvarchar(10),
				  adress    nvarchar(256),
				  POSTORT   nvarchar(256),
				  POSTNR    nvarchar(256),
				  src       varchar(8) not null,
				  BADNESS   int
				  unique (fnr,org,namn,adress,POSTORT,POSTNR,src)
				  with (ignore_dup_key  = on )
)end try begin catch end catch;

with       formatedWithAdresskomma as (
					select nullif(NAME, '')                                            namn
					     , nullif(personorganisationnr, '')                            org
					     , REALESTATEKEY                                               FNR
					     , SHAREPART                                                   ANDEL
					     , ACQUISITIONDATE                                             INSKDATUM
					 , nullif(ADDRESS,'') 						   ADRESS
					     , NULL                                                        POSTORT
					     , NULL                                                        POSTNR
					     , IIF(charindex(',', reverse(ADDRESS)) > 0, len(address) - charindex(',', reverse(ADDRESS)) + 1, 0) adressKomma
					from fromBJoinInfoCurrentOwner
				    )
  ,       withAdressKommaFinns    	as (select *, IIF(ADRESSKOMMA > 0 AND POSTORT IS NULL AND POSTNR IS NULL, 1, 0) adresskommaFinns
  						from formatedWithAdresskomma)

          ,actOnAdressKomma       	as (SELECT namn, org, FNR, ANDEL, INSKDATUM,POSTNR,POSTORT
					   , nullif(ltrim(CASE WHEN adressKommaFinns = 1 THEN substring(ADRESS, adressKomma + 1, LEN(ADRESS)) END), '')  POSTNRPOSTORT
					   , coalesce(nullif(IIF(ADRESSKOMMAFINNS = 1, left(ADRESS, adressKomma - 1), ADRESS), ' '),adress)  ADRESS
				      FROM withAdressKommaFinns)

	  ,  withPostNrAvsk        	as (select *, isnull(charindex(' ', POSTNRPOSTORT),0) postNrAvsk from actOnAdressKomma)

    	,  withPostNrAvskFinns 		as (select *, IIF(postNrAvsk > 0, 1, 0) as postnrAvskFinns from  withPostNrAvsk )


	, splitPostNrPostAdress 	as  (SELECT namn, org, FNR, ANDEL, INSKDATUM, ADRESS
	    , IIF(postort is null,
		  nullif(CASE WHEN postnrAvskFinns = 1 THEN substring(POSTNRPOSTORT, postNrAvsk + 1, LEN(POSTNRPOSTORT)) END, ''), postort) POSTORT
	    , IIF(postnr is null,
	        nullif(CASE WHEN postnrAvskFinns = 1 THEN left(POSTNRPOSTORT, postNrAvsk - 1) END, ''),
		  postnr) POSTNR
					    FROM withPostNrAvskFinns)

        ,COLUMNPROCESSBADNESSSCORE AS (   SELECT FNR , org , ANDEL , namn , INSKDATUM , adress ,  POSTORT ,  POSTNR , 'geosecma' src
    , ((IIF(namn IS NULL, 1, 0)) + (IIF(postnr IS NULL, 1, 0)) + (IIF(postort IS NULL, 1, 0)) + (IIF(adress IS NULL, 1, 0)) + (IIF(org is NULL, 1, 0))) BADNESS
	FROM splitPostNrPostAdress)

insert into fromCActOnAdressFormating select * from COLUMNPROCESSBADNESSSCORE

insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end1'));