-- Lab 10 MGS Jesus Hilario Hernandez
-- 1. 
CREATE OR REPLACE VIEW customer_addresses AS
    SELECT 
        c.customer_id, c.email_address, c.last_name, c.first_name,
        a1.line1 AS bill_line1, a1.line2 AS bill_line2, a1.city AS bill_city, a1.state AS bill_state, a1.zip_code AS bill_zip,
        a2.line1 AS ship_line1, a2.line2 AS ship_line2, a2.city AS ship_city, a2.state AS ship_state, a2.zip_code AS ship_zip
        FROM Addresses a1 
            JOIN Customers c
                ON a1.address_id = c.billing_address_id
            JOIN Addresses a2
                ON c.shipping_address_id = a2.address_id;
--2. 
SELECT *
FROM customer_addresses;

--3. 
CREATE OR REPLACE VIEW order_item_products AS
SELECT o.order_id, o.order_date, o.tax_amount, o.ship_date,
       oi.item_price, oi.discount_amount, (oi.item_price - oi.discount_amount) AS final_price,
       oi.quantity, SUM((oi.item_price - oi.discount_amount) * (oi.quantity)) AS item_total,
       p.product_name
FROM Orders o 
    JOIN Order_items oi
        ON o.order_id = oi.order_id
    JOIN Products p
        ON oi.product_id = p.product_id
GROUP BY o.order_id, o.order_date ,o.tax_amount, o.ship_date,
         oi.item_price, oi.discount_amount, oi.quantity, p.product_name;
        
--4. 
CREATE OR REPLACE VIEW product_summary AS
SELECT product_name, quantity AS order_count, item_total AS order_total
FROM order_item_products; 


--5. A SELECT statement that uses the view that you created in exercixe 5 to get
-- total sales for the five best selling products
SELECT best_selling_products
FROM (SELECT order_total AS best_selling_products
      FROM product_summary
      ORDER BY order_total DESC)
WHERE ROWNUM <= 5;