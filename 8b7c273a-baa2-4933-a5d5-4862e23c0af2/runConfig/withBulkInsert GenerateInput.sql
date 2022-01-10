
--joinX as (select * from [admsql04].[EDPVisionRegionGotland].DBO.VWAEHAERENDE INNER join FastighetsLista ON coalesce(nullif([admsql04].[EDPVisionRegionGotland].DBO.VWAEHAERENDE.strFastighetsbeteckning,''),strSoekbegrepp) = FastighetsLista.FASTIGHET),
/*,isnull(h.STRRUBRIK,1) strUbrik,
	       nullif(a.STRAERENDEMENING,@ARMENING) mening,
	    	nullif(a.strAerendeStatusPresent,@STATUSFILTER1) status1,
	          nullif(a.strAerendeStatusPresent,@STATUSFILTER2) status2*/

use [tempExcel]
    drop table Agarlista;

    create table Agarlista
    (
     Status NVARCHAR(max), handläggare nvarchar(max),	socken
         nvarchar(max),
     Fastighet NVARCHAR(max),
     öppet_ärende nvarchar(max),
     tillstånd_fastighet nvarchar(max),
     beslut nvarchar(max),
     utförandedatum nvarchar(max),
     ant nvarchar(max),
     ant2	nvarchar(max),
     bostadstyp nvarchar(max),
     antalbyggnader nvarchar(max)


	/*    FASTIGHETSNYCKEL INT,
	    Diarienummer NVARCHAR(max),
	    Fastighet NVARCHAR(max),
	    Upprättat NVARCHAR(max),
	    Handläggarnamn NVARCHAR(max),
	    Status NVARCHAR(max),
	    Statuskommentar NVARCHAR(max),
	    NAMN NVARCHAR(max),
	    ADRESS NVARCHAR(max),
	    POSTNUMMER NVARCHAR(max),
	    POSTORT NVARCHAR(max),
	    PERSONORGANISATIONNR VARCHAR(max) */
    )

       /*     WITH
    (
    		CODEPAGE = 'ACP',
                FIELDTERMINATOR = '\t',
                ROWTERMINATOR = '\n'
    )*/
BULK INSERT Agarlista
        FROM N'D:\Project Shelf\RegionGotland\AdressUtsökningar\sammanställning-röda.csv'

        WITH
    (
    	codepage = 'ACP',
    	BATCHSIZE = 10, --makes it vocalize errors atleast, better than silence
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a' --I think there's some strange interplay between having an integer be the last column type, and needing to specify the row terminator in this way...– Andrew Nov 8 '18 at 22:42
    )

alter table agarlista add FASTIGHETSNYCKEL as (dbo.getFnr(Fastighet))
alter table Agarlista add PERSONORGANISATIONNR VARCHAR(max)
alter table Agarlista add Diarienummer NVARCHAR(max)
alter table Agarlista add NAMN NVARCHAR(max)
alter table Agarlista add ADRESS NVARCHAR(max)
alter table Agarlista add POSTNUMMER NVARCHAR(max)
alter table Agarlista add POSTORT NVARCHAR(max)
exec sp_rename 'Agarlista.öppet_ärende', STATUSKOMMENTAR, 'COLUMN'
--insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end11',cast((select count(*) c from agarlista) as varchar)));

