# Counting total rows in the table
SELECT 
    COUNT(*)
FROM
    covid_vaccinations;

# Change databse character set and collation
ALTER DATABASE PORTFOLIOPROJECT CHARACTER SET = UTF8MB4 COLLATE = UTF8MB4_UNICODE_CI;

# Change table character set and collation
ALTER TABLE covid_vaccinations CONVERT TO CHARACTER SET UTF8MB4 COLLATE UTF8MB4_UNICODE_CI;

# Show database information
SHOW CREATE DATABASE portfolioproject;

# Show table information
SHOW CREATE TABLE covid_vaccinations;


# Update all Empty value cell within the whole column to Null 
UPDATE covid_vaccinations 
SET 
    new_tests = NULLIF(new_test, '')
WHERE
    new_tests = '';
    
# Update rows with non-numeric characters to NULL (if the above action is not working)
UPDATE covid_vaccinations 
SET 
    human_development_index = NULL
WHERE
    human_development_index REGEXP '[^0-9]';

# Update all Empty value cell in multiple columns to Null 
UPDATE covid_vaccinations 
SET 
	total_tests_per_thousand = NULLIF(total_tests_per_thousand,''),
    new_tests_per_thousand = NULLIF(new_tests_per_thousand,''),
    new_tests_smoothed = NULLIF(new_tests_smoothed,''),
    new_tests_smoothed_per_thousand = NULLIF(new_tests_smoothed_per_thousand,''),
    positive_rate = NULLIF(positive_rate,''),
    tests_per_case = NULLIF(tests_per_case, ''),
    tests_units = NULLIF(tests_units, ''),
    total_vaccinations = NULLIF(total_vaccinations, ''),
    people_vaccinated = NULLIF(people_vaccinated, ''),
    people_fully_vaccinated = NULLIF(people_fully_vaccinated, ''),
    new_vaccinations = NULLIF(new_vaccinations, ''),
    new_vaccinations_smoothed = NULLIF(new_vaccinations_smoothed, ''),
    total_vaccinations_per_hundred = NULLIF(total_vaccinations_per_hundred, ''),
    people_vaccinated_per_hundred = NULLIF(people_vaccinated_per_hundred, ''),
    people_fully_vaccinated_per_hundred = NULLIF(people_fully_vaccinated_per_hundred, ''),
    new_vaccinations_smoothed_per_million = NULLIF(new_vaccinations_smoothed_per_million,
            ''),
    stringency_index = NULLIF(stringency_index, ''),
    population_density = NULLIF(population_density, ''),
    median_age = NULLIF(median_age, ''),
    aged_65_older = NULLIF(aged_65_older, ''),
    aged_70_older = NULLIF(aged_70_older, ''),
    gdp_per_capita = NULLIF(gdp_per_capita, ''),
    extreme_poverty = NULLIF(extreme_poverty, ''),
    cardiovasc_death_rate = NULLIF(cardiovasc_death_rate, ''),
    diabetes_prevalence = NULLIF(diabetes_prevalence, ''),
    female_smokers = NULLIF(female_smokers, ''),
    male_smokers = NULLIF(male_smokers, ''),
    handwashing_facilities = NULLIF(handwashing_facilities, ''),
    hospital_beds_per_thousand = NULLIF(hospital_beds_per_thousand, ''),
    life_expectancy = NULLIF(life_expectancy, ''),
    human_development_index = NULLIF(human_development_index, '')
WHERE
	total_tests_per_thousand = '' OR new_tests_per_thousand = '' 
		OR new_tests_smoothed = '' 
        OR new_tests_smoothed_per_thousand = '' 
        OR positive_rate = '' 
        OR tests_per_case = '' 
		OR tests_units = ''
        OR total_vaccinations = ''
        OR people_vaccinated = ''
        OR people_fully_vaccinated = ''
        OR new_vaccinations = ''
        OR new_vaccinations_smoothed = ''
        OR total_vaccinations_per_hundred = ''
        OR people_vaccinated_per_hundred = ''
        OR people_fully_vaccinated_per_hundred = ''
        OR new_vaccinations_smoothed_per_million = ''
        OR stringency_index = ''
        OR population_density = ''
        OR median_age = ''
        OR aged_65_older = ''
        OR aged_70_older = ''
        OR gdp_per_capita = ''
        OR extreme_poverty = ''
        OR cardiovasc_death_rate = ''
        OR diabetes_prevalence = ''
        OR female_smokers = ''
        OR male_smokers = ''
        OR handwashing_facilities = ''
        OR hospital_beds_per_thousand = ''
        OR life_expectancy = ''
        OR human_development_index = '';

# Update column data type
ALTER TABLE covid_vaccinations
MODIFY COLUMN people_vaccinated INT;

# Update multiple columns' data types
 ALTER TABLE covid_vaccinations
	MODIFY COLUMN total_tests_per_thousand DOUBLE,
    MODIFY COLUMN new_tests_per_thousand DOUBLE,
    MODIFY COLUMN new_tests_smoothed INT,
    MODIFY COLUMN new_tests_smoothed_per_thousand DOUBLE,
    MODIFY COLUMN positive_rate DOUBLE,
    MODIFY COLUMN tests_per_case DOUBLE,
    MODIFY COLUMN total_vaccinations INT,
    MODIFY COLUMN people_vaccinated INT,
    MODIFY COLUMN people_fully_vaccinated INT,
    MODIFY COLUMN new_vaccinations INT,
    MODIFY COLUMN new_vaccinations_smoothed INT,
    MODIFY COLUMN total_vaccinations_per_hundred DOUBLE,
    MODIFY COLUMN people_vaccinated_per_hundred DOUBLE,
    MODIFY COLUMN people_fully_vaccinated_per_hundred DOUBLE,
    MODIFY COLUMN new_vaccinations_smoothed_per_million INT,
    MODIFY COLUMN stringency_index DOUBLE,
    MODIFY COLUMN population_density DOUBLE,
    MODIFY COLUMN median_age DOUBLE,
    MODIFY COLUMN aged_65_older DOUBLE,
    MODIFY COLUMN aged_70_older DOUBLE,
    MODIFY COLUMN gdp_per_capita DOUBLE,
    MODIFY COLUMN extreme_poverty DOUBLE,
    MODIFY COLUMN cardiovasc_death_rate DOUBLE,
    MODIFY COLUMN diabetes_prevalence DOUBLE,
    MODIFY COLUMN female_smokers DOUBLE,
    MODIFY COLUMN male_smokers DOUBLE,
    MODIFY COLUMN handwashing_facilities DOUBLE,
    MODIFY COLUMN hospital_beds_per_thousand DOUBLE,
    MODIFY COLUMN life_expectancy DOUBLE;
    #MODIFY COLUMN human_development_index DOUBLE;



SHOW VARIABLES LIKE 'character_set_client';
SHOW VARIABLES LIKE 'character_set_server';