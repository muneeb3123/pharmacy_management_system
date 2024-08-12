-- Create the location table
CREATE TABLE location (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  location_name VARCHAR(255) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NOT NULL,
  postal_code VARCHAR(20) NOT NULL,
  country VARCHAR(100) NOT NULL
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

-- Create the distributor table
CREATE TABLE distributors (
  distributor_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  phone_number VARCHAR(11),
  distributor_email VARCHAR(255),
  distributor_name VARCHAR(255) NOT NULL
);

-- Create table product
CREATE TABLE product (
  product_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  product_name VARCHAR(255) NOT NULL,
  product_price DECIMAL(10,2) NOT NULL,
  product_type VARCHAR(50) NOT NULL CHECK (product_type IN ('medicine', 'instrument'))
);

-- Create table medicine
CREATE TABLE medicine (
  product_id INT PRIMARY KEY REFERENCES product(product_id),
  expiry_date DATE NOT NULL,
  dosage_form VARCHAR(100) NOT NULL,
  strength VARCHAR(100) NOT NULL
);

-- Create table instruments 
CREATE TABLE instruments (
  product_id INT PRIMARY KEY REFERENCES product(product_id),
  modal_number VARCHAR(100) NOT NULL,
  warranty_period DATE NOT NULL
);

-- Create table purchase
CREATE TABLE purchase (
  purchase_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  pharmacy_id INT REFERENCES pharmacy(pharmacy_id),
  distributor_id INT REFERENCES distributors(distributor_id),
  product_id INT REFERENCES product(product_id),
  purchase_date DATE NOT NULL,
  quantity INT NOT NULL,
  purchase_price DECIMAL(10,2) NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  amount_paid DECIMAL(10,2) DEFAULT 0.00,
  payment_status VARCHAR(50) CHECK (payment_status IN ('Pending', 'Paid', 'Partially Paid')) DEFAULT 'Pending',
  UNIQUE (pharmacy_id, distributor_id, product_id, purchase_date)
);

-- Create table pharmacy_products
CREATE TABLE inventory (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  pharmacy_id INT REFERENCES pharmacy(pharmacy_id),
  product_id INT REFERENCES product(product_id),
  stock_quantity INT NOT NULL,
  last_updated DATE NOT NULL,
  UNIQUE (pharmacy_id, product_id)
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

-- Create table customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  location_id INT REFERENCES location(id),
  customer_name VARCHAR(255) NOT NULL,
  customer_email VARCHAR(255) NOT NULL
);

-- Create table sale_invoice
CREATE TABLE sales_invoice (
  invoice_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  sale_id INT REFERENCES sales(sale_id),
  invoice_date DATE NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  amount_paid DECIMAL(10,2) DEFAULT 0.00,
  invoice_status VARCHAR(50) CHECK (invoice_status IN ('Pending', 'Paid')) DEFAULT 'Pending'
);

-- Create table sales
CREATE TABLE sales (
  sale_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  pharmacy_id INT REFERENCES pharmacy(pharmacy_id),
  customer_id INT REFERENCES customers(customer_id),
  product_id INT REFERENCES product(product_id),
  quantity INT NOT NULL,
  sale_type VARCHAR(50) CHECK (sale_type IN ('sale', 'return')) NOT NULL,
  sale_date DATE NOT NULL,
  -- Add a constraint to ensure that the quantity is positive
  CHECK (quantity > 0)
);
