--  Insert into supplier Table
INSERT INTO supplier (name, email) 
VALUES 
('Acme Pharmaceuticals', 'contact@acmepharma.com'),
('BioMed Instruments', 'sales@biomedinst.com');

-- Insert into item Table
INSERT INTO item (supplier_id, purchase_date, item_name, item_price) 
VALUES 
(1, '2024-07-01', 'Aspirin 500mg', 12.00),
(1, '2024-07-01', 'Paracetamol 500mg', 8.00),
(2, '2024-07-02', 'Digital Thermometer', 25.00),
(2, '2024-07-02', 'Stethoscope', 50.00);

-- Insert into medicine Table
INSERT INTO medicine (item_id, dosage, type, medicine_price, expiry_date) 
VALUES 
(1, '500mg', 'Tablet', 12.00, '2025-12-31'),
(2, '500mg', 'Tablet', 8.00, '2025-12-31');

--  Insert into instruments Table
INSERT INTO instruments (item_id, warranty_period, instrument_price) 
VALUES 
(3, '2 years', 25.00),
(4, '1 year', 50.00);

--  Insert into bill Table
INSERT INTO bill (supplier_id, bill_date, total_amount, payment_status) 
VALUES 
(1, '2024-07-05', 20.00, FALSE),
(2, '2024-07-06', 75.00, FALSE);

--  Insert into bill_item Table
INSERT INTO bill_item (bill_id, item_id, quantity, unit_price) 
VALUES 
(2, 1, 2, 12.00),
(2, 2, 1, 8.00),
(3, 3, 1, 25.00),
(3, 4, 1, 50.00);

-- Insert into payment Table
INSERT INTO payment (bill_id, payment_date, amount) 
VALUES 
(3, '2024-07-07', 20.00),
(2, '2024-07-07', 75.00);

-- Insert into customer Table
INSERT INTO customer (name, email, phone, address)
VALUES
('John Doe', 'john.doe@example.com', '123-456-7890', '123 Elm Street, Springfield'),
('Jane Smith', 'jane.smith@example.com', '987-654-3210', '456 Oak Avenue, Springfield');

-- Insert into sales_invoice Table
INSERT INTO sales_invoice (customer_id, invoice_date, total_amount, payment_status)
VALUES
(1, '2024-07-30', 120.00, FALSE),
(2, '2024-07-31', 75.00, TRUE);

-- Insert into sales_invoice_item Table
INSERT INTO sales_invoice_item (invoice_id, item_id, quantity, unit_price)
VALUES
(1, 1, 5, 12.00), -- 5 units of item_id 1 at $12.00 each
(1, 2, 3, 8.00),  -- 3 units of item_id 2 at $8.00 each
(2, 3, 2, 25.00); -- 2 units of item_id 3 at $25.00 each

-- Insert into transaction Table
INSERT INTO transaction (invoice_id, transaction_date, amount, transaction_type)
VALUES
(1, '2024-07-07', 120.00, 'Payment'), -- Full payment for invoice 1
(2, '2024-07-31', 75.00, 'Payment'),  -- Full payment for invoice 2
(1, '2024-07-10', -10.00, 'Refund');  -- Refund for invoice 1 (partial refund)

-- Update Invoice Payment Status Based on Transactions
UPDATE sales_invoice si
SET payment_status = (
    SELECT CASE
        WHEN COALESCE(SUM(t.amount), 0) >= si.total_amount THEN TRUE
        ELSE FALSE
    END
    FROM transaction t
    WHERE t.invoice_id = si.invoice_id
);

