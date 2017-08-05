-- 6-1
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_total >
    (SELECT AVG(invoice_total) --1879.7413
     FROM invoices)
ORDER BY invoice_total;

-- 6.2.a
SELECT  invoice_number, invoice_date, invoice_total
FROM invoices JOIN vendors
    ON invoices.vendor_id = vendors.vendor_id
WHERE vendor_state = 'CA'
ORDER BY invoice_date;

-- 6.2.b
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE vendor_id IN
    (SELECT vendor_id
     FROM vendors
     WHERE vendor_state = 'CA')
ORDER BY invoice_date;

-- 6.3.a A query that returns vendors without invoices
SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE vendor_id NOT IN  -- Introduce a subquery with the IN operator.
                        -- Here, the VENDOR_ID is the test expression.
    (SELECT DISTINCT vendor_id
    FROM invoices)
ORDER BY vendor_id;

-- 6.3.b The query restated without a subquery
SELECT v.vendor_id, vendor_name, vendor_state
FROM vendors v LEFT JOIN invoices i
    ON v.vendor_id = i.vendor_id
WHERE I.vendor_id IS NULL   --Introduce a subquery with the IN operator. 
                            --Here, the VENDOR_ID is the test expression
ORDER BY v.vendor_id;

-- 6.4.a
SELECT invoice_number, invoice_date,
    invoice_total - payment_total -credit_total AS  balance_due
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0
    AND invoice_total - payment_total - credit_total <
    (
     SELECT AVG(invoice_total - payment_total - credit_total)
     FROM invoices
     WHERE invoice_total - payment_total - credit_total > 0
     )
ORDER BY invoice_total DESC;

-- 6.5.a    A query that returns invoices larger than the largest invoice for 
    -- vendor 34.
SELECT vendor_name, invoice_number, invoice_total, v.vendor_id
FROM invoices i JOIN vendors v ON i.vendor_id = v.vendor_id
WHERE invoice_total > ALL
    (SELECT invoice_total
     FROM invoices
     WHERE vendor_id = 34)
ORDER BY vendor_id, vendor_name;

--     SELECT invoice_total, vendor_id
--     FROM invoices
--     WHERE vendor_id = 34;
--     
--     SELECT invoice_total, vendor_id
--     FROM invoices Order By invoice_Total;
     
-- 6.6.a    A query that returns invoice amounts smaller than the largest
    -- invoice amount for vendor 115
SELECT vendor_name, invoice_number, invoice_total, vendors.vendor_id
FROM vendors JOIN invoices ON vendors.vendor_id = invoices.invoice_id
WHERE  invoice_total > ANY
    (SELECT invoice_total
    FROM invoices
    WHERE vendor_id = 115);
    
--    SELECT invoice_total, vendor_id
--    FROM invoices
--    WHERE vendor_id = 115;

-- 6.7.a    A query that uses a correlated subquery to return each invoice 
    -- amount that's higher than the vendor's average invoice amount.
SELECT vendor_id, invoice_number, invoice_total
FROM invoices inv_main -- inv_main is alias for invoices in Main Query
WHERE invoice_total >
    (SELECT AVG(invoice_total)
     FROM invoices inv_sub -- inv_sub is alias for invoices in subquery
     WHERE inv_sub.vendor_id = inv_main.vendor_id) -- Returns 28.50166
ORDER BY invoice_total, vendor_id;

-- 6.8.a
-- WHERE [NOT] EXISTS (subquery)
-- A query that returns vendors without invoices
SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE NOT EXISTS
    (SELECT *
     FROM invoices
     WHERE invoices.vendor_id = vendors.vendor_id)
ORDER BY vendor_state;

-- 6.9.a
-- A query that uses an inline view to retrieve all vendors with an average
 -- invoice total over 4900.
SELECT i.vendor_id, MAX(invoice_date) AS last_invoice_date,
    AVG(invoice_total) AS average_invoice_total
FROM invoices i JOIN
    (
     SELECT vendor_id, AVG(invoice_total) AS average_invoice_total
     FROM invoices
     HAVING AVG(invoice_total) > 4900
     GROUP BY vendor_id
    ) v
    ON i.vendor_id = v.vendor_id
GROUP BY i.vendor_id
ORDER BY MAX(invoice_total) DESC;

SELECT vendor_id, AVG(invoice_total) AS average_invoice_total
FROM invoices
HAVING AVG(invoice_total) > 4900
GROUP BY vendor_id;

-- 6.10.a
-- A query that uses a correlated subquery in its SELECT clause to retrieve
 -- the most recent invoice for each vendor
