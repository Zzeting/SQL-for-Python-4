--количество исполнителей в каждом жанре;
select g.genre_name, count(a.author_id)
from genre g 
left join author_genre ag on ag.genre_id = g.genre_id 
left join author a on a.author_id = ag.author_id 
group by g.genre_id 

--количество треков, вошедших в альбомы 2019-2020 годов;
select count(t.track_id) 
from album a
join track t on t.album_id = a.album_id 
where a.create_date between 2019 and 2020

--средняя продолжительность треков по каждому альбому;
select a.album_name, round(avg(t.duration), 2)
from album a
join track t on t.album_id = a.album_id 
group by a.album_id  

--все исполнители, которые не выпустили альбомы в 2020 году;
select a2.nickname 
from (
	select aa.author_id
	from album_author aa 
	except
	select aa.author_id 
	from album a 
	join album_author aa on aa.album_id = a.album_id 
	where a.create_date = 2020) t
join author a2 on a2.author_id = t.author_id


--названия сборников, в которых присутствует конкретный исполнитель (выберите сами);

select p.playlist_name, a2.author_name 
from playlist p 
join track_playlist tp on tp.list_id  = p.list_id 
join track t on t.track_id = tp.track_id 
join album a on a.album_id = t.album_id 
join album_author aa on aa.album_id = a.album_id 
join author a2 on a2.author_id = aa.author_id 
where a2.author_id = 2


--название альбомов, в которых присутствуют исполнители более 1 жанра;
--при вложенном запросе цена выполнения запроса намного ниже
--explain analyze  -- cost 99.71
select a2.album_name
from (
	select a.author_id  
	from author a 
	join author_genre ag on ag.author_id = a.author_id 
	group by a.author_id  
	having count(ag.genre_id) > 1) t
join album_author aa on aa.author_id = t.author_id
join album a2 on a2.album_id = aa.album_id 

--explain analyze -- cost 1964.71
select a.album_name
from album a 
join album_author aa on aa.album_id = a.album_id 
join author a2 on a2.author_id = aa.author_id 
join author_genre ag on ag.author_id = a2.author_id 
group by ag.author_id, a.album_id 
having count(ag.genre_id) > 1 

--наименование треков, которые не входят в сборники;
select t.track_name 
from track t 
left join track_playlist tp on tp.track_id = t.track_id 
left join playlist p on p.list_id = tp.list_id 
where tp.list_id is null


--исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);
--в результате два исполнителя, поскольку они являяются авторами одного альбоома с данным треком

select a.author_name 
from album_author aa 
join author a on a.author_id = aa.author_id 
join album a2 on a2.album_id = aa.album_id 
join track t on t.album_id = a2.album_id
where t.duration = (select min(t2.duration) from track t2)


--название альбомов, содержащих наименьшее количество треков.
--т.к. альбомов может быть несколько
--сперва получаем наименьшее число треков в альбоме, потом сравниваем альбомы где количество треков равно данному числу
-- также можно решить данную задачу с помощью row_number
select a2.album_name
from album a2 
join track t2 on t2.album_id = a2.album_id 
group by a2.album_id 
having count(t2.track_id) = (select count(t.track_id)
							 from album a 
							 join track t on a.album_id = t.album_id 
							 group by a.album_id 
							 order by count(t.track_id)
							 limit 1)

