begin
	declare @inputFnr KontaktUpgTableType
	insert into @inputFnr (id,Diarienummer,Fnr,fastighet,Händelsedatum) values (

1,'MBNV-2019-3863',90023816,'HELLVI VIVLINGS 1:99',getdate()),(
2,'MBNV-2019-3945',90039926,'RUTE STORA VALLE 1:11',getdate()),(
3,'MBNV-2019-3871',90022997,'HELLVI ANNEX 1:1',getdate()),(
4,'MBNV-2019-4176',90039597,'RUTE FARDUME 1:9',getdate()),(
5,'MBNV-2019-3944',90039929,'RUTE STORA VALLE 1:14',getdate()),(
6,'MBNV-2019-3892',90039842,'RUTE RISUNGS 1:13',getdate()),(
7,'MBNV-2019-4013',90040011,'RUTE TALINGS 1:20',getdate()),(
8,'MBNV-2019-3771',90023833,'HELLVI VIVLINGS 1:116',getdate()),(
9,'MBNV-2019-3837',90023800,'HELLVI VIVLINGS 1:83',getdate())


    ;with q as (
	    select (case when namn is null then 1 else 0 end)+(case when POSTNR is null then 1 else 0 end)+(case when postort is null then 1 else 0 end)+(case when adress is null then 1 else 0 end)+(case when PERSORGNR is null then 1 else 0 end) badness, FNR, PERSORGNR, ANDEL, NAMN, INSKDATUM, ADRESS, POSTORT, POSTNR, SOURCE
	    from fn_FnrToAdress(@inputFnr)),

    qt as (select *
            from q where badness < 2)

    select * from q
    --where Diarienummer not in (select Diarienummer from qt)
    --union select * from qt

    order by badness
           --, Diarienummer

end