SELECT 'order lines' AS check_name,
       (SELECT count(*) FROM stg_shop_orders) AS source,
       (SELECT count(*) FROM order_items)     AS loaded,
       CASE WHEN (SELECT count(*) FROM stg_shop_orders) = (SELECT count(*) FROM order_items)
            THEN 'PASS' ELSE 'FAIL' END AS result
UNION ALL
SELECT 'product-supplier links',
       (SELECT count(*) FROM stg_suppliers),
       (SELECT count(*) FROM product_suppliers),
       CASE WHEN (SELECT count(*) FROM stg_suppliers) = (SELECT count(*) FROM product_suppliers)
            THEN 'PASS' ELSE 'FAIL' END
UNION ALL
SELECT 'unique customers',
       (SELECT count(*) FROM (SELECT lower(trim(email)) FROM stg_crm_customers
                              UNION
                              SELECT lower(trim(customer_email)) FROM stg_shop_orders) x),
       (SELECT count(*) FROM customers),
       CASE WHEN (SELECT count(*) FROM (SELECT lower(trim(email)) FROM stg_crm_customers
                                        UNION
                                        SELECT lower(trim(customer_email)) FROM stg_shop_orders) x)
                 = (SELECT count(*) FROM customers)
            THEN 'PASS' ELSE 'FAIL' END
UNION ALL
SELECT 'total revenue',
       (SELECT sum(qty::int * unit_price::numeric) FROM stg_shop_orders)::bigint,
       (SELECT sum(quantity * unit_price) FROM order_items)::bigint,
       CASE WHEN (SELECT sum(qty::int * unit_price::numeric) FROM stg_shop_orders)
                 = (SELECT sum(quantity * unit_price) FROM order_items)
            THEN 'PASS' ELSE 'FAIL' END;