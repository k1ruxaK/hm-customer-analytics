-- Витрина RFM-сегментации
-- Зерно: 1 строка = 1 клиент
-- Период: последние 12 месяцев данных (2019-10-01 .. 2020-09-22)
-- Точка отсчёта Recency: 2020-09-22 (последняя дата в данных)

CREATE TABLE IF NOT EXISTS hm.rfm_mart
ENGINE = MergeTree()
ORDER BY customer_id
AS
WITH

-- Ступень 1: базовые RFM-метрики по каждому клиенту за последний год
rfm_base AS (
    SELECT
        customer_id,
        dateDiff('day', max(t_dat), toDate('2020-09-22')) AS recency,
        count()                                            AS frequency,
        sum(price)                                         AS monetary
    FROM hm.transactions
    WHERE t_dat BETWEEN '2019-10-01' AND '2020-09-22'
    GROUP BY customer_id
),

-- Ступень 2: присваиваем квинтили (оценки 1-5)
rfm_scored AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        ntile(5) OVER (ORDER BY recency DESC)   AS r_score,  -- DESC: недавние → 5
        ntile(5) OVER (ORDER BY frequency ASC)  AS f_score,  -- ASC: частые → 5
        ntile(5) OVER (ORDER BY monetary ASC)   AS m_score   -- ASC: дорогие → 5
    FROM rfm_base
)

-- Ступень 3: присваиваем сегменты на основе R и F (классическая RF-матрица)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CASE
        -- Champions: высокий R и высокий F
        WHEN r_score = 5 AND f_score >= 4 THEN 'Champions'
        WHEN r_score = 4 AND f_score = 5  THEN 'Champions'

        -- Loyal: хороший R и стабильный F
        WHEN r_score >= 3 AND f_score >= 4 THEN 'Loyal'
        WHEN r_score = 4 AND f_score = 3  THEN 'Loyal'
        WHEN r_score = 5 AND f_score = 3  THEN 'Loyal'

        -- Potential Loyalists: недавние но редкие
        WHEN r_score >= 4 AND f_score <= 2 THEN 'Potential Loyalists'
        WHEN r_score = 3 AND f_score <= 2  THEN 'Potential Loyalists'

        -- At Risk: раньше были активны, теперь пропали
        WHEN r_score <= 2 AND f_score >= 4 THEN 'At Risk'
        WHEN r_score = 2 AND f_score = 3  THEN 'At Risk'
        WHEN r_score = 3 AND f_score = 3  THEN 'At Risk'

        -- Lost: давно не было и редко покупали
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'

        -- Всё остальное
        ELSE 'Others'
    END AS segment
FROM rfm_scored;