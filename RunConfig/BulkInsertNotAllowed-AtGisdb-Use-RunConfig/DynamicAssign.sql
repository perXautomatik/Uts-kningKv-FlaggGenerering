 create function dynamicASigne returning varchar
    begin
        for each row in #varsToAssigne
            exec 'declare @' + @dig + ' Nvarchar(max)'
        
        for each row in #varsToAssigne
            exec 'set @' + @dig + '=' + char() + (select RowVal) + char()
        
        for each row in #varsToAssigne
            set @dynamicVariableAsignment = @dynamicVariableAsignment + ',@' + @dig + '=@' + (select RowVal)        
    end
