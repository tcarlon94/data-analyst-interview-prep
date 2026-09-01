-- Interview Practice: Highest-revenue merchant by industry
-- Requirement: If multiple merchants tie for first place, return all of them.

WITH rev_industry AS (
    SELECT
        merchant_id,
        industry,
        revenue,
        RANK() OVER (
            PARTITION BY industry
            ORDER BY revenue DESC
        ) AS industry_rank
    FROM merchant_monthly
    WHERE month = 'July'
)

SELECT
    merchant_id,
    industry,
    revenue
FROM rev_industry
WHERE industry_rank = 1;

/*
Why RANK()?

ROW_NUMBER() would arbitrarily assign a unique position to tied merchants,
which could exclude a merchant that tied for the highest revenue.

RANK() assigns the same rank to tied values, so filtering to rank = 1
returns every merchant tied for the top position in its industry.
*/
