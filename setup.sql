-- data cleaning


-- 1. Remove duplicate
-- 2. Standardize the Data
-- 3. Look at the Null Values
-- 4. Remove any columns (dont do it if you have automation from raw data/dont do it)

-- Staging table to separate master data to our own data, prevent mistakes
select *
from layoffs;

Create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;



