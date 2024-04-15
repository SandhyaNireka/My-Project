create database Heartattack_predication;

use Heartattack_predication;
use hemisphere;
create table HP(
Country_ID varchar(4),
Patient_ID varchar(7) primary key not null,
age int,
Salary int,
sex enum('Male','Female'),
Cholesterol int,
Blood_Pressure varchar(7),
Heart_Rate int,
Diabetes enum('0','1'),
Family_History enum('0','1'),
Smoking enum('0','1'),
Obesity enum('0','1'),
Alcohol_Consumption enum('0','1'),
Exercise int,
Diet enum('Average', 'Unhealthy','Healthy'),
Heart_Attack_Risk enum('0','1'));

Use Heartattack_predication;

select * from HP;

select sex, Patient_ID from HP
where sex = 'Female';

select Country_ID, sex from HP where Country_ID in ('US09');

select Patient_ID, sex from HP where age > 60;

Create table hemisphere(
Patient_ID varchar(7) primary key not null,
Country varchar(20),
Country_ID varchar(4),
Continent varchar(15),
Hemisphere varchar(20),
Diabetes enum('0','1'),
Family_History enum('0','1'),
Smoking enum('0','1'),
Obesity enum('0','1'),
Alcohol_Consumption enum('0','1'),
Heart_Attack_Risk enum('0','1'));

-- uses inner join query for hemisphere and hp--
select * 
from hemisphere
inner join hp
using (Country_ID);

-- display the count of patients based on continent
select continent, Count(*) AS countofpatients,
dense_rank() over (order by countofpatients desc) as ranking
from hemisphere
group by Continent;

SELECT 
    Continent,
    COUNT(*) AS countofpatients,
    SUM(CASE WHEN Heart_Attack_Risk = '1' THEN 1 ELSE 0 END) AS Count
FROM hemisphere
GROUP BY Continent;

-- display the count of gender where heart attack risk is possible--
SELECT sex, count(*) as countofgender
FROM HP
Where Heart_Attack_Risk = '1'
group by sex;

-- display the average cholestrol by gender wise--
SELECT sex, AVG(cholesterol) AS AverageCholesterol
FROM hp
GROUP BY sex
ORDER BY AverageCholesterol DESC;      




SELECT sex,
COUNT(CASE WHEN Country_ID = 'IN14' AND Heart_Attack_Risk = '1' THEN country_id END) as IndiaCount
FROM hp
GROUP BY sex;

SELECT Country_ID, AVG(age) as AverageAge
From hp
where Heart_Attack_Risk = '1'
group by Country_ID;

SELECT Country_ID, max(age) as AverageAge
From hp
where Heart_Attack_Risk = '1'
group by Country_ID;


-- display the percentage of people where heart attack is high grouping by country

select Country_ID,  count(*) * 100 / (select count(*) from hemisphere) as percentage
from hp 
where Heart_Attack_Risk = '1'
group by Country_ID;


select count(Heart_Attack_Risk) from hp
where Heart_Attack_Risk = '1'
group by Heart_Attack_Risk;

select 'Diabetes' as category, Count(case when Diabetes = '1' then 1 end) as Count,
'Family_History' as category, Count(case when Family_History = '1' then 1 end) as Count,
'Smoking' as category, Count(case when Smoking = '1' then 1 end) as Count,
'Obesity' as category, Count(case when Obesity = '1' then 1 end) as Count,
'Alcohol_Consumption' as category, Count(case when Alcohol_Consumption = '1' then 1 end) as Count from hp
where Heart_Attack_Risk = '1';

-- display the count of people where heart attack is high order by bad habits--
select Count(case when Diabetes = '1' then 1 end) as Diabetes_Count,
 Count(case when Family_History = '1' then 1 end) as Family_history,
 Count(case when Smoking = '1' then 1 end) as Smoking_Count,
 Count(case when Obesity = '1' then 1 end) as Obesity_Count,
 Count(case when Alcohol_Consumption = '1' then 1 end) as Alcohol_Count from hp
where Heart_Attack_Risk = '1';

-- display count of average people based on country

select Country_ID,
case 
when Diet ='Average' then 'Ok' 
when Diet ='Healthy' then 'Good' 
else "Not Good"
end as DIET_TABLE
from hp; 
(select Country_ID, count(Country_ID) as Countryname
from hp);

select Patient_ID, Sex,
case 
when Diet ='Average' then 'Ok' 
when Diet ='Healthy' then 'Good' 
else "Not Good"
end as DIET_TABLE
from hp;
(select Sex, count(Sex) as Gender
from hp
order by sex desc);

    


SELECT Diet, COUNT(*) AS count
FROM hp
WHERE Diet IN ('Average', 'Unhealthy', 'Healthy')
GROUP BY Diet;

-- percentage of healthy people

select Diet, count(*) as count,
count(*) * 100/(select count(*) from hemisphere) as percentage
from hp 
where Diet in ('Average','Unhealthy','Healthy')
group by Diet;

-- percentage of healthy people in

select Diet, count(*) as count,
count(*) * 100/(select count(*) from hemisphere) as percentage
from hp 
where Diet in ('Average','Unhealthy','Healthy')
and Country_ID = 'IN14'
group by Diet;

SELECT 
    Diet, 
    COUNT(*) AS Stats
FROM HP
WHERE Exercise >= 10
GROUP BY Diet;

select Patient_ID, Sex,
case 
when Diabetes ='Average' then 'Ok' 
when Diet ='Healthy' then 'Good' 
else "Not Good"
end as DIET_TABLE
from hp;

-- Check the BP is 'normal','high' & 'Low'

select 
Patient_ID, Sex,
case
When Blood_Pressure > '120/80' Then 'high'
when Blood_pressure < '100/70' Then 'Low'
else 'Normal'
end as BP
From hp

-- Check the Heartrate is 'normal','high' & 'Low'
Select Patient_ID, sex,
if(Heart_Rate > 72, "high", "low") as Heartrate_stats
from hp;

--- view table

CREATE VIEW mycountry_stats AS
SELECT 
    Country_ID, 
    MAX(Country) AS countryname
FROM 
    hemisphere
GROUP BY 
    Country_ID
HAVING 
    COUNT(CASE WHEN Diabetes = '1' THEN 1 END) > 0;
    
    select * from mycountry_stats;
    
    
    --- Using CTE and dense rank
    
    WITH PatientCounts AS (
    SELECT 
        Continent,
        COUNT(*) AS countofpatients
    FROM 
        hemisphere
    GROUP BY 
        Continent
)
SELECT 
    Continent,
    countofpatients,
    DENSE_RANK() OVER (ORDER BY countofpatients DESC) AS ranking
FROM 
    PatientCounts;

WITH PatientCounts AS (
    SELECT 
        Continent,
        COUNT(*) AS countofpatients
    FROM 
        hemisphere
    GROUP BY 
        Continent
)
SELECT 
    Continent,
    COUNT(*) AS countofpatients,
    SUM(CASE WHEN Heart_Attack_Risk = '1' THEN 1 ELSE 0 END) AS Count
FROM hemisphere
GROUP BY Continent;

SELECT 
    Continent,
    countofpatients,
    Count,
    DENSE_RANK() OVER (ORDER BY countofpatients DESC) AS ranking
FROM (
    SELECT 
        Continent,
        COUNT(*) AS countofpatients,
        SUM(CASE WHEN Heart_Attack_Risk = '1' THEN 1 ELSE 0 END) AS Count
    FROM 
        hemisphere
    GROUP BY 
        Continent
) AS Subquery;

