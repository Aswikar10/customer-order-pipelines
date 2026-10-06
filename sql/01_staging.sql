DROP TABLE IF EXISTS stg_crm_customers;
DROP TABLE IF EXISTS stg_shop_products;
DROP TABLE IF EXISTS stg_suppliers;
DROP TABLE IF EXISTS stg_shop_orders;

CREATE TABLE stg_crm_customers (cust_id text, full_name text, email text, city text);
CREATE TABLE stg_shop_products (sku text, product_name text, unit_price text);
CREATE TABLE stg_suppliers     (supplier_id text, supplier_name text, sku text, cost_price text);
CREATE TABLE stg_shop_orders   (order_id text, customer_email text, order_date text,
                                sku text, qty text, unit_price text, status text);

COPY stg_crm_customers FROM '/project/data/crm_customers.csv' CSV HEADER;
COPY stg_shop_products FROM '/project/data/shop_products.csv' CSV HEADER;
COPY stg_suppliers     FROM '/project/data/suppliers.csv'     CSV HEADER;
COPY stg_shop_orders   FROM '/project/data/shop_orders.csv'   CSV HEADER;