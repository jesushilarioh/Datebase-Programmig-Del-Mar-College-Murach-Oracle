--A statement that creates a table without column attributes..
CREATE TABLE vendors
(
    vendor_id NUMBER,
    vendor_name VARCHAR2(50)
);
DROP TABLE vendors;
-- A statement that creates a table with column attributes
CREATE TABLE vendors
(
    vendor_id       NUMBER          NOT NULL    UNIQUE,
    vendor_name     VARCHAR2(50)    NOT NULL    UNIQUE
);

-- Another statement that creates a table with column attributes.
CREATE TABLE invoices
(
    invoice_id          NUMBER          NOT NULL    UNIQUE,
    vendor_id           NUMBER          NOT NULL,
    invoice_number      VARCHAR2(50)    NOT NULL,
    invoice_date        DATE                        DEFAULT SYSDATE,
    invoice_total       NUMBER(9, 2)    NOT NULL,
    payment_total       NUMBER(9, 2)                DEFAULT 0
);
-- A table with column-level contstraints
DROP TABLE vendors;
CREATE TABLE vendors
(
    vendor_id       NUMBER          PRIMARY KEY,
    vendor_name     VARCHAR2(50)    NOT NULL        UNIQUE
);
--A table with named column-level constraints
DROP TABLE vendors;
CREATE TABLE vendors
(
    vendor_id       NUMBER          CONSTRAINT vendors_pk PRIMARY KEY,
    vendor_name     VARCHAR2(50)    CONSTRAINT vendor_name_nn NOT NULL
                                    CONSTRAINT vendor_name_un UNIQUE
);
-- A table with table-level constraints
CREATE TABLE vendors
(
    vendor_id       NUMBER,
    vendor_name     VARCHAR2(50)        NOT NULL,
    CONSTRAINT vendors_pk PRIMARY KEY (vendor_id),
    CONSTRAINT vendor_name_uq UNIQUE  (vendor_name)
);
DROP TABLE vendors;

-- A table with a two-column primary key constraint
CREATE TABLE invoice_line_items
(
    invoice_id              NUMBER          NOT NULL,
    invoice_sequence        NUMBER          NOT NULL,
    line_item_description   VARCHAR2(100)   NOT NULL,
    CONSTRAINT line_items_pk PRIMARY KEY (invoice_id, invoice_sequence)
);

-- A table with a column-level foreign key constraint
DROP TABLE invoices;
CREATE TABLE invoices
(
    invoice_id      NUMBER          PRIMARY KEY,
    vendor_id       NUMBER          REFERENCES vendors  (vendor_id),
    invoice_number  VARCHAR2(50)    NOT NULL     UNIQUE
);
-- A table with a table-level foreign key constraint
DROP TABLE invoices;
CREATE TABLE invoices 
(
    invoice_id      NUMBER          NOT NULL,
    vendor_id       NUMBER          NOT NULL,
    invoice_number  VARCHAR2(50)    NOT NULL        UNIQUE,
    CONSTRAINT invoices_pk
        PRIMARY KEY (invoice_id),
    CONSTRAINT invoices_fk_vendors
        FOREIGN KEY (vendor_id) REFERENCES vendors  (vendor_id)
);

--An INSERT statement that fails because a related row doesn't exist
INSERT INTO invoices
VALUES (1, 1, '1');

-- A constraint that uses the ON DELETE clause
CONSTRAINT invoices_fk_vendors
    FOREIGN KEY (vendor_id) REFERENCES vendors (vendor_id)
    ON DELETE CASCADE;
    
-- A table with a column-level foreign key constraint
DROP TABLE invoices;
CREATE TABLE invoices
(
    invoice_id          NUMBER          PRIMARY KEY,
    vendor_id           NUMBER          REFERENCES vendors (vendor_id),
    invoice_number      VARCHAR2(50)    NOT NULL        UNIQUE
);

-- A statement that creates a table with two column-level check constraints
DROP TABLE invoices;
CREATE TABLE invoices
(
    invoice_id          NUMBER          PRIMARY KEY,
    invoice_total       NUMBER(9, 2)    NOT NULL        CHECK(invoice_total >= 0),
    payment_total       NUMBER(9, 2)    DEFAULT 0       CHECK(payment_total >= 0)
);

-- The same statement with the check constraints coded at the table level
DROP TABLE invoices;
CREATE TABLE invoices
(
    invoice_id          NUMBER          PRIMARY KEY,
    invoice_total       NUMBER(9, 2)    NOT NULL,
    payment_total       NUMBER(9, 2)    DEFAULT 0,
    CONSTRAINT invoices_ck CHECK (invoice_total >= 0 AND payment_total >= 0)
);
-- An INSERT statement that fails due to the check constraint
INSERT INTO invoices
VALUES (1, 99.99, -10); -- check constraint violated because payment_total value (-10) is less than 0. 

