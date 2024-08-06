-- Insert data into location table
INSERT INTO location (location_name, city, state, postal_code, country) VALUES
('Main Office', 'New York', 'NY', '10001', 'USA'),
('Warehouse A', 'Los Angeles', 'CA', '90001', 'USA'),
('Pharmacy B', 'Chicago', 'IL', '60601', 'USA');

-- Insert data into compony table
INSERT INTO compony (location_id, compony_email, compony_name) VALUES
(1, 'info@companya.com', 'Company A'),
(2, 'contact@companyb.com', 'Company B');

-- Insert data into distributors table
INSERT INTO distributors (phone_number, distributor_email, distributor_name) VALUES
('1234567890', 'distributor1@distributor.com', 'Distributor 1'),
('0987654321', 'distributor2@distributor.com', 'Distributor 2');

-- Insert data into purchase_from table
INSERT INTO purchase_from (distributor_id, compony_id) VALUES
(1, 1),
(2, 2);

-- Insert data into warehouse table
INSERT INTO warehouse (location_id, distributor_id, warehouse_capacity, warehouse_email, warehouse_name) VALUES
(2, 1, '10000 sq ft', 'warehouse1@warehouse.com', 'Warehouse 1'),
(2, 2, '20000 sq ft', 'warehouse2@warehouse.com', 'Warehouse 2');

-- Insert data into warehouse_employee table
INSERT INTO warehouse_employee (warehouse_id, employee_role, employee_email, employee_first_name, employee_last_name, hire_date) VALUES
(1, 'Manager', 'manager1@warehouse.com', 'John', 'Doe', '2023-01-15'),
(2, 'Assistant', 'assistant1@warehouse.com', 'Jane', 'Smith', '2023-02-20');

-- Insert data into product table
INSERT INTO product (compony_id, product_name, product_price) VALUES
(1, 'Aspirin', 10.50),
(2, 'Bandage', 2.75);

-- Insert data into medicine table
INSERT INTO medicine (product_id, expiry_date, dosage_form, strength) VALUES
(1, '2025-12-31', 'Tablet', '500mg'),
(2, '2026-06-30', 'Bandage', 'N/A');

-- Insert data into instruments table
INSERT INTO instruments (product_id, modal_number, warranty_period) VALUES
(1, 'ASP-123', '2024-12-31'),
(2, 'BAN-456', '2025-06-30');

-- Insert data into warehouse_inventory table
INSERT INTO warehouse_inventory (warehouse_id, product_id, quantity, last_updated) VALUES
(1, 1, 100, '2024-08-06'),
(2, 2, 200, '2024-08-06');

-- Insert data into customers table
INSERT INTO customers (location_id, customer_name, customer_email) VALUES
(3, 'Pharmacy B', 'pharmacyb@pharmacy.com');

-- Insert data into pharmacy table
INSERT INTO pharmacy (location_id, pharmacy_number, pharmacy_email, pharmacy_manager, opening_hours) VALUES
(3, '1112223333', 'contact@pharmacyb.com', 'Alice Johnson', '9AM - 5PM');

-- Insert data into pharmacy_employee table
INSERT INTO pharmacy_employee (pharmacy_id, location_id, first_name, last_name, role, email, hire_date) VALUES
(1, 3, 'Emily', 'Clark', 'Pharmacist', 'emily@pharmacyb.com', '2024-03-01'),
(1, 3, 'Michael', 'Brown', 'Pharmacy Technician', 'michael@pharmacyb.com', '2024-04-01');

-- Insert data into pharmacy_products table
INSERT INTO pharmacy_products (pharmacy_id, product_id, stock_quantity) VALUES
(1, 1, 50),
(1, 2, 100);

-- Insert data into sales table
INSERT INTO sales (pharmacy_id, customer_id, total_amount, sale_date, sale_status) VALUES
(1, 1, 500.00, '2024-08-05', TRUE);

-- Insert data into sale_items table
INSERT INTO sale_items (sale_id, pharmacy_product_id, quantity, unit_price, total_price) VALUES
(1, 1, 10, 10.50, 105.00),
(1, 2, 20, 2.75, 55.00);

-- Insert data into sales_invoice table
INSERT INTO sales_invoice (sale_id, invoice_date, invoice_amount, invoice_status) VALUES
(1, '2024-08-06', 160.00, TRUE);

-- Insert data into pharmacy_order table
INSERT INTO pharmacy_order (pharamacy_id, distributor_id, order_date, total_amount) VALUES
(1, 1, '2024-08-01', 200.00);

-- Insert data into order_items table
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 20, 10.50, 210.00),
(1, 2, 50, 2.75, 137.50);
