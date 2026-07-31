/*
Examples of the primary window-function patterns covered
throughout the lessons.
*/


-- Exactly one highest-revenue customer per state.
WITH ranked_customers AS (
    SELECT
        state,
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY state
            ORDER BY total_revenue DESC
        ) AS row_number_rank
    FROM customer_revenue
)

SELECT *
FROM ranked_customers
WHERE row_number_rank = 1;


-- Rank ties equally and skip the next rank.
SELECT
    salesperson_id,
    sales,
    RANK() OVER (
        ORDER BY sales DESC
    ) AS sales_rank
FROM salesperson_sales;


-- Rank ties equally without skipping the next rank.
SELECT
    salesperson_id,
    sales,
    DENSE_RANK() OVER (
        ORDER BY sales DESC
    ) AS dense_sales_rank
FROM salesperson_sales;


-- Previous month's revenue.
SELECT
    revenue_month,
    revenue,
    LAG(revenue) OVER (
        ORDER BY revenue_month
    ) AS previous_month_revenue
FROM monthly_revenue;


-- Next order for each customer.
SELECT
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date, order_id
    ) AS next_order_date
FROM orders;


-- Running total.
SELECT
    sale_date,
    revenue,
    SUM(revenue) OVER (
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM daily_sales;


-- Thirty-row rolling average.
SELECT
    sale_date,
    revenue,
    AVG(revenue) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS thirty_day_rolling_average
FROM daily_sales;