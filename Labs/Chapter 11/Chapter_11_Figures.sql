--Figure 11_1_A
CREATE VIEW vendors_min AS 
    SELECT vendor_name, vendor_state, vendor_phone
    FROM vendors;
-- Check view --
SELECT * FROM vendors_min; --122 rows

-- Figure 11_1_B -- A SELECT statement that uses the Vendors_Min view
SELECT * FROM vendors_min
WHERE vendor_state = 'CA'
ORDER BY vendor_name; -- 75 rows

--Figure 11_1_C -- An UPDATE statement that uses a view to update the base table
UPDATE vendors_min
SET vendor_phone = '(800) 555-3941'
WHERE vendor_name = 'Register of Copyrights';
-- Check now row updated
SELECT vendor_phone, vendor_name FROM vendors_min WHERE vendor_name = 'Register of Copyrights';

-- Figure 11_1_D -- A statement that drops a view
DROP VIEW vendors_min;
-- Test
SELECT * FROM vendors_min; -- Returns error that vendors_min table does not exist.

-- Figure 11_3_A -- The CREATE VIEW statement that creates a view of vendors that
-- have invoices.
CREATE VIEW vendors_phone_list AS
    SELECT vendor_name, vendor_contact_last_name,
           vendor_contact_first_name, vendor_phone
    FROM vendors
    WHERE vendor_id IN (SELECT vendor_id FROM invoices);
-- test --
SELECT * FROM vendors_phone_list; -- 34 rows
SELECT * FROM vendors_phone_list ORDER BY vendor_name; -- 34 rows

-- Figure 11_3_B -- A CREATE VIEW statement that uses a join
CREATE OR REPLACE VIEW vendor_invoices AS
    SELECT vendor_name, invoice_number, invoice_date, invoice_total
    FROM vendors 
        JOIN invoices
            ON vendors.vendor_id = invoices.vendor_id;
-- Test --
SELECT * FROM vendor_invoices ORDER BY invoice_number; --117 rows

-- Figure 11_3_C -- A CREATE VIEW statement that uses a subquery
CREATE OR REPLACE VIEW top5_invoice_totals AS
    SELECT vendor_id, invoice_total
    FROM (SELECT vendor_id, invoice_total FROM invoices
          ORDER BY invoice_total DESC)
    WHERE ROWNUM <= 5;
-- Test --
SELECT * FROM top5_invoice_totals WHERE vendor_id > 1; -- 5 rows;
SELECT * FROM top5_invoice_totals ORDER BY vendor_id; -- 5 rows;
SELECT * FROM top5_invoice_totals ORDER BY invoice_total DESC; -- 5 rows;

--Figure 11_3_D -- A statement that names all the view columns in its CREATE VIEW clause
CREATE OR REPLACE VIEW invoices_outstanding
    (invoice_number, invoice_date, invoice_total, balance_due)
AS
    SELECT invoice_number, invoice_date, invoice_total,
           (invoice_total - payment_total - credit_total)
    FROM invoices
    WHERE invoice_total - payment_total - credit_total > 0;
-- Test --
SELECT * FROM invoices_outstanding; --42 rows
SELECT * FROM invoices_outstanding ORDER BY balance_due;

-- Figure 11_3_E -- A statement that names just calculated column in its SELECT clause
CREATE OR REPLACE VIEW invoices_outstanding AS
    SELECT invoice_number AS i_number, invoice_date AS i_date, invoice_total AS i_total,
           invoice_total - payment_total - credit_total AS balance_due
    FROM invoices
    WHERE invoice_total - payment_total - credit_total > 0;
-- test --
SELECT * FROM invoices_outstanding ORDER BY balance_due; -- 42 rowsa

-- Figure 11_3_F -- A CREATE VIEW statement that summarizes invoices by vendor
CREATE OR REPLACE VIEW invoice_summary AS
    SELECT vendor_name,
        COUNT(*) AS invoice_count,
        SUM(invoice_total) AS invoice_total_sum
    FROM vendors
        JOIN invoices ON vendors.vendor_id = invoices.vendor_id
    GROUP BY vendor_name;
--Test --
SELECT * FROM invoice_summary; --34 rows.

-- Figure 11_3_G -- A CREATE VIEW statement that uses the FORCE option -- this create a view even in the underlying base tables DO NOT exist
CREATE FORCE VIEW products_list AS
    SELECT product_description, product_price
    FROM products;
-- Test --
SELECT * FROM products_list;    -- An error is displayed because the underlying base table does not exist.

--A CREATE VIEW statement that creates an updatedable view
CREATE OR REPLACE VIEW balance_due_view AS
    SELECT vendor_name, invoice_number,
           invoice_total, payment_total, credit_total,
           invoice_total - payment_total - credit_total AS balance_due
    FROM vendors JOIN invoices ON vendors.vendor_id = invoices.vendor_id
    WHERE invoice_total - payment_total - credit_total > 0;
--Test--
SELECT * FROM balance_due_view; --42 rows
SELECT * FROM balance_due_view ORDER BY balance_due DESC; -- 42 rows.

