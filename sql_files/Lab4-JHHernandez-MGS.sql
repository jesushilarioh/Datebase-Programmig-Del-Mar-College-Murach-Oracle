/***************************
    Jesus Hilario Hernandez
    Lab 4 MGS 
****************************/
--1. Write a SELECT statement that joins the Categories Table to the Products
     -- table and returns the columns: category_name, product_name in
     -- ascending sequence.
SELECT category_name, product_name, list_price
FROM Products JOIN Categories
    ON Products.CATEGORY_ID = Categories.CATEGORY_Id
ORDER BY category_name, product_name; --SCREEN SHOT

--2. Write a SELECT statement that joins the Customers table to the
     -- Addresses table and returns these columns: first_name, last_name
     -- line1, city, state, zip_code.
     --
     -- Return one row for each address for the customer with an email
     -- address of alla.sherwood@yahoo.com.
SELECT first_name, last_name, line1, city, state, zip_code
FROM Addresses JOIN Customers
    ON Addresses.customer_id = Customers.customer_id
WHERE email_address = 'allan.sherwood@yahoo.com'; -- SCREEN SHOT

--3. Write a SELECT statement that joins the Customers table  to the
     -- Addresses table and returns these columns: first_name, last_name,
     -- line1, city, state, zip_code.
     --
     -- Return one row for each customer, but only return addresses that are
     -- the shipping address for a customer.
SELECT first_name, last_name, line1, city, state, zip_code
FROM Addresses JOIN Customers
    ON Addresses.customer_id = Customers.customer_id
WHERE shipping_address_id IS NOT NULL; -- SCREEN SHOT

--4 Write a SELECT statement that joins the Customers, Orders, Order_Items,
    -- and Products tables. This statement should return these columns: 
    -- last_name, first_name, order_date, product_name, item_price,
    -- discount_amount, and quantity.
    -- Use aliases for the tables
    -- Sort the final results set by last_name, order_date, and product_name.
SELECT last_name, first_name, order_date, product_name, item_price,
       discount_amount, quantity
FROM Customers c 
    JOIN Orders o 
        ON c.customer_id = o.customer_id
    JOIN Order_Items oi 
        ON o.order_id = oi.order_id
    JOIN Products p
        ON oi.product_id = p.product_id
ORDER BY last_name, order_date, product_name; -- SCREEN SHOT

-- 5. Write a SELECT statement that returns the product_name and list_price
      -- columns from the Products table.
      -- Return one row for each product that has the same list price as
      -- another product.
      -- Sort the result set by product_name. 
SELECT DISTINCT p1.product_name, p2.list_price
FROM Products p1 JOIN Products p2
    ON (p1.product_id != p2.product_id) AND
       (p1.list_price = p2.list_price)
ORDER BY product_name; -- SCREEN SHOT

--6. Write a SELECT statement that returns two columns:
     -- category_name from Categories tale and 
     -- product_id from the Products table.
     -- Return one tow for each category that has never been used.
SELECT category_name, product_id
FROM Categories JOIN Products
    ON Categories.category_id = Products.category_id
WHERE product_id IS NULL;

--7.  Use the UNION operator to generate a result set consisting of three
      -- columns from the Orders table: ship_status, order_id, and
      -- order_date.
      -- If the order has a valuse in the ship_date column, the ship_status
      -- column should contain a value of SHIPPED. Otherwise, it should
      -- contain a value of NOT SHIPPED.
      -- Sort the final result set by order_date.
SELECT 'SHIPPED' AS ship_status, order_id, order_date
FROM Orders
WHERE ship_date IS NULL
    UNION
SELECT 'NOT SHIPPED' AS ship_status, order_id, order_date
FROM Orders
WHERE ship_date IS NOT NULL
    ORDER BY order_date;