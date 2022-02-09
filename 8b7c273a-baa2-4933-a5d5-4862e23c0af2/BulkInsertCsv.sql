delete from tempExcel.dbo.inputUppf22 where diarienumer is not null

BULK INSERT tempExcel.dbo.inputUppf22
    FROM N'G:\sbf\Livsmiljö\Miljö- och hälsoskydd\Vatten\Avlopp\Klart Vatten\Information och utskick\Utskick till fastighetsägare\Uppföljning\2022\Aktuella-fastigheter-uppf-22.csv'
    WITH
    (
    	codepage = 'ACP',
    	BATCHSIZE = 10, --makes it vocalize errors atleast, better than silence
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a' --I think there's some strange interplay between having an integer be the last column type, and needing to specify the row terminator in this way...– Andrew Nov 8 '18 at 22:42
    )
