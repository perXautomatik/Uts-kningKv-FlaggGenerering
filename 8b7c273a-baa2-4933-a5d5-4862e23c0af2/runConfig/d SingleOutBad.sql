begin try
    drop table addressesToBeCorrected ;
end try
begin catch
end catch

select  * into
    addressesToBeCorrected
	from fromCActOnAdressFormating z WHERE BADNESS > 1;

