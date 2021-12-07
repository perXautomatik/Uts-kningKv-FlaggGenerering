begin
	declare @recHaendelseID int = 0
	declare @result int
	exec
		@result = spAehHaendelseUpdateFastighet @recHaendelseID
	select @result as result
end