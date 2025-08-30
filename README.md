# Gold Price Time Series Analysis (RBI)

A clean, reproducible **R** workflow to analyze **annual gold prices in India** (RBI data), assess **autocorrelation**, and compare **AR vs MA** components via **ARIMA** using **AIC/BIC**. Includes diagnostics (ADF, DW, Box test) and **10-step forecasting** on the differenced series.

> **Data Source:** Reserve Bank of India — [https://data.rbi.org.in/](https://data.rbi.org.in/)

## 📁 Project Structure

```
.
├── analysis.Rmd                  # Main R Markdown
├── data/                         # Place your CSV here (Year, GoldPrice)
│   └── Average Price of Gold in India 1971-2024.csv
├── outputs
└── README.md
```

## 📦 Requirements

* R (>= 4.2 recommended)
* Packages: `tidyverse`, `forecast`, `tseries`, `lmtest`, `knitr`

Install in R:

```r
install.packages(c('tidyverse','forecast','tseries','lmtest','knitr'), dependencies = TRUE)
```

## ▶️ How to Run

1. **Put your CSV** in `data/` with columns `Year, GoldPrice` (₹ per kg).
2. **Open `analysis.Rmd`** in RStudio (or VS Code + R plugins).
3. **Edit the `file_path`** in the first chunk to point to your CSV (e.g., `data/Average Price of Gold in India 1971-2024.csv`).
4. Click **Knit** → produce **HTML** (and optionally PDF).
5. Outputs (AIC/BIC table, coefficients list) are saved to `outputs/`.

## 🧪 What the Notebook Does

* Loads RBI annual gold price data and creates a **ts** object (annual frequency).
* Explores **trend**, **ACF**, **PACF**; runs **Durbin–Watson** on a linear-trend proxy.
* **Differences** the series, re-checks ACF/PACF, runs DW on differenced series.
* Sweeps **AR lags 1–5** (ARIMA(p,0,0)) vs **MA lags 1–5** (ARIMA(0,0,q)) on the differenced series and compares **AIC/BIC**.
* Extracts **coefficients** for each model.
* Fits `auto.arima()` and performs **residual diagnostics** (ACF/PACF of residuals, **ADF**, **Box test**).
* Produces **10-step forecasts** for the differenced series and plots them with **prediction intervals**.

## 🧩 Interpreting Typical Results (from sample run)

> Your sample outputs indicated:

* Strong positive autocorrelation in levels (very low DW, p < 2.2e-16).
* After differencing, autocorrelation is reduced (DW ≈ 1.47, p ≈ 0.017).
* **MA(4)** provided the **lowest AIC/BIC** among AR/MA sweeps (lags 1–5) on the differenced series.
* `auto.arima()` selected **ARIMA(0,1,0)** on levels (equivalent to white-noise differences), yielding widening forecast bands.

> Always re-validate with your exact CSV; results can shift as RBI updates or if the sample window changes.

## 🧯 Troubleshooting

* **CSV not found**: Check `file_path` in the Rmd.
* **Column names differ**: The Rmd normalizes to `Year, GoldPrice`. Adjust if needed.
* **ADF p-value high after differencing**: Consider alternate specs (e.g., seasonal differencing if relevant, variance-stabilising transforms) or extend model order.
* **Level forecasts**: Fit `Arima(gold_ts, order=c(p,1,q))` and forecast on levels; or integrate differenced forecasts by cumulative sum + last observed level.

## 📜 Citation
Reserve Bank of India (RBI) DataBase


