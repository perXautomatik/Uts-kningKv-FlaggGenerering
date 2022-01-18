-- One handelse per Ärende, regardless of number of recivers, we'll identifie ägare separatly

update Fu
    set Fu.recHaendelseID = tb.recHaendelseID
from  ##fannyUtskick Fu inner join
    ##justInserted tb on tb.recAerendeID = Fu.recAerendeID
