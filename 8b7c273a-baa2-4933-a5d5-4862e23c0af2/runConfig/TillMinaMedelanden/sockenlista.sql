use [tempExcel]
insert into dbo.resultatRunConf  (dnr) values ('sockenlista')


if object_id('tempdb..##SockenLista') is null begin
    CREATE table tempdb.dbo.##SockenLista (socken NVARCHAR(50) NOT NULL PRIMARY KEY)
    INSERT
    INTO tempdb.dbo.##SockenLista
    VALUES
--(N'Kr�klingbo'),('Alskog'),('Lau'),(N'N�r'),('Burs'),('Sjonhem')
	('Follingbo')
	 , ('Hejdeby')
	 , ('Lokrume')
	 , ('Martebo')
	 , (N'Tr�kumla')
	 , ('Visby')
	 , (N'V�sterhejde')
end
;


;

