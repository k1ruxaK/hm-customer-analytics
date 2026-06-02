INSERT INTO hm.articles
FROM INFILE '/data/articles.csv'
FORMAT CSVWithNames;

INSERT INTO hm.customers
FROM INFILE '/data/customers.csv'
FORMAT CSVWithNames;

INSERT INTO hm.transactions
FROM INFILE '/data/transactions_train.csv'
FORMAT CSVWithNames;