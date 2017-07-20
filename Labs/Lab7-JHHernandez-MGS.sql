-- LAB 7 - JESUS HILARIO HERNANDEZ - MGS --

--1.
INSERT INTO Categories 
    (category_id, category_name)
VALUES
    (5, 'Brass');
COMMIT;

--2.
UPDATE Categories
SET category_name = 'Woodwinds'
WHERE category_id = 5;

--3. 
DELETE FROM Categories
WHERE category_id = 5;

--4. 
INSERT INTO Products
    (product_id, category_id, product_code, product_name, description,
     list_price, discount_percent, date_added)
VALUES (11, 4, 'dgx_640', 'Yamaha DGX 640 88-Key Digital Piano', 'Long description to come.',
        799.99, 0, '16-JUL-17');
        
--5. 
UPDATE Products
SET discount_percent = 35
WHERE product_id = 11;

--6.
DELETE FROM Categories
WHERE Category_id = 1;
DELETE FROM Products
WHERE Category_id = 4;

--7. 
INSERT INTO Customers
    (customer_id, email_address, password, first_name, last_name)
VALUES (9, 'rick@raven.com', 'sesame', 'Rick', 'Raven');

--8.
UPDATE Customers
SET password = 'secret'
WHERE email_address = 'rick@raven.com';

--9.
UPDATE Customers
SET password = 'reset';

--10.
