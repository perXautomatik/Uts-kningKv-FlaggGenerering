# Uts-kningKv-FlaggGenerering

this branch except code to be run from GISDB01, and must therefore call tables internally rather than externaly.

------------------------ Länka med admsql01 --------------------------------------------------------------------------------

USE [master]
GO
EXEC master.dbo.sp_addlinkedserver
    @server = N'admsql01',
    @srvproduct=N'SQL Server' ;
GO

--test
SELECT name FROM [admsql01].master.sys.databases ;

----------------------- general difference from master branche ---

all calls is done explicitly towards gisdb01, we do not use any openquery or exec statements 
we do not need variables therefore.
also, we do not need to make calls to store them locally and call for completion externally.

in main branch, each submodule needs to define there own defenition of input parameters each call to gisdb

this could be avided in this side of the branch.

the v2 aproach of Goto branching into parts of the code would work in this branch, while deemed unsuitable for the mainbranch.
we did however experience major preformance improvements when we made the decision to move from the branching aproach
into separate batch statemetns.

the benefit with this is obeusly less massive calls, less complex subqueries with possible loss in preformance by non indexed tablcalls
( but this didn't seem to limit our mainbranch. )

is it suitable to create temptables in the gisdb01 just like the masterbranch would do to the local db?
if not, would the go to aproach be just as suitable?
it's worth asking our sysadmin what he'd prefere.

one mayor disadvantage of the gisdb01 enviorment is that there is no native connection with admsql01, neither is it suitable, 
this ressults in a need for a very large table being created on side and loaded in separatle as a temptable.
it's rely gretty, 20k lines and i feel absolutetly ashamed even suggesting such an aproach.

one way to aproach that would be to generate the table with tsql, though even that would look more palateable doesn't make it's worht the time.

last and most likely the absolutely smartest apraoch is to generate it on my side, aggregate the admsql lines, filter the input table by the output table.
move some of the aggregating methods over to the oposite side, for the sake of absolutely minimizing the rows that would be written manually.


