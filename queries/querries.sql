
1. Basic Retrieval (unchanged)

SELECT * FROM FARMERS;

SELECT * FROM CROPS;
	
SELECT * FROM ADVISORY;


2. Foreign Key Integrity

Advisories whose farmer_id does not appear in FARMERS

SELECT advisory_id, farmer_id
FROM ADVISORY
WHERE farmer_id NOT IN (SELECT farmer_id FROM FARMERS);


Advisories whose crop_id does not appear in CROPS

SELECT advisory_id, crop_id
FROM ADVISORY
WHERE crop_id NOT IN (SELECT crop_id FROM CROPS);



3. Data Completeness

Farmers with missing phone_number

SELECT farmer_id, farmer_name
FROM FARMERS
WHERE phone_number = '';


Advisories missing temperature or rainfall

SELECT advisory_id, farmer_id, crop_id
FROM ADVISORY
WHERE temperature = ''
   OR rainfall = '';


Advisories missing temperature or rainfall

SELECT advisory_id, farmer_id, crop_id
FROM ADVISORY
WHERE temperature = ''
   OR rainfall = '';


4. Consistency Checks

Count advisories per farmer

SELECT f.farmer_name, COUNT(a.advisory_id) AS total_advisories
FROM FARMERS f
LEFT JOIN ADVISORY a ON f.farmer_id = a.farmer_id
GROUP BY f.farmer_name;


Weather values outside a realistic range

SELECT advisory_id, temperature
FROM ADVISORY
WHERE temperature < -10 OR temperature > 50;


5. Duplicate Records Check

Duplicate farmers

SELECT farmer_name, phone_number, COUNT(*)
FROM FARMERS
GROUP BY farmer_name, phone_number
HAVING COUNT(*) > 1;
