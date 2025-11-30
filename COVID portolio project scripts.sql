
SELECT 
    *
FROM
    portfolioproject.covid_vaccinations
ORDER BY 3 , 4;


# Update date format in date (column)
UPDATE covid_vaccinations
SET date = DATE_FORMAT(STR_TO_DATE(date, '%m/%d/%Y'), '%Y-%m-%d');

SELECT 
    *
FROM
    covid_deaths
ORDER BY 3, 4;

# Update date format in date (column)
UPDATE covid_deaths
SET date = DATE_FORMAT(STR_TO_DATE(date, '%m/%d/%Y'), '%Y-%m-%d');

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    covid_deaths
ORDER BY 1 , 2;


-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS death_percentage
FROM
    covid_deaths
WHERE
    location LIKE '%states%'
ORDER BY 1 , 2;


-- Looking at total cases vs population
-- Shows what percentage of population got Covid
SELECT 
    location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100 AS percent_population_infected
FROM
    covid_deaths
WHERE
    location LIKE '%states%'
ORDER BY 1 , 2;


-- Looking at countries with highest infection rate compared to population
SELECT 
    location,
    population,
    MAX(total_cases) AS highest_infection_count,
    MAX(total_cases / population) * 100 AS percent_population_infected
FROM
    covid_deaths
GROUP BY location , population
ORDER BY percent_population_infected DESC;


-- Showing countries with highest death count per population
SELECT 
    location as country,
    population,
    MAX(total_deaths) AS highest_death_count,
    MAX(total_deaths / population) * 100 AS percent_population_death
FROM
    covid_deaths
WHERE
    continent != ''
        AND continent IS NOT NULL
        AND population != 0
GROUP BY location , population
ORDER BY highest_death_count DESC;


-- Showing continents with total deaths count
SELECT 
    location AS continent, MAX(total_deaths) AS total_deaths_count
FROM
    covid_deaths
WHERE
    continent = '' OR continent IS NULL
GROUP BY location
ORDER BY total_deaths_count DESC;


-- Global Numbers
SELECT 
    SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths) / SUM(new_cases) * 100 AS death_percentage
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
ORDER BY 1, 2;


-- Looking at total population vs vaccinations
SELECT 
    cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated
FROM
    covid_deaths cd
        JOIN
    covid_vaccinations cv ON cd.date = cv.date
        AND cd.location = cv.location
WHERE
    cd.continent IS NOT NULL
        AND cd.continent <> ''
ORDER BY 2 , 3;


-- Use CTE
WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
AS
(
SELECT 
    cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated
FROM
    covid_deaths cd
        JOIN
    covid_vaccinations cv ON cd.date = cv.date
        AND cd.location = cv.location
WHERE
    cd.continent IS NOT NULL
        AND cd.continent <> ''
ORDER BY 2, 3
)
SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM PopVsVac;


-- TEMP Table
DROP TABLE IF EXISTS percent_population_vaccinated;
CREATE TABLE percent_population_vaccinated(
Continent VARCHAR(255),
Location VARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_vaccination NUMERIC,
Rolling_People_Vaccinated NUMERIC
);
INSERT INTO percent_population_vaccinated
SELECT 
    cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated
FROM
    covid_deaths cd
        JOIN
    covid_vaccinations cv ON cd.date = cv.date
        AND cd.location = cv.location
-- WHERE cd.continent IS NOT NULL AND cd.continent <> ''
-- ORDER BY 2, 3
;
SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM percent_population_vaccinated;


-- Creating view to store data for later visualizations
CREATE OR REPLACE VIEW percent_population_vaccinated_view AS
SELECT 
    cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated
FROM
    covid_deaths cd
        JOIN
    covid_vaccinations cv ON cd.date = cv.date
        AND cd.location = cv.location
WHERE cd.continent IS NOT NULL AND cd.continent <> ''
-- ORDER BY 2, 3
;
SELECT 
    *
FROM
    percent_population_vaccinated_view;


-- Showing total continent populations for a specific contient by using CTE 
WITH population_per_country AS (
	SELECT 
		location, continent, MAX(population) AS total_pop
	FROM
		covid_deaths
	-- WHERE
		-- continent LIKE '%ocea%'
	GROUP BY continent , location
	ORDER BY continent

)
SELECT
    continent, SUM(total_pop) AS continent_population
FROM
	population_per_country
WHERE
	continent LIKE '%ocea%'
GROUP BY continent;


#Import csv file to a table
LOAD DATA LOCAL INFILE 'c:/CovidDeaths.csv' INTO TABLE covid_deaths
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


 
 SHOW GLOBAL VARIABLES LIKE 'local_infile';
 
SELECT USER();
 
SELECT DATABASE();
 
 SHOW DATABASES;
 