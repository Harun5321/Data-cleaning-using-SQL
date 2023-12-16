--This is a historical dataset on the modern Olympic Games,120 years of Olympics History dataset  downloaded from Kaggle,
--including all the Games from Athens 1896 to Rio 2016, & i will be using SQL to answer some common questions that can be derived from this dataset.



 --QUestion 1
--1. How many olympics games have been held?
select COUNT(DISTINCT(Games)) as Total_olympic_games
from Portfolio_projects..athlete_events


 --QUestion 2
--2. List down all Olympics games held so far.

select DISTINCT(Year),Season, City
from Portfolio_projects..athlete_events
ORDER BY 1


 --QUestion 3
--3. Mention the total no of nations which participated in each of the olympics games?

WITH All_countries AS (
	select games,nr.region
from Portfolio_projects..athlete_events av JOIN Portfolio_projects..noc_regions nr
ON av.NOC = nr.NOC
GROUP BY Games, nr.region

)

SELECT Games, COUNT(Games) AS Total_countries
from All_countries
GROUP BY Games
ORDER BY Games


 --QUestion 4
--4. Which year saw the highest and lowest no of countries participating in olympics

      with all_countries as
              (select games, nr.region
              from athlete_events oh
              join noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          tot_countries as
              (select games, count(1) as total_countries
              from all_countries
              group by games)
      select distinct
      concat(first_value(games) over(order by total_countries)
      , ' - '
      , first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
      concat(first_value(games) over(order by total_countries desc)
      , ' - '
      , first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
      from tot_countries
      order by 1;


--QUestion 5
--Which nation has participated in all of the olympic games

WITH Tot_games AS
	(select COUNT(DISTINCT(Games)) AS Total_games
	from athlete_events),
	countries AS 
	(select games,nr.region AS country
	FROM athlete_events ae JOIN noc_regions nr ON  nr.NOC = ae.NOC
	GROUP BY Games, nr.region),
	countries_participated AS (
	SELECT country, COUNT(1) AS total_participated_games
	from countries
	GROUP BY country
	)

 select cp.*
 from countries_participated cp
 join tot_games tg on tg.total_games = cp.total_participated_games
 order by 1;


 --QUestion 6
 -- Identify the sport which was played in all summer olympics.


WITH t1 as 
		(select COUNT(Distinct games) AS Total_games
		from Portfolio_projects..athlete_events
		Where Season = 'Summer'),
		t2 as 
		(select Distinct games, Sport 
		from Portfolio_projects..athlete_events
		Where Season = 'Summer'),
		t3 as 
		(select Sport ,COUNT(1) AS No_of_games
		from t2
		GROUP BY Sport)

select *
from t3
join t1 on t1.total_games = t3.no_of_games;


 --QUestion 7
--Which Sports were just played only once in the olympics.

WITH t1 AS 
		(SELECT DISTINCT games, Sport
		from Portfolio_projects..athlete_events),
	t2 AS 
		(SELECT Sport, COUNT(1) AS no_of_games
		from t1
		GROUP BY Sport)


SELECT t2.*, t1.games
from t2 JOIN t1 ON t1.sport = t2.sport
WHERE t2.no_of_games = 1
ORDER BY t1.sport

 --QUestion 8
 -- Fetch the total no of sports played in each olympic games

WITH t1 AS
		(SELECT DISTINCT Games, Sport
		from Portfolio_projects..athlete_events),
		t2 AS
		(SELECT Games, COUNT(1) AS no_of_sports
		from t1
		GROUP BY Games)

		
SELECT * from t2
ORDER BY no_of_sports DESC

 --QUestion 9
 -- Fetch oldest athletes to win a gold medal

WITH Temp AS (
    SELECT 
        name, 
        sex,
        CASE 
            WHEN TRY_CAST(Age AS FLOAT) IS NOT NULL THEN CAST(Age AS INT)
            ELSE 0
        END AS Age,
        team, 
        games, 
        city, 
        sport, 
        event, 
        medal 
    FROM Portfolio_projects..athlete_events
),
Ranking AS (
    SELECT 
        *, 
        DENSE_RANK() OVER (ORDER BY Age DESC) AS rank
    FROM Temp
    WHERE Medal = 'Gold'
)

SELECT * 
FROM Ranking
--where rank = 1
Where Age  >=60










