use [tempExcel]
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'korrigerade7'))

begin try
    drop table fromFulaatkorrigera
end try
begin catch
end catch
begin try
CREATE TABLE  fromFulaatkorrigera ( �gare nvarchar(200), Postadress nvarchar(200), POSTNR nvarchar(200), POSTORT nvarchar(200), [personnr/Organisationnr] nvarchar(200), SOURCE varchar(200), Id INTEGER NOT NULL DEFAULT 0 );;if object_id('tempdb..KorrigeringsIndex') is null begin CREATE INDEX KorrigeringsIndex on  fromFulaatkorrigera(�gare,POSTADRESS,POSTORT,POSTNR,[personnr/Organisationnr],SOURCE,id)end
end try
begin catch
end catch
begin try
    drop table fromCorrigerande
    end try
begin catch
end catch
begin try
    CREATE TABLE  fromCorrigerande (�gare nvarchar(200), Postadress nvarchar(200), POSTNR nvarchar(200), POSTORT nvarchar(200), [personnr/Organisationnr] nvarchar(200), SOURCE varchar(200),Id INTEGER primary key NOT NULL DEFAULT 0);
end try
begin catch
end catch

INSERT INTO  fromFulaatkorrigera(�gare, Postadress, POSTNR, POSTORT,id) VALUES ('Staten FORTIFIKATIONSVERKET', ' ', '63189', 'ESKILSTUNA', 1), ('Staten SVERIGES LANTBRUKSUNIVERSITET', 'Box 7070 ', 'SLU,', '75007 UPPSALA', 2), ('Lasmi AB', 'c/o SANCHES SUAREZ ', N'Gustavsviksv�gen', '36, 62141 VISBY', 3), (N'Kolonif�reningen Kamraterna u.p.a.', 'c/o P JANSSON ', N'LINGV�GEN', '219 LGH 1002, 12361 FARSTA', 4), ('Martin Plahn', N'RUDK�LLAV�GEN 2 ', 'BROLUNDA,', '15534 NYKVARN', 5), ('Kristine Torkelsdotter', 'c/o WESTER ', 'HELLVI', N'MALMS 955, 62450 L�RBRO', 6), ('FRANZISKA SCHNEIDER-STOTZER', N'c/o GRABEN 43294 B�REN A/A', '', 'SCHWEIZ', 7), ('TOMAS SCHNEIDER', N'c/o GRABEN 4,3294 BR�EN A/A', '', 'SCHWEIZ', 8), (N'F�reningen Follingbo Folkets Hus u p a', 'c/o LARS ANDERSSON ', 'STORA', N'T�RNEKVIOR 5, 62137 VISBY', 9), (N'W. Wetterstr�m Smide Mek & R�rledningsfirma Handelsbolag', 'BOX 369 ', N'VITV�RSV�GEN', '3, 62325 LJUGARN', 10), ('Romaklosters pastorat', 'c/o ROMA PASTORSEXPEDITION ', N'VISBYV�GEN', '33 B, 62254 ROMAKLOSTER', 11), (N'Gun Astrid S�rlin', 'c/o WALLIN ', N'STRANDV�GEN', N'29, 62462 F�R�SUND', 12), ('Sirredarre AB', 'c/o LINDA JENSEN ', N'INGENJ�RSV�GEN', '18 LGH 1202, 11759 STOCKHOLM', 14), (N'Niklas Per Emil M�ller', '322 RODNEY STREET APT 17 BROOKLYN .N.Y., USA', '11211', 'BROOKLYN  .N.Y., USA', 15), (N'V�STERHEJDE FOLKETS HUS F�RENING UPA', 'c/o SOCIALDEMOKRATERNA GOTLAND ', N'STENHUGGARV�GEN', '6, 62153 VISBY', 16), (N'Aktiebolaget Lunds All� Visby', N'c/o S�DERSTRAND ', N'BERGGR�ND', '5, 62157 VISBY', 17), (N'VISBY ALLM�NNA IDROTTSKLUBB', 'c/o VISBY AIK ', 'BOX', '1049, 62121 VISBY', 18), (N'Ludvig S�derberg', 'c/o RA EKONOMI AB ', 'HORNSGATAN', '103, 11728 STOCKHOLM', 19), ('Mats Wiktorsson', 'c/o JOVANOVIC ', 'SANKT', 'PAULSGATAN 14 LGH 1205, 11846 STOCKHOLM', 20), ('', 'c/o Ann-Sofie Ekedahl, Vadkastliden 5 ', '45196', 'UDDEVALLA',21), (N'GOTLANDS MOTORF�RENINGS SPEEDWAYKLUBB', '1035 ', '62121', 'VISBY',22), (N'PR�STL�NETILLG�NGAR I VISBY STIFT', 'BOX 1334 ', '62124', 'VISBY',23)
	,(N'VALLS GRUSTAG EK F�R', 'ROSARVE VALL/M ENEKVIST/ ', '62193', 'VISBY',25),
	('Introbolaget 4271 AB', 'c/o EKONOMERNA NB & IC HB ', N'TUV�NGSV�GEN', N'4, 15242 S�DERT�LJE',26);

