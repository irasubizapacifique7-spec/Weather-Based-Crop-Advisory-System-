1. Function: Calculate Average Temperature for a Location

CREATE OR REPLACE FUNCTION get_avg_temperature(
    p_location IN VARCHAR2
) RETURN NUMBER IS
    v_avg_temp NUMBER;
BEGIN
    SELECT AVG(temperature)
    INTO v_avg_temp
    FROM WEATHER_DATA
    WHERE location = p_location;

    RETURN v_avg_temp;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20040, 'Error calculating average temperature: ' || SQLERRM);
END;
/


 testing function

DECLARE
    v_avg NUMBER;
BEGIN
    v_avg := get_avg_temperature('Kigali - Gasabo');
    DBMS_OUTPUT.PUT_LINE('Average Temp: ' || v_avg);
END;
/


2. Function: Validate if Farmer Exists


CREATE OR REPLACE FUNCTION validate_farmer(
    p_farmer_id IN NUMBER
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM FARMERS
    WHERE farmer_id = p_farmer_id;

    RETURN (v_count > 0);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20041, 'Error validating farmer: ' || SQLERRM);
END;
/

 testing function

DECLARE
    v_exists BOOLEAN;
BEGIN
    v_exists := validate_farmer(1);
    IF v_exists THEN
        DBMS_OUTPUT.PUT_LINE('Farmer exists.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Farmer does not exist.');
    END IF;
END;
/


2. Function: Check if Weather Conditions are Suitable for a Crop


CREATE OR REPLACE FUNCTION get_crops_by_season(
    p_season IN VARCHAR2
) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
    SELECT crop_id, crop_name
    FROM CROPS
    WHERE season = p_season;

    RETURN v_cursor;
END;
/
 testing procedure

DECLARE
    v_rc SYS_REFCURSOR;
    v_id CROPS.crop_id%TYPE;
    v_name CROPS.crop_name%TYPE;
BEGIN
    v_rc := get_crops_by_season('Season A');
    LOOP
        FETCH v_rc INTO v_id, v_name;
        EXIT WHEN v_rc%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_id || ' - ' || v_name);
    END LOOP;
    CLOSE v_rc;
END;
/


Function: Check if Weather Conditions are Suitable for a Crop


CREATE OR REPLACE FUNCTION is_weather_suitable(
    p_crop_id IN NUMBER,
    p_weather_id IN NUMBER
) RETURN BOOLEAN IS
    v_temp NUMBER;
    v_rain NUMBER;
    v_hum  NUMBER;
    v_min_temp NUMBER;
    v_max_temp NUMBER;
    v_min_rain NUMBER;
    v_max_rain NUMBER;
    v_min_hum  NUMBER;
    v_max_hum  NUMBER;
BEGIN
    -- Get weather readings
    SELECT temperature, rainfall, humidity
    INTO v_temp, v_rain, v_hum
    FROM WEATHER_DATA
    WHERE weather_id = p_weather_id;

    -- Get crop requirements
    SELECT min_temp, max_temp, min_rainfall, max_rainfall, min_humidity, max_humidity
    INTO v_min_temp, v_max_temp, v_min_rain, v_max_rain, v_min_hum, v_max_hum
    FROM CROP_REQUIREMENTS
    WHERE crop_id = p_crop_id;

    RETURN (v_temp BETWEEN v_min_temp AND v_max_temp
        AND v_rain BETWEEN v_min_rain AND v_max_rain
        AND v_hum BETWEEN v_min_hum AND v_max_hum);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20042, 'Error checking weather suitability: ' || SQLERRM);
END;
/
