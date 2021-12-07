--Stringsplit
declare @stringSplitVar1 varchar(10) = '</x>'; declare @stringSplitVar2 varchar(10) = '<x>'; declare @stringSplitDelim varchar(10) = ',';

--OnskadeHandlingar
IF OBJECT_ID('tempdb..#OnskadeHandlingar') IS NOT NULL DROP TABLE #OnskadeHandlingar create table #OnskadeHandlingar ( namn varchar(max) )
declare @toSplit as table (toSplit nvarchar(max)) insert into @toSplit select
     N'Reviderad ans�kan ensklit avlopp' +
    N',Reviderad ans�kan' +
    N',Kompletteringsbeg�ran skickad' +
    N',Kompletteringsbeg�ran' +
    N',Komplettering-situationsplan' +
    N',Komplettering' +
    N',situationsplan' +
    N',Komplettering' +
    N',Komplett ans�kan' +
    N',Beslut om enskild avloppsanl�ggning BDT+ WC' +
    N',Beslut om enskild avloppsanl�ggning BDT + Tank' +
    N',Besiktningsprotokoll - provgrop' +
    N',Avlopp - utf�randeintyg' +
    N',Ans�kan/anm�lan om enskild avloppsanl�ggning' +
    N',Ans�kan med underskrift'
insert into #OnskadeHandlingar SELECT distinct SplitValue FROM  (select toSplit from @toSplit) q Cross Apply ( Select Seq   = Row_Number() over (Order By (Select null)) ,SplitValue = v.value('(./text())[1]', 'varchar(max)') From  (values (convert(xml,@stringSplitVar2 + replace(toSplit,@stringSplitDelim,@stringSplitVar1+@stringSplitVar2)+@stringSplitVar1))) x(n) Cross Apply n.nodes('x') node(v) ) B delete from @toSplit where toSplit is not null
