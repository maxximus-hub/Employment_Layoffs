data_cleaning.sql

/*
  data_cleaning.sql
  -----------------
  This script performs data cleaning on the layoffs table:
  - Removes duplicates
  - Standardizes text fields
  - Handles NULL and Missing values
  - Removes unnecessary columns
*/

/*
Create a copy of the original data set to avoid tampering with the raw data set.
Say the existing table is layoffs_t, call the copy table layoffs_t1
*/

CREATE TABLE layoffs_t1 AS SELECT * FROM layoffs_t WHERE 1 = 0;
INSERT INTO layoffs_t1 SELECT * FROM layoffs_t;

/*
Removing duplicates using Window Functions and CTE
This method can be used when the table does not have a unique column
*/
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off,
date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_t1;

WITH Duplicate_CTE AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off,
date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_t1
)
SELECT * FROM Duplicate_CTE
WHERE row_num > 1;

-- Create a new table and add a new column called 'row_num'. This helps to identify duplicates easily
CREATE TABLE layoffs_t2
(
    company text,
    location text,
    industry text,
    total_laid_off integer,
    percentage_laid_off numeric,
    date date,
    stage text,
    country text,
    funds_raised_millions numeric,
    row_num smallint
);

INSERT INTO layoffs_t2 
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off,
date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_t1;

-- Deleting duplicates from the new table
SELECT * FROM layoffs_t2 WHERE row_num > 1;

DELETE FROM layoffs_t2 WHERE row_num >1;

-- Standardizing the data
SELECT company, TRIM(company) FROM layoffs_t2;

UPDATE layoffs_t2 SET company = TRIM(company);

SELECT DISTINCT industry FROM layoffs_t2;

SELECT * FROM layoffs_t2 WHERE industry LIKE '%Crypto%';

UPDATE layoffs_t2 SET industry = 'Cryptocurrency' WHERE industry LIKE '%Crypto%';

-- Removed a fullstop sign from one of the countries in the country column using Trim Trailing
SELECT DISTINCT country FROM layoffs_t2 ORDER BY 1;

UPDATE layoffs_t2 SET country = 'United States' 
WHERE TRIM(TRAILING '.' FROM country) = 'United States';

/*
Set date column data type to the correct date format 
in case you will need to perform time series during Exploratory Data Analysis
*/
UPDATE layoffs_t2
SET "date" = TO_CHAR(TO_DATE("date", 'MM/DD/YY'), 'YYYY/MM/DD')
WHERE "date" IS NOT NULL;

/*
 Handling Nulls and Missing values
In this case, the industry column has missing values. So we can check for the industry with missing values, 
see if the same industry, from the same company is populated on the table. 
If it is, then we can populate the missing industry values with them.
*/

SELECT * FROM layoffs_t2
WHERE industry IS NULL
OR industry = 'NULL';

SELECT t1.industry, t2.industry
FROM layoffs_t2 t1
JOIN layoffs_t2 t2 on
t1.company = t2.company 
WHERE (t1.industry IS NULL OR t1.industry = 'NULL')
AND t2.industry IS NOT NULL;

-- If you run into trouble updating, change the blank/missing values in the industry column to NULL
UPDATE layoffs_t2
SET industry = NULL
WHERE industry IS NULL;

-- Proceed to update

UPDATE layoffs_t2 t1
SET industry = t2.industry
FROM layoffs_t2 t2
WHERE t1.company = t2.company
AND (t1.industry IS NULL OR t1.industry = 'NULL')
AND t2.industry IS NOT NULL;

-- Removing unnecessary columns and rows
DELETE FROM layoffs_t2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_t2 
DROP COLUMN row_num;






















