


1. Cursor Example: List All Farmers in a Location

DECLARE
    CURSOR c_farmers IS
        SELECT farmer_id, farmer_name, phone_number
        FROM FARMERS
        WHERE location = 'Kigali - Gasabo';
    
    v_farmer_id FARMERS.farmer_id%TYPE;
    v_name FARMERS.farmer_name%TYPE;
    v_phone FARMERS.phone_number%TYPE;
BEGIN
    OPEN c_farmers;
    LOOP
        FETCH c_farmers INTO v_farmer_id, v_name, v_phone;
        EXIT WHEN c_farmers%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_farmer_id || ' - ' || v_name || ' - ' || v_phone);
    END LOOP;
    CLOSE c_farmers;
END;
/


2. Cursor Example: Get Advisories for a Farmer

DECLARE
    CURSOR c_advisories(p_farmer NUMBER) IS
        SELECT advisory_id, crop_id, advisory_message
        FROM ADVISORY
        WHERE farmer_id = p_farmer;
    
    v_adv_id ADVISORY.advisory_id%TYPE;
    v_crop_id ADVISORY.crop_id%TYPE;
    v_message ADVISORY.advisory_message%TYPE;
BEGIN
    OPEN c_advisories(1); -- Farmer ID 1
    LOOP
        FETCH c_advisories INTO v_adv_id, v_crop_id, v_message;
        EXIT WHEN c_advisories%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Advisory ' || v_adv_id || ' for Crop ' || v_crop_id || ': ' || v_message);
    END LOOP;
    CLOSE c_advisories;
END;
/


3. Cursor FOR LOOP (Simpler)

BEGIN
    FOR rec IN (SELECT farmer_id, farmer_name FROM FARMERS WHERE location LIKE 'Huye%') LOOP
        DBMS_OUTPUT.PUT_LINE(rec.farmer_id || ' - ' || rec.farmer_name);
    END LOOP;
END;
/


4. Bulk Operations with Explicit Cursor

DECLARE
    TYPE t_farmer_id IS TABLE OF FARMERS.farmer_id%TYPE;
    TYPE t_phone IS TABLE OF FARMERS.phone_number%TYPE;
    
    v_ids t_farmer_id;
    v_phones t_phone;
    
    CURSOR c_farmers_bulk IS
        SELECT farmer_id, phone_number
        FROM FARMERS
        WHERE location LIKE 'Kigali%';
BEGIN
    OPEN c_farmers_bulk;
    FETCH c_farmers_bulk BULK COLLECT INTO v_ids, v_phones;
    CLOSE c_farmers_bulk;
    
    FOR i IN 1..v_ids.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Farmer ' || v_ids(i) || ' has phone ' || v_phones(i));
    END LOOP;
END;
/


5.Cursor + Updating Rows in Bulk

DECLARE
    TYPE t_farmer_id IS TABLE OF FARMERS.farmer_id%TYPE;
    TYPE t_new_phone IS TABLE OF FARMERS.phone_number%TYPE;

    v_ids t_farmer_id;
    v_phones t_new_phone;

    CURSOR c_farmers IS
        SELECT farmer_id, phone_number
        FROM FARMERS
        WHERE location LIKE 'Rubavu%';
BEGIN
    OPEN c_farmers;
    FETCH c_farmers BULK COLLECT INTO v_ids, v_phones;
    CLOSE c_farmers;

    -- Update phone numbers by adding '99' at the end
    FORALL i IN 1..v_ids.COUNT
        UPDATE FARMERS
        SET phone_number = v_phones(i) || '99'
        WHERE farmer_id = v_ids(i);

    DBMS_OUTPUT.PUT_LINE(v_ids.COUNT || ' farmers updated.');
END;
/

