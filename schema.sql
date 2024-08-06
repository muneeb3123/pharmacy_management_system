-- Create the location table
CREATE TABLE location (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  location_name VARCHAR(255) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NOT NULL,
  postal_code VARCHAR(20) NOT NULL,
  country VARCHAR(100) NOT NULL
);

-- Create the compony table
CREATE TABLE compony (
  compony_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  location_id INT REFERENCES location(id),
  compony_email VARCHAR(255),
  compony_name VARCHAR(25) NOT NULL
);

-- Create the distributor table
CREATE TABLE distributors (
  distributor_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  phone_number VARCHAR(11),
  distributor_email VARCHAR(255),
  distributor_name VARCHAR(255) NOT NULL
);

-- Create table purchase_from
CREATE TABLE purchase_from (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  distributor_id INT REFERENCES distributors(distributor_id),
  compony_id INT REFERENCES compony(compony_id)
);

-- Create table warehouse
CREATE TABLE warehouse (
  warehouse_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  location_id INT REFERENCES location(id),
  distributor_id INT REFERENCES distributors(distributor_id),
  warehouse_capacity VARCHAR(255) NOT NULL,
  warehouse_email VARCHAR(255),
  warehouse_name VARCHAR(255) NOT NULL
);

-- Create table warehouse_employee
CREATE TABLE warehouse_employee (
  employee_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  warehouse_id INT REFERENCES warehouse(warehouse_id),
  employee_role VARCHAR(100) NOT NULL,
  employee_email VARCHAR(255),
  employee_first_name VARCHAR(255) NOT NULL,
  employee_last_name VARCHAR(255) NOT NULL,
  hire_date DATE NOT NULL
);

-- Create table product
CREATE TABLE product (
  product_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  compony_id INT REFERENCES compony(compony_id),
  product_name VARCHAR(255) NOT NULL,
  product_price DECIMAL(10,2) NOT NULL
);

-- Create table medicine
CREATE TABLE medicine (
  product_id INT REFERENCES "product"(product_id),
  medicine_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  expiry_date DATE NOT NULL,
  dosage_form VARCHAR(100) NOT NULL,
  strength VARCHAR(100) NOT NULL
);

-- Create table instruments
CREATE TABLE instruments (
  product_id INT REFERENCES "product"(product_id),
  instrument_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  modal_number VARCHAR(100) NOT NULL,
  warranty_period DATE NOT NULL
);

-- Create table warehouse_inventory
CREATE TABLE warehouse_inventory (
  inventory_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  warehouse_id INT REFERENCES warehouse(warehouse_id),
  product_id INT REFERENCES "product"(product_id),
  quantity INT NOT NULL,
  last_updated DATE NOT NULL
);

-- Create table customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  location_id INT REFERENCES location(id),
  customer_name VARCHAR(255) NOT NULL,
  customer_email VARCHAR(255) NOT NULL
);

-- Create table pharmacy
CREATE TABLE pharmacy (
  pharmacy_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  location_id INT REFERENCES location(id),
  pharmacy_name VARCHAR(255) NOT NULL,
  pharmacy_number VARCHAR(11) NOT NULL,
  pharmacy_email VARCHAR(255),
  pharmacy_manager VARCHAR(255) NOT NULL,
  opening_hours VARCHAR(255) NOT NULL
);

-- Create table pharmacy_employee
CREATE TABLE pharmacy_employee (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  pharmacy_id INT REFERENCES pharmacy(pharmacy_id),
  location_id INT REFERENCES location(id),
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  role VARCHAR(100) NOT NULL,
  email VARCHAR(255),
  hire_date VARCHAR(255) NOT NULL
);

-- Create table pharmacy_products
CREATE TABLE pharmacy_products (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  pharmacy_id INT REFERENCES pharmacy(pharmacy_id),
  product_id INT REFERENCES product(product_id),
  stock_quantity INT NOT NULL
);

-- Create table pharmacy_sales
CREATE TABLE sales (
  sale_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  pharmacy_id INT REFERENCES pharmacy(pharmacy_id),
  customer_id INT REFERENCES customers(customer_id),
  total_amount INT NOT NULL,
  sale_date DATE NOT NULL,
  sale_status BOOLEAN DEFAULT FALSE
);

-- Create table sales_item
CREATE TABLE sale_items (
  sale_item_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  sale_id INT REFERENCES sales(sale_id),
  pharmacy_product_id INT REFERENCES pharmacy_products(id),
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL
);

-- Create table sale_invoice
CREATE TABLE sales_invoice (
  invoice_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  sale_id INT REFERENCES sales(sale_id),
  invoice_date DATE NOT NULL,
  invoice_amount DECIMAL(10,2) NOT NULL,
  invoice_status BOOLEAN DEFAULT FALSE
);

-- Create table order
CREATE TABLE pharmacy_order (
  order_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  pharamacy_id INT REFERENCES pharmacy(pharmacy_id),
  distributor_id INT REFERENCES distributors(distributor_id),
  order_date DATE NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL
);

-- Create table order_item
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  order_id INT REFERENCES pharmacy_order(order_id),
  product_id INT REFERENCES "product"(product_id),
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL
);
