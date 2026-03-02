# Influenza Outbreak Prediction via Twitter Keywords

> Statistical analysis and predictive modeling of flu outbreak patterns  
> using Twitter keyword frequency data — R, PCA, Linear Regression.

[![R](https://img.shields.io/badge/R-4.x-blue)](https://www.r-project.org/)
[![Dataset](https://img.shields.io/badge/Data-UCI%20ML%20Repository-orange)](https://archive.ics.uci.edu/dataset/861/influenza+outbreak+event+prediction+via+twitter)

---

## Overview

This project investigates whether **Twitter keyword frequencies** can be used
to detect and predict influenza outbreak patterns across 48 U.S. regions.

The analysis pipeline moves from exploratory data understanding through
dimensionality reduction to predictive modeling, with explicit hypothesis
testing at each stage.

**Research Questions:**
1. Which keywords are more frequently associated with regions experiencing flu outbreaks?
2. Can keyword frequency data be used to build a model to predict outbreak duration?

---

## Dataset

**Source:** [UCI ML Repository — Influenza Outbreak Event Prediction via Twitter](https://archive.ics.uci.edu/dataset/861/influenza+outbreak+event+prediction+via+twitter)

| Attribute | Value |
|---|---|
| Regions | 48 U.S. states |
| Time span | 1,095 days (~3 years) |
| Features | 545 flu-related keywords |
| Target | Number of outbreak days per region |
| Format | MATLAB `.mat` → preprocessed to CSV via Python |

**Preprocessing:** Raw `.mat` file parsed with `scipy.io.loadmat`;
keyword frequency matrix merged with outbreak labels into structured CSV
(48 rows × 546 columns).

---

## Methodology

```
[Raw .mat file] ──► [Python ETL] ──► [Structured CSV]
                                            │
                              ┌─────────────┼─────────────┐
                              ▼             ▼             ▼
                       Correlation       PCA          Linear
                        Analysis    (545 → 5 PCs)   Regression
                     (keyword EDA)  (96.35% var)   (hypothesis test)
```

### Step 1 — Correlation Analysis
Identified keywords most linearly associated with outbreak frequency.
Top signals: "dying", "diagnosed", "infections", "family".

### Step 2 — PCA (Dimensionality Reduction)
Reduced 545 keyword features to 5 principal components:

| Component | Variance Explained | Cumulative |
|---|---|---|
| PC1 | 90.36% | 90.36% |
| PC2 | 2.67% | 93.03% |
| PC3 | 1.39% | 94.43% |
| PC4 | 1.30% | 95.73% |
| PC5 | 0.62% | **96.35%** |

### Step 3 — Linear Regression + Hypothesis Testing

**H₀:** All coefficients β₁–β₅ = 0 (no predictive power)  
**Hₐ:** At least one βᵢ ≠ 0

Results:
- Overall model p-value = 0.1283 > 0.05 → **cannot reject H₀**
- R² = 17.87% (model explains ~18% of outbreak variance)
- **PC2 is significant** (p = 0.025), positively associated with outbreak duration

---

## Key Findings

The model has **partial but limited predictive power**:

- PC2 captures a keyword cluster meaningfully associated with outbreak intensity
- Overall model is not statistically significant, suggesting keyword frequency
  alone is insufficient for reliable prediction
- Maximum residual error reaches 161 days — high variance in predictions

**Identified limitations:**
- **Sampling bias**: Twitter users are not evenly distributed across regions
- **Semantic bias**: Keywords like "dying" appear in non-medical contexts (irony, sports)
- **Feature sparsity**: Many regions have zero counts for most keywords

**Suggested improvements:**
- Add demographic/geographic control variables
- Incorporate temporal features (seasonality, week-of-year)
- Pre-filter keywords using medical ontologies to reduce semantic noise

---

## How to Run

```r
# Install required packages
install.packages(c("ggplot2", "corrplot", "R.matlab", "data.table"))

# Run analysis
source("analysis.R")
```

**Prerequisites:** Download dataset from UCI ML Repository link above.
Place `influenza_outbreak_dataset.mat` in the project root directory.

---

## Tech Stack

| Layer | Tools |
|---|---|
| Data Parsing | Python (`scipy.io`, `pandas`) |
| Statistical Analysis | R (`base`, `stats`) |
| Dimensionality Reduction | R `prcomp()` — PCA |
| Predictive Modeling | R `lm()` — Linear Regression |
| Visualisation | R `ggplot2`, `corrplot` |
| Hypothesis Testing | F-statistic, p-values, R² |

---

## Academic Context

Final project for **NEU INFO6105 (Data Science Engineering)**.  
Demonstrates applied statistical workflow: EDA → feature compression →
predictive modeling → honest interpretation of negative/partial results.

---

## Author

**Yingying Zhuang**  
MS Information Systems, Northeastern University  
[LinkedIn](https://linkedin.com/in/zhuangyingying) · [GitHub](https://github.com/YingyingZhuang)
