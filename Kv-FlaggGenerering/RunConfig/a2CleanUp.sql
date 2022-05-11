/*todo: if buildTime delta bigger than a day, or if socknar not inside fastigheter
initiate complete rebuild */

if (select null) IS NULL BEGIN TRY Drop table #socknarOfInterest end try begin catch select 'error Drop table #socknarOfInterest' end catch
if (select null) IS NULL BEGIN TRY Drop table #FastighetsYtor end try begin catch select 'error Drop table #FastighetsYtor' end catch
if (select null) IS NULL BEGIN TRY Drop table #ByggnadPåFastighetISocken end try begin catch select 'error Drop table #ByggnadPåFastighetISocken' end catch
if (select null) IS NULL BEGIN TRY Drop table #Socken_tillstånd end try begin catch select 'error Drop table #Socken_tillstånd' end catch
if (select null) IS NULL BEGIN TRY Drop table #egetOmhändertagande end try begin catch select 'error Drop table #egetOmhändertagande ' end catch
if (select null) IS NULL BEGIN TRY Drop table #spillvatten end try begin catch select 'error Drop table #spillvatten' end catch
if (select null) IS NULL BEGIN TRY Drop table #taxekod end try begin catch select 'error Drop table #taxekod ' end catch
if (select null) IS NULL BEGIN TRY Drop table #enatSkikt end try begin catch select 'error Drop table #enatSkikt' end catch
if (select null) IS NULL BEGIN TRY Drop table #FiltreraMotFlaggskiktet  end try begin catch select 'error Drop table #FiltreraMotFlaggskiktet' end catch
go

