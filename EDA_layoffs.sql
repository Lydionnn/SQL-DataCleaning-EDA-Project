-- Exploratory Data Analysis

-- Here are the question I am looking to answer with this project:
-- 1# What was the company with the biggest amount of layoffs?
-- 2# What was the industry with the most layoffs overall? and in 2022?
-- 3# What year had the most layoffs? 
-- 4# What stage of the business had the most layoffs? 
-- 5# Show a rolling total for the layoffs throughout the months
-- 6# What are the 5 companies that had the most layoffs in 2020, 2021, 2022 and 2023? 
-- 7# What are the 3 industries that got hit the hardest with layoffs in 2020, 2021, 2022 and 2023? 

-- with this info I am just going to use different SQL skills to explore the data and answer the questions above. 

SELECT *
FROM layoffs_staging2;

#1 What was the company with the biggest amount of layoffs?
-- Companies with the biggest single Layoff
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


#2 What was the industry with the most layoffs overall? and in 2022?
-- understanding the date range of the data we have
-- With this information on free ananlysis we can come up with question like what industry had the highest amount of layoffs in X year. 

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- By industry
SELECT industry, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Industry with most layoffs in 2022 
SELECT industry, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
WHERE YEAR(`date`) = 2022
GROUP BY industry
ORDER BY 2 DESC;

-- Consumer industry got hit the most with 45182 layoffs overall 
-- Retail industry had the most layoffs in 2022 at 20914 for that year

#3 What year had the most layoffs? 
-- By year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

#4 What stage of the business had the most layoffs?
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


#5 Show a rolling total for the layoffs throughout the months
-- Rolling total by month to understand how the layoffs were happening throughout the months
WITH rolling_total AS(SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC)
SELECT `month`, total_off, SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM rolling_total;



#6 What are the 5 companies that had the most layoffs in 2020, 2021, 2022 and 2023? 
# First I have to answer what have been the total layoffs in each company every year? 
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


#7 What are the 3 industries that got hit the hardest with layoffs in 2020, 2021, 2022 and 2023? 
-- We already know the industries (from earlier) that got hit the hardest with the most layoffs
-- Now knowing that we can get the 3 industries that were hit the hardest by year with a similar code than the one we used for the previous question

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

# Now we have cleaned the data and successfully answered 7 questions that provide good insight about this data












