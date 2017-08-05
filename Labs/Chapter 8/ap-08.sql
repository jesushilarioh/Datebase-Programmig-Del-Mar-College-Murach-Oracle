-- Figure 8-6
SELECT invoice_id, invoice_date, invoice_total,
    CAST(invoice_date AS VARCHAR(9)) AS varchar_date, -- invoice_date originally  a DATE
    CAST(invoice_total AS NUMBER(9)) AS integer_total -- invoice_total originally a NUMBER(9,2)
FROM invoices;
-- Figure 8-9
SELECT vendor_name || CHR(13)
    || vendor_address1 || CHR(13)
    || vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code
    AS vendor_address
FROM vendors
WHERE vendor_id = 1;

-- Parsing a string
-- 8-11.a -- A SELECT statement that uses the SUBSTR function
SELECT vendor_name,
       vendor_contact_first_name || ' ' ||
           SUBSTR(vendor_contact_last_name, 1, 1) || '.'
           AS contact_name,
       SUBSTR(vendor_phone, 7) AS phone
FROM vendors
WHERE SUBSTR(vendor_phone, 2, 3) = '559'
ORDER BY vendor_name;
-- 8-11.b -- A SELECT statement that parses a string --USE ex database!!!!!
SELECT SUBSTR(name, 1, (INSTR(name, ' ') -1)) AS first_name,
       SUBSTR(name, (INSTR(name, ' ') + 1)) AS last_name
FROM string_sample;
--SELECT name FROM string_sample;

-- How to sort a string in numerical sequence:
-- Figure 8-12.a -- A table sorted by a character column:
SELECT * FROM string_sample
ORDER BY id;

-- Figure 8-12.b -- A table sorted by a character column treated as a numeric column
SELECT * FROM string_sample
ORDER BY TO_NUMBER(id);

-- Figure 8-12.c -- A table sorted by a character column that's padded with leading zeros
SELECT LPAD(id, 2, '0') AS lpad_id, name
FROM string_sample
ORDER BY lpad_id;

-->--HOW TO WORK WITH NUMERIC DATA:-->--
-- How to search for floating-point #s:

-- Figure 8-14.a -- The Float_Sample Table:
SELECT * FROM Float_Sample;

-- Figure 8-14.b -- A SELECT statement that searches for an exact value
SELECT * FROM float_sample
WHERE float_value = 1;

-- Figure 8-14.c -- A SELECT statement that searches for a range of values
SELECT * FROM Float_sample
WHERE float_value BETWEEN 0.99 AND 1.01;

-- Figure 8-14.d -- A SELECT statement that searches for rounded values
SELECT * FROM float_sample
WHERE ROUND(float_value, 2) = 1;

-->-- HOW TO PERFORM A DATE SEARCH -->--
-- Figure 8-17.a -- The Date_Sample table --
SELECT * FROM Date_Sample;

-- Figure 8-17.a -- A SELECT statement that fails to return a row:
SELECT * FROM date_sample
WHERE start_date = '28-FEB-06'; --Nothing returned because the default 00:00:00 
-- is added and this date does not have the default value as it's time.
-- 2 WAYS TO SOLVE THIS PROBLEM BY:
        -- 1. Figure 8-17.c -- A SELECT statement that searches for a range of dates
    SELECT * FROM date_sample
    WHERE start_date >= '28-FEB-06' AND start_date < '01-MAR-06';
        -- 2. Figure 8-17.c -- A SELECT statement that uses the TRUNC function to remove time values
    SELECT * FROM date_sample
    WHERE TRUNC(start_date) = '28-FEB-06';





-- HOW TO PERFORM A TIME SEARCH --
-- FIGURE 8-18.A
SELECT * FROM Date_Sample;

-- FIGURE 8-18.B -- A SELECT statement that fails to return a row
SELECT * FROM date_sample
WHERE start_date = TO_DATE('10:00:00', 'HH24:MI:SS');
-- TO SOLVE! --
-- FIGURE 8-18.C -- A SELECT statement that ignores the date component. The data
-- type for start_date (DATE) must first be changed to a CHAR before it can be compared.
SELECT * FROM date_sample
WHERE TO_CHAR(start_date, 'HH24:MI:SS') = '10:00:00';

-- FIGURE 8-18.D -- Another SELECT statement that fails to return a row.
SELECT * FROM date_sample
WHERE start_date >= TO_DATE('09:00:00', 'HH24:MI:SS')
  AND start_date < TO_DATE('12:59:59', 'HH24:MI:SS');
