-- Top merchants by industry
-- Return the highest-revenue merchant(s) in each industry for July.
-- If merchants tie for first place, return every tied merchant.

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
WHERE industry_rank = 1
ORDER BY industry, merchant_id;

-- Why RANK()?
-- ROW_NUMBER() would arbitrarily return only one merchant when revenue ties.
-- RANK() assigns tied merchants the same rank, allowing all first-place
-- merchants to be returned.
