
;if object_id('tempdb..##SockenLista') is null begin CREATE table ##SockenLista (socken NVARCHAR(50) NOT NULL PRIMARY KEY ) INSERT INTO ##SockenLista VALUES
--(N'Kr�klingbo'),('Alskog'),('Lau'),(N'N�r'),('Burs'),('Sjonhem')
    ('Follingbo'),('Hejdeby'),('Lokrume'),('Martebo'),(N'Tr�kumla'),('Visby'),(N'V�sterhejde')
end