SELECT vendor_name,
    (SELECT MAX(invoice_date) FROM invoices
     WHERE invoices.vendor_id = vendors.vendor_id) AS latest_inv
FROM vendors
ORDER BY vendor_name DESC, latest_inv;

SELECT vendor_name, invoice_date
FROM vendors JOIN invoices ON
    vendors.vendor_id = invoices.vendor_id
ORDER BY vendor_name DESC, invoice_date;

-- A query that uses three subqueries
SELECT summary1.vendor_state, summary1.vendor_name,
       top_in_state.sum_of_invoices
FROM
    (
        SELECT v_sub.vendor_state, v_sub.vendor_name,
            SUM(i_sub.invoice_total) AS sum_of_invoices
        FROM invoices i_sub JOIN vendors v_sub
            ON i_sub.vendor_id = v_sub.vendor_id
        GROUP BY v_sub.vendor_state, v_sub.vendor_name
    ) summary1
    JOIN
        (
            SELECT summary2.vendor_state,
                MAX(summary2.sum_of_invoices) AS sum_of_invoices
            FROM
                (
                    SELECT v_sub.vendor_state, v_sub.vendor_name,
                        SUM(i_sub.invoice_total) AS sum_of_invoices
                    FROM invoices i_sub JOIN vendors v_sub
                        ON i_sub.vendor_id = v_sub.vendor_id
                    GROUP BY v_sub.vendor_state, v_sub.vendor_name
                ) summary2
            GROUP BY summary2.vendor_state
        ) top_in_state
    ON summary1.vendor_state = top_in_state.vendor_state AND
       summary1.sum_of_invoices = top_in_state.sum_of_invoices
ORDER BY summary1.vendor_state;
        
        --Subquery 1
        SELECT v_sub.vendor_state, v_sub.vendor_name,
            SUM(i_sub.invoice_total) AS sum_of_invoices
        FROM invoices i_sub JOIN vendors v_sub
            ON i_sub.vendor_id = v_sub.vendor_id
        GROUP BY v_sub.vendor_state, v_sub.vendor_name;

            --Subquery 2
            SELECT summary2.vendor_state,
                MAX(summary2.sum_of_invoices) AS sum_of_invoices
            FROM
                (
                    SELECT v_sub.vendor_state, v_sub.vendor_name,
                        SUM(i_sub.invoice_total) AS sum_of_invoices
                    FROM invoices i_sub JOIN vendors v_sub
                        ON i_sub.vendor_id = v_sub.vendor_id
                    GROUP BY v_sub.vendor_state, v_sub.vendor_name
                ) summary2
            GROUP BY summary2.vendor_state;
            
            --Subquery 3
            SELECT v_sub.vendor_state, v_sub.vendor_name,
                SUM(i_sub.invoice_total) AS sum_of_invoices
            FROM invoices i_sub JOIN vendors v_sub
                ON i_sub.vendor_id = v_sub.vendor_id
            GROUP BY v_sub.vendor_state, v_sub.vendor_name;
            
-- 6-13.a Two query names and a query that uses them
WITH summary AS
(
    SELECT vendor_state, vendor_name, SUM(invoice_total) AS sum_of_invoices
    FROM invoices
        JOIN vendors ON invoices.vendor_id = vendors.vendor_id
    GROUP BY vendor_state, vendor_name
),
top_in_state AS
(
    SELECT vendor_state, MAX(sum_of_invoices) AS sum_of_invoices
    FROM summary
    GROUP BY vendor_state, vendor_name
)
SELECT summary.vendor_state, summary.vendor_name,
    top_in_state.sum_of_invoices
FROM summary JOIN top_in_state
    ON summary.vendor_state = top_in_state.vendor_state AND
       summary.sum_of_invoices = top_in_state.sum_of_invoices
ORDER BY summary.vendor_state;

--6.13.a - Query 1
SELECT vendor_state, vendor_name, SUM(invoice_total) AS sum_of_invoices
    FROM invoices
        JOIN vendors ON invoices.vendor_id = vendors.vendor_id
    GROUP BY vendor_state, vendor_name;
    
--6.13.b - Query 2
SELECT vendor_state, MAX(sum_of_invoices) AS sum_of_invoices
FROM summary
GROUP BY vendor_state, vendor_name;

--6.14.a A query that returns hierarchical data *IMPORTANT: use -- ex -- connection.*
SELECT  employee_id,
    first_name || ' ' || last_name AS employee_name,
    LEVEL
FROM employees
START WITH employee_id = 1
CONNECT BY PRIOR employee_id = manager_id
ORDER BY LEVEL, employee_id;
--
SELECT * FROM employees;