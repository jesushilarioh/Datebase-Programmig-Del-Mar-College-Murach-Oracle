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
    START WITH 120;  
    -- For products table
CREATE SEQUENCE product_id_seq
    START WITH 120;
    -- For downloads table
CREATE SEQUENCE  download_id_seq
    START WITH 120;
    
-- CREATE necessary indexes --
CREATE INDEX downloads_users_id_ix
    ON downloads (user_id);
CREATE INDEX downloads_products_id_ix
    ON downloads (product_id);
