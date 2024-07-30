--  Retrieve All Items with Supplier Details

SELECT 
    i.item_id,
    i.item_name,
    i.purchase_date,
    i.item_price,
    s.name AS supplier_name,
    s.email AS supplier_email
FROM 
    item i
JOIN 
    supplier s ON i.supplier_id = s.id;

-- Get All Medicines with Expiry Date and Supplier Information

SELECT 
    m.item_id,
    i.item_name,
    m.dosage,
    m.type,
    m.medicine_price,
    m.expiry_date,
    s.name AS supplier_name,
    s.email AS supplier_email
FROM 
    medicine m
JOIN 
    item i ON m.item_id = i.item_id
JOIN 
    supplier s ON i.supplier_id = s.id;

-- Find Unpaid Bills with Total Amount and Items

SELECT 
    b.bill_id,
    b.bill_date,
    b.total_amount,
    i.item_name,
    bi.quantity,
    bi.unit_price
FROM 
    bill b
JOIN 
    bill_item bi ON b.bill_id = bi.bill_id
JOIN 
    item i ON bi.item_id = i.item_id
WHERE 
    b.payment_status = FALSE;

-- Total Payments Made and Outstanding Amounts by Supplier

SELECT 
    s.name AS supplier_name,
    SUM(p.amount) AS total_paid,
    COALESCE(b.total_amount - SUM(p.amount), b.total_amount) AS outstanding_amount
FROM 
    supplier s
JOIN 
    bill b ON s.id = b.supplier_id
LEFT JOIN 
    payment p ON b.bill_id = p.bill_id
GROUP BY 
    s.name, b.total_amount;

-- Purchased Items and Their Corresponding Bills

SELECT 
    i.item_name,
    b.bill_id,
    bi.quantity,
    bi.quantity * bi.unit_price
FROM 
    item i
JOIN 
    bill_item bi ON i.item_id = bi.item_id
JOIN 
    bill b ON bi.bill_id = b.bill_id
ORDER BY 
    i.item_name, b.bill_id;

-- Detailed Payment History for a Specific Bill

SELECT 
    p.payment_id,
    p.payment_date,
    p.amount
FROM 
    payment p
WHERE 
    p.bill_id = 3
ORDER BY 
    p.payment_date;

-- Suppliers with the Highest Total Billing Amount

SELECT 
    s.name AS supplier_name,
    SUM(b.total_amount) AS total_billed
FROM 
    supplier s
JOIN 
    bill b ON s.id = b.supplier_id
GROUP BY 
    s.name
ORDER BY 
    total_billed DESC
LIMIT 10;

-- Average Item Price by Category (Medicine/Instrument)

SELECT 
    'Medicine' AS category,
    AVG(m.medicine_price) AS average_price
FROM 
    medicine m
UNION ALL
SELECT 
    'Instrument' AS category,
    AVG(i.instrument_price) AS average_price
FROM 
    instruments i;

-- Retrieve Detailed Sales Invoices
SELECT 
    si.invoice_id,
    c.name AS customer_name,
    si.invoice_date,
    si.total_amount,
    si.payment_status,
    i.item_name,
    sii.quantity,
    sii.unit_price
FROM 
    sales_invoice si
JOIN 
    customer c ON si.customer_id = c.customer_id
JOIN 
    sales_invoice_item sii ON si.invoice_id = sii.invoice_id
JOIN 
    item i ON sii.item_id = i.item_id;

-- Find Unpaid Sales Invoices
SELECT 
    si.invoice_id,
    c.name AS customer_name,
    si.invoice_date,
    si.total_amount
FROM 
    sales_invoice si
JOIN 
    customer c ON si.customer_id = c.customer_id
WHERE 
    si.payment_status = FALSE;

-- Calculate Total Sales for Each Customer
SELECT 
    c.name AS customer_name,
    SUM(si.total_amount) AS total_sales
FROM 
    sales_invoice si
JOIN 
    customer c ON si.customer_id = c.customer_id
GROUP BY 
    c.name;

-- Retrieve Transactions with Invoice Details
SELECT 
    t.transaction_id,
    t.transaction_date,
    t.amount,
    t.transaction_type,
    si.invoice_id,
    c.name AS customer_name,
    si.total_amount
FROM 
    transaction t
JOIN 
    sales_invoice si ON t.invoice_id = si.invoice_id
JOIN 
    customer c ON si.customer_id = c.customer_id
ORDER BY 
    t.transaction_date;

-- Calculate Net Amount for Each Invoice
SELECT 
    si.invoice_id,
    si.total_amount,
    COALESCE(SUM(t.amount), 0) AS total_Paid,
    si.total_amount - COALESCE(SUM(t.amount), 0) AS net_amount
FROM 
    sales_invoice si
LEFT JOIN 
    transaction t ON si.invoice_id = t.invoice_id
GROUP BY 
    si.invoice_id, si.total_amount;

-- Find Unpaid Invoices with Transaction Details
SELECT 
    si.invoice_id,
    si.total_amount,
    COALESCE(SUM(t.amount), 0) AS total_paid,
    si.total_amount - COALESCE(SUM(t.amount), 0) AS outstanding_amount
FROM 
    sales_invoice si
LEFT JOIN 
    transaction t ON si.invoice_id = t.invoice_id AND t.transaction_type = 'Payment'
GROUP BY 
    si.invoice_id, si.total_amount
HAVING 
    si.total_amount > COALESCE(SUM(t.amount), 0);



