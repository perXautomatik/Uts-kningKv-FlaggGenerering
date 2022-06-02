create table #socknarOfInterest (Socken nvarchar (100) not null , shape geometry)
insert into #socknarOfInterest
select SOCKEN,Shape from
          STRING_SPLIT(N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma', ',')
	   socknarOfIntresse
          inner join
              sde_regionstyrelsen.gng.nyko_socknar_y_evw
                  on SOCKEN = value
