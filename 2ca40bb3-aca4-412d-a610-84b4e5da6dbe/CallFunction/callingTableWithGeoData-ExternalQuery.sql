IF object_id('tempdb..#DF') is not null
    drop table #DF

    BEGIN TRANSACTION --B4
    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255) set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma'; set @externalparam = N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)'
	set @externalQuery =  'SELECT top 100 * from [sde_geofir_gotland].[gng].READDRESS'

    EXEC
		GISDB01.MASTER.DBO.sp_executesql @EXTERNALQUERY
    Commit Transaction --C4

