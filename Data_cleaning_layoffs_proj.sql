-- SQL Data cleaning Project
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022


SELECT * 
FROM layoffs;

-- Goals for project
-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns IF needed


-- Creating a staging table to manipulate without editing original data -as best practice
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

-- 1. Remove duplicates
# Checking for duplicates

WITH duplicate_cte as(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper'
;


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

-- Creating new table with labels on the duplicate rows to delete them

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER()OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Disabling safe update mode so I can delete the duplicate rows with row_num = 2
SET @@SESSION.sql_safe_updates = 0;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Standardizing data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY industry;

-- I also noticed the Crypto has multiple different variations. I need to standardize that

SELECT *
FROM layoffs_staging2
WHERE industry LIKE "Crypto%";

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2;

-- It seems like some countries have a duplicate with a '.' at the end. I'll be getting rid of those and replacing them with the right spelling

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Changing the formatting in the date column, currenty type is text

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

-- Dealing with NULL values and blank values

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- we should set the blanks to nulls since those are typically easier to work with

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Filling empty values accordingly
-- Airbnb had 2 rows where in 1 row industry was empty. It was replaced with null values and then replaced with the industry from the other Airbnb row. 

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company AND t1.location = t2.location
WHERE t1.industry IS NULL OR t1.industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';



-- 3. Look at Null Values

-- the null values in total_laid_off, percentage_laid_off, and funds_raised_millions all look normal. I don't think I want to change that
-- I like having them null because it makes it easier for calculations during the EDA phase
-- so there isn't anything I want to change with the null values
-- No blank or null values that can be replaced in other columns: stage


-- 4. Remove any columns and rows we need to
-- deleting rows we cant use due to missing data
-- For example rows that are missing BOTH total_laid_off and percentage_laid_off 

UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

SELECT *
FROM layoffs_staging2
WHERE (total_laid_off IS NULL)
AND (percentage_laid_off IS NULL);


DELETE
FROM layoffs_staging2
WHERE (total_laid_off IS NULL)
AND (percentage_laid_off IS NULL);

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;

-- Now we're ready to start the EDA phase














