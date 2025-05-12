exploratory_data_analysis.sql

/*
exploratory_data_analysis
-----------------------
This script performs exploratory data analysis on the layoffs table
*/

SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs_t2;

-- This shows companies that laid off 100 percent. 1 means 100 percent.
SELECT * FROM layoffs_t2 WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- This shows companies with funding that laid off 100 percent.
SELECT * FROM layoffs_t2 WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- To find companies that laid off the most people in total
SELECT company, SUM(total_laid_off) FROM layoffs_t2
GROUP BY company ORDER BY 2 DESC;

-- Date range of layoffs
SELECT MIN(date), MAX(date) FROM layoffs_t2;

-- Industries with the most to the least layoffs
SELECT industry, SUM(total_laid_off) FROM layoffs_t2
GROUP BY industry ORDER BY 2 DESC;

-- How many were laid off by countries
SELECT country, SUM(total_laid_off) FROM layoffs_t2
GROUP BY country ORDER BY 2 DESC;

-- The different stages companies were at when they laid off people
SELECT stage, SUM(total_laid_off) FROM layoffs_t2
GROUP BY stage ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) FROM layoffs_t2
GROUP BY stage ORDER BY 2 DESC;




