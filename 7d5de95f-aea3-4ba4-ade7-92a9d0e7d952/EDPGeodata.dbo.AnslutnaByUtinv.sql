select Anläggningstyp, min(Volym), max(Volym) from
     EDPGeodata.dbo.AnslutnaByUtinv group by Anläggningstyp