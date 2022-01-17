update Fu
    set Fu.recHaendelseID = tb.recHaendelseID
from  ##fannyUtskick Fu inner join
    ##justInserted tb on tb.indexX = Fu.indexX
