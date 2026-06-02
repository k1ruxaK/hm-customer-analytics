# Dataset Setup

Download the H&M dataset from Kaggle:
https://www.kaggle.com/competitions/h-and-m-personalized-fashion-recommendations/data

## Required files

| File | Size | Rows |
|---|---|---|
| `transactions_train.csv` | ~3.4 GB | ~31M |
| `customers.csv` | ~200 MB | ~1.37M |
| `articles.csv` | ~35 MB | ~105K |

Images (`images/`) and `sample_submission.csv` are **not needed**.

## Steps

1. Log in to Kaggle and accept the competition rules.
2. Install the Kaggle CLI:
   ```bash
   pip install kaggle
   ```
3. Place your `kaggle.json` API token in `~/.kaggle/kaggle.json` (Linux/Mac) or `%USERPROFILE%\.kaggle\kaggle.json` (Windows).
4. Download the required files into this `data/` directory:
   ```bash
   kaggle competitions download -c h-and-m-personalized-fashion-recommendations -f transactions_train.csv -p data/
   kaggle competitions download -c h-and-m-personalized-fashion-recommendations -f customers.csv -p data/
   kaggle competitions download -c h-and-m-personalized-fashion-recommendations -f articles.csv -p data/
   ```
5. Unzip if needed:
   ```bash
   unzip data/transactions_train.csv.zip -d data/
   unzip data/customers.csv.zip -d data/
   unzip data/articles.csv.zip -d data/
   ```

The files are listed in `.gitignore` and will not be committed to the repository.
