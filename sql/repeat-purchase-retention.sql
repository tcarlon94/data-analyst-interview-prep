/*
Problem:
For each acquisition channel, calculate the percentage of
customers who made a second purchase within 90 days of their
first purchase.

Assumption:
The denominator includes customers who placed at least one order.

Grain:
- customers: one row per customer
- orders: one row per order

Approach:
1. Order each customer's purchases chronologically.
2. Use LEAD() to find the next purchase date.
3. Keep the customer's first order.
4. Flag whether the second purchase occurred within 90 days.
5. Aggregate by acquisition channel.
*/

WITH ordered_purchases AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS order_number,
        LEAD(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS next_order_date
    FROM orders
),

customer_retention AS (
    SELECT
        customer_id,
        CASE
            WHEN next_order_date <= order_date + INTERVAL '90 days'
                THEN 1
            ELSE 0
        END AS returned_within_90_days
    FROM ordered_purchases
    WHERE order_number = 1
)

SELECT
    c.acquisition_channel,
    COUNT(*) AS customers,
    SUM(cr.returned_within_90_days) AS returned_within_90_days,
    100.0 * SUM(cr.returned_within_90_days) / NULLIF(COUNT(*), 0)
        AS retention_rate
FROM customer_retention AS cr
INNER JOIN customers AS c
    ON cr.customer_id = c.customer_id
GROUP BY c.acquisition_channel
ORDER BY retention_rate DESC;