analysis_layoffs.sql

/*
analysis_layoffs
-----------------------
This script performs analysis on the layoffs table showing how layoffs happened by month, by year, 
by company
*/

-- Total number of people laid off per year
SELECT EXTRACT(YEAR FROM date), SUM(total_laid_off) FROM layoffs_t2
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY 1 DESC;

-- Total number people laid off per month
SELECT TO_CHAR(date, 'YYYY-MM') FROM layoffs_t2;

SELECT TO_CHAR(date, 'YYYY-MM') AS Month,
SUM(total_Laid_off) FROM layoffs_t2
WHERE TO_CHAR(date, 'YYYY-MM') IS NOT NULL
GROUP BY TO_CHAR(date, 'YYYY-MM')
ORDER BY 1 ASC;

-- A rolling total of layoffs, showing the total layoffs by monthly progression
WITH rolling_sum_layoffs AS (
    SELECT
        TO_CHAR(date, 'YYYY-MM') AS month,
        SUM(total_laid_off) AS total_layoffs
    FROM layoffs_t2
    WHERE date IS NOT NULL
    GROUP BY TO_CHAR(date, 'YYYY-MM')
)
SELECT
    month,
    total_layoffs,
    SUM(total_layoffs) OVER (ORDER BY month) AS rolling_layoffs
FROM rolling_sum_layoffs
ORDER BY month;

-- How many did companies layoff per year
SELECT company, SUM(total_laid_off)
FROM layoffs_t2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, TO_CHAR(date, 'YYYY'), SUM(total_laid_off)
FROM layoffs_t2
GROUP BY company, TO_CHAR(date, 'YYYY')
ORDER BY 3 DESC;

-- Ranking companies with the highest layoffs per year
WITH company_yearly_layoffs AS (
    SELECT
        company,
        TO_CHAR(date, 'YYYY') AS year,
        SUM(COALESCE(total_laid_off, 0)) AS total_laid_off
    FROM layoffs_t2
    WHERE date IS NOT NULL
    GROUP BY company, TO_CHAR(date, 'YYYY')
),
ranked_layoffs AS (
    SELECT
        company,
        year,
        total_laid_off,
        DENSE_RANK() OVER (
            PARTITION BY year
            ORDER BY total_laid_off DESC
        ) AS ranking
    FROM company_yearly_layoffs
)
SELECT
    company,
    year,
    total_laid_off,
	ranking
FROM ranked_layoffs
ORDER BY ranking ASC, year ASC;

-- Ranking the top 5 companies with the highest layoffs per year
WITH company_yearly_layoffs AS (
    SELECT
        company,
        TO_CHAR(date, 'YYYY') AS year,
        SUM(COALESCE(total_laid_off, 0)) AS total_laid_off
    FROM layoffs_t2
    WHERE date IS NOT NULL
    GROUP BY company, TO_CHAR(date, 'YYYY')
),
ranked AS (
    SELECT
        company,
        year,
        total_laid_off,
        DENSE_RANK() OVER (
            PARTITION BY year
            ORDER BY total_laid_off DESC
        ) AS ranking
    FROM company_yearly_layoffs
)
SELECT
    company,
    year,
    total_laid_off,
    ranking
FROM ranked
WHERE ranking <= 5
ORDER BY year ASC, total_laid_off DESC;

