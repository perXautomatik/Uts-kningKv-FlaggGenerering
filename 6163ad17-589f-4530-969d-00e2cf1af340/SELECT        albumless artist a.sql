SELECT
       albumless.artist, albumless.track, albumless.playcount AS playCountWithoutAlbum, dbo.TracksByAlbum.album, dbo.TracksByAlbum.playcount AS playCountTotal, CAST(albumless.playcount AS float)
                         / CAST(dbo.TracksByAlbum.playcount AS float) AS urgence,
       dbo.TracksByAlbum.url
FROM
     (SELECT        LastFm.artist, LastFm.track, COUNT(1) AS playcount
                          FROM            database_name.dbo.LastFm
                          WHERE        (LastFm.album = '')
                          GROUP BY LastFm.artist, LastFm.track) AS albumless LEFT OUTER JOIN
                         dbo.TracksByAlbum ON dbo.TracksByAlbum.artist = albumless.artist AND dbo.TracksByAlbum.track = albumless.track
WHERE
      (dbo.TracksByAlbum.album <> '')