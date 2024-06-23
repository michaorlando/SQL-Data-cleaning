-- 1. Remove duplicate
-- 2. Standardize the Data
-- 3. Look at the Null Values
-- 4. Remove any columns (dont do it if you have automation from raw data/dont do it)

-- PART 2 STANDARDIZING (finding issue and fixing it)
-- TRIM take of the white space from both ends
select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct(industry)
from layoffs_staging2
order by 1;

-- crypto has different versions crypto, Crypto Currency,CryptoCurrency

select *
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

-- check for another column

select distinct country
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where country like 'United States%'
order by 1;

-- trailing
select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like '%United States%';

-- change the date column from txt to date
select `date`,
str_to_date(`date`, '%m/%d/%Y') -- capital Y !!
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

select *
from layoffs_staging2;

-- it still in txt format
alter table layoffs_staging2
modify column `date` date;

-- PART 3 LOOK AT THE NULL VALUES
select *
from layoffs_staging2
where total_laid_off is null;

-- if 2 nulls is useless = we can delete
-- for total and percentage
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- for industry
select *
from layoffs_staging2
where industry is null
or industry ='';

-- AIRBNB HAVE SOME MISSING 'industry'
select *
from layoffs_staging2
where company = 'Airbnb';

-- join the blank and not blank
select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location -- think what else if same company diff location can also have some industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not NULL;

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location -- think what else if same company diff location can also have some industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- after make sure the error -> we update it 
update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- does not work it's still show blank
-- maybe it's bcs the column is not null but blanks
-- changing Blank into Nulls
update layoffs_staging2
set industry = NULL
where industry = '';

-- update it
update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is NULL
and t2.industry is not null;


-- REMOVING data with 0/null toal and percentage layoff
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


-- PART 4 REMOVE COLUMNS (In this case the one we add earlier row_num column)
alter table layoffs_staging2
drop column row_num;

select *
from layoffs_staging2;