-- TO SOLVE!
-- FIGURE 8-18.E -- Another SELECT statement that ignores the date component:
SELECT * FROM date_sample
WHERE TO_CHAR(start_date, 'HH24:MI:SS') >= '09:00:00'
  AND TO_CHAR(start_date, 'HH24:MI:SS')  < '12:59:59';
  

-->-- HOW TO USE THE CASE FUNCTION -->-- P. 270-271
-- Test to see what is in invoices table
SELECT invoice_number, terms_id FROM invoices;
-- FIGURE 8-19.A -- A SELECT statement that uses a simple CASE expression.
SELECT invoice_number, terms_id,
    CASE terms_id
        WHEN 1 THEN 'Net due 10 days'
        WHEN 2 THEN 'Net due 20 days'
        WHEN 3 THEN 'Net due 30 days'
        WHEN 4 THEN 'Net due 60 days'
        WHEN 5 THEN 'Net due 90 days'
    END AS terms
WHERE terms_id = 5
FROM invoices
ORDER BY terms DESC;

-->-- HOW TO USE THE COALESCE, NVL, AND NVL2 FUNCTIONS -->--
-- Test
SELECT payment_date, invoice_due_date FROM invoices;
-- FIGURE 8-20.A -- A SELECT statement that uses the COALESCE function
SELECT payment_date, invoice_due_date,
       COALESCE(payment_date, invoice_due_date, TO_DATE('01-JAN-1900'))
       AS payment_date_2
FROM invoices;

--Test
SELECT payment_date FROM invoices;
-- FIGURE 8-20.B -- A SELECT statement that uses the NVL function
SELECT payment_date,
       NVL(TO_CHAR(payment_date), 'Unpaid') AS payment_date_2
FROM invoices;

--Test
SELECT payment_date FROM invoices;
--FIGURE 8-20.C
SELECT payment_date,
       NVL2(payment_date, 'Paid', 'Unpaid') AS payment_date_2 
FROM invoices;

-->-- HOW TO USE THE GROUPING FUNCTIONS -->--
--TEST
SELECT vendor_state, vendor_city, COUNT(*) AS qty_vendors
FROM vendors
WHERE vendor_state IN ('IA', 'NJ')
GROUP BY ROLLUP(vendor_state, vendor_city)
ORDER BY vendor_state DESC, vendor_city DESC;
--FIGURE 8-21.A -- A summary query that uses the GROUPING function
SELECT
    CASE
        WHEN GROUPING(vendor_state) = 1 THEN '==========='
        ELSE vendor_state
    END AS vendor_state,
    CASE 
        WHEN GROUPING(vendor_city) = 1 THEN '==========='
        ELSE vendor_city
    END AS vendor_city,
    COUNT(*) AS qty_vendors
FROM vendors
WHERE vendor_state IN ('IA', 'NJ')
GROUP BY ROLLUP(vendor_state, vendor_city)
ORDER BY vendor_state DESC, vendor_city DESC;

-->-- HOW TO USE THE RANKING FUNCTIONS -->--
--TEST
SELECT vendor_name FROM vendors ORDER BY vendor_name;
-- FIGURE 8-22.A -- A query that uses the ROW_NUMBER function
SELECT ROW_NUMBER() OVER(ORDER BY vendor_name) AS row_number, vendor_name
FROM vendors;

-- FIGURE 8-22.B -- A query that uses the PARTITION BY clause:
SELECT ROW_NUMBER()
       OVER(PARTITION BY vendor_state ORDER BY vendor_name)
       AS row_number, vendor_name, vendor_state
FROM vendors;

--TEST: PARTITION BY vendor_city, instead of vendor_state.
SELECT ROW_NUMBER()
       OVER(PARTITION BY vendor_city ORDER BY vendor_name)
       AS row_number, vendor_name, vendor_city
FROM vendors;

--
SELECT invoice_total, invoice_date,
    CASE 
        WHEN (SYSDATE - invoice_date) >= 30 AND (SYSDATE - invoice_date) < 60
            THEN invoice_total
        ELSE 0
    END AS "30-60",
    CASE
        WHEN (SYSDATE - invoice_date) >= 60 AND (SYSDATE - invoice_date) < 90
            THEN invoice_total
        ELSE 0
    END AS "60-90",
    CASE
        WHEN (SYSDATE - invoice_date) > 90
            THEN invoice_total
        ELSE 0
    END AS "Over 90"
FROM invoices;