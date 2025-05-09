# World Layoffs Analysis

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning](#data-cleaning)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Results](#results)
- [Limitations](#limitations)

  
### Project Overview

This data analysis project seeks to give insights into the layoffs that have happened around the world over the past 3 years (2020-2023). By analyzing different aspects of the layoffs data, the aim is to see how much layoffs have happened, and get better understanding of which companies and industries were affected.

### Data Sources

Layoffs Data: The primary dataset that was used for this analysis is the "layoffs.csv" file, which contains information about layoffs made by companies.


### Tools

- PostgreSQL - Data Cleaning and Data Analysis
   - [Download Here](https://postgresql.org)


### Data Cleaning

In preparing the data, we performed the following tasks:
1. Data loading and inspection.
2. Removing duplicates.
3. Standardizing text fields.
4. Handling Null and Missing values.
5. Data cleaning and formatting.

### Exploratory Data Analysis

This phase involved the exploration of the layoffs data to answer the following questions:

1. What is the total number of people laid off in each year?
2. What is the monthly progression of layoffs?
3. Which companies laid off the most people in all years combined?
4. Which companies had the top 5 highest layoffs each year?
5. Which industries experienced the most layoffs to the fewest?

### Data Analysis

While analysing this data, I had to understand how layoffs progressed as time passed. The code below shows the total layoffs that happened in a month, adds the number of layoffs in subsequent months until it arrives at the sum total of all layoffs.

```SQL
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
```

### Results

The results of this analysis are as follows:
1. The consumer industry took the most hit and had the highest number of layoffs in total, while the manufacturing industry had the fewest layoffs.
2. Within the time frame of the data, Amazon is the company that laid off the most people in total.
3. The most layoffs happened in the year 2022. But with just 3 months in, the layoffs in 2023 have already exceeded over 78% of the total layoffs that occured in all of 2022.


### Limitations

I had to remove rows where both the total laid off and percentage laid off columns were NULL. If both columns have null rows in common, we cannot determine how many were laid off, or if they had layoffs at all.


   










