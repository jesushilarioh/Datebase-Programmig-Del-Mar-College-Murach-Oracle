Lab MGS Chapter 5 -- Jesus Hilario Hernandez

-- 1. Select statement that returns count of orders and tax_amout from Orders
SELECT COUNT(*) AS num_of_orders, SUM(tax_amount) AS tax_amt 
FROM Orders;    -- SCREENSHOT

-- 2. A SELECT statement that returns one row for each category
SELECT c.category_name, COUNT(p.product_id), MAX(p.list_price)
FROM Products p JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY COUNT(p.product_id) DESC;

-- 3. A SELECT statement that returns a row for each customer
SELECT c.email_address, SUM(oi.item_price * oi.quantity) AS item_price_total, 
    SUM(oi.discount_amount * oi.quantity) AS item_price_discount
FROM Customers c JOIN Orders o
    ON c.customer_id = o.customer_id
        JOIN Order_Items oi
    ON o.order_id = oi.order_id 
GROUP BY c.email_address
ORDER BY item_price_total DESC; --Screen Shot

-- 4. A SELECT that returns one row for each customer that has orders
SELECT c.email_address, COUNT(*) AS number_of_orders, 
    SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS total_amt
FROM Customers c 
    JOIN Orders o 
        ON c.custommer_id = o.customer_id
    JOIN Order_Items oi
        ON o.order_id = oi.order_id
GROUP BY c.email_address
HAVING COUNT(*) > 1
ORDER BY total_amt; -- SCREEN SHOT

-- 5. Modify the solution to excercise 4 so it only counts and totals items
    -- that have an item_price value that's greater that 400.
SELECT c.email_address, COUNT(*) AS number_of_orders, 
    SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS total_amt
FROM Customers c 
    JOIN Orders o 
        ON c.customer_id = o.customer_id
    JOIN Order_Items oi
        ON o.order_id = oi.order_id
WHERE oi.item_price > 400
GROUP BY c.email_address
HAVING COUNT(*) > 1
ORDER BY total_amt; --

-- 6. Write a SELECT statement that answers this question: What is the total
    -- amount ordered for each product?
SELECT product_name, SUM((item_price - discount_amount) * quantity) AS amount
FROM Products p JOIN Order_Items oi
    ON p.product_id = oi.product_id
GROUP BY ROLLUP(product_name);

--7. Write a SELECT statement that answers this question: Which customers have
    -- ordered more than one product?
SELECT c.email_address, COUNT(DISTINCT oi.item_id) item_count
FROM Customers c 
    JOIN Orders o
        ON c.customer_id = o.customer_id
    JOIN Order_Items oi
        ON o.order_id = oi.order_id
    JOIN Products p
        ON oi.product_id = p.product_id
GROUP BY c.email_address
HAVING COUNT(DISTINCT oi.item_id) > 1;
