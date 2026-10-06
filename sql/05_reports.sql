-- Report 1: revenue per city
SELECT coalesce(c.city, 'Unknown') AS city,
       count(DISTINCT o.order_id)  AS orders,
       sum(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id   = o.order_id
GROUP BY coalesce(c.city, 'Unknown')
ORDER BY revenue DESC;

-- Report 2: profit per product (uses list price minus supplier cost)
SELECT p.name AS product,
       s.name AS supplier,
       p.unit_price,
       ps.cost_price,
       p.unit_price - ps.cost_price AS profit_per_unit,
       coalesce(sum(oi.quantity), 0) AS units_sold,
       coalesce(sum(oi.quantity), 0) * (p.unit_price - ps.cost_price) AS total_profit
FROM products p
JOIN product_suppliers ps ON ps.product_id = p.product_id
JOIN suppliers s          ON s.supplier_id = ps.supplier_id
LEFT JOIN order_items oi  ON oi.product_id = p.product_id
GROUP BY p.name, s.name, p.unit_price, ps.cost_price
ORDER BY total_profit DESC;

-- Report 3: top customers (LEFT JOIN keeps customers with no orders)
SELECT coalesce(c.full_name, c.email) AS customer,
       count(DISTINCT o.order_id) AS orders,
       coalesce(sum(oi.quantity * oi.unit_price), 0) AS total_spent
FROM customers c
LEFT JOIN orders o       ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON oi.order_id   = o.order_id
GROUP BY c.customer_id, c.full_name, c.email
ORDER BY total_spent DESC;