-- Jesus Hilario Hernandez -- Aug 3, 2017 --

--> Database Design And Implementation >--

-- Chapter 11: How To Create Views --

-- Exercises
--1. Create a view that defines a view name open_items that shows the invoices
--  that haven't been paid. This view should return four columns from the
-- Vendors and Invoices tables: vendor_name, invoice_number, invoice_total, 
-- and balance_due (invoice_total - payment_total - credit_total). However, a
-- row should onlly be returned when the balance_due is greater than zero, and
-- the rows should be in sequence by vendor_name. Then, run the script to create
-- the view, and use SQL Developer to review the data that it returns. (You may
-- have to click on the Refresh button in the Connections window after you click
-- on the View node to show the view you've just created.)
CREATE OR REPLACE VIEW open_items AS
SELECT vendor_name, invoice_number, invoice_total,
       invoice_total - payment_total - credit_total AS balance_due
FROM vendors JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
WHERE invoice_total - payment_total - credit_total > 0
ORDER BY vendor_name;
--Test--
SELECT * FROM open_items; --42 rows

--2. Write a SELECT statement that returns all of the columns in the open_items
-- view that you created in exercise 1, with one row for each invoice that has
-- a balance due of $1000 or more.
SELECT * FROM open_items WHERE balance_due >= 1000; -- 10 rows.

--3. Create a view named open_items_summary that returns one summary row for each
-- vendor that contains invoices with unpaid balances due. Each row should include
-- vendor_name, open_item_count (the number of invoices with a balance_due),
-- and open_item_total (the total of the balance due amounts), and the rows
-- should be sorted by the open item totals in descending sequence. Then, 
-- run the script to create the view, and use SQL Developer to review the data
-- that it returns.
-- HERE WE GO!
CREATE OR REPLACE VIEW open_items_summary AS 
    SELECT vendor_name, COUNT(*) AS open_item_count,
           SUM(invoice_total - credit_total - payment_total) AS open_item_total
    FROM vendors JOIN invoices
        ON vendors.vendor_id = invoices.vendor_id
    WHERE invoice_total - credit_total - payment_total > 0
    GROUP BY vendor_name
    ORDER BY open_item_total DESC;
--test--
SELECT * FROM open_items_summary; -- 17 rows

-- 4. Write a SELECT statement that returns just the first 5 rows in the
-- open_items_summary view that you've created in exercise 3.
-- Right.
SELECT * FROM open_items_summary WHERE ROWNUM <= 5 ORDER BY open_item_count; -- 1st 5 rows.

-- 5. Create an updated view named vendor_address that returns the vendor_id, 
-- both address columns, and the city, state, and zip code columns for each
-- vendor. Then, use SQL Developer to review the data in this view.
CREATE OR REPLACE VIEW vendor_address AS
    SELECT vendor_id, vendor_address1, vendor_address2, 
        vendor_city, vendor_state, vendor_zip_code
    FROM vendors;
--Test--
SELECT * FROM vendor_address ORDER BY vendor_state; --122 rows order by state.

--6. Write an UPDATE statement that changes the address for the row with vendor
-- ID 4 so the suite number (Ste 260) is stored in vendor_address2 instead of
-- vendor_address1. Then, use SQL Developer to verify the change (you may
-- need to click the Refresh button at the top of the Data tab to see the change).
--If this works correctly, go back to the tab for that UPDATE statement and click
-- the Commit button to commit the change. Ok.
UPDATE vendor_address
SET vendor_address1 = '1990 Westwood Blvd',
    vendor_address2 = 'Ste 260'
WHERE vendor_id = 4;
SELECT vendor_address1, vendor_address2 FROM vendor_address WHERE vendor_id = 4; -- Returns 1 row with vendor_addressesssssss.
--DONE!