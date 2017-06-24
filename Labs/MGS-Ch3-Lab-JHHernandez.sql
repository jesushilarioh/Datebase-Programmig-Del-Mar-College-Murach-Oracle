-- 1 write a SELECT statement that returns four columns from the Products table.
	-- Add ORDER BY clause that sorts by list_price, descending

SELECT product_code, product_name, list_price, discount_percent
FROM products -- SCREEN SHOT
ORDER BY list_price DESC; -- SCREEN SHOT


-- 2 Write a SELECT statement that returns one column from
	-- Customers named full_name that joins the last_name and first_name columns.

SELECT last_name || ', ' || first_name AS full_name
FROM Customers
WHERE last_name >= 'M' AND last_name <= 'Z'
ORDER BY last_name; -- SCREEN SHOT


--3 Write a SELECT statment that returns columns from Products table:
	-- Return only the rows with a list price that's greater than 500
	-- and less than 2000.
	-- Sort result in DESC order by date_added

SELECT product_name, list_price, date_added
FROM Products
WHERE list_price > 500 AND list_price < 2000
ORDER BY date_added DESC; -- SCREEN SHOT


-- 4 Write a SELECT statement that returns column names from Products table:
	-- Use the ROWNUM pseudo column so the result set contains only the first 5 rows.
	-- Sort the result set by discount price in descending sequence.

SELECT product_name, list_price, discount_percent,
    (list_price - discount_percent) AS discount_amount,
    list_price - (list_price - discount_percent) AS discount_price
FROM Products
WHERE ROWNUM <= 5
ORDER BY discount_price DESC; -- SCREEN SHOT


-- 5 Write a SELECT statement that returns columns from Order_Items table:
	-- Only return rows where the item_total is greater than 500.
	-- Sort the result set by item total in descending sequence.

SELECT item_id, item_price, discount_amount, quantity,
		(item_price * quantity) AS price_total,
    (discount_amount * quantity) AS discount_total,
    (item_price - discount_amount) * quantity AS item_total
FROM Order_Items
WHERE ((item_price - discount_amount) * quantity) > 500
ORDER BY item_total DESC; -- SCREEN SHOT



-- WORK WITH NULLS AND TEST EXPRESSIONS --
-- WORK WITH NULLS AND TEST EXPRESSIONS --
-- WORK WITH NULLS AND TEST EXPRESSIONS --


-- 6 Write a SELECT statement that returns these columns from the Orders table:
	-- Return only the rows where the ship_date column contains a null value.

SELECT order_id, order_date, ship_date
FROM Orders
WHERE ship_date IS NULL; -- SCREEN SHOT

-- 7 Write a SELECT statement that uses the SYSDATE function to create a row with these columns:
	-- This displays a number for the month, a number for the day, and a four-digit year.
	-- Use a FROM clause that specifies the Dual table.

SELECT
    SYSDATE AS today_unformatted,
    TO_CHAR(SYSDATE, 'MM-DD-YYYY') AS today_formatted
FROM Dual; -- SCREEN SHOT

-- 8 Write a SELECT statement that creates a row with these columns;
	-- To calculate the fourth column, add the expressions you used for the first and third columns.
	-- Use a FROM clause that specifies the Dual table.

SELECT
    100 AS price,
    .07 AS tax_rate,
    (100 * .07) AS tax_amount,
    (100 + (100 * .07)) AS total
FROM Dual; -- SCREEN SHOT
