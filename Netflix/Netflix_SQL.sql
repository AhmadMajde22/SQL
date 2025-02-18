SELECT * FROM netflix;

-- P1:Count the Number of Movies vs TV Shows
SELECT 
    type,
    COUNT(*) as Numbers
FROM netflix
GROUP BY 1;

-- P2:Find the Most Common Rating for Movies and TV Shows
SELECT 
	type,
	rating
FROM(
SELECT 
	type,
	rating,
	count(*) as Most_Common,
	RANK() OVER (PARTITION BY TYPE ORDER BY count(*) DESC) as ranking
FROM netflix
GROUP BY 1,2)
WHERE ranking = 1


-- P3:List All Movies Released in a Specific Year

SELECT * 
FROM 
	netflix
Where TYPE = 'Movie' AND release_year = '2020'

--P4: Find the Top 5 Countries with the Most Content on Netflix

SELECT 
	country,
	COUNT(*)
FROM netflix
WHERE country is not Null
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5 ;


-- Sperate the countries that groupped togather

SELECT 
	LTRIM(UNNEST(STRING_TO_ARRAY(country,','))) as new_country,
	COUNT(*)
FROM 
	Netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5 ;

-- P5:Identify the Longest Movie

SELECT 
	title,
	duration
FROM netflix
WHERE type = 'Movie' and duration is not null
ORDER BY duration DESC;

-- P6:Find Content Added in the Last 5 Years

SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- P7:Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT *
FROM 
	netflix
WHERE DIRECTOR LIKE '%Rajiv Chilaka%';

-- p8:List All TV Shows with More Than 5 Seasons

SELECT *
FROM
	netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration,' ',1)::INT > 5;



-- P9:Count the Number of Content Items in Each Genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genere,
	COUNT(*)
FROM netflix
GROUP BY genere 
ORDER BY 2 DESC;

-- P10:Find each year and the average numbers of content release in India on netflix.

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as YEAR,
	COUNT(*),
	ROUND(COUNT(*)::numeric/(SELECT count(*) FROM netflix where country = 'India'),3)::numeric *100 as AVG_content_Percentage
FROM 
	netflix
WHERE 
	country = 'India'
GROUP BY 1
ORDER BY 3 DESC;

-- P11:List All Movies that are Documentaries

SELECT * 
FROM	
	netflix
WHERE 
	listed_in ILIKE '%Documentaries%';

-- P12:Find All Content Without a Director

SELECT *
FROM netflix
WHERE director IS NULL;

-- P13:Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%' AND   TO_DATE(date_added,'Month DD, YYYY') >=CURRENT_DATE - INTERVAL '5 Years';


-- P14:Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country ILIKE 'India'
GROUP BY actor
ORDER BY 2 DESC
LIMIT 10;


-- P15:Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords


SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;

------------------------------------------------------------------------------------------------------
















