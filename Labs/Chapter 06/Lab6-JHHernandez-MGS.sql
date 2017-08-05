--1. Write a SELECT statement that returns the same result set as this SELECT
    -- statement, but don't use a join. Instead, use a subquery in a WHERE
    -- clause that uses the IN keyword.
--    SELECT DISTINCT category_name
--    FROM categories c JOIN products p
--        ON c.category_id = p.category_id
--    ORDER BY category_name;
SELECT category_name
FROM categories
WHERE category_id IN
    (SELECT category_id FROM products)
ORDER BY category_name;

--2. Write a SELECT statement that answers this question: Which products have a list
--   price that's greater than the average list_price for all products?
--   Return the product_name and list_price columns for each product.
--   Sort the results by the list_price column in descending sequence. 
SELECT product_name, list_price
FROM Products WHERE list_price > 
    (SELECT AVG(list_price)
     FROM Products)
ORDER BY list_price DESC;

--3. Write a SELECT statement that returns the category_name column from the Categories
    -- table. Return one row for each category that has never been assigned to any product
    -- in the Products table. To do that, use a subquery introduced with the NOT
    -- EXISTS operator.
SELECT category_name FROM Categories
WHERE NOT EXISTS
    (SELECT category_id
     FROM Products
     WHERE categories.category_id = products.category_id);
     
--4. Write a SELECT statement that returns three columns: 
--      email_address, 
--      order_id, and
--      the order total for each customer.
--   To do this, you can group the result set by the
--   email_address and order_id columns. In addition, you must calculate the order total
--   from the columns in the Order_items table

--      Write a second SELECT statement that uses the first SELECT statement in its FROM
--   clause. The main query should return two columns: the customer's email address and
--   the largest order for that customer. To do this, you can group the result set by the
--   email_address.
--SELECT c.email_address, o.order_id, SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS order_total
--FROM Order_Items oi 
--    JOIN Orders o
--        ON oi.order_id = o.order_id 
--    JOIN Customers c
--        ON o.customer_id = c.customer_id
--GROUP BY email_address, o.order_id;

SELECT email_address, MAX(order_total) AS largest_order_for_customer
FROM (SELECT c.email_address, o.order_id, SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS order_total
      FROM Order_Items oi 
        JOIN Orders o
            ON oi.order_id = o.order_id 
        JOIN Customers c
            ON o.customer_id = c.customer_id
      GROUP BY email_address, o.order_id)
GROUP BY email_address;


--5. Write a SELECT statement that returns the name and discount percent of each
-- product that has a unique discount percent. In other words, don't include products
-- that have the same discount percent as another product. 
-- Sort the results by the product_name column.
SELECT product_name, discount_percent
FROM Products
WHERE discount_percent NOT IN
    (SELECT discount_percent
     FROM Products
     GROUP BY discount_percent
     HAVING COUNT(*) > 1)
ORDER BY product_name;
     
--6. Use a correlated subquery to return one row per customer, representing the
-- customer's oldest order (the one with the earliest date). Each row should include
-- these three columns: email_address, order_id, and order_date.
SELECT email_address, order_id, order_date
FROM Customers c JOIN Orders o
    ON c.customer_id = o.customer_id
WHERE order_date = 
    (SELECT MIN(order_date)
     FROM Orders o_2 JOIN Customers c_2
        ON o_2.customer_id = c_2.customer_id
     WHERE c_2.email_address = c.email_address);
