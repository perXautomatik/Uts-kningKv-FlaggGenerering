UPDATE NrMp3PerArtists
SET NumberOffiles = (select top 1 count(c1) from NrMp3PerArtists as l where NrMp3PerArtists.C1 = l.c1 group by l.c1)


