select TrackList.track,
       TrackList.Artist,
       TrackList.playcount,
       tracklist2.[Artist name],
       tracklist2.[Track name],
            cast(difference(TrackList.Track, tracklist2.[Track name])+ difference(TrackList.Artist, tracklist2.[Artist name]) as float)
       / cast((SQUARE(POWER(len(tracklist2.[Track name]) - len(TrackList.Track), 4)) + SQUARE(POWER(len(tracklist2.[Artist name]) - len(TrackList.Artist), 4)) + 1) as float) as diff
from
TracksByAlbum as trackList
cross join
FirstDb.dbo.[My Lastfm Playlist_1] as tracklist2

where
      not(
          upper(tracklist2.[Artist name]) = upper(TrackList.Artist)
                                                     and
        upper(tracklist2.[Track name]) = upper(TrackList.Track)
          )

order by diff desc,playcount desc