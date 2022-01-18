begin try
	alter table ##fannyUtskick add recAerendeID int
end try
begin catch
    select 'alter'
end catch
;
begin try
update Fu
    set Fu.recAerendeID = vAA.recAerendeID
from  ##fannyUtskick Fu inner join
    EDPVisionRegionGotlandTest2.dbo.vwAehAerende vAA on vaa.strDiarienummer = fu.dnr
end try
begin catch
    select 'update'
end catch


;