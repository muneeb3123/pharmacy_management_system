-- 1. Get the total stock quantity of each product in all warehouses
SELECT w.warehouse_name, p.product_name, SUM(wi.quantity) AS total_stock
FROM product p
JOIN warehouse_inventory wi ON p.product_id = wi.product_id
JOIN warehouse w ON wi.warehouse_id = w.warehouse_id
GROUP BY p.product_name, w.warehouse_name;

-- 2. List all pharmacy sales with a total amount greater than a specified value
SELECT s.sale_id, p.pharmacy_name, s.total_amount, s.sale_date
FROM sales s
JOIN pharmacy p ON s.pharmacy_id = p.pharmacy_id
WHERE s.total_amount > 100;

-- 3. Find the top 3 pharmacies with the highest sales totals for the current year
SELECT p.pharmacy_name, SUM(s.total_amount) AS yearly_sales
FROM sales s
JOIN pharmacy p ON s.pharmacy_id = p.pharmacy_id
WHERE EXTRACT(YEAR FROM s.sale_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY p.pharmacy_name
ORDER BY yearly_sales DESC
LIMIT 3;

-- 4. Get the most recent order and its items for a specific pharmacy
SELECT o.order_id, oi.product_id, d.distributor_name, p.product_name, oi.quantity, oi.unit_price, oi.total_price
FROM distributors d
JOIN pharmacy_order o ON d.distributor_id = o.distributor_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN product p ON oi.product_id = p.product_id
WHERE o.pharamacy_id = 1
ORDER BY o.order_date DESC
LIMIT 1;

-- 5. Calculate the average sale amount per customer for the past month
SELECT c.customer_name, AVG(s.total_amount) AS average_sale_amount
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
WHERE s.sale_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY c.customer_name;

-- 6. Show the total quantity of each product ordered by a particular distributor
SELECT p.product_name, SUM(oi.quantity) AS total_ordered
FROM order_items oi
JOIN pharmacy_order o ON oi.order_id = o.order_id
JOIN product p ON oi.product_id = p.product_id
WHERE o.distributor_id = 1
GROUP BY p.product_name;

-- 7. Find the total revenue generated by each pharmacy in the last year
SELECT p.pharmacy_name, SUM(s.total_amount) AS total_revenue
FROM sales s
JOIN pharmacy p ON s.pharmacy_id = p.pharmacy_id
WHERE s.sale_date >= DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 year'
GROUP BY p.pharmacy_name;

-- 8. Retrieve the most recent hire date for employees in each pharmacy
SELECT f.pharmacy_name, MAX(e.hire_date) AS most_recent_hire
FROM pharmacy_employee e
JOIN pharmacy f ON e.pharmacy_id = f.pharmacy_id
GROUP BY f.pharmacy_name;

-- 9. List all products in warehouse with their current stock levels and respective prices
SELECT p.product_name, wi.quantity AS current_stock, p.product_price
FROM product p
JOIN warehouse_inventory wi ON p.product_id = wi.product_id;
