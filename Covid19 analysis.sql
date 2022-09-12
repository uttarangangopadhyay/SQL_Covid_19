CREATE DATABASE COVID

USE COVID
GO

--Checking NULL value
SELECT * FROM dbo.Data
WHERE Province IS NULL
OR Country IS NULL
OR Latitude IS NULL
OR Longitude IS NULL
OR Date IS NULL
OR Confirmed IS NULL
OR Deaths IS NULL
OR Recovered IS NULL

--Update NULL values to 0
UPDATE dbo.Data 
SET Longitude = 0 WHERE Longitude IS NULL

UPDATE dbo.Data
SET Latitude = 0 WHERE Latitude IS NULL

UPDATE dbo.Data
SET Recovered = 0 WHERE Recovered IS NULL

UPDATE dbo.Data
SET Active = 0 WHERE Active IS NULL

UPDATE dbo.Data
SET Incidence_Rate = 0 WHERE Incidence_Rate IS NULL

UPDATE dbo.Data
SET Case_Fatality_Ratio = 0 WHERE Case_Fatality_Ratio IS NULL

-- Checking first 10 rows
SELECT * FROM dbo.Data
LIMIT 10;

-- Checking total rows
SELECT COUNT(*) AS Number_of_rows
FROM dbo.Data;

-- Checking total number of months
SELECT DATEPART(YEAR, Date) AS 'Year', COUNT(DISTINCT(MONTH(Date))) AS Number_of_months FROM dbo.Data
GROUP BY DATEPART(YEAR, Date)

--start date & end date
SELECT MIN(Date) AS 'start_date', MAX(Date) AS 'end_date' FROM dbo.Data

-- Finding number of cases each month
SELECT DATEPART(YEAR, Date) AS 'Year', DATEPART(MONTH, Date) AS 'Month', COUNT(*) AS Number_of_rows
FROM dbo.Data
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY 1,2,3


--min: confirmed, deaths, recovered per month
SELECT DATEPART(YEAR, Date) AS 'Year', 
	DATEPART(MONTH, Date) AS 'Month', 
	MIN(Confirmed) AS min_confirmed, 
	MIN(Deaths) AS min_dealths, 
	MIN(Recovered) AS min_recovered
FROM dbo.Data
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY 1,2

--max: confirmed, deaths, recovered per month
SELECT DATEPART(YEAR, Date) AS 'Year', 
	DATEPART(MONTH, Date) AS 'Month', 
	MAX(Confirmed) AS max_confirmed, 
	MAX(Deaths) AS max_dealths, 
	MAX(Recovered) AS max_recovered
FROM dbo.Data
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY 1,2

-- The total case: confirmed, deaths, recovered per month
SELECT DATEPART(YEAR, Date) AS 'Year', 
	DATEPART(MONTH, Date) AS 'Month', 
	sum(Confirmed) AS sum_confirmed, 
	sum(Deaths) AS sum_dealths, 
	sum(Recovered) AS sum_recovered
FROM dbo.Data
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY 1,2

-- Finding the mean confirmed, death & recovered cases each month
SELECT DATEPART(YEAR, Date) AS 'Year', 
	DATEPART(MONTH, Date) AS 'Month', 
	ROUND(AVG(Confirmed),0) AS avg_confirmed,
	ROUND(AVG(Deaths),0) AS avg_deaths, 
	ROUND(AVG(Recovered),0) AS avg_recovered
FROM dbo.Data
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY 1,2

--Finding the median value
SELECT TOP 1 Confirmed
FROM dbo.Data
WHERE Confirmed IN (SELECT TOP 50 PERCENT Confirmed 
					FROM dbo.Data
					ORDER BY Confirmed ASC)
ORDER BY Confirmed DESC


--What is the frequently occuring numbers of confirmed cases in each month? Finding the mode
SELECT TOP 1 
	DATEPART(YEAR, Date) AS 'Year', 
	DATEPART(MONTH, Date) AS 'Month', 
	confirmed
FROM   dbo.Data
WHERE  Confirmed IS Not NULL
GROUP  BY DATEPART(YEAR, Date), DATEPART(MONTH, Date), confirmed
ORDER  BY COUNT(*) DESC

-- Finding the range, variance & standard deviation for confirmed, death and recovered cases
-- confirmed cases
SELECT 
	SUM(confirmed) AS total_confirmed, 
	ROUND(AVG(confirmed), 0) AS average_confirmed,
	ROUND(VAR(confirmed),0) AS variance_confirmed,
	ROUND(STDEV(confirmed),0) AS std_confirmed
FROM dbo.Data

-- deaths cases
SELECT 
	SUM(deaths) AS total_deaths, 
	ROUND(AVG(deaths), 0) AS average_deaths,
	ROUND(VAR(deaths),0) AS variance_deaths,
	ROUND(STDEV(deaths),0) AS std_deaths
FROM dbo.Data

-- recovered cases
SELECT 
	SUM(recovered) AS total_recovered, 
	ROUND(AVG(recovered), 0) AS average_recovered,
	ROUND(VAR(recovered),0) AS variance_recovered,
	ROUND(STDEV(recovered),0) AS std_recovered
FROM dbo.Data

