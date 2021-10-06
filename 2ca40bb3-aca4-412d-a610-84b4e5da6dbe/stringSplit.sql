SELECT value as ressWithSpaces
FROM tempExcel.dbo.[4årsPåm2019] as qwer
         CROSS APPLY STRING_SPLIT(qwer.ADRESS, '', '')