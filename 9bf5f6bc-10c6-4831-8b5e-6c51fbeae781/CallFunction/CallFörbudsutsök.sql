
begin
	declare @result int
	exec
		@result = Cp_Forbud1Utsok
	select @result as result
end