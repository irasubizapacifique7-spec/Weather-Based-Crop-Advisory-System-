---------------------------------------------------------
-- DATA RETRIEVAL QUERIES
-- Weather-Based Crop Advisory System
---------------------------------------------------------

-- 1. Get all farmers
SELECT * FROM farmers;

-- 2. Get all crops
SELECT * FROM crops;

-- 3. Get all weather records
SELECT * FROM weather_data;

-- 4. Get all advisories
SELECT * FROM advisory;

-- 5. Farmers with their advisories
SELECT f.farmer_name, a.advisory_message, a.advisory_date
FROM advisory a
JOIN farmers f ON a.farmer_id = f.farmer_id;

-- 6. Weather + advisory joined view
SELECT w.weather_date, w.temperature, w.rainfall, a.advisory_message
FROM advisory a
JOIN weather_data w ON a.weather_id = w.weather_id;
