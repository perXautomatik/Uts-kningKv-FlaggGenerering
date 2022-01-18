if not(exists(
    select * from sys.objects
    where object_id = object_id('dbo.getFnr')
    ))
    begin
	select ''
    end


    CREATE FUNCTION [dbo].[getFnr]
    (
	@fastighetsbeteckning NVARCHAR(4000)
    )
    RETURNS INT
    AS
    BEGIN

	DECLARE @ret INT = 0;
	SET @ret = (select top 1 x.fnr from [gisdata].[sde_geofir_gotland].[gng].Fa_Fastighet x where x.beteckning = @fastighetsbeteckning)
	RETURN @ret;

    END

go
;