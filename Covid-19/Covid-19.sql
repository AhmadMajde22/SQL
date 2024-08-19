SELECT *
FROM Covid19.dbo.CovidDeaths
where continent IS NOT NULL
ORDER BY 3,4


--SELECT *
--FROM Covid19.dbo.CovidVaccinations
--ORDER BY 3,4


SELECT Location,date,total_cases,new_cases,total_deaths,population 
FROM Covid19..CovidDeaths
ORDER BY 1,2;



Select 
	Location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases) *100 [DeathPercentage]
FROM 
	Covid19..CovidDeaths
WHERE location ='United States'
ORDER BY 
	1,2;

Select 
	Location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases) *100 [DeathPercentage]
FROM 
	Covid19..CovidDeaths
WHERE location ='Jordan'
ORDER BY 
	1,2;



Select 
	Location,
	date,
	total_cases,
	population,
	(total_cases/population) *100 [GotCovidPercentage]
FROM 
	Covid19..CovidDeaths
WHERE 
	location='United States'
ORDER BY 
	1,2;


Select 
	Location,
	date,
	total_cases,
	population,
	(total_cases/population) *100 [GotCovidPercentage]
FROM 
	Covid19..CovidDeaths
ORDER BY 
	1,2;


Select Location,Population,MAX(total_cases) [HighestInfectionCount], MAX(total_cases/population)*100 [PercentagePopulationInfected]
FROM Covid19..CovidDeaths
GROUP BY location,population
Order By [PercentagePopulationInfected] DESC;


Select Location,MAX(cast (total_Deaths as int)) [HighestNumDeaths]
FROM Covid19..CovidDeaths
where continent is not NULL
GROUP BY location
ORDER BY [HighestNumDeaths] DESC;

Select continent,MAX(cast (total_Deaths as int)) [HighestNumDeaths]
FROM Covid19..CovidDeaths
where continent is not NULL
GROUP BY continent
ORDER BY [HighestNumDeaths] DESC;


Select continent, Location,MAX(cast (total_Deaths as int)) [HighestNumDeaths]
FROM Covid19..CovidDeaths
where continent is not NULL and continent='North America'
GROUP BY location,continent
ORDER BY [HighestNumDeaths] DESC;


Select Location,MAX(cast (total_Deaths as int)) [HighestNumDeaths]
FROM Covid19..CovidDeaths
where continent is  NULL 
GROUP BY location
ORDER BY [HighestNumDeaths] DESC;


SELECT date,sum(new_cases)
from Covid19..CovidDeaths
where continent is not null
Group by Date 
order by 1,2 ;



SELECT sum(new_cases) AS SUM_NewInfection,SUM(cast(new_deaths as int)) SUM_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS [DeathPercentage]
from Covid19..CovidDeaths
where continent is not null 
order by 1,2 ;


SELECT date,sum(new_cases) AS SUM_NewInfection,SUM(cast(new_deaths as int)) SUM_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS [DeathPercentage]
from Covid19..CovidDeaths
where continent is not null 
Group by Date 
having sum(new_cases) is not null
order by 1 ASC,2 DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT DEATH.continent,DEATH.location,DEATH.date,DEATH.population,VAC.new_vaccinations,
SUM(cast (VAC.new_vaccinations as int)) OVER (Partition  by DEATH.location ORDER by DEATH.location,Death.date) [Rolling People Vaccinated]
FROM Covid19..CovidDeaths DEATH
JOIN  Covid19..CovidVaccinations VAC 
ON DEATH.location = VAC.location
AND DEATH.date =VAC.date
where DEATH.continent is not null
ORDER BY 2,3;

WITH POPUlationVacc (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS (
    SELECT 
        DEATH.continent, 
        DEATH.location, 
        DEATH.date, 
        DEATH.population, 
        VAC.new_vaccinations,
        SUM(CAST(VAC.new_vaccinations AS int)) 
            OVER (PARTITION BY DEATH.location 
                  ORDER BY DEATH.date) AS [RollingPeopleVaccinated]
    FROM 
        Covid19..CovidDeaths DEATH
    JOIN  
        Covid19..CovidVaccinations VAC 
    ON 
        DEATH.location = VAC.location
    AND 
        DEATH.date = VAC.date
    WHERE 
        DEATH.continent IS NOT NULL
)
SELECT *,(RollingPeopleVaccinated/population)*100 [Percentage of vaccinated],
MAX(RollingPeopleVaccinated) OVER(PARTITION BY location) AS MAX_NUM_OF_Vaccinated
FROM POPUlationVacc

ORDER BY location, date;




CREATE Table #PErcentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date Datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

insert  into #PErcentPopulationVaccinated
SELECT 
        DEATH.continent, 
        DEATH.location, 
        DEATH.date, 
        DEATH.population, 
        VAC.new_vaccinations,
        SUM(CAST(VAC.new_vaccinations AS int)) 
            OVER (PARTITION BY DEATH.location 
                  ORDER BY DEATH.date) AS [RollingPeopleVaccinated]
    FROM 
        Covid19..CovidDeaths DEATH
    JOIN  
        Covid19..CovidVaccinations VAC 
    ON 
        DEATH.location = VAC.location
    AND 
        DEATH.date = VAC.date
    WHERE 
        DEATH.continent IS NOT NULL

SELECT *,(RollingPeopleVaccinated/population)*100 [Percentage of vaccinated]
From #PErcentPopulationVaccinated