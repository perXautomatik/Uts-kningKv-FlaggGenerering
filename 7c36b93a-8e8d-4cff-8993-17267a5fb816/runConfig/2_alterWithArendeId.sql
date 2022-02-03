
update Fu
    set Fu.recAerendeID = vAA.recAerendeID
from  ##fannyUtskick Fu
                left outer join (select  recDiarieAarsSerieID,intDiarieAar from dbo.tbAehDiarieAarsSerie) diaS
                    on fu.intDiarieAar = dias.intDiarieAar
         left outer join dbo.tbAehAerende vAA
             on isnull(vaa.intDiarienummerLoepNummer,'') = fu.intDiarienummerLoepNummer
    		and vaa.recDiarieAarsSerieID = dias.recDiarieAarsSerieID
                and vaa.strDiarienummerSerie = fu.strDiarienummerSerie


;
insert into cbrRessults select recAerendeID from ##fannyUtskick