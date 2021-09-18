CREATE FUNCTION  dbo.usp_SplitReturnOcX(@stringToSplit as varchar(100),@nr as smallint,@delimeeter as character)
RETURNS
 varchar(max)
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT
 Declare @returnList TABLE ([Name] [nvarchar] (500),[id] [int])

 WHILE CHARINDEX(@delimeeter, @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(@delimeeter, @stringToSplit)
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList
  SELECT @name,@pos

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 set @name = case when count(@stringToSplit) < @nr then null
     else
          (select name from (select name, row_number() over (order by id) r from @returnList) q where r = @nr)
    end
 return @name
END