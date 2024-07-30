-- Create the supplier table
CREATE TABLE supplier (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL
);

-- Create the item table
CREATE TABLE item (
  item_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  supplier_id INT,
  purchase_date DATE,
  item_name VARCHAR(255),
  item_price DECIMAL(10, 2),
  FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

-- Create the medicine table
CREATE TABLE medicine (
  item_id INT PRIMARY KEY,
  dosage VARCHAR(50),
  type VARCHAR(50),
  medicine_price DECIMAL(10, 2),
  expiry_date DATE,
  FOREIGN KEY (item_id) REFERENCES item(item_id)
);

-- Create the instruments table
CREATE TABLE instruments (
  item_id INT PRIMARY KEY,
  warranty_period VARCHAR(50),
  instrument_price DECIMAL(10, 2),
  FOREIGN KEY (item_id) REFERENCES item(item_id)
);

-- Create the bill table
CREATE TABLE bill (
  bill_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  supplier_id INT,
  bill_date DATE,
  total_amount DECIMAL(10, 2),
  payment_status BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

-- Create the bill_item table to link items to bills
CREATE TABLE bill_item (
  bill_id INT,
  item_id INT,
  quantity INT,
  unit_price DECIMAL(10, 2),
  PRIMARY KEY (bill_id, item_id),
  FOREIGN KEY (bill_id) REFERENCES bill(bill_id),
  FOREIGN KEY (item_id) REFERENCES item(item_id)
);

-- Create the payment table
CREATE TABLE payment (
  payment_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  bill_id INT,
  payment_date DATE,
  amount DECIMAL(10, 2),
  FOREIGN KEY (bill_id) REFERENCES bill(bill_id)
);

-- Create the customer table
CREATE TABLE customer (
  customer_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  phone VARCHAR(20),
  address TEXT
);

-- Create the sales_invoice table
CREATE TABLE sales_invoice (
  invoice_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  customer_id INT,
  invoice_date DATE,
  total_amount DECIMAL(10, 2),
  payment_status BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- CREATE THE sales_invoice_item table to link items to invoices
CREATE TABLE sales_invoice_item (
  invoice_id INT,
  item_id INT,
  quantity INT,
  unit_price DECIMAL(10, 2),
  PRIMARY KEY (invoice_id, item_id),
  FOREIGN KEY (invoice_id) REFERENCES sales_invoice(invoice_id),
  FOREIGN KEY (item_id) REFERENCES item(item_id)
);

-- create transaction table
CREATE TABLE transaction (
  transaction_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  invoice_id INT,
  transaction_date DATE,
  amount DECIMAL(10, 2),
  transaction_type VARCHAR(50),
  FOREIGN KEY (invoice_id) REFERENCES sales_invoice(invoice_id)
);
