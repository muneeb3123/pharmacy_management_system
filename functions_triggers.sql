-- ############################################################################################################

-- Create function to check product_type before insert into medicine or instruments table

CREATE OR REPLACE FUNCTION check_product_type()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the product type already exists in the other table
    IF EXISTS (
        SELECT 1
        FROM product p
        JOIN medicine m ON p.product_id = m.product_id
        WHERE m.product_id = NEW.product_id
    ) THEN
        RAISE EXCEPTION 'Product ID % already exists in medicine table', NEW.product_id;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM product p
        JOIN instruments i ON p.product_id = i.product_id
        WHERE i.product_id = NEW.product_id
    ) THEN
        RAISE EXCEPTION 'Product ID % already exists in instruments table', NEW.product_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for medicine
CREATE TRIGGER check_medicine_type
BEFORE INSERT OR UPDATE ON medicine
FOR EACH ROW
EXECUTE FUNCTION check_product_type();

-- Trigger for instruments
CREATE TRIGGER check_instruments_type
BEFORE INSERT OR UPDATE ON instruments
FOR EACH ROW
EXECUTE FUNCTION check_product_type();

-- ############################################################################################################

-- To handle inventory updates efficiently, we can create a trigger that automatically updates the quantity in the inventory table whenever a new product is purchased or the quantity of an existing product is updated.

CREATE OR REPLACE FUNCTION update_inventory()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the product already exists in the inventory
    IF EXISTS (
        SELECT 1
        FROM inventory
        WHERE pharmacy_id = NEW.pharmacy_id
        AND product_id = NEW.product_id
    ) THEN
        -- Update the quantity of the existing product
        UPDATE inventory
        SET stock_quantity = stock_quantity + NEW.quantity,
            last_updated = CURRENT_DATE
        WHERE pharmacy_id = NEW.pharmacy_id
        AND product_id = NEW.product_id;
    ELSE
        -- Insert a new record for the new product
        INSERT INTO inventory (pharmacy_id, product_id, stock_quantity, last_updated)
        VALUES (NEW.pharmacy_id, NEW.product_id, NEW.quantity, CURRENT_DATE);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger when a new purchase is inserted
CREATE TRIGGER update_inventory_purchase
AFTER INSERT ON purchase
FOR EACH ROW
EXECUTE FUNCTION update_inventory();

-- ############################################################################################################

-- To calculate the total amount of a purchase, we can create a trigger that automatically calculates the total amount whenever a new purchase is inserted or updated.
CREATE OR REPLACE FUNCTION calculate_total_amount()
RETURNS TRIGGER AS $$
BEGIN
    -- Calculate total amount
    NEW.total_amount := NEW.quantity * NEW.purchase_price;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to calculate total amount before insert
CREATE TRIGGER before_insert_purchase
BEFORE INSERT ON purchase
FOR EACH ROW
EXECUTE FUNCTION calculate_total_amount();


-- ############################################################################################################

-- Create function to check inventory before inserting a sale
CREATE OR REPLACE FUNCTION check_inventory_before_sale()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if enough stock is available
    IF NEW.sale_type = 'sale' THEN

    IF (SELECT stock_quantity FROM inventory
        WHERE pharmacy_id = NEW.pharmacy_id
          AND product_id = NEW.product_id) < NEW.quantity THEN
        RAISE EXCEPTION 'Insufficient stock for product ID %', NEW.product_id;
    END IF;
    
      END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to call the function before inserting into sales
CREATE TRIGGER validate_inventory_before_sale
BEFORE INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION check_inventory_before_sale();


-- ############################################################################################################


-- Create function to update inventory after a sale or return
CREATE OR REPLACE FUNCTION update_inventory_after_transaction()
RETURNS TRIGGER AS $$
BEGIN
    -- If the transaction type is 'sale', reduce the stock quantity
    IF NEW.sale_type = 'sale' THEN
        UPDATE inventory
        SET stock_quantity = stock_quantity - NEW.quantity,
            last_updated = CURRENT_DATE
        WHERE pharmacy_id = NEW.pharmacy_id
          AND product_id = NEW.product_id;

    -- If the transaction type is 'return', increase the stock quantity
    ELSIF NEW.sale_type = 'return' THEN
        UPDATE inventory
        SET stock_quantity = stock_quantity + NEW.quantity,
            last_updated = CURRENT_DATE
        WHERE pharmacy_id = NEW.pharmacy_id
          AND product_id = NEW.product_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to call the function after inserting into sales
CREATE TRIGGER update_inventory_after_transaction
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION update_inventory_after_transaction();

-- ############################################################################################################