SELECT COUNT(DISTINCT vendor_id) AS number_of_vendors,
        COUNT(vendor_id) AS number_of_invoices,
        ROUND(AVG(invoice_total), 2) AS avg_invoice_amt,
        SUM(invoice_total) AS total_invoice_amt
FROM invoices
WHERE invoice_date > '01-JAN-2014';

-- SELECT COUNT(vendor_id) FROM invoices ORDER BY vendor_id;
-- SELECT invoice_total FROM invoices ORDER BY invoice_total;
-- SELECT invoice_date FROM invoices ORDER BY invoice_date;

-- SELECT COUNT(*) FROM invoices;
-- SELECT COUNT(DISTINCT vendor_id) FROM invoices;
-- 5-3.a
SELECT vendor_id, ROUND(AVG(invoice_total), 2) AS average_invoice_amount
FROM invoices
GROUP BY vendor_id
HAVING AVG(invoice_total) > 2000
ORDER BY average_invoice_amount DESC;

--SELECT invoice_id, ROUND(AVG(invoice_total), 2) AS average_invoice_amount
--FROM invoices
--GROUP BY invoice_id
--HAVING AVG(invoice_total) > 2000
--ORDER BY average_invoice_amount DESC;

SELECT  vendor_id, COUNT(*) AS invoice_qty
FROM invoices
GROUP BY vendor_id
ORDER BY vendor_id;

SELECT vendor_state, vendor_city, COUNT(*) AS invoice_qty,
    ROUND(AVG(invoice_total), 2) AS invoice_avg
FROM invoices JOIN vendors
    ON invoices.vendor_id = vendors.vendor_id
GROUP BY vendor_state, vendor_city
ORDER BY vendor_state, vendor_city;

-- 5-4.c
SELECT  vendor_state, vendor_city, COUNT(*) AS invoice_qty,
    ROUND(AVG(invoice_total), 2) AS invoice_avg
FROM invoices JOIN vendors
    ON invoices.vendor_id = vendors.vendor_id
GROUP BY vendor_state, vendor_city
HAVING COUNT(*) >= 2
ORDER BY vendor_state, vendor_city;

-- 5-5.a
SELECT vendor_name, COUNT(*) AS invoice_qty,
    ROUND(AVG(invoice_total),2) AS invoice_avg
FROM vendors JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
GROUP BY vendor_name
HAVING AVG(invoice_total) > 500
ORDER BY invoice_qty DESC;

-- 5-5.b
SELECT vendor_name, COUNT(*) AS invoice_qty,
    ROUND(AVG(invoice_total),2) AS invoice_avg
FROM vendors JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
WHERE invoice_total > 500
GROUP BY vendor_name
ORDER BY invoice_qty DESC;

-- 5-6.a
SELECT 
    invoice_date,
    COUNT(*) AS invoice_qty,
    SUM(invoice_total) AS invoice_sum
FROM invoices
GROUP BY invoice_date 
HAVING invoice_date BETWEEN '01-MAY-2014' AND '31-MAY-2014'
    AND COUNT(*) > 1
    AND SUM(invoice_total) > 100
ORDER BY invoice_date DESC;
--SELECT invoice_date, COUNT(*) AS date_groups FROM invoices Group by invoice_date ORDER BY INVOICE_DATE DESC;
-- 5-6.b
SELECT
    invoice_date,
    COUNT(*) AS invoice_qty,
    SUM(invoice_total) AS invoice_sum
FROM invoices
WHERE invoice_date BETWEEN '01-MAY-2014' AND '31-MAY-2014'
GROUP BY invoice_date
HAVING COUNT(*) > 1
    AND SUM(invoice_total) > 100
ORDER BY invoice_date DESC;

-- 5.7.a -- A summary query that includes a final summary row
SELECT vendor_id, COUNT(*) AS invoice_count,
    SUM(invoice_total) AS invoice_total
FROM invoices
GROUP BY ROLLUP (vendor_id);

-- 5.7.b -- A summary query that includes a summary row for each grouping level
SELECT vendor_state, vendor_city, COUNT(*) AS qty_vendors
FROM vendors
WHERE vendor_state IN ('IA', 'NJ')
GROUP BY ROLLUP (vendor_state, vendor_city)
ORDER BY vendor_state, vendor_city;

-- 5.8.a --A summary query that incudes a final summary row
SELECT vendor_id, COUNT(*) AS invoice_count,
    SUM(invoice_total) AS invoice_total
FROM invoices
GROUP BY CUBE(vendor_id);

-- 5.8.b -- A summary query that includes a summary row for each set of groups
SELECT  vendor_state, vendor_city, COUNT(*) AS qty_vendors
FROM vendors
WHERE vendor_state IN ('IA', 'NJ')
GROUP BY CUBE(vendor_state, vendor_city)
ORDER BY vendor_state, vendor_city;