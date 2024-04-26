-- Exploratory Data Analysis

-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers

-- normally when I start the EDA process I should have some idea of what you're looking for

-- with this info I am just going to use different SQL skills to freely explore the data


-- Looking at the data and the MAX values on the total_laid_off and percentage_laid_off

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Looking at companies that had 1 laid off which equates to 100% of their company was laid off
-- It's also interesting to see the ones that 100% of the company was laid off but they had the most funding

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- ---------------------
-- Companies with the biggest single Layoff
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- understanding the date range of the data we have
-- With this information on free ananlysis we can come up with question like what industry had the highest amount of layoffs in X year. 

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- By industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- By year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- By stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- Exploring the data with the date column
SELECT YEAR(`date`), MONTH(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`), MONTH(`date`)
ORDER BY 1, 2 DESC;

-- Total laid_off by month
SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC; 

-- Rolling total by month to understand how the layoffs were happening throughout the months
WITH rolling_total AS(SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC)
SELECT `month`, total_off, SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM rolling_total;



-- A good question could be what have been the total layoffs in each company every year
-- Total layoffs per company per year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `date`
ORDER BY 3 DESC;


-- Using that as a cte to dive deeper in this analysis and have a more precise answer
-- I want to get the 5 companies that had the most layoffs per year in order
WITH Company_year AS(SELECT company, YEAR(`date`) as years, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
),
company_year_rank AS(
SELECT *, DENSE_RANK()OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_year
WHERE years IS NOT NULL)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;


-- -----------------
-- We already know the industries (from earlier) that got hit the hardest with the most layoffs
-- Now knowing that we can get the 3 industries that were hit the hardest by year

WITH industry_year AS(SELECT industry, YEAR(`date`) as years, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)
ORDER BY 3 DESC
),
industry_year_rank AS(
SELECT *, DENSE_RANK()OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM industry_year
WHERE years IS NOT NULL)
SELECT *
FROM industry_year_rank
WHERE ranking <= 5;












