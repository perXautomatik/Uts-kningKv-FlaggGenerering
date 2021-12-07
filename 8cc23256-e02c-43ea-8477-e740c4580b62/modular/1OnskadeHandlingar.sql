--Stringsplit
declare @stringSplitVar1 varchar(10) = '</x>'; declare @stringSplitVar2 varchar(10) = '<x>'; declare @stringSplitDelim varchar(10) = ',';

--OnskadeHandlingar
IF OBJECT_ID('tempdb..#OnskadeHandlingar') IS NOT NULL DROP TABLE #OnskadeHandlingar create table #OnskadeHandlingar ( namn varchar(max) )
declare @toSplit as table (toSplit nvarchar(max)) insert into @toSplit select
     N'Reviderad ansökan ensklit avlopp' +
    N',Reviderad ansökan' +
    N',Kompletteringsbegäran skickad' +
    N',Kompletteringsbegäran' +
    N',Komplettering-situationsplan' +
    N',Komplettering' +
    N',situationsplan' +
    N',Komplettering' +
    N',Komplett ansökan' +
    N',Beslut om enskild avloppsanläggning BDT+ WC' +
    N',Beslut om enskild avloppsanläggning BDT + Tank' +
    N',Besiktningsprotokoll - provgrop' +
    N',Avlopp - utförandeintyg' +
    N',Ansökan/anmälan om enskild avloppsanläggning' +
    N',Ansökan med underskrift'
insert into #OnskadeHandlingar SELECT distinct SplitValue FROM  (select toSplit from @toSplit) q Cross Apply ( Select Seq   = Row_Number() over (Order By (Select null)) ,SplitValue = v.value('(./text())[1]', 'varchar(max)') From  (values (convert(xml,@stringSplitVar2 + replace(toSplit,@stringSplitDelim,@stringSplitVar1+@stringSplitVar2)+@stringSplitVar1))) x(n) Cross Apply n.nodes('x') node(v) ) B delete from @toSplit where toSplit is not null
