CREATE DATABASE SLEEP;

USE SLEEP;

-- Using Table Data Import Wizard, import my sleep data into Table 'mysleepdata'
-- check the new table and columns
SELECT * FROM mysleepdata_formatted;

-- 1. Rename TimeAsleep column as HoursAsleep and sort from longest sleep
-- 1.a Which nights did I get the most sleep?
SELECT StartDate, StartTime, EndDate, EndTime, ROUND(TimeAsleep/3600, 3) AS HoursAsleep, SleepQuality
FROM mysleepdata_formatted
ORDER BY HoursAsleep DESC
LIMIT 10;

-- 2. Which nights did I have the least amount of sleep?
SELECT StartDate, StartTime, EndDate, EndTime, ROUND(TimeAsleep/3600, 3) AS HoursAsleep, SleepQuality
FROM mysleepdata_formatted
WHERE ROUND(TimeAsleep/3600, 3) > 1
ORDER BY HoursAsleep
LIMIT 10;

-- 3. What are my average sleep hours?
SELECT AVG(TimeAsleep/3600) AS HoursAsleep
FROM mysleepdata_formatted;

-- 4. Which nights did I have the best quality of nights sleep?
SELECT StartDate, StartTime, EndDate, EndTime, ROUND(TimeAsleep/3600, 3) AS HoursAsleep, SleepQuality 
FROM mysleepdata_formatted
WHERE SleepQuality > '95%' 
ORDER BY SleepQuality DESC
LIMIT 10;

-- 5. Which nights did I have the worst quality of nights sleep?
SELECT StartDate, StartTime, EndDate, EndTime, ROUND(TimeAsleep/3600, 3) AS HoursAsleep, SleepQuality 
FROM mysleepdata_formatted
WHERE SleepQuality < '65%' 
	AND SleepQuality != '100%' 
    AND ROUND(TimeAsleep/3600, 3)  > 0.5 
ORDER BY SleepQuality DESC;

-- 6. What are the maximum amount of movements I made in one night?
SELECT ROUND(TimeAsleep/3600, 3) AS HoursAsleep, 
	MIN(MovementsPerHour) AS MaxMovements
FROM mysleepdata_formatted
WHERE MovementsPerHour != 0 
	AND ROUND(TimeAsleep/3600, 3)  > 0.5
GROUP BY HoursAsleep
ORDER BY MaxMovements DESC
LIMIT 15;

-- 7. What was the minimum amount of movements I made in one night?
SELECT ROUND(TimeAsleep/3600, 3) AS HoursAsleep, 
	MIN(MovementsPerHour) AS MaxMovements
FROM mysleepdata_formatted
WHERE MovementsPerHour != 0 
	AND ROUND(TimeAsleep/3600, 3)  > 0.5
GROUP BY HoursAsleep
ORDER BY MaxMovements
LIMIT 15;

-- 8. For my best nights of sleep, did I set an alarm? Assume best nights sleep with SleepQuality is at least 90%
SELECT SleepQuality, AlarmMode
FROM mysleepdata_formatted
WHERE SleepQuality >= '90%'
GROUP BY SleepQuality, AlarmMode
ORDER BY SleepQuality DESC;

-- 9. What is the percentage where an Alarm was set?
SELECT 
	(SELECT DISTINCT COUNT(AlarmMode) FROM mysleepdata_formatted WHERE AlarmMode = 'Normal') as Normal,
	(SELECT DISTINCT COUNT(AlarmMode) FROM mysleepdata_formatted WHERE AlarmMode = 'No alarm') as NoAlarm,
	(SELECT COUNT(AlarmMode) FROM mysleepdata_formatted) as Total,
	(SELECT DISTINCT COUNT(AlarmMode) FROM mysleepdata_formatted WHERE AlarmMode = 'Normal')/ (SELECT COUNT(AlarmMode) FROM mysleepdata_formatted) * 100 as PercentNormal,
    (SELECT DISTINCT COUNT(AlarmMode) FROM mysleepdata_formatted WHERE AlarmMode = 'No alarm')/ (SELECT COUNT(AlarmMode) FROM mysleepdata_formatted) * 100 as PercentNoAlarm
FROM mysleepdata_formatted
GROUP BY AlarmMode;

-- 10. How about the percentage where snoring was recorded?
SELECT 
	(SELECT DISTINCT COUNT(Snore) FROM mysleepdata_formatted WHERE Snore = 'TRUE') as YesSnore,
	(SELECT DISTINCT COUNT(Snore) FROM mysleepdata_formatted WHERE Snore = 'FALSE') as NoSnore,
	(SELECT COUNT(Snore) FROM mysleepdata_formatted) as TotalSnore,
	(SELECT DISTINCT COUNT(Snore) FROM mysleepdata_formatted WHERE Snore = 'TRUE')/ (SELECT COUNT(Snore) FROM mysleepdata_formatted) * 100 as PercentSnore,
    (SELECT DISTINCT COUNT(Snore) FROM mysleepdata_formatted WHERE Snore = 'FALSE')/ (SELECT COUNT(Snore) FROM mysleepdata_formatted)  * 100 as PercentNoSnore
FROM mysleepdata_formatted
GROUP BY Snore;

-- 11. How much cumulative time did I spend snoring? (Converted to hours)
SELECT ROUND(SUM(SnoreTime)/3600, 2) as TotalSnoreTime, 
	ROUND(SUM(TimeAsleep)/3600, 2) as TotalTimeAsleep,
    ROUND((SUM(SnoreTime)/3600) / (SUM(TimeAsleep)/3600), 3) * 100 as PercentSnoring
FROM mysleepdata_formatted;


