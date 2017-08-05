--1. Write a script that adds an index to the order_date column in the Orders table in the mgs schema
CREATE INDEX orders_order_date_id_ix
    ON Orders (order_date);

--2. 
-- Connect to database --
CONNECT ex/ex;
-- PL/SQL script
BEGIN 

    EXECUTE IMMEDIATE 'DROP SEQUENCE user_id_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE product_id_seq';
    EXECUTE IMMEDIATE 'DROP SEQUENCE download_id_seq';
    
    EXECUTE IMMEDIATE 'DROP TABLE downloads';
    EXECUTE IMMEDIATE 'DROP TABLE products';
    EXECUTE IMMEDIATE 'DROP TABLE users';

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('');
END;
/   
--END PL/SQL script.


-- CREATE users table --
CREATE TABLE users
(
    user_id         NUMBER          PRIMARY KEY,
    email_address   VARCHAR2(255)   NOT NULL        UNIQUE,
    first_name      VARCHAR2(60)    NOT NULL,
    last_name       VARCHAR(60)     NOT NULL
);

--CREATE products table--
CREATE TABLE products
(
    product_id      NUMBER          PRIMARY KEY,
    product_name    VARCHAR2(255)   NOT NULL
);
-- CREATE downloads table --
CREATE TABLE downloads
(
    download_id     NUMBER          PRIMARY KEY,
    user_id         NUMBER          REFERENCES users (user_id),
    download_date   DATE                            DEFAULT NULL,
    filename        VARCHAR2(1500)  NOT NULL,
    product_id      NUMBER          REFERENCES products (product_id)
);

-- CREATE sequences for primary all primary keys --

    -- For users table
CREATE SEQUENCE user_id_seq
    START WITH 1;  
    -- For products table
CREATE SEQUENCE product_id_seq
    START WITH 1;
    -- For downloads table
CREATE SEQUENCE  download_id_seq
    START WITH 1;
    
-- CREATE necessary indexes --
CREATE INDEX downloads_users_id_ix
    ON downloads (user_id);
CREATE INDEX downloads_products_id_ix
    ON downloads (product_id);

--3. 
-- Add two rows to the Users and Products tables. --
INSERT INTO users VALUES (user_id_seq.NEXTVAL, 'james@james.com', 'James', 'Wilson' );
INSERT INTO users VALUES (user_id_seq.NEXTVAL, 'john@john.com', 'John', 'Williams');
INSERT INTO products VALUES (product_id_seq.NEXTVAL, 'radigast');
INSERT INTO products VALUES (product_id_seq.NEXTVAL, 'whoanin');

-- Add 3 rows to the Downloads table --
    -- for user 1, product 2
INSERT INTO downloads VALUES (download_id_seq.NEXTVAL, 1, SYSDATE, 'whoanin_download_file.mp3', 2);
    -- for user 2, product 1
INSERT INTO downloads VALUES (download_id_seq.NEXTVAL, 2, SYSDATE, 'radigast_download_file.mp3', 1);
    -- For user 2, product 2
INSERT INTO downloads VALUES (download_id_seq.NEXTVAL, 2, SYSDATE, 'whoanin_download_file.mp3', 2);

-- Write a SELECT statement that joins the 3 tables and retrieves the data from all tables.
SELECT email_address, first_name, last_name, download_date, filename, 
    product_name
FROM users u 
    JOIN downloads d
        ON u.user_id = d.user_id
    JOIN products p
        ON d.product_id = p.product_id
ORDER BY email_address DESC, product_name ASC;

--4.
-- Write an ALTER TABLE statement that adds woth new columns to the Products table
    -- Add one column for product price that provides for three digits to the left
    -- of the decimal point and two to the right.
ALTER TABLE products
ADD product_price NUMBER(1,2);
    -- Add one column for the date and time that the product was added to the database
ALTER TABLE products
ADD date_product_added DATE;

--5. 
-- Write an ALTER TABLE statement that modifies the Users table
    -- so that first_name column can store NULL values and can store a max of 20 characters
ALTER TABLE users
MODIFY first_name VARCHAR2(20) NULL;

    -- Code an UPDATE statement that inserts a NULL value into this column.
    -- It should work this column now allows NULL values.
UPDATE users
SET first_name = NULL
WHERE user_id = 1;

    -- Code another UPDATE statement that attempts to insert a first name that's longer
    -- than 20 characters. It should fail due to the length of the column.
UPDATE users
SET first_name = 'jkleiuronendlsiehjrnfleij'
WHERE user_id = 2;