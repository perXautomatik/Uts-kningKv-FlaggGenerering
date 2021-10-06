begin
	declare @recAerendeID int = 0
	declare @result int
	exec
		@result = spAehAerendeDataUpdateFastighet @recAerendeID
	select @result as result
end