---------------------------------------------------------
-- AUDIT QUERIES
-- Used to verify weekday/holiday restrictions
---------------------------------------------------------

-- 1. View all audit logs (latest first)
SELECT *
FROM audit_log
ORDER BY action_date DESC;

-- 2. Check all DENIED attempts
SELECT *
FROM audit_log
WHERE status = 'DENIED'
ORDER BY action_date DESC;

-- 3. Check all ALLOWED operations
SELECT *
FROM audit_log
WHERE status = 'ALLOWED';

-- 4. Count how many operations were blocked this month
SELECT COUNT(*) AS denied_this_month
FROM audit_log
WHERE status = 'DENIED'
  AND TO_CHAR(action_date, 'YYYY-MM') = TO_CHAR(SYSDATE, 'YYYY-MM');

-- 5. Attempts made on public holidays
SELECT *
FROM audit_log
WHERE message LIKE '%holiday%';

-- 6. Attempts made on weekdays
SELECT *
FROM audit_log
WHERE message LIKE '%weekday%';

-- 7. Group audit records by user
SELECT user_name, COUNT(*) AS total_actions
FROM audit_log
GROUP BY user_name;
