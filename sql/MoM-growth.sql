/*
Problem:
Calculate month-over-month revenue growth.

Approach:
1. Aggregate revenue by month.
2. Use LAG() to retrieve the previous month's revenue.
3. Calculate absolute and percentage change.
*/

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS revenue_month,
        SUM(revenue) AS revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),

revenue_comparison AS (
    SELECT
        revenue_month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY revenue_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    revenue_month,
    revenue,
    previous_month_revenue,
    revenue - previous_month_revenue AS revenue_change,
    100.0 * (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0) AS revenue_growth_percentage
FROM revenue_comparison
ORDER BY revenue_month;