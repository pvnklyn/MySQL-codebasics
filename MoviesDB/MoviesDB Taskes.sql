#TASK-1
#1. Print all movie titles and release year for all Marvel Studios movies.
#2. Print all movies that have Avenger in their name.
#3. Print the year when the movie "The Godfather" was released.
#4. Print all distinct movie studios in the Bollywood industry.

use moviesdb;

select title,release_year from movies where studio='Marvel Studios';

select * from movies where title like '%avenger%';

select release_year from movies where title ='the godfather';

select distinct studio from movies where industry='bollywood';

#TASK-2
#1. Print all movies in the order of their release year (latest first)
#2. All movies released in the year 2022
#3. Now all the movies released after 2020
#4. All movies after the year 2020 that have more than 8 rating
#5. Select all movies that are by Marvel studios and Hombale Films
#6. Select all THOR movies by their release year
#7. Select all movies that are not from Marvel Studios

select * from movies order by  release_year desc;

select * from movies where release_year = 2022;

select * from movies where release_year>2020;

select * from movies where release_year>2020 and imdb_rating>8;

select * from movies where studio in  ('Marvel studios', 'Hombale Films');

select title, release_year from movies where title like '%thor%' order by release_year asc;

select * from movies where studio != 'marvel studios';

#TASK-3/1
#1. How many movies were released between 2015 and 2022
#2. Print the max and min movie release year
#3. Print a year and how many movies were released in that year starting with the latest year

select * from movies
select count(*) from movies where release_year between 2015 and 2022

select max(release_year) , min(release_year) from movies 

select relese_year, count(*) as cnt 

select release_year, count(release_year) as movies_count 
from movies group by release_year order by release_year desc

#TASK-3/2
#Print profit % for all the movies  
select *, 
    (revenue-budget) as profit, 
    (revenue-budget)*100/budget as profit_pct 
   from financials
 
 #TASK-4/1
#1. Show all the movies with their language names
#2. Show all Telugu movie names (assuming you don't know the language id for Telugu)
#3. Show the language and number of movies released in that language
 
 select language_id,name, title
from movies inner join languages 
using(language_id)

select m.language_id,title,name
from movies m inner join languages l
on m.language_id=l.language_id
order by language_id desc

select m.language_id,title,name
from movies m left join languages l
on m.language_id=l.language_id
where l.name='telugu'

select l.name,count(movie_id) as no_movies
from languages l left join movies m 
using (language_id)
group by language_id
order by no_movies desc

#TASK-4/2
/*Generate a report of all Hindi movies sorted by their revenue amount in millions.
 Print movie name, revenue, currency, and unit*/

select title, revenue, currency, unit,
case
 when unit='thousands' then round(revenue/1000,1)
 when unit='billions' then round(revenue*1000,1)
 else round(revenue,1)
end as revenue_mln
from movies m
join financials f on m.movie_id=f.movie_id
join languages l on m.language_id=l.language_id
where name= 'hindi'
order by revenue_mln desc

#TASK-5/1
#1. 
/*Select all the movies with minimum and maximum release_year. 
Note that there can be more than one movie in min and a max year hence output rows can be more than 2*/
#2. Select all the rows from the movies table whose imdb_rating is higher than the average rating

#1
select title, release_year 
from movies where release_year in ((select max(release_year) from movies),(select min(release_year) from movies));

#2
select * from movies where imdb_rating > (select avg(imdb_rating) from movies);

#TASK-5/2
/*Select all Hollywood movies released after the year 2000 that made more than 500 million $ profit or more profit. 
Note that all Hollywood movies have millions as a unit hence you don't need to do the unit conversion. 
Also, you can write this query without CTE as well but you should try to write this using CTE only*/

with cte as
(select title, release_year,(revenue-budget) as profit
 from movies m
 join financials f
 on m.movie_id=f.movie_id
 where release_year>2000 and industry='hollywood')
 select * from cte where profit>500



