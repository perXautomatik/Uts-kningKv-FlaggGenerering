CREATE VIEW ToCorrectAlbumName AS
select albumless.artist,
       albumless.track,
       albumless.playcount as playCountWithoutAlbum,
       album,
       TracksByAlbum.playcount as playCountTotal,

         CAST(albumless.playcount AS float) / CAST(TracksByAlbum.playcount AS float) as urgence,
url
from
     (select
       LastFmDataDump.artist,
       LastFmDataDump.track,
       count(1) as playcount

from FirstDb.dbo.LastFmDataDump
where LastFmDataDump.album = ''
group by LastFmDataDump.artist,
       LastFmDataDump.track) as albumless

left outer join TracksByAlbum on TracksByAlbum.artist = albumless.artist and TracksByAlbum.track = albumless.track
where album  <> ''
