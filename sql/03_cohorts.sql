CREATE TABLE IF NOT EXISTS hm.cohorts_mart
ENGINE = MergeTree()
ORDER BY (cohort_month, month_offset)
AS
WITH

--  когорта каждого клиента
customer_cohorts AS (
    SELECT
        customer_id,
        toStartOfMonth(min(t_dat)) AS cohort_month
    FROM hm.transactions
    WHERE t_dat >= '2018-10-01'   -- отрезаем неполный сентябрь 2018
    GROUP BY customer_id
),

-- размер каждой когорты (знаменатель для retention rate)
cohort_sizes AS (
    SELECT
        cohort_month,
        count() AS cohort_size
    FROM customer_cohorts
    GROUP BY cohort_month
),

-- для каждой транзакции считаем offset
transaction_offsets AS (
    SELECT
        cc.cohort_month,
        dateDiff('month', cc.cohort_month, toStartOfMonth(t.t_dat)) AS month_offset,
        t.customer_id
    FROM hm.transactions t
    INNER JOIN customer_cohorts cc ON t.customer_id = cc.customer_id
    WHERE t.t_dat >= '2018-10-01'
)

--  агрегация
SELECT
    to.cohort_month,
    to.month_offset,
    cs.cohort_size,
    uniq(to.customer_id)                                    AS retained_customers,
    round(uniq(to.customer_id) * 100.0 / cs.cohort_size, 2) AS retention_rate
FROM transaction_offsets to
INNER JOIN cohort_sizes cs ON to.cohort_month = cs.cohort_month
GROUP BY to.cohort_month, to.month_offset, cs.cohort_size
ORDER BY to.cohort_month, to.month_offset;