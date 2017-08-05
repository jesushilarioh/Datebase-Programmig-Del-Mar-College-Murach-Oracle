--1. 
SELECT list_price, TO_CHAR(list_price, '$99,999.99')
FROM Products;

--2. 
SELECT date_added, CAST(date_added AS VARCHAR2(9)) AS "Date_added as Character"
FROM Products;

--3. 
SELECT list_price, discount_percent, 
    TO_CHAR(ROUND(TO_NUMBER(list_price) * TO_NUMBER(discount_percent * .01) , 2), '99,999.99') AS "Discount Amount"
FROM Products;

--4. 
SELECT order_date, 
       TO_CHAR(order_date, 'YYYY') AS "order_date year", 
       TO_CHAR(order_date, 'MON-DD-YYYY') AS "order_date reformatted_1",
       TO_CHAR(order_date, 'HH:MI PM') AS "hours_and_minutes",
       TO_CHAR(order_date, 'MM/DD/YY HH24:MI') AS "order_date reformatted_2"
FROM Orders;

--5. 
SELECT card_number, 
       TO_CHAR(LENGTH(card_number)) AS "Card_#_length",
       SUBSTR(REPLACE(card_number, ' ', 0), 13),
       LENGTH(card_number) - 4
FROM Orders; --?

--6. 
SELECT  order_id, order_date, order_date + 2 AS approx_ship_date, ship_date,
    ship_date - order_date AS days_to_ship
FROM Orders
WHERE order_date < '01-APR-12' AND order_date >= '01-MAR-12';