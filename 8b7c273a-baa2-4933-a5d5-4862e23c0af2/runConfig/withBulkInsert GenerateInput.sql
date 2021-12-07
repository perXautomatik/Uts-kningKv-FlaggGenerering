use [tempExcel]
--joinX as (select * from [admsql04].[EDPVisionRegionGotland].DBO.VWAEHAERENDE INNER join FastighetsLista ON coalesce(nullif([admsql04].[EDPVisionRegionGotland].DBO.VWAEHAERENDE.strFastighetsbeteckning,''),strSoekbegrepp) = FastighetsLista.FASTIGHET),
/*,isnull(h.STRRUBRIK,1) strUbrik,
	       nullif(a.STRAERENDEMENING,@ARMENING) mening,
	    	nullif(a.strAerendeStatusPresent,@STATUSFILTER1) status1,
	          nullif(a.strAerendeStatusPresent,@STATUSFILTER2) status2*/
begin try
    insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'bulkinsert11'))

    drop table Agarlista;
    end try
begin catch
    print ERROR_line()
end catch
begin try
    create table Agarlista
    (
	    FASTIGHETSNYCKEL INT,
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
	    PERSONORGANISATIONNR VARCHAR(max)
    )

end try
begin catch
    print ERROR_line()
end catch
begin try
BULK INSERT Agarlista
        FROM N'D:\Unsorted\Ägarlista.txt'
            WITH
    (
    		CODEPAGE = 'ACP',
                FIELDTERMINATOR = '\t',
                ROWTERMINATOR = '\n'
    )
end try
begin catch
    print ERROR_line()
end catch
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end11',cast((select count(*) c from agarlista) as varchar)));

