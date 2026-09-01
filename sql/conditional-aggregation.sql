-- Conditional aggregation practice
-- Summarize approved and declined orders by merchant while preserving
-- one output row per merchant.

SELECT
    merchant_id,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN status = 'approved' THEN order_id
    END) AS approved_orders,
    COUNT(DISTINCT CASE
        WHEN status = 'declined' THEN order_id
    END) AS declined_orders,
    SUM(CASE
        WHEN status = 'approved' THEN revenue
        ELSE 0
    END) AS approved_revenue
FROM orders
GROUP BY merchant_id
ORDER BY approved_revenue DESC;

-- Interview checks:
-- 1. Confirm the source table grain before aggregating.
-- 2. If the table contains multiple rows per order, determine whether
--    revenue is order-level or row-level before summing it.
-- 3. COUNT(DISTINCT order_id) protects order counts from duplicate rows,
--    but it does not automatically protect SUM(revenue) from duplication.