INSERT INTO  fromFulaatkorrigera(�GARE, POSTADRESS, POSTNR, POSTORT, [personnr/Organisationnr], SOURCE,id) VALUES (N'Lena Nordstr�m', 'RUA EDUARDO HENRIQUES PEREIRA NO 1 ', 'BLOCO', '1, 2 B, 2655-267 ERICEIRA, PORTUGAL', '196204112764', 'geosecma',13), (N'Lena Katarina Nordstr�m', '', '', 'PORTUGAL', '196204112764', 'lagfart',13)
	,('Ingela Karin Spillmann', '', '', 'SCHWEIZ', '194003191246', 'lagfart',24)
	,(N'Kjell-�ke Brob�ck', N'', N'', N'', N'19511204-3236','geosecma',27);

 INSERT INTO  fromCorrigerande(�gare, Postadress, POSTNR, POSTORT,id) VALUES
        (N'Kjell-�ke Brob�ck',N'Dalhem pr�stg�rden 206', '62256', 'DALHEM',27)
	,(N'Aktiebolaget Lunds All� Visby', N'c/o S�DERSTRAND, BERGGR�ND 5','62157','VISBY',17),
	(N'FRANZISKA SCHNEIDER-STOTZER', N'Atelier Stadtgraben, Graben 4', 'CH-3294', N'B�ren an der Aare, SCHWEIZ',7),
	(N'F�reningen Follingbo Folkets Hus u p a ', N'c/o LARS ANDERSSON, STORA T�RNEKVIOR 5','62137', 'VISBY',9),
	(N'GOTLANDS MOTORF�RENINGS', 'SPEEDWAYKLUBB 1035 ', '62121', 'VISBY',22),
	(N'Gun Astrid S�rlin', N'c/o WALLIN, STRANDV�GEN 29', '62462',N'F�R�SUND',12),
	(N'Kolonif�reningen Kamraterna u.p.a.', N'c/o P, JANSSONLINGV�GEN 219 LGH 1002', '12361', 'FARSTA',4),
	(N'Kristine Torkelsdotter','c/o WESTER, HELLVI MALMS 955', '62450', N'L�RBRO',6),
	(N'Lasmi AB c/o SANCHES SUAREZ', N'Gustavsviksv�gen 36','62141', 'VISBY',3),
	(N'Ludvig S�derberg', 'c/o RA EKONOMI AB, HORNSGATAN 103','11728','STOCKHOLM',19),
	(N'Martin Plahn', N'RUDK�LLAV�GEN 2 BROLUNDA', '15534', 'NYKVARN',5),
	(N'Mats Wiktorsson c/o JOVANOVIC', 'SANKT PAULSGATAN 14 LGH 1205','11846','STOCKHOLM',20),
	(N'Niklas Per Emil M�ller', '322 RODNEY STREET APT 17', '11211', 'BROOKLYN .N.Y., USA',15),
	(N'PR�STL�NETILLG�NGAR I', 'VISBY STIFT BOX 1334 ', '62124', 'VISBY',23),
	(N'Romaklosters pastorat', N'c/o ROMA PASTORSEXPEDITION, VISBYV�GEN 33 B', '62254', 'ROMAKLOSTER',11),
	(N'SVERIGES LANTBRUKSUNIVERSITET', 'SLU, Box 7070', '75007', 'UPPSALA',2),
	(N'Sirredarre AB c/o LINDA JENSEN', N'INGENJ�RSV�GEN 18 LGH 1202','11759','STOCKHOLM',14),
	(N'Staten', 'FORTIFIKATIONSVERKET', '63189', 'ESKILSTUNA',1),
	(N'TOMAS SCHNEIDER', N'Atelier Stadtgraben, Graben 4', 'CH-3294', N'B�ren an der Aare, SCHWEIZ',8),
	(N'VISBY ALLM�NNA IDROTTSKLUBB', 'c/o VISBY AIK, BOX 1049','62121','VISBY',18),
	(N'V�STERHEJDE FOLKETS HUS F�RENING UPA', N'c/o SOCIALDEMOKRATERNA GOTLAND, STENHUGGARV�GEN 6', '62153','VISBY',16),
	(N'W. Wetterstr�m Smide Mek & R�rledningsfirma Handelsbolag', N'BOX 369 VITV�RSV�GEN 3','62325', N'LJUGARN',10),
	(N'c/o Ann-Sofie Ekedahl', 'Vadkastliden 5', '45196', 'UDDEVALLA',21),
	(N'VALLS GRUSTAG EK F�R', 'c/o M ENEKVIST, Vall rosarve', '62193', 'VISBY',25),
	('Introbolaget 4271 AB c/o EKONOMERNA NB & IC HB', N'TUV�NGSV�GEN 4', N'15242', N'S�DERT�LJE',26);

INSERT INTO  fromCorrigerande(�GARE, POSTADRESS, POSTNR, POSTORT, [personnr/Organisationnr], SOURCE,id) VALUES
       (N'Lena Nordstr�m', 'RUA EDUARDO HENRIQUES PEREIRA NO 1 BLOCO 1, 2 B', '2655-267','ERICEIRA, PORTUGAL', '196204112764', 'geosecma',13)
       ,('Spillmann Thulin, Ingela', 'Seestrasse 222', '8700', N'K�snacht ZH SCHWEIZ', '194003191246', 'googlade tel.search.ch',24);

    insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end7'));

--o	Vilande � Gem. Anl�ggning
--o	Vilande � kommunal anslutning
--o	V�ntande � uppskov
--o	V�ntande � �verklangande
--SELECT * TOP 3 ANDEL unless noone owns more than 25 then add all
--drop table  fromFulaatkorrigera
--drop table  fromCorrigerande
--DROP INDEX KorrigeringsIndex on  fromCorrigerande