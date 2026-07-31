/*
Original query:

SELECT *
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE YEAR(order_date) = 2025;

Potential issues:
1. SELECT * returns unnecessary columns.
2. Applying YEAR() to order_date can prevent efficient index
   usage or partition pruning.
3. The query may return millions of detailed order rows.
4. The required business output is unclear.
*/

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.revenue
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE o.order_date >= DATE '2025-01-01'
  AND o.order_date < DATE '2026-01-01';

  /*
Use this version only when the business needs customer-level
revenue rather than individual order records.
*/

WITH customer_revenue_2025 AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count,
        SUM(revenue) AS total_revenue
    FROM orders
    WHERE order_date >= DATE '2025-01-01'
      AND order_date < DATE '2026-01-01'
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.customer_name,
    cr.order_count,
    cr.total_revenue
FROM customer_revenue_2025 AS cr
INNER JOIN customers AS c
    ON cr.customer_id = c.customer_id
ORDER BY cr.total_revenue DESC;