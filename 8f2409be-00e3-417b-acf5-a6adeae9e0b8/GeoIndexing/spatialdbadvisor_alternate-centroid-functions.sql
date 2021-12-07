drop function dbo.[STCENTROID_P]
CREATE FUNCTION dbo.[STCENTROID_P](@p_geometry GEOMETRY,
				   @p_round_x  INT = 3,
				   @p_round_y  INT = 3,
				   @p_round_z  INT = 3)
    -- MultiPoint Centroid Creator
-- https://spatialdbadvisor.com/sql_server_blog/263/alternate-centroid-functions-for-sql-server-spatial
    RETURNS GEOMETRY
AS
BEGIN
    DECLARE
	@v_x FLOAT = 0.0,
	@v_y FLOAT = 0.0,
	@v_z FLOAT,
	@v_geomn INT,
	@v_part_geom geometry,
	@v_geometry geometry,
	@v_gtype nvarchar(MAX);
    BEGIN
	IF (@p_geometry IS NULL)
	    RETURN @p_geometry;
	SET @v_gtype = @p_geometry.STGeometryType();
	IF (@v_gtype = 'MultiPoint')
	    BEGIN
		-- Get parts of multi-point geometry
		--
		SET @v_geomn = 1;
		WHILE (@v_geomn <= @p_geometry.STNumGeometries())
		    BEGIN
			SET @v_part_geom = @p_geometry.STGeometryN(@v_geomn);
			SET @v_x = @v_x + @v_part_geom.STX
			SET @v_y = @v_y + @v_part_geom.STY
			SET @v_geomn = @v_geomn + 1;
		    END;
		SET @v_geometry = geometry::Point(@v_x / @p_geometry.STNumGeometries(),
						  @v_y / @p_geometry.STNumGeometries(),
						  @p_geometry.STSrid);
	    END
	ELSE
	    SET @v_geometry = @p_geometry;
	RETURN @v_geometry;
    END;
END
GO
