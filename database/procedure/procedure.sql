
1. Procedure: Add a New Farmer (INSERT + Exception Handling)

(Uses IN and OUT parameters)


CREATE OR REPLACE PROCEDURE add_farmer (
    p_name         IN  VARCHAR2,
    p_phone        IN  VARCHAR2,
    p_location     IN  VARCHAR2,
    p_new_id       OUT NUMBER
) AS
BEGIN
    -- Generate new ID
    SELECT NVL(MAX(farmer_id), 0) + 1 INTO p_new_id FROM FARMERS;

    -- Insert farmer
    INSERT INTO FARMERS (farmer_id, farmer_name, phone_number, location)
    VALUES (p_new_id, p_name, p_phone, p_location);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20001, 'Farmer already exists.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error adding farmer: ' || SQLERRM);
END;
/

&&& testing procedure

DECLARE
    v_new_id NUMBER;
BEGIN
    add_farmer('Jean Claude', '0788000100', 'Kigali - Gasabo', v_new_id);
    DBMS_OUTPUT.PUT_LINE('New Farmer ID: ' || v_new_id);
END;
/


EXEC add_farmer('Alice Mukamana', '0788000101', 'Huye - Tumba', :new_farmer_id);



2. Procedure: Update Farmer Phone Number (UPDATE + IN OUT)

CREATE OR REPLACE PROCEDURE update_farmer_phone (
    p_farmer_id   IN NUMBER,
    p_phone       IN OUT VARCHAR2
) AS
    v_old_phone   VARCHAR2(50);
BEGIN
    -- Get current phone for return  
    SELECT phone_number INTO v_old_phone
    FROM FARMERS WHERE farmer_id = p_farmer_id;

    -- Perform update
    UPDATE FARMERS
    SET phone_number = p_phone
    WHERE farmer_id = p_farmer_id;

    -- Return old phone in OUT variable
    p_phone := v_old_phone;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'Farmer not found.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20011, 'Error updating phone: ' || SQLERRM);
END;
/
&&& testing procedure

SET SERVEROUTPUT ON;

DECLARE
    v_phone VARCHAR2(50);
BEGIN
    -- Set new phone number
    v_phone := '0788000999';
    
    -- Call procedure
    update_farmer_phone(1, v_phone);
    
    -- Print old phone returned in OUT variable
    DBMS_OUTPUT.PUT_LINE('Old phone number was: ' || v_phone);
END;
/




3. Procedure: Delete Advisory (DELETE + IN parameter)


CREATE OR REPLACE PROCEDURE delete_advisory (
    p_advisory_id IN NUMBER
) AS
BEGIN
    DELETE FROM ADVISORY
    WHERE advisory_id = p_advisory_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Advisory ID not found.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20021, 'Error deleting advisory: ' || SQLERRM);
END;
/


$$$$testing procedure
BEGIN
    delete_advisory(1);
    DBMS_OUTPUT.PUT_LINE('Advisory deleted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

4. Procedure: Insert Advisory (INSERT + FK validation)


CREATE OR REPLACE PROCEDURE add_advisory (
    p_farmer_id      IN NUMBER,
    p_crop_id        IN NUMBER,
    p_weather_id     IN NUMBER,
    p_message        IN VARCHAR2,
    p_advisory_date  IN DATE,
    p_new_id         OUT NUMBER
) AS
BEGIN
    -- Generate new advisory ID
    SELECT NVL(MAX(advisory_id), 0) + 1 INTO p_new_id FROM ADVISORY;

    -- Insert into table
    INSERT INTO ADVISORY (advisory_id, farmer_id, crop_id, weather_id, advisory_message, advisory_date)
    VALUES (p_new_id, p_farmer_id, p_crop_id, p_weather_id, p_message, p_advisory_date);

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20030, 'Error adding advisory: ' || SQLERRM);
END;
/

&&& testing procedure

VARIABLE new_adv_id NUMBER;

EXEC add_advisory(1, 1, 1, 'Maize can be planted today', DATE '2025-12-08', :new_adv_id);

PRINT new_adv_id;
