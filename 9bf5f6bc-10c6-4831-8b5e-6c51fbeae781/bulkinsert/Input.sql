create table #f (
                 rowdata nvarchar(max)
)

declare @DF table  ( x integer, fnr integer )

DECLARE @EXTERNALQUERY NVARCHAR(MAX)

create table #g (
                 rowdata nvarchar(max)
)

BULK INSERT #f
    FROM N'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\5b682ee5-608b-4b16-bdfd-1132a4a5566f\select FastighetToAgare BeteckningWherePersonOrgnrEq_2.sql'
    WITH (ROWTERMINATOR = 'едц')
;

BULK INSERT #g
    FROM N'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\9bf5f6bc-10c6-4831-8b5e-6c51fbeae781\Vision-Gis\persNr.sql'
    WITH (ROWTERMINATOR = 'едц')
;
select * from #f

declare @query nvarchar(max);
set @query = (select replace(rowdata,'@personNr','@personNr.x') from #f);

SET @EXTERNALQUERY = '' + (select rowdata from #g) + ';'+
                     'select x,(select fnr from (' + @query +
                     ') q ) as fnr' +
                     ' from @personNr'

select @EXTERNALQUERY

insert INTO @DF (x, fnr)
	EXEC
	    GISDB01.MASTER.DBO.sp_executesql @EXTERNALQUERY

select * from @df

-- User-Defined Table Type cleanup
drop table #f
go
drop table #g
go