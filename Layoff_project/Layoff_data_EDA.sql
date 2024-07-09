USE world_layoffs;
SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * FROM layoffs_staging2

WHERE percentage_laid_off=1;


SELECT * FROM layoffs_staging2

WHERE percentage_laid_off=1

ORDER BY total_laid_off DESC;


SELECT * FROM layoffs_staging2

WHERE percentage_laid_off=1

ORDER BY funds_raised_millions DESC;

SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`),MAX(`date`)
FROM layoffs_staging2;


SELECT industry,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT country,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT `date`,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC;

SELECT YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 1 DESC;

 
SELECT stage,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 


SELECT SUBSTRING(`date`,1,7) AS `Month`,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP By `Month`
ORDER BY 1 ASC;


WITH ROlling_Total AS
(
    SELECT SUBSTRING(`date`,1,7) AS `Month`,SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP By `Month`
    ORDER BY 1 ASC
)
SELECT `Month`,total_off,
SUM(total_off) OVER( ORDER BY `Month` ) AS rolling_Total
FROM ROlling_Total;





SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company,YEAR(`date`) ,SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;



SELECT company,YEAR(`date`) AS year,SUM(total_laid_off) AS  total_off
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY company,YEAR(`date`)
ORDER BY total_off DESC,2 DESC;







WITH Company_Year (company,years,total_laid_off) AS 
(
    SELECT company,YEAR(`date`),SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company,YEAR(`date`)
)
SELECT *,
DENSE_RANK() OVER(PARTITION BY  years ORDER BY total_laid_off DESC) AS RANKING
FROM Company_Year
WHERE years is NOT NULL
ORDER BY RANKING;

WITH Company_Year AS 
(
    SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
Ranked_Companies AS
(
    SELECT *,
    DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS RANKING
    FROM Company_Year
    WHERE years IS NOT NULL
)
SELECT *
FROM Ranked_Companies
WHERE RANKING <= 5
ORDER BY years, RANKING;
