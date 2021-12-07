use [tempExcel];
/*--order by count desc,Tillsynsobjekt,unik,kdecy,kdecX,Kategori,typ,Volym,Besiktningsdatum,Beslutsdatum,bedömning
--where strPunkttyp='Ansluten byggnad' OR strPunkttyp='inventeringsinfo'
   --coalesce(nullif(cast(ExterntTjaenstID as varchar),'0'), case when left(ExterntTjaenstID,1) <> 'M' then 'MHN('+ExterntTjaenstID+')' else ExterntTjaenstID end) bedömning,
 z.recAnlaeggningID,--max(recAnlaeggningID) recAnlaeggningID, -- om det finns fler anläggningar av samma syp på en fastighet, strPunkttyp, Status,--max(Status) Status, Tillsynsobjekt, AKrecKoordinatID,--max(AKrecKoordinatID) AKrecKoordinatID, kdecy, kdecX, ExterntTjaenstID, Certifieringstyp,--max(Certifieringstyp) Certifieringstyp, cast(Besiktningsdatum as date) Besiktningsdatum,--cast(max(Besiktningsdatum) as date) Besiktningsdatum, cast(Beslutsdatum as date) Beslutsdatum--cast(max(Beslutsdatum) as date) Beslutsdatum -- group by ExterntTjaenstID,strPunkttyp, Volym, Status, Tillsynsobjekt, kdecy, kdecX */

begin try
    drop table dbo.#anl ;
END TRY BEGIN CATCH
    print ERROR_NUMBER();
END CATCH;
go
CREATE TABLE dbo.#Anl (ExterntTjaenstID Nvarchar(100),
		       recAnlaeggningID int,
		       strPunkttyp      Nvarchar(100),
		       Besiktningsdatum Nvarchar(100),
		       Beslutsdatum     Nvarchar(100),
		       Volym            Nvarchar(100),
		       Certifieringstyp Nvarchar(100),
		       Status           Nvarchar(100),
		       Tillsynsobjekt   int   not null,
		       kdecy            Float not null,
		       kdecX            Float not null)
insert
into dbo.#Anl (ExterntTjaenstID, recAnlaeggningID, strPunkttyp, Besiktningsdatum, Beslutsdatum, Volym, Certifieringstyp, Status, Tillsynsobjekt, kdecy, kdecX)
    (SELECT cast(intExterntTjaenstID as varchar(18)) as                              ExterntTjaenstID
	  , Anlagning.recAnlaeggningID
	  , strPunkttyp
	  , Anlagning.datBesiktningsdatum            As                              Besiktningsdatum
	  , Anlagning.datBeslutsdatum                AS                              Beslutsdatum
	  , (case when decVolym <> 0 then cast(decVolym as varchar(18)) + ' m2' end) Volym
	  , strCertifieringstyp                      as                              Certifieringstyp
	  , Anlagning.strStatus                      as                              Status
	  , AVanlagning.recTillsynsobjektID          AS                              Tillsynsobjekt
	  , decY                                     as                              kdecy
	  , decX                                     as                              kdecX
     FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggning AS Anlagning
	 INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS AVanlagning
	 ON Anlagning.recAvloppsanlaeggningID = AVanlagning.recAvloppsanlaeggningID
	 INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningKoordinat AS AKoordinat
	 ON Anlagning.recAnlaeggningID = AKoordinat.recAnlaeggningID
	 INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K ON AKoordinat.recKoordinatID = K.recKoordinatID
     WHERE k.decX IS NOT NULL AND k.decY IS NOT NULL);
go
begin try
    drop table #HuvudObj ;
END TRY BEGIN CATCH
    SELECT ERROR_NUMBER();
END CATCH;
go
CREATE TABLE #HuvudObj (ExterntTjaenstID Nvarchar(100),
			recAnlaeggningID int,
			strPunkttyp      Nvarchar(100),
			Besiktningsdatum Nvarchar(100),
			Beslutsdatum     Nvarchar(100),
			Volym            Nvarchar(100),
			Certifieringstyp Nvarchar(100),
			Status           Nvarchar(100),
			Tillsynsobjekt   int   not null,
			kdecy            Float not null,
			kdecX            Float not null)
