begin try
    alter table ##fannyUtskick
	add indexX int identity
end try
begin catch
    select 'alter'
end catch
;