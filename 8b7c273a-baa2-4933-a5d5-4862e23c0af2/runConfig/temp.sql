begin try
    drop table excluded;

        CREATE table  excluded (dia VARCHAR(50),fas VARCHAR(50))
	CREATE INDEX exCInd on  EXCLUDED(fas,dia);
	INSERT INTO  excluded (FAS)
	VALUES
	(N'TRÄKUMLA TJÄNGDARVE 1:27'),
	(N'FOLLINGBO ROSENDAL 1:40'),
	(N'FOLLINGBO SLÄTTFLISHAGE 4:1'),
	(N'FOLLINGBO SLÄTTFLISHAGE 2:2'),
	(N'FOLLINGBO SYLFASTE 1:15'),
	(N'FOLLINGBO SYLFASTE 1:19'),
	(N'FOLLINGBO TINGSTOMT 1:20'),
	(N'FOLLINGBO KLINTE 1:64'),
	(N'TRÄKUMLA INGVARDS 1:59'),
	(N'VISBY ANNELUND 1:20'),
	(N'VISBY GUSTAVSVIK 1:13'),
	(N'VISBY SNÄCKGÄRDET 1:30')
end try
begin catch
    print ERROR_line()
end catch
begin try
    drop table Agarlista;

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
;
With
       	--input as (select coalesce(nullif(STRFASTIGHETSBETECKNING, ''), STRSOEKBEGREPP) kir, fnr,dia,strLogKommentar from inputVision)
	input as (select fastighetsnyckel fnr, fastighet kir, personorganisationnr org,diarienummer dia,fastighet fas, * from agarlista)

	,correctFnrWithKirFnr as (select *,fnr fnrx from input)
   	       --coalesce(KirFnr.Fnr,a.fnr) Fnrx FROM input a LEFT OUTER JOIN KirFnr ON a.KIR = KirFnr.BETECKNING )
   	--vision has sometimes a internal nr instad of fnr in the fnrcolumn
	,withY as (select *,isnull(coalesce(nullif(T.DIA,''), nullif(T.FAS,'')),'') y from EXCLUDED T )
   	,withX as (SELECT t.*, isnull(coalesce(nullif(T.DIA,''), nullif(T.FAS,'')),'') X
   		FROM correctFnrWithKirFnr t )
   	,filterInputByDiaFas as (select x.* from withX x LEFT OUTER JOIN withy t on x.x = t.y WHERE t.y is null)

	select fnr,dia,org,STATUSKOMMENTAR from filterInputByDiaFas
