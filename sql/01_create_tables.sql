DROP TABLE IF EXISTS hm.transactions;
DROP TABLE IF EXISTS hm.customers;
DROP TABLE IF EXISTS hm.articles;

-- таблица транзакций
CREATE TABLE hm.transactions
(
    t_dat             Date,
    customer_id       FixedString(64),
    article_id        UInt32,
    price             Float32,
    sales_channel_id  UInt8
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(t_dat)
ORDER BY (customer_id, t_dat)
SETTINGS index_granularity = 8192;

-- таблица клиентов
CREATE TABLE hm.customers
(
    customer_id             FixedString(64),
    FN                      Nullable(Float32),
    Active                  Nullable(Float32),
    club_member_status      LowCardinality(String),
    fashion_news_frequency  LowCardinality(String),
    age                     Nullable(UInt8),
    postal_code             FixedString(64)
)
ENGINE = MergeTree()
ORDER BY customer_id;


-- таблица товаров
CREATE TABLE hm.articles
(
    article_id                    UInt32,
    product_code                  UInt32,
    prod_name                     String,
    product_type_no               Int32,
    product_type_name             LowCardinality(String),
    product_group_name            LowCardinality(String),
    graphical_appearance_no       Int32,
    graphical_appearance_name     LowCardinality(String),
    colour_group_code             Int32,
    colour_group_name             LowCardinality(String),
    perceived_colour_value_id     Int32,
    perceived_colour_value_name   LowCardinality(String),
    perceived_colour_master_id    Int32,
    perceived_colour_master_name  LowCardinality(String),
    department_no                 Int32,
    department_name               LowCardinality(String),
    index_code                    LowCardinality(String),
    index_name                    LowCardinality(String),
    index_group_no                Int32,
    index_group_name              LowCardinality(String),
    section_no                    Int32,
    section_name                  LowCardinality(String),
    garment_group_no              Int32,
    garment_group_name            LowCardinality(String),
    detail_desc                   String
)
ENGINE = MergeTree()
ORDER BY article_id;
