use [tempExcel]
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'excluded3'))
begin try
    drop table excluded;
    end try
begin catch
    print ERROR_line()
end catch
    begin try
        CREATE table  excluded (dia VARCHAR(50),fas VARCHAR(50)
        unique (dia,fas)
        )
        end try
begin catch
    print ERROR_line()
end catch
begin try
	INSERT INTO  excluded (FAS)
	VALUES
	(N'TRÄKUMLA TJÄNGDARVE 1:27'),
	(N'FOLLINGBO ROSENDAL 1:40'),
	(N'FOLLINGBO SLÄTTFLISHAGE 4:1'),
	(N'FOLLINGBO SLÄTTFLISHAGE 2:2'),
	(N'FOLLINGBO SYLFASTE 1:15'),
	(N'FOLLINGBO SYLFASTE 1:19'),
	(N'FOLLINGBO TINGSTOMT 1:20'),
	(N'FOLLINGBO KLINTE 1:64'),
	(N'TRÄKUMLA INGVARDS 1:59'),
	(N'VISBY ANNELUND 1:20'),
	(N'VISBY GUSTAVSVIK 1:13'),
	(N'VISBY SNÄCKGÄRDET 1:30')
end try
begin catch
    print ERROR_line()
end catch
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end3'));