insert
into #HuvudObj (ExterntTjaenstID, recAnlaeggningID, strPunkttyp, Besiktningsdatum, Beslutsdatum, Volym, Certifieringstyp, Status, Tillsynsobjekt, kdecy, kdecX)
    (
	SELECT[dbo].[udf_GetNumeric](AVanlagning.strBedoemning) AS ExterntTjaenstID
	     , 0                                                   recAnlaeggningID
	     , case when K.strPunkttyp = 'Extra inventeringsinformation' then 'inventeringsinfo'
									 else K.strPunkttyp
	       end                                                 strPunkttyp
	     , AVanlagning.datBesiktningsdatum                  As Besiktningsdatum
	     , AVanlagning.datBeslutsdatum                      AS Beslutsdatum
	     , AVanlagning.strVatten + ' h'                     AS Volym
	     , AVanlagning.strEfterfoeljandereningRecipient     as Certifieringstyp
	     , AVanlagning.strStatus                            as Status
	     , AVanlagning.recTillsynsobjektID                  AS Tillsynsobjekt
	     , decY                                             as kdecy
	     , decX                                             as kdecX
	FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning AS AVanlagning
	    INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjektKoordinat AS Tkoordinat
	    ON AVanlagning.recTillsynsobjektID = Tkoordinat.recTillsynsobjektID
	    INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbVisKoordinat AS K
	    ON Tkoordinat.recKoordinatID = K.recKoordinatID
	WHERE k.decX IS NOT NULL AND k.decY IS NOT NULL);
go
begin try
    drop table #xjoining ;
END TRY BEGIN CATCH
    SELECT ERROR_NUMBER();
END CATCH;
go

CREATE TABLE #xjoining (recAnlaeggningID     int,
			Datum                date,
			ToemningsdispensFrOM date,
			Ti                   int,
			Ak                   Nvarchar(100),
			Anläggningstyp       Nvarchar(100),
			Text                 Nvarchar(max))
insert
into #xjoining (recAnlaeggningID, Datum, ToemningsdispensFrOM, Ti, Ak, Anläggningstyp, Text)
    (
	select distinct Anlagning.recAnlaeggningID
		      , case when cast(Anlagning.datStatusDatum as date) <> cast('1900-01-01' as date)
				 then cast(Anlagning.datStatusDatum as date)
			end                                                                                     as Datum
		      , case when cast(Anlagning.datToemningsdispensFrOM as date) <> cast('1900-01-01' as date)
				 then cast(Anlagning.datToemningsdispensFrOM as date)
			end                                                                                     as ToemningsdispensFrOM
		      , case when Anlagning.intToemningsintervall <> 0 then Anlagning.intToemningsintervall end AS Ti
		      , Akategori.strAnlaeggningskategori                                                       AS Ak
		      , ATyp.strAnlaeggningstyp                                                                 AS Anläggningstyp
		      , Anlagning.strText                                                                       AS Text
	FROM EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggning AS Anlagning
	    LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningstyp AS ATyp
	    ON Anlagning.recAnlaeggningstypID = ATyp.recAnlaeggningstypID
	    LEFT OUTER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAnlaeggningskategori AS Akategori
	    ON Anlagning.recAnlaeggningskategoriID = Akategori.recAnlaeggningskategoriID);
go
begin try
    drop table #unGrouped ;
END TRY BEGIN CATCH
    SELECT ERROR_NUMBER();
END CATCH;
go
CREATE TABLE #unGrouped (recAnlaeggningID     int,
			 ExterntTjaenstID     Nvarchar(100),
			 strPunkttyp          Nvarchar(100),
			 Besiktningsdatum     Nvarchar(100),
			 Beslutsdatum         Nvarchar(100),
			 Volym                Nvarchar(100),
			 Certifieringstyp     Nvarchar(100),
			 Tillsynsobjekt       int   not null,
			 kdecy                Float not null,
			 kdecX                Float not null,
			 Ti                   int,
			 Anläggningstyp       Nvarchar(100),
			 Anteckning           Nvarchar(max),
			 qw                   Nvarchar(100),
			 Datum                Nvarchar(100),
			 ToemningsdispensFrOM Nvarchar(100),
			 ak                   Nvarchar(100));
