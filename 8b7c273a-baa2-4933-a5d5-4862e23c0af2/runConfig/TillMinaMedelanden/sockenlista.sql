use [tempExcel]
insert into dbo.resultatRunConf  (dnr) values ('sockenlista')


if object_id('tempdb..##SockenLista') is null begin
    CREATE table tempdb.dbo.##SockenLista (socken NVARCHAR(50) NOT NULL PRIMARY KEY)
    INSERT
    INTO tempdb.dbo.##SockenLista
    VALUES
--(N'Kräklingbo'),('Alskog'),('Lau'),(N'När'),('Burs'),('Sjonhem')
	('Follingbo')
	 , ('Hejdeby')
	 , ('Lokrume')
	 , ('Martebo')
	 , (N'Träkumla')
	 , ('Visby')
	 , (N'Västerhejde')
end
;


;

