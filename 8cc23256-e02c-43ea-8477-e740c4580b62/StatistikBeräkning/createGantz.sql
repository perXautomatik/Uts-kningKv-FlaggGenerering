
declare @KVganttschema2021 table
(
	ar varchar(max),
	event varchar(max),
	veckora varchar(max),
	veckorb varchar(max),
	veckorc varchar(max),
	[from] int,
	fromM int,
	[to] int,
	toM int
);
INSERT INTO @KVganttschema2021 VALUES
 (N'2019', N'Utskick 1, nya socknar', N'V10', N'V11', N'V12', 4, 3, 24, 3)
,(N'2019', N'12 m påm Alskog-Sjonhem', N'V11', null, null, 11, 3, 17, 3)
,(N'2019', N'Förbud 2  L-lunda- G-garn', N'V19', N'V21', N'V23', 6, 5, 9, 6)
,(N'2019', N'Viten', N'V23', N'V24', N'V25', 3, 6, 23, 6)
,(N'2019', N'3 års påm Akebäck mfl', N'V37', null, null, 9, 9, 15, 9)
,(N'2019', N'Förbud 1 Rute-Stenkumla', N'V39', N'V39', N'V39', 23, 9, 29, 9)
,(N'2020', N'Förbud 1 Alskog-Sjonhem', N'V13', N'V14', N'V15', 23, 3, 12, 4)
,(N'2020', N'12 m påm Follingbo-Västerhejde', N'V15', N'V15', N'V15', 6, 4, 12, 4)
,(N'2020', N'Utskick 1maj2020, nya socknar', N'V21', N'V21', N'V21', 18, null, 24, null)
,(N'2020', N'Förbud 2  Akebäck m.fl', N'V37', null, null, 7, 9, 13, 9)
,(N'2020', N'3 års påm Rute-Stenkumla', N'V41', null, null, 5, 10, 11, 10)
,(N'2020', N'Utskick 1, nya socknar', N'V45', N'V46', null, 2, 11, 15, 11)
,(N'2021', N'Påminnelse 3 år Alskog - Sjonhem', N'V09', N'V10', null, 1, 3, 14, 8)
,(N'2021', N'Förbud 1 Follingbo-Västerhejde', N'V14', N'V15', null, 5, 4, 18, 4)
,(N'2021', N'Utskick 1maj, nya socknar', N'V21', N'V22', N'V23', 1, null, 1, null)
,(N'2021', N'Förbud 2  Rute - Stenkumla', N'V36', N'V37', null, 6, 9, 19, 9)
,(N'2021', N'Utskick 1Sept, nya socknar', N'V44', N'V45', N'V46', 11, null, 21, null)
,(N'2021', N'Påminnelse 12 mån Björke - Roma', N'V40', N'V41', null, 4, 10, 17, 10);

