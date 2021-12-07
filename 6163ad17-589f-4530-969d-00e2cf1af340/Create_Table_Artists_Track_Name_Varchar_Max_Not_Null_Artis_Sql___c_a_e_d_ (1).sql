.read last.fm.sql;
create table [Artists 2019-05-24]
(
	Track_name varchar(max) not null,
	Artist_name nvarchar(1),
	Album nvarchar(1),
	Playlist_name nvarchar(50) not null,
	Type nvarchar(50) not null
)
go

