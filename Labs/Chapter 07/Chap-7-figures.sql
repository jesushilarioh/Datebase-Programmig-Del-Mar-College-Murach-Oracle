-- A statement that creates a complete copy of the Invoices table
CREATE TABLE invoices_copy AS
SELECT *
FROM invoices;
SELECT * FROM invoices_copy;
-- A statement that creates a partial copy of the Invoices table
CREATE TABLE old_invoices AS
SELECT *
FROM invoices
WHERE invoice_total - payment_total - credit_total = 0;
SELECT * FROM old_invoices;
-- A statement that creates a table with summary rows from the Invoices table
CREATE TABLE vendor_balances AS
SELECT vendor_id, SUM(invoice_total) AS sum_of_invoices
FROM invoices
WHERE (invoice_total - payment_total - credit_total) <> 0
GROUP BY vendor_id;
SELECT * FROM vendor_balances;
-- A statement that deletes a table
DROP TABLE old_invoices;
SELECT * FROM old_invoices;

-- Figure 7-2.a
--An INSERT statement that adds a new row to the Invoices table.
INSERT INTO invoices
VALUES (115, 97, '456789', '01-AUG-14', 8344.50, 0, 0, 1, '31-AUG-14', NULL);
--SELECT * FROM invoices;
-- Figure 7.3.b
-- A COMMIT  statement that commits the changes
COMMIT;
-- Figure 7-2.c
--A ROLLBACK statement that rolls back the changes.
ROLLBACK;

-- Figure 7-3.a
--An INSERT statement that adds the new row without using a column list
INSERT INTO invoices
VALUES (116, 97, '456789', '01-AUG-14', 8344.50, 0, 0, 1, '31-AUG-14', NULL);
SELECT * FROM invoices;
-- Figure 7-3.b
INSERT INTO invoices
    (invoice_id, vendor_id, invoice_number, invoice_total, payment_total,
     credit_total, terms_id, invoice_date, invoice_due_date)
VALUES (117, 99, '456789', 8344.50, 0, 0, 1, '01-AUG-14', '31-AUG-14');
SELECT * FROM invoices;
-- Figure 7-4.a
--Five INSERT  statements for the Color_Sample table --USE ex TABLE!!!!!
INSERT INTO color_sample (color_id, color_number)
VALUES (1, 606);

SELECT * FROM color_sample;

INSERT INTO color_sample (color_id, color_name)
VALUES (2, 'Yellow');
INSERT INTO color_sample
VALUES (3, DEFAULT, 'Orange');
INSERT INTO color_sample
VALUES (4, 808, NULL);
INSERT INTO color_sample
VALUES (5, DEFAULT, NULL);

--7-5.a -- USE ap TABLE!!!!!!
-- The syntax of the INSERT statement for inserting rows selected form
-- another table.
INSERT INTO invoice_archive
SELECT *
FROM invoices
WHERE invoice_total - payment_total - credit_total = 0;
SELECT * FROM invoice_archive;
--7-5-.b
--The same INSERT statement with a column list.
INSERT INTO invoice_archive 
    (invoice_id, vendor_id, invoice_number, invoice_total, credit_total,
     payment_total, terms_id, invoice_date, invoice_due_date)
SELECT 
    invoice_id, vendor_id, invoice_number, invoice_total, credit_total,
    payment_total, terms_id, invoice_date, invoice_due_date
FROM invoices
WHERE invoice_total - payment_total - credit_total = 0;
SELECT * FROM invoice_archive;

--7-6.a
--An UPDATE statement that assigns new values to two columns of a single
--row in the invoices table.
UPDATE invoices
SET payment_date = '21-SEP-14',
    payment_total = 19351.18
WHERE invoice_number = '97/522';

SELECT * FROM invoices WHERE payment_date = '21-SEP-14' AND payment_total = 19351.18;
--7-6.b
--An UPDATE statement that assigns a new value to one column of all invoices
--for a vendor.
UPDATE invoices
SET terms_id = 1
WHERE vendor_id = 95;

SELECT * FROM invoices WHERE terms_id = 1 AND vendor_id = 95;

--7-6.c
--An UPDATE statement that uses an arithmetic expression to assign a value to a column.
UPDATE invoices
SET credit_total = credit_total + 100
WHERE invoice_number = '97/522';

SELECT * FROM invoices WHERE invoice_number = '97/522';

--7-7.a
--An UPDATE statement that assigns the maximum due date in the invoices
--table to a specific invoice.
UPDATE invoices
SET credit_total = credit_total + 100,
    invoice_due_date = (SELECT MAX(invoice_due_date) FROM invoices)
WHERE invoice_number = '97/522';

SELECT * FROM invoices WHERE invoice_number = '97/522';

--7-7.b
-- An UPDATE statement that updates all invoices for a vendor based on the 
-- vendor's name
UPDATE invoices
SET terms_id = 1
WHERE vendor_id =
    (SELECT vendor_id
     FROM vendors
     WHERE vendor_name = 'Pacific Bell');

SELECT vendor_id, terms_id
FROM invoices 
WHERE vendor_id = 
    (SELECT vendor_id 
     FROM vendors 
     WHERE vendor_name = 'Pacific Bell');
     
--7-7.c
-- An UPDATE statement that changes the terms of all invoices for vendors in the three states.
UPDATE invoices
SET terms_id = 1
WHERE vendor_id IN
    (SELECT vendor_id
     FROM vendors
     WHERE vendor_state IN ('CA', 'AZ', 'NV')); -- Updates 52 rows

SELECT terms_id
FROM invoices
WHERE vendor_id IN
    (SELECT vendor_id
     FROM vendors
     WHERE vendor_state IN ('CA', 'AZ', 'NV')); -- Selects those 52 rows.
     
--7-8.a Deleting Existing Rows
--A DELETE statement that deletes one row.
DELETE FROM invoice_line_items
WHERE invoice_id = 100 AND invoice_sequence = 1;

SELECT * FROM invoice_line_items
WHERE invoice_id = 100 AND invoice_sequence = 1;

--7-8.b 
--A DELETE statement that deletes four rows.
DELETE FROM invoice_line_items
WHERE invoice_id = 100;

SELECT * FROM invoice_line_items
WHERE invoice_id = 100;

     
--7-8.c
--A DELETE statement that uses a subquery to delete all invoice line items for a vendor.
DELETE FROM invoice_line_items
WHERE invoice_id IN
    (SELECT invoice_id
     FROM invoices
     WHERE vendor_id = 115);
     
SELECT * FROM invoice_line_items
WHERE invoice_id IN
    (SELECT invoice_id
     FROM invoices
     WHERE vendor_id = 115);
     
--7-9.afhfhg