--An UPDATE statement that uses the view to update data.
UPDATE balance_due_view 
SET credit_total = 300
WHERE invoice_number = '989319-497';
--Test--
SELECT balance_due, invoice_number, credit_total 
FROM balance_due_view 
WHERE invoice_number = '989319-497';

--An UPDATE statement that attempts to use the view to update a calculated column
UPDATE balance_due_view
SET balance_due = 0
WHERE invoice_number = '989319-497'; -- This will throw an SQL Error: ORA-01733: virtual column not allowed here

--A CREATE VIEW statement that creates a read-only view
CREATE OR REPLACE VIEW balance_due_view AS
    SELECT vendor_name, invoice_number,
           invoice_total, payment_total, credit_total,
           invoice_total - payment_total - credit_total AS balance_due
    FROM vendors JOIN invoices ON vendors.vendor_id = invoices.vendor_id
    WHERE invoice_total - payment_total - credit_total > 0
WITH READ ONLY;
--Test--
SELECT * FROM balance_due_view; --42 rows
SELECT * FROM balance_due_view ORDER BY balance_due;

-- An updatable view that has a WITH CHECK OPTION clause
CREATE OR REPLACE VIEW vendor_payment AS
    SELECT vendor_name, invoice_number, invoice_date, payment_date, 
           invoice_total, credit_total, payment_total
    FROM vendors JOIN invoices ON vendors.vendor_id = invoices.vendor_id
    WHERE invoice_total - payment_total - credit_total >= 0
WITH CHECK OPTION;
--Test--
SELECT * FROM vendor_payment ORDER BY invoice_total DESC; --116 rows

-- Figure 11_5_B -- A SELECT statement that displays a row from the view
SELECT * FROM vendor_payment
WHERE invoice_number = 'P-0608';

DELETE * FROM vendor_payment
WHERE invoice_number = 'P-0608'; -- This DELETE statement returns a SQL Error: ORA-00903: "invalid table name";

-- Figure 11_5_C -- A UPDATE statement that updates the view
UPDATE vendor_payment
SET payment_total = 400.00,
    payment_date = SYSDATE
WHERE invoice_number = 'P-0608';
--Test--
SELECT vendor_name, invoice_number, invoice_date, payment_date, invoice_total, credit_total, payment_total
FROM vendor_payment
WHERE invoice_number = 'P-0608';

--Figure 11_5_D -- A UPDATE statement that attempts to update the view
UPDATE vendor_payment
SET payment_total = 30000.00,
    payment_date = SYSDATE
WHERE invoice_number = 'P-0608'; -- This statement throws an SQL Error: ORA-01402: "view WITH CHECK OPTION where-clause violation

--Figure 11_6_A -- A statement that creates an updatable view--
CREATE OR REPLACE VIEW ibm_invoices AS
    SELECT invoice_number, invoice_date, invoice_total
    FROM invoices
    WHERE vendor_id = 34;
-- Contents int ibm_invoices view--
SELECT * FROM ibm_invoices; -- 2 rows

-- Figure 11_6_B -- An INSERT statement that fails due to columns with null values
INSERT INTO ibm_invoices
    (invoice_number, invoice_date, invoice_total)
VALUES
    ('RA23988', '31-JUL-14', 417.34); -- This statement returns an SQL Error: "cannot insert NULL into ('AP'.'INVOICES_ID')"

-- Figure 11_6_C -- A DELETE statement that fails due to a foreign key constraint
DELETE FROM ibm_invoices
WHERE invoice_number = 'Q545443'; -- This statement returns the SQL Error ORA-02292: 'integrity constraint (AP.LINE_ITEMS_FK_INVOICES) violated - child record founr

-- Figure 11_6_D_&_E -- Two DELETE statements that succeed
-- D.
DELETE FROM invoice_line_items
WHERE invoice_id = (SELECT invoice_id FROM invoices
                    WHERE invoice_number = 'Q545443');
--Test--
SELECT invoice_id 
FROM invoice_line_items 
WHERE invoice_id = (SELECT invoice_id FROM invoices
                    WHERE invoice_number = 'Q545443'); -- Returns nothing because we've just deleted it.
-- E.
DELETE FROM ibm_invoices
WHERE invoice_number = 'Q54553';
--test--
SELECT invoice_number FROM ibm_invoices WHERE invoice_number = 'Q54553'; -- Returns nothing because we've just deleted it.

--Figure 11_7_A -- A statement that creates a view --
CREATE OR REPLACE VIEW vendors_sw AS
SELECT *
FROM vendors
WHERE vendor_state IN ('CA', 'AZ', 'NV', 'NM');
--Test--
SELECT * FROM vendors_sw ORDER BY vendor_state; -- 80 rows.

--Figure 11_7_B -- A statement that replaces the view with a new read-only view
CREATE OR REPLACE VIEW vendors_sw AS
    SELECT * FROM vendors
    WHERE vendor_state IN ('CA', 'AZ', 'NV', 'NM', 'UT', 'CO')
WITH READ ONLY;
--Test--
SELECT * FROM vendors_sw ORDER BY vendor_state; -- 50 rows.

-- Figure 11_7_C -- A statement that drops the view --
DROP VIEW vendors_sw;
--Test--
SELECT * FROM vendors_sw;   -- Returns: "table view does not exist", because we just dropped it.