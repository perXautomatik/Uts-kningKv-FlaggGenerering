declare @stringSplitVar1 varchar(10) = '</x>'; declare @stringSplitVar2 varchar(10) = '<x>'; declare @stringSplitDelim varchar(10) = ',';

IF OBJECT_ID('tempdb..#sockNarOFIntresse') IS NOT NULL DROP TABLE #sockNarOFIntresse create table #sockNarOFIntresse ( namn varchar(max) )
insert into @toSplit
select N'%ollingbo%,' +
       N'%ejdeby%,' +
       N'%okrume%,' +
       N'%artebo%,' +
       N'%räkumla%,' +
       N'%isby%,' +
       N'%ästerhejde%'
insert into #sockNarOFIntresse SELECT distinct SplitValue FROM  (select toSplit from @toSplit) q Cross Apply ( Select Seq   = Row_Number() over (Order By (Select null)) ,SplitValue = v.value('(./text())[1]', 'varchar(max)') From  (values (convert(xml,@stringSplitVar2 + replace(toSplit,@stringSplitDelim,@stringSplitVar1+@stringSplitVar2)+@stringSplitVar1))) x(n) Cross Apply n.nodes('x') node(v) ) B