
INSERT INTO [20201108ChristofferRäknarExcel](fastighet) VALUES ('FOLLINGBO ROSENDAL 1:35');
INSERT INTO [20201108ChristofferRäknarExcel](fastighet)  VALUES ('FOLLINGBO ROSENDAL 1:36');
INSERT INTO [20201108ChristofferRäknarExcel](fastighet)  VALUES ('FOLLINGBO ROSENDAL 1:37');
INSERT INTO [20201108ChristofferRäknarExcel](fastighet)  VALUES ('FOLLINGBO ROSENDAL 1:38');
INSERT INTO [20201108ChristofferRäknarExcel](fastighet)  VALUES ('FOLLINGBO ROSENDAL 1:39');
INSERT INTO [20201108ChristofferRäknarExcel](fastighet)  VALUES ('VÄSKINDE KNUTS 1:7');


update tempExcel.dbo.[20201112Flaggor ägaruppgifter-nyutskick]
set NAMN = 'Nellie Andersson', PERSONORGANISATIONNR = '19940224-1500'
    ,adress = 'STRANDVÄGEN 37 B LGH 1002', POSTORT = 'LOMMA', POSTNUMMER = 23436
where FASTIGHETSBETECKNING = 'GANTHEM NORRBYS 1:16'

INSERT into tempExcel.dbo.[20201112Flaggor ägaruppgifter-nyutskick]
(NAMN, PERSONORGANISATIONNR,adress, POSTORT, POSTNUMMER,FASTIGHETSBETECKNING) values('Kristofer Bergbohm','19940509-8030',
'RUTE SIGFRIDE 721', 'LÄRBRO', 62458, 'GANTHEM NORRBYS 1:16')


select * from #pato


