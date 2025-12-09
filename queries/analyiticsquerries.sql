---------------------------------------------------------
-- ANALYTICS QUERIES
-- Insights and Metrics
---------------------------------------------------------

-- 1. Count total farmers
SELECT COUNT(*) AS total_farmers FROM farmers;

-- 2. Number of advisories per month
SELECT 
    TO_CHAR(advisory_date, 'YYYY-MM') AS month,
    COUNT(*) AS total_advisories
FROM advisory
GROUP BY TO_CHAR(advisory_date, 'YYYY-MM')
ORDER BY month;

-- 3. Top crops recommended in advisories
SELECT c.crop_name, COUNT(*) AS times_recommended
FROM advisory a
JOIN crops c ON a.crop_id = c.crop_id
GROUP BY c.crop_name
ORDER BY times_recommended DESC;

-- 4. Average rainfall per district
SELECT location, AVG(rainfall) AS avg_rainfall
FROM weather_data
GROUP BY location;

-- 5. Farmers who received more than 3 advisories
SELECT farmer_id, COUNT(*) AS advisory_count
FROM advisory
GROUP BY farmer_id
HAVING COUNT(*) > 3;
