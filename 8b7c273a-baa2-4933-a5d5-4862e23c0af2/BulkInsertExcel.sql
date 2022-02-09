EXEC sp_addLinkedServer
    @server= N'XLSX_2022a',
    @srvproduct = N'Excel',
    @provider = N'Microsoft.ACE.OLEDB.16.0',
    @datasrc = N'G:\sbf\Livsmiljö\Miljö- och hälsoskydd\Vatten\Avlopp\Klart Vatten\Information och utskick\Utskick till fastighetsägare\Uppföljning\2022\Aktuella-fastigheter-uppf-22.xlsx',
    @provstr = N'Excel 12.0; HDR=Yes';
GO
-- Cannot get the column information from OLE DB provider "Microsoft.ACE.OLEDB.16.0" for linked server "XLSX_2022a".

SELECT * FROM OPENQUERY (XLSX_2022a, 'select * from [Aktuella Faster-utskcik]')

-- might be due to not being able to install right cpu arcitecture on current computer of acces db engine,

INSERT INTO tempExcel.dbo.toInsert (fnr, dia, statuskommentar)
SELECT A.[Fastighet], A.[Diarienummer],  A.[statuskommentar]
SELECT * FROM OPENROWSET (
    'Microsoft.ACE.OLEDB.16.0',
    'Excel 12.0;Database=G:\sbf\Livsmiljö\Miljö- och hälsoskydd\Vatten\Avlopp\Klart Vatten\Information och utskick\Utskick till fastighetsägare\Uppföljning\2022\Aktuella-fastigheter-uppf-22.xlsx;HDR=YES;IMEX=1',
    'select * from [Aktuella Faster-utskcik]');

GO

--

SELECT * FROM OPENROWSET(
	'Microsoft.Jet.OLEDB.4.0',
	'Excel 12.0;Database=G:\sbf\Livsmiljö\Miljö- och hälsoskydd\Vatten\Avlopp\Klart Vatten\Information och utskick\Utskick till fastighetsägare\Uppföljning\2022\Aktuella-fastigheter-uppf-22.xlsx;HDR=YES;IMEX=1',
	'SELECT * FROM [Aktuella Faster-utskcik]');
