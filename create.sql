create schema music_site

set search_path to music_site

--создаем специальный тип данных, с действующим огранием по дате
create domain "year" as integer CHECK (VALUE >= 1000 AND VALUE <= 2155); 

create table author (
	author_id serial primary key,
	author_name varchar(50) not null,
	nickname varchar(50) not null,
	birthday date not null check(date_part('year', birthday) > 1000)
)

create table album (
	album_id serial primary key,
	album_name varchar(50) not null,
	create_date "year" not null
)

create table genre (
	genre_id serial primary key,
	genre_name varchar(50) not null unique
)

create table track (
	track_id serial primary key,
	track_name varchar(50) not null,
	duration numeric(4,2) not null,
	album_id int not null references album(album_id)
)


create table album_author (
	album_id int2 not null references album(album_id),
	author_id int2 not null references author(author_id),
	primary key (album_id, author_id)
)


create table author_genre (
	genre_id int2 not null references genre(genre_id),
	author_id int2 not null references author(author_id),
	primary key (genre_id, author_id)
)


create table playlist (
	list_id serial primary key,
	playlist_name varchar(100) not null,
	create_date "year" not null
)

create table track_playlist (
	track_id int2 not null references track(track_id), 
	list_id int2 not null references playlist(list_id),
	primary key (track_id, list_id)
)






