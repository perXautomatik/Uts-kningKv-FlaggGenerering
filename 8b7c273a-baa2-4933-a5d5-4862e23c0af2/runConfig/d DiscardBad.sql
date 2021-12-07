begin try
    drop table addressesToBeCorrected ;
end try
begin catch
end catch

select  * into
    addressesToBeCorrected
	from afterFirstFormating z WHERE BADNESS > 1;

