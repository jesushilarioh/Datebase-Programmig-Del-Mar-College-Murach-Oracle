-- 3.
SELECT v.vendor_name, COUNT(*), SUM(i.invoice_total)
FROM Vendors v JOIN Invoices i
    ON v.vendor_id = i.vendor_id
GROUP BY v.vendor_name
ORDER BY COUNT(*) DESC;
-- Actual
SELECT vendor_name, COUNT(*) AS invoice_count,
       SUM(invoice_total) AS invoice_total_sum
FROM vendors v JOIN invoices i
  ON v.vendor_id = i.vendor_id
GROUP BY vendor_name
ORDER BY invoice_count DESC;

-- 4. 
SELECT gl.account_description, COUNT(li.invoice_id) AS line_item_count,
       SUM(li.line_item_amt) AS line_item_amt_sum
FROM general_ledger_accounts gl JOIN invoice_line_items li
  ON gl.account_number = li.account_number
GROUP BY gl.account_description
HAVING COUNT(li.invoice_id) > 1
ORDER BY line_item_amt_sum DESC;

-- Actual
SELECT account_description, COUNT(*) AS line_item_count,
       SUM(line_item_amt) AS line_item_amt_sum
FROM general_ledger_accounts gl JOIN invoice_line_items li
  ON gl.account_number = li.account_number
GROUP BY gl.account_description
HAVING COUNT(*) > 1
ORDER BY line_item_amt_sum DESC;
    
-- 5.
SELECT gl.account_description, COUNT(li.invoice_id) AS line_item_count,
       SUM(li.line_item_amt) AS line_item_amt_sum
FROM general_ledger_accounts gl 
    JOIN invoice_line_items li
        ON gl.account_number = li.account_number
    JOIN invoices i
        ON li.invoice_id = i.invoice_id
WHERE invoice_date BETWEEN '01-APR-2014' AND '30-JUNE-2014'
GROUP BY gl.account_description
HAVING COUNT(li.invoice_id) > 1
ORDER BY line_item_amt_sum DESC;
-- Actual
SELECT account_description, COUNT(*) AS line_item_count,
       SUM(line_item_amt) AS line_item_amt_sum
FROM general_ledger_accounts gl JOIN invoice_line_items li
  ON gl.account_number = li.account_number
 JOIN invoices i
   ON li.invoice_id = i.invoice_id
WHERE invoice_date BETWEEN '01-Apr-2008' AND '30-June-2008'
GROUP BY gl.account_description
HAVING COUNT(*) > 1
ORDER BY line_item_amt_sum DESC;

6.
