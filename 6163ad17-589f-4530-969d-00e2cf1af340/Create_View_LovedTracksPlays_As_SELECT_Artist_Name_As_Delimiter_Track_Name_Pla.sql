create view LovedTracksPlays as SELECT [Artist name], ' - ' as delimiter, [Track name], plays, library.datex
FROM database_name.dbo.[My Lastfm Playlist_1] t
         join (SELECT l.track, l.artist, count(1) as plays, max(l.uts) as datex
               FROM database_name.dbo.EveryLastFmplay l
               group by l.track, l.artist) library
              on t.[Artist name] = artist and t.[Track name] = library.track;
go


