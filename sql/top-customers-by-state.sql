/*
Problem:
For every state, show the top 3 customers by total revenue
over the past 12 months.

Ties should share the same ranking, and the next ranking
should not be skipped.

Grain:
- customers: one row per customer
- orders: one row per order

Approach:
1. Filter orders to the past 12 months.
2. Aggregate revenue to one row per customer.
3. Join customer attributes.
4. Rank customers within each state using DENSE_RANK().
5. Keep the top three ranks.
*/

WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue
    FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '12 months'
    GROUP BY customer_id
),

customer_rankings AS (
    SELECT
        c.state,
        c.customer_name,
        cr.total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY c.state
            ORDER BY cr.total_revenue DESC
        ) AS revenue_rank
    FROM customer_revenue AS cr
    INNER JOIN customers AS c
        ON cr.customer_id = c.customer_id
)

SELECT
    state,
    customer_name,
    total_revenue,
    revenue_rank
FROM customer_rankings
WHERE revenue_rank <= 3
ORDER BY
    state,
    revenue_rank,
    customer_name;