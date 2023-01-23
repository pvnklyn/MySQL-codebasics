#class-1
use moviesdb;
SELECT * FROM moviesdb.movies;
select count(*) from movies where industry='bollywood';
select * from movies where industry='bollywood';
select distinct industry from movies ;
select * from movies where title like '%thor%';
select * from movies where title like '%america%';
select * from movies where studio=''

#class-2/1
SELECT * FROM movies;
select round(avg(imdb_rating),2) as avg_rating from movies where studio ='marvel studios'

select studio, 
count(studio) as cnt 
from movies 
where studio!=''
group by studio 
order by cnt desc

select studio, 
count(studio) as cnt, 
round(avg(imdb_rating),1) as avg_rating 
from movies 
where studio!='' 
group by studio 
order by avg_rating desc

#class-2/2
select *,year(curdate())-birth_year as age from actors

select *, (revenue-budget) as profit from financials

select *,
if(currency='usd',revenue*77,revenue) as revenue_inr 
from financials


SELECT *,
CASE
WHEN unit="thousands" THEN revenue/1000
WHEN unit="billions" THEN revenue*1000
ELSE revenue
END as revenue_mln
FROM financials;


#class-3/1
select m.movie_id, title,budget, revenue,unit,currency
from movies m
inner join financials f
on m.movie_id=f.movie_id and m.col2=f.col2;

select m.movie_id, title,budget, revenue,unit,currency
from movies m
left join financials f
on m.movie_id=f.movie_id

select f.movie_id, title,budget, revenue,unit,currency
from movies m
right join financials f
on m.movie_id=f.movie_id

select m.movie_id, title,budget, revenue,unit,currency
from movies m left join financials f on m.movie_id=f.movie_id
union
select f.movie_id, title,budget, revenue,unit,currency
from movies m right join financials f on m.movie_id=f.movie_id

select movie_id,title,budget,revenue,unit,currency
from movies left join financials 
using(movie_id)

select m.movie_id,title,budget,revenue,currency,unit,
case
 when unit='thousands' then round((revenue-budget)/1000,1)
 when unit='billions' then round((revenue-budget)*1000,1)
 else round(revenue-budget,1)
end as profit_mln
from movies m 
join financials f on m.movie_id=f.movie_id
where industry='bollywood'
order by profit_mln desc


#class3/2
select m.movie_id,title, group_concat(name separator'  |  ') as actor
from movies m
join movie_actor ma on m.movie_id=ma.movie_id
join actors a on a.actor_id=ma.actor_id
group by m.movie_id

select  name, 
group_concat(title separator '  |  ') as actors,
count(title) as movie_count
from actors a
join movie_actor ma on ma.actor_id=a.actor_id
join movies m on m.movie_id=ma.movie_id
where industry='bollywood'
group by a.actor_id
order by movie_count desc


#class-4
# subquery  for single value
select * from movies where imdb_rating=(select max(imdb_rating) from movies)
select * from movies where imdb_rating=(select min(imdb_rating) from movies)

# subquery  for single value
select* from movies where imdb_rating in ((select max(imdb_rating) from movies), (select min(imdb_rating) from movies))

# subquery  for table
select* from
(select name, year(curdate())-birth_year as age from actors) as actors_age
where age>70 and age<85


# ANY
select * from actors where actor_id = any (select actor_id from movie_actor where movie_id in (101,110,121)) 
# ALL
select * from movies where imdb_rating >  (select imdb_rating from movies where studio='marvel studios')

# co_related subquery
# explain analyze
select actor_id, name, 
(select count(*) from movie_actor where actor_id=actors.actor_id) as movies_count
from actors order by movies_count desc

# other way for doing this
explain analyze
select a.actor_id, name, count(*) as movie_count
from actors a
join movie_actor ma on a.actor_id = ma.actor_id
group by actor_id order by movie_count desc


#CTE(common table expression)
with actor_age as
(select name as actor_name,year(curdate())-birth_year as age from actors)
select actor_name,age from actor_age
where age>70 and age<85


Select x.movie_id, x.pct_profit, y.title, y.imdb_rating
from (select *, (revenue-budget)*100/budget as pct_profit
from financials) x
join (select * from movies
where imdb_rating<(select avg(imdb_rating) from movies)) y
on x.movie_id = y.movie_id
where pct_profit >= 500

# CTE MODEL
with 
x as (select *,(revenue-budget)*100/budget as pct_profit from financials),
y as (select * from movies where imdb_rating<(select avg (imdb_rating) from movies))
Select x.movie_id, x.pct_profit, y.title, y.imdb_rating
from x
join y
on x.movie_id = y.movie_id
where pct_profit >= 500

#class-5/1
SELECT * FROM superstore_db.items
where properties->'$.gluten_free'=1;

SELECT * FROM superstore_db.items
where isnull(properties->'$.gluten_free')

SELECT * FROM superstore_db.items
where properties->'$.color'='blue'

SELECT * FROM superstore_db.items
where json_extract(properties,'$.color')='blue'

select *,
st_astext(location) as location
 from sakila.address


#class-5/2
SELECT * FROM moviesdb.movies;
INSERT INTO moviesdb.movies (`title`) VALUES ('ppp');
UPDATE moviesdb.movies SET release_year= 2027 , studio= 'PK_Productions', imdb_rating= 9.2 where (movie_id ='141');
create database my_db;
drop database my_db;
