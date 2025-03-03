--1a Count of F vs M that have OCD & Avg Obsession Score by Gender
SELECT 
    gender,
	COUNT (*) AS count_with_ocd,
    ROUND (AVG(ocd.obssession_score),2) AS avg_obsession_score
FROM 
    ocd
GROUP BY 
    gender;
-- 1b: Find the Female and Male percentages
--COUNT(CASE WHEN gender = 'Female' THEN 1 END): Counts the number of females in the population.
--COUNT(CASE WHEN gender = 'Male' THEN 1 END): Counts the number of males in the population.
--COUNT(*): Counts the total number of people in the population.
--(COUNT(CASE WHEN gender = 'Female' THEN 1 END) * 100.0) / COUNT(*): Calculates the percentage of females.
--(COUNT(CASE WHEN gender = 'Male' THEN 1 END) * 100.0) / COUNT(*): Calculates the percentage of males.
SELECT
  (COUNT(CASE WHEN gender = 'Female' THEN 1 END) * 100.0) / COUNT(*) AS female_percentage,
   (COUNT(CASE WHEN gender = 'Male' THEN 1 END) * 100.0) / COUNT(*) AS male_percentage
FROM
  ocd;
 
	

--2 Count of Patients by Ethnicity & Patients Average Obsession Score by Ethnicities that have OCD
SELECT 
Ethnicity,
COUNT (*) AS count_ethnicity,
  ROUND (AVG(ocd.obssession_score),3) AS avg_obsession_score
FROM 
    ocd
GROUP BY 
    ethnicity;

--3 Number of people diagnosed with OCD every month
-- from 2013-11-01 till 2022-11-01

SELECT
  DATE_TRUNC('month', ocd_diagnosis_date) AS month,
  COUNT(*) AS diagnoses_count
FROM
  ocd
GROUP BY
  DATE_TRUNC('month', ocd_diagnosis_date)
ORDER BY
  month;


--4 What is the most common Obsession Type (Count) & it's respective Average Obsession Score
SELECT 
	obsession_type,
    COUNT (*) AS count_with_ocd,
    ROUND (AVG(ocd.obssession_score),2) AS avg_obsession_score
FROM 
    ocd
GROUP BY 
    obsession_type;

--5. What is the most common Compulsion type (Count) & it's respective Average Obsession Score 
SELECT 
	compulsion_type,
    COUNT (*) AS count_with_ocd,
    ROUND (AVG(ocd.obssession_score),2) AS avg_obsession_score
FROM 
    ocd
GROUP BY 
    compulsion_type;