-- Finding the range, variance & standard deviation for confirmed, death and recovered cases for each month
-- confirmed cases
SELECT 
	DATEPART(YEAR, Date) AS 'Year', 
	DATEPART(MONTH, Date) AS 'Month', 
	SUM(confirmed) AS total_confirmed, 
	ROUND(AVG(confirmed), 0) AS average_confirmed,
	ROUND(VAR(confirmed),0) AS variance_confirmed,
	ROUND(STDEV(confirmed),0) AS std_confirmed
FROM dbo.Data
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY 1,2

--- deaths case
SELECT 
	DATEPART(YEAR, Date) AS 'Year', 
	DATEPART(MONTH, Date) AS 'Month', 
	SUM(deaths) AS total_deaths, 
	ROUND(AVG(deaths), 0) AS average_deaths,
	ROUND(VAR(deaths),0) AS variance_deaths,
	ROUND(STDEV(deaths),0) AS std_deaths
FROM dbo.Data
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY 1,2

--- recovered case
SELECT 
	DATEPART(YEAR, Date) AS 'Year', 
	DATEPART(MONTH, Date) AS 'Month', 
	SUM(recovered) AS total_recovered, 
	ROUND(AVG(recovered), 0) AS average_recovered,
	ROUND(VAR(recovered),0) AS variance_recovered,
	ROUND(STDEV(recovered),0) AS std_recovered
FROM dbo.Data
GROUP BY DATEPART(YEAR, Date), DATEPART(MONTH, Date)
ORDER BY 1,2


--TOP 10 of the Confirmed case: the most Confirmed case are from India in April and May 2021
SELECT TOP 10 *
FROM dbo.Data
ORDER BY Confirmed DESC

--TOP 10 of the Deaths case: the most deaths case are from India. It causes the largest number of confirmed case.
SELECT TOP 10 *
FROM dbo.Data
ORDER BY Deaths DESC

--TOP 10 of the recovered case: is similar to Deaths case
SELECT TOP 10 *
FROM dbo.Data
ORDER BY recovered DESC


-- Finding the average confirmed, death & recovered cases
SELECT
	ROUND(AVG(Confirmed),0) AS avg_confirmed,
	ROUND(AVG(Deaths),0) AS avg_deaths,
	ROUND(AVG(Recovered),0) AS avg_recoverd
FROM dbo.Data

-- PERCENTITLE
SELECT
	PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Confirmed) OVER() AS percentitles_confirmed_50,
	PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Deaths) OVER() AS percentitles_deaths_50,
	PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Recovered) OVER() AS percentitles_recovered_50
FROM dbo.Data

-- Finding 50th, 60th , 90th , 95th percentiles of confirmed cases
SELECT
	PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Confirmed) OVER () AS pct_50_revenues,
	PERCENTILE_DISC(0.6) WITHIN GROUP(ORDER BY Confirmed) over () AS pct_60_revenues,
	PERCENTILE_DISC(0.9) WITHIN GROUP(ORDER BY Confirmed) over () AS pct_90_revenues,
	PERCENTILE_DISC(0.95) WITHIN GROUP(ORDER BY Confirmed) over () AS pct_95_revenues
FROM dbo.Data;

-- Percentile Continuous Function
SELECT 
	PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY confirmed) OVER() AS pct_95_cont_confirmed,
	PERCENTILE_DISC(0.95) WITHIN GROUP(ORDER BY confirmed) OVER() AS pct_95_disc_reconfirmed
FROM dbo.Data;


-- Finding correlations
SELECT ((Avg(Confirmed * Deaths) - (Avg(Confirmed) * Avg(Deaths))) / (StDev(Confirmed) * StDev(Deaths))) AS 'Cor_cf_dt'
FROM dbo.Data

--confirmed - recovered: 0.68807
SELECT ((Avg(Confirmed * Recovered) - (Avg(Confirmed) * Avg(Recovered))) / (StDev(Confirmed) * StDev(Recovered))) AS 'Cor_cf_rc'
FROM dbo.Data

--deaths - recovered: 0.60565
SELECT ((Avg(deaths * Recovered) - (Avg(deaths) * Avg(Recovered))) / (StDev(deaths) * StDev(Recovered))) AS 'Cor_dt_rc'
FROM dbo.Data


-- Finding the rank of month_of_year based on confirmed cases
SELECT
	ROW_NUMBER() OVER(ORDER BY confirmed) AS row_number,
	Province,
	Country,
	confirmed
FROM dbo.Data
ORDER BY confirmed DESC;


-- Computing Slope (Deaths on y-axis and confirmed case in x-asis)
SELECT (count(Confirmed)*sum(Confirmed*Deaths) - sum(Confirmed)* sum(Deaths))/(count(Confirmed)*sum(Confirmed*Confirmed) - sum(Confirmed)* sum(Confirmed))
FROM dbo.Data

-- Computing Intercept (deaths on y-axis and confirmed case in x-asis)
--Intercept = avg(y) - slope*avg(x)
SELECT AVG(Deaths) - ((count(Confirmed)*sum(Confirmed*Deaths) - sum(Confirmed)* sum(Deaths))/(count(Confirmed)*sum(Confirmed*Confirmed) - sum(Confirmed)* sum(Confirmed)))*AVG(Confirmed)
FROM dbo.Data