-->-- HOW TO ALTER THE COLUMNS OF A TABLE -->--
-- A statement that adds a new column
ALTER TABLE vendors
ADD last_transaction_date DATE;
--A statement that drops a column
ALTER TABLE vendors
DROP COLUMN last_transaction_date;--here

-- A statement that changes the length of a column
ALTER TABLE vendors
MODIFY vendor_name VARCHAR2(100);--here

-- A statement that changes the data type of a column
ALTER TABLE vendors
MODIFY vendor_name CHAR(100);--here
--A statement that changes the default value of a column
ALTER TABLE vendors
MODIFY vendor_name DEFAULT 'New Vendor';
--A statement that fails because it would cause data to be lost
ALTER TABLE vendors
MODIFY vendor_name VARCHAR2(9);

-->-->-- HOW TO ALTER THE CONSTRAINTS OF A TABLE -->-->--
--A statement that adds a new check constraint
ALTER TABLE invoices
ADD CONSTRAINT invoice_total_ck CHECK (invoice_total >= 0);
--A statement that drops a check constraint.
ALTER TABLE invoices
DROP CONSTRAINT invoice_total_ck;

--A statement that adds a disabled constraint
ALTER TABLE invoices
ADD CONSTRAINT invoice_total_ck CHECK (invoice_total >= 1) DISABLE;
--A statement that enables a constraint for new values only
ALTER TABLE invoices
ENABLE NOVALIDATE CONSTRAINT invoice_total_ck;
--A statement that disables a constraint
ALTER TABLE invoices
DISABLE CONSTRAINT invoice_total_ck;
--A statement that adds a foreign key constraint
ALTER TABLE invoices
ADD CONSTRAINT invoice_fk_vendors
FOREIGN KEY (vendor_id) REFERENCES vendors (vendor_id);

--A statement that adds a unique constraint
ALTER TABLE vendors
ADD CONSTRAINT vendors_vendor_name_uq
UNIQUE (vendor_name);
--A statement that adds a not null constraint
ALTER TABLE vendors
MODIFY vendor_name
CONSTRAINT vendors_vendor_name_nn NOT NULL;

-->-- HOW TO RENAME, TRUNCATE, AND DROP A TABLE -->--

--A statement that renames a table--
RENAME vendors TO vendor;
--A statement that deletes all data from a table
TRUNCATE TABLE vendor;
--A statement that deletes a table from the current schema--
DROP TABLE ex.vendor;

-->00 HOW TO WORK WITH INDEXES 00 -->
--> HOW TO CREATE AN INDEX >--
--A statement that creates an index based on a single column
CREATE INDEX invoices_vendor_id_ix
    ON invoices (vendor_id);
--A statement that creates an index based on two columns
CREATE INDEX invoices_vendor_id_inv_no_ix
    ON invoices (vendor_id, invoice_number);
--A statement that creates a unique index
CREATE UNIQUE INDEX vendors_vendor_phone_ix
    ON vendors (vendor_phone);
--A statement that creates an index that's sorted in descending order
CREATE INDEX invoices_invoice_total_ix
    ON invoices (invoice_total DESC);
--A statement that creates a function-base index
CREATE INDEX vendors_vendor_name_upper_ix
    ON vendors (UPPER(vendor_name));
--Another statement that creates a function-based index
CREATE INDEX invoices_balance_due_ix
    ON invoices (invoice_total - payment_total - credit_total DESC);
--How to enable function-based indexes
CONNECT system/system;
ALTER SYSTEM SET QUERY_REWRITE_ENABLED=TRUE;
--A statement that drops an index
DROP INDEX vendors_vendor_state_ix;

--<>-- HOW TO WORK WITH SEQUENCES --<>--
--HOW TO CREATE A SEQUENCE--
--A statement that creates a sequence of integers that starts with 1 and is incremented by 1
CREATE SEQUENCE vendor_id_seq;
--A statement that specifies a starting integer for a sequence
CREATE SEQUENCE vendor_id_seq
    START WITH 124;
--A statement that specifies all optional parameters for a sequence
CREATE SEQUENCE test_seq
    START WITH 100 INCREMENT BY 10
    MINVALUE 0 MAXVALUE BY 1000000
    CYCLE CACHE 10 ORDER;
--A statement that uses the NEXTVAL pseudo column to get the next value for a
-- sequence.
INSERT INTO vendors
VALUES (vendor_id_seq.NEXTVAL, 'Acme Co.', '123 Main St.', NULL,
        'Fresno', 'CA', '93711', '(800) 221-5528', 
        'Wiley', 'Coyote');
--A statement that uses the CURRVAL pseudo column to get the current value of th-
--e sequence.
SELECT vendor_id_seq.CURRVAL from dual;

--> HOW TO ALTER A SEQUENCE >--
-- HOW TO DROP A SEQUENCE
--A statement tnat alters a sequence
ALTER SEQUENCE test_seq
    INCREMENT BY 9
    MINVALUE 99 MAXVALUE 999999
    NOCYCLE CACHE 9 NOORDER;
--A statement that drops a sequence
DROP SEQUENCE test_seq;

