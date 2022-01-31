

update Fu
    set Fu.recAerendeID = vAA.recAerendeID
from  ##fannyUtskick Fu inner join
    EDPVisionRegionGotlandTest2.dbo.vwAehAerende vAA on vaa.strDiarienummer = fu.dnr


