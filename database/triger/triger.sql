-- 1. Holiday Management: Create a table to store public holidays
-- Since the requirement mentions "upcoming month only", we limit to relevant dates around now (Dec 2025 - Jan 2026)
-- For this example, including Christmas 2025 and New Year's Day 2026 as common public holidays

CREATE TABLE PUBLIC_HOLIDAYS (
    holiday_date DATE PRIMARY KEY,
    holiday_name VARCHAR2(100) NOT NULL
);

-- Insert sample holidays (adjust as needed for your region)
INSERT INTO PUBLIC_HOLIDAYS (holiday_date, holiday_name) VALUES (TO_DATE('2025-12-25', 'YYYY-MM-DD'), 'Christmas Day');
INSERT INTO PUBLIC_HOLIDAYS (holiday_date, holiday_name) VALUES (TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'New Year''s Day');

COMMIT;

-- 2. Audit Log Table: To capture all attempts (successful and failed)

CREATE TABLE DATA_CHANGE_AUDIT (
    audit_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name VARCHAR2(30) NOT NULL,
    operation VARCHAR2(10) NOT NULL,  -- INSERT, UPDATE, DELETE, or ATTEMPT_DENIED
    attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_name VARCHAR2(100) DEFAULT USER NOT NULL,
    farmer_id NUMBER,
    crop_id NUMBER,
    weather_id NUMBER,
    advisory_message VARCHAR2(500),
    reason_denied VARCHAR2(500)  -- NULL if allowed
);

-- 3. Restriction Check Function (reusable)

CREATE OR REPLACE FUNCTION is_operation_allowed RETURN BOOLEAN IS
    v_day VARCHAR2(10);
    v_is_holiday NUMBER;
BEGIN
    -- Check if weekday (Monday=2 to Friday=6 in default Oracle D format)
    v_day := TO_CHAR(SYSDATE, 'D');
    IF v_day BETWEEN '2' AND '6' THEN
        RETURN FALSE;  -- Weekday: denied
    END IF;

    -- Check if public holiday
    SELECT COUNT(*) INTO v_is_holiday
    FROM PUBLIC_HOLIDAYS
    WHERE TRUNC(holiday_date) = TRUNC(SYSDATE);

    IF v_is_holiday > 0 THEN
        RETURN FALSE;  -- Holiday: denied
    END IF;

    RETURN TRUE;  -- Weekend and not holiday: allowed
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;  -- Safe default
END;
/

-- 4. Audit Logging Procedure (called from triggers)

CREATE OR REPLACE PROCEDURE log_data_change_attempt (
    p_table_name IN VARCHAR2,
    p_operation IN VARCHAR2,
    p_farmer_id IN NUMBER DEFAULT NULL,
    p_crop_id IN NUMBER DEFAULT NULL,
    p_weather_id IN NUMBER DEFAULT NULL,
    p_advisory_message IN VARCHAR2 DEFAULT NULL,
    p_reason IN VARCHAR2 DEFAULT NULL
) IS
BEGIN
    INSERT INTO DATA_CHANGE_AUDIT (
        table_name,
        operation,
        farmer_id,
        crop_id,
        weather_id,
        advisory_message,
        reason_denied
    ) VALUES (
        p_table_name,
        p_operation,
        p_farmer_id,
        p_crop_id,
        p_weather_id,
        p_advisory_message,
        p_reason
    );
    COMMIT;
END;
/

-- 5. Compound Trigger: Enforce restriction on ADVISORY table (main data change table)
-- Using compound trigger to handle all events (INSERT/UPDATE/DELETE) in one place
-- Captures :NEW values for logging

CREATE OR REPLACE TRIGGER trg_restrict_advisory_changes
FOR INSERT OR UPDATE OR DELETE ON ADVISORY
COMPOUND TRIGGER

    -- Variables to hold row data for logging
    v_farmer_id NUMBER;
    v_crop_id NUMBER;
    v_weather_id NUMBER;
    v_advisory_message VARCHAR2(500);

    BEFORE STATEMENT IS
    BEGIN
        IF NOT is_operation_allowed THEN
            log_data_change_attempt(
                p_table_name => 'ADVISORY',
                p_operation => 'ATTEMPT_DENIED',
                p_reason => 'Operation not allowed on weekdays or public holidays'
            );
            RAISE_APPLICATION_ERROR(-20001, 'Data changes are restricted to weekends only (not on weekdays or public holidays).');
        END IF;
    END BEFORE STATEMENT;

    AFTER EACH ROW IS
    BEGIN
        IF INSERTING THEN
            v_farmer_id := :NEW.farmer_id;
            v_crop_id := :NEW.crop_id;
            v_weather_id := :NEW.weather_id;
            v_advisory_message := :NEW.advisory_message;

            log_data_change_attempt(
                p_table_name => 'ADVISORY',
                p_operation => 'INSERT',
                p_farmer_id => v_farmer_id,
                p_crop_id => v_crop_id,
                p_weather_id => v_weather_id,
                p_advisory_message => v_advisory_message
            );

        ELSIF UPDATING THEN
            v_farmer_id := :NEW.farmer_id;
            v_crop_id := :NEW.crop_id;
            v_weather_id := :NEW.weather_id;
            v_advisory_message := :NEW.advisory_message;

            log_data_change_attempt(
                p_table_name => 'ADVISORY',
                p_operation => 'UPDATE',
                p_farmer_id => v_farmer_id,
                p_crop_id => v_crop_id,
                p_weather_id => v_weather_id,
                p_advisory_message => v_advisory_message
            );

        ELSIF DELETING THEN
            v_farmer_id := :OLD.farmer_id;
            v_crop_id := :OLD.crop_id;
            v_weather_id := :OLD.weather_id;
            v_advisory_message := :OLD.advisory_message;

            log_data_change_attempt(
                p_table_name => 'ADVISORY',
                p_operation => 'DELETE',
                p_farmer_id => v_farmer_id,
                p_crop_id => v_crop_id,
                p_weather_id => v_weather_id,
                p_advisory_message => v_advisory_message
            );
        END IF;
    END AFTER EACH ROW;

END trg_restrict_advisory_changes;
/

-- You can create similar triggers for other tables (FARMERS, CROPS, etc.) if needed.
-- For brevity, shown only for ADVISORY (the primary mutable table in the schema).

-- Testing Queries (for your deliverable)

-- 1. View audit logs
SELECT audit_id, operation, TO_CHAR(attempt_date, 'YYYY-MM-DD HH24:MI:SS'), user_name, reason_denied
FROM DATA_CHANGE_AUDIT
ORDER BY audit_id DESC;

-- 2. Test on a weekday (should be denied and logged)
-- (Run on a Monday-Friday or insert a matching holiday date for testing)

-- 3. Test on a weekend (should succeed and log the operation)

-- 4. View holidays
SELECT * FROM PUBLIC_HOLIDAYS;

-- Add more holidays as needed for the "upcoming month"