go
insert
into #unGrouped( recAnlaeggningID, Volym, Tillsynsobjekt, kdecy, kdecX, ExterntTjaenstID, Certifieringstyp, Besiktningsdatum, Beslutsdatum, Datum, ToemningsdispensFrOM, Ti, strPunkttyp, ak
	       , Anteckning, Anläggningstyp)
    (select qw                                                                                                      recAnlaeggningID
	  , Volym
	  , Tillsynsobjekt
	  , kdecy
	  , kdecX
	  , ExterntTjaenstID
	  , Certifieringstyp
	  , Besiktningsdatum
	  , Beslutsdatum
	  , Datum
	  , ToemningsdispensFrOM
	  , Ti
	  , strPunkttyp
	  , coalesce(nullif(AK, ''), strPunkttyp)                                                                   strPunkttyp
	  , case when T.strAnteckning like '%' + text then T.stranteckning
						      else cast(T.strAnteckning as nvarchar(256)) + ' ' +
							   cast(Text as nvarchar(256))
	    end                                                                                                  AS Anteckning
	  , case when Anläggningstyp <> '' then ltrim(Anläggningstyp + ' ' + isnull(status, ''))
					   else status
	    end                                                                                                  as Anläggningstyp
     from (select Volym
		, z.recAnlaeggningID             qw
		, strPunkttyp
		, Status
		, Tillsynsobjekt
		, kdecy
		, kdecX
		, ExterntTjaenstID
		, Certifieringstyp
		, cast(Besiktningsdatum as date) Besiktningsdatum
		, cast(Beslutsdatum as date)     Beslutsdatum
	   from (
	       select ExterntTjaenstID
		    , recAnlaeggningID
		    , strPunkttyp
		    , Besiktningsdatum
		    , Beslutsdatum
		    , Volym
		    , Certifieringstyp
		    , Status
		    , Tillsynsobjekt
		    , kdecy
		    , kdecX
	       from dbo.#Anl
	       union
	       select ExterntTjaenstID
		    , recAnlaeggningID
		    , case when not (status is null AND ExterntTjaenstID is null) then 'inventeringsinfo'
										  else strPunkttyp
		      end as                                         strPunkttyp
		    , Besiktningsdatum
		    , Beslutsdatum
		    , Volym
		    , nullif(nullif(Certifieringstyp, ''), N'okänd') Certifieringstyp
		    , Status
		    , Tillsynsobjekt
		    , kdecy
		    , kdecX
	       from #HuvudObj
	   ) z) unionQ
	 INNER JOIN EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt AS T
	 ON unionQ.Tillsynsobjekt = T.recTillsynsobjektID
	 left outer join #xjoining on unionq.qw = #xjoining.recAnlaeggningID);
go



as punktKord_id{ dense_rank() over (
    strPunkttyp, -- should be the reference
    max (KordNyckel) over (kdecy,kdecX) -- seem like there is no requiremnt for this to be unique, but we should
    ) }
    as volym{
select Volym
     , punktKord_id
where Volym is not null, volym <> 0 -- i princip bör årtalen på
group by Volym, punktKord_id}
    as Tillsynsobjekt{ --hämta fast och diarienummer
    max (Tillsynsobjekt), punktKord_id
group by punktKord_id}
    as ExterntTjaenstID{
    stuff(ExterntTjaenstID), punktKord_id
group by punktKord_id}
    as Certifieringsty{
    stuff(Certifieringsty), punktKord_id
group by punktKord_id}
    as Besiktningsdatum{
    max (Besiktningsdatum), punktKord_id
group by punktKord_id}
    as Beslutsdatum{
    max (Beslutsdatum), punktKord_id
GROUP by punktkord_id}
    as Datum{
    max (Datum), punktKord_id
GROUP by punktkord_id}
    as ToemningsdispensFrOM{
    max (ToemningsdispensFrOM), punktKord_id
GROUP by punktkord_id}
    as Ti{ stuff(Ti), punktKord_id
GROUP by punktkord_id}--intToemningsintervall

    as Anteckning{ stuff(Anteckning), punktKord_id
GROUP by punktkord_id}--intToemningsintervall

    as Anläggningstyp{ stuff(Anläggningstyp), punktKord_id
GROUP by punktkord_id}--intToemningsintervall

begin try
    drop table dbo.#restOfTable ;
END TRY BEGIN CATCH
    SELECT ERROR_NUMBER();
END CATCH;
go
CREATE TABLE dbo.#restOfTable (recAnlaeggningID     int,
			       ExterntTjaenstID     Nvarchar(100),
			       strPunkttyp          Nvarchar(100),
			       Besiktningsdatum     Nvarchar(100),
			       Beslutsdatum         Nvarchar(100),
			       Volym                Nvarchar(100),
			       Certifieringstyp     Nvarchar(100),
			       Tillsynsobjekt       int   not null,
			       kdecy                Float not null,
			       kdecX                Float not null,
			       Ti                   int,
			       Anläggningstyp       Nvarchar(100),
			       Anteckning           Nvarchar(max),
			       Datum                Nvarchar(100),
			       ToemningsdispensFrOM Nvarchar(100),
			       groupKey             int   not null)
