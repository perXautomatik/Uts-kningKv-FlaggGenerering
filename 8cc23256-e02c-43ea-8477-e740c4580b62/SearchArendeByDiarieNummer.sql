with viewX as (select arende.*,
                   arende.intDiarienummerLoepNummer aIntDiarienummerLoepNummer
            from EDPVisionRegionGotlandAvlopp.dbo.vwAehAerende arende

            where arende.intDiarienummerLoepNummer in
                  (1957,2016,2215,2262,2400,2558,2722,2729)
              and strDiarienummerSerie = 'mbnv')

select * from EDPVisionRegionGotlandAvlopp.dbo.tbAehAerendeData where recAerendeID in (select recAerendeID from viewX)
union
select top 8 * from EDPVisionRegionGotlandAvlopp.dbo.tbAehAerendeData
