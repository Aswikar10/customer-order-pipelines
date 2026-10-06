-- Customers from the CRM
INSERT INTO customers (crm_id, full_name, email, city)
SELECT cust_id, full_name, lower(trim(email)), city
FROM stg_crm_customers
ON CONFLICT (email) DO NOTHING;

-- Customers that exist only in the shop
INSERT INTO customers (email)
SELECT DISTINCT lower(trim(customer_email))
FROM stg_shop_orders
ON CONFLICT (email) DO NOTHING;

-- Products
INSERT INTO products (sku, name, unit_price)
SELECT upper(trim(sku)), product_name, unit_price::numeric
FROM stg_shop_products
ON CONFLICT (sku) DO NOTHING;

-- Suppliers
INSERT INTO suppliers (code, name)
SELECT DISTINCT supplier_id, supplier_name
FROM stg_suppliers
ON CONFLICT (code) DO NOTHING;

-- Which supplier sells which product, at what cost
INSERT INTO product_suppliers (product_id, supplier_id, cost_price)
SELECT p.product_id, sp.supplier_id, s.cost_price::numeric
FROM stg_suppliers s
JOIN products  p  ON p.sku   = upper(trim(s.sku))
JOIN suppliers sp ON sp.code = s.supplier_id
ON CONFLICT (product_id, supplier_id) DO NOTHING;

-- Orders (one row per order_id)
INSERT INTO orders (order_id, customer_id, order_date, status)
SELECT DISTINCT s.order_id::int, c.customer_id, s.order_date::date, lower(trim(s.status))
FROM stg_shop_orders s
JOIN customers c ON c.email = lower(trim(s.customer_email))
ON CONFLICT (order_id) DO NOTHING;

-- Order lines
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT s.order_id::int, p.product_id, s.qty::int, s.unit_price::numeric
FROM stg_shop_orders s
JOIN products p ON p.sku = upper(trim(s.sku))
ON CONFLICT (order_id, product_id) DO NOTHING;