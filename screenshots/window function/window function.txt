1. ROW_NUMBER() – Latest Weather Reading per Location

SELECT 
    weather_id,
    location,
    reading_date,
    temperature,
    ROW_NUMBER() OVER (PARTITION BY location ORDER BY reading_date DESC) AS row_num
FROM WEATHER_DATA;


2. RANK() – Rank Locations by Rainfall (Highest to Lowest)

SELECT
    location,
    rainfall,
    RANK() OVER (ORDER BY rainfall DESC) AS rainfall_rank
FROM WEATHER_DATA;


3.DENSE_RANK() – Temperature Ranking Without Skipping Values

SELECT
    location,
    temperature,
    DENSE_RANK() OVER (ORDER BY temperature DESC) AS temp_rank
FROM WEATHER_DATA;

4. LAG() – Compare Today’s Temperature with Previous Day

SELECT
    weather_id,
    location,
    reading_date,
    temperature,
    LAG(temperature, 1) OVER (ORDER BY reading_date) AS previous_temp
FROM WEATHER_DATA;


5. LEAD() – Predict Next Day’s Humidity

SELECT
    weather_id,
    location,
    reading_date,
    humidity,
    LEAD(humidity, 1) OVER (ORDER BY reading_date) AS next_humidity
FROM WEATHER_DATA;


6. PARTITION BY + LAG() – Farmer’s Advisory History

SELECT
    farmer_id,
    advisory_id,
    advisory_message,
    advisory_date,
    LAG(advisory_message) OVER (PARTITION BY farmer_id ORDER BY advisory_date) AS previous_advisory
FROM ADVISORY;


6. PARTITION BY + LAG() – Farmer’s Advisory History

SELECT
    farmer_id,
    advisory_id,
    advisory_message,
    advisory_date,
    LAG(advisory_message) OVER (PARTITION BY farmer_id ORDER BY advisory_date) AS previous_advisory
FROM ADVISORY;


7. PARTITION BY Weather – Crop Suitability Trends

SELECT
    crop_id,
    weather_id,
    advisory_message,
    advisory_date,
    ROW_NUMBER() OVER (PARTITION BY weather_id ORDER BY advisory_date DESC) AS row_num
FROM ADVISORY;


8. Aggregate Window Function – Average Temperature Over All Rwanda

SELECT
    weather_id,
    location,
    temperature,
    AVG(temperature) OVER () AS avg_temp_rwanda
FROM WEATHER_DATA;


9. PARTITION BY + Aggregate – Avg Temp Per District

SELECT
    location,
    temperature,
    AVG(temperature) OVER (PARTITION BY location) AS avg_temp_location
FROM WEATHER_DATA;


10. Running Total of Rainfall Over Time (Cumulative Sum)

SELECT
    weather_id,
    reading_date,
    rainfall,
    SUM(rainfall) OVER (ORDER BY reading_date) AS cumulative_rainfall
FROM WEATHER_DATA;


11. Combine Multiple Window Functions

SELECT
    f.farmer_id,
    f.farmer_name,
    COUNT(a.advisory_id) AS total_advisories,
    RANK() OVER (ORDER BY COUNT(a.advisory_id) DESC) AS popularity_rank
FROM FARMERS f
LEFT JOIN ADVISORY a ON f.farmer_id = a.farmer_id
GROUP BY f.farmer_id, f.farmer_name;


	 	