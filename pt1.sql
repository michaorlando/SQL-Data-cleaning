-- 1. Remove duplicate
-- 2. Standardize the Data
-- 3. Look at the Null Values
-- 4. Remove any columns (dont do it if you have automation from raw data/dont do it)

-- PART 1 REMOVING DUPLICATE

select *,
row_number() over(
partition by company,industry,total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

-- If row_num is >1 = duplicate

with duplicate_cte as 
(
select *,
row_number() over(
partition by company,industry,total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;


-- to check if our query is right
select *
from layoffs_staging
where company = 'Oda';

-- After checking the data we realize that some of it is not dups
-- so we are fixing our query
-- adding more things in "partition by" section

with duplicate_cte as 
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off, percentage_laid_off, `date`, -- use ` insted of '
stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

-- checking another row
select *
from layoffs_staging
where company = 'Casper';

-- We just want to delete one dups column instead of 2

with duplicate_cte as 
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off, percentage_laid_off, date,
stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
DELETE
from duplicate_cte
where row_num > 1;

-- the DELETE function is not working 
-- first step is to create new table (layoffs_staging2) with a new column called row_num then delete it
-- right click on table we want to dup -> copy to clipboard -> create statement
-- change the table name -> add new column
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

select *
from layoffs_staging2;

-- insert the row_num table from before
insert into layoffs_staging2
select *,
row_number() over(
partition by company,location,industry,total_laid_off, percentage_laid_off, `date`,
stage,country,funds_raised_millions) as row_num
from layoffs_staging;


select *
from layoffs_staging2
where row_num>1;

delete
from layoffs_staging2
where row_num>1;