use [tempExcel]
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'sockenlista9'))
   begin try

if object_id('tempdb..SockenLista') is null begin
    CREATE table SockenLista (socken NVARCHAR(50) NOT NULL PRIMARY KEY)
    INSERT
    INTO SockenLista
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

end try
begin catch
    print ERROR_line()
end catch
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end9'));