insert
into dbo.#restOfTable(Volym, Tillsynsobjekt, kdecy, kdecX, ExterntTjaenstID, Certifieringstyp, Besiktningsdatum, Beslutsdatum, Datum, ToemningsdispensFrOM, Ti, strPunkttyp, Anteckning, Anläggningstyp, groupKey)
    (select Volym
	  , Tillsynsobjekt       -- should be maxed
	  , kdecy-- should be the reference
	  , kdecX                -- should be the reference
	  , ExterntTjaenstID     -- should be joined
	  , Certifieringstyp     -- joined
	  , Besiktningsdatum     -- maxed
	  , Beslutsdatum         -- maxed
	  , Datum                -- maxed
	  , ToemningsdispensFrOM -- maxed
	  , Ti                   --?
	  , strPunkttyp          -- joined
	  , Anteckning-- joined
	  , Anläggningstyp       -- joined
	  , groupKey
     from (select Volym
		, Tillsynsobjekt
		, kdecy
		, kdecX
		, ExterntTjaenstID
		, Certifieringstyp
		, Besiktningsdatum
		, Beslutsdatum
		, Datum
		, ToemningsdispensFrOM
		, Ti
		, strPunkttyp
		, Anteckning
		, Anläggningstyp
		, dense_rank()
		 over (order by Tillsynsobjekt,Volym, kdecy, kdecX, ExterntTjaenstID, Certifieringstyp, Besiktningsdatum, Beslutsdatum, Datum, ToemningsdispensFrOM, Ti, strPunkttyp, Anteckning, Anläggningstyp) groupKey
	   from #unGrouped z) as c1gK
     group by Tillsynsobjekt, Volym, kdecy, kdecX, ExterntTjaenstID, Certifieringstyp, Besiktningsdatum, Beslutsdatum
	    , Datum, ToemningsdispensFrOM, Ti, strPunkttyp, Anteckning, Anläggningstyp, groupKey);



go
begin try
    drop table #zeroTable ;
END TRY BEGIN CATCH
    SELECT ERROR_NUMBER();
END CATCH;
go
CREATE TABLE #zeroTable (groupKey int not null, zeroColumn nvarchar(100),)
insert
into #zeroTable(zeroColumn, groupkey)
    (select zeroColumn, groupkey
     from (select(case when recAnlaeggningID = '0' then max(recAnlaeggningID) over ( partition by recAnlaeggningID)
						   else recAnlaeggningID
		  end) zeroColumn
		, groupkey
	   from (select recAnlaeggningID
		      , dense_rank()
		       over (order by Tillsynsobjekt,Volym, kdecy, kdecX, ExterntTjaenstID, Certifieringstyp, Besiktningsdatum, Beslutsdatum, Datum, ToemningsdispensFrOM, Ti, strPunkttyp, Anteckning, Anläggningstyp) groupKey
		 from #unGrouped q) as c1gK) as zCg
     group by zeroColumn, groupKey);
go
begin try
    drop table dbo.#grouped ;
END TRY BEGIN CATCH
    SELECT ERROR_NUMBER();
END CATCH;
go
CREATE TABLE dbo.#grouped (ExterntTjaenstID     Nvarchar(100),
			   strPunkttyp          Nvarchar(100),
			   Besiktningsdatum     Nvarchar(100),
			   Beslutsdatum         Nvarchar(100),
			   Volym                Nvarchar(100),
			   Certifieringstyp     Nvarchar(100),
			   Tillsynsobjekt       int   not null,
			   kdecy                Float not null,
			   kdecX                Float not null,
			   Ti                   int,
			   zeroColumn           nvarchar(100),
			   Anläggningstyp       Nvarchar(100),
			   Anteckning           Nvarchar(max),
			   Datum                Nvarchar(100),
			   ToemningsdispensFrOM Nvarchar(100),
			   groupKey             int   not null,
			   recAnlaeggningID     int)
insert
into dbo.#grouped
(recAnlaeggningID, Volym, Tillsynsobjekt, kdecy, kdecX, ExterntTjaenstID, Certifieringstyp, Besiktningsdatum, Beslutsdatum, Datum, ToemningsdispensFrOM, Ti, strPunkttyp, Anteckning, Anläggningstyp, groupKey)
    (select distinct #zeroTable.zeroColumn recAnlaeggningID
		   , Volym
		   , Tillsynsobjekt
		   , kdecy
		   , kdecX
		   , ExterntTjaenstID
		   , Certifieringstyp
		   , Besiktningsdatum
		   , Beslutsdatum
		   , Datum
		   , ToemningsdispensFrOM
		   , Ti
		   , strPunkttyp
		   , Anteckning
		   , Anläggningstyp
		   , #restOfTable.groupKey
     from #zeroTable
	 join #restOfTable on #zeroTable.groupKey = #restOfTable.groupKey);
go

select recAnlaeggningID
     , strPunkttyp                                                          Kategori
     , Anläggningstyp                                                       typ
     , kdecy
     , kdecX
     , Tillsynsobjekt
     , case
    when cast(ExterntTjaenstID as varchar) <> '0' then case
	when left(ExterntTjaenstID, 1) <> 'M'
	    then 'MHN(' +
		 case when left(ExterntTjaenstID, 2) between 19 AND 20
			  then left(ExterntTjaenstID, 4) + '-' + right(ExterntTjaenstID, len(ExterntTjaenstID) - 4)
			  else ExterntTjaenstID
		 end
	    + ')'
	    else ExterntTjaenstID
						       end
       end                                                                  bedömning
     , Datum                                                                InventeringsDatum
     , Volym
     , Anteckning
     , Besiktningsdatum
     , Beslutsdatum
     , Certifieringstyp as                                                  [Kap\HusTyp\ReningPlacerad]
     , Ti                                                                   SlamDispDiaNr
     , ToemningsdispensFrOM
     , count(Tillsynsobjekt) over (partition by kdecy,kdecX,Tillsynsobjekt) TillObjMedSammaKoord
     , count(*) over (partition by kdecy,kdecX)                             koordinatDubletter
     , count(Tillsynsobjekt) over (partition by Tillsynsobjekt)             TillObjAvSammaNr
     , [geometry]::Point(kdecy, kdecX, 3015)
			AS                                                  Shape
from #grouped
order by koordinatDubletter desc, TillObjMedSammaKoord desc, TillObjAvSammaNr desc, Tillsynsobjekt, recAnlaeggningID


