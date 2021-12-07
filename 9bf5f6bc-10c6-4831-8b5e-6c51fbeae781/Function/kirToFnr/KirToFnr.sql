IF OBJECT_ID(N'dbo.KirToFnr', N'FN') IS NOT NULL DROP FUNCTION KirToFnr;
GO
CREATE FUNCTION DBO.KirToFnr(@RUB NVARCHAR(100)) RETURNS INTEGER AS
BEGIN
    DECLARE @RET AS INTEGER
    SELECT @RET = FNR FROM [gisdata].[sde_geofir_gotland].[gng].FA_FASTIGHET X WHERE @RUB = X.BETECKNING;
    IF (@RET IS NULL) SET @RET = 0; RETURN @RET;
END;
GO