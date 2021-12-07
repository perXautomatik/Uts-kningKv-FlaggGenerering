create table #g (
                 name varchar(max)
)

BULK INSERT #g
    FROM 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\58e93225-fbe8-4239-b061-0a7800085c08\bulkinsert\Input.sql'
    WITH (ROWTERMINATOR = 'едц')
;
