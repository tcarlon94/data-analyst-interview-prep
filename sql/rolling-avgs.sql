/*
Problem:
Show each day, its revenue, and the seven-day rolling
average revenue.

Grain:
- daily_sales: one row per day

Important:
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW averages seven rows.
If calendar dates can be missing, use a date spine first.
*/

SELECT
    sale_date,
    revenue AS daily_revenue,
    AVG(revenue) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS seven_day_rolling_average
FROM daily_sales
ORDER BY sale_date;