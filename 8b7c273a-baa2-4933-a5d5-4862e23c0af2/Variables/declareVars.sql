declare @inputFnr dbo.KontaktUpgTableType;
declare @arMening as VARCHAR(200) set @arMening = 'Klart vatten - information om avlopp';
declare @diareAr as int set @diareAr = null;
declare @lopNrLargerOrEq as int set @lopNrLargerOrEq = null;
DECLARE @handRubrik1 as NVARCHAR(200)
DECLARE @handRubrik2 as NVARCHAR(200)
set @handRubrik1 = N'%utf�randeintyg'
set @handRubrik2 = N'Ans�kan/anm�lan om enskild cavloppsanl�ggning%';
DECLARE	@HandKat as VARCHAR(50) set @HandKat = N'ANS�KAN';
declare @statusFilter1 as varchar(50) set @STATUSFILTER1 = 'Makulerat';
declare @statusFilter2 as varchar(50) set @STATUSFILTER2 = 'Avslutat';