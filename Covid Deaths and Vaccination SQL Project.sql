-- Data Source - 'https://ourworldindata.org/covid-deaths'

SELECT *
FROM Portfolio_Project.dbo.Covid_Deaths
ORDER BY 1,2


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project.dbo.Covid_Deaths
ORDER BY 1, 2


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as Death_percentage
FROM Portfolio_Project.dbo.Covid_Deaths
WHERE location like '%India%'
ORDER BY 1,2


-- to change the data type of columns so that calculations can be made
-- alternatively we can use the cast or convert command to temporarily change the data type
ALTER TABLE Portfolio_Project.dbo.Covid_Deaths
ALTER COLUMN total_cases float


-- Looking at Total Cases vs Total Population
-- Shows what percentage of population got Covid
SELECT location, date, total_cases, population, (total_cases / population)*100 AS Case_Percentage
FROM Portfolio_Project.dbo.Covid_Deaths
--WHERE location = 'India'
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Looking at countries with Highest Infection rate compared to Population
SELECT location, MAX(total_cases) AS Highest_Infection_Count, population, MAX((total_cases / population))*100 AS Percentage_Populatin_Infected
FROM Portfolio_Project.dbo.Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location, population
HAVING MAX(total_cases) IS NOT NULL
ORDER BY Percentage_Populatin_Infected DESC


-- Showing Countries with the Highest Death Count per Population
SELECT location, MAX(cast(total_deaths as int)) as Total_Death_count
FROM Portfolio_Project.dbo.Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_Death_count DESC


-- Showing Continents With Total no of Deaths
SELECT continent, MAX(CAST(total_deaths as int)) AS Total_Death_per_Continent
FROM Portfolio_Project.dbo.Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_per_Continent DESC


-- GLOBAL New Deaths Percentage
SELECT SUM(new_cases) as Total_new_cases, SUM(CAST(new_deaths as float)) as Total_new_deaths, 
	SUM(CAST(new_deaths as int)) / SUM(new_cases)*100 as Death_percentage
FROM Portfolio_Project.dbo.Covid_Deaths
WHERE continent IS NOT NULL
order by 1,2


-- Looking at total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cummulative_vacc
FROM Portfolio_Project..Covid_Deaths as dea
JOIN Portfolio_Project..Covid_Vaccinations as vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- To show New Vaccination and Total Vaccination location wise
SELECT location, SUM(CAST(new_vaccinations AS bigint)) AS new_vac, total_vaccinations AS total_vac
FROM Portfolio_Project..Covid_Vaccinations
WHERE new_vaccinations IS NOT NULL
AND total_vaccinations IS NOT NULL
GROUP BY location, total_vaccinations
ORDER BY 1

