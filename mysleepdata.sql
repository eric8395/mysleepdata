CREATE DATABASE SLEEP;

USE SLEEP;

##Using Table Data Import Wizard, import my sleep data into Table 'mysleepdata'
#check the new table and columns
SELECT * 
FROM mysleepdata_formatted;

#Rename TimeAsleep column as HoursAsleep and sort from longest sleep
#Which nights did I get the most sleep?
SELECT StartDate, 
	StartTime, 
    EndDate, 
    EndTime, 
    ROUND(TimeAsleep/3600, 3) AS HoursAsleep, 
    SleepQuality
FROM mysleepdata_formatted
ORDER BY HoursAsleep DESC
LIMIT 10;

#Which nights did I have the least amount of sleep?
SELECT StartDate, 
	StartTime, 
    EndDate, 
    EndTime, 
    ROUND(TimeAsleep/3600, 3) AS HoursAsleep, 
    SleepQuality
FROM mysleepdata_formatted
WHERE ROUND(TimeAsleep/3600, 3) > 1
ORDER BY HoursAsleep
LIMIT 10;

#What are my average sleep hours?
SELECT AVG(TimeAsleep/3600) AS HoursAsleep
FROM mysleepdata_formatted;

#Which nights did I have the best quality of nights sleep?
SELECT StartDate, 
	StartTime, 
    EndDate, 
    EndTime, 
    ROUND(TimeAsleep/3600, 3) AS HoursAsleep, 
    SleepQuality 
FROM mysleepdata_formatted
WHERE SleepQuality > '95%' 
ORDER BY SleepQuality DESC
LIMIT 10;

#Which nights did I have the worst quality of nights sleep?
SELECT StartDate, 
	StartTime, 
    EndDate, 
    EndTime, 
    ROUND(TimeAsleep/3600, 3) AS HoursAsleep, 
    SleepQuality 
FROM mysleepdata_formatted
WHERE SleepQuality < '65%' 
	AND SleepQuality != '100%' 
    AND ROUND(TimeAsleep/3600, 3)  > 0.5 
ORDER BY SleepQuality DESC;

#What are the maximum amount of movements I made in one night?
SELECT ROUND(TimeAsleep/3600, 3) AS HoursAsleep, 
	MIN(MovementsPerHour) AS MaxMovements
FROM mysleepdata_formatted
WHERE MovementsPerHour != 0 
	AND ROUND(TimeAsleep/3600, 3)  > 0.5
GROUP BY HoursAsleep
ORDER BY MaxMovements DESC
LIMIT 15;

#What was the minimum amount of movements I made in one night?
SELECT ROUND(TimeAsleep/3600, 3) AS HoursAsleep, 
	MIN(MovementsPerHour) AS MaxMovements
FROM mysleepdata_formatted
WHERE MovementsPerHour != 0 
	AND ROUND(TimeAsleep/3600, 3)  > 0.5
GROUP BY HoursAsleep
ORDER BY MaxMovements
LIMIT 15;

