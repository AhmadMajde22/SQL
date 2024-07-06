USE world_layoffs;

SELECT * from layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data 
-- 3. Null Values or blank values
-- 4. Remove unnecassery columns 


Create TABLE layoffs_staging
LIKE layoffs; -- copy the row dataset into another table 


SELECT * from layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;


SELECT * ,
ROW_NUMBER() OVER(
partition by company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
from layoffs_staging;

SELECT * ,
ROW_NUMBER() OVER(
partition by company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
from layoffs_staging
order by row_num DESC;


WITH duplicate_cte AS 
(
SELECT * ,
ROW_NUMBER() OVER(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,
country,funds_raised_millions) AS row_num
from layoffs_staging
)

SElect * 
from duplicate_cte 
where row_num >1;

SELECT * 
FROM layoffs_staging
where company='Oda';

SELECT * 
FROM layoffs_staging
where company='Yahoo';




CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



SELECT * 
from layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT  * ,
ROW_NUMBER() OVER(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,
country,funds_raised_millions) AS row_num
from layoffs_staging;

SELECT * 
from layoffs_staging2
WHERE row_num > 1;

DELETE  
from layoffs_staging2
WHERE row_num > 1;

SELECT * 
from layoffs_staging2
WHERE row_num > 1;


SELECT *
FROM layoffs_staging2;

----Standardizing the data

SELECT company,TRIM(company)
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET company=TRIM(company);


SELECT industry,TRIM(industry)
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;



SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2 
SET  industry='Crypto' WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT(industry)
FROM layoffs_staging2;


SELECT DISTINCT (location)
FROM layoffs_staging2;


SELECT DISTINCT location,country
FROM layoffs_staging2;


SELECT DISTINCT country
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET country='United States' WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2;





SELECT `date`
FROM layoffs_staging2;

SELECT `date`,STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;



UPDATE layoffs_staging2 SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');


SELECT `date`
FROM layoffs_staging2;


SELECT `date`,YEAR(`date`),MONTH(`date`),DAY(`date`) FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;



------------------------NULL and BLANK Values-------------------

SELECT *
FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off is NULL;

DELETE 
FROM layoffs_staging2 where total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off is NULL;

SELECT * FROM layoffs_staging2
WHERE industry IS NULL OR industry ='';

SELECT *
FROM layoffs_staging2
WHERE company='Airbnb';


UPDATE layoffs_staging2
SET industry =NULL 
WHERE industry='';

SELECT t1.company,t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company 
WHERE (t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL ;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
 ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


SELECT *
FROM layoffs_staging2
WHERE company='Airbnb';



SELECT * FROM layoffs_staging2
WHERE industry IS NULL OR industry ='';


SELECT * FROM layoffs_staging2
WHERE company LIKE 'Bally%';

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * FROM layoffs_staging2;