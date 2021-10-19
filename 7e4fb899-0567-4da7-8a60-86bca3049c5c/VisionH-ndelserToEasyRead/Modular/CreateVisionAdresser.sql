--should be a tempTable rather than a function?

create function dbo.visionAdresser(@tp1 KontaktUpgTableType READONLY, @tp2 KontaktUpgTableType readonly)
    returns table as
        return
        select *
        from (select *, row_number() over (partition by diarienummer order by CC_priox desc) dqweq
              from (
                       select Diarienummer,
                              max(Fnr)           fnr,
                              max(Händelsedatum) datum,
                              Namn,
                              Postnummer,
                              Postort,
                              Gatuadress,
                              personnr,
                              harNamn,
                              row_number() over (partition by diarienummer order by max(Händelsedatum)) *
                              max(CC_prio)       CC_priox
                       from (
                                select *
                                from (select z.*
                                      from (select Diarienummer from @tp1 union select Diarienummer from @tp2) unx
                                               left outer join @tp1 z on unx.Diarienummer = z.Diarienummer) as sa
                                where harNamn = 1
                                union
                                select *
                                from (select z.*
                                      from (select Diarienummer
                                            from (select z.Diarienummer, harNamn
                                                  from (select Diarienummer from @tp1 union select Diarienummer from @tp2) unx
                                                           left outer join @tp1 z on unx.Diarienummer = z.Diarienummer) as sa
                                            where harNamn = 0
                                           ) unx
                                               left outer join @tp2 z on unx.Diarienummer = z.Diarienummer) as sa
                                where harNamn = 1) we
                       group by Diarienummer, namn, Postnummer, Postort, Gatuadress, personnr, harNamn) as w) as ad
        where dqweq = 1

go
    PRINT 'Error Number: ' + str(error_number()); PRINT 'Line Number: ' + str(error_line()); PRINT error_message();
GO