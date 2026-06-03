
CREATE TABLE IF NOT EXISTS hm.channels_mart
ENGINE = MergeTree()
ORDER BY customer_id
AS
SELECT
    customer_id,

    -- Метрики поведения
    count()                                  AS total_transactions,
    uniq(article_id)                         AS unique_articles,
    sum(price)                               AS total_spent,
    round(avg(price), 4)                     AS avg_price,
    dateDiff('day', min(t_dat), max(t_dat))  AS customer_lifespan_days,

    -- Разбивка по каналам
    countIf(sales_channel_id = 1)            AS offline_transactions,
    countIf(sales_channel_id = 2)            AS online_transactions,

    -- Определение типа клиента
    multiIf(
        uniq(sales_channel_id) = 2, 'omnichannel',
        min(sales_channel_id) = 1,  'offline-only',
                                    'online-only'
    ) AS channel_type
FROM hm.transactions
GROUP BY customer_id;